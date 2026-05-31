part of '../pages/advanced_chart_page.dart';

class _AdvancedHeader extends StatelessWidget {
  const _AdvancedHeader({required this.pair});

  final TradePair pair;

  @override
  Widget build(BuildContext context) {
    final logoColor = Color(pair.logoColorHex);
    final changeColor = pair.changePct >= 0 ? AppColors.buy : AppColors.sell;

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => context.go(AppRoutePaths.tradePair(pair.id)),
            borderRadius: AppRadii.cardRadius,
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.onAccent.withValues(alpha: .08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: AppColors.text1,
                size: 23,
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            key: AdvancedChartPage.pairSelectorKey,
            onTap: () => context.go(AppRoutePaths.markets),
            borderRadius: AppRadii.mdRadius,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: logoColor.withValues(alpha: .18),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    pair.baseAsset.substring(0, 3),
                    style: AppTextStyles.micro.copyWith(
                      color: logoColor,
                      fontSize: 8,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  pair.symbol,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text2,
                  size: 17,
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 120,
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
                    fontSize: 15,
                    fontFamily: 'monospace',
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatPercent(pair.changePct),
                  style: AppTextStyles.micro.copyWith(
                    color: changeColor,
                    fontSize: 11,
                    fontWeight: AppTextStyles.medium,
                    height: 1,
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

class _OhlcvBar extends StatelessWidget {
  const _OhlcvBar({required this.ohlcv});

  final TradeOhlcv ohlcv;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Text(
                'Mới nhất',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.sell,
                  fontSize: 11,
                  fontFamily: 'monospace',
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
              const SizedBox(width: 12),
              _OhlcvToken(label: 'O', value: _formatRawPrice(ohlcv.open)),
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
    return Padding(
      padding: const EdgeInsets.only(right: 9),
      child: RichText(
        maxLines: 1,
        text: TextSpan(
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
            fontFamily: 'monospace',
            height: 1,
          ),
          children: [
            TextSpan(
              text: '$label:',
              style: const TextStyle(color: AppColors.text2),
            ),
            TextSpan(
              text: value,
              style: TextStyle(color: valueColor),
            ),
          ],
        ),
      ),
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
    return Container(
      height: 49,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          for (final timeframe in timeframes)
            _TimeframeButton(
              key: AdvancedChartPage.timeframeKey(timeframe),
              label: timeframe,
              active: activeTimeframe == timeframe,
              onTap: () => onTimeframeChanged(timeframe),
            ),
          Container(
            width: 1,
            height: 22,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            color: AppColors.borderSolid,
          ),
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
          const SizedBox(width: 5),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                key: AdvancedChartPage.indicatorButtonKey,
                onTap: onIndicators,
                borderRadius: AppRadii.inputRadius,
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: _toolbarBackground,
                    border: Border.all(
                      color: _tradePrimary.withValues(alpha: .45),
                    ),
                    borderRadius: AppRadii.inputRadius,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.layers_outlined,
                        size: 13,
                        color: _tradePrimary,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '$activeIndicatorCount chỉ\nbáo',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.micro.copyWith(
                            color: _tradePrimary,
                            fontSize: 11,
                            fontWeight: AppTextStyles.medium,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        width: 39,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? _tradePrimary : AppColors.transparent,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? AppColors.onAccent : AppColors.text3,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
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
    return InkWell(
      onTap: () => onTap(id),
      borderRadius: AppRadii.smRadius,
      child: Container(
        width: 28,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.borderSolid : AppColors.transparent,
          borderRadius: AppRadii.smRadius,
        ),
        child: Icon(
          icon,
          size: 16,
          color: active ? AppColors.primarySoft : AppColors.text2,
        ),
      ),
    );
  }
}
