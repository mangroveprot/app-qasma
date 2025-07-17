import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../theme/theme_extensions.dart';
import '../bloc/button/button_cubit.dart';

part 'button_content.dart';
part 'button_content_loading.dart';

enum Position { left, right }

class CustomAppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final IconData? iconData;
  final Position? iconPosition;
  final double? iconSize;
  final Color? buttonColor;
  final Color? textColor;
  final TextDecoration? textDecoration;
  final double? textSize;
  final FontWeight? fontWeight;
  final Color? shadowColor;
  final double? elevation;
  final double? buttonWidth;
  final double? buttonHeight;
  final EdgeInsetsGeometry padding;
  final MainAxisAlignment mainAxisAlignment;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Color? loadingIndicatorColor;
  final double loadingIndicatorSize;
  final Color? disabledBackgroundColor;

  const CustomAppButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    this.iconData,
    this.buttonColor = Colors.transparent,
    this.fontWeight,
    this.iconSize = 22,
    this.textColor,
    this.textSize = 16,
    this.shadowColor,
    this.textDecoration = TextDecoration.none,
    this.elevation = 0,
    this.borderRadius,
    this.buttonWidth = double.infinity,
    this.buttonHeight = 48,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    this.boxShadow = const [],
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.iconPosition,
    this.loadingIndicatorColor,
    this.loadingIndicatorSize = 20,
    this.disabledBackgroundColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ButtonCubit, ButtonState>(
      builder: (context, state) {
        if (state is ButtonLoadingState) {
          return _ButtonContentLoading(
            buttonText: buttonText,
            iconData: iconData,
            buttonColor: buttonColor,
            fontWeight: fontWeight,
            iconSize: iconSize,
            textColor: textColor,
            textSize: textSize,
            shadowColor: shadowColor,
            textDecoration: textDecoration,
            elevation: elevation,
            borderRadius: borderRadius,
            buttonWidth: buttonWidth,
            buttonHeight: buttonHeight,
            padding: padding,
            boxShadow: boxShadow,
            mainAxisAlignment: mainAxisAlignment,
            iconPosition: iconPosition,
            loadingIndicatorColor: loadingIndicatorColor,
            loadingIndicatorSize: loadingIndicatorSize,
            disabledBackgroundColor: disabledBackgroundColor,
          );
        }
        return _ButtonContent(
          onPressed: onPressed,
          buttonText: buttonText,
          iconData: iconData,
          buttonColor: buttonColor,
          fontWeight: fontWeight,
          iconSize: iconSize,
          textColor: textColor,
          textSize: textSize,
          shadowColor: shadowColor,
          textDecoration: textDecoration,
          elevation: elevation,
          borderRadius: borderRadius,
          buttonWidth: buttonWidth,
          buttonHeight: buttonHeight,
          padding: padding,
          boxShadow: boxShadow,
          mainAxisAlignment: mainAxisAlignment,
          iconPosition: iconPosition,
        );
      },
    );
  }
}
