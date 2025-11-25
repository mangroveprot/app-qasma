// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../widgets/models/modal_option.dart';

int YEARS_TO_GENERATE = 50;
int totalYearLevel = 10;

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

class NotificationType {
  static Property appointmentCancelled =
      Property(field: 'APPOINTMENT_CANCELLED');
  static Property appointmentRescheduled =
      Property(field: 'APPOINTMENT_RESCHEDULED');
  static Property appointmentConfirmed =
      Property(field: 'APPOINTMENT_CONFIRMED');
  static Property appointmentCompleted =
      Property(field: 'APPOINTMENT_COMPLETED');
  static Property general = Property(field: 'GENERAL');
}

class SharedPrefStrings {
  // static Property lastFCMToken = Property(field: 'last_fcm_token');
}

String get guidance_email => 'katipunan.guidance@jrmsu.edu.ph';
String get feedback_url => 'https://jrmsu.online/feedback/';
String get guidance_fb_url => 'https://m.facebook.com/jrmsuk.guidanceoffice';
String get jrmsu_guidance_map => 'https://maps.app.goo.gl/qywZG2wXxTS6eJov5';
String get gcareapp_terms => 'https://terms.jrmsu-gcare.com';
String get gcareapp_privacy => 'https://privacy.jrmsu-gcare.com';

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

final List<String> yearLevelList =
    List.generate(totalYearLevel, (index) => '${index + 1}');

const List<String> genderList = ['Male', 'Female', 'Other'];

final currentYear = DateTime.now().year;
final yearsList = List.generate(
  YEARS_TO_GENERATE,
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
