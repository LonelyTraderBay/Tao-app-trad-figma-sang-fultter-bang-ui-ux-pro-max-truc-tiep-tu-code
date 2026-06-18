part of '../pages/bot_backtesting_page.dart';

class _StrategyGrid extends StatelessWidget {
  const _StrategyGrid({
    required this.strategies,
    required this.selectedId,
    required this.onChanged,
  });

  final List<TradeBotBacktestStrategy> strategies;
  final String selectedId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - AppSpacing.tradeBotRowGap) /
            AppSpacing.tradeBotGridColumns;
        return Wrap(
          spacing: AppSpacing.tradeBotRowGap,
          runSpacing: AppSpacing.tradeBotRowGap,
          children: [
            for (final strategy in strategies)
              _StrategyButton(
                width: itemWidth,
                widgetKey: BotBacktestingPage.strategyKey(strategy.id),
                strategy: strategy,
                selected: strategy.id == selectedId,
                onTap: () => onChanged(strategy.id),
              ),
          ],
        );
      },
    );
  }
}

class _StrategyButton extends StatelessWidget {
  const _StrategyButton({
    required this.widgetKey,
    required this.width,
    required this.strategy,
    required this.selected,
    required this.onTap,
  });

  final Key widgetKey;
  final double width;
  final TradeBotBacktestStrategy strategy;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(strategy.colorHex);
    return VitCard(
      key: widgetKey,
      width: width,
      onTap: onTap,
      variant: selected ? VitCardVariant.ghost : VitCardVariant.inner,
      borderColor: selected ? color : AppColors.borderSolid,
      padding: AppSpacing.tradeBotChipPadding,
      child: Row(
        children: [
          Icon(Icons.circle, color: color, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.tradeBotInlineIconGap),
          Expanded(
            child: Text(
              strategy.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.captionSm.copyWith(
                color: selected ? color : AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PairGrid extends StatelessWidget {
  const _PairGrid({
    required this.pairs,
    required this.selectedPair,
    required this.onChanged,
  });

  final List<String> pairs;
  final String selectedPair;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: AppSpacing.tradeBotRowGap,
      children: [
        for (final pair in pairs)
          _ChoicePill(
            widgetKey: BotBacktestingPage.pairKey(pair),
            label: pair,
            selected: pair == selectedPair,
            width: AppSpacing.buttonHero + AppSpacing.x6,
            onTap: () => onChanged(pair),
          ),
      ],
    );
  }
}

class _DateRangeGrid extends StatelessWidget {
  const _DateRangeGrid({
    required this.ranges,
    required this.selectedId,
    required this.onChanged,
  });

  final List<TradeBotBacktestDateRange> ranges;
  final String selectedId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final range in ranges) ...[
          Expanded(
            child: _ChoicePill(
              widgetKey: BotBacktestingPage.rangeKey(range.id),
              label: range.label,
              selected: range.id == selectedId,
              onTap: () => onChanged(range.id),
            ),
          ),
          if (range != ranges.last)
            const SizedBox(width: AppSpacing.tradeBotSmallGap),
        ],
      ],
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    required this.widgetKey,
    required this.label,
    required this.selected,
    required this.onTap,
    this.width,
  });

  final Key widgetKey;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: widgetKey,
      onTap: onTap,
      width: width,
      height: AppSpacing.buttonCompact,
      alignment: Alignment.center,
      variant: selected ? VitCardVariant.ghost : VitCardVariant.inner,
      borderColor: selected ? _backtestPrimary : AppColors.borderSolid,
      child: Text(
        label,
        style: AppTextStyles.captionSm.copyWith(
          color: selected ? _backtestPrimary : AppColors.text1,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _CapitalInput extends StatelessWidget {
  const _CapitalInput({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return VitInput(
      controller: controller,
      fieldKey: BotBacktestingPage.capitalKey,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      suffix: Text(
        'USDT',
        style: AppTextStyles.captionSm.copyWith(color: AppColors.text3),
      ),
    );
  }
}

class _BacktestPeriodCard extends StatelessWidget {
  const _BacktestPeriodCard({
    required this.strategyId,
    required this.pair,
    required this.range,
    required this.capital,
  });

  final String strategyId;
  final String pair;
  final TradeBotBacktestDateRange range;
  final String capital;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.tradeBotCardPadding,
      borderColor: _backtestPrimary.withValues(alpha: .22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            color: _backtestPrimary,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.tradeBotCardIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Backtest Period',
                  style: AppTextStyles.captionSm.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.tradeBotSmallGap),
                Text(
                  'Testing ${strategyId.toUpperCase()} strategy on $pair from ${range.periodLabel} with \$$capital initial capital.',
                  style: AppTextStyles.captionSm.copyWith(
                    color: AppColors.text3,
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

class _RunFooter extends StatelessWidget {
  const _RunFooter({required this.onRun});

  final VoidCallback onRun;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: AppSpacing.tradeBotControlTall,
      padding: AppSpacing.tradeBotFooterPadding,
      child: VitCtaButton(
        key: BotBacktestingPage.runKey,
        onPressed: onRun,
        height: AppSpacing.tradeBotFooterButtonHeight,
        leading: const Icon(Icons.play_arrow_outlined, size: 19),
        child: Text(
          'Run Backtest',
          style: AppTextStyles.control.copyWith(
            color: AppColors.onAccent,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return VitSectionHeader(
      title: label,
      variant: VitSectionHeaderVariant.accentBar,
      accentColor: _backtestPrimary,
    );
  }
}
