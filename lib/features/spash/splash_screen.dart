import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../common/networks/api_client.dart';
import '../../infrastructure/routes/app_routes.dart';
import '../auth/presentation/bloc/auth/auth_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(apiClient: ApiClient())..checkAuth(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccessState) {
            context.go(Routes.home_path);
          } else if (state is AuthFailureState) {
            context.go(Routes.buildPath(Routes.aut_path, Routes.login));
          }
        },
        child: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
