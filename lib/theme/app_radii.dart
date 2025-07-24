import 'package:flutter/material.dart';

@immutable
class AppRadii extends ThemeExtension<AppRadii> {
  final BorderRadius small;
  final BorderRadius medium;
  final BorderRadius large;
  const AppRadii({
    required this.small,
    required this.medium,
    required this.large,
  });

  @override
  AppRadii copyWith({
    BorderRadius? small,
    BorderRadius? medium,
    BorderRadius? large,
  }) {
    return AppRadii(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
    );
  }

  @override
  AppRadii lerp(ThemeExtension<AppRadii>? other, double t) {
    if (other is! AppRadii) return this;
    return AppRadii(
      small: BorderRadius.lerp(small, other.small, t)!,
      medium: BorderRadius.lerp(medium, other.medium, t)!,
      large: BorderRadius.lerp(large, other.large, t)!,
    );
  }

  static const lightRadii = AppRadii(
    small: BorderRadius.all(Radius.circular(6)),
    medium: BorderRadius.all(Radius.circular(12)),
    large: BorderRadius.all(Radius.circular(18)),
  );
}
