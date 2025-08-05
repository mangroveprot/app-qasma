import 'package:equatable/equatable.dart';

class Reminder extends Equatable {
  final String message;

  const Reminder({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
