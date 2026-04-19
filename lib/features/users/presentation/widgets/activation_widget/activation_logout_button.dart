import 'package:flutter/material.dart';

import '../../controller/activation_controller.dart';

class ActivationLogoutButton extends StatelessWidget {
  final ActivationController controller;

  const ActivationLogoutButton({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => controller.handleLogout(context),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.logout_rounded,
                size: 12,
                color: Color(0xFF6B7280),
              ),
              SizedBox(width: 5),
              Text(
                'Sign out',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
