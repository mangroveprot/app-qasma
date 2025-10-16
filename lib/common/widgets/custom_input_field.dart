import 'package:flutter/material.dart';
import '../../infrastructure/theme/theme_extensions.dart';
import '../presentation/widgets/tool_tip_bubble_painter.dart';

class CustomInputField extends StatefulWidget {
  final String fieldName;
  final String? label;
  final String? tooltip;
  final double? fontSize;
  final FontWeight? fontWeight;
  final IconData? icon;
  final Color? iconColor;
  final TextEditingController controller;
  final VoidCallback onChanged;
  final bool isEnabled;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final bool expands;

  const CustomInputField({
    super.key,
    required this.fieldName,
    this.label,
    this.tooltip,
    this.fontSize,
    this.fontWeight,
    required this.controller,
    required this.onChanged,
    this.iconColor,
    this.icon,
    this.isEnabled = true,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField>
    with WidgetsBindingObserver {
  final GlobalKey _fieldKey = GlobalKey();
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
    final customFontWeight = context.weight;
    final radius = context.radii;

    return Container(
      key: _fieldKey,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: radius.medium,
              border: Border.all(
                color: colors.white.withOpacity(0.4),
                width: 1,
              ),
              color: colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.icon != null) ...[
                    Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (widget.iconColor?.withOpacity(0.1)) ??
                              Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(widget.icon,
                            color: widget.iconColor ?? colors.textPrimary,
                            size: 20)),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.label != null) ...[
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.label!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: customFontWeight.medium,
                                    color: colors.textPrimary,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                              if (widget.tooltip != null) ...[
                                const SizedBox(width: 8),
                                GestureDetector(
                                  key: _infoIconKey,
                                  onTap: _showTooltip,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.info_outline,
                                      size: 16,
                                      color:
                                          colors.textPrimary.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                        ],
                        TextFormField(
                          controller: widget.controller,
                          enabled: widget.isEnabled,
                          maxLines: widget.maxLines,
                          minLines: widget.minLines,
                          expands: widget.expands,
                          style: TextStyle(
                            fontSize: widget.fontSize ?? 16,
                            fontWeight:
                                widget.fontWeight ?? customFontWeight.medium,
                            color: widget.isEnabled
                                ? colors.black
                                : colors.black.withOpacity(0.5),
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                          onChanged: (_) => widget.onChanged(),
                          keyboardType: widget.keyboardType,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
