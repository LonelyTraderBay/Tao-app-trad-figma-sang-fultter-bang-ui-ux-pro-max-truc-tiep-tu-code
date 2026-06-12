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
                      padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                      child: VitPageContent(
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        customGap: 18,
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
                            padding: EdgeInsets.all(12),
                            child: VitPageContent(
                              padding: VitContentPadding.none,
                              customGap: 8,
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
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      variant: VitCardVariant.inner,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColors.text1,
            size: 17,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '100% SLA Compliance (Last 7 Days)',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'All reports submitted within T+1. Zero regulatory breaches. Avg latency: ${totals.avgLatency.round()}s.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    height: 1.4,
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
          if (item != items.last) const SizedBox(width: 8),
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
      height: 124,
      padding: const EdgeInsets.fromLTRB(9, 11, 9, 10),
      borderColor: _dashBorder.withValues(alpha: .68),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(item.$5, color: item.$4, size: 15),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  item.$1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            item.$2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            item.$3,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: item.$4 == _dashAmber ? _dashGreen : item.$4,
              height: 1,
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
          if (range != ranges.last) const SizedBox(width: 8),
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
    return VitCard(
      height: 54,
      child: Row(
        children: [
          for (final tab in _tabs)
            Expanded(
              child: InkWell(
                key: RegulatoryReportsDashboardPage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: activeId == tab.$1
                                ? _dashPrimary
                                : AppColors.text3,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: activeId == tab.$1 ? 58 : 0,
                      height: 2,
                      child: const ColoredBox(color: _dashPrimary),
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

  final TradeRegulatoryReportsDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.none,
      customGap: 18,
      children: [
        VitPageSection(
          label: 'Submission Trend (Last 7 Days)',
          customGap: 12,
          children: [
            _Card(
              padding: const EdgeInsets.all(14),
              child: SizedBox(
                height: 200,
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
          customGap: 12,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _Card(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      height: 180,
                      child: CustomPaint(
                        painter: _DonutPainter(items: snapshot.distribution),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
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
          customGap: 10,
          children: [
            for (final provider in snapshot.providers)
              _ProviderCard(provider: provider),
          ],
        ),
      ],
    );
  }
}
