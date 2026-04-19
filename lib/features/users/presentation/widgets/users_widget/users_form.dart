import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/utils/constant.dart';
import '../../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../data/models/user_model.dart';
import '../../bloc/user_cubit.dart';
import '../../pages/users_page.dart';
import 'user_list_content.dart';
import 'user_search_bar.dart';
import 'users_filter_bottom_sheet.dart';

enum UsersListFilter { all, newest, oldest, active, inactive }

class UsersForm extends StatefulWidget {
  final UsersPageState state;
  const UsersForm({super.key, required this.state});

  @override
  State<UsersForm> createState() => _UsersFormState();
}

class _UsersFormState extends State<UsersForm> {
  DateTime? _lastRefreshTime;
  bool _isRefreshing = false;
  static const Duration _refreshCooldown = Duration(seconds: 30);

  String _searchQuery = '';
  UsersListFilter _filter = UsersListFilter.all;

  List<UserModel> _getFilteredUsers(List<UserModel> users) {
    final currentUserId = SharedPrefs().getString('currentUserId');

    final filtered = users
        .where((user) {
          final isCurrentUser =
              currentUserId != null && user.idNumber == currentUserId;
          final isStudent = user.role.toLowerCase() == RoleType.student.field;

          if (isCurrentUser || !isStudent) return false;
          if (_filter == UsersListFilter.active && !user.active) return false;
          if (_filter == UsersListFilter.inactive && user.active) return false;

          if (_searchQuery.isNotEmpty) {
            final fullName =
                '${user.first_name} ${user.last_name}'.toLowerCase();
            final query = _searchQuery.toLowerCase();
            return fullName.contains(query) ||
                user.idNumber.toLowerCase().contains(query);
          }

          return true;
        })
        .map((user) => user)
        .toList();

    filtered.sort((a, b) {
      if (_filter == UsersListFilter.newest)
        return b.createdAt.compareTo(a.createdAt);
      if (_filter == UsersListFilter.oldest)
        return a.createdAt.compareTo(b.createdAt);
      return a.first_name.toLowerCase().compareTo(b.first_name.toLowerCase());
    });

    return filtered;
  }

  Future<void> _onRefresh({bool bypassThrottle = false}) async {
    if (_isRefreshing) return;
    if (!bypassThrottle &&
        _lastRefreshTime != null &&
        DateTime.now().difference(_lastRefreshTime!) < _refreshCooldown) return;

    setState(() => _isRefreshing = true);
    try {
      await widget.state.controller.loadAllUsers();
      _lastRefreshTime = DateTime.now();
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserCubitState>(
      buildWhen: (prev, curr) =>
          prev.runtimeType != curr.runtimeType || curr is UserLoadingState,
      builder: (context, state) {
        return Column(
          children: [
            UsersSearchBar(
              onSearchChanged: (val) => setState(() => _searchQuery = val),
              onFilterPressed: () => _showFilterBottomSheet(context),
              hasActiveFilter: _filter != UsersListFilter.all,
            ),
            Spacing.verticalMedium,
            Expanded(
              child: UsersListContent(
                state: state,
                filteredUsers: state is UserLoadedState
                    ? _getFilteredUsers(state.users)
                    : [],
                onRefresh: _onRefresh,
                onRetry: widget.state.controller.loadAllUsers,
                isRefreshing: _isRefreshing,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => UsersFilterBottomSheet(
        initialFilter: _filter,
        onApply: (filter) => setState(() => _filter = filter),
      ),
    );
  }
}
