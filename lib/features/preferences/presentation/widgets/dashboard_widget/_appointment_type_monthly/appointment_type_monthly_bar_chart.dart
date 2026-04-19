import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../../../../common/utils/constant.dart';
import '../../../../../../../infrastructure/theme/app_colors.dart';
import '../../../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../../appointment/data/models/appointment_model.dart';
import '../_appointment_status/appointmet_legend_item.dart';

class AppointmentTypeMonthlyBarChart extends StatelessWidget {
  final List<AppointmentModel> appointments;

  const AppointmentTypeMonthlyBarChart({
    Key? key,
    required this.appointments,
  }) : super(key: key);

  Map<int, Map<String, int>> _buildMonthlyTypeCounts() {
    final Map<int, Map<String, int>> byMonth = {};
    for (var m = 0; m < 12; m++) {
      byMonth[m] = {};
    }
    for (final a in appointments) {
      final type = a.appointmentType.trim();
      if (type.isEmpty) continue;
      final monthIndex = a.scheduledStartAt.month - 1;
      if (monthIndex < 0 || monthIndex > 11) continue;
      byMonth[monthIndex]![type] = (byMonth[monthIndex]![type] ?? 0) + 1;
    }
    return byMonth;
  }

  /// Distinct types in stable order (sorted by name). No cap so all types show; bar width scales to avoid overflow.
  List<String> _typeOrder(Map<int, Map<String, int>> monthly) {
    final set = <String>{};
    for (final types in monthly.values) {
      set.addAll(types.keys);
    }
    final list = set.toList()..sort((a, b) => a.compareTo(b));
    return list;
  }

  /// Theme-based palette for types. Add more entries here as needed for future types; legend stays in sync.
  static List<Color> _typePalette(AppColors colors) {
    return [
      colors.primary,
      colors.secondary,
      colors.warning,
      colors.error,
      colors.accent,
      colors.primary.withOpacity(0.75),
      colors.secondary.withOpacity(0.75),
      colors.warning.withOpacity(0.85),
      colors.error.withOpacity(0.85),
      colors.accent.withOpacity(0.8),
      colors.primary.withOpacity(0.6),
      colors.secondary.withOpacity(0.6),
    ];
  }

  Color _typeColor(int index, AppColors colors) {
    final palette = _typePalette(colors);
    return palette[index % palette.length];
  }

  /// Rod width so that one group (all types) fits without overflow; scales down when there are many types.
  double _rodWidth(int typeCount) {
    const barsSpace = 2.0;
    const maxGroupWidth = 36.0; // logical units per month slot
    const minRodWidth = 1.8;
    const maxRodWidth = 8.0;
    if (typeCount <= 0) return maxRodWidth;
    final totalSpace = (typeCount - 1) * barsSpace;
    final width = (maxGroupWidth - totalSpace) / typeCount;
    return width.clamp(minRodWidth, maxRodWidth);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;

    final monthly = _buildMonthlyTypeCounts();
    final typeOrder = _typeOrder(monthly);

    if (typeOrder.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(fontSize: 12, color: colors.secondary),
        ),
      );
    }

    int maxCount = 1;
    for (final types in monthly.values) {
      final total = types.values.fold<int>(0, (s, v) => s + v);
      if (total > maxCount) maxCount = total;
    }

    final interval = (maxCount / 4).ceilToDouble().clamp(1.0, double.infinity);
    final maxY = maxCount.toDouble() + (maxCount * 0.2);

    final rodWidth = _rodWidth(typeOrder.length);
    const barsSpace = 2.0;

    final barGroups = <BarChartGroupData>[
      for (var monthIndex = 0; monthIndex < 12; monthIndex++)
        BarChartGroupData(
          x: monthIndex,
          barRods: [
            for (var t = 0; t < typeOrder.length; t++)
              BarChartRodData(
                toY: (monthly[monthIndex]![typeOrder[t]] ?? 0).toDouble(),
                width: rodWidth,
                borderRadius: BorderRadius.circular(6),
                color: _typeColor(t, colors),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxY,
                  color: colors.primary.withOpacity(0.07),
                ),
              ),
          ],
          barsSpace: barsSpace,
          showingTooltipIndicators: [],
        ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RepaintBoundary(
          child: SizedBox(
            height: 200,
            child: BarChart(
            BarChartData(
              barGroups: barGroups,
              maxY: maxY,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: interval,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: colors.textPrimary.withOpacity(0.06),
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    interval: interval,
                    getTitlesWidget: (value, _) {
                      if (value != value.roundToDouble()) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: fontWeight.medium,
                          color: colors.textPrimary.withOpacity(0.5),
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: 1,
                    getTitlesWidget: (value, _) {
                      final i = value.toInt();
                      if (i < 0 || i >= shortMonth.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          shortMonth[i],
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary.withOpacity(0.7),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: colors.black.withOpacity(0.85),
                  tooltipRoundedRadius: 8,
                  tooltipPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final typeName = typeOrder[rodIndex];
                    final count = (monthly[group.x.toInt()]![typeName] ?? 0);
                    return BarTooltipItem(
                      '$typeName\n',
                      TextStyle(
                        color: colors.white,
                        fontWeight: fontWeight.bold,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: '$count appointment${count == 1 ? '' : 's'}',
                          style: TextStyle(
                            color: colors.white.withOpacity(0.85),
                            fontWeight: fontWeight.regular,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: [
            for (var t = 0; t < typeOrder.length; t++)
              AppointmentLegendItem(
                label: typeOrder[t],
                color: _typeColor(t, colors),
              ),
          ],
        ),
      ],
    );
  }
}
