part of '../pages/staking_earnings_calendar_page.dart';

class _UpcomingList extends StatelessWidget {
  const _UpcomingList({required this.events});

  final List<StakingCalendarEventDraft> events;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const VitEmptyState(
        icon: Icons.calendar_today_rounded,
        title: 'Không có sự kiện nào',
        message: 'Lịch nhận lãi sẽ hiển thị khi bạn có vị thế staking.',
      );
    }

    return VitPageSection(
      key: StakingEarningsCalendarPage.listKey,
      label: 'Sự kiện sắp tới',
      accentColor: AppColors.primary,
      children: [
        for (final event in events)
          _EventCard(
            key: StakingEarningsCalendarPage.eventKey(event.id),
            event: event,
          ),
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({super.key, required this.event});

  final StakingCalendarEventDraft event;

  @override
  Widget build(BuildContext context) {
    final color = _eventColor(event.type);

    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: AppRadii.lgRadius,
            ),
            child: SizedBox(
              width: AppSpacing.buttonCompact + AppSpacing.x2,
              height: AppSpacing.buttonCompact + AppSpacing.x2,
              child: Icon(_eventIcon(event.type), color: color, size: 19),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        _eventLabel(event.type),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    _TimingPill(dateIso: event.dateIso),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  event.product,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${_formatDate(event.dateIso)} · ${event.description}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          _EventValue(event: event),
        ],
      ),
    );
  }
}

class _TimingPill extends StatelessWidget {
  const _TimingPill({required this.dateIso});

  final String dateIso;

  @override
  Widget build(BuildContext context) {
    final days = DateTime.parse(
      dateIso,
    ).difference(DateTime(2026, 3, 7)).inDays;
    final label = switch (days) {
      0 => 'Hôm nay',
      1 => 'Ngày mai',
      _ when days > 1 && days <= 7 => '$days ngày nữa',
      _ => null,
    };
    if (label == null) return const SizedBox.shrink();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary12,
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: 3,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.primarySoft,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _EventValue extends StatelessWidget {
  const _EventValue({required this.event});

  final StakingCalendarEventDraft event;

  @override
  Widget build(BuildContext context) {
    if (event.type == StakingCalendarEventType.rateChange) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${event.newRate?.toStringAsFixed(1) ?? '-'}%',
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.warn,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          Text(
            'từ ${event.oldRate?.toStringAsFixed(1) ?? '-'}%',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '+${_formatAmount(event.amount ?? 0)} ${event.asset}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          _formatUsd(event.usdValue ?? 0),
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingEarningsCalendarSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingEarningsCalendarPage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary30,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.calendar_month_rounded,
            color: AppColors.primarySoft,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.infoTitle,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                for (final bullet in snapshot.infoBullets)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.x1),
                    child: Text(
                      bullet,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.35,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<StakingCalendarEventDraft> _upcomingEvents(
  List<StakingCalendarEventDraft> events,
  DateTime today,
) {
  final list =
      [
        for (final event in events)
          if (!DateTime.parse(event.dateIso).isBefore(today)) event,
      ]..sort(
        (a, b) =>
            DateTime.parse(a.dateIso).compareTo(DateTime.parse(b.dateIso)),
      );
  return list.take(10).toList();
}

List<StakingCalendarEventDraft> _eventsForDay(
  List<StakingCalendarEventDraft> events,
  DateTime month,
  int day,
) {
  return [
    for (final event in events)
      if (_isSameCalendarDay(DateTime.parse(event.dateIso), month, day)) event,
  ];
}

bool _isSameCalendarDay(DateTime date, DateTime month, int day) {
  return date.year == month.year &&
      date.month == month.month &&
      date.day == day;
}

String _monthLabel(
  StakingEarningsCalendarSnapshot snapshot,
  DateTime visibleMonth,
) {
  if (visibleMonth.year == snapshot.currentYear &&
      visibleMonth.month == snapshot.currentMonth) {
    return snapshot.currentMonthLabel;
  }
  return 'Tháng ${visibleMonth.month} ${visibleMonth.year}';
}

Color _eventColor(StakingCalendarEventType type) {
  return switch (type) {
    StakingCalendarEventType.dailyReward => AppColors.buy,
    StakingCalendarEventType.maturity => AppColors.primary,
    StakingCalendarEventType.autoCompound => AppColors.accent,
    StakingCalendarEventType.rateChange => AppColors.warn,
  };
}

IconData _eventIcon(StakingCalendarEventType type) {
  return switch (type) {
    StakingCalendarEventType.dailyReward => Icons.attach_money_rounded,
    StakingCalendarEventType.maturity => Icons.schedule_rounded,
    StakingCalendarEventType.autoCompound => Icons.trending_up_rounded,
    StakingCalendarEventType.rateChange => Icons.show_chart_rounded,
  };
}

String _eventLabel(StakingCalendarEventType type) {
  return switch (type) {
    StakingCalendarEventType.dailyReward => 'Nhận lãi',
    StakingCalendarEventType.maturity => 'Đến hạn',
    StakingCalendarEventType.autoCompound => 'Tái đầu tư',
    StakingCalendarEventType.rateChange => 'Thay đổi APY',
  };
}

String _formatDate(String dateIso) {
  final date = DateTime.parse(dateIso);
  const weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
  return '${weekdays[date.weekday - 1]}, ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final raw = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final position = raw.length - i;
    buffer.write(raw[i]);
    if (position > 1 && position % 3 == 1) buffer.write(',');
  }
  return '\$${buffer.toString()}.${parts.last}';
}

String _formatAmount(double value) {
  final decimals = value < 1
      ? 2
      : value >= 10
      ? 2
      : 4;
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final raw = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final position = raw.length - i;
    buffer.write(raw[i]);
    if (position > 1 && position % 3 == 1) buffer.write(',');
  }
  return '${buffer.toString()}.${parts.last}';
}
