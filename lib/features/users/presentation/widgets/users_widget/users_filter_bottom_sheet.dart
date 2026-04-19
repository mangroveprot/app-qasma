import 'package:flutter/material.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../preferences/presentation/widgets/dashboard_widget/_filter/filter_section.dart';
import '../../../../preferences/presentation/widgets/dashboard_widget/_filter/filter_status_chip.dart';
import 'users_form.dart';

class UsersFilterBottomSheet extends StatefulWidget {
  final UsersListFilter initialFilter;
  final ValueChanged<UsersListFilter> onApply;

  const UsersFilterBottomSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  @override
  State<UsersFilterBottomSheet> createState() => _UsersFilterBottomSheetState();
}

class _UsersFilterBottomSheetState extends State<UsersFilterBottomSheet> {
  late UsersListFilter _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialFilter;
  }

  void _apply() {
    widget.onApply(_current);
    Navigator.of(context).pop();
  }

  void _reset() => setState(() => _current = UsersListFilter.all);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final maxHeight = MediaQuery.of(context).size.height - 60;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Container(
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(colors),
            Divider(height: 1, color: colors.surface),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FilterSection(
                  title: 'User Categories',
                  onReset: _reset,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _chip(UsersListFilter.all, 'All'),
                      _chip(UsersListFilter.newest, 'Newest First'),
                      _chip(UsersListFilter.oldest, 'Oldest First'),
                      _chip(
                        UsersListFilter.active,
                        'Active Only',
                        dotColor: colors.secondary,
                      ),
                      _chip(
                        UsersListFilter.inactive,
                        'Inactive Only',
                        dotColor: colors.error,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildFooter(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 16, 16),
      child: Row(
        children: [
          Text(
            'Filter Students',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colors.black,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, size: 22, color: colors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(dynamic colors) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
      decoration: BoxDecoration(
        color: colors.white,
        border: Border(top: BorderSide(color: colors.surface, width: 1)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: _reset,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: colors.surface, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child:
                    Text('Reset', style: TextStyle(color: colors.textPrimary)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _apply,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: colors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Apply Filters',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(UsersListFilter value, String label, {Color? dotColor}) {
    return FilterStatusChip(
      value: value.name,
      label: label,
      isSelected: _current == value,
      dotColor: dotColor,
      onTap: () => setState(() => _current = value),
    );
  }
}
