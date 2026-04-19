import 'package:flutter/material.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../data/models/user_model.dart';
import '../../bloc/user_cubit.dart';
import 'user_item.dart';

class UsersListContent extends StatelessWidget {
  final UserCubitState state;
  final List<UserModel> filteredUsers;
  final Future<void> Function({bool bypassThrottle}) onRefresh;
  final VoidCallback onRetry;
  final bool isRefreshing;

  const UsersListContent({
    super.key,
    required this.state,
    required this.filteredUsers,
    required this.onRefresh,
    required this.onRetry,
    required this.isRefreshing,
  });

  @override
  Widget build(BuildContext context) {
    if (state is UserLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is UserFailureState) {
      return _ScrollablePlaceholder(
        icon: Icons.error_outline,
        title: 'Failed to load users',
        subtitle: (state as UserFailureState).primaryError,
        onRefresh: () => onRefresh(),
        action: ElevatedButton(
            onPressed: isRefreshing ? null : onRetry,
            child: const Text('Retry')),
      );
    }

    if (filteredUsers.isEmpty) {
      return _ScrollablePlaceholder(
        icon: Icons.people_outline,
        title: 'No users found',
        subtitle: 'Try adjusting your filters or search query',
        onRefresh: () => onRefresh(),
      );
    }

    return RefreshIndicator(
      onRefresh: () => onRefresh(bypassThrottle: false),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
          child: UserItem(
            onRefresh: () => onRefresh(bypassThrottle: true),
            model: filteredUsers[index],
            count: '${index + 1}',
          ),
        ),
      ),
    );
  }
}

class _ScrollablePlaceholder extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Future<void> Function() onRefresh;
  final Widget? action;

  const _ScrollablePlaceholder({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onRefresh,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    size: 64,
                    color: context.colors.textPrimary.withOpacity(0.5)),
                const SizedBox(height: 16),
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(subtitle, textAlign: TextAlign.center),
                if (action != null) ...[const SizedBox(height: 20), action!],
              ],
            ),
          )
        ],
      ),
    );
  }
}
