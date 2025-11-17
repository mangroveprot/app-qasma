import 'package:flutter/material.dart';
import '../../../../../theme/theme_extensions.dart';

class MenuHeader extends StatelessWidget {
  final String user_name;
  final String idNumber;

  const MenuHeader({
    super.key,
    required this.user_name,
    required this.idNumber,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;

    return Container(
      width: double.infinity,
      color: colors.primary,
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.white,
            ),
            child: Icon(
              Icons.person_outline,
              color: colors.black.withOpacity(0.6),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user_name,
                  style: TextStyle(
                    color: colors.white,
                    fontSize: 15,
                    fontWeight: weight.medium,
                    letterSpacing: 0,
                    height: 1.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 2),
                Text(
                  idNumber,
                  style: TextStyle(
                    color: colors.white,
                    fontSize: 13,
                    fontWeight: weight.regular,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.close,
                  color: colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
