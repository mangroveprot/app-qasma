import 'dart:convert';

import 'other_info_model.dart';

class UserModel {
  final String idNumber;
  final String email;
  final String password;
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
  final OtherInfoModel otherInfo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? deletedAt;
  final String? deletedBy;

  UserModel({
    required this.idNumber,
    required this.email,
    required this.password,
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

  Map<String, dynamic> toDb() => {
    'idNumber': idNumber,
    'email': email,
    'password': password,
    'role': role,
    'verified': verified ? 1 : 0,
    'active': active ? 1 : 0,
    'first_name': firstName,
    'last_name': lastName,
    'middle_name': middleName,
    'suffix': suffix,
    'gender': gender,
    'date_of_birth': dateOfBirth.toIso8601String(),
    'address': address,
    'contact_number': contactNumber,
    'facebook': facebook,
    'other_info': jsonEncode(otherInfo.toMap()),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'createdBy': createdBy,
    'updatedBy': updatedBy,
    'deletedAt': deletedAt?.toIso8601String(),
    'deletedBy': deletedBy,
  };

  factory UserModel.fromDb(Map<String, dynamic> map) => UserModel(
    idNumber: map['idNumber'],
    email: map['email'],
    password: map['password'],
    role: map['role'],
    verified: (map['verified'] ?? 0) == 1,
    active: (map['active'] ?? 0) == 1,
    firstName: map['first_name'],
    lastName: map['last_name'],
    middleName: map['middle_name'],
    suffix: map['suffix'],
    gender: map['gender'],
    dateOfBirth: DateTime.parse(map['date_of_birth']),
    address: map['address'],
    contactNumber: map['contact_number'],
    facebook: map['facebook'],
    otherInfo: OtherInfoModel.fromMap(jsonDecode(map['other_info'])),
    createdAt: DateTime.parse(map['createdAt']),
    updatedAt: DateTime.parse(map['updatedAt']),
    createdBy: map['createdBy'],
    updatedBy: map['updatedBy'],
    deletedAt:
        map['deletedAt'] != null ? DateTime.tryParse(map['deletedAt']) : null,
    deletedBy: map['deletedBy'],
  );
}
