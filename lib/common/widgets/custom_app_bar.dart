import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../infrastructure/theme/theme_extensions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String leadingText;
  final Color? backgroundColor;
  final Future<void> Function(BuildContext context)? onBackPressed;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.backgroundColor = Colors.transparent,
    this.leadingText = '',
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
            color: colors.black, fontSize: 14, fontWeight: fontWeight.medium),
      ),
      backgroundColor: backgroundColor,
      elevation: 0.0,
      centerTitle: true,
      leadingWidth: 100,
      leading: _buildLeadingGesture(context),
      // actions: [_buildActionGesture(context)],
    );
  }

  Widget _buildLeadingGesture(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;
    final radii = context.radii;
    final lowColor = colors.black.withOpacity(0.8);
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (onBackPressed != null) {
              onBackPressed!(context);
            } else {
              context.pop();
            }
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            width: 34,
            decoration: BoxDecoration(
              borderRadius: radii.small,
            ),
            child: Icon(Icons.arrow_back, color: lowColor, size: 24),
          ),
        ),
        if (leadingText.isNotEmpty)
          Text(
            leadingText,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: lowColor,
              fontWeight: fontWeight.medium,
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
