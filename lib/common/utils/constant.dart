import 'package:flutter/material.dart';

import '../widgets/models/modal_option.dart';

int YEARS_TO_GENERATE = 50;

const Map<String, dynamic> name = {
  'name': 'First Name',
  'hint': 'Enter your first name...',
};
const Map<String, dynamic> lastname = {
  'name': 'Last Name',
  'hint': 'Enter your last name...',
};

const List<String> courseList = [
  'BS Information Technology',
  'BS Computer Science',
  'BS Education major in English',
  'BS Education major in Math',
  'BS Civil Engineering',
  'BS Accountancy',
  'BS Nursing',
  'BS Criminology',
  'BS Agriculture',
  'BS Hospitality Management',
  'BS Tourism Management',
];

const List<String> blockList = [
  'Block A',
  'Block B',
  'Block C',
  'Block D',
  'Block E',
];

const List<String> yearLevelList = ['1', '2', '3', '4'];

const List<String> genderList = ['Male', 'Female', 'LGBTQ+ ultra'];

final currentYear = DateTime.now().year;
final yearsList = List.generate(
  YEARS_TO_GENERATE, // years to generate start from current year
  (index) => (currentYear - index).toString(),
);

final List<String> daysList = List.generate(
  31,
  (index) => (index + 1).toString(),
);

const List<String> monthsList = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

class AppointmentSelection {
  static const key = 'new-appointment-selection';
  static const title = 'Select Your Appointment Category';
  static const description = 'Choose from the list of available services.';
}

final List<ModalOption> newAppointmentOptions = [
  const ModalOption(
    value: 'counseling',
    title: 'Counseling',
    subtitle:
        'Get support through emotional, mental, or personal challenges with our counseling staff',
    icon: Icon(Icons.psychology, size: 40, color: Colors.blue),
  ),
  const ModalOption(
    value: 'testing',
    title: 'Testing',
    subtitle:
        'Take psychological tests to better understand your mental health and create personalized plans',
    icon: Icon(Icons.assignment, size: 40, color: Colors.green),
  ),
];

final List<ModalOption> reasonOptionList = [
  const ModalOption(
    value: 'counseling',
    title: '',
    subtitle:
        'Get support through emotional, mental, or personal challenges with our counseling staff',
    icon: Icon(Icons.psychology, size: 40, color: Colors.blue),
  ),
  const ModalOption(
    value: 'testings',
    title: '',
    subtitle:
        'Take psychological tests to better understand your mental health and create personalized plans',
    icon: Icon(Icons.assignment, size: 40, color: Colors.green),
  ),
  const ModalOption(
    value: 'counseling',
    title: '',
    subtitle:
        'Get support through emotional, mental, or personal challenges with our counseling staff',
    icon: Icon(Icons.psychology, size: 40, color: Colors.blue),
  ),
  const ModalOption(
    value: 'testingq',
    title: '',
    subtitle:
        'Take psychological tests to better understand your mental health and create personalized plans',
    icon: Icon(Icons.assignment, size: 40, color: Colors.green),
  ),
  const ModalOption(
    value: 'counselinga',
    title: '',
    subtitle:
        'Get support through emotional, mental, or personal challenges with our counseling staff',
    icon: Icon(Icons.psychology, size: 40, color: Colors.blue),
  ),
  const ModalOption(
      value: 'testingc',
      title: '',
      subtitle:
          'Take psychological tests to better understand your mental health and create personalized plans',
      icon: Icon(Icons.assignment, size: 40, color: Colors.green),
      requiresInput: true),
];
