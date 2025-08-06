import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/utils/form_field_config.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../infrastructure/routes/app_route_extractor.dart';
import '../widgets/otp_verrification_widget/otp_verification_form.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => OtpVerificationPageState();
}

class OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> controllers = [];
  final List<FocusNode> focusNodes = [];
  late Map<String, dynamic> _routeData;
  final otp_field_key = field_otp_verification.field_key;

  static const List<FormFieldConfig> _routeFields = [field_email];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      controllers.add(TextEditingController());
      focusNodes.add(FocusNode());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _extractRouteData();
  }

  void _extractRouteData() {
    final extra = GoRouterState.of(context).extra;
    _routeData = AppRouteExtractor.extractFieldData(extra, _routeFields);
  }

  String getRouteValue(FormFieldConfig field) {
    return _routeData[field.field_key] ?? '';
  }

  @override
  void deactivate() {
    // if the page is closed then clear the error from cubit
    context.read<FormCubit>().clearAll();
    super.deactivate();
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void onBackspace(int index) {
    if (!mounted) return;

    if (index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  String get otpCode {
    return controllers.map((controller) => controller.text).join();
  }

  bool get isOtpComplete {
    return otpCode.length == 6 &&
        controllers.every((controller) => controller.text.isNotEmpty);
  }

  void onOtpChanged(int index, String value) {
    if (!mounted) return;

    context.read<FormCubit>().clearFieldError('otp_field_$index');
    context.read<FormCubit>().clearFieldError('otp_verification');

    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    }

    context.read<FormCubit>().clearAll();
  }

  void onSubmitted(int index) {
    if (index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (isOtpComplete) {
      handleVerifyOTP();
    }
  }

  void handleVerifyOTP() {
    // TODO: Implement OTP verification logic
    if (!isOtpComplete) {
      // Set error for incomplete OTP
      context.read<FormCubit>().setFieldError(
            otp_field_key,
            'Please enter complete 6-digit code',
          );
      return;
    }

    // Get email from route parameters for verification
    final email = getRouteValue(field_email);
  }

  void handleResendOTP() {
    if (!mounted) return;

    for (var controller in controllers) {
      controller.clear();
    }

    context.read<FormCubit>().clearAll();

    if (focusNodes.isNotEmpty) {
      focusNodes[0].requestFocus();
    }

    // TODO: Handle resend OTP logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(leadingText: 'Back'),
      body: BlocListener<ButtonCubit, ButtonState>(
        listener: _handleButtonState,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: OtpVerificationForm(state: this),
            );
          },
        ),
      ),
    );
  }

  void _handleButtonState(BuildContext context, ButtonState state) {
    if (state is ButtonFailureState) {
      if (state.errorMessages.isNotEmpty) {
        AppToast.show(
          message: state.errorMessages.first,
          type: ToastType.error,
        );
      }
    }

    if (state is ButtonSuccessState) {
      // OTP verification successful - handle navigation or other success logic
    }
  }
}
