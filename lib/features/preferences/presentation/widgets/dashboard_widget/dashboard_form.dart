import 'package:flutter/material.dart';

import '../../pages/dashboard_page.dart';
import 'dashboard_stats.dart';

class DashboardForm extends StatelessWidget {
  final DashboardPageState state;
  const DashboardForm({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const DashboardStats(),
        ],
      ),
    );
  }
}
