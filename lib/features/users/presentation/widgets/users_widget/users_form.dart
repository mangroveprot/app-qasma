import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/utils/constant.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../data/models/user_model.dart';
import '../../bloc/user_cubit.dart';
import '../../pages/users_page.dart';
import 'user_item.dart';
import '../../../../../common/widgets/custom_search_bar.dart';

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

  List<UserModel> _getFilteredUsers(UserLoadedState state) {
    if (_lastProcessedState != state) {
      _cachedFilteredUsers = state.users.where((user) {
        final role = user.role.toLowerCase();
        return role == RoleType.student.field.toLowerCase();
      }).toList();

      _cachedFilteredUsers!.sort((a, b) =>
          a.first_name.toLowerCase().compareTo(b.first_name.toLowerCase()));

      _lastProcessedState = state;
    }

    if (_searchQuery.isEmpty) {
      return _cachedFilteredUsers!;
    }

    return _cachedFilteredUsers!.where((user) {
      final fullName = '${user.first_name} ${user.last_name}'.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return fullName.contains(query) ||
          user.first_name.toLowerCase().contains(query) ||
          user.last_name.toLowerCase().contains(query);
    }).toList();
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
            ),
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

  const _SearchBar({required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: CustomSearchBar(
        onSearchChanged: onSearchChanged,
        hintText: 'Search students...',
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
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
