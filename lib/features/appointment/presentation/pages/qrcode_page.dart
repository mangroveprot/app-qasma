import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';

import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/app_toast.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isFlashOn = false;
  bool hasScanned = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ButtonCubit(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: const CustomAppBar(
          title: 'Scan QR Code',
          backgroundColor: Colors.black,
        ),
        body: BlocListener<ButtonCubit, ButtonState>(
          listener: _handleButtonState,
          child: Stack(
            children: [
              // QR Scanner View
              QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.white,
                  borderRadius: 16,
                  borderLength: 30,
                  borderWidth: 8,
                  cutOutSize: 280,
                ),
                onPermissionSet: (ctrl, p) =>
                    _onPermissionSet(context, ctrl, p),
              ),

              // Top instruction overlay
              Positioned(
                top: 40,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Position the QR code within the frame',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // Scanning line animation
              if (!hasScanned)
                Positioned.fill(
                  child: Center(
                    child: SizedBox(
                      width: 280,
                      height: 280,
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: ScanningLinePainter(_animation.value),
                          );
                        },
                      ),
                    ),
                  ),
                ),

              // Bottom controls
              Positioned(
                bottom: 60,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Flash toggle
                    _buildControlButton(
                      icon: isFlashOn ? Icons.flash_on : Icons.flash_off,
                      onTap: _toggleFlash,
                    ),

                    // Scan again button
                    if (hasScanned)
                      _buildControlButton(
                        icon: Icons.refresh,
                        onTap: _resetScanner,
                      ),
                  ],
                ),
              ),

              // Success overlay
              if (hasScanned)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 80,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'QR Code Scanned!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!hasScanned && scanData.code != null) {
        setState(() {
          hasScanned = true;
        });
        _handleQRCodeScanned(scanData.code!);
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      AppToast.show(
        message: 'Camera permission is required to scan QR codes',
        type: ToastType.error,
      );
    }
  }

  void _handleQRCodeScanned(String qrCode) {
    controller?.pauseCamera();
    _animationController.stop();

    AppToast.show(
      message: 'QR Code scanned successfully!',
      type: ToastType.success,
    );

    // Delay to show success animation
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pop(qrCode);
      }
    });
  }

  Future<void> _toggleFlash() async {
    if (controller != null) {
      await controller!.toggleFlash();
      setState(() {
        isFlashOn = !isFlashOn;
      });
    }
  }

  void _resetScanner() {
    setState(() {
      hasScanned = false;
    });
    _animationController.repeat(reverse: true);
    controller?.resumeCamera();
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    controller?.dispose();
    super.dispose();
  }
}

class ScanningLinePainter extends CustomPainter {
  final double animationValue;

  ScanningLinePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.withOpacity(0.8)
      ..strokeWidth = 3;

    final lineY = size.height * animationValue;

    canvas.drawLine(
      Offset(20, lineY),
      Offset(size.width - 20, lineY),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
