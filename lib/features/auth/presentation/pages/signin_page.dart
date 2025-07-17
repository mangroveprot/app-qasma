import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/button/custom_app_button.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../data/models/signin_params.dart';
import '../../domain/usecases/signin_usecase.dart';

class SigninPage extends StatelessWidget {
  SigninPage({super.key});

  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();

  Future<void> _handleLogin(BuildContext context) async {
    final usecase = sl<SigninUsecase>();

    final result = await usecase(
      param: SigninParams(
        idNumber: _emailCon.text.trim(),
        password: _passwordCon.text.trim(),
      ),
    );

    result.fold(
      (failure) {
        print('Login failed: $failure');
        final snackBar = SnackBar(content: Text(failure.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      (success) {
        print('Login successful: $success');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 100, right: 16, left: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _signin(),
            const SizedBox(height: 50),
            _emailField(),
            const SizedBox(height: 20),
            _password(),
            const SizedBox(height: 60),
            _createAccountButton(context),
            const SizedBox(height: 20),
            _signupText(context),
          ],
        ),
      ),
    );
  }

  Widget _signin() {
    return const Text(
      'Sign In',
      style: TextStyle(
        color: Color(0xff2A4ECA),
        fontWeight: FontWeight.bold,
        fontSize: 32,
      ),
    );
  }

  Widget _emailField() {
    return TextField(
      controller: _emailCon,
      decoration: const InputDecoration(hintText: 'Email'),
    );
  }

  Widget _password() {
    return TextField(
      controller: _passwordCon,
      decoration: const InputDecoration(hintText: 'Password'),
    );
  }

  Widget _createAccountButton(BuildContext context) {
    return Container();
  }

  Widget _signupText(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: "Don't you have account?",
            style: TextStyle(
              color: Color(0xff3B4054),
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: ' Sign Up',
            style: const TextStyle(
              color: Color(0xff3461FD),
              fontWeight: FontWeight.w500,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => SignupPage()),
                    // );
                  },
          ),
        ],
      ),
    );
  }
}
