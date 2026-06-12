part of '../pages/prediction_event_detail_page.dart';

class _TradeSection extends StatelessWidget {
  const _TradeSection({
    required this.event,
    required this.preview,
    required this.selectedOutcome,
    required this.isBuy,
    required this.isMarket,
    required this.amount,
    required this.onSideChanged,
    required this.onOrderTypeChanged,
    required this.onAmountChanged,
    required this.onOutcomeChanged,
  });

  final PredictionEventDraft event;
  final PredictionOrderPreview preview;
  final String selectedOutcome;
  final bool isBuy;
  final bool isMarket;
  final String amount;
  final ValueChanged<bool> onSideChanged;
  final ValueChanged<bool> onOrderTypeChanged;
  final ValueChanged<String> onAmountChanged;
  final ValueChanged<String> onOutcomeChanged;

  @override
  Widget build(BuildContext context) {
    final outcome = event.outcomes.firstWhere(
      (item) => item.label == selectedOutcome,
      orElse: () => event.outcomes.first,
    );
    final price = outcome.chance / 100;
    return VitPageSection(
      label: 'Trade',
      accentColor: _predictionPrimary,
      children: [
        VitCard(
          padding: AppSpacing.predictionDetailTradeCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SegmentedToggle(
                leftLabel: 'Buy',
                rightLabel: 'Sell',
                leftActive: isBuy,
                leftColor: AppColors.buy,
                rightColor: AppColors.sell,
                onLeft: () => onSideChanged(true),
                onRight: () => onSideChanged(false),
              ),
              if (event.outcomes.length > 2) ...[
                const SizedBox(
                  height: AppSpacing.predictionDetailTradeSectionGap,
                ),
                Text(
                  'Outcome',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(
                  height: AppSpacing.predictionDetailTradeLabelGap,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final option in event.outcomes)
                        Padding(
                          padding: const EdgeInsets.only(
                            right: AppSpacing.predictionDetailTradeLabelGap,
                          ),
                          child: _SmallToggleChip(
                            label: option.label,
                            color: option.color,
                            active: option.label == selectedOutcome,
                            onTap: () => onOutcomeChanged(option.label),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(
                height: AppSpacing.predictionDetailTradeSectionGap,
              ),
              Text(
                'Order Type',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.predictionDetailTradeLabelGap),
              _SegmentedToggle(
                leftLabel: 'Market',
                rightLabel: 'Limit',
                leftActive: isMarket,
                leftColor: _predictionPrimary,
                rightColor: _predictionPrimary,
                onLeft: () => onOrderTypeChanged(true),
                onRight: () => onOrderTypeChanged(false),
              ),
              const SizedBox(height: AppSpacing.predictionDetailTradeHelperGap),
              Text(
                isMarket
                    ? 'Execute at current best available price'
                    : 'Set your desired entry price',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(
                height: AppSpacing.predictionDetailTradeSectionGap,
              ),
              Text(
                'Amount',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.predictionDetailTradeLabelGap),
              _TradeAmountInput(amount: amount, onChanged: onAmountChanged),
              const SizedBox(
                height: AppSpacing.predictionDetailTradeAmountPresetGap,
              ),
              Row(
                children: [
                  for (final preset in const ['10', '25', '50', '100']) ...[
                    Expanded(
                      child: _AmountChip(
                        amount: preset,
                        active: amount == preset,
                        onTap: () => onAmountChanged(preset),
                      ),
                    ),
                    if (preset != '100')
                      const SizedBox(
                        width: AppSpacing.predictionDetailTradePresetGap,
                      ),
                  ],
                ],
              ),
              const SizedBox(
                height: AppSpacing.predictionDetailTradePreviewGap,
              ),
              PredictionOrderPreviewCard(preview: preview),
              const SizedBox(
                height: AppSpacing.predictionDetailTradeDisclaimerGap,
              ),
              Text(
                'Đây không phải lời khuyên đầu tư. Xác suất không phải sự chắc chắn.',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.predictionDetailTradeCtaGap),
              VitCtaButton(
                variant: isBuy
                    ? VitCtaButtonVariant.success
                    : VitCtaButtonVariant.danger,
                onPressed: preview.canSubmit ? () {} : null,
                child: Text(
                  '${isBuy ? 'Buy' : 'Sell'} $selectedOutcome @ '
                  '${_formatPrice(price)}',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TradeAmountInput extends StatefulWidget {
  const _TradeAmountInput({required this.amount, required this.onChanged});

  final String amount;
  final ValueChanged<String> onChanged;

  @override
  State<_TradeAmountInput> createState() => _TradeAmountInputState();
}

class _TradeAmountInputState extends State<_TradeAmountInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.amount);
  }

  @override
  void didUpdateWidget(covariant _TradeAmountInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amount != widget.amount &&
        _controller.text != widget.amount) {
      _controller.value = TextEditingValue(
        text: widget.amount,
        selection: TextSelection.collapsed(offset: widget.amount.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VitInput(
      controller: _controller,
      keyboardType: TextInputType.number,
      onChanged: widget.onChanged,
      semanticLabel: 'Prediction order amount',
      hintText: '0.00',
      textStyle: AppTextStyles.body.copyWith(
        fontFeatures: AppTextStyles.tabularFigures,
      ),
      suffix: _TinyBadge(
        label: 'USDT',
        color: AppColors.text2,
        background: AppColors.surface3,
      ),
    );
  }
}
