import '../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../users/data/models/user_model.dart';
import '../../data/models/activity_log_model.dart';

const List<String> _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String formatRelativeTime(DateTime date) {
  final diff = DateTime.now().difference(date);
  if (diff.inSeconds < 60) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  return '${diff.inDays}d ago';
}

String formatDateLabel(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final d = DateTime(date.year, date.month, date.day);

  if (d == today) return 'Today';
  if (d == yesterday) return 'Yesterday';

  return '${_months[date.month - 1]} ${date.day}, ${date.year}';
}

String formatFullTime(DateTime date) {
  final hour =
      date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
  final minute = date.minute.toString().padLeft(2, '0');
  final ampm = date.hour >= 12 ? 'PM' : 'AM';
  return '${_months[date.month - 1]} ${date.day}, $hour:$minute $ampm';
}

Map<String, List<ActivityLogModel>> groupLogsByDate(
    List<ActivityLogModel> logs) {
  final sorted = [...logs]..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  final Map<DateTime, List<ActivityLogModel>> dateGroups = {};
  for (final log in sorted) {
    final d = DateTime(
      log.createdAt.year,
      log.createdAt.month,
      log.createdAt.day,
    );
    dateGroups.putIfAbsent(d, () => []).add(log);
  }

  final sortedDates = dateGroups.keys.toList()..sort((a, b) => b.compareTo(a));

  return {
    for (final date in sortedDates) formatDateLabel(date): dateGroups[date]!,
  };
}

class DetailEntry {
  final String label;
  final String value;
  const DetailEntry({required this.label, required this.value});
}

String _capitalizeWords(String input) {
  return input.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1);
  }).join(' ');
}

String get _currId => SharedPrefs().getString('currentUserId') ?? '';

UserModel? _findUser(
  List<UserModel>? users, {
  required bool Function(UserModel) predicate,
}) {
  if (users == null || users.isEmpty) return null;
  try {
    return users.firstWhere(predicate);
  } catch (_) {
    return null;
  }
}

String _resolveByLabel(ActivityLogModel log, List<UserModel>? users) {
  final userId = log.userId;
  if (userId == null || userId.isEmpty) return 'System';
  if (userId == _currId) return 'You';
  final user = _findUser(users, predicate: (u) => u.idNumber == userId);
  if (user == null) return 'System';
  final role = user.role.toLowerCase();
  if (role == 'staff') return 'Staff';
  if (role == 'counselor') return 'Counselor';
  return _capitalizeWords(role.isNotEmpty ? role : 'System');
}

List<DetailEntry> buildDetailEntries(
  ActivityLogModel log, [
  List<UserModel>? users,
]) {
  final rows = <DetailEntry>[];

  rows.add(DetailEntry(label: 'By', value: _resolveByLabel(log, users)));
  if (log.userId != null && log.userId!.isNotEmpty) {
    rows.add(DetailEntry(label: 'User ID', value: log.userId!));
  }
  if (log.ipAddress != null && log.ipAddress!.isNotEmpty) {
    rows.add(DetailEntry(label: 'IP Address', value: log.ipAddress!));
  }
  if (log.device != null && log.device!.isNotEmpty) {
    rows.add(DetailEntry(label: 'Device', value: log.device!));
  }
  if (log.platform != null && log.platform!.isNotEmpty) {
    rows.add(DetailEntry(label: 'Platform', value: log.platform!));
  }
  if (log.userAgent != null && log.userAgent!.isNotEmpty) {
    rows.add(DetailEntry(label: 'User Agent', value: log.userAgent!));
  }
  if (log.relatedId != null && log.relatedId!.isNotEmpty) {
    rows.add(DetailEntry(label: 'Related ID', value: log.relatedId!));
  }

  log.details.forEach((k, v) {
    if (v != null) {
      rows.add(DetailEntry(
        label: _capitalizeWords(k.toString().replaceAll('_', ' ')),
        value: v.toString(),
      ));
    }
  });

  rows.add(DetailEntry(label: 'Time', value: formatFullTime(log.createdAt)));

  return rows;
}
