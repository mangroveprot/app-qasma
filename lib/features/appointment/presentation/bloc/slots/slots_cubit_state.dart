part of 'slots_cubit.dart';

abstract class SlotsCubitState extends BaseState {
  const SlotsCubitState();
}

class SlotsInitialState extends SlotsCubitState {}

class SlotsLoadingState extends SlotsCubitState {
  final bool isRefreshing;
  const SlotsLoadingState({this.isRefreshing = false});
}

class SlotsLoadedState extends SlotsCubitState {
  final Map<String, dynamic> slots;
  final List<String> formattedSlots;

  const SlotsLoadedState({
    required this.slots,
    required this.formattedSlots,
  });
}

class SlotsFailureState extends SlotsCubitState {
  final List<String> errorMessages;
  final List<String>? suggestions;
  const SlotsFailureState({
    required this.errorMessages,
    this.suggestions,
  });
}
