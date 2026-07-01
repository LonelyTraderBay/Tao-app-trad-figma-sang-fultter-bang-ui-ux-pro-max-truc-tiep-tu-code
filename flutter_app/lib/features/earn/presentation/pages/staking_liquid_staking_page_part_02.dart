part of 'staking_liquid_staking_page.dart';

class _SwapTab extends StatelessWidget {
  const _SwapTab({
    required this.snapshot,
    required this.swapFrom,
    required this.swapTo,
    required this.amountController,
    required this.onFromChanged,
    required this.onToChanged,
    required this.onAmountChanged,
    required this.onReverse,
  });

  final StakingLiquidStakingSnapshot snapshot;
  final String swapFrom;
  final String swapTo;
  final TextEditingController amountController;
  final ValueChanged<String> onFromChanged;
  final ValueChanged<String> onToChanged;
  final ValueChanged<String> onAmountChanged;
  final VoidCallback onReverse;

  @override
  Widget build(BuildContext context) {
    final fromToken = snapshot.tokenBySymbol(swapFrom);
    final amount = double.tryParse(amountController.text.trim()) ?? 0;
    final receive = amount * (fromToken?.exchangeRate ?? 1);
    final minReceive = receive * (1 - snapshot.slippageTolerance / 100);
    final canSwap = amount > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          key: StakingLiquidStakingPage.swapCardKey,
          radius: VitCardRadius.large,
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SwapRow(
                label: 'Từ',
                selected: swapFrom,
                options: snapshot.swapFromOptions,
                amountController: amountController,
                amountKey: StakingLiquidStakingPage.swapAmountKey,
                onSelected: onFromChanged,
                onAmountChanged: onAmountChanged,
              ),
              const SizedBox(height: AppSpacing.x4),
              Center(
                child: VitCtaButton(
                  variant: VitCtaButtonVariant.secondary,
                  fullWidth: false,
                  height: AppSpacing.buttonCompact,
                  padding: AppSpacing.zeroInsets.copyWith(
                    left: AppSpacing.x4,
                    right: AppSpacing.x4,
                  ),
                  onPressed: onReverse,
                  child: const Icon(Icons.swap_vert_rounded),
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              _ReceiveRow(
                label: 'Sang',
                selected: swapTo,
                options: snapshot.swapToOptions,
                receive: receive,
                onSelected: onToChanged,
              ),
              if (canSwap) ...[
                const SizedBox(height: AppSpacing.x4),
                _SwapSummary(
                  key: StakingLiquidStakingPage.swapSummaryKey,
                  swapFrom: swapFrom,
                  swapTo: swapTo,
                  rate: fromToken?.exchangeRate ?? 1,
                  slippage: snapshot.slippageTolerance,
                  minReceive: minReceive,
                  gasFee: snapshot.estimatedGasFee,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCtaButton(
          onPressed: canSwap ? () {} : null,
          child: Text('Swap $swapFrom → $swapTo'),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          variant: VitCardVariant.inner,
          borderColor: AppColors.primary20,
          padding: AppSpacing.cardPadding,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Gợi ý: ',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                TextSpan(
                  text: snapshot.swapNote,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SwapRow extends StatelessWidget {
  const _SwapRow({
    required this.label,
    required this.selected,
    required this.options,
    required this.amountController,
    required this.amountKey,
    required this.onSelected,
    required this.onAmountChanged,
  });

  final String label;
  final String selected;
  final List<String> options;
  final TextEditingController amountController;
  final Key amountKey;
  final ValueChanged<String> onSelected;
  final ValueChanged<String> onAmountChanged;

  @override
  Widget build(BuildContext context) {
    return _FieldGroup(
      label: label,
      child: Row(
        children: [
          Expanded(
            child: _AssetSelector(
              selected: selected,
              options: options,
              onSelected: onSelected,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _AmountInput(
              fieldKey: amountKey,
              controller: amountController,
              onChanged: onAmountChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiveRow extends StatelessWidget {
  const _ReceiveRow({
    required this.label,
    required this.selected,
    required this.options,
    required this.receive,
    required this.onSelected,
  });

  final String label;
  final String selected;
  final List<String> options;
  final double receive;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return _FieldGroup(
      label: label,
      child: Row(
        children: [
          Expanded(
            child: _AssetSelector(
              selected: selected,
              options: options,
              onSelected: onSelected,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: VitCard(
              variant: VitCardVariant.inner,
              radius: VitCardRadius.standard,
              padding: AppSpacing.cardPadding,
              child: Align(
                alignment: Alignment.centerRight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    receive > 0 ? receive.toStringAsFixed(6) : '0.0',
                    style: AppTextStyles.baseMedium.copyWith(
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
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

class _FieldGroup extends StatelessWidget {
  const _FieldGroup({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x3),
        child,
      ],
    );
  }
}

class _AssetSelector extends StatelessWidget {
  const _AssetSelector({
    required this.selected,
    required this.options,
    required this.onSelected,
  });

  final String selected;
  final List<String> options;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.x3,
        right: AppSpacing.x3,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: options.contains(selected) ? selected : options.first,
          dropdownColor: AppColors.surface2,
          iconEnabledColor: AppColors.text2,
          style: AppTextStyles.body,
          isExpanded: true,
          items: [
            for (final option in options)
              DropdownMenuItem(value: option, child: Text(option)),
          ],
          onChanged: (value) {
            if (value != null) onSelected(value);
          },
        ),
      ),
    );
  }
}

class _AmountInput extends StatelessWidget {
  const _AmountInput({
    required this.fieldKey,
    required this.controller,
    required this.onChanged,
  });

  final Key fieldKey;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitInput(
      fieldKey: fieldKey,
      controller: controller,
      textAlign: TextAlign.right,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      hintText: '0.0',
      semanticLabel: 'Liquid staking swap amount',
      onChanged: onChanged,
      textStyle: AppTextStyles.baseMedium.copyWith(
        fontFeatures: AppTextStyles.tabularFigures,
      ),
    );
  }
}

class _SwapSummary extends StatelessWidget {
  const _SwapSummary({
    super.key,
    required this.swapFrom,
    required this.swapTo,
    required this.rate,
    required this.slippage,
    required this.minReceive,
    required this.gasFee,
  });

  final String swapFrom;
  final String swapTo;
  final double rate;
  final double slippage;
  final double minReceive;
  final double gasFee;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: AppSpacing.cardPadding,
      child: Column(
        children: [
          _SheetRow(
            label: 'Exchange Rate',
            value: '1 $swapFrom = $rate $swapTo',
          ),
          _SheetRow(
            label: 'Slippage Tolerance',
            value: '${slippage.toStringAsFixed(1)}%',
          ),
          _SheetRow(
            label: 'Minimum Received',
            value: '${minReceive.toStringAsFixed(6)} $swapTo',
            valueColor: AppColors.warn,
          ),
          _SheetRow(label: 'Gas Fee', value: '~${_formatUsd(gasFee)}'),
        ],
      ),
    );
  }
}

class _HoldingsTab extends StatelessWidget {
  const _HoldingsTab({required this.snapshot, required this.onStakeNow});

  final StakingLiquidStakingSnapshot snapshot;
  final VoidCallback onStakeNow;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingLiquidStakingPage.holdingsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: AppSpacing.cardPaddingHero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tổng giá trị Liquid Staking',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        Text(
                          _formatUsd(snapshot.holdingsValue),
                          style: AppTextStyles.numericDisplayXl,
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: AppColors.primary12,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.xlRadius,
                      side: const BorderSide(
                        color: AppColors.primary30,
                        width: AppSpacing.stakingProductIconBorderWidth,
                      ),
                    ),
                    child: const SizedBox(
                      width: AppSpacing.buttonHero,
                      height: AppSpacing.buttonHero,
                      child: Icon(
                        Icons.water_drop_rounded,
                        color: AppColors.primarySoft,
                        size: AppSpacing.iconLg,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x5),
              Row(
                children: const [
                  Expanded(child: _HoldingMetric(label: 'stETH Balance')),
                  SizedBox(width: AppSpacing.x3),
                  Expanded(child: _HoldingMetric(label: 'rETH Balance')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        _EmptyHoldings(onStakeNow: onStakeNow),
      ],
    );
  }
}

class _HoldingMetric extends StatelessWidget {
  const _HoldingMetric({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text('0.0000', style: AppTextStyles.baseMedium),
        ],
      ),
    );
  }
}

class _EmptyHoldings extends StatelessWidget {
  const _EmptyHoldings({required this.onStakeNow});

  final VoidCallback onStakeNow;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingLiquidStakingPage.emptyKey,
      children: [
        const Icon(
          Icons.water_drop_outlined,
          color: AppColors.text3,
          size: AppSpacing.x7,
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          'Bạn chưa có liquid token nào',
          style: AppTextStyles.body.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCtaButton(
          fullWidth: false,
          onPressed: onStakeNow,
          child: const Text('Stake ngay'),
        ),
      ],
    );
  }
}
