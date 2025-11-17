import 'package:equatable/equatable.dart';

import 'category_type.dart';

class Category extends Equatable {
  final String? description;
  final List<CategoryType> types;

  const Category({
    this.description,
    required this.types,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      description: json['description'] as String?,
      types: (json['types'] as List<dynamic>)
          .map((e) => CategoryType.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'types': types.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [description, types];
}
