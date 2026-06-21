part of '../pages/predictions_breaking_page.dart';

class _EmailCta extends StatelessWidget {
  const _EmailCta({
    required this.controller,
    required this.subscribed,
    required this.onSubscribe,
  });

  final TextEditingController controller;
  final bool subscribed;
  final VoidCallback onSubscribe;

  @override
  Widget build(BuildContext context) {
    if (subscribed) {
      return VitCard(
        borderColor: AppColors.buy.withValues(alpha: .24),
        density: VitDensity.compact,
        padding: AppSpacing.cardPaddingCompact,
        child: Row(
          children: [
            Material(
              color: AppColors.buy.withValues(alpha: .12),
              borderRadius: AppRadii.mdRadius,
              child: const SizedBox.square(
                dimension: _breakingIconBox,
                child: Icon(
                  Icons.mail_outline_rounded,
                  color: AppColors.buy,
                  size: AppSpacing.x4,
                ),
              ),
            ),
            const SizedBox(width: _breakingSpace),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subscribed!',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    "You'll receive daily prediction updates",
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return VitCard(
      borderColor: _emailPurple.withValues(alpha: .24),
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        children: [
          Row(
            children: [
              Material(
                color: _emailPurple.withValues(alpha: .13),
                borderRadius: AppRadii.mdRadius,
                child: const SizedBox.square(
                  dimension: _breakingIconBox,
                  child: Icon(
                    Icons.mail_outline_rounded,
                    color: _emailPurple,
                    size: AppSpacing.x4,
                  ),
                ),
              ),
              const SizedBox(width: _breakingSpace),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Get daily updates',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      'Top movers & trending markets in your inbox',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: _breakingSpace),
          Row(
            children: [
              Expanded(
                child: VitInput(
                  fieldKey: PredictionsBreakingPage.emailFieldKey,
                  controller: controller,
                  keyboardType: TextInputType.emailAddress,
                  semanticLabel: 'Prediction breaking email',
                  hintText: 'your@email.com',
                  textStyle: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                  ),
                ),
              ),
              const SizedBox(width: _breakingSpace),
              Material(
                color: _emailPurple,
                borderRadius: AppRadii.mdRadius,
                key: PredictionsBreakingPage.subscribeKey,
                child: InkWell(
                  onTap: onSubscribe,
                  borderRadius: AppRadii.mdRadius,
                  child: SizedBox(
                    height: _breakingCtaHeight,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: AppSpacing.x3,
                      ),
                      child: Center(
                        child: Text(
                          'Subscribe',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.onAccent,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BreakingEmptyState extends StatelessWidget {
  const _BreakingEmptyState();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bolt_rounded,
            color: AppColors.text3.withValues(alpha: .42),
            size: _breakingIconBox,
          ),
          const SizedBox(height: _breakingSpace),
          Text(
            'No movers in this category',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _breakingTinySpace),
          Text(
            'Try selecting a different category',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

String _formatVolume(double value) {
  if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(0)}K';
  return '\$${value.toStringAsFixed(0)}';
}

String _formatPercent(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(1)}%';
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
