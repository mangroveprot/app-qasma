import 'package:flutter/material.dart';
import '_appointment_status/appointment_line_chart.dart';

import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../config/appointment_stats_data.dart';
import '../../models/appointment_filter_model.dart';
import '_appointment_status/appointment_stats_item.dart';
import '_appointment_status/appointmet_legend_item.dart';

class DashboardAppointments extends StatefulWidget {
  final List<AppointmentStatsData> data;
  final List<AppointmentModel> appointments;
  final AppointmentFilterModel? filter;
  final VoidCallback? onFilterPressed;
  final VoidCallback? onDownloadPressed;

  const DashboardAppointments({
    Key? key,
    required this.data,
    required this.appointments,
    this.filter,
    this.onFilterPressed,
    this.onDownloadPressed,
  }) : super(key: key);

  @override
  _DashboardAppointmentsState createState() => _DashboardAppointmentsState();
}

class _DashboardAppointmentsState extends State<DashboardAppointments> {
  int get totalAppointments =>
      widget.data.fold(0, (sum, item) => sum + item.count);

  Color _statusColor(String label) {
    final colors = context.colors;
    final lower = label.toLowerCase();
    if (lower.contains('pending')) return colors.warning;
    if (lower.contains('approved')) return colors.primary;
    if (lower.contains('completed')) return colors.secondary;
    if (lower.contains('cancelled')) return colors.error;
    return colors.textPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radii;
    final fontWeight = context.weight;
    final filterCount = widget.filter?.activeFilterCount ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: colors.white,
            borderRadius: radius.medium,
            boxShadow: [
              BoxShadow(
                color: colors.black.withOpacity(0.07),
                spreadRadius: 0,
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: colors.surface, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Appointments Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: fontWeight.bold,
                      color: colors.black.withOpacity(0.8),
                      letterSpacing: -0.2,
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onFilterPressed,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: filterCount > 0
                              ? colors.primary.withOpacity(0.08)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: filterCount > 0
                                ? colors.primary.withOpacity(0.3)
                                : colors.textPrimary.withOpacity(0.25),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.filter_list_rounded,
                              size: 18,
                              color: filterCount > 0
                                  ? colors.primary
                                  : colors.textPrimary.withOpacity(0.7),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Filter',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: filterCount > 0
                                    ? colors.primary
                                    : colors.textPrimary.withOpacity(0.85),
                              ),
                            ),
                            if (filterCount > 0) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  filterCount.toString(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: colors.white,
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
              const SizedBox(height: 14),

              // Total count
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$totalAppointments',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: colors.black,
                      ),
                    ),
                    TextSpan(
                      text: ' Total Appointments',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: fontWeight.medium,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Chart (RepaintBoundary reduces repaint cost when scrolling)
              RepaintBoundary(
                child: SizedBox(
                  height: 180,
                  child: AppointmentLineChart(appointments: widget.appointments),
                ),
              ),
              const SizedBox(height: 12),

              // Legend
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  AppointmentLegendItem(
                      label: 'Pending', color: colors.warning),
                  AppointmentLegendItem(
                      label: 'Approved', color: colors.primary),
                  AppointmentLegendItem(
                      label: 'Completed', color: colors.secondary),
                  AppointmentLegendItem(
                      label: 'Cancelled', color: colors.error),
                ],
              ),
              const SizedBox(height: 18),

              // Stats list
              Column(
                children: widget.data.asMap().entries.map((entry) {
                  return AppointmentStatsItem(
                    item: entry.value,
                    color: _statusColor(entry.value.label),
                    isLast: entry.key == widget.data.length - 1,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
