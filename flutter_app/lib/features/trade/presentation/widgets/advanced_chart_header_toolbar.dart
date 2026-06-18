part of '../pages/advanced_chart_page.dart';

class _AdvancedHeader extends StatelessWidget {
  const _AdvancedHeader({required this.pair});

  final TradePair pair;

  @override
  Widget build(BuildContext context) {
    final logoColor = Color(pair.logoColorHex);
    final changeColor = pair.changePct >= 0 ? AppColors.buy : AppColors.sell;

    return SizedBox(
      height: AppSpacing.inputHeight,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: AppSpacing.tradeReceiptSupportPadding,
              child: Row(
                children: [
                  VitIconButton(
                    icon: Icons.chevron_left_rounded,
                    tooltip: 'Back to pair',
                    onPressed: () =>
                        context.go(AppRoutePaths.tradePair(pair.id)),
                    variant: VitIconButtonVariant.transparent,
                    size: VitIconButtonSize.md,
                  ),
                  const SizedBox(width: AppSpacing.tradeBotSmallGap),
                  InkWell(
                    key: AdvancedChartPage.pairSelectorKey,
                    onTap: () => context.go(AppRoutePaths.markets),
                    borderRadius: AppRadii.mdRadius,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        VitCard(
                          width: AppSpacing.tradeBotClientMoneyBalanceGlyph,
                          height: AppSpacing.tradeBotClientMoneyBalanceGlyph,
                          padding: AppSpacing.zeroInsets,
                          variant: VitCardVariant.ghost,
                          clip: true,
                          background: ColoredBox(
                            color: logoColor.withValues(alpha: .18),
                          ),
                          child: Text(
                            pair.baseAsset.substring(0, 3),
                            style: AppTextStyles.micro.copyWith(
                              color: logoColor,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.tradeBotInlineIconGap),
                        Text(
                          pair.symbol,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontWeight: AppTextStyles.bold,
                            height: AppSpacing.tradeBotLineHeightTight,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.hairlineStroke * 2),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.text2,
                          size: AppSpacing.tradeBotMediumIcon,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width:
                        AppSpacing.tradeBotMetricTableColumnWidth +
                        AppSpacing.contentPad,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatPrice(pair.price),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: changeColor,
                            fontFeatures: AppTextStyles.tabularFigures,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(
                          height: AppSpacing.tradeBotNarrowIconGap,
                        ),
                        Text(
                          _formatPercent(pair.changePct),
                          style: AppTextStyles.micro.copyWith(
                            color: changeColor,
                            fontWeight: AppTextStyles.medium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: AppSpacing.tradeBotHairline,
            thickness: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
        ],
      ),
    );
  }
}

class _OhlcvBar extends StatelessWidget {
  const _OhlcvBar({required this.ohlcv});

  final TradeOhlcv ohlcv;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.tradeBotQuestionIconBox,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: AppSpacing.tradeReceiptSupportPadding,
              child: Align(
                alignment: Alignment.centerLeft,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                          'Mới nhất',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.sell,
                            fontWeight: AppTextStyles.bold,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.tradeBotCardIconGap),
                        _OhlcvToken(
                          label: 'O',
                          value: _formatRawPrice(ohlcv.open),
                        ),
                        _OhlcvToken(
                          label: 'H',
                          value: _formatRawPrice(ohlcv.high),
                          valueColor: AppColors.buy,
                        ),
                        _OhlcvToken(
                          label: 'L',
                          value: _formatRawPrice(ohlcv.low),
                          valueColor: AppColors.sell,
                        ),
                        _OhlcvToken(
                          label: 'C',
                          value: _formatRawPrice(ohlcv.close),
                          valueColor: AppColors.sell,
                        ),
                        _OhlcvToken(label: 'Vol', value: ohlcv.volumeLabel),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            height: AppSpacing.tradeBotHairline,
            thickness: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
        ],
      ),
    );
  }
}

class _OhlcvToken extends StatelessWidget {
  const _OhlcvToken({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          maxLines: 1,
          text: TextSpan(
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
            children: [
              TextSpan(
                text: '$label:',
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
              TextSpan(
                text: value,
                style: AppTextStyles.micro.copyWith(color: valueColor),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.tradeBotDisclosureGap),
      ],
    );
  }
}

class _ChartToolbar extends StatelessWidget {
  const _ChartToolbar({
    required this.timeframes,
    required this.activeTimeframe,
    required this.activeChartType,
    required this.activeIndicatorCount,
    required this.onTimeframeChanged,
    required this.onChartTypeChanged,
    required this.onIndicators,
  });

  final List<String> timeframes;
  final String activeTimeframe;
  final String activeChartType;
  final int activeIndicatorCount;
  final ValueChanged<String> onTimeframeChanged;
  final ValueChanged<String> onChartTypeChanged;
  final VoidCallback onIndicators;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.tradeBotClientMetricHeight,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: AppSpacing.tradeReceiptSupportPadding,
              child: Row(
                children: [
                  for (final timeframe in timeframes)
                    _TimeframeButton(
                      key: AdvancedChartPage.timeframeKey(timeframe),
                      label: timeframe,
                      active: activeTimeframe == timeframe,
                      onTap: () => onTimeframeChanged(timeframe),
                    ),
                  const SizedBox(width: AppSpacing.tradeBotTinyGap),
                  const SizedBox(
                    width: AppSpacing.dividerHairline,
                    height: AppSpacing.tradeBotDisputeDropdownIcon,
                    child: ColoredBox(color: AppColors.borderSolid),
                  ),
                  const SizedBox(width: AppSpacing.tradeBotTinyGap),
                  _ChartTypeButton(
                    key: AdvancedChartPage.chartTypeKey('candle'),
                    id: 'candle',
                    icon: Icons.show_chart_rounded,
                    active: activeChartType == 'candle',
                    onTap: onChartTypeChanged,
                  ),
                  _ChartTypeButton(
                    key: AdvancedChartPage.chartTypeKey('line'),
                    id: 'line',
                    icon: Icons.stacked_line_chart_rounded,
                    active: activeChartType == 'line',
                    onTap: onChartTypeChanged,
                  ),
                  _ChartTypeButton(
                    key: AdvancedChartPage.chartTypeKey('area'),
                    id: 'area',
                    icon: Icons.bar_chart_rounded,
                    active: activeChartType == 'area',
                    onTap: onChartTypeChanged,
                  ),
                  const SizedBox(width: AppSpacing.tradeBotTinyGap),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: VitCard(
                        key: AdvancedChartPage.indicatorButtonKey,
                        height: AppSpacing.tradeBotQuestionIconBox,
                        padding: AppSpacing.tradeBotCopyDemoInlinePadding,
                        variant: VitCardVariant.ghost,
                        borderColor: _tradePrimary.withValues(alpha: .45),
                        clip: true,
                        onTap: onIndicators,
                        background: const ColoredBox(color: _toolbarBackground),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.layers_outlined,
                              size: AppSpacing.iconSm,
                              color: _tradePrimary,
                            ),
                            const SizedBox(
                              width: AppSpacing.hairlineStroke * 2,
                            ),
                            Flexible(
                              child: Text(
                                '$activeIndicatorCount chỉ\nbáo',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.micro.copyWith(
                                  color: _tradePrimary,
                                  fontWeight: AppTextStyles.medium,
                                  fontFeatures: AppTextStyles.tabularFigures,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: AppSpacing.tradeBotHairline,
            thickness: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
        ],
      ),
    );
  }
}

class _TimeframeButton extends StatelessWidget {
  const _TimeframeButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      width: AppSpacing.buttonCompact + AppSpacing.x2,
      height: AppSpacing.buttonCompact - AppSpacing.hairlineStroke,
      alignment: Alignment.center,
      variant: active ? VitCardVariant.standard : VitCardVariant.ghost,
      borderColor: active ? _tradePrimary : AppColors.transparent,
      background: ColoredBox(
        color: active ? _tradePrimary : AppColors.transparent,
      ),
      onTap: onTap,
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: active ? AppColors.onAccent : AppColors.text3,
          fontWeight: AppTextStyles.bold,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
    );
  }
}

class _ChartTypeButton extends StatelessWidget {
  const _ChartTypeButton({
    super.key,
    required this.id,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String id;
  final IconData icon;
  final bool active;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      width: AppSpacing.tradeBotClientMoneyBalanceGlyph,
      height: AppSpacing.buttonCompact - AppSpacing.hairlineStroke,
      alignment: Alignment.center,
      variant: VitCardVariant.ghost,
      background: ColoredBox(
        color: active ? AppColors.borderSolid : AppColors.transparent,
      ),
      onTap: () => onTap(id),
      child: Icon(
        icon,
        size: AppSpacing.tradeBotCheckboxIcon,
        color: active ? AppColors.primarySoft : AppColors.text2,
      ),
    );
  }
}
