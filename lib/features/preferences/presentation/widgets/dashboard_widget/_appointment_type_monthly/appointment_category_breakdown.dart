import 'package:flutter/material.dart';

import '../../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../../appointment/data/models/appointment_model.dart';

/// Categories & Types expansion list; accepts a filtered list (e.g. by year).
class AppointmentCategoryBreakdown extends StatefulWidget {
  final List<AppointmentModel> appointments;

  const AppointmentCategoryBreakdown({
    Key? key,
    required this.appointments,
  }) : super(key: key);

  @override
  State<AppointmentCategoryBreakdown> createState() =>
      _AppointmentCategoryBreakdownState();
}

class _AppointmentCategoryBreakdownState
    extends State<AppointmentCategoryBreakdown> {
  final Set<String> _expandedCategories = {};

  Map<String, Map<String, int>> _buildCategoryTypeCounts(
    List<AppointmentModel> appointments,
  ) {
    final Map<String, Map<String, int>> result = {};
    for (final appointment in appointments) {
      final category = appointment.appointmentCategory.trim();
      final type = appointment.appointmentType.trim();
      if (category.isEmpty || type.isEmpty) continue;
      result.putIfAbsent(category, () => {});
      result[category]![type] = (result[category]![type] ?? 0) + 1;
    }
    return result;
  }

  int _categoryTotal(Map<String, int> types) {
    return types.values.fold(0, (sum, v) => sum + v);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;
    final categoryTypeCounts = _buildCategoryTypeCounts(widget.appointments);

    if (categoryTypeCounts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Text(
            'No appointment category and type data available',
            style: TextStyle(fontSize: 12, color: colors.secondary),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories & Types',
          style: TextStyle(
            fontSize: 13,
            fontWeight: fontWeight.medium,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        ...categoryTypeCounts.entries.map((entry) {
          final category = entry.key;
          final types = entry.value;
          final total = _categoryTotal(types);
          final isExpanded = _expandedCategories.contains(category);

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: colors.surface.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.surface, width: 1),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: fontWeight.medium,
                          color: colors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.event_note,
                            size: 14,
                            color: colors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$total',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: fontWeight.bold,
                              color: colors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                trailing: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: colors.secondary,
                ),
                onExpansionChanged: (expanded) {
                  setState(() {
                    if (expanded) {
                      _expandedCategories.add(category);
                    } else {
                      _expandedCategories.remove(category);
                    }
                  });
                },
                children: types.entries.map((typeEntry) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  borderRadius: BorderRadius.circular(99),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  typeEntry.key,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${typeEntry.value}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: fontWeight.medium,
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
