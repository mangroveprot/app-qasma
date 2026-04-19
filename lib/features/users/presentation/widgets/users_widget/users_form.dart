import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../data/models/user_model.dart';
import '../../bloc/user_cubit.dart';
import '../../pages/users_page.dart';
import 'user_item.dart';
import '../../../../../common/widgets/custom_search_bar.dart';
import '../../../../preferences/presentation/widgets/dashboard_widget/_filter/filter_section.dart';
import '../../../../preferences/presentation/widgets/dashboard_widget/_filter/filter_status_chip.dart';

class UsersForm extends StatefulWidget {
  final UsersPageState state;
  const UsersForm({
    super.key,
    required this.state,
  });

  @override
  State<UsersForm> createState() => _UsersFormState();
}

class _UsersFormState extends State<UsersForm> {
  DateTime? _lastRefreshTime;
  bool _isRefreshing = false;
  static const Duration _refreshCooldown = Duration(seconds: 30);
  List<UserModel>? _cachedFilteredUsers;
  UserLoadedState? _lastProcessedState;
  String _searchQuery = '';
  _UsersListFilter _filter = _UsersListFilter.all;

  List<UserModel> _getFilteredUsers(UserLoadedState state) {
    if (_lastProcessedState != state) {
      final currentUserId = SharedPrefs().getString('currentUserId');

      _cachedFilteredUsers = state.users.where((user) {
        final role = user.role.toLowerCase();
        final isSameRole = role == widget.state.role;
        final isCurrentUser = currentUserId != null &&
            currentUserId.isNotEmpty &&
            user.idNumber == currentUserId;
        return isSameRole && !isCurrentUser;
      }).toList();

      _lastProcessedState = state;
    }

    final filtered = _cachedFilteredUsers!.where((user) {
      if (_filter == _UsersListFilter.active && !user.active) return false;
      if (_filter == _UsersListFilter.inactive && user.active) return false;
      return true;
    }).where((user) {
      final fullName = '${user.first_name} ${user.last_name}'.toLowerCase();
      final query = _searchQuery.toLowerCase();
      if (query.isEmpty) return true;
      return fullName.contains(query) ||
          user.first_name.toLowerCase().contains(query) ||
          user.last_name.toLowerCase().contains(query);
    }).toList();

    if (_filter == _UsersListFilter.newest) {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return filtered;
    }

    if (_filter == _UsersListFilter.oldest) {
      filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return filtered;
    }

    filtered.sort(
      (a, b) =>
          a.first_name.toLowerCase().compareTo(b.first_name.toLowerCase()),
    );
    return filtered;
  }

  Future<void> _onRefresh({bool bypassThrottle = false}) async {
    if (_isRefreshing) return;

    if (!bypassThrottle && _shouldThrottle) return;

    setState(() => _isRefreshing = true);

    try {
      await widget.state.controller.loadAllUsers();
      _lastRefreshTime = DateTime.now();
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  bool get _shouldThrottle {
    return _lastRefreshTime != null &&
        DateTime.now().difference(_lastRefreshTime!) < _refreshCooldown;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _UsersFilterBottomSheet(
          initialFilter: _filter,
          onApply: (filter) => setState(() => _filter = filter),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserCubitState>(
      buildWhen: (previous, current) {
        return previous.runtimeType != current.runtimeType ||
            previous is UserLoadingState ||
            current is UserLoadingState;
      },
      builder: (context, state) {
        return Column(
          children: [
            _SearchBar(
              onSearchChanged: _onSearchChanged,
              onFilterPressed: _showFilterBottomSheet,
              hasActiveFilter: _filter != _UsersListFilter.all,
            ),
            Spacing.verticalMedium,
            Expanded(
              child: _buildContent(state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(UserCubitState state) {
    if (state is UserLoadingState) {
      return const _LoadingContent();
    }

    if (state is UserLoadedState) {
      return _LoadedContent(
        onRefresh: _onRefresh,
        users: _getFilteredUsers(state),
      );
    }

    if (state is UserFailureState) {
      return _ErrorContent(
        error: state.primaryError,
        onRefresh: _onRefresh,
        onRetry: widget.state.controller.loadAllUsers,
        isRefreshing: _isRefreshing,
      );
    }

    return _EmptyContent(onRefresh: _onRefresh);
  }
}

class _SearchBar extends StatelessWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onFilterPressed;
  final bool hasActiveFilter;

  const _SearchBar({
    required this.onSearchChanged,
    required this.onFilterPressed,
    required this.hasActiveFilter,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radii;
    final shadows = context.shadows;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: CustomSearchBar(
              onSearchChanged: onSearchChanged,
              hintText: 'Search...',
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 0,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Stack(
            clipBehavior: Clip.none,
            children: [
              InkWell(
                onTap: onFilterPressed,
                borderRadius: radius.medium,
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: colors.white.withOpacity(0.8),
                    borderRadius: radius.medium,
                    border:
                        Border.all(color: colors.textPrimary.withOpacity(0.1)),
                    boxShadow: [shadows.light],
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    size: 22,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              if (hasActiveFilter)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _UsersListFilter { all, newest, oldest, active, inactive }

class _UsersFilterBottomSheet extends StatefulWidget {
  final _UsersListFilter initialFilter;
  final ValueChanged<_UsersListFilter> onApply;

  const _UsersFilterBottomSheet({
    required this.initialFilter,
    required this.onApply,
  });

  @override
  State<_UsersFilterBottomSheet> createState() =>
      _UsersFilterBottomSheetState();
}

class _UsersFilterBottomSheetState extends State<_UsersFilterBottomSheet> {
  late _UsersListFilter _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialFilter;
  }

  void _apply() {
    widget.onApply(_current);
    Navigator.of(context).pop();
  }

  void _reset() => setState(() => _current = _UsersListFilter.all);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final maxHeight = MediaQuery.of(context).size.height - 60;

    Widget chip({
      required _UsersListFilter value,
      required String label,
      Color? dotColor,
    }) {
      return FilterStatusChip(
        value: value.name,
        label: label,
        isSelected: _current == value,
        dotColor: dotColor,
        onTap: () => setState(() => _current = value),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Container(
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 16, 16),
              child: Row(
                children: [
                  Text(
                    'Filter by',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: colors.black,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child:
                        Icon(Icons.close, size: 22, color: colors.textPrimary),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: colors.surface),
            Flexible(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    FilterSection(
                      title: 'Users',
                      onReset: _reset,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          chip(value: _UsersListFilter.all, label: 'All'),
                          chip(value: _UsersListFilter.newest, label: 'New'),
                          chip(value: _UsersListFilter.oldest, label: 'Old'),
                          chip(
                            value: _UsersListFilter.active,
                            label: 'Active',
                            dotColor: colors.secondary,
                          ),
                          chip(
                            value: _UsersListFilter.inactive,
                            label: 'Inactive',
                            dotColor: colors.error,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: colors.white,
                border:
                    Border(top: BorderSide(color: colors.surface, width: 1)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
                  child: Row(
                    children: [
                      OutlinedButton(
                        onPressed: _reset,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          side: BorderSide(color: colors.surface, width: 1.5),
                          backgroundColor: colors.surface.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Reset',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _apply,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: colors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Apply Filters',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: colors.white,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _LoadedContent extends StatelessWidget {
  final List<UserModel> users;
  final Future<void> Function({bool bypassThrottle}) onRefresh;

  const _LoadedContent({
    Key? key,
    required this.users,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return _EmptyContent(onRefresh: onRefresh);
    }

    return RefreshIndicator(
      onRefresh: () => onRefresh(bypassThrottle: false),
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return RepaintBoundary(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
              child: UserItem(
                onRefresh: () => onRefresh(bypassThrottle: true),
                model: users[index],
                count: '${index + 1}',
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EmptyContent extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const _EmptyContent({
    Key? key,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: const _ScrollableContent(
        icon: Icons.calendar_today_outlined,
        title: 'No users yet',
        subtitle: '',
      ),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  final String error;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final bool isRefreshing;

  const _ErrorContent({
    Key? key,
    required this.error,
    required this.onRefresh,
    required this.onRetry,
    required this.isRefreshing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: _ScrollableContent(
        icon: Icons.error_outline,
        title: 'Failed to users.',
        subtitle: error,
        action: ElevatedButton(
          onPressed: isRefreshing ? null : onRetry,
          child: isRefreshing
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Retry'),
        ),
      ),
    );
  }
}

class _ScrollableContent extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;

  const _ScrollableContent({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: constraints.maxHeight,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 64, color: colors.textPrimary),
                      const SizedBox(height: 24),
                      Text(
                        title,
                        style: TextStyle(
                          color: colors.black.withOpacity(0.8),
                          fontWeight: fontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colors.textPrimary,
                            ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (action != null) ...[
                        const SizedBox(height: 24),
                        action!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
