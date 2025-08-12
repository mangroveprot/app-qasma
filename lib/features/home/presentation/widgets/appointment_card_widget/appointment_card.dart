import 'package:flutter/material.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/helpers/spacing.dart';
import '../../../../../theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import 'card_cancel_button.dart';
import 'card_reschedule_button.dart';
import 'status_chip.dart';

class AppointmentCard extends StatefulWidget {
  final AppointmentModel appointment;
  final VoidCallback onCancel;
  final VoidCallback onReschedule;
  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onCancel,
    required this.onReschedule,
  });

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  bool _showActions = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;
    final radius = context.radii;
    final textPrimay = colors.textPrimary;

    final _divider = Container(
      height: 1,
      color: textPrimay.withOpacity(0.1),
    );

    final _labelTextStyle =
        TextStyle(fontSize: 14, color: colors.black, fontWeight: weight.medium);

    final _subtitleTextStyle = TextStyle(
      fontSize: 12,
      color: textPrimay,
    );

    final _titleTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: weight.bold,
      color: colors.black,
    );

    return Card(
      elevation: 4,
      color: colors.white,
      surfaceTintColor: colors.white,
      shadowColor: colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: radius.large,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // date/time and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: colors.black,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            formatUtcToLocal(
                                utcTime: widget.appointment.scheduledStartAt
                                    .toString(),
                                style: DateTimeFormatStyle.dateOnly),
                            style: _titleTextStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: colors.textPrimary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${formatUtcToLocal(utcTime: widget.appointment.scheduledStartAt.toString(), style: DateTimeFormatStyle.timeOnly)} - '
                            '${formatUtcToLocal(
                              utcTime:
                                  widget.appointment.scheduledEndAt.toString(),
                              style: DateTimeFormatStyle.timeOnly,
                            )}',
                            style: _subtitleTextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                StatusChip(status: widget.appointment.status),
              ],
            ),

            Spacing.verticalMedium,
            _divider,
            Spacing.verticalMedium,

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // left side - Appointment info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 16,
                            color: colors.textPrimary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  TextSpan(
                                    text: 'Category: ',
                                    style: _labelTextStyle,
                                  ),
                                  TextSpan(
                                    text: capitalizeWords(
                                        widget.appointment.appointmentCategory),
                                    style: _subtitleTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacing.verticalSmall,

                      // Description with icon
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.description_outlined,
                            size: 16,
                            color: colors.textPrimary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context)
                                    .style, // base style
                                children: [
                                  TextSpan(
                                      text: 'Description: ',
                                      style: _labelTextStyle),
                                  TextSpan(
                                      text: widget.appointment.description,
                                      style: _subtitleTextStyle),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacing.verticalXSmall,

                      // Appointment Type with icon
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.label_important_outline,
                            size: 16,
                            color: colors.textPrimary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context)
                                    .style, // base style
                                children: [
                                  TextSpan(
                                      text: 'Appointment Type: ',
                                      style: _labelTextStyle),
                                  TextSpan(
                                      text: widget.appointment.appointmentType,
                                      style: _subtitleTextStyle),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Spacing.verticalMedium,
            _divider,
            Spacing.verticalSmall,

            // See More / Actions
            GestureDetector(
              onTap: () {
                setState(() {
                  _showActions = !_showActions;
                });
              },
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  decoration: BoxDecoration(
                    //   color: colors.textPrimary.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _showActions ? 'See less' : 'See more',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textPrimary,
                          fontWeight: weight.medium,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _showActions
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: colors.textPrimary,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (_showActions) ...[
              Spacing.verticalMedium,
              // action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CardRescheduleButton(onPressed: widget.onReschedule),
                  const SizedBox(width: 8),
                  CardCancelButton(onPressed: widget.onCancel),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
