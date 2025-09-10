class CounselorScheduleConfig {
  static const List<String> timeSlots = [
    '8:00-8:30',
    '8:30-9:00',
    '9:00-9:30',
    '9:30-10:00',
    '10:00-10:30',
    '10:30-11:00',
    '11:00-11:30',
    '11:30-12:00',
    '1:00-1:30',
    '1:30-2:00',
    '2:00-2:30',
    '2:30-3:00',
    '3:00-3:30',
    '4:00-4:30',
    '4:30-5:00'
  ];

  static final List<String> days = const [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
  ];

  static const Map<String, String> dayNameMap = {
    'Monday': 'Mon',
    'Tuesday': 'Tue',
    'Wednesday': 'Wed',
    'Thursday': 'Thu',
    'Friday': 'Fri',
  };

  static const Map<String, String> reverseDayNameMap = {
    'Mon': 'Monday',
    'Tue': 'Tuesday',
    'Wed': 'Wednesday',
    'Thu': 'Thursday',
    'Fri': 'Friday',
  };

  static String getShortDayName(String fullDay) {
    return dayNameMap[fullDay] ?? fullDay;
  }

  static String getFullDayName(String shortDay) {
    return reverseDayNameMap[shortDay] ?? shortDay;
  }

  static bool isAMPMBreak(int index) {
    return index == 0 || index == 8;
  }

  static String getAMPMLabel(int index) {
    return index == 0 ? 'AM' : 'PM';
  }
}
