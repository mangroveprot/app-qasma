import 'package:flutter/material.dart';

import '../../../theme/theme_extensions.dart';
import '../modal.dart';
import '../models/modal_option.dart';
import 'enhance_option_card.dart';

class AnimatedSelectionContent extends StatelessWidget {
  const AnimatedSelectionContent({
    super.key,
    required this.options,
    required this.title,
    this.subtitle,
    this.backButtonText = 'Back',
    this.showBackButton = true,
  });

  final List<ModalOption> options;
  final String title;
  final String? subtitle;
  final String backButtonText;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(20),
          child: ModalUI.header(
            title,
            subtitle: subtitle,
            onClose: () => Navigator.pop(context),
          ),
        ),

        // Content
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAnimatedOptionsList(context),
                const SizedBox(height: 24),
                if (showBackButton)
                  Container(
                    width: double.infinity,
                    child: ModalUI.secondaryButton(
                      text: backButtonText,
                      color: colors.black,
                      width: double.infinity,
                      height: 48,
                      backgroundColor: Colors.transparent,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                const SizedBox(height: 38),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedOptionsList(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 500 + (index * 100)),
          curve: Curves.easeOut,
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, animationValue, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * animationValue),
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 400 + (index * 100)),
                opacity: animationValue,
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: index < options.length - 1 ? 12 : 0,
                  ),
                  child: EnhancedOptionCard(
                    option: option,
                    onTap: () {
                      // Add delay for visual feedback
                      Future.delayed(
                        const Duration(milliseconds: 150),
                        () => Navigator.pop(context, option.value),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
