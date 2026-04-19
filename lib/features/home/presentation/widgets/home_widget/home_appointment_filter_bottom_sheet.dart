import 'package:flutter/material.dart';

import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../preferences/presentation/widgets/dashboard_widget/_filter/filter_date_field.dart';
import '../../../../preferences/presentation/widgets/dashboard_widget/_filter/filter_quick_date_chip.dart';
import '../../../../preferences/presentation/widgets/dashboard_widget/_filter/filter_section.dart';
import '../../../../preferences/presentation/widgets/dashboard_widget/_filter/filter_status_chip.dart';
import '../../models/home_appointment_filter_model.dart';

class HomeAppointmentFilterBottomSheet extends StatefulWidget {
  final HomeAppointmentFilterModel initialFilter;
  final ValueChanged<HomeAppointmentFilterModel> onApply;

  const HomeAppointmentFilterBottomSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  @override
  State<HomeAppointmentFilterBottomSheet> createState() =>
      _HomeAppointmentFilterBottomSheetState();
}

class _HomeAppointmentFilterBottomSheetState
    extends State<HomeAppointmentFilterBottomSheet> {
  late HomeAppointmentFilterModel _currentFilter;
  DateTime? _tempDateFrom;
  DateTime? _tempDateTo;
  String? _activeQuickDate;

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.initialFilter;
    _tempDateFrom = widget.initialFilter.dateFrom;
    _tempDateTo = widget.initialFilter.dateTo;
  }

  void _setQuickDate(String type) {
    final today = DateTime.now();
    DateTime from, to;

    if (type == 'today') {
      from = DateTime(today.year, today.month, today.day);
      to = from;
    } else if (type == 'week') {
      final monday = today.subtract(Duration(days: today.weekday - 1));
      from = DateTime(monday.year, monday.month, monday.day);
      to = from.add(const Duration(days: 6));
    } else if (type == 'month') {
      from = DateTime(today.year, today.month, 1);
      final lastDay = DateTime(today.year, today.month + 1, 0);
      to = DateTime(lastDay.year, lastDay.month, lastDay.day);
    } else {
      return;
    }

    setState(() {
      _tempDateFrom = from;
      _tempDateTo = to;
      _activeQuickDate = type;
      _currentFilter = _currentFilter.copyWith(dateFrom: from, dateTo: to);
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

  void _resetDate() => setState(() {
        _tempDateFrom = null;
        _tempDateTo = null;
        _activeQuickDate = null;
        _currentFilter = _currentFilter.resetDate();
      });

  void _resetAll() => setState(() {
        _currentFilter = _currentFilter.reset();
        _tempDateFrom = null;
        _tempDateTo = null;
        _activeQuickDate = null;
      });

  void _applyFilters() {
    widget.onApply(_currentFilter);
    Navigator.of(context).pop();
  }

  Color? _overdueDotColor(String value) {
    final colors = context.colors;
    switch (value) {
      case 'overdue':
        return colors.error;
      case 'not_overdue':
        return colors.primary;
      default:
        return null;
    }
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
                    'Filter by',
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
                    child:
                        Icon(Icons.close, size: 22, color: colors.textPrimary),
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
                    FilterSection(
                      title: 'Date Range',
                      onReset: _resetDate,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: FilterDateField(
                                  label: 'From',
                                  date: _tempDateFrom,
                                  onTap: _selectDateFrom,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: FilterDateField(
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
                              FilterQuickDateChip(
                                type: 'today',
                                label: 'Today',
                                isActive: _activeQuickDate == 'today',
                                onTap: () => _setQuickDate('today'),
                              ),
                              const SizedBox(width: 8),
                              FilterQuickDateChip(
                                type: 'week',
                                label: 'This Week',
                                isActive: _activeQuickDate == 'week',
                                onTap: () => _setQuickDate('week'),
                              ),
                              const SizedBox(width: 8),
                              FilterQuickDateChip(
                                type: 'month',
                                label: 'This Month',
                                isActive: _activeQuickDate == 'month',
                                onTap: () => _setQuickDate('month'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: colors.surface),
                    FilterSection(
                      title: 'Overdue',
                      onReset: () => setState(
                          () => _currentFilter = _currentFilter.resetOverdue()),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilterStatusChip(
                            value: 'all',
                            label: 'All',
                            isSelected: _currentFilter.overdue == 'all',
                            dotColor: _overdueDotColor('all'),
                            onTap: () => setState(() => _currentFilter =
                                _currentFilter.copyWith(overdue: 'all')),
                          ),
                          FilterStatusChip(
                            value: 'overdue',
                            label: 'Overdue',
                            isSelected: _currentFilter.overdue == 'overdue',
                            dotColor: _overdueDotColor('overdue'),
                            onTap: () => setState(() => _currentFilter =
                                _currentFilter.copyWith(overdue: 'overdue')),
                          ),
                          FilterStatusChip(
                            value: 'not_overdue',
                            label: 'Not overdue',
                            isSelected: _currentFilter.overdue == 'not_overdue',
                            dotColor: _overdueDotColor('not_overdue'),
                            onTap: () => setState(() => _currentFilter =
                                _currentFilter.copyWith(overdue: 'not_overdue')),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: colors.surface),
                    FilterSection(
                      title: 'Sort by Date',
                      onReset: () => setState(
                          () => _currentFilter = _currentFilter.resetSort()),
                      child: _buildDropdown(
                        value: _currentFilter.sortBy,
                        items: const [
                          DropdownMenuItem(
                              value: 'newest', child: Text('Newest First')),
                          DropdownMenuItem(
                              value: 'oldest', child: Text('Oldest First')),
                        ],
                        onChanged: (v) => setState(() => _currentFilter =
                            _currentFilter.copyWith(sortBy: v ?? 'newest')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: colors.white,
                border: Border(top: BorderSide(color: colors.surface, width: 1)),
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
                              horizontal: 20, vertical: 14),
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

  Widget _buildDropdown({
    required String value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: colors.surface.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.surface, width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: colors.textPrimary.withOpacity(0.5), size: 20),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildApplyButton(colors) {
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
            Text(
              'Apply Filters',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colors.white,
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
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colors.white,
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

