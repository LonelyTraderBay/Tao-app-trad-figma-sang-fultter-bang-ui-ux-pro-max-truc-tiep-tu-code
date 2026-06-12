part of 'savings_auto_rebalance_page.dart';

class _AllocationComparisonCard extends StatelessWidget {
  const _AllocationComparisonCard({
    required this.snapshot,
    required this.strategy,
  });

  final SavingsAutoRebalanceSnapshot snapshot;
  final SavingsRebalanceStrategyDraft strategy;

  @override
  Widget build(BuildContext context) {
    final drift = _totalDrift(snapshot.positions, strategy);

    return VitCard(
      key: SavingsAutoRebalancePage.allocationKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        customGap: AppSpacing.x4,
        children: [
          const _SectionTitle(
            icon: Icons.compare_arrows_rounded,
            iconColor: AppColors.primary,
            label: 'Hiện tại vs Mục tiêu',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _AllocationRing(
                  label: 'Hiện tại',
                  allocations: {
                    for (final position in snapshot.positions)
                      position.asset: position.currentPct,
                  },
                  positions: snapshot.positions,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x2),
                child: Column(
                  children: [
                    const Icon(
                      Icons.compare_arrows_rounded,
                      color: AppColors.text3,
                      size: AppSpacing.savingsRebalanceInlineIcon,
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    _TonePill(
                      label: 'Drift ${drift.toStringAsFixed(1)}%',
                      color: _driftColor(drift),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _AllocationRing(
                  label: strategy.name,
                  allocations: strategy.allocations,
                  positions: snapshot.positions,
                ),
              ),
            ],
          ),
          for (final position in snapshot.positions) ...[
            _AssetDriftRow(position: position, strategy: strategy),
          ],
        ],
      ),
    );
  }
}

class _AllocationRing extends StatelessWidget {
  const _AllocationRing({
    required this.label,
    required this.allocations,
    required this.positions,
  });

  final String label;
  final Map<String, double> allocations;
  final List<SavingsRebalancePositionDraft> positions;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.none,
      fullBleed: true,
      customGap: AppSpacing.x2,
      children: [
        SizedBox.square(
          dimension: 118,
          child: CustomPaint(
            painter: _AllocationRingPainter(
              allocations: allocations,
              positions: positions,
            ),
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _AssetDriftRow extends StatelessWidget {
  const _AssetDriftRow({required this.position, required this.strategy});

  final SavingsRebalancePositionDraft position;
  final SavingsRebalanceStrategyDraft strategy;

  @override
  Widget build(BuildContext context) {
    final target = strategy.allocations[position.asset] ?? position.targetPct;
    final drift = position.currentPct - target;
    final color = _assetColor(position);
    final driftColor = _driftColor(drift.abs());

    return Row(
      children: [
        Container(
          width: AppSpacing.savingsRebalanceAssetBadge,
          height: AppSpacing.savingsRebalanceAssetBadge,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .14),
            borderRadius: BorderRadius.circular(AppRadii.sm),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              position.asset,
              style: _captionMedium.copyWith(color: color),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${position.currentPct.toStringAsFixed(1)}% -> ${target.toStringAsFixed(0)}%',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                  const Spacer(),
                  if (position.locked) ...[
                    const Icon(
                      Icons.lock_outline_rounded,
                      size: AppSpacing.savingsRebalanceLockIcon,
                      color: AppColors.text3,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                  ],
                  Text(
                    '${drift >= 0 ? '+' : ''}${drift.toStringAsFixed(1)}%',
                    style: _captionMedium.copyWith(color: driftColor),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x2),
              SizedBox(
                height: AppSpacing.savingsRebalanceTrackHeight,
                child: CustomPaint(
                  painter: _DriftTrackPainter(
                    color: color,
                    driftColor: driftColor,
                    current: position.currentPct,
                    target: target,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DriftStatusCard extends StatelessWidget {
  const _DriftStatusCard({
    required this.drift,
    required this.threshold,
    required this.onPreview,
  });

  final double drift;
  final double threshold;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final color = _driftColor(drift);
    final needsAction = drift >= threshold;

    return VitCard(
      key: SavingsAutoRebalancePage.driftStatusKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: AppSpacing.savingsRebalanceIconBox,
            height: AppSpacing.savingsRebalanceIconBox,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .14),
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: Icon(
              needsAction
                  ? Icons.warning_amber_rounded
                  : Icons.check_circle_outline_rounded,
              color: color,
              size: AppSpacing.savingsRebalanceIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  needsAction ? 'Cần tái cân bằng' : 'Danh mục cân bằng',
                  style: _captionMedium.copyWith(color: AppColors.text1),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Tổng drift: ${drift.toStringAsFixed(1)}% · Ngưỡng: ${threshold.toStringAsFixed(0)}%',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          if (needsAction)
            TextButton(
              key: SavingsAutoRebalancePage.previewButtonKey,
              onPressed: onPreview,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x3,
                  vertical: AppSpacing.x2,
                ),
                backgroundColor: AppColors.primary08,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                  side: const BorderSide(color: AppColors.primary20),
                ),
              ),
              child: const Text('Xem trước'),
            ),
        ],
      ),
    );
  }
}

class _DriftHistoryCard extends StatelessWidget {
  const _DriftHistoryCard({required this.points});

  final List<SavingsRebalanceDriftPointDraft> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsAutoRebalancePage.driftChartKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        customGap: AppSpacing.x3,
        children: [
          const _SectionTitle(
            icon: Icons.bar_chart_rounded,
            iconColor: AppColors.primary,
            label: 'Lịch sử Drift',
          ),
          SizedBox(
            height: AppSpacing.savingsRebalanceDriftChartHeight,
            child: _DriftBarChart(points: points),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(label: '< 3% Tốt', color: AppColors.buy),
              SizedBox(width: AppSpacing.x3),
              _LegendDot(label: '3-8% Lệch', color: AppColors.primary),
              SizedBox(width: AppSpacing.x3),
              _LegendDot(label: '> 8% Cao', color: AppColors.sell),
            ],
          ),
        ],
      ),
    );
  }
}

class _DriftBarChart extends StatelessWidget {
  const _DriftBarChart({required this.points});

  final List<SavingsRebalanceDriftPointDraft> points;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const labels = [8, 6, 4, 2, 0];
        final chartTop = 8.0;
        final chartHeight = constraints.maxHeight - 28;
        final step = (constraints.maxWidth - 42) / points.length;
        const labelWidth = 54.0;
        const labelIndexes = [1, 3, 5, 7, 9];

        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _DriftBarPainter(points: points)),
            ),
            for (final label in labels)
              Positioned(
                left: 0,
                top: chartTop + chartHeight * (1 - label / 8) - 6,
                child: _AxisText('$label%'),
              ),
            for (final i in labelIndexes)
              Positioned(
                left: math
                    .max(
                      0,
                      math.min(
                        constraints.maxWidth - labelWidth,
                        34 + step * i + step / 2 - labelWidth / 2,
                      ),
                    )
                    .toDouble(),
                bottom: 0,
                width: labelWidth,
                child: _AxisText(points[i].date, align: TextAlign.center),
              ),
          ],
        );
      },
    );
  }
}

class _AutoStatusCard extends StatelessWidget {
  const _AutoStatusCard({
    required this.autoEnabled,
    required this.settings,
    required this.onChanged,
  });

  final bool autoEnabled;
  final SavingsRebalanceSettingsDraft settings;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsAutoRebalancePage.autoStatusKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: AppSpacing.savingsRebalanceIconBox,
            height: AppSpacing.savingsRebalanceIconBox,
            decoration: BoxDecoration(
              color: autoEnabled ? AppColors.buy10 : AppColors.hoverBg,
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: Icon(
              autoEnabled ? Icons.play_arrow_rounded : Icons.pause_rounded,
              color: autoEnabled ? AppColors.buy : AppColors.text3,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tự động tái cân bằng',
                  style: _captionMedium.copyWith(color: AppColors.text1),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  autoEnabled
                      ? '${settings.frequencyLabel} · Ngưỡng ${settings.driftThreshold.toStringAsFixed(0)}%'
                      : 'Đã tắt',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: autoEnabled,
            activeThumbColor: AppColors.buy,
            activeTrackColor: AppColors.buy20,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.snapshot, required this.strategy});

  final SavingsAutoRebalanceSnapshot snapshot;
  final SavingsRebalanceStrategyDraft strategy;

  @override
  Widget build(BuildContext context) {
    final completed = snapshot.history
        .where((item) => item.status == SavingsRebalanceHistoryStatus.completed)
        .length;
    final totalMoved = snapshot.history.fold<double>(
      0,
      (sum, item) => sum + item.totalMoved,
    );

    return Row(
      key: SavingsAutoRebalancePage.statsKey,
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.sync_rounded,
            color: AppColors.primary,
            value: '$completed',
            label: 'Lần cân bằng',
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _MetricCard(
            icon: Icons.compare_arrows_rounded,
            color: AppColors.buy,
            value: _formatUsd(totalMoved),
            label: 'Tổng di chuyển',
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _MetricCard(
            icon: Icons.trending_up_rounded,
            color: AppColors.warn,
            value: '${strategy.expectedApy.toStringAsFixed(2)}%',
            label: 'APY kỳ vọng',
          ),
        ),
      ],
    );
  }
}

class _StrategyList extends StatelessWidget {
  const _StrategyList({
    required this.snapshot,
    required this.activeId,
    required this.onChanged,
  });

  final SavingsAutoRebalanceSnapshot snapshot;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Chiến lược đề xuất',
      accentColor: AppColors.primary,
      children: [
        for (final strategy in snapshot.strategies)
          _StrategyCard(
            strategy: strategy,
            active: strategy.id == activeId,
            onTap: () => onChanged(strategy.id),
          ),
      ],
    );
  }
}
