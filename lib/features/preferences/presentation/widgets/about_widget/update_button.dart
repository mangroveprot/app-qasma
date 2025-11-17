import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/manager/update_manager.dart';
import '../../../../../common/widgets/toast/app_toast.dart';
import '../../../../../theme/theme_extensions.dart';
import '../../../../update/presentation/bloc/update_cubit.dart';
import '../../../../update/presentation/bloc/update_cubit_helpers.dart';
import '../../pages/about_page.dart';

class UpdateButton extends StatefulWidget {
  final AboutPageState state;

  const UpdateButton({Key? key, required this.state}) : super(key: key);

  @override
  State<UpdateButton> createState() => _UpdateButtonState();
}

class _UpdateButtonState extends State<UpdateButton> {
  bool _hasCheckedManually = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocConsumer<UpdateCubit, UpdateCubitState>(
      listener: (context, updateState) {
        if (!_hasCheckedManually) return;

        if (updateState is UpdateAvailable ||
            updateState is UpdateNotAvailable) {
          UpdateManager.handleUpdateStateChanges(
            context,
            updateState,
            isManualCheck: true,
          );
        }

        if (updateState is UpdateCheckFailed) {
          final errMessage =
              UpdateErrorHelper.getFriendlyMessage(updateState.message);
          AppToast.show(
            message: errMessage,
            type: ToastType.error,
            duration: const Duration(seconds: 8),
          );
        }
      },
      builder: (context, updateState) {
        final isLoading = updateState is UpdateChecking;
        final hasUpdate = updateState is UpdateAvailable;

        return Container(
          decoration: BoxDecoration(
            color: colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colors.white),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            title: Text(
              'Check for updates',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 15,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(colors.textPrimary),
                    ),
                  )
                else ...[
                  if (hasUpdate) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: colors.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'New',
                        style: TextStyle(
                          color: colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Icon(Icons.chevron_right, color: colors.textPrimary),
                ],
              ],
            ),
            onTap: isLoading
                ? null
                : () {
                    setState(() {
                      _hasCheckedManually = true;
                    });

                    widget.state.controller.updateManager.reset();
                    context.read<UpdateCubit>().forceCheck();
                  },
          ),
        );
      },
    );
  }
}
