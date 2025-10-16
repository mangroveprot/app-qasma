import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../infrastructure/theme/theme_extensions.dart';
import '../presentation/widgets/tool_tip_bubble_painter.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String leadingText;
  final Color? backgroundColor;
  final Future<void> Function(BuildContext context)? onBackPressed;
  final String? tooltipMessage;
  final VoidCallback? onTooltipTap;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.backgroundColor = Colors.transparent,
    this.leadingText = '',
    this.onBackPressed,
    this.tooltipMessage,
    this.onTooltipTap,
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
      actions: tooltipMessage != null ? [_buildTooltipAction(context)] : null,
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
            } else if (tooltipMessage != null) {
              _showInfoDialog(context);
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

  void _showInfoDialog(BuildContext context) {
    final fontWeight = context.weight;
    final colors = context.colors;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              top: kToolbarHeight - 15,
              right: 12,
              child: Material(
                color: Colors.transparent,
                child: CustomPaint(
                  painter: TooltipBubblePainter(),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4285F4),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: colors.white.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: Text(
                            tooltipMessage ?? 'No information available',
                            style: TextStyle(
                              color: colors.white,
                              fontSize: 12,
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              if (onTooltipTap != null) {
                                onTooltipTap!();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Text(
                                'GOT IT',
                                style: TextStyle(
                                  color: colors.white,
                                  fontSize: 12,
                                  fontWeight: fontWeight.bold,
                                  letterSpacing: 0.5,
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
            ),
          ],
        );
      },
    );
  }

  Widget _buildTooltipAction(BuildContext context) {
    final colors = context.colors;
    final lowColor = colors.black.withOpacity(0.8);

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () {
          _showInfoDialog(context);
          if (onTooltipTap != null) {
            onTooltipTap!();
          }
        },
        child: Icon(
          Icons.info_outline,
          color: lowColor,
          size: 24,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
