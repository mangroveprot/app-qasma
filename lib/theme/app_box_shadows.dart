import 'package:flutter/material.dart';

@immutable
class AppBoxShadow extends ThemeExtension<AppBoxShadow> {
  final BoxShadow light;
  final BoxShadow heavy;

  const AppBoxShadow({required this.light, required this.heavy});

  @override
  AppBoxShadow copyWith({BoxShadow? light, BoxShadow? heavy}) {
    return AppBoxShadow(light: light ?? this.light, heavy: heavy ?? this.heavy);
  }

  @override
  AppBoxShadow lerp(ThemeExtension<AppBoxShadow>? other, double t) {
    if (other is! AppBoxShadow) return this;
    return AppBoxShadow(
      light: BoxShadow.lerp(light, other.light, t)!,
      heavy: BoxShadow.lerp(heavy, other.heavy, t)!,
    );
  }

  static const lightShadows = AppBoxShadow(
    light: BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      blurRadius: 6,
      offset: Offset(0, 3),
    ),
    heavy: BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.25),
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  );
}
