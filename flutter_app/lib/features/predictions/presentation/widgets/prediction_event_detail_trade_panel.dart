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
          padding: const EdgeInsets.all(14),
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
                const SizedBox(height: 13),
                Text(
                  'Outcome',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 7),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final option in event.outcomes)
                        Padding(
                          padding: const EdgeInsets.only(right: 7),
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
              const SizedBox(height: 13),
              Text(
                'Order Type',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 7),
              _SegmentedToggle(
                leftLabel: 'Market',
                rightLabel: 'Limit',
                leftActive: isMarket,
                leftColor: _predictionPrimary,
                rightColor: _predictionPrimary,
                onLeft: () => onOrderTypeChanged(true),
                onRight: () => onOrderTypeChanged(false),
              ),
              const SizedBox(height: 4),
              Text(
                isMarket
                    ? 'Execute at current best available price'
                    : 'Set your desired entry price',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: 13),
              Text(
                'Amount',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 7),
              Container(
                height: AppSpacing.inputHeight,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface2,
                  border: Border.all(color: AppColors.borderSolid),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: onAmountChanged,
                        style: AppTextStyles.body.copyWith(
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '0.00',
                          hintStyle: AppTextStyles.body.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ),
                    ),
                    _TinyBadge(
                      label: 'USDT',
                      color: AppColors.text2,
                      background: AppColors.surface3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
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
                    if (preset != '100') const SizedBox(width: 6),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              PredictionOrderPreviewCard(preview: preview),
              const SizedBox(height: 12),
              Text(
                'Đây không phải lời khuyên đầu tư. Xác suất không phải sự chắc chắn.',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 9,
                ),
              ),
              const SizedBox(height: 10),
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
