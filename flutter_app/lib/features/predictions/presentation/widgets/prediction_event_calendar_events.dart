part of '../pages/prediction_event_calendar_page.dart';

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.snapshot});

  final PredictionEventCalendarSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: _StatCell(
              label: 'Total',
              value: '${snapshot.events.length}',
            ),
          ),
          Expanded(
            child: _StatCell(
              label: 'Watching',
              value: '${snapshot.watchingCount}',
              color: _predictionPrimary,
            ),
          ),
          Expanded(
            child: _StatCell(
              label: 'This Month',
              value: '${snapshot.thisMonthCount}',
              color: AppColors.buy,
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthSection extends StatelessWidget {
  const _MonthSection({required this.month});

  final PredictionCalendarMonthDraft month;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: month.label,
      accentColor: _predictionPrimary,
      children: [
        for (final event in month.events) _CalendarEventCard(event: event),
      ],
    );
  }
}

class _CalendarEventCard extends StatelessWidget {
  const _CalendarEventCard({required this.event, this.urgent = false});

  final PredictionCalendarEventDraft event;
  final bool urgent;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(event.status);
    final statusBg = _statusBackground(event.status);
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        key: PredictionEventCalendarPage.eventKey(event.id),
        onTap: () => context.go(AppRoutePaths.marketsPredictionEvent(event.id)),
        borderRadius: AppRadii.cardRadius,
        child: VitCard(
          borderColor: urgent ? AppColors.warningBorder : AppColors.border,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (event.isWatching) ...[
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.warn,
                      size: 17,
                    ),
                    const SizedBox(width: 6),
                  ] else if (urgent) ...[
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.warn,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _statusLabel(event.status),
                      style: AppTextStyles.micro.copyWith(
                        color: statusColor,
                        fontWeight: AppTextStyles.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _EventMetric(
                      label: 'Resolution',
                      value: _shortDate(event.resolutionDate),
                    ),
                  ),
                  Expanded(
                    child: _EventMetric(
                      label: 'Probability',
                      value: '${event.probability}%',
                      valueColor: _predictionPrimary,
                    ),
                  ),
                  Expanded(
                    child: _EventMetric(
                      label: 'Volume',
                      value: _formatVolume(event.volume),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    color: AppColors.text3,
                    size: 12,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _daysUntil(event.resolutionDate),
                    style: AppTextStyles.micro.copyWith(
                      color: urgent ? AppColors.warn : AppColors.text3,
                      fontSize: 11,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.searchBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      event.category,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.text3,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UpcomingSection extends StatelessWidget {
  const _UpcomingSection({required this.snapshot});

  final PredictionEventCalendarSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Su kien sap dien ra',
      accentColor: _predictionPrimary,
      children: [
        for (final event in snapshot.upcomingEvents)
          _CalendarEventCard(event: event, urgent: _isUrgent(event)),
      ],
    );
  }
}
