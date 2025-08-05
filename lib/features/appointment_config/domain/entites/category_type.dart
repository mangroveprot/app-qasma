import 'package:equatable/equatable.dart';

class CategoryType extends Equatable {
  final String type;
  final int duration;

  const CategoryType({
    required this.type,
    required this.duration,
  });

  @override
  List<Object?> get props => [type, duration];
}
