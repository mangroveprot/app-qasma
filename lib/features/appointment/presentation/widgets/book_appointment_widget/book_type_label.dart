import 'package:flutter/material.dart';

import '../../../../../common/presentation/widgets/tool_tip_bubble_painter.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class BookTypeLabel extends StatefulWidget {
  final String text;
  final String? tooltip;

  const BookTypeLabel({
    super.key,
    required this.text,
    this.tooltip,
  });

  @override
  State<BookTypeLabel> createState() => _BookTypeLabelState();
}

class _BookTypeLabelState extends State<BookTypeLabel>
    with WidgetsBindingObserver {
  final GlobalKey _infoIconKey = GlobalKey();
  bool _isTooltipVisible = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _hideTooltip();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (_isTooltipVisible) {
      _hideTooltip();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state != AppLifecycleState.resumed && _isTooltipVisible) {
      _hideTooltip();
    }
  }

  void _showTooltip() {
    if (_isTooltipVisible) return;

    setState(() {
      _isTooltipVisible = true;
    });

    final colors = context.colors;

    final RenderBox? renderBox =
        _infoIconKey.currentContext?.findRenderObject() as RenderBox?;
    final position = renderBox?.localToGlobal(Offset.zero);
    final size = renderBox?.size;

    if (position == null || size == null) return;

    final tooltipWidth = 200.0;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _hideTooltip,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
          ),
          Positioned(
            top: position.dy + size.height,
            left: position.dx + size.width - tooltipWidth + 5,
            child: Material(
              color: Colors.transparent,
              child: CustomPaint(
                painter: TooltipBubblePainter(),
                child: Container(
                  width: tooltipWidth,
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                    minWidth: 180,
                  ),
                  margin: const EdgeInsets.only(top: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4285F4),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: colors.black.withOpacity(0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            widget.tooltip!,
                            style: TextStyle(
                              color: colors.white,
                              fontSize: 12,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _hideTooltip,
                        child: Icon(
                          Icons.close,
                          color: colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideTooltip() {
    if (!_isTooltipVisible) return;

    _overlayEntry?.remove();
    _overlayEntry = null;

    setState(() {
      _isTooltipVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.text,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 14,
                    fontWeight: weight.medium,
                  ),
                ),
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: colors.error,
                    fontSize: 14,
                    fontWeight: weight.medium,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          if (widget.tooltip != null) ...[
            GestureDetector(
              key: _infoIconKey,
              onTap: _showTooltip,
              child: Container(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.info_outline,
                  size: 16,
                  color: colors.textPrimary.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
