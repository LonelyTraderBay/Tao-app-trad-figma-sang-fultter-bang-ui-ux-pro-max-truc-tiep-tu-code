part of '../pages/margin_trading_page.dart';

class _PriceComparison extends StatelessWidget {
  const _PriceComparison({required this.prices});

  final TradeMarginReferencePrices prices;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(
            icon: Icons.show_chart_rounded,
            iconColor: _marginPrimary,
            title: 'Giá tham chiếu',
          ),
          const SizedBox(height: AppSpacing.x3),
          VitCard(
            padding: AppSpacing.zeroInsets.copyWith(
              left: AppSpacing.x4,
              top: AppSpacing.walletAssetHeroTopGap,
              right: AppSpacing.x4,
              bottom: AppSpacing.x4,
            ),
            variant: VitCardVariant.ghost,
            background: ColoredBox(
              color: _marginPrimary.withValues(alpha: .06),
            ),
            clip: true,
            child: Row(
              children: [
                Expanded(
                  child: _PriceColumn(
                    label: 'Mark Price',
                    value: _formatPriceWithDollar(prices.markPrice),
                    large: true,
                  ),
                ),
                const VitStatusPill(
                  label: 'Dùng cho thanh lý',
                  status: VitStatusPillStatus.info,
                  size: VitStatusPillSize.md,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PriceColumn(
                  label: 'Last Price',
                  value: _formatPriceWithDollar(prices.lastPrice),
                ),
              ),
              Text(
                'Giá khớp lệnh gần nhất',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PriceColumn(
                  label: 'Index Price',
                  value: _formatPriceWithDollar(prices.indexPrice),
                  dim: true,
                ),
              ),
              Text(
                'Avg của các sàn',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _InfoBanner(
            text:
                'Mark Price được dùng để tính PnL và thanh lý, giúp tránh manipulation từ flash crash.',
          ),
        ],
      ),
    );
  }
}

class _PriceColumn extends StatelessWidget {
  const _PriceColumn({
    required this.label,
    required this.value,
    this.large = false,
    this.dim = false,
  });

  final String label;
  final String value;
  final bool large;
  final bool dim;

  @override
  Widget build(BuildContext context) {
    final valueStyle = large
        ? AppTextStyles.amountSm
        : AppTextStyles.numericCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.hairlineStroke * 2),
        Text(
          value,
          style: valueStyle.copyWith(
            color: dim ? AppColors.text2 : AppColors.onAccent,
            fontWeight: large ? AppTextStyles.bold : AppTextStyles.medium,
          ),
        ),
      ],
    );
  }
}

class _PairCard extends StatelessWidget {
  const _PairCard({required this.snapshot});

  final TradeMarginTradingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      minHeight: 104,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.walletAssetSectionGap,
        top: AppSpacing.walletDepositCopyIcon,
        right: AppSpacing.walletAssetSectionGap,
        bottom: AppSpacing.rowPy,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                snapshot.pair.symbol,
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              _MiniBadge(
                label: snapshot.defaultMode.toUpperCase(),
                color: _marginPrimary,
              ),
              const SizedBox(width: AppSpacing.x2),
              const Expanded(child: SizedBox.shrink()),
              VitCard(
                width: AppSpacing.rowPy,
                height: AppSpacing.x3,
                radius: VitCardRadius.standard,
                variant: VitCardVariant.ghost,
                background: ColoredBox(
                  color: _marginRed.withValues(alpha: .06),
                ),
                clip: true,
                child: const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Text(
                '--',
                style: AppTextStyles.amountXs.copyWith(
                  color: AppColors.onAccent,
                ),
              ),
              const SizedBox(width: AppSpacing.transferCardGap),
              Text(
                snapshot.pair.quoteAsset,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.iconColor,
    required this.title,
  });

  final IconData icon;
  final Color iconColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: AppSpacing.inputPrefixIcon),
        const SizedBox(width: AppSpacing.x3),
        Text(
          title,
          style: AppTextStyles.body.copyWith(
            color: AppColors.onAccent,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}
