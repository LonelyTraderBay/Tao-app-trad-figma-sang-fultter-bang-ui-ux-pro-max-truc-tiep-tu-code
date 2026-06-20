part of 'wallet_health_score_page.dart';

class _WalletHealthScorePageState extends ConsumerState<WalletHealthScorePage> {
  String _tab = _tabOverview;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(walletHealthScoreProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final scrollEndPadding =
        navClearance +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : AppSpacing.contentPad);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-151 WalletHealthScorePage',
      child: Material(
        color: _healthBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Wallet Health',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.wallet),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HealthTabs(
                activeTab: _tab,
                onChanged: (tab) => setState(() => _tab = tab),
              ),
              Expanded(
                child: SingleChildScrollView(
                  key: WalletHealthScorePage.contentKey,
                  padding: AppSpacing.walletHealthScrollPadding(
                    scrollEndPadding,
                  ),
                  physics: const BouncingScrollPhysics(),
                  child: _buildTab(snapshot),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(WalletHealthScoreSnapshot snapshot) {
    if (_tab == _tabSecurity) return _SecurityTab(snapshot: snapshot);
    if (_tab == _tabDiversification) {
      return _DiversificationTab(snapshot: snapshot);
    }
    return _OverviewTab(
      snapshot: snapshot,
      onRecommendationTap: _showRecommendationSheet,
    );
  }

  void _showRecommendationSheet(WalletHealthRecommendation recommendation) {
    showVitBottomSheet<void>(
      context: context,
      backgroundColor: _healthPanel,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.sheetTopRadius,
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: AppSpacing.walletHealthSheetPadding,
            child: VitPageContent(
              density: VitDensity.compact,
              children: [
                Text(
                  recommendation.actionLabel,
                  style: AppTextStyles.sectionTitle,
                ),
                Text(
                  recommendation.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
                  ),
                ),
                VitCtaButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Done',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onAccent,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HealthTabs extends StatelessWidget {
  const _HealthTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      for (final tab in const [_tabOverview, _tabSecurity, _tabDiversification])
        VitTabItem(
          key: tab,
          label: tab,
          widgetKey: WalletHealthScorePage.tabKey(tab),
        ),
    ];

    return Material(
      color: _healthPanel,
      child: SizedBox(
        height: 48,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: VitTabBar(
                  tabs: tabs,
                  activeKey: activeTab,
                  onChanged: onChanged,
                  variant: VitTabBarVariant.underline,
                ),
              ),
            ),
            const Divider(
              height: AppSpacing.dividerHairline,
              color: _healthBorder,
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    required this.snapshot,
    required this.onRecommendationTap,
  });

  final WalletHealthScoreSnapshot snapshot;
  final ValueChanged<WalletHealthRecommendation> onRecommendationTap;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      density: VitDensity.compact,
      children: [
        _OverallScoreCard(snapshot: snapshot),
        _RadarCard(metrics: snapshot.metrics),
        const _SectionLabel(label: 'Chi ti\u1EBFt \u0111i\u1EC3m'),
        for (final metric in snapshot.metrics) ...[_MetricCard(metric: metric)],
        _TrendCard(history: snapshot.history),
        const _SectionLabel(label: '\u0110\u1EC1 xu\u1EA5t \u01B0u ti\u00EAn'),
        if (snapshot.priorityRecommendations.isEmpty)
          const VitEmptyState(
            title: 'No priority recommendations',
            message: 'Wallet health actions will appear here when needed.',
          )
        else
          for (final rec in snapshot.priorityRecommendations) ...[
            _RecommendationCard(
              recommendation: rec,
              onTap: () => onRecommendationTap(rec),
            ),
          ],
      ],
    );
  }
}

class _OverallScoreCard extends StatelessWidget {
  const _OverallScoreCard({required this.snapshot});

  final WalletHealthScoreSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final scoreColor = _scoreColor(snapshot.overallScore);
    return VitCard(
      density: VitDensity.compact,
      borderColor: _healthBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 88,
            height: 88,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size.square(88),
                  painter: _GaugePainter(
                    score: snapshot.overallScore,
                    color: scoreColor,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${snapshot.overallScore}',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: scoreColor,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '/ 100',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Health Score',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.overallStatus,
                  style: AppTextStyles.caption.copyWith(
                    color: scoreColor,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Your wallet is ${snapshot.overallMessage}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1.28,
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

class _RadarCard extends StatelessWidget {
  const _RadarCard({required this.metrics});

  final List<WalletHealthMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: VitDensity.compact.controlHeight * 3.2,
      density: VitDensity.compact,
      borderColor: _healthBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Health Breakdown',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Expanded(
            child: CustomPaint(
              painter: _RadarPainter(metrics),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final WalletHealthMetric metric;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(metric.status);
    return VitCard(
      key: WalletHealthScorePage.metricKey(metric.category),
      radius: VitCardRadius.sm,
      density: VitDensity.compact,
      borderColor: _healthBorder,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  metric.category,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '${metric.score}',
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              _StatusBadge(label: metric.status, color: color),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          ClipRRect(
            borderRadius: AppRadii.pillRadius,
            child: SizedBox(
              height: 5,
              child: LinearProgressIndicator(
                value: metric.score / metric.maxScore,
                backgroundColor: _healthBackground,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard({required this.history});

  final List<WalletHealthHistoryPoint> history;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: VitDensity.compact.controlHeight * 3,
      density: VitDensity.compact,
      borderColor: _healthBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Health Trend (6 months)',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Expanded(
            child: CustomPaint(
              painter: _TrendPainter(history),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}
