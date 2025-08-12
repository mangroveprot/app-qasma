import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../theme/theme_extensions.dart';
import '../bloc/button/button_cubit.dart';

part 'button_content.dart';
part 'button_content_loading.dart';

enum Position { left, right }

enum BorderSide { top, bottom, left, right, all }

class CustomAppButton extends StatelessWidget {
  final VoidCallback? onPressedCallback;
  final String labelText;
  final IconData? icon;
  final Position? iconPosition;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? labelTextColor;
  final TextDecoration? labelTextDecoration;
  final double? labelFontSize;
  final FontWeight? labelFontWeight;
  final Color? shadowColor;
  final double? elevation;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final MainAxisAlignment contentAlignment;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadows;
  final Color? loadingSpinnerColor;
  final double loadingSpinnerSize;
  final Color? disabledBackgroundColor;
  final Border? border;
  final String? buttonId; // Add this line

  const CustomAppButton({
    Key? key,
    required this.onPressedCallback,
    required this.labelText,
    this.icon,
    this.iconPosition,
    this.iconSize = 22,
    this.backgroundColor = Colors.transparent,
    this.labelTextColor,
    this.labelTextDecoration = TextDecoration.none,
    this.labelFontSize = 16,
    this.labelFontWeight,
    this.shadowColor,
    this.elevation = 0,
    this.width = double.infinity,
    this.height = 48,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    this.contentAlignment = MainAxisAlignment.center,
    this.borderRadius,
    this.boxShadows = const [],
    this.loadingSpinnerColor,
    this.loadingSpinnerSize = 20,
    this.disabledBackgroundColor = Colors.transparent,
    this.border,
    this.buttonId, // Add this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ButtonCubit, ButtonState>(
      builder: (context, state) {
        final isButtonLoading = _shouldShowLoading(state);

        if (isButtonLoading) {
          return _ButtonContentLoading(
            buttonText: labelText,
            iconData: icon,
            iconPosition: iconPosition,
            iconSize: iconSize,
            buttonColor: backgroundColor,
            textColor: labelTextColor,
            textDecoration: labelTextDecoration,
            textSize: labelFontSize,
            fontWeight: labelFontWeight,
            shadowColor: shadowColor,
            elevation: elevation,
            buttonWidth: width,
            buttonHeight: height,
            padding: padding,
            mainAxisAlignment: contentAlignment,
            borderRadius: borderRadius,
            boxShadow: boxShadows,
            loadingIndicatorColor: loadingSpinnerColor,
            loadingIndicatorSize: loadingSpinnerSize,
            disabledBackgroundColor: disabledBackgroundColor,
          );
        }

        return _ButtonContent(
          onPressed: onPressedCallback,
          buttonText: labelText,
          iconData: icon,
          iconPosition: iconPosition,
          iconSize: iconSize,
          buttonColor: backgroundColor,
          textColor: labelTextColor,
          textDecoration: labelTextDecoration,
          textSize: labelFontSize,
          fontWeight: labelFontWeight,
          shadowColor: shadowColor,
          elevation: elevation,
          buttonWidth: width,
          buttonHeight: height,
          padding: padding,
          mainAxisAlignment: contentAlignment,
          borderRadius: borderRadius,
          boxShadow: boxShadows,
          border: border,
        );
      },
    );
  }

  /// Determines if this button should show loading state
  bool _shouldShowLoading(ButtonState state) {
    if (state is! ButtonLoadingState) return false;

    // If no buttonId on state = all buttons load
    // If no buttonId on widget = react to all states
    // If both have IDs = only load if they match
    return state.buttonId == null ||
        buttonId == null ||
        state.buttonId == buttonId;
  }
}
