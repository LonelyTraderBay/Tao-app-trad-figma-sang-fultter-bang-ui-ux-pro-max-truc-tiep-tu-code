part of '../pages/launchpad_swap_aggregator_page.dart';

class _Tabs extends StatelessWidget {
  const _Tabs({required this.activeTab, required this.onChanged});

  final _SwapTab activeTab;
  final ValueChanged<_SwapTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      key: LaunchpadSwapAggregatorPage.tabsKey,
      color: AppColors.surface,
      child: Padding(
        padding: AppSpacing.launchpadHorizontalContentPadding,
        child: VitTabBar(
          tabs: const [
            VitTabItem(key: 'compare', label: 'So sanh'),
            VitTabItem(key: 'history', label: 'Lich su'),
            VitTabItem(key: 'settings', label: 'Cai dat'),
          ],
          activeKey: activeTab.name,
          onChanged: (key) => onChanged(_SwapTab.values.byName(key)),
          variant: VitTabBarVariant.underline,
        ),
      ),
    );
  }
}

class _SwapInputCard extends StatelessWidget {
  const _SwapInputCard({
    required this.fromToken,
    required this.toToken,
    required this.amountController,
    required this.output,
    required this.bestPrice,
    required this.onFlip,
    required this.onAmountChanged,
  });

  final String fromToken;
  final String toToken;
  final TextEditingController amountController;
  final double output;
  final double bestPrice;
  final VoidCallback onFlip;
  final ValueChanged<String> onAmountChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadSwapAggregatorPage.inputKey,
      padding: AppSpacing.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Swap from',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _TokenButton(token: fromToken, color: AppColors.buy),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitInput(
                  controller: amountController,
                  onChanged: onAmountChanged,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.end,
                  semanticLabel: 'Launchpad swap amount',
                  hintText: '0.00',
                  textStyle: AppTextStyles.amountSm.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Center(
            child: VitIconButton(
              key: LaunchpadSwapAggregatorPage.flipKey,
              onPressed: onFlip,
              icon: Icons.swap_horiz_rounded,
              tooltip: 'Doi chieu swap',
              variant: VitIconButtonVariant.primary,
              size: VitIconButtonSize.md,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Swap to',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _TokenButton(token: toToken, color: AppColors.accent),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '~${output.toStringAsFixed(4)}',
                      style: AppTextStyles.amountSm.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      '@${bestPrice.toStringAsFixed(2)} $fromToken',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TokenButton extends StatelessWidget {
  const _TokenButton({required this.token, required this.color});

  final String token;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: AppColors.bg,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: AppColors.cardBorder),
          borderRadius: AppRadii.inputRadius,
        ),
      ),
      child: Padding(
        padding: AppSpacing.launchpadPillPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: AppSpacing.launchpadBox24,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: color.withValues(alpha: .16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.xsRadius,
                  ),
                ),
                child: Center(
                  child: Text(
                    token.substring(0, 2),
                    style: AppTextStyles.badge.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              token,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.text3,
            ),
          ],
        ),
      ),
    );
  }
}

class _BestRouteAlert extends StatelessWidget {
  const _BestRouteAlert({required this.bestDex, required this.savings});

  final LaunchpadSwapDexQuoteDraft bestDex;
  final num savings;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: LaunchpadSwapAggregatorPage.bestRouteKey,
      decoration: const ShapeDecoration(
        color: AppColors.buy10,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.buy20),
          borderRadius: AppRadii.cardRadius,
        ),
      ),
      child: Padding(
        padding: AppSpacing.launchpadPaddingX4,
        child: Row(
          children: [
            const Icon(
              Icons.bolt_rounded,
              color: AppColors.buy,
              size: AppSpacing.launchpadIcon2xl + AppSpacing.hairlineStroke,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Best rate: ${bestDex.name}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    'Saving ${savings.toStringAsFixed(2)}% vs worst route - Gas: \$${bestDex.gas.toStringAsFixed(0)}',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
