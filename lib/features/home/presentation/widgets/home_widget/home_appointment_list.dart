import 'package:flutter/material.dart';
import '../../../../../common/utils/constant.dart';
import '../../../../../common/widgets/custom_search_bar.dart';
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
  final ValueChanged<String> onSearchChanged;
  final TextEditingController? searchController;
  final VoidCallback onOpenFilter;
  final int activeFilterCount;
  final Function(String) onCancel;
  final Function(String) onReschedule;
  final Future<void> Function() onRefresh;

  const HomeAppointmentList({
    super.key,
    required this.appointments,
    required this.users,
    required this.onSearchChanged,
    this.searchController,
    required this.onOpenFilter,
    this.activeFilterCount = 0,
    required this.onCancel,
    required this.onReschedule,
    required this.state,
    required this.onRefresh,
  });

  @override
  State<HomeAppointmentList> createState() => _HomeAppointmentListState();
}

class _HomeAppointmentListState extends State<HomeAppointmentList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<AppointmentModel> _pendingAppointments;
  late List<AppointmentModel> _approvedAppointments;
  Map<String, UserModel> _userMap = {};

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
    _userMap = {for (var user in widget.users) user.idNumber: user};

    _pendingAppointments = widget.appointments
        .where((appointment) =>
            appointment.status.toLowerCase() == StatusType.pending.field)
        .toList();
    _approvedAppointments = widget.appointments
        .where((appointment) =>
            appointment.status.toLowerCase() == StatusType.approved.field)
        .toList();
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

        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 520;

            final tabBar = _buildTabBar();

            final searchAndSort = _SearchAndSortRow(
              onSearchChanged: widget.onSearchChanged,
              controller: widget.searchController,
              onOpenFilter: widget.onOpenFilter,
              activeFilterCount: widget.activeFilterCount,
            );

            if (isWide) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Flexible(flex: 5, child: tabBar),
                    const SizedBox(width: 8),
                    Flexible(flex: 6, child: searchAndSort),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  tabBar,
                  const SizedBox(height: 8),
                  searchAndSort,
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 8),

        // Flexible expanded content
        Flexible(
          child: TabBarView(
            controller: _tabController,
            children: [
              RefreshIndicator(
                onRefresh: widget.onRefresh,
                child: _buildAppointmentList(_pendingAppointments),
              ),
              RefreshIndicator(
                onRefresh: widget.onRefresh,
                child: _buildAppointmentList(_approvedAppointments),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    final colors = context.colors;
    final weight = context.weight;

    return Container(
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
        labelColor: _tabController.index == 0 ? colors.warning : colors.primary,
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
          _buildTab('Pending', _pendingAppointments.length, 0),
          _buildTab('Approved', _approvedAppointments.length, 1),
        ],
      ),
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

  Widget _buildAppointmentList(List<AppointmentModel> appointments) {
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
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: HomeSkeletonLoader.appointmentSingleCardSkeleton(),
          );
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
              onApproved: () => widget.state.controller
                  .handleApprovedAppointment(context, appointmentId),
              onCancel: () => widget.state.controller
                  .handleCancelAppointment(appointmentId, context),
              onReschedule: () => widget.state.controller
                  .handleRescheduleAppointment(appointmentId),
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
              'No ${_tabController.index == 0 ? 'pending' : 'approved'} appointments',
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

class _SearchAndSortRow extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final TextEditingController? controller;
  final VoidCallback onOpenFilter;
  final int activeFilterCount;

  const _SearchAndSortRow({
    required this.onSearchChanged,
    this.controller,
    required this.onOpenFilter,
    this.activeFilterCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomSearchBar(
            onSearchChanged: onSearchChanged,
            hintText: 'Search appointments...',
            controller: controller,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
            margin: EdgeInsets.zero,
            iconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          ),
        ),
        const SizedBox(width: 8),
        _FilterButton(
          onTap: onOpenFilter,
          activeFilterCount: activeFilterCount,
        ),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  final VoidCallback onTap;
  final int activeFilterCount;

  const _FilterButton({
    required this.onTap,
    required this.activeFilterCount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radii;
    final shadows = context.shadows;

    return Material(
      color: Colors.transparent,
      borderRadius: radius.medium,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius.medium,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colors.white.withOpacity(0.8),
            borderRadius: radius.medium,
            border: Border.all(color: colors.textPrimary.withOpacity(0.1)),
            boxShadow: [shadows.light],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Icon(
                  Icons.tune_rounded,
                  size: 20,
                  color: colors.textPrimary,
                ),
              ),
              if (activeFilterCount > 0)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: colors.white, width: 2),
                    ),
                    child: Text(
                      activeFilterCount.toString(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
