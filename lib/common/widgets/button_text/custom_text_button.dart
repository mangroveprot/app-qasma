import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../theme/theme_extensions.dart';
import '../bloc/button/button_cubit.dart';

enum Position { left, right }

class CustomTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;
  final Color? backgroundColor;
  final Border? border;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? loadingIndicatorColor;
  final double loadingIndicatorSize;
  final double? width;
  final double? height;
  final IconData? iconData;
  final Position? iconPosition;
  final double? iconSize;
  final Color? iconColor;
  final double? iconSpacing;
  final String? buttonId; // Add this line

  const CustomTextButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.textColor,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
    this.textDecoration = TextDecoration.none,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.padding,
    this.loadingIndicatorColor,
    this.loadingIndicatorSize = 16,
    this.width,
    this.height,
    this.iconData,
    this.iconPosition,
    this.iconSize,
    this.iconColor,
    this.iconSpacing,
    this.buttonId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ButtonCubit, ButtonState>(
      builder: (context, state) {
        final isLoading = _shouldShowLoading(state);
        final colorToUse = context.colors.textPrimary;

        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: isLoading ? null : border,
            borderRadius: borderRadius,
          ),
          child: TextButton(
            onPressed: isLoading
                ? null
                : () {
                    FocusScope.of(context).unfocus();
                    onPressed();
                  },
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: padding,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.zero,
              ),
            ),
            child: isLoading
                ? SizedBox(
                    width: loadingIndicatorSize,
                    height: loadingIndicatorSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        loadingIndicatorColor ?? textColor ?? colorToUse,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (iconData != null &&
                          iconPosition == Position.left) ...[
                        Padding(
                          padding: EdgeInsets.only(left: iconSpacing ?? 8),
                          child: Icon(
                            iconData,
                            size: iconSize,
                            color: iconColor ?? textColor ?? colorToUse,
                          ),
                        ),
                        SizedBox(width: iconSpacing ?? 4),
                      ],
                      Text(
                        text,
                        style: TextStyle(
                          color: textColor,
                          fontSize: fontSize,
                          fontWeight: fontWeight,
                          decoration: textDecoration,
                        ),
                      ),
                      if (iconData != null &&
                          iconPosition == Position.right) ...[
                        SizedBox(width: iconSpacing ?? 4),
                        Icon(
                          iconData,
                          size: iconSize,
                          color: iconColor ?? textColor ?? colorToUse,
                        ),
                      ],
                    ],
                  ),
          ),
        );
      },
    );
  }

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
