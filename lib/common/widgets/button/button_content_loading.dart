// ignore_for_file: unused_element_parameter

part of 'custom_app_button.dart';

// ignore: unused_element
class _ButtonContentLoading extends StatelessWidget {
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

  const _ButtonContentLoading({
    Key? key,
    required this.buttonText,
    this.iconData,
    this.buttonColor,
    this.fontWeight,
    this.iconSize = 22,
    this.textColor,
    this.textSize = 16,
    this.shadowColor,
    this.textDecoration = TextDecoration.none,
    this.elevation = 0,
    this.borderRadius,
    this.buttonWidth,
    this.buttonHeight,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    this.boxShadow = const [],
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.iconPosition,
    this.loadingIndicatorColor,
    this.loadingIndicatorSize = 20,
    this.disabledBackgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color defaultTextColor = context.colors.textColor;
    final Color effectiveTextColor = textColor ?? defaultTextColor;
    final Color effectiveLoadingColor =
        loadingIndicatorColor ?? effectiveTextColor;

    final Widget loadingIndicator = SizedBox(
      width: loadingIndicatorSize,
      height: loadingIndicatorSize,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(effectiveLoadingColor),
      ),
    );

    final List<Widget> buttonContent = [];

    if (iconPosition == Position.right) {
      buttonContent.add(
        Text(
          buttonText,
          style: TextStyle(
            color: effectiveTextColor,
            fontSize: textSize,
            fontWeight: fontWeight ?? context.weight.regular,
          ),
        ),
      );
      buttonContent.add(const SizedBox(width: 8));
      buttonContent.add(loadingIndicator);
    } else {
      buttonContent.add(loadingIndicator);
      buttonContent.add(const SizedBox(width: 8));
      buttonContent.add(
        Text(
          buttonText,
          style: TextStyle(
            color: effectiveTextColor,
            fontSize: textSize,
            fontWeight: fontWeight ?? context.weight.regular,
          ),
        ),
      );
    }

    return Container(
      width: buttonWidth,
      height: buttonHeight,
      decoration: BoxDecoration(boxShadow: boxShadow),
      child: ElevatedButton(
        onPressed: null, // always disabled
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: disabledBackgroundColor,
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
            children: buttonContent,
          ),
        ),
      ),
    );
  }
}
