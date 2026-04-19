import 'package:flutter/material.dart';

import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../data/models/category_type_model.dart';
import 'category_type_field.dart';

class CategoryTypeItem extends StatefulWidget {
  final String category;
  final int index;
  final CategoryTypeModel model;
  final Function(String, int, String, int) onUpdate;
  final Function(String, int) onRemove;

  const CategoryTypeItem({
    super.key,
    required this.category,
    required this.index,
    required this.model,
    required this.onUpdate,
    required this.onRemove,
  });

  @override
  State<CategoryTypeItem> createState() => _CategoryTypeItemState();
}

class _CategoryTypeItemState extends State<CategoryTypeItem> {
  late final TextEditingController _typeController;
  late final TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    _typeController = TextEditingController(text: widget.model.type);
    _durationController =
        TextEditingController(text: widget.model.duration.toString());
  }

  @override
  void didUpdateWidget(covariant CategoryTypeItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the underlying model changes (e.g. list reorder/remove),
    // ensure the text fields reflect the new model values, but avoid
    // blindly resetting the controller text on every change while the
    // user is typing. That behaviour can cause the first typed
    // character to be "eaten" or the cursor to jump.

    if (oldWidget.model.type != widget.model.type &&
        _typeController.text != widget.model.type) {
      _typeController
        ..text = widget.model.type
        ..selection = TextSelection.collapsed(
          offset: widget.model.type.length,
        );
    }

    final newDurationText = widget.model.duration.toString();
    if (oldWidget.model.duration.toString() != newDurationText &&
        _durationController.text != newDurationText) {
      _durationController
        ..text = newDurationText
        ..selection = TextSelection.collapsed(
          offset: newDurationText.length,
        );
    }
  }

  @override
  void dispose() {
    _typeController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: CategoryTypeField(
              label: 'Type',
              initialValue: widget.model.type,
              hintText: 'Enter type name',
              controller: _typeController,
              onChanged: (value) => widget.onUpdate(
                widget.category,
                widget.index,
                value,
                widget.model.duration,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: CategoryTypeField(
              label: 'Duration',
              initialValue: widget.model.duration.toString(),
              hintText: '30',
              keyboardType: TextInputType.number,
              suffixText: 'min',
              controller: _durationController,
              onChanged: (value) {
                final duration = int.tryParse(value) ?? 30;
                widget.onUpdate(
                  widget.category,
                  widget.index,
                  widget.model.type,
                  duration,
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Container(
            margin: const EdgeInsets.only(top: 24),
            child: IconButton(
              onPressed: () => widget.onRemove(widget.category, widget.index),
              icon: Icon(Icons.delete_outline, color: colors.error, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: colors.error.withOpacity(0.08),
                foregroundColor: colors.error,
                padding: const EdgeInsets.all(12),
                minimumSize: const Size(44, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              tooltip: 'Remove',
            ),
          ),
        ],
      ),
    );
  }
}
