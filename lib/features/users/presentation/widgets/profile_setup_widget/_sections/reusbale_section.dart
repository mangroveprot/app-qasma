import 'package:flutter/material.dart';

import '../../../../../../common/widgets/button_text/custom_text_button.dart';
import '../../../../../../infrastructure/theme/theme_extensions.dart';

class StepHeader extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;

  const StepHeader({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 40),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class CustomProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const CustomProgressIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep + 1) / totalSteps;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step ${currentStep + 1} of $totalSteps',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ],
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ReviewCard({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class NavigationButtons extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onComplete;

  const NavigationButtons({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    this.onPrevious,
    this.onNext,
    this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentStep == totalSteps - 1;
    final colors = context.colors;
    final radius = context.radii;

    return Builder(builder: (context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: currentStep == 0 ? null : onPrevious,
            child: const Text('Back'),
          ),
          CustomTextButton(
            onPressed: isLastStep ? onComplete : onNext,
            text: isLastStep ? 'Complete Setup' : 'Next',
            backgroundColor: isLastStep ? colors.primary : colors.secondary,
            textColor: colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            borderRadius: radius.medium,
          ),
        ],
      );
    });
  }
}
