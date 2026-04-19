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
    final indicators = <String>[];
    if (!model.active) indicators.add('unregistered');
    if (!model.verified) indicators.add('uverified');

    final baseName = capitalizeWords(
        model.fullName.isEmpty ? 'Unknown User' : model.fullName);
    final displayTitle = '$count. $baseName';
    final isLongName = baseName.length > 22;
    final double titleFontSize = isLongName ? 13 : 14;

    final statusLabel = indicators.isEmpty
        ? null
        : indicators.map((e) => e.toLowerCase()).join('  ');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: CustomChevronButton(
        title: displayTitle,
        titleFontStyle:
            model.fullName.isEmpty ? FontStyle.italic : FontStyle.normal,
        onTap: () => _handleOnPressed(context, model.idNumber),
        fontSize: titleFontSize,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        trailing: statusLabel == null
            ? null
            : Text(
                statusLabel,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.redAccent,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
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
