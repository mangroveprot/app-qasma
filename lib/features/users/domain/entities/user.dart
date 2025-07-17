import 'package:equatable/equatable.dart';
import 'other_info.dart';

class User extends Equatable {
  final String idNumber;
  final String email;
  final String role;
  final bool verified;
  final bool active;
  final String firstName;
  final String lastName;
  final String middleName;
  final String suffix;
  final String gender;
  final DateTime dateOfBirth;
  final String address;
  final String contactNumber;
  final String facebook;
  final OtherInfo otherInfo;
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
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.suffix,
    required this.gender,
    required this.dateOfBirth,
    required this.address,
    required this.contactNumber,
    required this.facebook,
    required this.otherInfo,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
    this.deletedBy,
  });

  // helper
  String get fullName => '$firstName $lastName';
  bool get isDeleted => deletedAt != null;
  bool get canPerformActions => active && verified && !isDeleted;

  @override
  List<Object?> get props => [
    idNumber,
    email,
    role,
    verified,
    active,
    firstName,
    lastName,
    middleName,
    suffix,
    gender,
    dateOfBirth,
    address,
    contactNumber,
    facebook,
    otherInfo,
    createdAt,
    updatedAt,
    createdBy,
    updatedBy,
    deletedAt,
    deletedBy,
  ];
}
