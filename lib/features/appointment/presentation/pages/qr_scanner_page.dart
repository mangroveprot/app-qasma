import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../common/utils/button_ids.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../../infrastructure/routes/app_route_extractor.dart';
import '../../../../infrastructure/theme/theme_extensions.dart';
import '../../data/models/appointment_model.dart';
import '../../data/models/params/qr_scan_params.dart';
import '../../domain/usecases/verify_appointment_usecase.dart';
import '../controllers/qr_scanner_controller.dart';
import '../widgets/qr_scanner_widget/scanner_frame.dart';
import '../widgets/qr_scanner_widget/scanner_instructions.dart';
import '../widgets/qr_scanner_widget/scanner_result_dialog.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage>
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

  AppointmentModel? get appointment {
    if (_routeData == null) {
      return null;
    }

    final appointmentData = _routeData!['appointment'];
    return appointmentData as AppointmentModel?;
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
    } catch (e) {
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
    } catch (e) {
      //  error silently
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

  void _onVerify() {
    if (_isDisposed) return;
    final currentUserId = SharedPrefs().getString('currentUserId') ?? '';
    if (currentUserId.isEmpty)
      return AppToast.show(
        message: 'Session expired, please log in again.',
        type: ToastType.error,
      );
    final data = QRScanParams(
      token: appointment!.qrCode.token,
      studentId: appointment!.studentId,
      counselorId: currentUserId,
      appointmentId: appointment!.appointmentId,
    );

    controller.buttonCubit.execute(
      usecase: sl<VerifyAppointmentUsecase>(),
      params: data,
      buttonId: ButtonsUniqeKeys.verifyQR.id,
    );
  }

  void _handleScanResult(BuildContext context, String data) {
    if (_isDisposed) return;

    setState(() => _isScanning = false);
    _stopCamera();

    ScannerResultDialog.show(
      context: context,
      scannedData: data,
      appointment: appointment!,
      onScanAgain: _resetScanner,
      onDone: () async {
        await _stopCamera();
        _onVerify();
      },
      buttonCubit: controller.buttonCubit,
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
        appBar: CustomAppBar(title: 'QR Scanner'),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_routeData != null && appointment == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'QR Scanner'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Appointment Not Found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'The appointment data was not properly passed to this screen.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
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
            appBar: const CustomAppBar(title: 'QR Scanner'),
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
                  child: ScannerInstructions(),
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
          } catch (e) {
            debugPrint('Error calling success callback: $e');
          }
        }
        Navigator.of(context).pop();
        context.pop();
        return AppToast.show(
          message:
              'Session verified successfully. Appointment is now completed.',
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
