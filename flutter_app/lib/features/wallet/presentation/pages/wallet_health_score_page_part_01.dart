part of 'wallet_health_score_page.dart';

class _WalletHealthScorePageState extends ConsumerState<WalletHealthScorePage> {
  String _tab = _tabOverview;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(walletHealthScoreProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome +
                  AppSpacing.walletHealthBottomInsetVisual
            : DeviceMetrics.nativeBottomChrome +
                  AppSpacing.walletHealthBottomInsetNative) +
        MediaQuery.paddingOf(context).bottom;

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
                  padding: AppSpacing.walletHealthScrollPadding(bottomInset),
                  physics: const BouncingScrollPhysics(),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    customGap: 0,
                    fullBleed: true,
                    children: [_buildTab(snapshot)],
                  ),
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
              padding: VitContentPadding.none,
              fullBleed: true,
              customGap: AppSpacing.walletHealthSheetGap,
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
    return Container(
      height: AppSpacing.walletHealthTabsHeight,
      decoration: const BoxDecoration(
        color: _healthPanel,
        border: Border(bottom: BorderSide(color: _healthBorder)),
      ),
      child: Row(
        children: [
          for (final tab in const [
            _tabOverview,
            _tabSecurity,
            _tabDiversification,
          ])
            Expanded(
              child: GestureDetector(
                key: WalletHealthScorePage.tabKey(tab),
                onTap: () => onChanged(tab),
                behavior: HitTestBehavior.opaque,
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        tab,
                        style: AppTextStyles.caption.copyWith(
                          color: activeTab == tab
                              ? _healthPrimary
                              : AppColors.textDisabled,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      left: AppSpacing.walletHealthTabIndicatorInset,
                      right: AppSpacing.walletHealthTabIndicatorInset,
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        height: AppSpacing.walletHealthTabIndicatorHeight,
                        decoration: BoxDecoration(
                          color: activeTab == tab
                              ? _healthPrimary
                              : AppColors.transparent,
                          borderRadius: AppRadii.pillRadius,
                        ),
                      ),
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
  const _OverviewTab({
    required this.snapshot,
    required this.onRecommendationTap,
  });

  final WalletHealthScoreSnapshot snapshot;
  final ValueChanged<WalletHealthRecommendation> onRecommendationTap;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.none,
      fullBleed: true,
      customGap: AppSpacing.walletHealthContentGap,
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
      constraints: const BoxConstraints(
        minHeight: AppSpacing.walletHealthOverallHeight,
      ),
      padding: AppSpacing.walletHealthOverallPadding,
      borderColor: _healthBorder,
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        customGap: AppSpacing.walletHealthCardGap,
        children: [
          Text(
            'Overall Health Score',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          SizedBox(
            width: AppSpacing.walletHealthGaugeSize,
            height: AppSpacing.walletHealthGaugeSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size.square(AppSpacing.walletHealthGaugeSize),
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
                    const SizedBox(height: AppSpacing.walletHealthScoreGap),
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
          Text(
            snapshot.overallStatus,
            style: AppTextStyles.caption.copyWith(
              color: scoreColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          Text(
            'Your wallet is ${snapshot.overallMessage}',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
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
      height: AppSpacing.walletHealthRadarHeight,
      padding: AppSpacing.walletHealthRadarPadding,
      borderColor: _healthBorder,
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        customGap: AppSpacing.walletHealthCardGap,
        children: [
          Text(
            'Health Breakdown',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
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
      radius: VitCardRadius.sm,
      constraints: const BoxConstraints(
        minHeight: AppSpacing.walletHealthMetricHeight,
      ),
      padding: AppSpacing.walletHealthMetricPadding,
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
              const SizedBox(width: AppSpacing.walletHealthMetricValueGap),
              _StatusBadge(label: metric.status, color: color),
            ],
          ),
          const SizedBox(height: AppSpacing.walletHealthInlineGap),
          ClipRRect(
            borderRadius: AppRadii.pillRadius,
            child: SizedBox(
              height: AppSpacing.walletHealthProgressHeight,
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
      height: AppSpacing.walletHealthTrendHeight,
      padding: AppSpacing.walletHealthTrendPadding,
      borderColor: _healthBorder,
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        customGap: AppSpacing.walletHealthTrendGap,
        children: [
          Text(
            'Health Trend (6 months)',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
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
