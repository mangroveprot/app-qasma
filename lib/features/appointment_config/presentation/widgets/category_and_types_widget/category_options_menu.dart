import 'package:flutter/material.dart';

import '../../../../../infrastructure/theme/theme_extensions.dart';
import 'add_category_dialog.dart';

class CategoryOptionsMenu extends StatelessWidget {
  final String category;
  final Function(String) onDeleteCategory;

  const CategoryOptionsMenu({
    super.key,
    required this.category,
    required this.onDeleteCategory,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'delete') {
            CategoryDialogs.showDeleteCategoryDialog(
                context, category, onDeleteCategory);
          }
        },
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(Icons.more_vert, color: colors.textPrimary, size: 18),
        ),
        itemBuilder: (context) => [
          PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete_outline, color: colors.error, size: 18),
                const SizedBox(width: 8),
                Text('Delete Category', style: TextStyle(color: colors.error)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryDialogs {
  static void showAddCategoryDialog(
      BuildContext context, Function(String, String) onAddCategory) {
    showDialog(
      context: context,
      builder: (context) => AddCategoryDialog(onAddCategory: onAddCategory),
    );
  }

  static void showDeleteCategoryDialog(BuildContext context, String category,
      Function(String) onDeleteCategory) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text(
            'Are you sure you want to delete the "$category" category and all its types? This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              onDeleteCategory(category);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: context.colors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  static void showRemoveLastTypeDialog(
    BuildContext context,
    String category,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category?'),
        content: Text(
          'Deleting the last type will remove the entire "$category" category. Continue?',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: context.colors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
