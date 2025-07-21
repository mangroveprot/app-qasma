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
  YEARS_TO_GENERATE, // years to generate start from current date
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
