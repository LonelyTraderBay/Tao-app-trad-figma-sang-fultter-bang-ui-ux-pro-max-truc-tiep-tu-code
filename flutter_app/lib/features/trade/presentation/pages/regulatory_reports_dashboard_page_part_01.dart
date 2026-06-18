part of 'regulatory_reports_dashboard_page.dart';

class _RegulatoryReportsDashboardPageState
    extends ConsumerState<RegulatoryReportsDashboardPage> {
  String _tab = 'overview';
  String _range = '7D';
  String? _notice;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getRegulatoryReportsDashboard();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 118
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-094 RegulatoryReportsDashboardPage',
      child: Material(
        color: _dashBackground,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: 'Regulatory Reports',
                subtitle: 'Dashboard - MiFID II - EMIR',
                showBack: true,
                onBack: () =>
                    context.go(AppRoutePaths.tradeCopyTransactionReporting),
                actions: [
                  VitHeaderActionItem(
                    type: VitHeaderActionType.export,
                    onPressed: () => setState(() => _notice = 'Export queued'),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      key: RegulatoryReportsDashboardPage.contentKey,
                      padding: AppSpacing.tradeBotScrollPaddingWithBottom(
                        bottomInset,
                      ),
                      child: VitPageContent(
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        customGap: AppSpacing.tradeBotContentGap,
                        children: [
                          _ComplianceAlert(totals: snapshot.totals),
                          VitPageSection(
                            customGap: 0,
                            children: [_KpiGrid(totals: snapshot.totals)],
                          ),
                          _RangeSelector(
                            ranges: snapshot.timeRanges,
                            activeId: _range,
                            onChanged: (id) => setState(() => _range = id),
                          ),
                          _Tabs(
                            activeId: _tab,
                            onChanged: (id) => setState(() => _tab = id),
                          ),
                          if (_tab == 'overview')
                            _OverviewTab(snapshot: snapshot)
                          else if (_tab == 'queue')
                            _QueueTab(snapshot: snapshot)
                          else if (_tab == 'compliance')
                            _ComplianceTab(totals: snapshot.totals)
                          else
                            _ExportsTab(
                              onNotice: (text) =>
                                  setState(() => _notice = text),
                            ),
                          _QuickActions(
                            onQueue: () => context.go(
                              AppRoutePaths.tradeCopyTransactionReporting,
                            ),
                            onArmStatus: () => context.go(
                              AppRoutePaths.tradeCopyArmIntegrationStatus,
                            ),
                          ),
                          const VitCard(
                            variant: VitCardVariant.inner,
                            padding: AppSpacing.tradeBotInnerPanelPadding,
                            child: VitPageContent(
                              padding: VitContentPadding.none,
                              customGap: AppSpacing.tradeBotSmallGap,
                              children: [
                                VitHighRiskStatePanel(
                                  state: VitHighRiskUiState.riskReview,
                                  title: 'Regulatory report review',
                                  message:
                                      'Report queue, confirmed count, failed count, export action, ARM route and remediation next step are reviewed before submission follow-up.',
                                  contractId: 'regulatory-reports-review',
                                ),
                                VitStatusPill(
                                  label: 'SLA and failures visible',
                                  status: VitStatusPillStatus.warning,
                                  size: VitStatusPillSize.sm,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_notice != null)
              _NoticePanel(
                text: _notice!,
                onClose: () => setState(() => _notice = null),
              ),
          ],
        ),
      ),
    );
  }
}

class _ComplianceAlert extends StatelessWidget {
  const _ComplianceAlert({required this.totals});

  final TradeRegulatoryDashboardTotals totals;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.tradeBotInnerPanelPadding,
      variant: VitCardVariant.inner,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColors.text1,
            size: AppSpacing.tradeBotMediumIcon,
          ),
          const SizedBox(width: AppSpacing.tradeBotRowGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '100% SLA Compliance (Last 7 Days)',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.tradeBotLineHeightTight,
                  ),
                ),
                const SizedBox(height: AppSpacing.tradeBotNarrowIconGap),
                Text(
                  'All reports submitted within T+1. Zero regulatory breaches. Avg latency: ${totals.avgLatency.round()}s.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.tradeBotLineHeightMedium,
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

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.totals});

  final TradeRegulatoryDashboardTotals totals;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        'Total Reports',
        _formatInt(totals.total),
        '+12% vs last week',
        _dashPrimary,
        Icons.description_outlined,
      ),
      (
        'Success Rate',
        '${totals.successRate.toStringAsFixed(1)}%',
        '${totals.confirmed}/${totals.total} confirmed',
        _dashGreen,
        Icons.check_circle_outline,
      ),
      (
        'Avg Latency',
        '${totals.avgLatency.round()}s',
        'Under 60s SLA',
        _dashAmber,
        Icons.bolt_rounded,
      ),
      (
        'Failed',
        '${totals.failed}',
        '${(totals.failed / totals.total * 100).toStringAsFixed(1)}% failure rate',
        _dashRed,
        Icons.cancel_outlined,
      ),
    ];

    return Row(
      children: [
        for (final item in items) ...[
          Expanded(child: _KpiCard(item: item)),
          if (item != items.last)
            const SizedBox(width: AppSpacing.tradeBotSmallGap),
        ],
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.item});

  final (String, String, String, Color, IconData) item;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: AppSpacing.tradeBotCassSummaryHeight,
      padding: AppSpacing.tradeBotMetricBoxPadding,
      borderColor: _dashBorder.withValues(alpha: .68),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                item.$5,
                color: item.$4,
                size: AppSpacing.tradeBotMediumIcon,
              ),
              const SizedBox(width: AppSpacing.tradeBotTinyGap),
              Expanded(
                child: Text(
                  item.$1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: AppSpacing.tradeBotLineHeightTight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.tradeBotCardGap),
          Text(
            item.$2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: AppSpacing.tradeBotLineHeightTight,
            ),
          ),
          const Spacer(),
          Text(
            item.$3,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: item.$4 == _dashAmber ? _dashGreen : item.$4,
              height: AppSpacing.tradeBotLineHeightTight,
            ),
          ),
        ],
      ),
    );
  }
}

class _RangeSelector extends StatelessWidget {
  const _RangeSelector({
    required this.ranges,
    required this.activeId,
    required this.onChanged,
  });

  final List<String> ranges;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final range in ranges) ...[
          VitStatusPill(
            key: RegulatoryReportsDashboardPage.rangeKey(range),
            label: range,
            status: activeId == range
                ? VitStatusPillStatus.info
                : VitStatusPillStatus.neutral,
            size: VitStatusPillSize.lg,
            onTap: () => onChanged(range),
          ),
          if (range != ranges.last)
            const SizedBox(width: AppSpacing.tradeBotSmallGap),
        ],
      ],
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  static const _tabs = [
    ('overview', 'Overview'),
    ('queue', 'Queue'),
    ('compliance', 'Compliance'),
    ('exports', 'Exports'),
  ];

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      activeKey: activeId,
      tabs: [
        for (final tab in _tabs)
          VitTabItem(
            key: tab.$1,
            label: tab.$2,
            widgetKey: RegulatoryReportsDashboardPage.tabKey(tab.$1),
          ),
      ],
      onChanged: onChanged,
      variant: VitTabBarVariant.segment,
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.snapshot});

  final TradeRegulatoryReportsDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.none,
      customGap: AppSpacing.tradeBotContentGap,
      children: [
        VitPageSection(
          label: 'Submission Trend (Last 7 Days)',
          customGap: AppSpacing.tradeBotCardGap,
          children: [
            _Card(
              padding: AppSpacing.tradeBotInnerPanelPadding,
              child: SizedBox(
                height: AppSpacing.tradeBotDistributionChartHeight,
                child: CustomPaint(
                  painter: _TrendPainter(stats: snapshot.dailyStats),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ],
        ),
        VitPageSection(
          label: 'Report Distribution by Regulation',
          customGap: AppSpacing.tradeBotCardGap,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _Card(
                    padding: AppSpacing.tradeBotInnerPanelPadding,
                    child: SizedBox(
                      height: AppSpacing.tradeBotDashboardChartHeight,
                      child: CustomPaint(
                        painter: _DonutPainter(items: snapshot.distribution),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.tradeBotCardGap),
                Expanded(
                  child: _DistributionLegend(
                    items: snapshot.distribution,
                    total: snapshot.totals.distributionTotal,
                  ),
                ),
              ],
            ),
          ],
        ),
        VitPageSection(
          label: 'ARM Provider Performance',
          customGap: AppSpacing.tradeBotRowGap,
          children: [
            for (final provider in snapshot.providers)
              _ProviderCard(provider: provider),
          ],
        ),
      ],
    );
  }
}
