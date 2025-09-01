import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/_base/_services/storage/shared_preference.dart';
import '../../infrastructure/routes/app_routes.dart';
import '../../infrastructure/theme/theme_extensions.dart';
import '../auth/presentation/bloc/auth/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  final currentUserFirstName =
      SharedPrefs().getString('currentUserFirstName') ?? '';

  Future<void> _initializeApp() async {
    try {
      await Future.wait([
        _performAuthCheck(),
        Future.delayed(const Duration(seconds: 2)),
      ]);

      if (mounted) {
        _navigateBasedOnCurrentAuthState();
      }
    } catch (e) {
      if (mounted) {
        context.go(Routes.buildPath(Routes.aut_path, Routes.login));
      }
    }
  }

  Future<void> _performAuthCheck() async {
    await AuthCubit.instance.checkAuth();
  }

  void _navigateBasedOnCurrentAuthState() {
    final currentState = AuthCubit.instance.state;

    if (currentState is AuthSuccessState) {
      if (currentUserFirstName.isEmpty) {
        context.go(Routes.common);
      } else {
        context.go(Routes.home_path);
      }
    } else if (currentState is AuthFailureState) {
      context.go(Routes.buildPath(Routes.aut_path, Routes.login));
    } else {
      context.go(Routes.buildPath(Routes.aut_path, Routes.login));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.white,
      body: BlocListener<AuthCubit, AuthState>(
        bloc: AuthCubit.instance,
        listener: (context, state) {
          if (state is AutoLogoutState) {
            context.go(Routes.buildPath(Routes.aut_path, Routes.login));
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [context.shadows.light],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.webp',
                    fit: BoxFit.cover,
                    cacheWidth: 104,
                    cacheHeight: 104,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              CircularProgressIndicator(color: colors.textPrimary),
              const SizedBox(height: 20),
              Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 16,
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
