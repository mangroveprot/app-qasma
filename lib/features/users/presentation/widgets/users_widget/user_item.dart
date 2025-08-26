import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/widgets/custom_chevron_button.dart';
import '../../../../../infrastructure/routes/app_routes.dart';
import '../../../data/models/user_model.dart';

class UserItem extends StatelessWidget {
  final UserModel model;
  final Future<void> Function() onRefresh;
  final String count;
  const UserItem({
    super.key,
    required this.model,
    required this.count,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: CustomChevronButton(
        title: '${count}. ${capitalizeWords(model.fullName)}',
        onTap: () => _handleOnPressed(context, model.idNumber),
        fontSize: 14,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      ),
    );
  }

  void _handleOnPressed(BuildContext context, String idNumber,
      [bool isCurrentUser = false]) {
    context.push(
      Routes.buildPath(Routes.user_path, Routes.user_profile),
      extra: {
        'idNumber': idNumber,
        'isCurrentUser': isCurrentUser,
        'onSuccess': () async {
          await onRefresh();
        },
      },
    );
  }
}
