import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../config/appointment_stats_data.dart';

class AppointmentsDashboard extends StatefulWidget {
  final List<AppointmentStatsData> data;
  final VoidCallback? onDownloadPressed;

  const AppointmentsDashboard({
    Key? key,
    required this.data,
    this.onDownloadPressed,
  }) : super(key: key);

  @override
  _AppointmentsDashboardState createState() => _AppointmentsDashboardState();
}

class _AppointmentsDashboardState extends State<AppointmentsDashboard> {
  int get totalAppointments =>
      widget.data.fold(0, (sum, item) => sum + item.count);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildMainCard(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMainCard() {
    final colors = context.colors;
    final radius = context.radii;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: radius.medium,
        boxShadow: [
          BoxShadow(
            color: colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: colors.surface,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),
          const SizedBox(height: 20),

          // Pie Chart
          Center(child: _buildPieChart()),
          const SizedBox(height: 32),

          // Stats List
          _buildStatsList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final colors = context.colors;
    final fontWeight = context.weight;
    return Text(
      'Appointments Status',
      style: TextStyle(
        fontSize: 16,
        fontWeight: fontWeight.bold,
        color: colors.black.withOpacity(0.8),
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildPieChart() {
    final colors = context.colors;
    final fontWeight = context.weight;
    return SizedBox(
      height: 140,
      width: 140,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 45,
              startDegreeOffset: -90,
              sections: widget.data.map((item) {
                return PieChartSectionData(
                  color: item.color,
                  value: item.percentage.toDouble(),
                  title: '',
                  radius: 18,
                  borderSide: BorderSide(
                    color: colors.white,
                    width: 2,
                  ),
                );
              }).toList(),
            ),
          ),
          // Center text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: fontWeight.medium,
                    color: colors.textPrimary,
                    height: 1.1,
                  ),
                ),
                Text(
                  '$totalAppointments',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: fontWeight.bold,
                    color: colors.black,
                    height: 1.0,
                  ),
                ),
                Text(
                  'Appointments',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: fontWeight.medium,
                    color: colors.textPrimary,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsList() {
    final colors = context.colors;
    final radius = context.radii;
    final fontWeight = context.weight;
    return Column(
      children: widget.data.asMap().entries.map((entry) {
        final int index = entry.key;
        final AppointmentStatsData item = entry.value;
        final bool isLast = index == widget.data.length - 1;

        return Container(
          margin: EdgeInsets.only(bottom: isLast ? 0 : 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.white,
            borderRadius: radius.medium,
            boxShadow: [
              BoxShadow(
                color: colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon - match stats style
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.15),
                  borderRadius: radius.small,
                ),
                child: Icon(
                  item.icon,
                  color: item.color,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),

              // Label
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: fontWeight.medium,
                    color: colors.textPrimary,
                    height: 1.1,
                  ),
                ),
              ),

              // Count and Percentage
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${item.count}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: fontWeight.bold,
                      color: colors.black,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    '${item.percentage}%',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: fontWeight.medium,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
