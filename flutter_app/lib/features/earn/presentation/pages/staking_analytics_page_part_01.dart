part of 'staking_analytics_page.dart';

class _StakingAnalyticsPageState extends ConsumerState<StakingAnalyticsPage> {
  String? _tab;
  bool _showCalculator = false;
  bool _compound = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingAnalyticsRepositoryProvider)
        .getAnalytics();
    final activeTab = _tab ?? snapshot.defaultTab;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-359 StakingAnalyticsPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _SummaryCard(
                      snapshot: snapshot,
                      showCalculator: _showCalculator,
                      onCalculate: _toggleCalculator,
                      onExport: _exportReport,
                    ),
                    if (_showCalculator)
                      _CalculatorCard(
                        key: StakingAnalyticsPage.calculatorKey,
                        compound: _compound,
                        onToggleCompound: () {
                          HapticFeedback.selectionClick();
                          setState(() => _compound = !_compound);
                        },
                      ),
                    _AnalyticsTabs(
                      key: StakingAnalyticsPage.tabBarKey,
                      tabs: snapshot.tabs,
                      activeTab: activeTab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _tab = tab);
                      },
                    ),
                    if (activeTab == 'earnings')
                      _EarningsTab(snapshot: snapshot)
                    else if (activeTab == 'apy')
                      _ApyTab(snapshot: snapshot)
                    else if (activeTab == 'roi')
                      _RoiTab(snapshot: snapshot)
                    else
                      _ProductsTab(snapshot: snapshot),
                    _FooterNote(note: snapshot.footerNote),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleCalculator() {
    HapticFeedback.selectionClick();
    setState(() => _showCalculator = !_showCalculator);
  }

  void _exportReport() {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Xuất báo cáo CSV/PDF sẽ sớm ra mắt')),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.snapshot,
    required this.showCalculator,
    required this.onCalculate,
    required this.onExport,
  });

  final StakingAnalyticsSnapshot snapshot;
  final bool showCalculator;
  final VoidCallback onCalculate;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAnalyticsPage.summaryKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  icon: Icons.attach_money_rounded,
                  label: 'Tổng thu nhập',
                  value: '+${_formatUsd(snapshot.summary.totalEarned)}',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SummaryMetric(
                  icon: Icons.percent_rounded,
                  label: 'APY TB',
                  value: '${snapshot.summary.averageApy.toStringAsFixed(1)}%',
                  color: AppColors.primarySoft,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SummaryMetric(
                  icon: Icons.trending_up_rounded,
                  label: 'Tốt nhất',
                  value: '${snapshot.summary.bestRoi.toStringAsFixed(1)}%',
                  color: AppColors.warn,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: StakingAnalyticsPage.calculateButtonKey,
                  height: 40,
                  onPressed: onCalculate,
                  leading: Icon(
                    showCalculator
                        ? Icons.expand_less_rounded
                        : Icons.bar_chart_rounded,
                  ),
                  child: const Text('Tính lợi nhuận'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitCtaButton(
                  key: StakingAnalyticsPage.exportButtonKey,
                  height: 40,
                  variant: VitCtaButtonVariant.secondary,
                  onPressed: onExport,
                  leading: const Icon(Icons.file_download_outlined),
                  child: const Text('Xuất báo cáo'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 15),
            const SizedBox(width: AppSpacing.x1),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _CalculatorCard extends StatelessWidget {
  const _CalculatorCard({
    super.key,
    required this.compound,
    required this.onToggleCompound,
  });

  final bool compound;
  final VoidCallback onToggleCompound;

  @override
  Widget build(BuildContext context) {
    final principal = 1000.0;
    final apy = 7.5;
    final days = 90.0;
    final earned = compound
        ? principal * math.pow(1 + (apy / 100) / 365, days) - principal
        : principal * (apy / 100) * (days / 365);
    final finalValue = principal + earned;

    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calculate_outlined,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Mẫu tính lợi nhuận',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
              ),
              Switch.adaptive(
                value: compound,
                onChanged: (_) => onToggleCompound(),
                activeThumbColor: AppColors.primary,
                activeTrackColor: AppColors.primary20,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _CalculatorMetric(
                  label: 'Gốc',
                  value: _formatUsd(principal),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _CalculatorMetric(label: 'APY', value: '$apy%'),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _CalculatorMetric(
                  label: compound ? 'Lãi kép' : 'Lãi đơn',
                  value: '+${_formatUsd(earned)}',
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Tổng nhận về ${_formatUsd(finalValue)} sau 90 ngày. Đây là mô phỏng để kiểm UI, không phải cam kết lợi nhuận.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _CalculatorMetric extends StatelessWidget {
  const _CalculatorMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.standard,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsTabs extends StatelessWidget {
  const _AnalyticsTabs({
    super.key,
    required this.tabs,
    required this.activeTab,
    required this.onChanged,
  });

  final List<StakingAnalyticsTabDraft> tabs;
  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x2),
        child: VitTabBar(
          variant: VitTabBarVariant.underline,
          activeKey: activeTab,
          onChanged: onChanged,
          tabs: [
            for (final tab in tabs) VitTabItem(key: tab.id, label: tab.label),
          ],
        ),
      ),
    );
  }
}

class _EarningsTab extends StatelessWidget {
  const _EarningsTab({required this.snapshot});

  final StakingAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitPageSection(
          label: 'Phân tích Thu nhập theo Tài sản',
          accentColor: AppColors.primary,
          children: [_EarningsChartCard(points: snapshot.earningsBreakdown)],
        ),
        VitPageSection(
          label: 'Thu nhập theo Tài sản',
          accentColor: AppColors.primary,
          children: [_AssetEarningsGrid(products: snapshot.productPerformance)],
        ),
      ],
    );
  }
}

class _EarningsChartCard extends StatelessWidget {
  const _EarningsChartCard({required this.points});

  final List<StakingEarningsPointDraft> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAnalyticsPage.earningsChartKey,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x5,
        AppSpacing.x4,
        AppSpacing.x4,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 214,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _YAxisLabels(
                  labels: ['\$320', '\$240', '\$160', '\$80', '\$0'],
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomPaint(
                          painter: _StackedAreaPainter(points: points),
                          size: Size.infinite,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      _DateLabels(dates: points.map((p) => p.date).toList()),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          const _LegendRow(
            entries: [
              _LegendEntry(label: 'BTC', color: _AssetPalette.btc),
              _LegendEntry(label: 'USDT', color: _AssetPalette.usdt),
              _LegendEntry(label: 'ETH', color: _AssetPalette.eth),
              _LegendEntry(label: 'SOL', color: _AssetPalette.sol),
              _LegendEntry(label: 'LP', color: _AssetPalette.lp),
            ],
          ),
        ],
      ),
    );
  }
}
