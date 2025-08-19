import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../infrastructure/theme/theme_extensions.dart';
import '../bloc/connections/connection_cubit.dart';

class ConnectionBanner extends StatefulWidget {
  final Widget child;

  const ConnectionBanner({super.key, required this.child});

  @override
  State<ConnectionBanner> createState() => _ConnectionBannerState();
}

class _ConnectionBannerState extends State<ConnectionBanner> {
  bool showConnectedBanner = false;
  bool wasOffline = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;

    return BlocListener<ConnectionCubit, ConnectionCubitState>(
      listener: (context, state) {
        if (state is ConnectionOnline && wasOffline) {
          setState(() => showConnectedBanner = true);

          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) setState(() => showConnectedBanner = false);
          });
        }
        wasOffline = state is ConnectionOffline;
      },
      child: BlocBuilder<ConnectionCubit, ConnectionCubitState>(
        builder: (context, state) {
          final isOffline = state is ConnectionOffline;
          final showBanner = isOffline || showConnectedBanner;

          return Scaffold(
            body: Stack(
              children: [
                widget.child,
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  left: 16,
                  right: 16,
                  bottom: showBanner ? 16 : -80,
                  child: SafeArea(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF323232),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isOffline ? Icons.wifi_off : Icons.wifi,
                            color: colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              isOffline
                                  ? 'You are currently offline.'
                                  : 'You are connected.',
                              style: TextStyle(
                                color: colors.white,
                                fontSize: 14,
                                fontWeight: fontWeight.regular,
                              ),
                            ),
                          ),
                          if (isOffline) ...[
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () => context
                                  .read<ConnectionCubit>()
                                  .retryConnectionCheck(),
                              style: TextButton.styleFrom(
                                foregroundColor: colors.primary,
                                backgroundColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Retry',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: fontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
