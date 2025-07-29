import 'package:flutter/material.dart';

class ModalOption {
  const ModalOption({
    required this.value,
    required this.title,
    this.subtitle,
    this.icon,
  });

  final String value;
  final String title;
  final String? subtitle;
  final Widget? icon;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModalOption &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          title == other.title &&
          subtitle == other.subtitle;

  @override
  int get hashCode => value.hashCode ^ title.hashCode ^ subtitle.hashCode;

  @override
  String toString() {
    return 'ModalOption{value: $value, title: $title, subtitle: $subtitle}';
  }

  ModalOption copyWith({
    String? value,
    String? title,
    String? subtitle,
    Widget? icon,
  }) {
    return ModalOption(
      value: value ?? this.value,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
    );
  }
}
