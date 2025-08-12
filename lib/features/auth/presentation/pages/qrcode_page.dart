import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../appointment/domain/entities/qrcode.dart';

class QrCodePage extends StatefulWidget {
  final QRCode qrData;
  const QrCodePage({super.key, required this.qrData});

  @override
  State<QrCodePage> createState() => QrCodePageState();
}

class QrCodePageState extends State<QrCodePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ButtonCubit(),
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Share QR Code',
        ),
        body: BlocListener<ButtonCubit, ButtonState>(
          listener: _handleButtonState,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // QR Code Container
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: QrImage(
                    data: widget.qrData.token.toString(),
                    version: QrVersions.auto,
                    size: 200.0,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    errorCorrectionLevel: QrErrorCorrectLevel.M,
                  ),
                ),

                const SizedBox(height: 24),

                // Description text
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Share this QR code to your counsellor.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
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
  }
}
