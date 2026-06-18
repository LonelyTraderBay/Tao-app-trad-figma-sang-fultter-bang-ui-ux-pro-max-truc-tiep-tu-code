part of 'savings_ladder_page.dart';

class _RungTile extends StatelessWidget {
  const _RungTile({
    required this.index,
    required this.rung,
    required this.onToggleRenew,
    required this.onRemove,
  });

  final int index;
  final SavingsLadderRungDraft rung;
  final VoidCallback onToggleRenew;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(rung.colorKey);
    return VitCard(
      key: SavingsLadderPage.rungKey(rung.id),
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: AppSpacing.earnPaddingX3,
      child: Row(
        children: [
          SizedBox.square(
            dimension: AppSpacing.savingsLadderRungIndexBox,
            child: Material(
              color: color.withValues(alpha: .14),
              shape: const CircleBorder(),
              child: Center(
                child: Text('$index', style: _microBold.copyWith(color: color)),
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
                    Flexible(
                      child: Text(
                        rung.product,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _captionBold.copyWith(color: AppColors.text1),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    _SmallPill(
                      label: '${rung.lockDays}D',
                      color: AppColors.warn,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    _SmallPill(
                      label: rung.autoRenew ? 'Tự gia hạn' : 'Dừng',
                      color: rung.autoRenew ? AppColors.buy : AppColors.text3,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x1,
                  children: [
                    Text(
                      _money(rung.amountUsd),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    Text(
                      '${rung.apyPct.toStringAsFixed(1)}%',
                      style: _captionBold.copyWith(color: AppColors.buy),
                    ),
                    Text(
                      '→ ${rung.maturityDate}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: rung.autoRenew ? 'Tắt tự gia hạn' : 'Bật tự gia hạn',
            onPressed: onToggleRenew,
            icon: Icon(
              rung.autoRenew ? Icons.autorenew_rounded : Icons.block_flipped,
              color: rung.autoRenew ? AppColors.buy : AppColors.text3,
              size: AppSpacing.iconSm,
            ),
          ),
          IconButton(
            tooltip: 'Xóa bậc',
            onPressed: onRemove,
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.sell,
              size: AppSpacing.iconSm,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddRungButton extends StatelessWidget {
  const _AddRungButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsLadderPage.addRungKey,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.lg,
      borderColor: AppColors.primary30,
      padding: AppSpacing.earnVerticalPaddingX4,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add_rounded,
            color: AppColors.text2,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            'Thêm bậc ladder',
            style: _captionBold.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _AllocationStatus extends StatelessWidget {
  const _AllocationStatus({
    required this.amountUsd,
    required this.totalAllocated,
    required this.unallocated,
  });

  final int amountUsd;
  final double totalAllocated;
  final double unallocated;

  @override
  Widget build(BuildContext context) {
    final complete = unallocated.abs() < 1;
    final progress = amountUsd <= 0
        ? 0.0
        : (totalAllocated / amountUsd).clamp(0.0, 1.0);
    final color = complete ? AppColors.buy : AppColors.warn;
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: color.withValues(alpha: .18),
      padding: AppSpacing.earnPaddingX3,
      child: Row(
        children: [
          Expanded(
            child: Text(
              complete
                  ? 'Đã phân bổ hết'
                  : 'Chưa phân bổ: ${_money(unallocated)}',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          SizedBox(
            width: AppSpacing.savingsLadderAllocationProgressWidth,
            child: ClipRRect(
              borderRadius: AppRadii.pillRadius,
              child: LinearProgressIndicator(
                minHeight: AppSpacing.savingsLadderProgressHeight,
                value: progress,
                color: color,
                backgroundColor: AppColors.surface3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineTab extends StatelessWidget {
  const _TimelineTab({required this.snapshot, required this.rungs});

  final SavingsLadderSnapshot snapshot;
  final List<SavingsLadderRungDraft> rungs;

  @override
  Widget build(BuildContext context) {
    if (rungs.isEmpty) {
      return _EmptyTab(
        icon: Icons.layers_clear_outlined,
        title: 'Chưa có bậc nào',
        cta: 'Bắt đầu xây',
      );
    }

    final sorted = [...rungs]..sort((a, b) => a.lockDays.compareTo(b.lockDays));
    return VitPageContent(
      key: SavingsLadderPage.timelineKey,
      padding: VitContentPadding.none,
      fullBleed: true,
      customGap: AppSpacing.x5,
      children: [
        const _SectionTitle(label: 'Lịch đáo hạn'),
        _TimelineChart(rungs: sorted),
        const _SectionTitle(label: 'Lịch trình đáo hạn'),
        VitPageContent(
          padding: VitContentPadding.none,
          fullBleed: true,
          customGap: AppSpacing.x3,
          children: [for (final rung in sorted) _MaturityTile(rung: rung)],
        ),
        const _SectionTitle(label: 'Dự kiến dòng tiền'),
        _CashFlowCard(rungs: sorted),
        _Disclaimer(text: snapshot.disclaimer),
      ],
    );
  }
}

class _TimelineChart extends StatelessWidget {
  const _TimelineChart({required this.rungs});

  final List<SavingsLadderRungDraft> rungs;

  @override
  Widget build(BuildContext context) {
    final maxDays = rungs.map((rung) => rung.lockDays).reduce(math.max);
    return VitCard(
      radius: VitCardRadius.lg,
      padding: AppSpacing.earnPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Hôm nay',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const Spacer(),
              Text(
                '${maxDays}D',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final rung in rungs) ...[
            _TimelineBar(rung: rung, maxDays: maxDays),
            if (rung != rungs.last) const SizedBox(height: AppSpacing.x2),
          ],
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final rung in rungs)
                _SmallPill(
                  label: rung.maturityDate,
                  color: _colorFor(rung.colorKey),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineBar extends StatelessWidget {
  const _TimelineBar({required this.rung, required this.maxDays});

  final SavingsLadderRungDraft rung;
  final int maxDays;

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(rung.colorKey);
    final widthFactor = math.max(.18, rung.lockDays / maxDays);
    return Row(
      children: [
        SizedBox(
          width: AppSpacing.savingsLadderTimelineLabelWidth,
          child: Text(
            '${rung.asset} ${rung.lockDays}D',
            textAlign: TextAlign.right,
            style: _microBold.copyWith(color: color),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Stack(
            children: [
              SizedBox(
                height: AppSpacing.savingsLadderTimelineBarHeight,
                child: Material(
                  color: AppColors.surface3,
                  borderRadius: AppRadii.smRadius,
                ),
              ),
              FractionallySizedBox(
                widthFactor: widthFactor,
                child: SizedBox(
                  height: AppSpacing.savingsLadderTimelineBarHeight,
                  child: Material(
                    color: color.withValues(alpha: .18),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.smRadius,
                      side: BorderSide(color: color.withValues(alpha: .3)),
                    ),
                    child: Padding(
                      padding: AppSpacing.earnHorizontalPaddingX2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${_money(rung.amountUsd)} · ${rung.apyPct.toStringAsFixed(1)}%',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: color,
                            fontWeight: AppTextStyles.bold,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ),
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

class _MaturityTile extends StatelessWidget {
  const _MaturityTile({required this.rung});

  final SavingsLadderRungDraft rung;

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(rung.colorKey);
    final parts = rung.maturityDate.split('/');
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: AppSpacing.earnPaddingX3,
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.savingsLadderMaturityBadgeWidth,
            height: AppSpacing.savingsLadderMaturityBadgeHeight,
            child: Material(
              color: color.withValues(alpha: .12),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.mdRadius,
                side: BorderSide(color: color.withValues(alpha: .25)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(parts.first, style: _captionBold.copyWith(color: color)),
                  Text(
                    'T${parts[1]}',
                    style: AppTextStyles.micro.copyWith(color: color),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rung.product,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _captionBold.copyWith(color: AppColors.text1),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${_money(rung.amountUsd)} · ${rung.apyPct.toStringAsFixed(1)}% APY',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+${_money(_interestForTerm(rung))}',
                style: _captionBold.copyWith(
                  color: AppColors.buy,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              Text(
                rung.autoRenew ? 'Tự gia hạn' : 'Dừng',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CashFlowCard extends StatelessWidget {
  const _CashFlowCard({required this.rungs});

  final List<SavingsLadderRungDraft> rungs;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      borderColor: AppColors.buy20,
      padding: AppSpacing.earnPaddingX4,
      child: Column(
        children: [
          for (final rung in rungs) ...[
            _DetailRow(
              label: rung.maturityDate,
              value:
                  'Vốn ${_money(rung.amountUsd)}  +${_money(_interestForTerm(rung))}',
              color: AppColors.buy,
            ),
            if (rung != rungs.last) const Divider(color: AppColors.divider),
          ],
          const Divider(color: AppColors.divider),
          _DetailRow(
            label: 'Tổng',
            value:
                '${_money(_totalAllocated(rungs))}  +${_money(rungs.fold<double>(0, (total, rung) => total + _interestForTerm(rung)))}',
            color: AppColors.buy,
          ),
        ],
      ),
    );
  }
}

class _AnalysisTab extends StatelessWidget {
  const _AnalysisTab({
    required this.snapshot,
    required this.rungs,
    required this.amountUsd,
    required this.weightedApy,
    required this.annualInterest,
    required this.liquidityScore,
  });

  final SavingsLadderSnapshot snapshot;
  final List<SavingsLadderRungDraft> rungs;
  final int amountUsd;
  final double weightedApy;
  final double annualInterest;
  final int liquidityScore;

  @override
  Widget build(BuildContext context) {
    if (rungs.isEmpty) {
      return _EmptyTab(
        icon: Icons.bar_chart_rounded,
        title: 'Tạo ladder để xem phân tích',
        cta: 'Bắt đầu xây',
      );
    }

    final avgLockDays =
        rungs.fold<int>(0, (total, rung) => total + rung.lockDays) ~/
        rungs.length;
    return VitPageContent(
      key: SavingsLadderPage.analysisKey,
      padding: VitContentPadding.none,
      fullBleed: true,
      customGap: AppSpacing.x5,
      children: [
        _MetricGrid(
          metrics: [
            _Metric(
              'APY bình quân',
              '${weightedApy.toStringAsFixed(2)}%',
              Icons.trending_up_rounded,
              AppColors.buy,
            ),
            _Metric(
              'Thanh khoản',
              '$liquidityScore/100',
              Icons.bolt_rounded,
              _liquidityColor(liquidityScore),
            ),
            _Metric(
              'Lock TB',
              '$avgLockDays ngày',
              Icons.lock_outline_rounded,
              AppColors.warn,
            ),
            _Metric(
              'Lãi dự kiến/năm',
              _money(annualInterest),
              Icons.attach_money_rounded,
              AppColors.buy,
            ),
          ],
        ),
        const _SectionTitle(label: 'Phân bổ theo tài sản'),
        _AssetBreakdown(rungs: rungs),
        const _SectionTitle(label: 'Phân bổ theo thời hạn'),
        _DurationBreakdown(rungs: rungs),
        const _SectionTitle(label: 'Đánh giá thanh khoản'),
        _LiquidityCard(score: liquidityScore, rungs: rungs),
        _OptimizationTip(
          weightedApy: weightedApy,
          liquidityScore: liquidityScore,
        ),
        _Disclaimer(text: snapshot.disclaimer),
      ],
    );
  }
}

class _Metric {
  const _Metric(this.label, this.value, this.icon, this.color);

  final String label;
  final String value;
  final IconData icon;
  final Color color;
}
