import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../../../../core/_base/_bloc_cubit/base_cubit.dart';
import '../../../../core/_usecase/usecase.dart';
import '../../data/models/appointment_config_model.dart';
import '../../domain/entites/category_type.dart';

part 'appointment_config_cubit_state.dart';

class AppointmentConfigCubit extends BaseCubit<AppointmentConfigCubitState> {
  AppointmentConfigCubit() : super(AppointmentConfigInitialState());

  @override
  void emitLoading({bool isRefreshing = false}) {
    emit(AppointmentConfigLoadingState(isRefreshing: isRefreshing));
  }

  @override
  void emitInitial({bool isRefreshing = false}) {
    emit(AppointmentConfigInitialState());
  }

  @override
  void emitError({
    String? message,
    List<String>? errorMessages,
    dynamic error,
    StackTrace? stackTrace,
    List<String>? suggestions,
  }) {
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
    emitLoading(isRefreshing: isRefreshing);

    try {
      final Either result = await usecase.call(param: params);

      result.fold(
        (error) {
          emitError(
            errorMessages:
                error.messages ?? ['Failed to load appointment config'],
            suggestions: error.suggestions,
            error: error,
          );
        },
        (data) {
          final config = data as AppointmentConfigModel;
          emit(AppointmentConfigLoadedState(config));
        },
      );
    } catch (e, stackTrace) {
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

// Get CategoryType objects for a specific category
  List<CategoryType> getCategoryTypes(String category) {
    final categoryAndType = currentConfig?.categoryAndType;
    if (categoryAndType == null) return [];

    // Case-insensitive lookup
    final normalizedCategory = category.toLowerCase();
    for (final entry in categoryAndType.entries) {
      if (entry.key.toLowerCase() == normalizedCategory) {
        return entry.value;
      }
    }
    return [];
  }

// Get type names only for a specific category
  List<String> getTypesByCategory(String category) {
    final categoryTypes = getCategoryTypes(category);
    return categoryTypes.map((categoryType) => categoryType.type).toList();
  }

// Get duration for a specific type within a specific category
  int? getDurationByTypeInCategory(String category, String typeName) {
    final categoryTypes = getCategoryTypes(category);
    for (final categoryType in categoryTypes) {
      if (categoryType.type == typeName) {
        return categoryType.duration;
      }
    }
    return null; // Type not found in this category
  }

// Get all categories (keys)
  List<String> get allCategories {
    return currentConfig?.categoryAndType?.keys.toList() ?? [];
  }
}
