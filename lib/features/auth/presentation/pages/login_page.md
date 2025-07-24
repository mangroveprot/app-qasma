```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/helpers/spacing.dart';
import '../../../../common/utils/form_field_config.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../common/widgets/button/custom_app_button.dart';
import '../../../../common/widgets/custom_form_field.dart';
import '../../../../theme/theme_extensions.dart';
import '../widgets/custom_password_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _idNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formCubit = context.read<FormCubit>();

    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5), // Light gray background
      body: BlocListener<ButtonCubit, ButtonState>(
        listener: (context, state) {
          if (state is ButtonSuccessState) {
            // Handle successful login
            // Navigate to home or dashboard
          }
          if (state is ButtonFailureState) {
            // formCubit.setFieldError(
            //   field_idNumber.field_key,
            //   state.errorMessages,
            // );
          }
        },
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 60),

                        // Logo Section
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.school,
                            size: 60,
                            color: Color(0xFF4CAF50),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // University Name
                        const Text(
                          'JOSE RIZAL MEMORIAL STATE UNIVERSITY',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4CAF50), // Green color
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // App Title
                        const Text(
                          'QR CODE-ENABLED\nAPPOINTMENT AND\nSCHEDULING MANAGER\nAPPLICATION',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF424242), // Dark gray
                            height: 1.3,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Campus Info
                        const Text(
                          'KATIPUNAN CAMPUS, Z.N',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFFFA726), // Orange color
                            letterSpacing: 1.0,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Student Label
                        const Text(
                          'STUDENT',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF424242),
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Form Fields Container
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // ID Number Field
                              CustomFormField(
                                field_key: field_idNumber.field_key,
                                name: 'Enter ID Number',
                                hint: 'Enter ID Number',
                                controller: _idNumberController,
                                required: true,
                              ),

                              const SizedBox(height: 16),

                              // Password Field
                              CustomPasswordField(
                                field_key: field_password.field_key,
                                name: 'Enter Password',
                                hint: 'Enter Password',
                                controller: _passwordController,
                                showPasswordRule: false,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Login Button
                        Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton(
                            onPressed: () {
                              final isValid = formCubit.validateAll({
                                field_idNumber.field_key:
                                    _idNumberController.text,
                                field_password.field_key:
                                    _passwordController.text,
                              });

                              if (!isValid) return;

                              // Handle login logic here
                              // context.read<ButtonCubit>().execute(
                              //   usecase: null, // Add your login usecase here
                              //   params: {
                              //     'idNumber': _idNumberController.text,
                              //     'password': _passwordController.text,
                              //   },
                              // );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50), // Green
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'LOGIN',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Forgot Password
                        TextButton(
                          onPressed: () {
                            // Handle forgot password
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
                        ),

                        // Spacer to push Create Account button to bottom
                        //   const Spacer(),

                        // Create New Account Button
                        // Container(
                        //   width: double.infinity,
                        //   height: 50,
                        //   margin: const EdgeInsets.only(
                        //     left: 16,
                        //     right: 16,
                        //     bottom: 30,
                        //   ),
                        //   child: OutlinedButton(
                        //     onPressed: () {
                        //       context.push('/auth/get-started');
                        //     },
                        //     style: OutlinedButton.styleFrom(
                        //       foregroundColor: const Color(0xFF424242),
                        //       side: const BorderSide(
                        //         color: Color(0xFF424242),
                        //         width: 1.5,
                        //       ),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(8),
                        //       ),
                        //     ),
                        //     child: const Text(
                        //       'Create New Account',
                        //       style: TextStyle(
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.w500,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

```
