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
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 4,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        for (final strategy in strategies)
          _StrategyButton(
            key: BotBacktestingPage.strategyKey(strategy.id),
            strategy: strategy,
            selected: strategy.id == selectedId,
            onTap: () => onChanged(strategy.id),
          ),
      ],
    );
  }
}

class _StrategyButton extends StatelessWidget {
  const _StrategyButton({
    super.key,
    required this.strategy,
    required this.selected,
    required this.onTap,
  });

  final TradeBotBacktestStrategy strategy;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(strategy.colorHex);
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: .10) : _backtestPanel,
          border: Border.all(
            color: selected ? color : AppColors.borderSolid,
            width: selected ? 2 : 1.5,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                strategy.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: selected ? color : AppColors.text1,
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
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
      runSpacing: 10,
      children: [
        for (final pair in pairs)
          _ChoicePill(
            key: BotBacktestingPage.pairKey(pair),
            label: pair,
            selected: pair == selectedPair,
            width: 128,
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
              key: BotBacktestingPage.rangeKey(range.id),
              label: range.label,
              selected: range.id == selectedId,
              onTap: () => onChanged(range.id),
            ),
          ),
          if (range != ranges.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.width,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        width: width,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? _backtestPrimary : _backtestPanel,
          border: Border.all(
            color: selected ? _backtestPrimary : AppColors.borderSolid,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: selected ? AppColors.onAccent : AppColors.text1,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
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
    return Container(
      height: 52,
      padding: const EdgeInsets.fromLTRB(16, 0, 12, 0),
      decoration: BoxDecoration(
        color: _backtestPanel2,
        border: Border.all(color: AppColors.borderSolid),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              key: BotBacktestingPage.capitalKey,
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              style: AppTextStyles.body.copyWith(
                color: AppColors.text1,
                fontSize: 16,
                fontFamily: 'Roboto',
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          Text(
            'USDT',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 13,
              height: 1,
            ),
          ),
        ],
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
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      decoration: BoxDecoration(
        color: _backtestPrimary.withValues(alpha: .08),
        border: Border.all(color: _backtestPrimary.withValues(alpha: .22)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            color: _backtestPrimary,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Backtest Period',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Testing ${strategyId.toUpperCase()} strategy on $pair from ${range.periodLabel} with \$$capital initial capital.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                    height: 1.6,
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
    return Container(
      height: 80,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      color: _backtestPanel,
      child: SizedBox(
        height: 44,
        child: FilledButton.icon(
          key: BotBacktestingPage.runKey,
          onPressed: onRun,
          style: FilledButton.styleFrom(
            backgroundColor: _backtestPrimary,
            shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
          ),
          icon: const Icon(Icons.play_arrow_outlined, size: 19),
          label: Text(
            'Run Backtest',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.onAccent,
              fontSize: 14,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
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
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _backtestPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}
