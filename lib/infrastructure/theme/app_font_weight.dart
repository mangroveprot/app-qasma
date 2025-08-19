import 'package:flutter/material.dart';

@immutable
class AppFontWeights extends ThemeExtension<AppFontWeights> {
  final FontWeight light;
  final FontWeight regular;
  final FontWeight medium;
  final FontWeight bold;

  const AppFontWeights({
    required this.light,
    required this.regular,
    required this.medium,
    required this.bold,
  });

  @override
  AppFontWeights copyWith({
    FontWeight? light,
    FontWeight? regular,
    FontWeight? medium,
    FontWeight? bold,
  }) {
    return AppFontWeights(
      light: light ?? this.light,
      regular: regular ?? this.regular,
      medium: medium ?? this.medium,
      bold: bold ?? this.bold,
    );
  }

  @override
  AppFontWeights lerp(ThemeExtension<AppFontWeights>? other, double t) {
    if (other is! AppFontWeights) return this;
    return AppFontWeights(
      light: FontWeight.lerp(light, other.light, t)!,
      regular: FontWeight.lerp(regular, other.regular, t)!,
      medium: FontWeight.lerp(medium, other.medium, t)!,
      bold: FontWeight.lerp(bold, other.bold, t)!,
    );
  }

  static const lightFontWeights = AppFontWeights(
    light: FontWeight.w200,
    regular: FontWeight.w400,
    medium: FontWeight.w500,
    bold: FontWeight.w700,
  );
}
