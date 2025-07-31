import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../_config/url_provider.dart';
import '../../_models/sync_model.dart';
import '../base_repository/abstract_repositories.dart';
import '../base_repository/base_repositories.dart';
import '../local_repository/local_repositories.dart';

typedef FromJson<T> = T Function(Map<String, dynamic> json);
typedef ToJson<T> = Map<String, dynamic> Function(T model);
typedef GetId<T> = String Function(T model);

class RemoteRepository<T> extends BaseRepository
    implements AbstractRepository<T> {
  // Optional path builders
  final String Function(dynamic id)? getItemPath;
  final String Function(dynamic id)? deletePath;
  final String Function()? savePath;
  final String Function()? getAllByUser;

  final LocalRepository<T> _localRepository;
  final SyncField<T>? syncField;
  final String endpoint;
  final FromJson<T> fromJson;
  final ToJson<T> toJson;
  final GetId<T> getId;

  RemoteRepository({
    required LocalRepository<T> localRepository,
    this.getItemPath,
    this.deletePath,
    this.savePath,
    this.syncField,
    this.getAllByUser,
    required this.endpoint,
    required this.fromJson,
    required this.toJson,
    required this.getId,
  }) : _localRepository = localRepository;

  @override
  Future<T?> getItemById(id) async {
    final path = getItemPath?.call(id) ?? endpoint;
    final result = handleCacheOperation(
      () => _localRepository.getItemById(id),
      () async {
        final response = await handleApiCall(
          () => apiClient.get(
            URLProviderConfig().addPathSegments(path, [id.toString()]),
          ),
        );
        if (response.data == null) return null;
        final item = fromJson(Map<String, dynamic>.from(response.data));
        await _localRepository.saveItem(item);
        return item;
      },
    );

    return result;
  }

  @override
  Future<List<T>> getAllItems({
    int page = 1,
    int limit = 10,
    bool paginate = false,
    bool includeDeleted = false,
    String? searchTerm,
    Map<String, dynamic>? extraParams,
  }) async {
    final queryParams = {
      'page': page,
      'limit': limit,
      'paginate': paginate,
      'includeDeleted': includeDeleted,
      if (searchTerm != null) 'searchTerm': searchTerm,
      ...?extraParams,
    };
    final result = await handleCacheOperation(
      () => _localRepository.getAllItems(),
      () async {
        final response = await handleApiCall(
          () => apiClient.get(endpoint,
              requiresAuth: true, queryParameters: queryParams),
        );
        final data = response.data as List;
        final items =
            data.map((e) => fromJson(Map<String, dynamic>.from(e))).toList();
        await _localRepository.saveAllItems(items);
        return items;
      },
    );

    return result ?? [];
  }

  @override
  Future<void> saveItem(item) async {
    await handleApiCall(() async {
      await apiClient.post(endpoint, data: toJson(item));
      await handleDatabaseOperation(() => _localRepository.saveItem(item));
    });
  }

  @override
  Future<void> saveAllItems(List items) async {
    await handleDatabaseOperation(() => _localRepository.saveAllItems(items));
  }

  @override
  Future<void> deleteItemById(id) async {
    final path = deletePath?.call(id) ?? endpoint;
    await handleApiCall(() async {
      await apiClient.delete(
        URLProviderConfig().addPathSegments(path, [id.toString()]),
      );
      await handleDatabaseOperation(() => _localRepository.deleteItemById(id));
    });
  }

  @override
  Future<void> syncItems() async {
    if (syncField == null) return;

    await handleSyncOperation(
      () async {
        final relativePath = getAllByUser?.call();

        final fullPath =
            '${endpoint.trim().replaceAll(RegExp(r'/+$'), '')}/${relativePath?.trim().replaceAll(RegExp(r'^/+'), '')}';

        final prefs = await SharedPreferences.getInstance();

        final lastSyncStr = prefs.getString('${endpoint}_lastSyncTime');
        final currentUserId = prefs.getString('currentUserId');
        final lastSyncTime =
            lastSyncStr != null ? DateTime.parse(lastSyncStr) : DateTime(2000);

        final data = {
          'userId': currentUserId,
          'lastSynced': lastSyncTime.toUtc().toIso8601String()
        };

        final response = await handleApiCall(() {
          return apiClient.post(
            fullPath,
            data: data,
            requiresAuth: true,
          );
        });

        final responseData = response.data as Map<String, dynamic>;
        final List<dynamic> rawList = responseData['documents'] ?? [];

        final updatedItems =
            rawList.map((e) => fromJson(Map<String, dynamic>.from(e))).toList();

        DateTime? latestUpdatedAt;

        for (final item in updatedItems) {
          try {
            final itemId = getId(item);
            final itemUpdatedAt = syncField!.accessor(item);

            if (itemUpdatedAt == null) continue;

            if (latestUpdatedAt == null ||
                itemUpdatedAt.isAfter(latestUpdatedAt)) {
              latestUpdatedAt = itemUpdatedAt;
            }

            final existingItem = await getItemById(itemId);
            bool shouldSave = false;

            if (existingItem == null) {
              shouldSave = true;
            } else {
              final existingUpdatedAt = syncField!.accessor(existingItem);
              if (existingUpdatedAt == null ||
                  itemUpdatedAt.isAfter(existingUpdatedAt)) {
                shouldSave = true;
              }
            }

            if (shouldSave) {
              await _localRepository.saveItem(item);
            }
          } catch (e) {
            debugPrint('Failed to sync item ${getId(item)}: $e');
          }
        }

        // Update sync timestamp
        if (latestUpdatedAt != null) {
          await prefs.setString(
              '${endpoint}_lastSyncTime', latestUpdatedAt.toIso8601String());
        } else if (updatedItems.isNotEmpty) {
          await prefs.setString(
              '${endpoint}_lastSyncTime', DateTime.now().toIso8601String());
        }
      },
      onConflict: () async {
        final response = await handleApiCall(() => apiClient.get(endpoint));
        final responseData = response.data as Map<String, dynamic>;
        final List<dynamic> rawList = responseData['documents'] ?? [];

        final items =
            rawList.map((e) => fromJson(Map<String, dynamic>.from(e))).toList();
        DateTime? latestUpdatedAt;

        for (final item in items) {
          try {
            await _localRepository.saveItem(item);

            final itemUpdatedAt = syncField!.accessor(item);
            if (itemUpdatedAt != null) {
              if (latestUpdatedAt == null ||
                  itemUpdatedAt.isAfter(latestUpdatedAt)) {
                latestUpdatedAt = itemUpdatedAt;
              }
            }
          } catch (e) {
            debugPrint('Failed to save item during conflict resolution: $e');
          }
        }

        final prefs = await SharedPreferences.getInstance();
        final syncTime = latestUpdatedAt?.toIso8601String() ??
            DateTime.now().toIso8601String();
        await prefs.setString('${endpoint}_lastSyncTime', syncTime);
      },
      onComplete: () => Future.value(),
    );
  }

  @override
  Future<List<T>> search(String keyword, List<String> fields) async {
    await getAllItems(); // sync to api
    return _localRepository.search(keyword, fields);
  }

  @override
  Future<int> count() {
    return _localRepository.count();
  }

  @override
  Future<void> dispose() async {
    await _localRepository.dispose();
    await super.dispose();
  }
}
