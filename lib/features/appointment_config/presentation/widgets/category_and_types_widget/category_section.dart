import 'package:flutter/material.dart';

import '../../../../../common/widgets/custom_modal/custom_modal.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../data/models/category_type_model.dart';
import 'category_options_menu.dart';
import 'category_type_item.dart';

class CategorySection extends StatelessWidget {
  final String category;
  final String description;
  final List<CategoryTypeModel> types;
  final Function(String) onAddType;
  final Function(String) onDeleteCategory;
  final Function(String, int, String, int) onUpdateType;
  final Function(String, String) onUpdateDescription;
  final Function(String, int) onRemoveType;

  const CategorySection({
    super.key,
    required this.category,
    required this.description,
    required this.types,
    required this.onAddType,
    required this.onDeleteCategory,
    required this.onUpdateType,
    required this.onUpdateDescription,
    required this.onRemoveType,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 0.5,
      color: colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(colors, fontWeight),
            const SizedBox(height: 8),
            _buildDescriptionField(context),
            const SizedBox(height: 12),
            ...types.asMap().entries.map((entry) => CategoryTypeItem(
                  key: ValueKey('${category}_${entry.key}_${entry.value.type}'),
                  category: category,
                  index: entry.key,
                  model: entry.value,
                  onUpdate: onUpdateType,
                  onRemove: onRemoveType,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic colors, dynamic fontWeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            category,
            style: TextStyle(
              fontSize: 16,
              fontWeight: fontWeight.medium,
              color: colors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => onAddType(category),
              icon: Icon(Icons.add_rounded, color: colors.secondary, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: colors.secondary.withOpacity(0.12),
                minimumSize: const Size(36, 36),
                padding: const EdgeInsets.all(6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              tooltip: 'Add Type',
            ),
            const SizedBox(width: 6),
            CategoryOptionsMenu(
              category: category,
              onDeleteCategory: onDeleteCategory,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionField(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(
            fontSize: 12,
            color: colors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () => _showEditDescriptionBottomSheet(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.textPrimary.withOpacity(0.18)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    description.isEmpty
                        ? 'Add a short description'
                        : description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: description.isEmpty
                          ? colors.textPrimary.withOpacity(0.6)
                          : colors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.edit_outlined,
                    size: 18, color: colors.textPrimary.withOpacity(0.8)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showEditDescriptionBottomSheet(BuildContext context) {
    final colors = context.colors;
    final controller = TextEditingController(text: description);

    CustomModal.simpleShow(
      context: context,
      title: 'Edit description',
      maxHeight: MediaQuery.of(context).size.height * 0.7,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Text field
            TextField(
              controller: controller,
              autofocus: true,
              minLines: 3,
              maxLines: 5,
              maxLength: 200,
              decoration: InputDecoration(
                hintText: 'Write a short description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colors.textPrimary.withOpacity(0.2),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colors.textPrimary.withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colors.secondary,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Save button
            FilledButton(
              onPressed: () {
                onUpdateDescription(category, controller.text.trim());
                Navigator.of(context).pop();
              },
              style: FilledButton.styleFrom(
                backgroundColor: colors.secondary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
