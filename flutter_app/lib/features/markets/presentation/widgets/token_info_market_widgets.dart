part of '../pages/token_info_page.dart';

class _SupplyCard extends StatelessWidget {
  const _SupplyCard({required this.fundamentals, required this.supplyPct});

  final TokenFundamentalsDraft fundamentals;
  final double? supplyPct;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _MetricLine(
            label: 'Luu hanh',
            value:
                '${_formatCompact(fundamentals.circulatingSupply)} ${fundamentals.symbol}',
          ),
          if (supplyPct != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      minHeight: 6,
                      value: (supplyPct! / 100).clamp(0, 1).toDouble(),
                      backgroundColor: AppColors.surface3,
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.primarySoft,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${supplyPct!.toStringAsFixed(1)}%',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          _MetricLine(
            label: 'Tong cung',
            value:
                '${_formatCompact(fundamentals.totalSupply)} ${fundamentals.symbol}',
            muted: true,
          ),
          _MetricLine(
            label: 'Cung toi da',
            value:
                '${_formatCompact(fundamentals.maxSupply ?? 0)} ${fundamentals.symbol}',
            muted: true,
          ),
          _MetricLine(
            label: 'Ty le lam phat',
            value: '+${fundamentals.inflationRate.toStringAsFixed(2)}%',
            valueColor: AppColors.warn,
          ),
        ],
      ),
    );
  }
}

class _MetricLine extends StatelessWidget {
  const _MetricLine({
    required this.label,
    required this.value,
    this.muted = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool muted;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor ?? (muted ? AppColors.text2 : AppColors.text1),
              fontWeight: muted ? AppTextStyles.medium : AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _DistributionCard extends StatelessWidget {
  const _DistributionCard({required this.distribution});

  final List<SupplyDistributionDraft> distribution;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CustomPaint(
            size: const Size.square(80),
            painter: _DonutPainter(distribution),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              children: [
                for (final item in distribution)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: item.color,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.label,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                        ),
                        Text(
                          '${item.percentage.toStringAsFixed(1)}%',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
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

class _DonutPainter extends CustomPainter {
  const _DonutPainter(this.distribution);

  final List<SupplyDistributionDraft> distribution;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    var start = -math.pi / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.butt;
    for (final item in distribution) {
      final sweep = math.pi * 2 * (item.percentage / 100);
      canvas.drawArc(
        rect.deflate(9),
        start,
        sweep,
        false,
        paint..color = item.color,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.distribution != distribution;
  }
}

class _AthAtlCards extends StatelessWidget {
  const _AthAtlCards({
    required this.fundamentals,
    required this.athDropPct,
    required this.atlGainPct,
  });

  final TokenFundamentalsDraft fundamentals;
  final double athDropPct;
  final double atlGainPct;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PriceRecordCard(
            label: 'ATH',
            icon: Icons.trending_up_rounded,
            color: AppColors.buy,
            value: _formatPrice(fundamentals.allTimeHigh),
            date: fundamentals.allTimeHighDate,
            delta: '${athDropPct.toStringAsFixed(1)}% so voi ATH',
            deltaColor: AppColors.sell,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _PriceRecordCard(
            label: 'ATL',
            icon: Icons.trending_down_rounded,
            color: AppColors.sell,
            value: _formatPrice(fundamentals.allTimeLow),
            date: fundamentals.allTimeLowDate,
            delta: '+${atlGainPct.toStringAsFixed(1)}% so voi ATL',
            deltaColor: AppColors.buy,
          ),
        ),
      ],
    );
  }
}

class _PriceRecordCard extends StatelessWidget {
  const _PriceRecordCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.value,
    required this.date,
    required this.delta,
    required this.deltaColor,
  });

  final String label;
  final IconData icon;
  final Color color;
  final String value;
  final String date;
  final String delta;
  final Color deltaColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(14),
      borderColor: color.withValues(alpha: 0.18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontSize: 14,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          Text(
            date,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 8),
          Text(
            delta,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: deltaColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartLink extends StatelessWidget {
  const _ChartLink({required this.pairId});

  final String pairId;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: TokenInfoPage.chartButtonKey,
      onTap: () => context.go(AppRoutePaths.pairDetail(pairId)),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _marketPrimary.withValues(alpha: 0.12),
              borderRadius: AppRadii.cardRadius,
            ),
            child: const Icon(Icons.bar_chart_rounded, color: _marketPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xem bieu do & giao dich',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Chart, so lenh, giao dich gan day',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.text3),
        ],
      ),
    );
  }
}
