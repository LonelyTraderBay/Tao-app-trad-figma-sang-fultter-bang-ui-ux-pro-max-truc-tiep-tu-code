part of '../pages/margin_trading_page.dart';

class _RiskWarningCard extends StatelessWidget {
  const _RiskWarningCard({required this.warning});

  final TradeMarginRiskWarning warning;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      color: _marginAmber.withValues(alpha: .06),
      borderColor: _marginAmber.withValues(alpha: .35),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _marginAmber,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  warning.title,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.onAccent,
                    fontWeight: AppTextStyles.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                for (final item in warning.items) ...[
                  _Bullet(text: item, color: _marginAmber),
                  if (item != warning.items.last) const SizedBox(height: 9),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NegativeBalanceCard extends StatelessWidget {
  const _NegativeBalanceCard({required this.disclosure});

  final TradeMarginSafetyDisclosure disclosure;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      color: _marginGreen.withValues(alpha: .07),
      borderColor: _marginGreen.withValues(alpha: .18),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _marginGreen.withValues(alpha: .13),
              borderRadius: AppRadii.cardRadius,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: _marginGreen,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  disclosure.title,
                  style: AppTextStyles.body.copyWith(
                    color: _marginGreen,
                    fontWeight: AppTextStyles.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  disclosure.body,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  disclosure.footer,
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

class _BestExecutionCard extends StatelessWidget {
  const _BestExecutionCard({required this.disclosure, required this.onTap});

  final TradeMarginBestExecutionDisclosure disclosure;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _marginPrimary.withValues(alpha: .13),
              borderRadius: AppRadii.cardRadius,
            ),
            child: const Icon(
              Icons.description_outlined,
              color: _marginPrimary,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  disclosure.title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.onAccent,
                    fontWeight: AppTextStyles.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  disclosure.body,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 8),
                for (final item in disclosure.items) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: _marginPrimary,
                        size: 13,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (item != disclosure.items.last) const SizedBox(height: 5),
                ],
                const SizedBox(height: 12),
                InkWell(
                  onTap: onTap,
                  borderRadius: AppRadii.smRadius,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _marginPrimary.withValues(alpha: .12),
                      borderRadius: AppRadii.smRadius,
                    ),
                    child: Text(
                      disclosure.actionLabel,
                      style: AppTextStyles.caption.copyWith(
                        color: _marginPrimary,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
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
