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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color defaultTexColor = context.colors.textPrimary;
    final List<Widget> icon =
        (iconData != null)
            ? [
              Icon(
                iconData,
                color: textColor ?? defaultTexColor,
                size: iconSize,
              ),
              const SizedBox(width: 8),
            ]
            : [];

    return Container(
      width: buttonWidth,
      height: buttonHeight,
      decoration: BoxDecoration(boxShadow: boxShadow),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          padding: EdgeInsets.zero,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? context.radii.medium,
          ),
        ),
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            children: [
              if (iconPosition == Position.left) ...icon,
              Text(
                buttonText,
                style: TextStyle(
                  color: textColor ?? defaultTexColor,
                  fontSize: textSize,
                  fontWeight: fontWeight ?? context.weight.regular,
                  decoration: textDecoration,
                ),
              ),
              if (iconPosition == Position.right) ...icon,
            ],
          ),
        ),
      ),
    );
  }
}
