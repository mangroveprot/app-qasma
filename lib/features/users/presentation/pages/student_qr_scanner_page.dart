import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../common/utils/button_ids.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/button_text/custom_text_button.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../../infrastructure/routes/app_route_extractor.dart';
import '../../../../infrastructure/theme/theme_extensions.dart';
import '../../../appointment/presentation/controllers/qr_scanner_controller.dart';
import '../../../appointment/presentation/widgets/qr_scanner_widget/scanner_frame.dart';
import '../../../appointment/presentation/widgets/qr_scanner_widget/scanner_instructions.dart';
import '../../data/models/params/dynamic_param.dart';
import '../../data/models/user_model.dart';
import '../../domain/usecases/get_user_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';

class StudentQRScannerPage extends StatefulWidget {
  const StudentQRScannerPage({super.key});

  @override
  State<StudentQRScannerPage> createState() => _StudentQRScannerPageState();
}

class _StudentQRScannerPageState extends State<StudentQRScannerPage>
    with WidgetsBindingObserver {
  late final QRScannerController controller;
  MobileScannerController? _cameraController;
  bool _isScanning = true;
  bool _isDisposed = false;
  bool _isCameraInitialized = false;
  Map<String, dynamic>? _routeData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = QRScannerController();
    _initializeCamera();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _extractRouteData();
    if (!controller.isInitialized) {
      controller.initialize();
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

  VoidCallback? get onSuccessCallback {
    if (_routeData == null) return null;
    final onSuccess = _routeData!['onSuccess'];
    return onSuccess is VoidCallback ? onSuccess : null;
  }

  void _initializeCamera() {
    _cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
      autoStart: false,
      useNewCameraSelector: true,
      formats: const [BarcodeFormat.qrCode],
      returnImage: true,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _startCamera());
  }

  Future<void> _startCamera() async {
    if (_isDisposed || _cameraController == null) return;

    try {
      await _cameraController!.start();
      if (mounted && !_isDisposed) {
        setState(() => _isCameraInitialized = true);
      }
    } catch (_) {
      if (mounted && !_isDisposed) {
        setState(() => _isCameraInitialized = false);
      }
    }
  }

  Future<void> _stopCamera() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.stop();
      if (mounted && !_isDisposed) {
        setState(() => _isCameraInitialized = false);
      }
    } catch (_) {
      // ignore stop errors
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (_cameraController == null || _isDisposed) return;

    switch (state) {
      case AppLifecycleState.resumed:
        if (_isScanning && !_isCameraInitialized) {
          _startCamera();
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        if (_isCameraInitialized) {
          _stopCamera();
        }
        break;
    }
  }

  @override
  void deactivate() {
    if (_cameraController != null && !_isDisposed && _isCameraInitialized) {
      _stopCamera();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _isDisposed = true;
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _cameraController = null;
    super.dispose();
  }

  void _onDetect(BuildContext context, BarcodeCapture capture) {
    if (!_isScanning || _isDisposed || !_isCameraInitialized) return;

    final validBarcodes =
        capture.barcodes.where((barcode) => barcode.rawValue != null);

    if (validBarcodes.isNotEmpty) {
      _handleScanResult(context, validBarcodes.first.rawValue!);
    }
  }

  Future<void> _handleScanResult(BuildContext context, String data) async {
    if (_isDisposed) return;

    setState(() => _isScanning = false);
    await _stopCamera();

    final usecase = sl<GetUserUsecase>();
    final result = await usecase.call(param: data);

    await result.fold(
      (failure) async {
        AppToast.show(
          message: 'Student not found for ID: $data',
          type: ToastType.error,
        );
        _resetScanner();
      },
      (user) async {
        if (user is! UserModel) {
          AppToast.show(
            message: 'Invalid user data scanned.',
            type: ToastType.error,
          );
          _resetScanner();
          return;
        }

        await StudentScannerResultDialog.show(
          context: context,
          scannedData: data,
          user: user,
          onScanAgain: _resetScanner,
          onDone: () async {
            await _stopCamera();
            _onVerify(user);
          },
          buttonCubit: controller.buttonCubit,
        );
      },
    );
  }

  void _onVerify(UserModel user) {
    if (_isDisposed) return;

    if (user.active) {
      return AppToast.show(
        message: 'Student is already active.',
        type: ToastType.original,
      );
    }

    final param = DynamicParam(
      fields: {
        'idNumber': user.idNumber,
        'active': true,
      },
    );

    controller.buttonCubit.execute(
      usecase: sl<UpdateUserUsecase>(),
      params: param,
      buttonId: ButtonsUniqeKeys.verifyQR.id,
    );
  }

  void _resetScanner() {
    if (_isDisposed) return;
    setState(() => _isScanning = true);
    _startCamera();
  }

  Future<bool> _onWillPop() async {
    await _stopCamera();
    return true;
  }

  Widget _buildErrorView(Object error) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Camera Error',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await _stopCamera();
                if (mounted) Navigator.of(context).pop();
              },
              child: const Text('Go Back'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _startCamera,
              child: const Text('Retry Camera'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Initializing Camera...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _startCamera,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraStatusIndicator() {
    if (_isCameraInitialized) return const SizedBox.shrink();

    return Positioned(
      top: 100,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Camera is starting...',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Student QR Scanner'),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: MultiBlocProvider(
        providers: controller.blocProviders,
        child: MultiBlocListener(
          listeners: [
            BlocListener<ButtonCubit, ButtonState>(
              listener: _handleButtonState,
            ),
          ],
          child: Scaffold(
            appBar: const CustomAppBar(title: 'Student QR Scanner'),
            body: Stack(
              children: [
                MobileScanner(
                  controller: _cameraController,
                  onDetect: (capture) => _onDetect(context, capture),
                  errorBuilder: (context, error, child) =>
                      _buildErrorView(error),
                  placeholderBuilder: (context, child) => _buildPlaceholder(),
                ),
                Container(color: context.colors.black.withOpacity(0.5)),
                Center(
                  child: ScannerFrame(
                    isScanning: _isScanning && _isCameraInitialized,
                  ),
                ),
                const Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: ScannerInstructions(
                    customMessage: 'Scan the QR code to activate a student.',
                  ),
                ),
                _buildCameraStatusIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleButtonState(
    BuildContext context,
    ButtonState state,
  ) async {
    if (state is ButtonSuccessState &&
        state.buttonId == ButtonsUniqeKeys.verifyQR.id) {
      if (context.mounted) {
        final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
        final onSuccess = extra?['onSuccess'] as Function()?;

        if (onSuccess != null) {
          try {
            onSuccess();
          } catch (_) {}
        }

        Navigator.of(context).pop();
        context.pop();
        return AppToast.show(
          message: 'Student has been marked as active.',
          type: ToastType.success,
        );
      }
    }

    if (state is ButtonFailureState &&
        state.buttonId == ButtonsUniqeKeys.verifyQR.id) {
      return AppToast.show(
        message: state.errorMessages.first,
        type: ToastType.error,
      );
    }
  }
}

class StudentScannerResultDialog extends StatelessWidget {
  final String scannedData;
  final VoidCallback onScanAgain;
  final VoidCallback onDone;
  final UserModel user;
  final ButtonCubit buttonCubit;

  const StudentScannerResultDialog({
    super.key,
    required this.scannedData,
    required this.onScanAgain,
    required this.onDone,
    required this.user,
    required this.buttonCubit,
  });

  static Future<void> show({
    required BuildContext context,
    required String scannedData,
    required UserModel user,
    required VoidCallback onScanAgain,
    required VoidCallback onDone,
    required ButtonCubit buttonCubit,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StudentScannerResultDialog(
        scannedData: scannedData,
        user: user,
        onScanAgain: onScanAgain,
        onDone: onDone,
        buttonCubit: buttonCubit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: buttonCubit,
      child: Builder(
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 16),
                        _buildContent(context),
                        const SizedBox(height: 16),
                        _buildActions(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colors.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            Icons.qr_code_scanner,
            size: 24,
            color: colors.secondary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Confirm Student',
          style: TextStyle(
            fontSize: 18,
            fontWeight: fontWeight.bold,
            color: colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          'Mark this student as active?',
          style: TextStyle(
            fontSize: 13,
            color: colors.textPrimary,
            fontWeight: fontWeight.regular,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final colors = context.colors;
    final isActive = user.active;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEDF2F7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDataRow(
                'ID Number',
                user.idNumber,
                Icons.badge_outlined,
                colors,
              ),
              const SizedBox(height: 8),
              _buildDataRow(
                'Name',
                user.fullName,
                Icons.person,
                colors,
              ),
              const SizedBox(height: 8),
              _buildDataRow(
                'Current Status',
                isActive ? 'Active' : 'Inactive',
                isActive ? Icons.check_circle : Icons.remove_circle_outline,
                colors,
                valueColor: isActive ? Colors.green : Colors.red,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataRow(
    String label,
    String value,
    IconData icon,
    dynamic colors, {
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 14,
          color: colors.textPrimary,
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 90,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colors.textPrimary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: valueColor ?? colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        CustomTextButton(
          backgroundColor: colors.primary,
          width: double.infinity,
          onPressed: onDone,
          text: 'Mark as Active',
          buttonId: ButtonsUniqeKeys.verifyQR.id,
          borderRadius: BorderRadius.circular(10),
          iconData: Icons.check,
          iconPosition: Position.left,
          iconSize: 14,
          textColor: colors.white,
          iconColor: colors.white,
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onScanAgain();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey,
              side: const BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.qr_code_scanner,
                  size: 14,
                  color: colors.black,
                ),
                const SizedBox(width: 6),
                Text(
                  'Scan Again',
                  style: TextStyle(fontSize: 14, color: colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
