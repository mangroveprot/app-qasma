import 'package:equatable/equatable.dart';

import 'other_info.dart';

class User extends Equatable {
  final String idNumber;
  final String email;
  final String role;
  final bool verified;
  final bool active;
  final String first_name;
  final String last_name;
  final String middle_name;
  final String suffix;
  final String gender;
  final DateTime date_of_birth;
  final String address;
  final String contact_number;
  final String facebook;
  final OtherInfo other_info;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? deletedAt;
  final String? deletedBy;

  const User({
    required this.idNumber,
    required this.email,
    required this.role,
    required this.verified,
    required this.active,
    required this.first_name,
    required this.last_name,
    required this.middle_name,
    required this.suffix,
    required this.gender,
    required this.date_of_birth,
    required this.address,
    required this.contact_number,
    required this.facebook,
    required this.other_info,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
    this.deletedBy,
  });

  // helper
  String get fullName => '$first_name $last_name';
  bool get isDeleted => deletedAt != null;
  bool get canPerformActions => active && verified && !isDeleted;

  @override
  List<Object?> get props => [
        idNumber,
        email,
        role,
        verified,
        active,
        first_name,
        last_name,
        middle_name,
        suffix,
        gender,
        date_of_birth,
        address,
        contact_number,
        facebook,
        other_info,
        createdAt,
        updatedAt,
        createdBy,
        updatedBy,
        deletedAt,
        deletedBy,
      ];
}
