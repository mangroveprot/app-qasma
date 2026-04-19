import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/theme_extensions.dart';
import '../../features/appointment_config/domain/entites/category.dart';
import '../../features/appointment_config/presentation/bloc/appointment_config_cubit.dart';
import '../../features/home/presentation/widgets/home_widget/_feedback/feedback_section.dart';
import '../../infrastructure/routes/app_routes.dart';
import '../shell_refresh_scope.dart';
import '../widgets/custom_modal/info_modal_dialog.dart';
import '../widgets/models/modal_option.dart';

class NavAddButton extends StatefulWidget {
  final bool isSelected;
  final String label;
  final String currentRoute;

  const NavAddButton({
    super.key,
    required this.isSelected,
    required this.currentRoute,
    this.label = 'Add',
  });

  @override
  State<NavAddButton> createState() => _NavAddButtonState();
}

class _NavAddButtonState extends State<NavAddButton> {
  Map<String, Category> _categories = {};

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    final state = context.read<AppointmentConfigCubit>().state;
    if (state is AppointmentConfigLoadedState) {
      setState(() {
        _categories = state.config.categoryAndType ?? {};
      });
    }
  }

  List<ModalOption> generateAppointmentOptions(
      Map<String, Category> categories) {
    try {
      return categories.entries
          .map((entry) => ModalOption(
                value: entry.key,
                title: entry.key,
                subtitle: entry.value.description ?? 'No description',
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colors;

    return BlocBuilder<AppointmentConfigCubit, AppointmentConfigCubitState>(
      builder: (context, state) {
        if (state is AppointmentConfigLoadedState) {
          final newCategories = state.config.categoryAndType ?? {};
          if (_categories != newCategories) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _categories = newCategories;
                });
              }
            });
          }
        }

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              if (FeedBackSection.hasUnfinishedAppointment) {
                await InfoModalDialog.show(
                  context: context,
                  icon: Icons.event_busy_rounded,
                  title: 'Existing Appointment',
                  subtitle: 'You already have an active appointment.',
                  content: Text(
                    'You can only book a new appointment once your current '
                    'appointment has been completed or cancelled.',
                    style: TextStyle(
                      fontSize: 13,
                      color: color.textPrimary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  primaryButtonText: 'OK',
                  onPrimaryPressed: () {
                    Navigator.of(context).pop();
                  },
                );
                return;
              }

              if (FeedBackSection.hasPendingFeedback) {
                await InfoModalDialog.show(
                  context: context,
                  icon: Icons.feedback_rounded,
                  title: 'Feedback Needed',
                  subtitle:
                      'You have a completed appointment that still needs feedback.',
                  content: Text(
                    'Kindly submit feedback for your previous appointment '
                    'before scheduling a new one. This helps JRMSU-KC Guidance Office continue to its improve services for you.',
                    style: TextStyle(
                      fontSize: 13,
                      color: color.textPrimary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  primaryButtonText: 'OK',
                  onPrimaryPressed: () {
                    Navigator.of(context).pop();
                    final shellRefresh = ShellRefreshScope.of(context);
                    context.go(Routes.home_path);
                    shellRefresh?.refreshCurrent(Routes.home_path);
                  },
                );
                return;
              }

              final cubit = context.read<AppointmentConfigCubit>();
              final currentState = cubit.state;
              Map<String, Category> categories = {};

              if (currentState is AppointmentConfigLoadedState) {
                categories = currentState.config.categoryAndType ?? {};
              }

              if (categories.isEmpty &&
                  currentState is! AppointmentConfigLoadingState) {
                await cubit.manager.refreshAppointmentsConfig(cubit);
                final updatedState = cubit.state;
                if (updatedState is AppointmentConfigLoadedState) {
                  categories = updatedState.config.categoryAndType ?? {};
                }
              }

              final options = generateAppointmentOptions(categories);
              final routeToRefresh = widget.currentRoute;

              await cubit.manager.showAppointmentModal(
                context,
                options: options,
                onAppointmentSuccess: () {
                  ShellRefreshScope.of(context)?.refreshCurrent(routeToRefresh);
                },
              );
            },
            borderRadius: BorderRadius.circular(30),
            splashColor: color.white.withOpacity(0.3),
            highlightColor: color.white.withOpacity(0.2),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Icon(
                Icons.add_rounded,
                color: color.primary,
                size: 28,
              ),
            ),
          ),
        );
      },
    );
  }
}
