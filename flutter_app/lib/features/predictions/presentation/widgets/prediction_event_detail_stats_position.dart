part of '../pages/prediction_event_detail_page.dart';

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.event});

  final PredictionEventDraft event;

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatItem(
        icon: Icons.bar_chart_rounded,
        label: 'Volume 24h',
        value: _formatVolume(event.volume24h),
        color: _predictionPrimary,
      ),
      _StatItem(
        icon: Icons.group_outlined,
        label: 'Participants',
        value: _formatInt(event.participants),
        color: _predictionPurple,
      ),
      _StatItem(
        icon: Icons.stacked_line_chart_rounded,
        label: 'Total Volume',
        value: _formatVolume(event.totalVolume),
        color: AppColors.buy,
      ),
      _StatItem(
        icon: Icons.schedule_rounded,
        label: 'Ends in',
        value: _timeRemaining(event.endDate),
        color: AppColors.warn,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 2.7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (final stat in stats)
          VitCard(
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: stat.color.withValues(alpha: .12),
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: Icon(stat.icon, color: stat.color, size: 15),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        stat.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      Text(
                        stat.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _StatItem {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
}

class _PositionBanner extends StatelessWidget {
  const _PositionBanner({required this.position});

  final PredictionDetailPositionDraft position;

  @override
  Widget build(BuildContext context) {
    final color = position.pnl >= 0 ? AppColors.buy : AppColors.sell;
    return VitCard(
      borderColor: color.withValues(alpha: .22),
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: AppColors.warn, size: 13),
              const SizedBox(width: 6),
              Text(
                'Your Position',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              _TinyBadge(
                label: position.outcome,
                color: position.outcome == 'Yes'
                    ? AppColors.buy
                    : AppColors.sell,
                background: position.outcome == 'Yes'
                    ? AppColors.buy10
                    : AppColors.sell10,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${position.shares.toStringAsFixed(0)} shares @ '
                  '${_formatPrice(position.avgPrice)}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 11,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${position.pnl >= 0 ? '+' : ''}'
                    '${_formatMoney(position.pnl)}',
                    style: AppTextStyles.caption.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    '${position.pnlPct >= 0 ? '+' : ''}'
                    '${position.pnlPct.toStringAsFixed(1)}%',
                    style: AppTextStyles.micro.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
