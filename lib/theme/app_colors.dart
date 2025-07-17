// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color danger;
  final Color backgroundColor;
  final Color midGroundColor;
  final Color textColor;

  const AppColors({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.danger,
    required this.backgroundColor,
    required this.midGroundColor,
    required this.textColor,
  });

  @override
  AppColors copyWith({
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? danger,
    Color? backgroundColor,
    Color? midGroundColor,
    Color? textColor,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      danger: danger ?? this.danger,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      midGroundColor: midGroundColor ?? this.midGroundColor,
      textColor: textColor ?? this.textColor,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      midGroundColor: Color.lerp(midGroundColor, other.midGroundColor, t)!,
      textColor: Color.lerp(textColor, other.midGroundColor, t)!,
    );
  }

  static const lightColors = AppColors(
    primary: Color(0xFF32A616),
    secondary: Color(0xFF0F65B3),
    tertiary: Color(0xFF484848),
    danger: Color(0xFFE8322B),
    backgroundColor: Color(0xFFE6E6E6),
    midGroundColor: Color(0xFFD9D9D9),
    textColor: Color(0xFF616161),
  );
}
