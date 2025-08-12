import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../infrastructure/routes/app_routes.dart';
import '../../../../../theme/theme_extensions.dart';

class HomeHistoryButton extends StatelessWidget {
  const HomeHistoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;
    final radii = context.radii;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: colors.black,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: radii.large,
        ),
      ),
      onPressed: () {
        context.push(
            Routes.buildPath(Routes.appointment, Routes.appointment_history));
      },
      child: Text(
        'My History',
        style: TextStyle(
          fontSize: 14,
          fontWeight: weight.medium,
        ),
      ),
    );
  }
}
