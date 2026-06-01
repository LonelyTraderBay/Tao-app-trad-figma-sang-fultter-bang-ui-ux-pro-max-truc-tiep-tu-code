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
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.buy.withValues(alpha: .12),
                borderRadius: AppRadii.mdRadius,
              ),
              child: const Icon(
                Icons.mail_outline_rounded,
                color: AppColors.buy,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _emailPurple.withValues(alpha: .13),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: const Icon(
                  Icons.mail_outline_rounded,
                  color: _emailPurple,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    border: Border.all(color: AppColors.borderSolid),
                    borderRadius: AppRadii.mdRadius,
                  ),
                  child: TextField(
                    key: PredictionsBreakingPage.emailFieldKey,
                    controller: controller,
                    keyboardType: TextInputType.emailAddress,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText: 'your@email.com',
                      hintStyle: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                key: PredictionsBreakingPage.subscribeKey,
                onTap: onSubscribe,
                borderRadius: AppRadii.mdRadius,
                child: Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _emailPurple,
                    borderRadius: AppRadii.mdRadius,
                    boxShadow: [
                      BoxShadow(
                        color: _emailPurple.withValues(alpha: .26),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    'Subscribe',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onAccent,
                      fontWeight: AppTextStyles.bold,
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
    return SizedBox(
      height: 220,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bolt_rounded,
              color: AppColors.text3.withValues(alpha: .42),
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              'No movers in this category',
              style: AppTextStyles.body.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try selecting a different category',
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ],
        ),
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
