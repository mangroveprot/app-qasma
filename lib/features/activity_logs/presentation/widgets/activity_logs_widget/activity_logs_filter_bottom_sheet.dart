import 'package:flutter/material.dart';

import '../../../../../common/utils/constant.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../config/activity_logs_config.dart';
import '../../models/activity_logs_filter_model.dart';

class ActivityLogsFilterBottomSheet extends StatefulWidget {
  final ActivityLogsFilterModel initialFilter;
  final void Function(ActivityLogsFilterModel) onApply;

  const ActivityLogsFilterBottomSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  @override
  State<ActivityLogsFilterBottomSheet> createState() =>
      _ActivityLogsFilterBottomSheetState();
}

class _ActivityLogsFilterBottomSheetState
    extends State<ActivityLogsFilterBottomSheet> {
  late ActivityLogsFilterModel _currentFilter;
  DateTime? _tempDateFrom;
  DateTime? _tempDateTo;
  String? _activeQuickDate;

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.initialFilter;
    _tempDateFrom = _currentFilter.dateFrom;
    _tempDateTo = _currentFilter.dateTo;
  }

  void _setQuickDate(String type) {
    final today = DateTime.now();
    late DateTime from;
    late DateTime to;

    if (type == 'today') {
      from = DateTime(today.year, today.month, today.day);
      to = from;
    } else if (type == 'week') {
      final monday = today.subtract(Duration(days: today.weekday - 1));
      from = DateTime(monday.year, monday.month, monday.day);
      to = from.add(const Duration(days: 6));
    } else if (type == 'month') {
      from = DateTime(today.year, today.month, 1);
      final lastDayOfMonth = DateTime(today.year, today.month + 1, 0);
      to = DateTime(
        lastDayOfMonth.year,
        lastDayOfMonth.month,
        lastDayOfMonth.day,
      );
    } else {
      return;
    }

    setState(() {
      _tempDateFrom = from;
      _tempDateTo = to;
      _activeQuickDate = type;
      _currentFilter = _currentFilter.copyWith(
        dateFrom: from,
        dateTo: to,
      );
    });
  }

  Future<void> _selectDateFrom() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tempDateFrom ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _tempDateFrom = picked;
        _activeQuickDate = null;
        _currentFilter = _currentFilter.copyWith(dateFrom: picked);
      });
    }
  }

  Future<void> _selectDateTo() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tempDateTo ?? DateTime.now(),
      firstDate: _tempDateFrom ?? DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _tempDateTo = picked;
        _activeQuickDate = null;
        _currentFilter = _currentFilter.copyWith(dateTo: picked);
      });
    }
  }

  void _resetDate() {
    setState(() {
      _tempDateFrom = null;
      _tempDateTo = null;
      _activeQuickDate = null;
      _currentFilter = _currentFilter.resetDate();
    });
  }

  void _resetRole() {
    setState(() {
      _currentFilter = _currentFilter.resetRole();
    });
  }

  void _resetStatus() {
    setState(() {
      _currentFilter = _currentFilter.resetStatus();
    });
  }

  void _resetAll() {
    setState(() {
      _currentFilter = _currentFilter.reset();
      _tempDateFrom = null;
      _tempDateTo = null;
      _activeQuickDate = null;
    });
  }

  void _applyFilters() {
    widget.onApply(_currentFilter);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final maxHeight = MediaQuery.of(context).size.height - 60;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Container(
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 16, 16),
              child: Row(
                children: [
                  Text(
                    'Filter activity logs',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: colors.black,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.close,
                      size: 22,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: colors.surface),
            Flexible(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _FilterSection(
                      title: 'Category',
                      onReset: _resetStatus,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildStatusChip(
                            ActivityLogFilterStatus.all,
                            'All',
                          ),
                          _buildStatusChip(
                            ActivityLogFilterStatus.account,
                            'Account',
                          ),
                          _buildStatusChip(
                            ActivityLogFilterStatus.appointment,
                            'Appointment',
                          ),
                          _buildStatusChip(
                            ActivityLogFilterStatus.security,
                            'Security',
                          ),
                          _buildStatusChip(
                            ActivityLogFilterStatus.system,
                            'System',
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: colors.surface),
                    _FilterSection(
                      title: 'Date range',
                      onReset: _resetDate,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _FilterDateField(
                                  label: 'From',
                                  date: _tempDateFrom,
                                  onTap: _selectDateFrom,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _FilterDateField(
                                  label: 'To',
                                  date: _tempDateTo,
                                  onTap: _selectDateTo,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _QuickDateChip(
                                type: 'today',
                                label: 'Today',
                                isActive: _activeQuickDate == 'today',
                                onTap: () => _setQuickDate('today'),
                              ),
                              const SizedBox(width: 8),
                              _QuickDateChip(
                                type: 'week',
                                label: 'This week',
                                isActive: _activeQuickDate == 'week',
                                onTap: () => _setQuickDate('week'),
                              ),
                              const SizedBox(width: 8),
                              _QuickDateChip(
                                type: 'month',
                                label: 'This month',
                                isActive: _activeQuickDate == 'month',
                                onTap: () => _setQuickDate('month'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: colors.surface),
                    _FilterSection(
                      title: 'Role',
                      onReset: _resetRole,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildRoleChip('all', 'All'),
                          _buildRoleChip('student', 'Student'),
                          _buildRoleChip('staff', 'Staff'),
                          _buildRoleChip('counselor', 'Counselor'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: colors.white,
                border: Border(
                  top: BorderSide(color: colors.surface, width: 1),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
                  child: Row(
                    children: [
                      OutlinedButton(
                        onPressed: _resetAll,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          side: BorderSide(color: colors.surface, width: 1.5),
                          backgroundColor: colors.surface.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Reset',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: _buildApplyButton(colors)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(
    ActivityLogFilterStatus value,
    String label,
  ) {
    final colors = context.colors;
    final isSelected = _currentFilter.status == value;

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isSelected ? colors.white : colors.textPrimary,
        ),
      ),
      selected: isSelected,
      selectedColor: colors.primary,
      backgroundColor: colors.surface.withOpacity(0.4),
      onSelected: (_) {
        setState(() {
          _currentFilter = _currentFilter.copyWith(status: value);
        });
      },
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildRoleChip(String value, String label) {
    final colors = context.colors;
    final isSelected = _currentFilter.role.toLowerCase() == value;

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isSelected ? colors.white : colors.textPrimary,
        ),
      ),
      selected: isSelected,
      selectedColor: colors.primary,
      backgroundColor: colors.surface.withOpacity(0.4),
      onSelected: (_) {
        setState(() {
          _currentFilter = _currentFilter.copyWith(role: value);
        });
      },
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildApplyButton(dynamic colors) {
    final count = _currentFilter.activeFilterCount;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _applyFilters,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: colors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Apply filters',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: -0.2,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final VoidCallback onReset;
  final Widget child;

  const _FilterSection({
    required this.title,
    required this.onReset,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.black,
                  letterSpacing: -0.1,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onReset,
                child: Text(
                  'Reset',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _FilterDateField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const _FilterDateField({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: colors.textPrimary.withOpacity(0.55),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 5),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: colors.surface.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: date != null
                    ? colors.primary.withOpacity(0.4)
                    : colors.surface,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 13,
                  color: date != null
                      ? colors.primary
                      : colors.textPrimary.withOpacity(0.4),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    date != null ? _formatDate(date!) : 'Select',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: date != null
                          ? colors.black
                          : colors.textPrimary.withOpacity(0.4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${shortMonth[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }
}

class _QuickDateChip extends StatelessWidget {
  final String type;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _QuickDateChip({
    required this.type,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: isActive ? colors.white : colors.textPrimary,
        ),
      ),
      selected: isActive,
      selectedColor: colors.primary,
      backgroundColor: colors.surface.withOpacity(0.4),
      onSelected: (_) => onTap(),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
