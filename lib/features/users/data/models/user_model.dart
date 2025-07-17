import 'dart:convert';
import '../../domain/entities/user.dart';
import 'other_info_model.dart';

class UserModel extends User {
  final String password;

  const UserModel({
    required super.idNumber,
    required super.email,
    required this.password,
    required super.role,
    required super.verified,
    required super.active,
    required super.firstName,
    required super.lastName,
    required super.middleName,
    required super.suffix,
    required super.gender,
    required super.dateOfBirth,
    required super.address,
    required super.contactNumber,
    required super.facebook,
    required super.otherInfo,
    required super.createdAt,
    required super.updatedAt,
    super.createdBy,
    super.updatedBy,
    super.deletedAt,
    super.deletedBy,
  });

  // helpers for value safety
  static String _getString(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    return map[key1]?.toString() ?? map[key2]?.toString() ?? '';
  }

  static bool _getBool(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  static DateTime _getDateTime(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    final value = map[key1]?.toString() ?? map[key2]?.toString();
    if (value != null && value.isNotEmpty) {
      return DateTime.parse(value);
    }
    return DateTime.now();
  }

  static DateTime? _getNullableDateTime(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    final value = map[key1]?.toString() ?? map[key2]?.toString();
    if (value != null && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  // to db (sqlite)
  Map<String, dynamic> toDb() {
    return {
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
  }

  // from localdb (sqlife)
  factory UserModel.fromDb(Map<String, dynamic> map) {
    return UserModel(
      idNumber: _getString(map, 'idNumber'),
      email: _getString(map, 'email'),
      password: _getString(map, 'password'),
      role: _getString(map, 'role'),
      verified: _getBool(map, 'verified'),
      active: _getBool(map, 'active'),
      firstName: _getString(map, 'first_name'),
      lastName: _getString(map, 'last_name'),
      middleName: _getString(map, 'middle_name'),
      suffix: _getString(map, 'suffix'),
      gender: _getString(map, 'gender'),
      dateOfBirth: _getDateTime(map, 'date_of_birth'),
      address: _getString(map, 'address'),
      contactNumber: _getString(map, 'contact_number'),
      facebook: _getString(map, 'facebook'),
      otherInfo: OtherInfoModel.fromMap(
        map['other_info'] != null
            ? jsonDecode(map['other_info'])
            : <String, dynamic>{},
      ),
      createdAt: _getDateTime(map, 'createdAt'),
      updatedAt: _getDateTime(map, 'updatedAt'),
      createdBy: _getString(map, 'createdBy'),
      updatedBy: _getString(map, 'updatedBy'),
      deletedAt: _getNullableDateTime(map, 'deletedAt'),
      deletedBy: _getString(map, 'deletedBy'),
    );
  }

  // For API (JSON format)
  Map<String, dynamic> toJson() {
    return {
      'idNumber': idNumber,
      'email': email,
      'password': password,
      'role': role,
      'verified': verified,
      'active': active,
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'suffix': suffix,
      'gender': gender,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'address': address,
      'contactNumber': contactNumber,
      'facebook': facebook,
      'otherInfo': otherInfo.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'deletedAt': deletedAt?.toIso8601String(),
      'deletedBy': deletedBy,
    };
  }

  // From API (JSON format) - handles both camelCase and snake_case
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idNumber: _getString(json, 'idNumber', 'id_number'),
      email: _getString(json, 'email'),
      password: _getString(json, 'password'),
      role: _getString(json, 'role'),
      verified: _getBool(json, 'verified'),
      active: _getBool(json, 'active'),
      firstName: _getString(json, 'firstName', 'first_name'),
      lastName: _getString(json, 'lastName', 'last_name'),
      middleName: _getString(json, 'middleName', 'middle_name'),
      suffix: _getString(json, 'suffix'),
      gender: _getString(json, 'gender'),
      dateOfBirth: _getDateTime(json, 'dateOfBirth', 'date_of_birth'),
      address: _getString(json, 'address'),
      contactNumber: _getString(json, 'contactNumber', 'contact_number'),
      facebook: _getString(json, 'facebook'),
      otherInfo: OtherInfoModel.fromMap(
        json['otherInfo'] ?? json['other_info'] ?? <String, dynamic>{},
      ),
      createdAt: _getDateTime(json, 'createdAt', 'created_at'),
      updatedAt: _getDateTime(json, 'updatedAt', 'updated_at'),
      createdBy: _getString(json, 'createdBy', 'created_by'),
      updatedBy: _getString(json, 'updatedBy', 'updated_by'),
      deletedAt: _getNullableDateTime(json, 'deletedAt', 'deleted_at'),
      deletedBy: _getString(json, 'deletedBy', 'deleted_by'),
    );
  }

  // Convert to entity (removes password)
  User toEntity() {
    return User(
      idNumber: idNumber,
      email: email,
      role: role,
      verified: verified,
      active: active,
      firstName: firstName,
      lastName: lastName,
      middleName: middleName,
      suffix: suffix,
      gender: gender,
      dateOfBirth: dateOfBirth,
      address: address,
      contactNumber: contactNumber,
      facebook: facebook,
      otherInfo: otherInfo,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdBy: createdBy,
      updatedBy: updatedBy,
      deletedAt: deletedAt,
      deletedBy: deletedBy,
    );
  }

  // Create from entity (need to add password)
  factory UserModel.fromEntity(User entity, {required String password}) {
    return UserModel(
      idNumber: entity.idNumber,
      email: entity.email,
      password: password,
      role: entity.role,
      verified: entity.verified,
      active: entity.active,
      firstName: entity.firstName,
      lastName: entity.lastName,
      middleName: entity.middleName,
      suffix: entity.suffix,
      gender: entity.gender,
      dateOfBirth: entity.dateOfBirth,
      address: entity.address,
      contactNumber: entity.contactNumber,
      facebook: entity.facebook,
      otherInfo: OtherInfoModel.fromEntity(entity.otherInfo),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      createdBy: entity.createdBy,
      updatedBy: entity.updatedBy,
      deletedAt: entity.deletedAt,
      deletedBy: entity.deletedBy,
    );
  }
}
