import 'package:flutter/material.dart';

class LoginForgotPasswordBtn extends StatelessWidget {
  const LoginForgotPasswordBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        //TODO: Handle forgot password
      },
      child: const Text(
        'Forgot Password?',
        style: TextStyle(
          color: Color(0xFF424242),
          fontSize: 14,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
