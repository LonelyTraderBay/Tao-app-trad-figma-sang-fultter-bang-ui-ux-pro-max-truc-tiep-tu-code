part of '../pages/prediction_market_maker_page.dart';

class _MarketMakerTabBar extends StatelessWidget {
  const _MarketMakerTabBar({required this.activeTab, required this.onChanged});

  final _MarketMakerTab activeTab;
  final ValueChanged<_MarketMakerTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (
        key: PredictionMarketMakerPage.provideTabKey,
        tab: _MarketMakerTab.provide,
        label: 'Cung cap',
      ),
      (
        key: PredictionMarketMakerPage.positionsTabKey,
        tab: _MarketMakerTab.positions,
        label: 'Vi the',
      ),
      (
        key: PredictionMarketMakerPage.earningsTabKey,
        tab: _MarketMakerTab.earnings,
        label: 'Thu nhap',
      ),
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SizedBox(
        height: 54,
        child: Row(
          children: [
            for (final item in tabs)
              Expanded(
                child: InkWell(
                  key: item.key,
                  onTap: () => onChanged(item.tab),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            item.label,
                            style: AppTextStyles.caption.copyWith(
                              color: activeTab == item.tab
                                  ? _predictionPrimary
                                  : AppColors.text3,
                              fontWeight: AppTextStyles.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        height: 2,
                        width: activeTab == item.tab ? 116 : 0,
                        decoration: BoxDecoration(
                          color: _predictionPrimary,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LiquidityOverview extends StatelessWidget {
  const _LiquidityOverview({required this.snapshot});

  final PredictionMarketMakerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary08,
                  borderRadius: AppRadii.inputRadius,
                ),
                child: const Icon(
                  Icons.water_drop_outlined,
                  color: _predictionPrimary,
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Liquidity Provider',
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      'Thu nhap tu phi giao dich',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  label: 'Total Provided',
                  value: _formatMoney(snapshot.totalLiquidity),
                ),
              ),
              Expanded(
                child: _OverviewMetric(
                  label: 'Avg APR',
                  value: '${snapshot.averageApr.toStringAsFixed(1)}%',
                  valueColor: AppColors.buy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddLiquidityForm extends StatelessWidget {
  const _AddLiquidityForm({
    required this.eventController,
    required this.amountController,
    required this.minDepthController,
    required this.spreadBps,
    required this.onSpreadChanged,
  });

  final TextEditingController eventController;
  final TextEditingController amountController;
  final TextEditingController minDepthController;
  final int spreadBps;
  final ValueChanged<int> onSpreadChanged;

  @override
  Widget build(BuildContext context) {
    final hasAmount = amountController.text.trim().isNotEmpty;
    final amount = double.tryParse(amountController.text) ?? 0;

    return VitPageSection(
      label: 'Them thanh khoan',
      accentColor: _predictionPrimary,
      children: [
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _MarketInput(label: 'Select Event', controller: eventController),
              const SizedBox(height: 16),
              _MarketInput(
                label: 'Liquidity Amount (USD)',
                controller: amountController,
                fieldKey: PredictionMarketMakerPage.amountFieldKey,
                hintText: '0.00',
                numeric: true,
                prefix: const Icon(
                  Icons.attach_money_rounded,
                  color: AppColors.text3,
                  size: 19,
                ),
              ),
              const SizedBox(height: 16),
              _SpreadSelector(value: spreadBps, onChanged: onSpreadChanged),
              const SizedBox(height: 16),
              _MarketInput(
                label: 'Minimum Depth (USD)',
                controller: minDepthController,
                numeric: true,
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Thanh khoan toi thieu moi ben',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              if (hasAmount) ...[
                const SizedBox(height: 14),
                _EstimatedReturns(amount: amount),
              ],
              const SizedBox(height: 16),
              _AddLiquidityButton(enabled: hasAmount),
            ],
          ),
        ),
      ],
    );
  }
}

class _MarketInput extends StatelessWidget {
  const _MarketInput({
    required this.label,
    required this.controller,
    this.fieldKey,
    this.hintText = '',
    this.numeric = false,
    this.prefix,
  });

  final String label;
  final TextEditingController controller;
  final Key? fieldKey;
  final String hintText;
  final bool numeric;
  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 42,
          padding: EdgeInsets.only(left: prefix == null ? 16 : 10, right: 16),
          decoration: BoxDecoration(
            color: AppColors.bg,
            border: Border.all(color: AppColors.border),
            borderRadius: AppRadii.lgRadius,
          ),
          child: Row(
            children: [
              if (prefix != null) ...[prefix!, const SizedBox(width: 8)],
              Expanded(
                child: TextField(
                  key: fieldKey,
                  controller: controller,
                  keyboardType: numeric
                      ? const TextInputType.numberWithOptions(decimal: true)
                      : TextInputType.text,
                  inputFormatters: numeric
                      ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
                      : null,
                  cursorColor: _predictionPrimary,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 14,
                    fontWeight: AppTextStyles.medium,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: hintText,
                    hintStyle: AppTextStyles.body.copyWith(
                      color: AppColors.text3,
                      fontSize: 14,
                    ),
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

class _SpreadSelector extends StatelessWidget {
  const _SpreadSelector({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Spread (basis points)',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (final bps in [25, 50, 100, 200]) ...[
              Expanded(
                child: _SpreadButton(
                  key: _spreadKey(bps),
                  value: bps,
                  selected: value == bps,
                  onTap: () => onChanged(bps),
                ),
              ),
              if (bps != 200) const SizedBox(width: 8),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Hieu gia bid/ask: ${(value / 100).toStringAsFixed(2)}%',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _SpreadButton extends StatelessWidget {
  const _SpreadButton({
    super.key,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final int value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Material(
        color: selected ? _predictionPrimary : AppColors.bg,
        borderRadius: AppRadii.cardRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.cardRadius,
          child: Center(
            child: Text(
              '$value',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
