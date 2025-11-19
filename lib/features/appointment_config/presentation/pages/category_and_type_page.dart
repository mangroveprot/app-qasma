import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/presentation/widgets/basic_save_action_buttons.dart';
import '../../../../common/utils/tooltips_items.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../appointment_config/domain/usecases/update_config_uscase.dart';
import '../../../appointment_config/presentation/bloc/appointment_config_cubit.dart';
import '../../../users/data/models/params/dynamic_param.dart';
import '../../data/models/category_type_model.dart';
import '../controller/appointment_config_controller.dart';
import '../widgets/category_and_types_widget/add_category_type_button.dart';
import '../widgets/category_and_types_widget/category_options_menu.dart';
import '../widgets/category_and_types_widget/category_section.dart';
import '../widgets/category_and_types_widget/empty_category_type_section.dart';
import '../utils/category_type_utils.dart';

class CategoryTypePage extends StatefulWidget {
  const CategoryTypePage({super.key});

  @override
  _CategoryTypePageState createState() => _CategoryTypePageState();
}

class _CategoryTypePageState extends State<CategoryTypePage> {
  late final AppointmentConfigController controller;

  final ValueNotifier<Map<String, CategoryView>> _categoryTypesNotifier =
      ValueNotifier({});
  final ValueNotifier<bool> _hasChangesNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier(true);

  Map<String, CategoryView> _originalCategoryTypes = {};
  bool configDataLoaded = false;

  @override
  void initState() {
    super.initState();
    controller = AppointmentConfigController();
    controller.initialize();

    _initializeWithDelay();
  }

  Future<void> _initializeWithDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      _isLoadingNotifier.value = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _initializeCategoryTypesFromData() {
    if (!configDataLoaded) return;

    final config = controller.appointmentConfigCubit.currentConfig;
    if (config?.categoryAndType != null) {
      final newCategoryTypes =
          CategoryTypeUtils.fromConfigData(config!.categoryAndType);
      _categoryTypesNotifier.value = newCategoryTypes;
      _originalCategoryTypes = CategoryTypeUtils.deepCopy(newCategoryTypes);
    }
  }

  void _updateHasChanges() {
    _hasChangesNotifier.value = !CategoryTypeUtils.isEqual(
        _categoryTypesNotifier.value, _originalCategoryTypes);
  }

  void _updateCategoryType(
      String category, int index, String type, int duration) {
    final updated = CategoryTypeUtils.deepCopy(_categoryTypesNotifier.value);
    final view = updated[category];
    if (view != null && index < view.types.length) {
      final newTypes = List<CategoryTypeModel>.from(view.types);
      newTypes[index] =
          CategoryTypeModel(type: type.trim(), duration: duration);
      updated[category] = view.copyWith(types: newTypes);
    }
    _categoryTypesNotifier.value = updated;
    _updateHasChanges();
  }

  void _updateCategoryDescription(String category, String description) {
    final updated = CategoryTypeUtils.deepCopy(_categoryTypesNotifier.value);
    final view = updated[category];
    if (view != null) {
      updated[category] = view.copyWith(description: description);
      _categoryTypesNotifier.value = updated;
      _updateHasChanges();
    }
  }

  void _addCategoryType(String category) {
    final updated = CategoryTypeUtils.deepCopy(_categoryTypesNotifier.value);
    final view = updated[category];
    if (view != null) {
      final newTypes = List<CategoryTypeModel>.from(view.types)
        ..insert(0, const CategoryTypeModel(type: '', duration: 30));

      updated[category] = view.copyWith(types: newTypes);
      _categoryTypesNotifier.value = updated;
      _updateHasChanges();
    }
  }

  void _removeCategoryType(String category, int index) {
    final updated = CategoryTypeUtils.deepCopy(_categoryTypesNotifier.value);
    final view = updated[category];
    if (view == null) return;

    if (view.types.isNotEmpty && index < view.types.length) {
      if (view.types.length == 1) {
        CategoryDialogs.showRemoveLastTypeDialog(
          context,
          category,
          () {
            updated.remove(category);
            _categoryTypesNotifier.value = updated;
            _updateHasChanges();
          },
        );
      }
    }
  }

  void _addNewCategory(String categoryName, String description) {
    if (categoryName.trim().isEmpty) return;

    final updated = CategoryTypeUtils.deepCopy(_categoryTypesNotifier.value);
    if (!updated.containsKey(categoryName)) {
      updated[categoryName] = CategoryView(
        description: description.trim(),
        types: const [CategoryTypeModel(type: 'New Type', duration: 30)],
      );
    }
    _categoryTypesNotifier.value = updated;
    _updateHasChanges();
  }

  void _deleteCategory(String category) {
    final updated = CategoryTypeUtils.deepCopy(_categoryTypesNotifier.value);
    updated.remove(category);
    _categoryTypesNotifier.value = updated;
    _updateHasChanges();
  }

  void _unfocusAll() {
    FocusScope.of(context).unfocus();
  }

  void _saveChanges() {
    _unfocusAll();

    final processedCategoryTypes =
        CategoryTypeUtils.processForSave(_categoryTypesNotifier.value);
    _categoryTypesNotifier.value = processedCategoryTypes;

    final configId = controller.appointmentConfigCubit.currentConfig?.configId;
    if (configId != null) {
      _performUpdate(configId: configId, categoryTypes: processedCategoryTypes);
    } else {
      AppToast.show(message: 'Config ID not found', type: ToastType.error);
    }
  }

  void _performUpdate({
    required String configId,
    required Map<String, CategoryView> categoryTypes,
  }) {
    final categoryTypesMap = CategoryTypeUtils.toApiFormat(categoryTypes);

    final param = DynamicParam(
        fields: {'configId': configId, 'category_and_type': categoryTypesMap});

    controller.buttonCubit.execute(
      buttonId: 'save_category_types_config',
      usecase: sl<UpdateConfigUsecase>(),
      params: param,
    );
  }

  void _cancelChanges() {
    _unfocusAll();
    _categoryTypesNotifier.value =
        CategoryTypeUtils.deepCopy(_originalCategoryTypes);
    _hasChangesNotifier.value = false;
  }

  Future<void> _handleBack(BuildContext context) async {
    if (context.mounted) {
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
      final onSuccess = extra?['onSuccess'] as Function()?;

      try {
        onSuccess?.call();
      } catch (e) {
        debugPrint('Error calling success callback: $e');
      }
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: controller.blocProviders,
      child: MultiBlocListener(
        listeners: [
          BlocListener<ButtonCubit, ButtonState>(listener: _handleButtonState),
          BlocListener<AppointmentConfigCubit, AppointmentConfigCubitState>(
              listener: _handleAppointmentConfigState),
        ],
        child: GestureDetector(
          onTap: _unfocusAll,
          child: Scaffold(
            appBar: CustomAppBar(
              title: ToolTip.category_types.key,
              onBackPressed: _handleBack,
              tooltipMessage: ToolTip.category_types.tips,
            ),
            body: ValueListenableBuilder<bool>(
              valueListenable: _isLoadingNotifier,
              builder: (context, isLoading, _) {
                if (isLoading)
                  return const Center(child: CircularProgressIndicator());

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Expanded(
                        child:
                            ValueListenableBuilder<Map<String, CategoryView>>(
                          valueListenable: _categoryTypesNotifier,
                          builder: (context, categories, _) {
                            return categories.isEmpty
                                ? const EmptyCategoryTypesSection()
                                : ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: categories.keys.length,
                                    itemBuilder: (context, index) {
                                      final category =
                                          categories.keys.elementAt(index);
                                      final view = categories[category]!;
                                      return CategorySection(
                                        category: category,
                                        description: view.description,
                                        types: view.types,
                                        onAddType: _addCategoryType,
                                        onDeleteCategory: _deleteCategory,
                                        onUpdateType: _updateCategoryType,
                                        onUpdateDescription:
                                            _updateCategoryDescription,
                                        onRemoveType: _removeCategoryType,
                                      );
                                    },
                                  );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      AddCategoryTypeButton(
                        onPressed: () => CategoryDialogs.showAddCategoryDialog(
                          context,
                          _addNewCategory,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
            bottomNavigationBar: ValueListenableBuilder<bool>(
              valueListenable: _hasChangesNotifier,
              builder: (context, hasChanges, _) => hasChanges
                  ? BasicSaveActionButtons(
                      onSave: _saveChanges, onCancel: _cancelChanges)
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  void _handleButtonState(BuildContext context, ButtonState state) {
    if (state is ButtonSuccessState &&
        state.buttonId == 'save_category_types_config') {
      _originalCategoryTypes =
          CategoryTypeUtils.deepCopy(_categoryTypesNotifier.value);
      _hasChangesNotifier.value = false;
      AppToast.show(message: 'Saved successfully!', type: ToastType.success);
    } else if (state is ButtonFailureState &&
        state.buttonId == 'save_category_types_config') {
      AppToast.show(message: state.errorMessages.first, type: ToastType.error);
    }
  }

  void _handleAppointmentConfigState(
      BuildContext context, AppointmentConfigCubitState state) {
    if (state is AppointmentConfigLoadedState) {
      if (!configDataLoaded) {
        setState(() => configDataLoaded = true);
        _initializeCategoryTypesFromData();
      }
    } else if (state is AppointmentConfigFailureState) {
      AppToast.show(
          message: 'Failed to load appointment config data',
          type: ToastType.error);
      debugPrint('Failed to load appointment config: ${state.errorMessages}');
    }
  }

  @override
  void dispose() {
    _categoryTypesNotifier.dispose();
    _hasChangesNotifier.dispose();
    _isLoadingNotifier.dispose();
    super.dispose();
  }
}
