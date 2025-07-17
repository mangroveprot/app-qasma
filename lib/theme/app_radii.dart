import 'package:flutter/material.dart';

@immutable
class AppRadii extends ThemeExtension<AppRadii> {
  final BorderRadius small;
  final BorderRadius medium;

  const AppRadii({required this.small, required this.medium});

  @override
  AppRadii copyWith({BorderRadius? small, BorderRadius? medium}) {
    return AppRadii(small: small ?? this.small, medium: medium ?? this.medium);
  }

  @override
  AppRadii lerp(ThemeExtension<AppRadii>? other, double t) {
    if (other is! AppRadii) return this;
    return AppRadii(
      small: BorderRadius.lerp(small, other.small, t)!,
      medium: BorderRadius.lerp(medium, other.medium, t)!,
    );
  }

  static const lightRadii = AppRadii(
    small: BorderRadius.all(Radius.circular(6)),
    medium: BorderRadius.all(Radius.circular(10)),
  );
}
