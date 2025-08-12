import 'dart:convert';
import '../../../../common/utils/model_utils.dart';
import '../../domain/entities/user.dart';
import 'other_info_model.dart';

class UserModel extends User {
  final String password;

  const UserModel({
    required super.idNumber,
    required super.email,
    required this.password,
    super.role = 'student',
    required super.verified,
    required super.active,
    required super.first_name,
    required super.last_name,
    required super.middle_name,
    required super.suffix,
    required super.gender,
    required super.date_of_birth,
    required super.address,
    required super.contact_number,
    required super.facebook,
    required super.other_info,
    required super.createdAt,
    required super.updatedAt,
    super.createdBy,
    super.updatedBy,
    super.deletedAt,
    super.deletedBy,
  });

  UserModel copyWith({
    String? idNumber,
    String? email,
    String? password,
    String? role,
    bool? verified,
    bool? active,
    String? first_name,
    String? last_name,
    String? middle_name,
    String? suffix,
    String? gender,
    DateTime? date_of_birth,
    String? address,
    String? contact_number,
    String? facebook,
    OtherInfoModel? other_info,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    DateTime? deletedAt,
    String? deletedBy,
  }) {
    return UserModel(
      idNumber: idNumber ?? this.idNumber,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      verified: verified ?? this.verified,
      active: active ?? this.active,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      middle_name: middle_name ?? this.middle_name,
      suffix: suffix ?? this.suffix,
      gender: gender ?? this.gender,
      date_of_birth: date_of_birth ?? this.date_of_birth,
      address: address ?? this.address,
      contact_number: contact_number ?? this.contact_number,
      facebook: facebook ?? this.facebook,
      other_info: other_info ?? this.other_info,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }

  // helpers for value safety
  // helpers for value safety
  static String _getString(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    // Check if the key exists first to avoid QueryResultSet null check error
    if (map.containsKey(key1)) {
      final value = map[key1];
      if (value != null) return value.toString();
    }

    if (key2 != null && map.containsKey(key2)) {
      final value = map[key2];
      if (value != null) return value.toString();
    }

    return '';
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

  // to db (sqlite)
  Map<String, dynamic> toDb() {
    return {
      'idNumber': idNumber,
      'email': email,
      'role': role,
      'verified': verified ? 1 : 0,
      'active': active ? 1 : 0,
      'first_name': first_name,
      'last_name': last_name,
      'middle_name': middle_name,
      'suffix': suffix,
      'gender': gender,
      'date_of_birth': date_of_birth.toIso8601String(),
      'address': address,
      'contact_number': contact_number,
      'facebook': facebook,
      'other_info': jsonEncode(other_info.toMap()),
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
      password: '',
      role: _getString(map, 'role'),
      verified: _getBool(map, 'verified'),
      active: _getBool(map, 'active'),
      first_name: _getString(map, 'first_name'),
      last_name: _getString(map, 'last_name'),
      middle_name: _getString(map, 'middle_name'),
      suffix: _getString(map, 'suffix'),
      gender: _getString(map, 'gender'),
      date_of_birth: _getDateTime(map, 'date_of_birth'),
      address: _getString(map, 'address'),
      contact_number: _getString(map, 'contact_number'),
      facebook: _getString(map, 'facebook'),
      other_info: OtherInfoModel.fromMap(
        map['other_info'] != null
            ? jsonDecode(map['other_info'])
            : <String, dynamic>{},
      ),
      deletedAt: ModelUtils.getNullableDateTime(map, 'deletedAt'),
      deletedBy: ModelUtils.getString(map, 'deletedBy'),
      createdBy: ModelUtils.getString(map, 'createdBy'),
      updatedBy: ModelUtils.getString(map, 'updatedBy'),
      createdAt: ModelUtils.getDateTime(map, 'createdAt'),
      updatedAt: ModelUtils.getDateTime(map, 'updatedAt'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idNumber': idNumber,
      'email': email,
      'password': password,
      'role': role,
      'first_name': first_name,
      'last_name': last_name,
      'middle_name': middle_name,
      'suffix': suffix,
      'gender': gender.toLowerCase(),
      'date_of_birth': date_of_birth.toIso8601String(),
      'address': address,
      'contact_number': contact_number,
      'facebook': facebook,
      'other_info': other_info.toMap(),
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
      first_name: _getString(json, 'first_name', 'first_name'),
      last_name: _getString(json, 'last_name', 'last_name'),
      middle_name: _getString(json, 'middle_name', 'middle_name'),
      suffix: _getString(json, 'suffix'),
      gender: _getString(json, 'gender'),
      date_of_birth: _getDateTime(json, 'date_of_birth', 'date_of_birth'),
      address: _getString(json, 'address'),
      contact_number: _getString(json, 'contact_number', 'contact_number'),
      facebook: _getString(json, 'facebook'),
      other_info: OtherInfoModel.fromMap(
        json['other_info'] ?? json['other_info'] ?? <String, dynamic>{},
      ),
      deletedAt:
          ModelUtils.getNullableDateTime(json, 'deletedAt', 'deleted_at'),
      deletedBy: ModelUtils.getString(json, 'deletedBy', 'deleted_by'),
      createdBy: ModelUtils.getString(json, 'createdBy', 'created_by'),
      updatedBy: ModelUtils.getString(json, 'updatedBy', 'updated_by'),
      createdAt: ModelUtils.getDateTime(json, 'createdAt', 'created_at'),
      updatedAt: ModelUtils.getDateTime(json, 'updatedAt', 'updated_at'),
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
      first_name: first_name,
      last_name: last_name,
      middle_name: middle_name,
      suffix: suffix,
      gender: gender,
      date_of_birth: date_of_birth,
      address: address,
      contact_number: contact_number,
      facebook: facebook,
      other_info: other_info,
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
      first_name: entity.first_name,
      last_name: entity.last_name,
      middle_name: entity.middle_name,
      suffix: entity.suffix,
      gender: entity.gender,
      date_of_birth: entity.date_of_birth,
      address: entity.address,
      contact_number: entity.contact_number,
      facebook: entity.facebook,
      other_info: OtherInfoModel.fromEntity(entity.other_info),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      createdBy: entity.createdBy,
      updatedBy: entity.updatedBy,
      deletedAt: entity.deletedAt,
      deletedBy: entity.deletedBy,
    );
  }
}
