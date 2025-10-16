import 'package:flutter/material.dart';

import '../../../../../infrastructure/theme/theme_extensions.dart';

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
            // color: colors.textPrimary.withOpacity(0.1),
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
      BuildContext context, Function(String) onAddCategory) {
    showDialog(
      context: context,
      builder: (context) => _AddCategoryDialog(onAddCategory: onAddCategory),
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

class _AddCategoryDialog extends StatefulWidget {
  final Function(String) onAddCategory;

  const _AddCategoryDialog({required this.onAddCategory});

  @override
  State<_AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<_AddCategoryDialog> {
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Category'),
      content: TextField(
        controller: textController,
        decoration: const InputDecoration(
          labelText: 'Category Name',
          hintText: 'e.g., Meeting, Interview',
        ),
        autofocus: true,
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            widget.onAddCategory(value.trim());
            Navigator.of(context).pop();
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (textController.text.trim().isNotEmpty) {
              widget.onAddCategory(textController.text.trim());
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
