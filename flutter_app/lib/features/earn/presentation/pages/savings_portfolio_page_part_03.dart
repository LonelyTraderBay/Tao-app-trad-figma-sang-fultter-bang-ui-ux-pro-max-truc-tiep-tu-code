part of 'savings_portfolio_page.dart';

class _EarningsTab extends StatelessWidget {
  const _EarningsTab({required this.snapshot, required this.hideBalance});

  final SavingsPortfolioSnapshot snapshot;
  final bool hideBalance;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: AppSpacing.earnPaddingX5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    color: AppColors.buy,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Tổng lãi nhận được',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const Spacer(),
                  _StatusPill(label: '+0.752%', color: AppColors.buy),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                hideBalance ? '••••••' : '+\$77.72',
                style: AppTextStyles.numericDisplayXl.copyWith(
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                'APY ${snapshot.weightedApy} - Lãi tiết kiệm',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        _SectionLabel(label: 'Lãi theo tài sản', color: AppColors.accent),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          radius: VitCardRadius.lg,
          padding: AppSpacing.earnPaddingX4,
          child: Column(
            children: [
              for (final position in snapshot.positions) ...[
                _AllocationRow(position: position),
                if (position != snapshot.positions.last)
                  const SizedBox(height: AppSpacing.x3),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DecoratedBox(
          decoration: ShapeDecoration(
            color: color,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.hairlineRadius,
            ),
          ),
          child: const SizedBox(
            width: AppSpacing.savingsPortfolioSectionMarkerWidth,
            height: AppSpacing.savingsPortfolioSectionMarkerHeight,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return _ToneBanner(
      text: text,
      icon: Icons.info_outline_rounded,
      color: AppColors.primary,
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return _ToneBanner(
      text: text,
      icon: Icons.warning_amber_rounded,
      color: AppColors.warn,
    );
  }
}

class _ToneBanner extends StatelessWidget {
  const _ToneBanner({
    required this.text,
    required this.icon,
    required this.color,
  });

  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      borderColor: color.withValues(alpha: 0.2),
      padding: AppSpacing.earnPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _TinyDot extends StatelessWidget {
  const _TinyDot({required this.color, this.size = 6});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(color: color, shape: const CircleBorder()),
      child: SizedBox(width: size, height: size),
    );
  }
}

class _AssetBadge extends StatelessWidget {
  const _AssetBadge({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.16),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.mdRadius,
          side: BorderSide(color: color.withValues(alpha: 0.25)),
        ),
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Center(
          child: Text(
            asset.substring(0, math.min(asset.length, 2)),
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.14),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.xlRadius,
          side: BorderSide(color: color.withValues(alpha: 0.24)),
        ),
      ),
      child: Padding(
        padding: AppSpacing.earnSmallPillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _DaysPill extends StatelessWidget {
  const _DaysPill({required this.days, required this.color});

  final int days;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.16),
        shape: CircleBorder(
          side: BorderSide(color: color.withValues(alpha: 0.25)),
        ),
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Center(
          child: Text(
            '$days\nngày',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: color,
              height: AppSpacing.savingsPortfolioDaysLineHeight,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color = AppColors.text1,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.portfolioBtnGhost,
      borderRadius: AppRadii.xlRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.xlRadius,
        child: SizedBox(
          height: AppSpacing.savingsPortfolioSecondaryButtonHeight,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.xlRadius,
                side: BorderSide(color: color.withValues(alpha: 0.18)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: AppSpacing.iconSm),
                const SizedBox(width: AppSpacing.x2),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.xlRadius,
      child: SizedBox(
        height: AppSpacing.x2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: AppColors.surface3),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0, 1),
              child: ColoredBox(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

final class _DonutSegment {
  const _DonutSegment({required this.value, required this.color});

  final double value;
  final Color color;
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({required this.segments});

  final List<_DonutSegment> segments;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = AppSpacing.savingsPortfolioDonutStrokeWidth;
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: AppSpacing.savingsPortfolioDonutDiameter,
      height: AppSpacing.savingsPortfolioDonutDiameter,
    );
    var start = -math.pi / 2;
    for (final segment in segments) {
      final sweep = math.pi * 2 * segment.value;
      paint.color = segment.color;
      canvas.drawArc(rect, start, sweep - 0.035, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.segments != segments;
  }
}

double _allocationValue(String allocationLabel) {
  final value = double.tryParse(allocationLabel.replaceAll('%', '')) ?? 0;
  return (value / 100).clamp(0, 1);
}

Color _assetColor(String asset) {
  return switch (asset) {
    'USDT' => AppColors.buy,
    'BTC' => AppColors.warn,
    'SOL' => AppColors.accent,
    'ETH' => AppColors.primarySoft,
    _ => AppColors.primary,
  };
}

Color _riskColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.warn,
    EarnRiskLevel.high => AppColors.primary,
  };
}

String _statusLabel(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => 'Còn lâu',
    EarnRiskLevel.medium => 'Gần đáo hạn',
    EarnRiskLevel.high => 'Sắp tới',
  };
}
