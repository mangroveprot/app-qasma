import 'package:flutter/material.dart';
import 'dart:async';

import 'package:go_router/go_router.dart';

import '../../../../../infrastructure/routes/app_routes.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class CompletionScreen extends StatefulWidget {
  const CompletionScreen({Key? key}) : super(key: key);

  @override
  State<CompletionScreen> createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<CompletionScreen>
    with SingleTickerProviderStateMixin {
  bool _isVisible = false;
  bool _showRedirectButton = false;
  bool _isRedirecting = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    Timer(const Duration(milliseconds: 200), () {
      setState(() {
        _isVisible = true;
      });
      _animationController.forward();
    });

    Timer(const Duration(seconds: 3), () {
      _attemptRedirect();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _attemptRedirect() {
    if (context.canPop() || mounted) {
      context.go(Routes.root);
    } else {
      setState(() {
        _isRedirecting = false;
        _showRedirectButton = true;
      });
    }
  }

  void _handleManualRedirect() {
    context.go(Routes.root);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.primary.withOpacity(0.1),
              colors.secondary.withOpacity(0.1)
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: _isVisible ? 1.0 : 0.0),
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.elasticOut,
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: colors.white,
                                  size: 32,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Title
                        Text(
                          'Profile Complete!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Description
                        Text(
                          'Your profile has been set up successfully. Welcome aboard!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 24),

                        if (_isRedirecting)
                          Column(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colors.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Taking you to homepage...',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                        if (_showRedirectButton)
                          GestureDetector(
                            onTap: _handleManualRedirect,
                            child: Text(
                              'Redirect',
                              style: TextStyle(
                                color: colors.primary,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
