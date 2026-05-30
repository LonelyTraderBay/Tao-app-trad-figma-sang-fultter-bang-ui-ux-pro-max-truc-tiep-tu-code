part of 'prediction_event_detail_page.dart';

class _ChartPeriodTabs extends StatelessWidget {
  const _ChartPeriodTabs();

  @override
  Widget build(BuildContext context) {
    const tabs = ['1H', '1D', '7D', '30D', 'All'];
    return Row(
      children: [
        for (var index = 0; index < tabs.length; index += 1) ...[
          Expanded(
            child: Container(
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tabs[index] == '30D'
                    ? _predictionPrimary.withValues(alpha: .14)
                    : AppColors.transparent,
                border: Border.all(
                  color: tabs[index] == '30D'
                      ? _predictionPrimary.withValues(alpha: .32)
                      : AppColors.transparent,
                ),
                borderRadius: AppRadii.smRadius,
              ),
              child: Text(
                tabs[index],
                style: AppTextStyles.micro.copyWith(
                  color: tabs[index] == '30D'
                      ? _predictionPrimary
                      : AppColors.text3,
                  fontWeight: tabs[index] == '30D'
                      ? AppTextStyles.bold
                      : AppTextStyles.normal,
                ),
              ),
            ),
          ),
          if (index != tabs.length - 1) const SizedBox(width: 6),
        ],
      ],
    );
  }
}

class _VolumeBars extends StatelessWidget {
  const _VolumeBars({required this.values});

  final List<int> values;

  @override
  Widget build(BuildContext context) {
    final maxValue = values.reduce(math.max).toDouble();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final value in values)
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: math.max(.10, value / maxValue),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  decoration: BoxDecoration(
                    color: _predictionPrimary.withValues(alpha: .30),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ProbabilityChartPainter extends CustomPainter {
  const _ProbabilityChartPainter({required this.values});

  final List<int> values;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.borderSolid.withValues(alpha: .55)
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i += 1) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (values.length < 2) return;

    final path = Path();
    for (var index = 0; index < values.length; index += 1) {
      final x = size.width * index / (values.length - 1);
      final y = size.height - (values[index] / 100) * size.height;
      if (index == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.buy.withValues(alpha: .30),
          AppColors.buy.withValues(alpha: .02),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _ProbabilityChartPainter oldDelegate) {
    return oldDelegate.values != values;
  }
}

class _OrderBookSection extends StatelessWidget {
  const _OrderBookSection({
    required this.snapshot,
    required this.expanded,
    required this.onToggle,
  });

  final PredictionEventDetailSnapshot snapshot;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final chance = snapshot.event.outcomes.first.chance / 100;
    final bestBid = snapshot.orderBook.bids.first.price;
    final bestAsk = snapshot.orderBook.asks.first.price;
    return Column(
      children: [
        InkWell(
          key: PredictionEventDetailPage.orderBookToggleKey,
          onTap: onToggle,
          borderRadius: AppRadii.cardRadius,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.cardBorder),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.layers_rounded,
                  color: _predictionPrimary,
                  size: 15,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Order Book',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Spread ${_formatPrice(bestAsk - bestBid)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text3,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
        if (expanded) ...[
          const SizedBox(height: 8),
          VitCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _OrderBookHeader(),
                const SizedBox(height: 6),
                for (final ask in snapshot.orderBook.asks.reversed)
                  _OrderBookRow(entry: ask, isBid: false),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 7),
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: Text(
                    '${_formatPrice(chance)} · mid price',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                for (final bid in snapshot.orderBook.bids)
                  _OrderBookRow(entry: bid, isBid: true),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _OrderBookHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _OrderBookLabel('PRICE')),
        SizedBox(width: 72, child: _OrderBookLabel('SHARES', alignEnd: true)),
        SizedBox(width: 72, child: _OrderBookLabel('TOTAL', alignEnd: true)),
      ],
    );
  }
}

class _OrderBookLabel extends StatelessWidget {
  const _OrderBookLabel(this.label, {this.alignEnd = false});

  final String label;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: alignEnd ? TextAlign.end : TextAlign.start,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _OrderBookRow extends StatelessWidget {
  const _OrderBookRow({required this.entry, required this.isBid});

  final PredictionOrderBookEntryDraft entry;
  final bool isBid;

  @override
  Widget build(BuildContext context) {
    final color = isBid ? AppColors.buy : AppColors.sell;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .04),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _formatPrice(entry.price),
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          SizedBox(
            width: 72,
            child: Text(
              _formatInt(entry.shares),
              textAlign: TextAlign.end,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          SizedBox(
            width: 72,
            child: Text(
              _formatInt((entry.price * entry.shares).round()),
              textAlign: TextAlign.end,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 11,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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

class _SegmentedToggle extends StatelessWidget {
  const _SegmentedToggle({
    required this.leftLabel,
    required this.rightLabel,
    required this.leftActive,
    required this.leftColor,
    required this.rightColor,
    required this.onLeft,
    required this.onRight,
  });

  final String leftLabel;
  final String rightLabel;
  final bool leftActive;
  final Color leftColor;
  final Color rightColor;
  final VoidCallback onLeft;
  final VoidCallback onRight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentButton(
              label: leftLabel,
              active: leftActive,
              color: leftColor,
              onTap: onLeft,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _SegmentButton(
              label: rightLabel,
              active: !leftActive,
              color: rightColor,
              onTap: onRight,
            ),
          ),
        ],
      ),
    );
  }
}
