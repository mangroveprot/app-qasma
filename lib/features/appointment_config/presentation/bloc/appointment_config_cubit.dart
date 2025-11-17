import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../../../common/error/app_error.dart';
import '../../../../core/_base/_bloc_cubit/base_cubit.dart';
import '../../../../core/_usecase/usecase.dart';
import '../../data/models/appointment_config_model.dart';
import '../../domain/entites/category.dart';
import '../../domain/entites/category_type.dart';

part 'appointment_config_cubit_state.dart';

class AppointmentConfigCubit extends BaseCubit<AppointmentConfigCubitState> {
  final Logger _logger = Logger();

  AppointmentConfigCubit() : super(AppointmentConfigInitialState());

  @override
  void emitLoading({bool isRefreshing = false}) {
    if (!isClosed) {
      emit(AppointmentConfigLoadingState(isRefreshing: isRefreshing));
    }
  }

  @override
  void emitInitial({bool isRefreshing = false}) {
    if (!isClosed) {
      emit(AppointmentConfigInitialState());
    }
  }

  @override
  void emitError({
    String? message,
    List<String>? errorMessages,
    dynamic error,
    StackTrace? stackTrace,
    List<String>? suggestions,
  }) {
    if (isClosed) return;

    final List<String> finalSuggestions =
        error is AppError ? error.suggestions ?? [] : [];

    final List<String> finalErrorMessages = errorMessages ??
        (error is AppError
            ? error.allMessages
            : [message ?? 'Failed to load appointment config']);

    emit(
      AppointmentConfigFailureState(
        errorMessages: finalErrorMessages,
        suggestions: finalSuggestions,
      ),
    );
  }

  Future<void> loadAppointmentConfig({
    dynamic params,
    required Usecase usecase,
    bool isRefreshing = false,
  }) async {
    if (isClosed) {
      _logger.d('Cubit closed, skipping loadAppointmentConfig');
      return;
    }

    emitLoading(isRefreshing: isRefreshing);

    try {
      final Either result = await usecase.call(param: params);

      if (isClosed) {
        _logger.d('Cubit closed after usecase call');
        return;
      }

      result.fold(
        (error) {
          if (isClosed) {
            _logger.d('Cubit closed in fold error callback');
            return;
          }
          _logger.e('Failed to load appointment config: $error');
          emitError(
            errorMessages:
                error.messages ?? ['Failed to load appointment config'],
            suggestions: error.suggestions,
            error: error,
          );
        },
        (data) {
          if (isClosed) {
            _logger.d('Cubit closed in fold success callback');
            return;
          }
          final config = data as AppointmentConfigModel;
          _logger.i('Successfully loaded appointment config');
          emit(AppointmentConfigLoadedState(config));
        },
      );
    } catch (e, stackTrace) {
      if (isClosed) {
        _logger.d('Cubit closed in catch block');
        return;
      }
      _logger.e('Error loading appointment config: $e\n$stackTrace');
      emitError(
        errorMessages: ['Failed to load appointment config: ${e.toString()}'],
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  AppointmentConfigModel? get currentConfig {
    final state = this.state;
    return state is AppointmentConfigLoadedState ? state.config : null;
  }

  // Get Category object for a specific category key
  Category? getCategory(String category) {
    if (isClosed) return null;

    final categoryAndType = currentConfig?.categoryAndType;
    if (categoryAndType == null) return null;

    // Case-insensitive lookup
    final normalizedCategory = category.toLowerCase();
    for (final entry in categoryAndType.entries) {
      if (entry.key.toLowerCase() == normalizedCategory) {
        return entry.value;
      }
    }
    return null;
  }

  // Get CategoryType objects for a specific category
  List<CategoryType> getCategoryTypes(String category) {
    if (isClosed) return [];

    final categoryObj = getCategory(category);
    return categoryObj?.types ?? [];
  }

  // Get type names only for a specific category
  List<String> getTypesByCategory(String category) {
    if (isClosed) return [];

    final categoryTypes = getCategoryTypes(category);
    return categoryTypes.map((categoryType) => categoryType.type).toList();
  }

  // Get duration for a specific type within a specific category
  int? getDurationByTypeInCategory(String category, String typeName) {
    if (isClosed) return null;

    final categoryTypes = getCategoryTypes(category);
    for (final categoryType in categoryTypes) {
      if (categoryType.type == typeName) {
        return categoryType.duration;
      }
    }
    return null; // Type not found in this category
  }

  // Get description for a specific category
  String? getCategoryDescription(String category) {
    if (isClosed) return null;

    final categoryObj = getCategory(category);
    return categoryObj?.description;
  }

  // Get all categories (keys)
  List<String> get allCategoriesName {
    if (isClosed) return [];
    return currentConfig?.categoryAndType?.keys.toList() ?? [];
  }

  // Get all categories (map)
  Map<String, Category> get allCategories {
    if (isClosed) return {};
    return currentConfig?.categoryAndType ?? {};
  }

  @override
  Future<void> close() {
    _logger.d('Closing AppointmentConfigCubit');
    return super.close();
  }
}
