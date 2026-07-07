part of 'staking_liquid_staking_page.dart';

class _BenefitsGrid extends StatelessWidget {
  const _BenefitsGrid({required this.snapshot});

  final StakingLiquidStakingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingLiquidStakingPage.benefitsKey,
      label: 'Lợi ích Liquid Staking',
      accentColor: AppColors.primary,
      children: [
        GridView.builder(
          itemCount: snapshot.benefits.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: EarnSpacingTokens.stakingProductGridColumns,
            crossAxisSpacing: AppSpacing.x4,
            mainAxisSpacing: AppSpacing.x4,
            childAspectRatio:
                EarnSpacingTokens.stakingProductLiquidBenefitAspect,
          ),
          itemBuilder: (context, index) {
            final benefit = snapshot.benefits[index];
            return VitCard(
              radius: VitCardRadius.large,
              padding: AppSpacing.cardPaddingCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    color: AppColors.primary12,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.lgRadius,
                      side: const BorderSide(color: AppColors.primary30),
                    ),
                    child: SizedBox(
                      width: AppSpacing.ctaHeight,
                      height: AppSpacing.ctaHeight,
                      child: Icon(
                        _benefitIcon(benefit.icon),
                        color: AppColors.primarySoft,
                        size: AppSpacing.iconMd,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    benefit.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    benefit.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: AppSpacing.zeroInsets.copyWith(
          left: AppSpacing.contentPad,
          top: AppSpacing.contentPad,
          right: AppSpacing.contentPad,
          bottom: AppSpacing.contentPad,
        ),
        child: VitSheetSurface(
          color: AppColors.surface,
          borderRadius: AppRadii.cardLargeRadius,
          padding: AppSpacing.cardPaddingHero,
          child: child,
        ),
      ),
    );
  }
}

class _TokenDetailSheet extends StatelessWidget {
  const _TokenDetailSheet({required this.token});

  final StakingLiquidTokenDraft token;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: StakingLiquidStakingPage.detailSheetKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(token.name, style: AppTextStyles.sectionTitle),
              ),
              VitIconButton(
                icon: Icons.close_rounded,
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(),
                variant: VitIconButtonVariant.transparent,
                size: VitIconButtonSize.md,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCard(
            variant: VitCardVariant.inner,
            padding: AppSpacing.cardPadding,
            child: Column(
              children: [
                _SheetRow(
                  label: 'Exchange Rate',
                  value:
                      '1 ${token.symbol} = ${token.exchangeRate} ${token.underlyingAsset}',
                ),
                _SheetRow(
                  label: 'APY',
                  value: '${token.apy}%',
                  valueColor: AppColors.buy,
                ),
                _SheetRow(
                  label: 'Total Supply',
                  value: '${_formatAmount(token.totalSupply)} ${token.symbol}',
                ),
                _SheetRow(label: 'TVL', value: _formatUsd(token.tvl)),
                _SheetRow(label: 'Protocol', value: token.protocol),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _BulletSection(
            title: 'Lợi ích',
            items: token.benefits,
            success: true,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _BulletSection(title: 'Rủi ro', items: token.risks, success: false),
        ],
      ),
    );
  }
}

class _SheetRow extends StatelessWidget {
  const _SheetRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.zeroInsets.copyWith(
        top: AppSpacing.x2,
        bottom: AppSpacing.x2,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.caption.copyWith(
                color: valueColor,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletSection extends StatelessWidget {
  const _BulletSection({
    required this.title,
    required this.items,
    required this.success,
  });

  final String title;
  final List<String> items;
  final bool success;

  @override
  Widget build(BuildContext context) {
    final color = success ? AppColors.buy : AppColors.sell;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final item in items)
          Padding(
            padding: AppSpacing.zeroInsets.copyWith(bottom: AppSpacing.x2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: AppSpacing.zeroInsets.copyWith(top: AppSpacing.x3),
                  child: Material(
                    color: color,
                    shape: const CircleBorder(),
                    child: const SizedBox(
                      width: AppSpacing.x1,
                      height: AppSpacing.x1,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
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

String _tabLabel(_LiquidTab tab) {
  return switch (tab) {
    _LiquidTab.stake => 'Stake',
    _LiquidTab.swap => 'Swap',
    _LiquidTab.holdings => 'Holdings',
  };
}

IconData _benefitIcon(String icon) {
  return switch (icon) {
    'zap' => Icons.bolt_rounded,
    'trend' => Icons.trending_up_rounded,
    'shield' => Icons.shield_outlined,
    'swap' => Icons.swap_horiz_rounded,
    _ => Icons.water_drop_outlined,
  };
}

String _formatUsd(double value) {
  if (value >= 1000000000) {
    return '\$${(value / 1000000000).toStringAsFixed(1)}B';
  }
  if (value >= 1000000) {
    return '\$${(value / 1000000).toStringAsFixed(1)}M';
  }
  return '\$${value.toStringAsFixed(value == 0 ? 0 : 2)}';
}

String _formatBillions(double value) {
  return '\$${(value / 1000000000).toStringAsFixed(1)}B';
}

String _formatMillions(double value) {
  return '${(value / 1000000).toStringAsFixed(1)}M';
}

String _formatAmount(double value) {
  if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toStringAsFixed(0);
}

extension on StakingLiquidStakingSnapshot {
  StakingLiquidTokenDraft? tokenBySymbol(String symbol) {
    for (final token in tokens) {
      if (token.symbol == symbol) return token;
    }
    return null;
  }
}
