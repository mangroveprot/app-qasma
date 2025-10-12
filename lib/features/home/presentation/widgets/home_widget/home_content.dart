import 'package:flutter/material.dart';
import '../../../../../common/helpers/spacing.dart';
import '../../../../../theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../pages/home_page.dart';
import 'home_appointment_list.dart';
import 'home_greeting.dart';

// Loading State
class LoadingContent extends StatelessWidget {
  const LoadingContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

// Loaded State
class LoadedContent extends StatelessWidget {
  final String userName;
  final HomePageState state;
  final List<AppointmentModel> appointments;
  final Future<void> Function() onRefresh;
  final void Function(String) onCancel;
  final void Function(String) onReschedule;

  const LoadedContent({
    Key? key,
    required this.appointments,
    required this.onRefresh,
    required this.onCancel,
    required this.onReschedule,
    required this.userName,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeGreetingCard(
          userName: userName,
          appointments: appointments,
        ),
        Spacing.verticalSmall,
        Expanded(
          child: appointments.isEmpty
              ? EmptyContent(onRefresh: onRefresh)
              : RefreshIndicator(
                  onRefresh: onRefresh,
                  child: HomeAppointmentList(
                    appointments: appointments,
                    state: state,
                    onCancel: onCancel,
                    onReschedule: onReschedule,
                  ),
                ),
        ),
      ],
    );
  }
}

// Error State
class ErrorContent extends StatelessWidget {
  final String error;
  final String userName;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final bool isRefreshing;

  const ErrorContent({
    Key? key,
    required this.error,
    required this.onRefresh,
    required this.onRetry,
    required this.isRefreshing,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: ScrollableContent(
              icon: Icons.error_outline,
              title: 'Failed to load appointments',
              subtitle: error,
              action: ElevatedButton(
                onPressed: isRefreshing ? null : onRetry,
                child: isRefreshing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Retry'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Empty State
class EmptyContent extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const EmptyContent({
    Key? key,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 60),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.textPrimary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_today_outlined,
              size: 58,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'No appointments yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          Spacing.verticalMedium,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tap the ',
                style: TextStyle(color: colors.textPrimary),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colors.textPrimary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  color: colors.white,
                  size: 14,
                ),
              ),
              Text(
                ' button to book an appointment',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Reusable Scrollable Content
class ScrollableContent extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;

  const ScrollableContent({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: constraints.maxHeight,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 64,
                        color: colors.textPrimary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        title,
                        style: TextStyle(
                          color: colors.black.withOpacity(0.8),
                          fontWeight: fontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colors.textPrimary,
                            ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (action != null) ...[
                        const SizedBox(height: 24),
                        action!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
