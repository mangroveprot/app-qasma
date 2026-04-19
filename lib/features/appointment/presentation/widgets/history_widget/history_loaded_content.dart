import 'package:flutter/material.dart';

import '../../../../../common/widgets/pagination_widget.dart';
import '../../../../users/data/models/user_model.dart';
import '../../../data/models/appointment_model.dart';
import '../../pages/appointment_history_page.dart';
import 'history_card.dart';
import 'history_empty_content.dart';

class HistoryLoadedContent extends StatelessWidget {
  final List<AppointmentModel> appointments;
  final Future<void> Function() onRefresh;
  final AppointmentHistoryState state;
  final int currentPage;
  final int itemsPerPage;
  final Function(int) onPageChanged;
  final ScrollController scrollController;
  final List<UserModel> users;

  const HistoryLoadedContent({
    Key? key,
    required this.appointments,
    required this.onRefresh,
    required this.state,
    required this.currentPage,
    required this.itemsPerPage,
    required this.onPageChanged,
    required this.scrollController,
    required this.users,
  }) : super(key: key);

  List<AppointmentModel> get paginatedAppointments {
    final int start = currentPage * itemsPerPage;
    int end = start + itemsPerPage;
    if (end > appointments.length) end = appointments.length;
    return appointments.sublist(start, end);
  }

  int get totalPages =>
      appointments.isEmpty ? 0 : (appointments.length / itemsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return HistoryEmptyContent(onRefresh: onRefresh);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          ...paginatedAppointments.map(
            (appointment) => RepaintBoundary(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: HistoryCard(
                  appointment: appointment,
                  users: users,
                ),
              ),
            ),
          ),
          if (totalPages > 1)
            PaginationWidget(
              currentPage: currentPage,
              totalPages: totalPages,
              onPageChanged: onPageChanged,
            ),
        ],
      ),
    );
  }
}
