import 'package:flutter/material.dart';

import '../../../../common/utils/constant.dart';

class ProfileFieldConfig {
  static const Map<String, List<String>> dropdownOptions = {
    'active': activeOption,
    'verified': verifyption,
    'gender': genderList,
    'course': courseList,
    'yearLevel': yearLevelList,
    'block': blockList,
  };

  static const Map<String, String> fieldLabels = {
    'active': 'Active',
    'verified': 'Verified',
    'first_name': 'First Name',
    'middle_name': 'Middle Name',
    'last_name': 'Last Name',
    'suffix': 'Suffix',
    'gender': 'Gender',
    'date_of_birth': 'Date of Birth',
    'email': 'Email',
    'contact_number': 'Contact Number',
    'address': 'Address',
    'facebook': 'Facebook',
    'course': 'Course',
    'yearLevel': 'Year Level',
    'block': 'Block',
  };

  static const List<String> otherInfoFields = ['course', 'yearLevel', 'block'];

  static const List<String> informationFields = [
    'active',
    'verified',
  ];

  static const List<String> personalFields = [
    'first_name',
    'middle_name',
    'last_name',
    'suffix',
    'gender',
    'date_of_birth',
  ];

  static const List<String> contactFields = [
    'email',
    'contact_number',
    'address',
    'facebook'
  ];

  static const List<String> academicFields = ['course', 'yearLevel', 'block'];

  static TextInputType? getKeyboardType(String fieldName) {
    switch (fieldName) {
      case 'email':
        return TextInputType.emailAddress;
      case 'contact_number':
        return TextInputType.phone;
      default:
        return TextInputType.text;
    }
  }
}
