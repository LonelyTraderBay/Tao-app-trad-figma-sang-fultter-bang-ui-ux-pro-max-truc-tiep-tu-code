part of '../pages/copy_performance_page.dart';

class _PerformanceSummary extends StatelessWidget {
  const _PerformanceSummary({required this.snapshot});

  final TradeCopyPerformanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tổng quan so sánh',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ReturnCard(
                  title: 'Hiệu suất của bạn',
                  value: '+${snapshot.yourReturnPct.toStringAsFixed(1)}%',
                  range:
                      '\$${snapshot.initialCapital.toStringAsFixed(0)} → \$${snapshot.yourCurrentValue.toStringAsFixed(0)}',
                  border: _performancePrimary,
                  foreground: _performancePrimary,
                  textColor: AppColors.infoTextStrong,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ReturnCard(
                  title: 'Provider lý thuyết',
                  value: '+${snapshot.providerReturnPct.toStringAsFixed(1)}%',
                  range:
                      '\$${snapshot.initialCapital.toStringAsFixed(0)} → \$${snapshot.providerTheoreticalValue.toStringAsFixed(0)}',
                  border: _performancePurple,
                  foreground: _performancePurple,
                  textColor: AppColors.accentTextStrong,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          VitCard(
            variant: VitCardVariant.ghost,
            padding: const EdgeInsets.all(12),
            borderColor: _performanceGreen,
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: _performanceGreen,
                      size: 15,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Chênh lệch hiệu suất',
                        style: TextStyle(color: AppColors.buy20),
                      ),
                    ),
                    Text(
                      '${snapshot.performanceGapPct.toStringAsFixed(2)}%',
                      style: AppTextStyles.baseMedium.copyWith(
                        color: _performanceGreen,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nguyên nhân chính: slippage (${snapshot.avgSlippagePct.toStringAsFixed(2)}%) và chi phí (\$${snapshot.totalCosts.toStringAsFixed(0)})',
                    style: AppTextStyles.micro.copyWith(color: AppColors.buy20),
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

class _ReturnCard extends StatelessWidget {
  const _ReturnCard({
    required this.title,
    required this.value,
    required this.range,
    required this.border,
    required this.foreground,
    required this.textColor,
  });

  final String title;
  final String value;
  final String range;
  final Color border;
  final Color foreground;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      height: 92,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      borderColor: border,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: textColor),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: foreground,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(range, style: AppTextStyles.micro.copyWith(color: textColor)),
        ],
      ),
    );
  }
}

class _PerformanceTabs extends StatelessWidget {
  const _PerformanceTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      ('overview', 'Tổng quan'),
      ('trades', 'Trades'),
      ('costs', 'Chi phí'),
      ('metrics', 'Metrics'),
    ];
    return VitCard(
      variant: VitCardVariant.inner,
      height: 52,
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: CopyPerformancePage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.$2,
                          style: AppTextStyles.caption.copyWith(
                            color: activeTab == tab.$1
                                ? _performancePrimary
                                : AppColors.text3,
                            fontWeight: activeTab == tab.$1
                                ? FontWeight.w800
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: activeTab == tab.$1 ? 70 : 0,
                      height: 2,
                      color: _performancePrimary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.snapshot});

  final TradeCopyPerformanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Đường vốn so sánh (30 ngày)',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 258,
          child: CustomPaint(
            painter: _LineChartPainter(points: snapshot.equityCurve),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: 14),
        _InfoBox(
          title: 'Tại sao có chênh lệch?',
          lines: const [
            'Slippage: Copy orders thực thi chậm hơn 0.5-3s',
            'Chi phí: Trading fees + performance fees',
            'Position sizing: Fixed mode sử dụng 50% capital',
          ],
        ),
        const SizedBox(height: 18),
        Text(
          'Phân bổ Slippage',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 220,
          child: CustomPaint(
            painter: _BarChartPainter(buckets: snapshot.slippageBuckets),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SmallMetricCard(
                label: 'Slippage TB của bạn',
                value: '${snapshot.avgSlippagePct.toStringAsFixed(2)}%',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SmallMetricCard(
                label: 'Provider TB',
                value: '${snapshot.providerAvgSlippagePct.toStringAsFixed(2)}%',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
