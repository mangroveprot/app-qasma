import 'package:flutter/material.dart';

import '../../../../common/helpers/helpers.dart';
import '../../../../common/utils/constant.dart';
import '../../data/models/other_info_model.dart';
import '../../data/models/user_model.dart';
import '../config/profile_config.dart';

class ProfileFormUtils {
  static UserModel updateMainUser(
      UserModel user, String fieldName, String newValue) {
    switch (fieldName) {
      case 'active':
        return user.copyWith(
            active: newValue == activeOption[0] ? true : false);
      case 'verified':
        return user.copyWith(
            verified: newValue == verifyption[0] ? true : false);
      case 'first_name':
        return user.copyWith(first_name: newValue);
      case 'last_name':
        return user.copyWith(last_name: newValue);
      case 'middle_name':
        return user.copyWith(middle_name: newValue);
      case 'email':
        return user.copyWith(email: newValue);
      case 'suffix':
        return user.copyWith(suffix: newValue);
      case 'gender':
        return user.copyWith(gender: newValue);
      case 'address':
        return user.copyWith(address: newValue);
      case 'contact_number':
        return user.copyWith(contact_number: newValue);
      case 'facebook':
        return user.copyWith(facebook: newValue);
      default:
        return user;
    }
  }

  static OtherInfoModel updateOtherInfo(
      OtherInfoModel otherInfo, String fieldName, String newValue) {
    final validFields = ['course', 'yearLevel', 'block'];

    if (validFields.contains(fieldName)) {
      return otherInfo.copyWith({fieldName: newValue});
    }

    return otherInfo;
  }

  static String getFieldValue(UserModel user, String fieldName) {
    if (ProfileFieldConfig.otherInfoFields.contains(fieldName)) {
      switch (fieldName) {
        case 'course':
          return user.other_info.course ?? '';
        case 'yearLevel':
          return user.other_info.yearLevel ?? '';
        case 'block':
          return user.other_info.block ?? '';
        default:
          return '';
      }
    }

    if (ProfileFieldConfig.informationFields.contains(fieldName)) {
      switch (fieldName) {
        // case 'idNumber':
        //   return user.idNumber;
        case 'active':
          return user.active ? activeOption[0] : activeOption[1];
        case 'verified':
          return user.verified ? verifyption[0] : verifyption[1];
        default:
          return '';
      }
    }

    switch (fieldName) {
      case 'first_name':
        return user.first_name;
      case 'last_name':
        return user.last_name;
      case 'middle_name':
        return user.middle_name;
      case 'email':
        return user.email;
      case 'suffix':
        return user.suffix;
      case 'gender':
        return capitalizeWords(user.gender);
      case 'address':
        return user.address;
      case 'contact_number':
        return user.contact_number;
      case 'facebook':
        return user.facebook;
      case 'date_of_birth':
        return user.date_of_birth.toIso8601String();
      default:
        return '';
    }
  }

  static Map<String, dynamic> getAllFieldsData(
    UserModel user,
    Map<String, TextEditingController> controllers,
  ) {
    return {
      'idNumber': user.idNumber,
      if (user.role == RoleType.student.field) 'active': user.active,
      if (user.role == RoleType.student.field) 'verified': user.verified,
      'first_name': controllers['first_name']?.text ?? '',
      'last_name': controllers['last_name']?.text ?? '',
      'middle_name': controllers['middle_name']?.text ?? '',
      'email': controllers['email']?.text ?? '',
      'suffix': controllers['suffix']?.text ?? '',
      'gender': user.gender,
      'address': controllers['address']?.text ?? '',
      'contact_number': controllers['contact_number']?.text ?? '',
      'facebook': controllers['facebook']?.text ?? '',
      if (user.role == RoleType.student.field)
        'course': user.other_info.course ?? '',
      if (user.role == RoleType.student.field)
        'yearLevel': user.other_info.yearLevel ?? '',
      if (user.role == RoleType.student.field)
        'block': user.other_info.block ?? '',
      'date_of_birth': user.date_of_birth.toIso8601String(),
    };
  }
}
