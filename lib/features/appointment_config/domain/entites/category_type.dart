import 'package:equatable/equatable.dart';

class CategoryType extends Equatable {
  final String type;
  final int duration;

  const CategoryType({
    required this.type,
    required this.duration,
  });

  factory CategoryType.fromJson(Map<String, dynamic> json) {
    return CategoryType(
      type: json['type'] as String,
      duration: json['duration'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'duration': duration,
    };
  }

  @override
  List<Object?> get props => [type, duration];
}
