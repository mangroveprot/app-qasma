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
          () => apiClient.get(endpoint, queryParameters: queryParams),
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
        final lastSyncedItem = await _getLastSyncedItem();
        final lastSyncTime =
            lastSyncedItem != null ? syncField!.accessor(lastSyncedItem) : null;

        final queryParams =
            lastSyncTime != null
                ? {syncField!.name: lastSyncTime.toIso8601String()}
                : null;

        final response = await handleApiCall(
          () => apiClient.get(
            endpoint,
            queryParameters: lastSyncTime != null ? queryParams : null,
          ),
        );

        final data = response.data as List;
        final items =
            data.map((e) => fromJson(Map<String, dynamic>.from(e))).toList();

        await handleDatabaseOperation(
          () => _localRepository.saveAllItems(items),
        );
      },
      onConflict: () async {
        final response = await handleApiCall(() => apiClient.get(endpoint));
        final data = response.data as List;
        final items =
            data.map((e) => fromJson(Map<String, dynamic>.from(e))).toList();
        await handleDatabaseOperation(
          () => _localRepository.saveAllItems(items),
        );
      },
      onComplete: () {
        logger.i('Sync completed successfully');
        return Future.value();
      },
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

  Future<T?> _getLastSyncedItem() async {
    final items = await _localRepository.getAllItems();
    if (items.isEmpty || syncField == null) return null;

    return items.reduce((a, b) {
      final aSync = syncField!.accessor(a);
      final bSync = syncField!.accessor(b);
      if (aSync == null) return b;
      if (bSync == null) return a;
      return aSync.isAfter(bSync) ? a : b;
    });
  }

  @override
  Future<void> dispose() async {
    await _localRepository.dispose();
    await super.dispose();
  }
}
