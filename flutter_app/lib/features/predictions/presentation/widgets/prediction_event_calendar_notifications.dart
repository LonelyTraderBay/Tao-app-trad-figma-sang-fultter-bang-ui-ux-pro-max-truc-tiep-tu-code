part of '../pages/prediction_event_calendar_page.dart';

class _NotificationSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const settings = [
      (
        label: 'Resolution Reminder',
        desc: 'Thong bao truoc khi su kien chot ket qua',
      ),
      (label: 'Price Alert', desc: 'Canh bao khi xac suat thay doi lon'),
      (
        label: 'New Events',
        desc: 'Thong bao su kien moi theo danh muc quan tam',
      ),
    ];
    return VitPageSection(
      label: 'Cai dat thong bao',
      accentColor: _predictionPrimary,
      children: [
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              for (var i = 0; i < settings.length; i += 1)
                _NotificationSettingRow(
                  label: settings[i].label,
                  description: settings[i].desc,
                  showDivider: i < settings.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WatchingSection extends StatelessWidget {
  const _WatchingSection({required this.snapshot});

  final PredictionEventCalendarSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Dang theo doi',
      accentColor: _predictionPrimary,
      children: [
        for (final event in snapshot.watchingEvents)
          VitCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.warn,
                      size: 17,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event.title,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: AppTextStyles.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    event.category,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
                const SizedBox(height: 14),
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
                        label: 'Notify Before',
                        value: event.notifyBefore ?? 'Not set',
                        valueColor: _predictionPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 38,
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      border: Border.all(color: AppColors.border),
                      borderRadius: AppRadii.mdRadius,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.notifications_none_rounded,
                          color: AppColors.text1,
                          size: 15,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Chinh sua thong bao',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _NotificationInfo extends StatelessWidget {
  const _NotificationInfo();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.primary15,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _predictionPrimary,
            size: 15,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Thong bao giup ban khong bo lo su kien quan trong. Ban se nhan canh bao qua app va email.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationSettingRow extends StatelessWidget {
  const _NotificationSettingRow({
    required this.label,
    required this.description,
    required this.showDivider,
  });

  final String label;
  final String description;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.border))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const _TogglePill(),
        ],
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  const _TogglePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 28,
      decoration: BoxDecoration(
        color: _predictionPrimary,
        borderRadius: AppRadii.inputRadius,
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.all(2),
      child: Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: AppColors.onAccent,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontSize: 20,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _EventMetric extends StatelessWidget {
  const _EventMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

bool _isUrgent(PredictionCalendarEventDraft event) {
  final days = event.resolutionDate
      .difference(DateTime.utc(2026, 5, 20))
      .inDays;
  return days >= 0 && days <= 7;
}

Color _statusColor(PredictionCalendarEventStatus status) {
  return switch (status) {
    PredictionCalendarEventStatus.active => AppColors.buy,
    PredictionCalendarEventStatus.upcoming => AppColors.warn,
    PredictionCalendarEventStatus.resolving => _predictionPrimary,
    PredictionCalendarEventStatus.resolved => AppColors.text3,
  };
}

Color _statusBackground(PredictionCalendarEventStatus status) {
  return switch (status) {
    PredictionCalendarEventStatus.active => AppColors.buy10,
    PredictionCalendarEventStatus.upcoming => AppColors.warn10,
    PredictionCalendarEventStatus.resolving => AppColors.primary08,
    PredictionCalendarEventStatus.resolved => AppColors.text3.withValues(
      alpha: .08,
    ),
  };
}

String _statusLabel(PredictionCalendarEventStatus status) {
  return switch (status) {
    PredictionCalendarEventStatus.active => 'ACTIVE',
    PredictionCalendarEventStatus.upcoming => 'UPCOMING',
    PredictionCalendarEventStatus.resolving => 'RESOLVING',
    PredictionCalendarEventStatus.resolved => 'RESOLVED',
  };
}

String _shortDate(DateTime date) {
  const months = [
    'thg 1',
    'thg 2',
    'thg 3',
    'thg 4',
    'thg 5',
    'thg 6',
    'thg 7',
    'thg 8',
    'thg 9',
    'thg 10',
    'thg 11',
    'thg 12',
  ];
  return '${date.day} ${months[date.month - 1]}';
}

String _daysUntil(DateTime date) {
  final days = date.difference(DateTime.utc(2026, 5, 20)).inDays;
  if (days < 0) return 'Da qua';
  if (days == 0) return 'Hom nay';
  if (days == 1) return '1 ngay';
  if (days < 30) return '$days ngay';
  return '${days ~/ 30} thang';
}

String _formatVolume(double value) =>
    '\$${(value / 1000000).toStringAsFixed(1)}M';
