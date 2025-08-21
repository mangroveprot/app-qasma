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
    'idNumber': 'ID Number',
    'active': 'Active',
    'verified': 'Verified',
    'first_name': 'First Name',
    'middle_name': 'Middle Name',
    'last_name': 'Last Name',
    'suffix': 'Suffix',
    'gender': 'Gender',
    'email': 'Email',
    'contact_number': 'Contact Number',
    'address': 'Address',
    'facebook': 'Facebook',
    'course': 'Course',
    'yearLevel': 'Year Level',
    'block': 'Block',
  };

  static const Map<String, IconData> fieldIcons = {
    'idNumber': Icons.badge_outlined,
    'active': Icons.check_circle_outline,
    'verified': Icons.verified_outlined,
    'first_name': Icons.person_outline,
    'middle_name': Icons.person_outline,
    'last_name': Icons.person_outline,
    'suffix': Icons.person_outline,
    'gender': Icons.wc_outlined,
    'email': Icons.email_outlined,
    'contact_number': Icons.phone_outlined,
    'address': Icons.location_on_outlined,
    'facebook': Icons.facebook_outlined,
    'course': Icons.school_outlined,
    'yearLevel': Icons.grade_outlined,
    'block': Icons.class_outlined,
  };

  static const List<String> otherInfoFields = ['course', 'yearLevel', 'block'];

  static const List<String> informationFields = [
    'idNumber',
    'active',
    'verified',
  ];

  static const List<String> personalFields = [
    'first_name',
    'middle_name',
    'last_name',
    'suffix',
    'gender'
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
