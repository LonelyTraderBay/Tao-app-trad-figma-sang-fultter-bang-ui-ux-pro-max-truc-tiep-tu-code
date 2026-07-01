part of '../pages/staking_multi_chain_page.dart';

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingMultiChainSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingMultiChainPage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.accent30,
      padding: AppSpacing.earnCardPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.public_rounded,
            color: AppColors.accent,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.infoTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalStats extends StatelessWidget {
  const _TotalStats({required this.snapshot});

  final StakingMultiChainSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingMultiChainPage.totalStatsKey,
      radius: VitCardRadius.large,
      padding: AppSpacing.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Portfolio Value',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _formatUsd(snapshot.totalValue, decimals: 0),
                    style: AppTextStyles.numericDisplayXl,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              const _GainPill(label: '+12.4%'),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _MiniMetric(
                  label: '24h Rewards',
                  value: '+\$${snapshot.totalRewards24h.toStringAsFixed(2)}',
                  valueColor: AppColors.buy,
                ),
              ),
              Expanded(
                child: _MiniMetric(
                  label: 'Avg APY',
                  value: '${snapshot.avgApy}%',
                ),
              ),
              Expanded(
                child: _MiniMetric(
                  label: 'Active Chains',
                  value: '${snapshot.activeChains}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _GainPill extends StatelessWidget {
  const _GainPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.buy15,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: AppSpacing.earnSmallPillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _AllocationCard extends StatelessWidget {
  const _AllocationCard({required this.snapshot});

  final StakingMultiChainSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingMultiChainPage.allocationKey,
      radius: VitCardRadius.large,
      padding: AppSpacing.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Chain Allocation', style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: AppSpacing.stakingProductDonutChartHeight,
            child: CustomPaint(
              painter: _DonutPainter(
                positions: snapshot.positions,
                totalValue: snapshot.totalValue,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Wrap(
            spacing: AppSpacing.x5,
            runSpacing: AppSpacing.x2,
            children: [
              for (final position in snapshot.positions)
                _LegendItem(
                  position: position,
                  share: position.value / snapshot.totalValue * 100,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.position, required this.share});

  final StakingChainPositionDraft position;
  final double share;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.stakingProductLegendWidth,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: ShapeDecoration(
              color: _chainColor(position.chainId),
              shape: const CircleBorder(),
            ),
            child: const SizedBox(width: AppSpacing.x3, height: AppSpacing.x3),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              '${position.chain} ${share.toStringAsFixed(1)}%',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({required this.positions, required this.totalValue});

  final List<StakingChainPositionDraft> positions;
  final double totalValue;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - AppSpacing.x5;
    final strokeWidth = AppSpacing.x5;
    var start = -math.pi / 2;

    for (final position in positions) {
      final sweep = (position.value / totalValue) * math.pi * 2;
      final paint = Paint()
        ..color = _chainColor(position.chainId)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep - 0.035,
        false,
        paint,
      );
      start += sweep;
    }

    canvas.drawCircle(
      center,
      radius - strokeWidth / 2,
      Paint()
        ..color = AppColors.bg
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.positions != positions ||
        oldDelegate.totalValue != totalValue;
  }
}

class _PositionsSection extends StatelessWidget {
  const _PositionsSection({required this.snapshot});

  final StakingMultiChainSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingMultiChainPage.positionsKey,
      label: 'Positions by Chain',
      accentColor: AppColors.primarySoft,
      children: [
        for (final position in snapshot.positions)
          _ChainPositionCard(
            position: position,
            dashboardRoute: snapshot.dashboardRoute,
          ),
      ],
    );
  }
}
