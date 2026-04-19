import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../../../common/utils/constant.dart';
import '../../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../../appointment/data/models/appointment_model.dart';
import '../../../utils/dashboard_utils.dart';

class AppointmentLineChart extends StatelessWidget {
  final List<AppointmentModel> appointments;

  const AppointmentLineChart({Key? key, required this.appointments})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final monthlyData = DashboardUtils.getMonthlyAppointmentData(
      appointments: appointments,
    );

    int maxValue = 1;
    for (final month in shortMonth) {
      final data = monthlyData[month] ?? {};
      final total = (data['pending'] ?? 0) +
          (data['approved'] ?? 0) +
          (data['completed'] ?? 0) +
          (data['cancelled'] ?? 0);
      if (total > maxValue) maxValue = total;
    }

    List<FlSpot> spots(String key) => shortMonth
        .asMap()
        .entries
        .map((e) => FlSpot(
              e.key.toDouble(),
              (monthlyData[e.value]?[key] ?? 0).toDouble(),
            ))
        .toList();

    LineChartBarData line(String key, Color color,
        {double fillOpacity = 0.10}) {
      return LineChartBarData(
        spots: spots(key),
        isCurved: true,
        color: color,
        barWidth: 2.2,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
            radius: 3.5,
            color: colors.white,
            strokeWidth: 2,
            strokeColor: color,
          ),
        ),
        belowBarData:
            BarAreaData(show: true, color: color.withOpacity(fillOpacity)),
      );
    }

    final interval = maxValue > 4 ? (maxValue / 4).ceilToDouble() : 1.0;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (_) => FlLine(
            color: colors.textPrimary.withOpacity(0.06),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= shortMonth.length) return const Text('');
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    shortMonth[i],
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: interval,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          line('pending', colors.warning, fillOpacity: 0.12),
          line('approved', colors.primary, fillOpacity: 0.10),
          line('completed', colors.secondary, fillOpacity: 0.10),
          line('cancelled', colors.error, fillOpacity: 0.08),
        ],
        minY: 0,
        maxY: maxValue.toDouble() + (maxValue * 0.2),
      ),
    );
  }
}
