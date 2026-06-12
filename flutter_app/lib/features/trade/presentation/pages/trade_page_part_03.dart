part of 'trade_page.dart';

class _LabelValue extends StatelessWidget {
  const _LabelValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontFeatures: AppTextStyles.tabularFigures,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _TradeInput extends StatelessWidget {
  const _TradeInput({
    super.key,
    required this.label,
    required this.suffix,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final String suffix;
  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return VitInput(
      controller: controller,
      label: label,
      semanticLabel: label,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      textStyle: AppTextStyles.baseMedium.copyWith(
        fontFeatures: AppTextStyles.tabularFigures,
      ),
      suffix: Text(
        suffix,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text3,
          fontWeight: AppTextStyles.bold,
        ),
      ),
      onChanged: (_) => onChanged(),
    );
  }
}

class _PctButton extends StatelessWidget {
  const _PctButton({super.key, required this.pct, required this.onTap});

  final int pct;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: VitCard(
        height: AppSpacing.tradePctButtonHeight,
        alignment: Alignment.center,
        radius: VitCardRadius.sm,
        borderColor: AppColors.borderSolid,
        child: Text('$pct%', style: AppTextStyles.caption),
      ),
    );
  }
}

class _TpslSwitch extends StatelessWidget {
  const _TpslSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: AppSpacing.tradeTpslHeight,
      padding: AppSpacing.tradeTpslPadding,
      variant: VitCardVariant.inner,
      borderColor: AppColors.borderSolid,
      child: Row(
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.text3,
            size: AppSpacing.tradeTpslIcon,
          ),
          const SizedBox(width: AppSpacing.tradeTpslGap),
          Text(
            'TP/SL',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.tradeTpslGap),
          Expanded(
            child: Text(
              'Take Profit / Stop Loss',
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.buy,
          ),
        ],
      ),
    );
  }
}

class _FeeCard extends StatelessWidget {
  const _FeeCard({required this.preview});

  final TradeOrderPreview preview;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.tradeFeeCardPadding,
      child: Column(
        children: [
          _LabelValue(
            label: 'Thành tiền',
            value: '\$${preview.total.toStringAsFixed(2)}',
          ),
          const SizedBox(height: AppSpacing.tradeFeeRowGap),
          Row(
            children: [
              Text(
                'Phí (Maker)',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
              const SizedBox(width: AppSpacing.tradeTpslGap),
              DecoratedBox(
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: AppRadii.xsRadius,
                ),
                child: Padding(
                  padding: AppSpacing.tradeFeeBadgePadding,
                  child: Text(
                    'VIP 1',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.dynamicIslandBg,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
              Text(
                '  -5%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.tradeTpslGap),
              Expanded(
                child: Text(
                  '0.085% ≈ \$${preview.fee.toStringAsFixed(2)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OpenOrdersList extends StatelessWidget {
  const _OpenOrdersList({required this.orders});

  final List<TradeOpenOrder> orders;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.relaxed,
      customGap: AppSpacing.tradeListGap,
      children: [
        for (final order in orders)
          VitCard(
            padding: AppSpacing.tradeListCardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LabelValue(
                  label: order.symbol,
                  value: order.side == TradeOrderSide.buy ? 'MUA' : 'BÁN',
                ),
                const SizedBox(height: AppSpacing.tradeTpslGap),
                Text(
                  '${order.amount} @ ${order.price.toStringAsFixed(2)}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList();

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.relaxed,
      customGap: AppSpacing.tradeListGap,
      children: [
        for (final label in const [
          'BTC/USDT · MUA · Đã khớp',
          'ETH/USDT · BÁN · Một phần',
        ])
          VitCard(
            onTap: () => context.go(AppRoutePaths.tradeOrderReceipt),
            padding: AppSpacing.tradeListCardPadding,
            child: Text(label, style: AppTextStyles.body),
          ),
      ],
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
    this.activeColor,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? (activeColor ?? AppColors.bg) : AppColors.transparent,
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: active ? AppColors.text1 : AppColors.text3,
            fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _PairRouteChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = AppColors.onAccent.withValues(alpha: .07)
      ..strokeWidth = 1;
    for (final y in [size.height * .35, size.height * .55, size.height * .75]) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final dash = Paint()
      ..color = _tradePrimary.withValues(alpha: .35)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 10) {
      canvas.drawLine(
        Offset(x, size.height * .36),
        Offset(x + 5, size.height * .36),
        dash,
      );
    }

    final points = <Offset>[
      Offset(size.width * .02, size.height * .66),
      Offset(size.width * .10, size.height * .60),
      Offset(size.width * .18, size.height * .56),
      Offset(size.width * .27, size.height * .48),
      Offset(size.width * .36, size.height * .34),
      Offset(size.width * .46, size.height * .38),
      Offset(size.width * .56, size.height * .22),
      Offset(size.width * .66, size.height * .26),
      Offset(size.width * .76, size.height * .39),
      Offset(size.width * .86, size.height * .47),
      Offset(size.width * .96, size.height * .39),
    ];
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      linePath.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = AppColors.buy
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final candlePaint = Paint();
    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final green = i == 0 || i == 1 || i == 2 || i == 3 || i == 5 || i == 10;
      candlePaint.color = green ? AppColors.buy : AppColors.sell;
      canvas.drawRect(
        Rect.fromCenter(center: point, width: 9, height: green ? 10 : 12),
        candlePaint,
      );
    }

    for (var i = 0; i < 28; i++) {
      final h = 5.0 + ((i * 5) % 10) * 2.4;
      candlePaint.color = i % 4 == 0
          ? AppColors.sell.withValues(alpha: .55)
          : AppColors.buy.withValues(alpha: .58);
      canvas.drawRect(
        Rect.fromLTWH(18 + i * 13, size.height - 10 - h, 9, h),
        candlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CandlestickPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = _tradePrimary.withValues(alpha: .22)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 10) {
      canvas.drawLine(
        Offset(x, size.height * .57),
        Offset(x + 5, size.height * .57),
        grid,
      );
    }

    final candles = <(double, double, double, double, bool)>[
      (.18, .13, .31, .24, false),
      (.12, .11, .42, .34, false),
      (.32, .30, .48, .38, false),
      (.39, .38, .47, .42, false),
      (.42, .36, .50, .44, true),
      (.35, .28, .45, .36, true),
      (.26, .24, .38, .33, false),
      (.31, .30, .45, .37, false),
      (.39, .37, .48, .42, false),
      (.44, .43, .55, .48, false),
      (.48, .40, .56, .44, true),
      (.43, .39, .51, .47, false),
      (.48, .43, .57, .50, true),
      (.41, .38, .50, .46, true),
      (.39, .35, .53, .48, false),
      (.43, .37, .55, .47, true),
      (.45, .37, .61, .52, false),
      (.51, .47, .62, .55, false),
      (.55, .49, .64, .58, true),
      (.49, .43, .61, .54, true),
      (.45, .40, .58, .52, false),
    ];
    final bodyWidth = 10.0;
    final step = (size.width - 88) / (candles.length - 1);
    for (var i = 0; i < candles.length; i++) {
      final c = candles[i];
      final x = 18.0 + i * step;
      final color = c.$5 ? AppColors.buy : AppColors.sell;
      final paint = Paint()..color = color;
      canvas.drawLine(
        Offset(x + bodyWidth / 2, size.height * c.$1),
        Offset(x + bodyWidth / 2, size.height * c.$3),
        paint..strokeWidth = 2,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          x,
          size.height * c.$2,
          bodyWidth,
          size.height * (c.$4 - c.$2).abs().clamp(.05, .18),
        ),
        paint,
      );
    }

    final volumePaint = Paint()..color = AppColors.buy.withValues(alpha: .65);
    for (var i = 0; i < 22; i++) {
      final h = 7.0 + ((i * 3) % 7) * 3;
      volumePaint.color = i.isEven
          ? AppColors.buy.withValues(alpha: .55)
          : AppColors.sell.withValues(alpha: .55);
      canvas.drawRect(
        Rect.fromLTWH(18 + i * 16, size.height - 10 - h, 12, h),
        volumePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

String _formatPrice(double value) {
  final raw = value.toStringAsFixed(2);
  final parts = raw.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '$buffer.${parts.last}';
}

String _formatMoney(double value) => _formatPrice(value);
