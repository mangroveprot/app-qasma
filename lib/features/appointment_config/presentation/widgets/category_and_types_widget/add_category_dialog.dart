import 'package:flutter/material.dart';

import '../../../../../infrastructure/theme/theme_extensions.dart';

class AddCategoryDialog extends StatefulWidget {
  final Function(String, String) onAddCategory;

  const AddCategoryDialog({super.key, required this.onAddCategory});

  @override
  State<AddCategoryDialog> createState() => AddCategoryDialogState();
}

class AddCategoryDialogState extends State<AddCategoryDialog> {
  late final TextEditingController nameController;
  late final TextEditingController descController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  void _handleAdd() {
    if (nameController.text.trim().isNotEmpty) {
      widget.onAddCategory(
        nameController.text.trim(),
        descController.text.trim(),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      Text(
                        'Category Name',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: context.weight.medium,
                          color: context.colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: nameController,
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                          fontSize: 15,
                          color: context.colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'e.g., Meeting, Interview, Event',
                          hintStyle: TextStyle(
                            color: context.colors.textPrimary.withOpacity(0.4),
                            fontSize: 15,
                          ),
                          filled: true,
                          fillColor:
                              context.colors.textPrimary.withOpacity(0.04),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Description Field
                      Text(
                        'Description (Optional)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: context.weight.medium,
                          color: context.colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: descController,
                        maxLines: 4,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _handleAdd(),
                        style: TextStyle(
                          fontSize: 15,
                          color: context.colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'Add a short description for this category...',
                          hintStyle: TextStyle(
                            color: context.colors.textPrimary.withOpacity(0.4),
                            fontSize: 15,
                          ),
                          filled: true,
                          fillColor:
                              context.colors.textPrimary.withOpacity(0.04),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color:
                                  context.colors.textPrimary.withOpacity(0.12),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color:
                                  context.colors.textPrimary.withOpacity(0.12),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: context.colors.secondary,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Add Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _handleAdd,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.secondary,
                            foregroundColor: context.colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: context.weight.medium,
                              color: context.colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.close,
                        color: context.colors.textPrimary.withOpacity(0.5),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
