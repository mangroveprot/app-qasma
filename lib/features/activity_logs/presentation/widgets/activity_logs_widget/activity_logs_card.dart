import 'package:flutter/material.dart';

import '../../../data/models/activity_log_model.dart';
import '../../../../users/data/models/user_model.dart';
import '../../config/activity_logs_config.dart';
import '../../utils/activity_logs_util.dart';

class ActivityLogsCard extends StatefulWidget {
  final ActivityLogModel log;
  final List<UserModel>? users;
  final bool isExpanded;
  final VoidCallback onTap;

  const ActivityLogsCard({
    super.key,
    required this.log,
    this.users,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<ActivityLogsCard> createState() => _ActivityLogsCardState();
}

class _ActivityLogsCardState extends State<ActivityLogsCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _expandAnim;
  late final Animation<double> _rotateAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _expandAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _rotateAnim = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    if (widget.isExpanded) _ctrl.value = 1.0;
  }

  @override
  void didUpdateWidget(ActivityLogsCard old) {
    super.didUpdateWidget(old);
    if (widget.isExpanded != old.isExpanded) {
      widget.isExpanded ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meta = activityCategoryMeta[widget.log.category]!;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.isExpanded
                ? const Color(0xFFD6E8D8)
                : const Color(0xFFF0F0F0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(widget.isExpanded ? 0.04 : 0.02),
              blurRadius: widget.isExpanded ? 10 : 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Main Row ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: meta.iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(meta.icon, color: meta.iconColor, size: 17),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.log.action,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1F1F1F),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            meta.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: meta.iconColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD0D0D0),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            formatRelativeTime(widget.log.createdAt),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFFAAAAAA),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                RotationTransition(
                  turns: _rotateAnim,
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFFCCCCCC),
                    size: 18,
                  ),
                ),
              ],
            ),

            SizeTransition(
              sizeFactor: _expandAnim,
              axisAlignment: -1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Container(height: 1, color: const Color(0xFFF2F2F2)),
                  const SizedBox(height: 12),
                  _buildDetails(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails() {
    final rows = buildDetailEntries(widget.log, widget.users);

    return Column(
      children: rows
          .asMap()
          .entries
          .map(
            (e) => Padding(
              padding: EdgeInsets.only(bottom: e.key < rows.length - 1 ? 7 : 0),
              child: _DetailRow(entry: e.value),
            ),
          )
          .toList(),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final DetailEntry entry;
  const _DetailRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            entry.label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFFAAAAAA),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            entry.value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF555555),
            ),
          ),
        ),
      ],
    );
  }
}
