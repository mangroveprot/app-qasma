// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color primary;
  final Color secondary;
  final Color accent; // tertiary
  final Color error;
  final Color warning;
  final Color background;
  final Color surface; // midground
  final Color textPrimary;
  final Color white;
  final Color black;

  const AppColors(
      {required this.primary,
      required this.secondary,
      required this.accent,
      required this.error,
      required this.warning,
      required this.background,
      required this.surface,
      required this.textPrimary,
      required this.white,
      required this.black});

  @override
  AppColors copyWith({
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? error,
    Color? warning,
    Color? background,
    Color? surface,
    Color? textPrimary,
    Color? white,
    Color? black,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      textPrimary: textPrimary ?? this.textPrimary,
      white: white ?? this.white,
      black: black ?? this.black,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      error: Color.lerp(error, other.error, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      white: Color.lerp(white, other.white, t)!,
      black: Color.lerp(black, other.black, t)!,
    );
  }

  static const lightColors = AppColors(
    primary: Color(0xFF32A616),
    secondary: Color(0xFF0F65B3),
    accent: Color(0xFF484848),
    error: Color(0xFFE8322B),
    warning: Color(0xFFF57C00),
    background: Color(0xFFE6E6E6),
    surface: Color(0xFFD9D9D9),
    textPrimary: Color(0xFF616161),
    white: Color(0xFFFEFEFE),
    black: Colors.black87,
  );
}
