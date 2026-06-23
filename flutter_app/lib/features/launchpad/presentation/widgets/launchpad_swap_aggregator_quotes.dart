part of '../pages/launchpad_swap_aggregator_page.dart';

class _DexList extends StatelessWidget {
  const _DexList({
    required this.quotes,
    required this.amount,
    required this.expandedDexId,
    required this.onToggle,
  });

  final List<LaunchpadSwapDexQuoteDraft> quotes;
  final double amount;
  final String? expandedDexId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: LaunchpadSwapAggregatorPage.dexListKey,
      child: VitPageSection(
        label: 'DEX so sanh',
        accentColor: AppColors.primary,
        children: [
          for (final quote in quotes)
            _DexQuoteCard(
              quote: quote,
              amount: amount,
              expanded: expandedDexId == quote.id,
              onToggle: () => onToggle(quote.id),
            ),
        ],
      ),
    );
  }
}

class _DexQuoteCard extends StatelessWidget {
  const _DexQuoteCard({
    required this.quote,
    required this.amount,
    required this.expanded,
    required this.onToggle,
  });

  final LaunchpadSwapDexQuoteDraft quote;
  final double amount;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final output = amount == 0 ? 0.0 : amount / quote.price;
    final impactColor = quote.priceImpact < .2
        ? AppColors.buy
        : quote.priceImpact < .3
        ? AppColors.primary
        : AppColors.sell;
    return VitCard(
      key: LaunchpadSwapAggregatorPage.dexKey(quote.id),
      borderColor: quote.recommended ? AppColors.buy20 : AppColors.cardBorder,
      padding: EdgeInsets.zero,
      clip: true,
      child: VitCard(
        key: LaunchpadSwapAggregatorPage.dexToggleKey(quote.id),
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.sm,
        padding: AppSpacing.launchpadPaddingX4,
        onTap: onToggle,
        child: Column(
          children: [
            Row(
              children: [
                _DexLogo(quote: quote),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: AppSpacing.x2,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            quote.name,
                            style: AppTextStyles.base.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          if (quote.recommended) const _BestPill(),
                        ],
                      ),
                      Text(
                        quote.estimatedTime,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      output.toStringAsFixed(4),
                      style: AppTextStyles.base.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      '~\$${amount.toStringAsFixed(0)}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
            Row(
              children: [
                _Metric(
                  label: 'Price Impact',
                  value: '${quote.priceImpact.toStringAsFixed(2)}%',
                  color: impactColor,
                  align: TextAlign.start,
                ),
                _Metric(
                  label: 'Gas Fee',
                  value: '\$${quote.gas.toStringAsFixed(0)}',
                  color: AppColors.text1,
                  align: TextAlign.center,
                ),
                _Metric(
                  label: 'Liquidity',
                  value: '\$${(quote.liquidity / 1000000).toStringAsFixed(1)}M',
                  color: AppColors.text1,
                  align: TextAlign.end,
                ),
              ],
            ),
            if (expanded) ...[
              const SizedBox(height: AppSpacing.x3),
              _RouteDetails(quote: quote),
            ],
            const SizedBox(height: AppSpacing.x1),
            Icon(
              expanded
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: AppColors.text3,
              size: AppSpacing.launchpadIcon2xl,
            ),
          ],
        ),
      ),
    );
  }
}

class _DexLogo extends StatelessWidget {
  const _DexLogo({required this.quote});

  final LaunchpadSwapDexQuoteDraft quote;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.launchpadBox40,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: quote.accent.withValues(alpha: .14),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
        ),
        child: Center(
          child: Text(
            quote.symbol.substring(0, 2),
            style: AppTextStyles.micro.copyWith(
              color: quote.accent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _BestPill extends StatelessWidget {
  const _BestPill();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.buy,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: AppSpacing.launchpadBadgePadding,
        child: Text(
          'BEST',
          style: AppTextStyles.chartLabelTiny.copyWith(
            color: AppColors.onAccent,
            fontWeight: AppTextStyles.bold,
            height: AppSpacing.launchpadLineHeightTight,
          ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    required this.color,
    required this.align,
  });

  final String label;
  final String value;
  final Color color;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: switch (align) {
          TextAlign.end => CrossAxisAlignment.end,
          TextAlign.center => CrossAxisAlignment.center,
          _ => CrossAxisAlignment.start,
        },
        children: [
          Text(
            label,
            textAlign: align,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          Text(
            value,
            textAlign: align,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteDetails extends StatelessWidget {
  const _RouteDetails({required this.quote});

  final LaunchpadSwapDexQuoteDraft quote;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.bg,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
      ),
      child: Padding(
        padding: AppSpacing.launchpadPaddingX3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Route',
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
            const SizedBox(height: AppSpacing.x2),
            Wrap(
              spacing: AppSpacing.x2,
              runSpacing: AppSpacing.x2,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (var i = 0; i < quote.route.length; i++) ...[
                  _RouteToken(token: quote.route[i]),
                  if (i < quote.route.length - 1)
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.text3,
                      size: AppSpacing.launchpadIconMd,
                    ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.x2),
            Row(
              children: [
                Icon(
                  Icons.shield_outlined,
                  color: quote.security == LaunchpadSwapSecurity.high
                      ? AppColors.buy
                      : AppColors.primary,
                  size: AppSpacing.launchpadIconSm,
                ),
                const SizedBox(width: AppSpacing.x1),
                Text(
                  'Security: ${quote.security == LaunchpadSwapSecurity.high ? 'High' : 'Medium'}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteToken extends StatelessWidget {
  const _RouteToken({required this.token});

  final String token;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: AppSpacing.launchpadPillPadding,
        child: Text(
          token,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _SwapWarning extends StatelessWidget {
  const _SwapWarning({required this.slippage});

  final String slippage;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: LaunchpadSwapAggregatorPage.warningKey,
      child: VitHighRiskStatePanel(
        state: VitHighRiskUiState.riskReview,
        title: 'Review route before swap',
        message:
            'Gia chi mang tinh chat tham khao. Kiem tra lai truoc khi swap. Slippage: $slippage%',
        contractId: 'Launchpad swap route',
      ),
    );
  }
}

class _SwapPreview extends StatelessWidget {
  const _SwapPreview({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return VitHighRiskStatePanel(
      state: VitHighRiskUiState.success,
      title: 'Swap preview ready',
      message: message,
      contractId: 'Best route preview',
    );
  }
}
