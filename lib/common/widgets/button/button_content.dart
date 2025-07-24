// ignore_for_file: unused_element_parameter

part of 'custom_app_button.dart';

// ignore: unused_element
class _ButtonContent extends StatelessWidget {
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
  final Border? border;

  const _ButtonContent({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    this.iconData,
    this.buttonColor = Colors.transparent,
    this.fontWeight,
    this.iconSize,
    this.textColor,
    this.textSize,
    this.shadowColor,
    this.textDecoration = TextDecoration.none,
    this.elevation,
    this.borderRadius,
    this.buttonWidth,
    this.buttonHeight,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    this.boxShadow,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.iconPosition,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultTextColor = context.colors.textPrimary;
    final effectiveTextColor = textColor ?? defaultTextColor;
    final effectiveBorderRadius = borderRadius ?? context.radii.medium;

    return Container(
      width: buttonWidth,
      height: buttonHeight,
      decoration: BoxDecoration(
        boxShadow: boxShadow,
        border: border,
        borderRadius: effectiveBorderRadius,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          padding: EdgeInsets.zero,
          elevation: elevation,
          shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
        ),
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            children: [
              if (iconPosition == Position.left && iconData != null) ...[
                Icon(iconData, color: effectiveTextColor, size: iconSize),
                const SizedBox(width: 8),
              ],
              Text(
                buttonText,
                style: TextStyle(
                  color: effectiveTextColor,
                  fontSize: textSize,
                  fontWeight: fontWeight ?? context.weight.regular,
                  decoration: textDecoration,
                ),
              ),
              if (iconPosition == Position.right && iconData != null) ...[
                const SizedBox(width: 8),
                Icon(iconData, color: effectiveTextColor, size: iconSize),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
