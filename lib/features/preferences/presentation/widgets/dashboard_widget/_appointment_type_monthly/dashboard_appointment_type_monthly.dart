import 'package:flutter/material.dart';

import '../../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../../appointment/data/models/appointment_model.dart';
import '../../../models/appointment_filter_model.dart';
import 'appointment_category_breakdown.dart';
import 'appointment_type_monthly_bar_chart.dart';

/// Dashboard card: "Appointments by Type & Month" with year filter, chart, and category breakdown.
class DashboardAppointmentTypeMonthly extends StatefulWidget {
  final List<AppointmentModel> appointments;
  final AppointmentFilterModel? filter;
  final VoidCallback? onFilterPressed;

  const DashboardAppointmentTypeMonthly({
    Key? key,
    required this.appointments,
    this.filter,
    this.onFilterPressed,
  }) : super(key: key);

  @override
  State<DashboardAppointmentTypeMonthly> createState() =>
      _DashboardAppointmentTypeMonthlyState();
}

class _DashboardAppointmentTypeMonthlyState
    extends State<DashboardAppointmentTypeMonthly> {
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
  }

  List<AppointmentModel> get _appointmentsForYear => widget.appointments
      .where((a) => a.scheduledStartAt.year == _selectedYear)
      .toList();

  List<int> get _availableYears {
    final fromData = widget.appointments
        .map((a) => a.scheduledStartAt.year)
        .toSet()
        .toList()
      ..sort();
    final current = DateTime.now().year;
    if (!fromData.contains(current)) {
      fromData.add(current);
      fromData.sort();
    }
    return fromData;
  }

  void _showYearPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) {
        final colors = ctx.colors;
        final fontWeight = ctx.weight;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Text(
                  'Select year',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: fontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              ..._availableYears.reversed.map((year) {
                final isSelected = year == _selectedYear;
                return ListTile(
                  title: Text('$year'),
                  trailing: isSelected
                      ? Icon(Icons.check, color: colors.secondary, size: 22)
                      : null,
                  onTap: () {
                    setState(() => _selectedYear = year);
                    Navigator.of(ctx).pop();
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radii;
    final fontWeight = context.weight;
    final forYear = _appointmentsForYear;

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Appointments Type',
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
                      onTap: () => _showYearPicker(context),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colors.secondary.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$_selectedYear',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: colors.secondary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: colors.secondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              AppointmentTypeMonthlyBarChart(appointments: forYear),
              const SizedBox(height: 18),
              AppointmentCategoryBreakdown(appointments: forYear),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
