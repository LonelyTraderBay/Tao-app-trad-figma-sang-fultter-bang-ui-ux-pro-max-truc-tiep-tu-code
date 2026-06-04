part of 'wallet_health_score_page.dart';

class _WalletHealthScorePageState extends ConsumerState<WalletHealthScorePage> {
  String _tab = _tabOverview;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(walletHealthScoreProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
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
                  padding: EdgeInsets.fromLTRB(20, 12, 20, bottomInset),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  recommendation.actionLabel,
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  recommendation.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _healthPrimary,
                      borderRadius: AppRadii.inputRadius,
                    ),
                    child: Text(
                      'Done',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.onAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
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
      height: 54,
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
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 7,
                      right: 7,
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        height: 2,
                        decoration: BoxDecoration(
                          color: activeTab == tab
                              ? _healthPrimary
                              : AppColors.transparent,
                          borderRadius: BorderRadius.circular(999),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _OverallScoreCard(snapshot: snapshot),
        const SizedBox(height: 16),
        _RadarCard(metrics: snapshot.metrics),
        const SizedBox(height: 16),
        const _SectionLabel(label: 'Chi ti\u1EBFt \u0111i\u1EC3m'),
        const SizedBox(height: 10),
        for (final metric in snapshot.metrics) ...[
          _MetricCard(metric: metric),
          if (metric != snapshot.metrics.last) const SizedBox(height: 8),
        ],
        const SizedBox(height: 16),
        _TrendCard(history: snapshot.history),
        const SizedBox(height: 16),
        const _SectionLabel(label: '\u0110\u1EC1 xu\u1EA5t \u01B0u ti\u00EAn'),
        const SizedBox(height: 10),
        for (final rec in snapshot.priorityRecommendations) ...[
          _RecommendationCard(
            recommendation: rec,
            onTap: () => onRecommendationTap(rec),
          ),
          if (rec != snapshot.priorityRecommendations.last)
            const SizedBox(height: 10),
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
    return Container(
      height: 292,
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 20),
      decoration: BoxDecoration(
        color: _healthPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _healthBorder),
      ),
      child: Column(
        children: [
          Text(
            'Overall Health Score',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size.square(160),
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
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Roboto',
                        height: .95,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '/ 100',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            snapshot.overallStatus,
            style: AppTextStyles.caption.copyWith(
              color: scoreColor,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your wallet is ${snapshot.overallMessage}',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1,
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
    return Container(
      height: 325,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: _healthPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _healthBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Breakdown',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
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
    return Container(
      height: 60,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      decoration: BoxDecoration(
        color: _healthPanel,
        borderRadius: AppRadii.inputRadius,
        border: Border.all(color: _healthBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  metric.category,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
              Text(
                '${metric.score}',
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Roboto',
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              _StatusBadge(label: metric.status, color: color),
            ],
          ),
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 6,
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
    return Container(
      height: 205,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      decoration: BoxDecoration(
        color: _healthPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _healthBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Trend (6 months)',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
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
