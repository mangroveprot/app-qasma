import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/presentation/widgets/basic_save_action_buttons.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/custom_input_field.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../../infrastructure/routes/app_route_extractor.dart';
import '../../../../infrastructure/theme/theme_extensions.dart';
import '../../../appointment_config/domain/usecases/update_config_uscase.dart';
import '../../../appointment_config/presentation/bloc/appointment_config_cubit.dart';
import '../../../users/data/models/params/dynamic_param.dart';
import '../../data/models/appointment_config_model.dart';
import '../../data/models/reminder_model.dart';
import '../controller/appointment_config_controller.dart';
import '../widgets/reminders_widget/add_reminder_button.dart';
import '../widgets/reminders_widget/empty_reminders_section.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  _RemindersPageState createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  late final AppointmentConfigController controller;

  final ValueNotifier<List<ReminderModel>> _remindersNotifier =
      ValueNotifier(<ReminderModel>[]);
  final ValueNotifier<bool> _hasChangesNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier(true);

  List<ReminderModel> _originalReminders = [];
  Map<String, dynamic>? _routeData;

  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];

  bool _hasInitialized = false;
  bool configDataLoaded = false;

  @override
  void initState() {
    super.initState();
    controller = AppointmentConfigController();
    _initializeData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _extractRouteData();

    if (!_hasInitialized) {
      controller.initialize();
      _hasInitialized = true;
    }
  }

  void _extractRouteData() {
    if (_routeData != null) return;

    final rawExtra = GoRouterState.of(context).extra;
    _routeData = rawExtra as Map<String, dynamic>?;

    if (_routeData == null) {
      _routeData = AppRouteExtractor.extractRaw<Map<String, dynamic>>(rawExtra);
    }
  }

  void _initializeData() {
    _initializeWithDelay();
  }

  Future<void> _initializeWithDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      _isLoadingNotifier.value = false;
    }
  }

  void _initializeRemindersFromData() {
    if (!configDataLoaded) return;

    final AppointmentConfigModel? config =
        controller.appointmentConfigCubit.currentConfig;

    if (config != null && config.reminders != null) {
      final newReminders = config.reminders!
          .map((reminder) => ReminderModel(message: reminder.message.trim()))
          .toList();
      _remindersNotifier.value = newReminders;
      _originalReminders = List<ReminderModel>.from(newReminders);
      _setupControllers();
    } else {
      _remindersNotifier.value = [];
      _originalReminders = [];
      _setupControllers();
    }
  }

  void _setupControllers() {
    _disposeControllers();
    final reminders = _remindersNotifier.value;
    controllers = reminders
        .map((reminder) => TextEditingController(text: reminder.message))
        .toList();
    focusNodes = List.generate(reminders.length, (_) => FocusNode());
  }

  void _disposeControllers() {
    for (final controller in controllers) controller.dispose();
    for (final node in focusNodes) node.dispose();
    controllers.clear();
    focusNodes.clear();
  }

  bool _remindersEqual(List<ReminderModel> list1, List<ReminderModel> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].message.trim() != list2[i].message.trim()) return false;
    }
    return true;
  }

  void _updateHasChanges() {
    final current = _remindersNotifier.value;
    final hasChanges = !_remindersEqual(current, _originalReminders);
    _hasChangesNotifier.value = hasChanges;
  }

  void _unfocusAll() {
    for (final node in focusNodes) node.unfocus();
    FocusScope.of(context).unfocus();
  }

  void _updateReminder(int index, String value) {
    final updatedReminders = List<ReminderModel>.from(_remindersNotifier.value);
    if (index >= 0 && index < updatedReminders.length) {
      updatedReminders[index] = ReminderModel(message: value.trim());
      _remindersNotifier.value = updatedReminders;
      _updateHasChanges();
    }
  }

  void _addReminder() {
    final updatedReminders = List<ReminderModel>.from(_remindersNotifier.value);
    updatedReminders.add(const ReminderModel(message: 'New reminder'));
    _remindersNotifier.value = updatedReminders;

    controllers.add(TextEditingController(text: 'New reminder'));
    focusNodes.add(FocusNode());
    _updateHasChanges();
  }

  void _removeReminder(int index) {
    if (index >= 0 && index < _remindersNotifier.value.length) {
      focusNodes[index].unfocus();
      controllers[index].dispose();
      focusNodes[index].dispose();

      final updatedReminders =
          List<ReminderModel>.from(_remindersNotifier.value);
      updatedReminders.removeAt(index);
      controllers.removeAt(index);
      focusNodes.removeAt(index);

      _remindersNotifier.value = updatedReminders;
      _updateHasChanges();
    }
  }

  void _saveChanges() {
    _unfocusAll();

    final trimmedReminders = _remindersNotifier.value
        .map((reminder) => ReminderModel(message: reminder.message.trim()))
        .where((reminder) => reminder.message.isNotEmpty)
        .toList();

    _remindersNotifier.value = trimmedReminders;

    final String? configId =
        controller.appointmentConfigCubit.currentConfig?.configId;

    if (configId != null) {
      _performUpdate(configId: configId, reminders: trimmedReminders);
    } else {
      AppToast.show(
        message: 'Config ID not found',
        type: ToastType.error,
      );
    }
  }

  void _performUpdate({
    required String configId,
    required List<ReminderModel> reminders,
  }) {
    final Map<String, dynamic> params = {
      'configId': configId,
      'reminders': reminders.map((r) => r.message.trim()).toList(),
    };

    final param = DynamicParam(fields: params);
    controller.buttonCubit.execute(
      buttonId: 'save_reminders_config',
      usecase: sl<UpdateConfigUsecase>(),
      params: param,
    );
  }

  void _cancelChanges() {
    _unfocusAll();
    _remindersNotifier.value = List<ReminderModel>.from(_originalReminders);
    _setupControllers();
    _hasChangesNotifier.value = false;
  }

  Future<void> _handleBack(BuildContext context) async {
    if (context.mounted) {
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
      final onSuccess = extra?['onSuccess'] as Function()?;

      if (onSuccess != null) {
        try {
          onSuccess();
        } catch (e) {
          debugPrint('Error calling success callback: $e');
        }
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
          BlocListener<ButtonCubit, ButtonState>(
            listener: _handleButtonState,
          ),
          BlocListener<AppointmentConfigCubit, AppointmentConfigCubitState>(
            listener: _handleAppointmentConfigState,
          ),
        ],
        child: GestureDetector(
          onTap: _unfocusAll,
          child: Scaffold(
            appBar: CustomAppBar(
              title: 'Reminders',
              onBackPressed: _handleBack,
            ),
            body: ValueListenableBuilder<bool>(
              valueListenable: _isLoadingNotifier,
              builder: (context, isLoading, _) {
                if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Expanded(
                        child: ValueListenableBuilder<List<ReminderModel>>(
                          valueListenable: _remindersNotifier,
                          builder: (context, reminders, _) {
                            return reminders.isEmpty
                                ? const EmptyRemindersSectionWidget()
                                : ListView.builder(
                                    itemCount: reminders.length,
                                    itemBuilder: (context, index) =>
                                        _buildReminderItem(index),
                                  );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      AddReminderButton(onPressed: _addReminder),
                    ],
                  ),
                );
              },
            ),
            bottomNavigationBar: ValueListenableBuilder<bool>(
              valueListenable: _hasChangesNotifier,
              builder: (context, hasChanges, _) => hasChanges
                  ? BasicSaveActionButtons(
                      onSave: _saveChanges,
                      onCancel: _cancelChanges,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReminderItem(int index) {
    final fontWeight = context.weight;
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomInputField(
              fieldName: 'reminder_$index',
              fontWeight: fontWeight.regular,
              fontSize: 14,
              maxLines: null,
              controller: controllers[index],
              onChanged: () => _updateReminder(index, controllers[index].text),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _removeReminder(index),
            icon: Icon(Icons.delete_outline, color: colors.error, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: colors.white,
              foregroundColor: colors.error,
              padding: const EdgeInsets.all(8),
              minimumSize: const Size(40, 40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  void _handleButtonState(BuildContext context, ButtonState state) {
    if (state is ButtonSuccessState &&
        state.buttonId == 'save_reminders_config') {
      _originalReminders = List<ReminderModel>.from(_remindersNotifier.value);
      _hasChangesNotifier.value = false;

      AppToast.show(
        message: 'Reminders saved successfully!',
        type: ToastType.success,
      );
    } else if (state is ButtonFailureState &&
        state.buttonId == 'save_reminders_config') {
      AppToast.show(
        message: state.errorMessages.first,
        type: ToastType.error,
      );
    }
  }

  void _handleAppointmentConfigState(
    BuildContext context,
    AppointmentConfigCubitState state,
  ) {
    if (state is AppointmentConfigLoadedState) {
      if (!configDataLoaded) {
        setState(() {
          configDataLoaded = true;
        });
        _initializeRemindersFromData();
      }
    } else if (state is AppointmentConfigFailureState) {
      AppToast.show(
        message: 'Failed to load appointment config data',
        type: ToastType.error,
      );
      debugPrint('Failed to load appointment config: ${state.errorMessages}');
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    _remindersNotifier.dispose();
    _hasChangesNotifier.dispose();
    _isLoadingNotifier.dispose();
    super.dispose();
  }
}
