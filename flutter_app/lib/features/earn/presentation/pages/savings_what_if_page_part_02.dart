part of 'savings_what_if_page.dart';

class _ResultsTab extends StatelessWidget {
  const _ResultsTab({
    required this.result,
    required this.scenario,
    required this.hasRun,
    required this.onRun,
    required this.onReset,
  });

  final _ScenarioResult result;
  final SavingsWhatIfScenarioDraft scenario;
  final bool hasRun;
  final VoidCallback onRun;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    if (!hasRun) {
      return _EmptyResults(onRun: onRun);
    }

    final positive = result.difference >= 0;
    final impactColor = positive ? AppColors.buy : AppColors.sell;
    return Column(
      key: SavingsWhatIfPage.resultsKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(label: 'Kết quả mô phỏng'),
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          borderColor: impactColor.withValues(alpha: .35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _RoundIcon(
                    color: impactColor,
                    icon: _scenarioIcon(scenario.iconKey),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kịch bản: ${scenario.label}',
                          style: _captionBold.copyWith(color: AppColors.text1),
                        ),
                        Text(
                          '${scenario.durationMonths} tháng · ${_riskLabel(scenario.riskLevel)}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _ImpactBadge(value: result.differencePct),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      label: 'Giá trị cuối',
                      value: _money(result.scenarioValue),
                      color: impactColor,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _MetricTile(
                      label: 'Chênh lệch',
                      value:
                          '${positive ? '+' : ''}${_money(result.difference)}',
                      color: impactColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x3),
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      label: 'Lãi baseline',
                      value: _money(result.baselineInterest),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _MetricTile(
                      label: 'Lãi kịch bản',
                      value: _money(result.scenarioInterest),
                      color: impactColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        _ComparisonChart(result: result),
        const SizedBox(height: AppSpacing.x4),
        const _SectionTitle(label: 'Ảnh hưởng theo tài sản'),
        _AssetImpactList(result: result),
        const SizedBox(height: AppSpacing.x4),
        Row(
          children: [
            Expanded(
              child: VitCtaButton(
                key: SavingsWhatIfPage.resetKey,
                variant: VitCtaButtonVariant.secondary,
                onPressed: onReset,
                leading: const Icon(Icons.restart_alt_rounded),
                child: const Text('Reset'),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitCtaButton(
                onPressed: onRun,
                leading: const Icon(Icons.play_arrow_rounded),
                child: const Text('Chạy lại'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.onRun});

  final VoidCallback onRun;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          const Icon(
            Icons.analytics_outlined,
            color: AppColors.text3,
            size: 44,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Chưa chạy mô phỏng',
            style: _captionBold.copyWith(color: AppColors.text1),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Chọn kịch bản và bấm "Chạy mô phỏng" để xem kết quả.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCtaButton(
            onPressed: onRun,
            leading: const Icon(Icons.play_arrow_rounded),
            child: const Text('Chạy mô phỏng'),
          ),
        ],
      ),
    );
  }
}

class _StressTab extends StatelessWidget {
  const _StressTab({required this.snapshot});

  final SavingsWhatIfSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final results = [
      for (final scenario in snapshot.scenarios)
        if (scenario.id != SavingsWhatIfScenarioId.custom)
          _StressScenarioResult(
            scenario: scenario,
            result: _simulateScenario(
              snapshot.portfolio,
              scenario,
              snapshot.defaultCustomMultiplier,
              snapshot.defaultCustomVolatility,
            ),
          ),
    ]..sort((a, b) => b.result.difference.compareTo(a.result.difference));
    final worst = results.last;
    final best = results.first;
    final average =
        results.fold<double>(
          0,
          (sum, entry) => sum + entry.result.differencePct,
        ) /
        results.length;
    final score = math.max(0, math.min(100, 50 + average * 5)).round();
    final scoreColor = score >= 60
        ? AppColors.buy
        : score >= 40
        ? AppColors.warn
        : AppColors.sell;

    return Column(
      key: SavingsWhatIfPage.stressKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.stacked_line_chart_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Stress Test tổng hợp',
                    style: _captionBold.copyWith(color: AppColors.text2),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              _StressBars(results: results),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        const _SectionTitle(label: 'Xếp hạng theo ảnh hưởng'),
        for (final entry in results) ...[
          _StressRankCard(entry: entry),
          if (entry != results.last) const SizedBox(height: AppSpacing.x3),
        ],
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          borderColor: scoreColor.withValues(alpha: .35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.shield_outlined, color: scoreColor, size: 18),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Đánh giá chống chịu',
                    style: _captionBold.copyWith(color: AppColors.text2),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              Row(
                children: [
                  _ScoreRing(score: score, color: scoreColor),
                  const SizedBox(width: AppSpacing.x4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          score >= 60
                              ? 'Danh mục chống chịu tốt'
                              : score >= 40
                              ? 'Cần cải thiện'
                              : 'Rủi ro cao',
                          style: _captionBold.copyWith(color: AppColors.text1),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          'Xấu nhất (${worst.scenario.label}): ${worst.result.differencePct.toStringAsFixed(1)}%. Tốt nhất (${best.scenario.label}): +${best.result.differencePct.toStringAsFixed(1)}%.',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      label: 'TB ảnh hưởng',
                      value:
                          '${average >= 0 ? '+' : ''}${average.toStringAsFixed(1)}%',
                      color: average >= 0 ? AppColors.buy : AppColors.sell,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _MetricTile(
                      label: 'Xấu nhất',
                      value:
                          '${worst.result.differencePct.toStringAsFixed(1)}%',
                      color: AppColors.sell,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _MetricTile(
                      label: 'Tốt nhất',
                      value:
                          '+${best.result.differencePct.toStringAsFixed(1)}%',
                      color: AppColors.buy,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        const _InfoCallout(
          icon: Icons.auto_awesome_rounded,
          color: AppColors.primary,
          title: 'Gợi ý tăng kháng chịu',
          text:
              'Đa dạng hóa tài sản và pha trộn sản phẩm linh hoạt với cố định giúp giảm rủi ro trong kịch bản bất lợi. Cân nhắc tăng tỷ trọng stablecoin để đảm bảo ổn định.',
        ),
        const SizedBox(height: AppSpacing.x3),
        _Disclaimer(text: snapshot.stressDisclaimer, tone: AppColors.warn),
      ],
    );
  }
}

class _StressBars extends StatelessWidget {
  const _StressBars({required this.results});

  final List<_StressScenarioResult> results;

  @override
  Widget build(BuildContext context) {
    final maxAbs = results.fold<double>(
      1,
      (maxValue, entry) => math.max(maxValue, entry.result.differencePct.abs()),
    );
    return Column(
      children: [
        for (final entry in results) ...[
          Row(
            children: [
              SizedBox(
                width: 88,
                child: Text(
                  entry.scenario.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: ClipRRect(
                  borderRadius: AppRadii.smRadius,
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: entry.result.differencePct.abs() / maxAbs,
                    backgroundColor: AppColors.surface3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      entry.result.differencePct >= 0
                          ? AppColors.buy
                          : AppColors.sell,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              SizedBox(
                width: 52,
                child: Text(
                  '${entry.result.differencePct >= 0 ? '+' : ''}${entry.result.differencePct.toStringAsFixed(1)}%',
                  textAlign: TextAlign.right,
                  style: _microBold.copyWith(
                    color: entry.result.differencePct >= 0
                        ? AppColors.buy
                        : AppColors.sell,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
          if (entry != results.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _StressRankCard extends StatelessWidget {
  const _StressRankCard({required this.entry});

  final _StressScenarioResult entry;

  @override
  Widget build(BuildContext context) {
    final result = entry.result;
    final color = result.difference >= 0 ? AppColors.buy : AppColors.sell;
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      borderColor: color.withValues(alpha: .18),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RoundIcon(
                color: color,
                icon: _scenarioIcon(entry.scenario.iconKey),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          entry.scenario.label,
                          style: _captionBold.copyWith(color: AppColors.text1),
                        ),
                        _RiskPill(level: entry.scenario.riskLevel),
                      ],
                    ),
                    Text(
                      entry.scenario.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                '${result.differencePct >= 0 ? '+' : ''}${result.differencePct.toStringAsFixed(1)}%',
                style: _captionBold.copyWith(
                  color: color,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: 'Giá trị cuối',
                  value: _money(result.scenarioValue),
                  color: color,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _MetricTile(
                  label: 'Drawdown',
                  value: '${result.maxDrawdown.toStringAsFixed(2)}%',
                  color: result.maxDrawdown > 1
                      ? AppColors.sell
                      : AppColors.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _MetricTile(
                  label: 'Hồi phục',
                  value: result.recoveryMonths == 0
                      ? '-'
                      : '${result.recoveryMonths}M',
                  color: result.recoveryMonths == 0
                      ? AppColors.buy
                      : AppColors.warn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComparisonChart extends StatelessWidget {
  const _ComparisonChart({required this.result});

  final _ScenarioResult result;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Baseline vs kịch bản',
            style: _captionBold.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: 150,
            width: double.infinity,
            child: CustomPaint(
              painter: _LineChartPainter(points: result.monthlyData),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _LegendDot(color: AppColors.primary, label: 'Baseline'),
              SizedBox(width: AppSpacing.x4),
              _LegendDot(color: AppColors.buy, label: 'Kịch bản'),
            ],
          ),
        ],
      ),
    );
  }
}
