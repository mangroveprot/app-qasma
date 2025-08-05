import 'package:equatable/equatable.dart';

class TimeSlot extends Equatable {
  final String start;
  final String end;

  const TimeSlot({
    required this.start,
    required this.end,
  });

  @override
  List<Object?> get props => [start, end];
}
