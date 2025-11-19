import 'package:flutter/material.dart';
import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/utils/constant.dart';
import '../../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../../../users/data/models/user_model.dart';
import '../../pages/home_page.dart';
import '../appointment_card_widget/appointment_card.dart';
import '../home_skeletonloader.dart';
import 'home_history_button.dart';

class HomeAppointmentList extends StatefulWidget {
  final HomePageState state;
  final List<AppointmentModel> appointments;
  final List<UserModel> users;
  final Function(String) onCancel;
  final Function(String) onReschedule;
  final Function(String) onVerify;
  final Future<void> Function() onRefresh;

  const HomeAppointmentList({
    super.key,
    required this.appointments,
    required this.users,
    required this.onCancel,
    required this.onReschedule,
    required this.state,
    required this.onRefresh,
    required this.onVerify,
  });

  @override
  State<HomeAppointmentList> createState() => _HomeAppointmentListState();
}

class _HomeAppointmentListState extends State<HomeAppointmentList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<AppointmentModel> _currentSessionAppointments = [];
  List<AppointmentModel> _upcomingAppointments = [];
  Map<String, UserModel> _userMap = {};
  static const bool _enableTimeFiltering = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = 0;
    _filterAppointments();

    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void didUpdateWidget(HomeAppointmentList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.appointments != widget.appointments ||
        oldWidget.users != widget.users) {
      _filterAppointments();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _filterAppointments() {
    final currentUserId = SharedPrefs().getString('currentUserId');

    _userMap = {for (var user in widget.users) user.idNumber: user};

    final approvedAppointments = widget.appointments
        .where((appointment) =>
            appointment.status.toLowerCase() == StatusType.approved.field &&
            appointment.counselorId == currentUserId)
        .toList();

    if (_enableTimeFiltering) {
      final now = DateTime.now();
      _currentSessionAppointments = [];
      _upcomingAppointments = [];

      for (final appointment in approvedAppointments) {
        if (isNowAppointment(now, appointment.scheduledStartAt) ||
            appointment.scheduledStartAt.isBefore(now)) {
          _currentSessionAppointments.add(appointment);
        } else {
          _upcomingAppointments.add(appointment);
        }
      }

      _currentSessionAppointments.sort((a, b) {
        return b.scheduledStartAt.compareTo(a.scheduledStartAt);
      });

      _upcomingAppointments.sort((a, b) {
        return a.scheduledStartAt.compareTo(b.scheduledStartAt);
      });
    } else {
      _currentSessionAppointments = List.from(approvedAppointments);
      _upcomingAppointments = [];

      _currentSessionAppointments.sort((a, b) {
        return b.scheduledStartAt.compareTo(a.scheduledStartAt);
      });
    }
  }

  UserModel? _getUserById(String? userId) {
    if (userId == null || userId.isEmpty) return null;
    return _userMap[userId];
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
          child: Text(
            'Appointments',
            style: TextStyle(
              fontSize: 14,
              fontWeight: weight.medium,
              color: colors.textPrimary,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: colors.textPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.zero,
            dividerColor: Colors.transparent,
            labelColor:
                _tabController.index == 0 ? colors.warning : colors.primary,
            unselectedLabelColor: colors.textPrimary,
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: weight.medium,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 12,
              fontWeight: weight.regular,
            ),
            splashFactory: NoSplash.splashFactory,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            tabs: [
              _buildTab(
                  'Current Session', _currentSessionAppointments.length, 0),
              _buildTab('Upcoming', _upcomingAppointments.length, 1),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Flexible(
          child: TabBarView(
            controller: _tabController,
            children: [
              RefreshIndicator(
                onRefresh: widget.onRefresh,
                child: _buildAppointmentList(
                  _currentSessionAppointments,
                  isCurrentSession: true,
                ),
              ),
              RefreshIndicator(
                onRefresh: widget.onRefresh,
                child: _buildAppointmentList(_upcomingAppointments),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String title, int count, int tabIndex) {
    final colors = context.colors;
    final weight = context.weight;
    final isSelected = _tabController.index == tabIndex;

    return Container(
      height: 32,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            constraints: const BoxConstraints(minWidth: 20),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isSelected
                  ? (tabIndex == 0
                      ? colors.warning.withOpacity(0.2)
                      : colors.primary.withOpacity(0.2))
                  : colors.textPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 10,
                fontWeight: weight.medium,
                color: isSelected
                    ? (tabIndex == 0 ? colors.warning : colors.primary)
                    : colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentList(List<AppointmentModel> appointments,
      {bool isCurrentSession = false}) {
    if (appointments.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: appointments.length + 1,
      itemBuilder: (context, index) {
        if (index == appointments.length) {
          return const Padding(
            padding: EdgeInsets.only(top: 8),
            child: HomeHistoryButton(),
          );
        }

        final appointment = appointments[index];

        final studentUser = _getUserById(appointment.studentId);
        final rescheduledByUser =
            _getUserById(appointment.reschedule.rescheduledBy);

        if (studentUser == null) {
          return HomeSkeletonLoader.appointmentSingleCardSkeleton();
        }

        final appointmentId = appointments[index].appointmentId;

        return RepaintBoundary(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: AppointmentCard(
              key: ValueKey(appointmentId),
              userModel: studentUser,
              rescheduledByUser: rescheduledByUser,
              appointment: appointments[index],
              isCurrentSessions: isCurrentSession,
              onApproved: () => widget.state.controller
                  .handleApprovedAppointment(context, appointmentId),
              onCancel: () => widget.state.controller
                  .handleCancelAppointment(appointmentId, context),
              onReschedule: () => widget.state.controller
                  .handleRescheduleAppointment(appointmentId),
              onVerify: () => widget.state.controller
                  .handleAppointmentVerification(appointmentId),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final colors = context.colors;
    final weight = context.weight;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Icon(
              Icons.event_busy_outlined,
              size: 48,
              color: colors.textPrimary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No ${_tabController.index == 0 ? 'current session' : 'upcoming'} appointments',
              style: TextStyle(
                fontSize: 14,
                fontWeight: weight.regular,
                color: colors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Pull down to refresh',
              style: TextStyle(
                fontSize: 12,
                fontWeight: weight.regular,
                color: colors.textPrimary.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
