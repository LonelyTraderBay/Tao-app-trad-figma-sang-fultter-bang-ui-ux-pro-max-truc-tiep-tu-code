part of 'savings_ladder_page.dart';

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.metrics});

  final List<_Metric> metrics;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: AppSpacing.savingsLadderMetricGridColumns,
      childAspectRatio: AppSpacing.savingsLadderGridAspect,
      crossAxisSpacing: AppSpacing.x3,
      mainAxisSpacing: AppSpacing.x3,
      children: [
        for (final metric in metrics)
          VitCard(
            radius: VitCardRadius.lg,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      metric.icon,
                      color: metric.color,
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        metric.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  metric.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.base.copyWith(
                    color: metric.color,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _AssetBreakdown extends StatelessWidget {
  const _AssetBreakdown({required this.rungs});

  final List<SavingsLadderRungDraft> rungs;

  @override
  Widget build(BuildContext context) {
    final total = _totalAllocated(rungs);
    final byAsset = <String, _AssetBucket>{};
    for (final rung in rungs) {
      final current = byAsset[rung.asset] ?? _AssetBucket(rung.colorKey);
      byAsset[rung.asset] = current.add(rung);
    }
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          for (final entry in byAsset.entries) ...[
            _BreakdownRow(
              label: entry.key,
              caption: '${entry.value.count} bậc',
              value: _money(entry.value.totalUsd),
              percent: total <= 0 ? 0 : entry.value.totalUsd / total,
              color: _colorFor(entry.value.colorKey),
            ),
            if (entry.key != byAsset.keys.last)
              const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _AssetBucket {
  const _AssetBucket(this.colorKey, {this.totalUsd = 0, this.count = 0});

  final String colorKey;
  final double totalUsd;
  final int count;

  _AssetBucket add(SavingsLadderRungDraft rung) {
    return _AssetBucket(
      colorKey,
      totalUsd: totalUsd + rung.amountUsd,
      count: count + 1,
    );
  }
}

class _DurationBreakdown extends StatelessWidget {
  const _DurationBreakdown({required this.rungs});

  final List<SavingsLadderRungDraft> rungs;

  @override
  Widget build(BuildContext context) {
    final total = _totalAllocated(rungs);
    return VitPageContent(
      padding: VitContentPadding.none,
      fullBleed: true,
      customGap: AppSpacing.x3,
      children: [
        for (final days in [30, 60, 90]) ...[
          if (rungs.any((rung) => rung.lockDays == days))
            _DurationTile(days: days, rungs: rungs, totalUsd: total),
        ],
      ],
    );
  }
}

class _DurationTile extends StatelessWidget {
  const _DurationTile({
    required this.days,
    required this.rungs,
    required this.totalUsd,
  });

  final int days;
  final List<SavingsLadderRungDraft> rungs;
  final double totalUsd;

  @override
  Widget build(BuildContext context) {
    final dayRungs = rungs.where((rung) => rung.lockDays == days).toList();
    final amount = _totalAllocated(dayRungs);
    final pct = totalUsd <= 0 ? 0.0 : amount / totalUsd;
    final avgApy = dayRungs.isEmpty
        ? 0.0
        : dayRungs.fold<double>(0, (total, rung) => total + rung.apyPct) /
              dayRungs.length;
    final color = days <= 30
        ? AppColors.buy
        : days <= 60
        ? AppColors.primary
        : AppColors.accent;
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          _RoundIcon(icon: Icons.schedule_rounded, color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${dayRungs.length} bậc · ${(pct * 100).toStringAsFixed(0)}%',
                  style: _captionBold.copyWith(color: AppColors.text1),
                ),
                Text(
                  '${_money(amount)} · APY TB: ${avgApy.toStringAsFixed(1)}%',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Text(
            '${avgApy.toStringAsFixed(1)}%',
            style: _captionBold.copyWith(color: AppColors.buy),
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.label,
    required this.caption,
    required this.value,
    required this.percent,
    required this.color,
  });

  final String label;
  final String caption;
  final String value;
  final double percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: AppSpacing.savingsLadderBreakdownDot,
              height: AppSpacing.savingsLadderBreakdownDot,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(label, style: _captionBold.copyWith(color: AppColors.text1)),
            const SizedBox(width: AppSpacing.x2),
            Text(caption, style: AppTextStyles.micro),
            const Spacer(),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              '${(percent * 100).toStringAsFixed(0)}%',
              style: _captionBold.copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.pillRadius,
          child: LinearProgressIndicator(
            minHeight: AppSpacing.savingsLadderProgressHeight,
            value: percent.clamp(0.0, 1.0),
            color: color,
            backgroundColor: AppColors.surface3,
          ),
        ),
      ],
    );
  }
}

class _LiquidityCard extends StatelessWidget {
  const _LiquidityCard({required this.score, required this.rungs});

  final int score;
  final List<SavingsLadderRungDraft> rungs;

  @override
  Widget build(BuildContext context) {
    final color = _liquidityColor(score);
    final label = score >= 70
        ? 'Cao'
        : score >= 40
        ? 'Trung bình'
        : 'Thấp';
    return VitCard(
      radius: VitCardRadius.lg,
      borderColor: color.withValues(alpha: .25),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: AppSpacing.savingsLadderLiquidityRing,
                height: AppSpacing.savingsLadderLiquidityRing,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: score / 100,
                      color: color,
                      backgroundColor: AppColors.surface3,
                      strokeWidth: 7,
                    ),
                    Text(
                      '$score',
                      style: AppTextStyles.base.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thanh khoản $label',
                      style: _captionBold.copyWith(color: AppColors.text1),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      score >= 70
                          ? 'Ladder được phân bổ tốt, đảm bảo dòng tiền liên tục và linh hoạt.'
                          : score >= 40
                          ? 'Cần thêm bậc ngắn hạn để tăng tính linh hoạt khi cần rút.'
                          : 'Hầu hết vốn bị khóa dài hạn. Cân nhắc thêm bậc 30D.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        height: AppSpacing.savingsLadderLiquidityLineHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _LiquidityMini(
                  label: 'Ngắn hạn',
                  value: _money(
                    rungs
                        .where((rung) => rung.lockDays <= 30)
                        .fold<double>(
                          0,
                          (total, rung) => total + rung.amountUsd,
                        ),
                  ),
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _LiquidityMini(
                  label: 'Trung hạn',
                  value: _money(
                    rungs
                        .where((rung) => rung.lockDays == 60)
                        .fold<double>(
                          0,
                          (total, rung) => total + rung.amountUsd,
                        ),
                  ),
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _LiquidityMini(
                  label: 'Dài hạn',
                  value: _money(
                    rungs
                        .where((rung) => rung.lockDays >= 90)
                        .fold<double>(
                          0,
                          (total, rung) => total + rung.amountUsd,
                        ),
                  ),
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LiquidityMini extends StatelessWidget {
  const _LiquidityMini({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _microBold.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _OptimizationTip extends StatelessWidget {
  const _OptimizationTip({
    required this.weightedApy,
    required this.liquidityScore,
  });

  final double weightedApy;
  final int liquidityScore;

  @override
  Widget build(BuildContext context) {
    final text = weightedApy < 5
        ? 'Tăng tỷ trọng sản phẩm APY cao để cải thiện lãi suất bình quân.'
        : liquidityScore < 50
        ? 'Thêm bậc 30D để đảm bảo thanh khoản và giảm rủi ro khóa vốn quá lâu.'
        : 'Ladder hiện tại cân bằng tốt giữa lãi suất và thanh khoản. Bật auto-renew để tối ưu liên tục.';
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: AppColors.accent20,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.accent,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gợi ý tối ưu', style: _captionBold),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.savingsLadderDisclaimerLineHeight,
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

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary12 : AppColors.transparent,
            border: Border.all(
              color: selected ? AppColors.primary30 : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: _captionBold.copyWith(
              color: selected ? AppColors.primary : AppColors.text2,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSpacing.savingsLadderSectionMarkerWidth,
          height: AppSpacing.savingsLadderSectionMarkerHeight,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            label,
            style: _microBold.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}
