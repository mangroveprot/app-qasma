import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/presentation/widgets/basic_save_action_buttons.dart';
import '../../../../common/utils/tooltips_items.dart';
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
import '../controller/appointment_config_controller.dart';

class BasicConfigPage extends StatefulWidget {
  const BasicConfigPage({super.key});

  @override
  State<BasicConfigPage> createState() => _BasicConfigPageState();
}

class _BasicConfigPageState extends State<BasicConfigPage> {
  late final AppointmentConfigController controller;

  final ValueNotifier<Map<String, int>> _configNotifier =
      ValueNotifier(<String, int>{});
  final ValueNotifier<bool> _hasChangesNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier(true);

  late TextEditingController _bufferTimeController;
  late TextEditingController _bookingLeadTimeController;
  late TextEditingController _slotDaysRangeController;

  Map<String, int> _originalConfig = {};
  Map<String, dynamic>? _routeData;

  bool _hasInitialized = false;
  bool configDataLoaded = false;

  @override
  void initState() {
    super.initState();
    controller = AppointmentConfigController();
    _initializeControllers();
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

  void _initializeControllers() {
    _bufferTimeController = TextEditingController();
    _bookingLeadTimeController = TextEditingController();
    _slotDaysRangeController = TextEditingController();

    _bufferTimeController.addListener(_updateBufferTime);
    _bookingLeadTimeController.addListener(_updateBookingLeadTime);
    _slotDaysRangeController.addListener(_updateSlotDaysRange);
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

  void _initializeConfigFromData() {
    if (!configDataLoaded) return;

    final AppointmentConfigModel? config =
        controller.appointmentConfigCubit.currentConfig;

    if (config != null) {
      final newConfig = {
        'buffer_time': config.bufferTime ?? 10,
        'booking_lead_time': config.bookingLeadTime ?? 120,
        'slot_days_range': config.slotDaysRange ?? 7,
      };

      _configNotifier.value = newConfig;
      _originalConfig = Map.from(newConfig);
      _updateControllers();
    }
  }

  void _updateControllers() {
    final config = _configNotifier.value;
    if (config.isNotEmpty) {
      _bufferTimeController.text = config['buffer_time']?.toString() ?? '';
      _bookingLeadTimeController.text =
          config['booking_lead_time']?.toString() ?? '';
      _slotDaysRangeController.text =
          config['slot_days_range']?.toString() ?? '';
    }
  }

  void _updateBufferTime() {
    final value = int.tryParse(_bufferTimeController.text) ?? 0;
    final updatedConfig = Map<String, int>.from(_configNotifier.value);
    updatedConfig['buffer_time'] = value;
    _configNotifier.value = updatedConfig;
    _updateHasChanges();
  }

  void _updateBookingLeadTime() {
    final value = int.tryParse(_bookingLeadTimeController.text) ?? 0;
    final updatedConfig = Map<String, int>.from(_configNotifier.value);
    updatedConfig['booking_lead_time'] = value;
    _configNotifier.value = updatedConfig;
    _updateHasChanges();
  }

  void _updateSlotDaysRange() {
    final value = int.tryParse(_slotDaysRangeController.text) ?? 0;
    final updatedConfig = Map<String, int>.from(_configNotifier.value);
    updatedConfig['slot_days_range'] = value;
    _configNotifier.value = updatedConfig;
    _updateHasChanges();
  }

  void _updateHasChanges() {
    final current = _configNotifier.value;
    bool hasChanges = false;

    for (final key in current.keys) {
      if (current[key] != _originalConfig[key]) {
        hasChanges = true;
        break;
      }
    }

    _hasChangesNotifier.value = hasChanges;
  }

  void _saveChanges() {
    FocusScope.of(context).unfocus();
    final configData = _configNotifier.value;

    final String? configId =
        controller.appointmentConfigCubit.currentConfig?.configId;

    if (configId != null) {
      _performUpdate(configId: configId, configData: configData);
    } else {
      AppToast.show(
        message: 'Config ID not found',
        type: ToastType.error,
      );
    }
  }

  void _performUpdate(
      {required String configId, required Map<String, dynamic> configData}) {
    final Map<String, dynamic> params = {
      'configId': configId,
      'buffer_time': configData['buffer_time'],
      'booking_lead_time': configData['booking_lead_time'],
      'slot_days_range': configData['slot_days_range'],
    };

    final param = DynamicParam(fields: params);
    controller.buttonCubit.execute(
      buttonId: 'save_basic_config',
      usecase: sl<UpdateConfigUsecase>(),
      params: param,
    );
  }

  void _cancelChanges() {
    _configNotifier.value = Map.from(_originalConfig);
    _updateControllers();
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
    final colors = context.colors;
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
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'Basic Config',
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

              return LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      Expanded(
                        child: ValueListenableBuilder<Map<String, int>>(
                          valueListenable: _configNotifier,
                          builder: (context, config, _) =>
                              SingleChildScrollView(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 24,
                              bottom: 24,
                            ),
                            child: Column(
                              children: [
                                CustomInputField(
                                  fieldName: 'buffer_time',
                                  label: ToolTip.buffer_time.key,
                                  icon: Icons.access_time,
                                  iconColor: colors.secondary,
                                  controller: _bufferTimeController,
                                  onChanged: _updateBufferTime,
                                  keyboardType: TextInputType.number,
                                  tooltip: ToolTip.buffer_time.tips,
                                ),
                                CustomInputField(
                                  fieldName: 'booking_lead_time',
                                  label: ToolTip.booking_lead_time.key,
                                  icon: Icons.schedule,
                                  iconColor: colors.secondary,
                                  controller: _bookingLeadTimeController,
                                  onChanged: _updateBookingLeadTime,
                                  keyboardType: TextInputType.number,
                                  tooltip: ToolTip.booking_lead_time.tips,
                                ),
                                CustomInputField(
                                  fieldName: 'slot_days_range',
                                  label: ToolTip.slot_days_range.key,
                                  icon: Icons.date_range,
                                  iconColor: colors.secondary,
                                  controller: _slotDaysRangeController,
                                  onChanged: _updateSlotDaysRange,
                                  keyboardType: TextInputType.number,
                                  tooltip: ToolTip.slot_days_range.tips,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: _hasChangesNotifier,
                        builder: (context, hasChanges, _) => hasChanges
                            ? BasicSaveActionButtons(
                                onSave: _saveChanges,
                                onCancel: _cancelChanges,
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleButtonState(BuildContext context, ButtonState state) {
    if (state is ButtonSuccessState && state.buttonId == 'save_basic_config') {
      _originalConfig = Map.from(_configNotifier.value);
      _hasChangesNotifier.value = false;

      AppToast.show(
        message: 'Basic config saved successfully!',
        type: ToastType.success,
      );
    } else if (state is ButtonFailureState &&
        state.buttonId == 'save_basic_config') {
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
        _initializeConfigFromData();
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
    _bufferTimeController.removeListener(_updateBufferTime);
    _bookingLeadTimeController.removeListener(_updateBookingLeadTime);
    _slotDaysRangeController.removeListener(_updateSlotDaysRange);

    _bufferTimeController.dispose();
    _bookingLeadTimeController.dispose();
    _slotDaysRangeController.dispose();

    _configNotifier.dispose();
    _hasChangesNotifier.dispose();
    _isLoadingNotifier.dispose();

    super.dispose();
  }
}
