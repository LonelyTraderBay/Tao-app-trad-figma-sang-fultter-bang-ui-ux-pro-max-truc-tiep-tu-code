part of 'prediction_event_detail_page.dart';

class _QuickLinks extends StatelessWidget {
  const _QuickLinks({required this.onRewards, required this.onActivity});

  final VoidCallback onRewards;
  final VoidCallback onActivity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickLinkCard(
            key: PredictionEventDetailPage.dailyRewardsKey,
            icon: Icons.card_giftcard_rounded,
            color: AppColors.warn,
            title: 'Daily Rewards',
            subtitle: 'Earn by providing liquidity',
            onTap: onRewards,
          ),
        ),
        const SizedBox(width: AppSpacing.predictionDetailQuickLinkGap),
        Expanded(
          child: _QuickLinkCard(
            key: PredictionEventDetailPage.globalActivityKey,
            icon: Icons.timeline_rounded,
            color: _predictionPurple,
            title: 'Global Activity',
            subtitle: 'Live trading feed',
            onTap: onActivity,
          ),
        ),
      ],
    );
  }
}

class _QuickLinkCard extends StatelessWidget {
  const _QuickLinkCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      padding: AppSpacing.predictionDetailQuickLinkPadding,
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: AppSpacing.predictionDetailQuickLinkIcon,
          ),
          const SizedBox(width: AppSpacing.predictionDetailQuickLinkGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: AppColors.text3,
          size: AppSpacing.predictionHomeStatIcon,
        ),
        const SizedBox(width: AppSpacing.predictionHomeStatIconGap),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _ChangeLabel extends StatelessWidget {
  const _ChangeLabel({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final color = value >= 0 ? AppColors.buy : AppColors.sell;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          value >= 0 ? Icons.arrow_outward_rounded : Icons.south_east_rounded,
          color: color,
          size: AppSpacing.predictionHomeTrendIcon,
        ),
        Text(
          _formatPercent(value),
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: AppRadii.badgeRadius,
      child: Padding(
        padding: AppSpacing.predictionHomeBadgePadding,
        child: Text(label, style: AppTextStyles.badge.copyWith(color: color)),
      ),
    );
  }
}

String _formatVolume(double value) {
  if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(0)}K';
  return '\$${value.toStringAsFixed(0)}';
}

String _formatMoney(double value) {
  final absValue = value.abs();
  return '\$${absValue.toStringAsFixed(2)}';
}

String _formatPrice(double value) {
  return '\$${value.toStringAsFixed(2)}';
}

String _formatInt(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var index = 0; index < text.length; index += 1) {
    if (index > 0 && (text.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(text[index]);
  }
  return buffer.toString();
}

String _formatPercent(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(1)}%';
}

String _formatDate(DateTime value) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${months[value.month - 1]} ${value.day}, ${value.year}';
}

String _timeRemaining(DateTime endDate) {
  final now = DateTime.utc(2026, 2, 27, 12);
  final diff = endDate.difference(now);
  if (diff.isNegative) return 'Ended';
  final days = diff.inDays;
  if (days > 30) return '${days ~/ 30} tháng';
  if (days > 0) return '$days ngày';
  return '${diff.inHours}h';
}
