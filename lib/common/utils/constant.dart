// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../widgets/models/modal_option.dart';

int YEARS_TO_GENERATE = 50;

class Property {
  final String field;
  Property({
    required this.field,
  });
}

class StatusType {
  static Property pending = Property(field: 'pending');
  static Property completed = Property(field: 'completed');
  static Property cancelled = Property(field: 'cancelled');
  static Property approved = Property(field: 'approved');
}

class RoleType {
  static Property student = Property(field: 'student');
  static Property staff = Property(field: 'staff');
  static Property counselor = Property(field: 'counselor');
}

class NotificationType {
  static Property appointmentCancelled =
      Property(field: 'APPOINTMENT_CANCELLED');
  static Property appointmentRescheduled =
      Property(field: 'APPOINTMENT_RESCHEDULED');
  static Property appointmentConfirmed =
      Property(field: 'APPOINTMENT_CONFIRMED');
  static Property appointmentCompleted =
      Property(field: 'APPOINTMENT_COMPLETED');
  static Property checkInReminder = Property(field: 'CHECK_IN_REMINDER');
}

String get guidance_email => 'katipunan.guidance@jrmsu.edu.ph';
String get guidance_fb_url => 'https://m.facebook.com/jrmsuk.guidanceoffice';

const Map<String, dynamic> name = {
  'name': 'First Name',
  'hint': 'Enter your first name...',
};
const Map<String, dynamic> lastname = {
  'name': 'Last Name',
  'hint': 'Enter your last name...',
};

const List<String> courseList = [
  'Bachelor of Elementary Education',
  'Bachelor of Physical Education',
  'Bachelor of Science in Agriculture - Animal Science',
  'Bachelor of Science in Agriculture - Crop Science',
  'Bachelor of Science in Agricultural and Biosystems Engineering',
  'Bachelor of Science in Criminology',
  'Bachelor of Science in Forestry',
  'Bachelor of Secondary Education - Filipino',
  'Bachelor of Secondary Education - Mathematics',
  'Bachelor of Secondary Education - Science',
  'Bachelor of Secondary Education - Social Studies',
  'Bachelor of Science in Agribusiness Management',
  'Bachelor of Science in Business Administration - Human Resource Management',
  'Bachelor of Science in Computer Science',
  'Bachelor of Science in Hospitality Management',
  'Bachelor of Science in Information Systems',
];

const List<String> blockList = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z'
];

const List<String> yearLevelList = ['1', '2', '3', '4'];

const List<String> genderList = ['Male', 'Female', 'Other'];

const List<String> activeOption = ['active', 'inactive'];

const List<String> verifyption = ['verified', 'unverified'];

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
    value: 'personal',
    title: '',
    subtitle: 'Personal Issues or Mental Health Concerns',
  ),
  const ModalOption(
    value: 'scheduling',
    title: '',
    subtitle: 'Class or Study Conflicts',
  ),
  const ModalOption(
    value: 'emergency',
    title: '',
    subtitle: 'Emergencies or Unexpected Events',
  ),
  const ModalOption(
    value: 'completion',
    title: '',
    subtitle: 'No Longer Needing Counseling',
  ),
  const ModalOption(
    value: 'rescheduling',
    title: '',
    subtitle: 'Availability of a Better Time Slot',
  ),
  const ModalOption(
    value: 'miscellaneous',
    title: '',
    subtitle: 'Others',
    requiresInput: true,
  ),
];

class OtpPurposes {
  static const String accountVerification = 'ACCOUNT_VERIFICATION';
  static const String passwordReset = 'FORGOT_PASSWORD';
}
