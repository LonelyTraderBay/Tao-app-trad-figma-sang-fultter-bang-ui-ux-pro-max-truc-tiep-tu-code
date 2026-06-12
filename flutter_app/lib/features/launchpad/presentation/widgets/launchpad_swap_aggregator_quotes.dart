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
    return Container(
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
      child: InkWell(
        key: LaunchpadSwapAggregatorPage.dexToggleKey(quote.id),
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x4),
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
                    value:
                        '\$${(quote.liquidity / 1000000).toStringAsFixed(1)}M',
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
      ),
    );
  }
}

class _DexLogo extends StatelessWidget {
  const _DexLogo({required this.quote});

  final LaunchpadSwapDexQuoteDraft quote;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.launchpadBox40,
      height: AppSpacing.launchpadBox40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: quote.accent.withValues(alpha: .14),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Text(
        quote.symbol.substring(0, 2),
        style: AppTextStyles.micro.copyWith(
          color: quote.accent,
          fontWeight: AppTextStyles.bold,
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
      decoration: BoxDecoration(
        color: AppColors.buy,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Text(
          'BEST',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.onAccent,
            fontWeight: AppTextStyles.bold,
            fontSize: AppSpacing.launchpadFontXxs,
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
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: AppSpacing.launchpadFontSm,
            ),
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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: AppRadii.cardRadius,
      ),
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
    );
  }
}

class _RouteToken extends StatelessWidget {
  const _RouteToken({required this.token});

  final String token;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
    return Container(
      key: LaunchpadSwapAggregatorPage.warningKey,
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.warn08,
        border: Border.all(color: AppColors.warn15),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warn,
            size: AppSpacing.launchpadIconLg,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Gia chi mang tinh chat tham khao. Kiem tra lai truoc khi swap. Slippage: $slippage%',
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwapPreview extends StatelessWidget {
  const _SwapPreview({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x3),
      borderColor: AppColors.buy20,
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded, color: AppColors.buy),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}
