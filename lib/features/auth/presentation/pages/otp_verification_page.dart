import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/utils/button_ids.dart';
import '../../../../common/utils/constant.dart';
import '../../../../common/utils/form_field_config.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../../infrastructure/routes/app_route_extractor.dart';
import '../../../../infrastructure/routes/app_routes.dart';
import '../../data/models/resend_otp_params.dart';
import '../../data/models/verify_params.dart';
import '../../domain/usecases/resend_otp_usecase.dart';
import '../../domain/usecases/verify_usecase.dart';
import '../widgets/otp_verrification_widget/otp_verification_form.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => OtpVerificationPageState();
}

class OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> controllers = [];
  final List<FocusNode> focusNodes = [];
  Map<String, dynamic>? _routeData;
  final otp_field_key = field_otp_verification.field_key;
  bool isResend = false;
  bool isResetPassword = false;

  bool _canResendOtp = true;
  DateTime? _lastResendTime;
  Timer? _resendTimer;
  int _resendCooldownRemaining = 0;
  static const int resendCooldownDuration = 300; // 5minutes

  static const List<FormFieldConfig> _routeFields = [field_email];

  bool get canResendOtp => _canResendOtp;
  int get resendCooldownRemaining => _resendCooldownRemaining;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      controllers.add(TextEditingController());
      focusNodes.add(FocusNode());
    }
    _checkResendCooldown();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _extractRouteData();
  }

  void _extractRouteData() {
    if (_routeData != null) return;
    final extra = GoRouterState.of(context).extra;
    if (AppRouteExtractor.extractFieldByKey(extra, OtpPurposes.passwordReset)
        .isNotEmpty) {
      isResetPassword = true;
    } else if (AppRouteExtractor.extractFieldByKey(
            extra, OtpPurposes.accountVerification)
        .isNotEmpty) {
      isResetPassword = false;
    }

    _routeData = AppRouteExtractor.extractFieldData(extra, _routeFields);
  }

  String getRouteValue(FormFieldConfig field) {
    return _routeData?[field.field_key] ?? '';
  }

  void _checkResendCooldown() {
    if (_lastResendTime != null) {
      final timeSinceLastResend = DateTime.now().difference(_lastResendTime!);
      final remainingSeconds =
          resendCooldownDuration - timeSinceLastResend.inSeconds;

      if (remainingSeconds > 0) {
        _canResendOtp = false;
        _resendCooldownRemaining = remainingSeconds;
        _startCooldownTimer();
      } else {
        _canResendOtp = true;
        _resendCooldownRemaining = 0;
      }
    }
  }

  void _startCooldownTimer() {
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldownRemaining > 0) {
        setState(() {
          _resendCooldownRemaining--;
        });
      } else {
        setState(() {
          _canResendOtp = true;
        });
        timer.cancel();
      }
    });
  }

  void _startResendCooldown() {
    setState(() {
      _canResendOtp = false;
      _lastResendTime = DateTime.now();
      _resendCooldownRemaining = resendCooldownDuration;
    });
    _startCooldownTimer();
  }

  String formatResendTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void deactivate() {
    context.read<FormCubit>().clearAll();
    super.deactivate();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
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

  String get otpPurposes {
    String purposes = '';
    if (isResetPassword) {
      purposes = OtpPurposes.passwordReset;
    } else if (_routeData != null && _routeData!.isNotEmpty) {
      purposes = OtpPurposes.accountVerification;
    }
    return purposes;
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

  void onSubmitted(BuildContext context, int index) {
    if (index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (isOtpComplete) {
      handleVerifyOTP(context);
    }
  }

  void handleVerifyOTP(BuildContext context) {
    if (!isOtpComplete) {
      context.read<FormCubit>().setFieldError(
            otp_field_key,
            'Please enter complete 6-digit code',
          );
      return;
    }

    _performVerifyAccount(context);
  }

  void _performVerifyAccount(BuildContext context) {
    final email = getRouteValue(field_email);
    final params = VerifyParams(email: email, code: otpCode);

    context.read<ButtonCubit>().execute(
          usecase: sl<VerifyUsecase>.call(),
          params: params,
          buttonId: ButtonsUniqeKeys.verify.id,
        );
    isResend = false;
  }

  void handleResendOTP(BuildContext context) {
    if (!mounted) return;

    // Check if resend is allowed
    if (!_canResendOtp) {
      AppToast.show(
        message:
            'Please wait ${formatResendTime(_resendCooldownRemaining)} before requesting another OTP',
        type: ToastType.warning,
      );
      return;
    }

    for (var controller in controllers) {
      controller.clear();
    }

    context.read<FormCubit>().clearAll();

    if (focusNodes.isNotEmpty) {
      focusNodes[0].requestFocus();
    }

    _performResend(context);
  }

  Future<void> _performResend(BuildContext context) async {
    final email = getRouteValue(field_email);

    final params = ResendOtpParams(
      email: email,
      purposes: otpPurposes,
    );

    context.read<ButtonCubit>().execute(
          usecase: sl<ResendOTPUsecase>(),
          params: params,
          buttonId: ButtonsUniqeKeys.resend.id,
        );
    isResend = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ButtonCubit(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: isResetPassword
              ? 'Reset Password Verification'
              : 'Account Verification',
        ),
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
      if (isResend) {
        _startResendCooldown();

        AppToast.show(
          message: 'OTP has been resent to your email',
          type: ToastType.success,
        );
        return;
      }

      if (!isResend) {
        if (otpPurposes == OtpPurposes.passwordReset) {
          final email = getRouteValue(field_email);
          AppToast.show(
            message:
                'Successfully verified. You will be redirected to reset password page.',
            type: ToastType.success,
          );
          context.go(
            Routes.buildPath(Routes.aut_path, Routes.reset_password),
            extra: {field_email.field_key: email},
          );
          return;
        }

        AppToast.show(
          message:
              'Account is verified successfully. You will be redirected to login.',
          type: ToastType.success,
        );
        context.go(Routes.buildPath(Routes.aut_path, Routes.login));
      }
    }
  }
}
