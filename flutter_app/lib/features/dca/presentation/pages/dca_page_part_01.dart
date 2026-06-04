part of 'dca_page.dart';

class _DCAPageState extends ConsumerState<DCAPage> {
  _DcaTab _activeTab = _DcaTab.plans;
  bool _createSheetOpen = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(dcaDashboardProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final stickyBottom =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final bottomInset = stickyBottom + AppSpacing.ctaHeight + AppSpacing.x6;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-169 DCAPage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitTopChrome(
            type: VitTopChromeType.rootModule,
            title: 'Mua tự động (DCA)',
            subtitle: 'Tự động mua crypto định kỳ',
            showBack: true,
            onBack: _close,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        key: DCAPage.contentKey,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(bottom: bottomInset),
                        child: VitPageContent(
                          padding: VitContentPadding.relaxed,
                          customGap: AppSpacing.x5,
                          children: [
                            _DcaOverviewCard(
                              snapshot: snapshot,
                              onCreate: _openCreateSheet,
                              onPauseAll: _showPausedState,
                              onChart: () =>
                                  setState(() => _activeTab = _DcaTab.history),
                              onHistory: () =>
                                  setState(() => _activeTab = _DcaTab.history),
                            ),
                            _AdvancedTools(tools: snapshot.tools, onOpen: _go),
                            _DcaTabs(
                              active: _activeTab,
                              planCount: snapshot.plans.length,
                              onChanged: (tab) =>
                                  setState(() => _activeTab = tab),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              child: _activeTab == _DcaTab.plans
                                  ? _PlansList(
                                      key: const ValueKey('plans'),
                                      plans: snapshot.plans,
                                      onPause: _showPausedState,
                                    )
                                  : _HistoryPanel(
                                      key: const ValueKey('history'),
                                      snapshot: snapshot,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 60,
                      right: 60,
                      bottom: stickyBottom,
                      child: VitCtaButton(
                        key: DCAPage.createPlanKey,
                        onPressed: _openCreateSheet,
                        leading: const Icon(Icons.add_rounded),
                        child: const Text('Tạo kế hoạch mới'),
                      ),
                    ),
                    if (_createSheetOpen)
                      _CreatePlanSheet(onClose: _closeCreateSheet),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _go(String route) {
    HapticFeedback.selectionClick();
    context.go(route);
  }

  void _openCreateSheet() {
    HapticFeedback.selectionClick();
    setState(() => _createSheetOpen = true);
  }

  void _closeCreateSheet() {
    HapticFeedback.selectionClick();
    setState(() => _createSheetOpen = false);
  }

  void _showPausedState() {
    HapticFeedback.selectionClick();
    setState(() => _activeTab = _DcaTab.plans);
  }

  void _close() {
    goBackOrFallback(
      context,
      fallbackPath: AppRoutePaths.trade,
      mode: BackNavigationMode.historyThenFallback,
    );
  }
}

class _DcaOverviewCard extends StatelessWidget {
  const _DcaOverviewCard({
    required this.snapshot,
    required this.onCreate,
    required this.onPauseAll,
    required this.onChart,
    required this.onHistory,
  });

  final DcaDashboardSnapshot snapshot;
  final VoidCallback onCreate;
  final VoidCallback onPauseAll;
  final VoidCallback onChart;
  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) {
    final overview = snapshot.overview;
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.contentPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tổng danh mục DCA (VND)',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextDim,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const Icon(
                Icons.visibility_outlined,
                color: AppColors.portfolioTextMuted,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  '₫${_formatFullVnd(overview.currentValueVnd)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.heroNumber.copyWith(
                    fontSize: 29,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              SizedBox(
                width: 96,
                height: AppSpacing.x7,
                child: CustomPaint(
                  painter: _SparklinePainter(
                    values: snapshot.sparkline,
                    lineColor: AppColors.buy,
                    fillColor: AppColors.buy15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DeltaPill(
                      value:
                          '+ ${_formatFullVnd(overview.profitLossVnd)} (+${_formatPercent(overview.profitLossPercent)})',
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      'tổng lãi/lỗ',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.portfolioTextMuted,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '90 ngày',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.portfolioTextMuted,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  icon: Icons.sync_rounded,
                  label: 'Kế\nhoạch',
                  value: '${overview.totalPlans}',
                  subtitle: '${overview.activePlans} đang chạy',
                  color: AppModuleAccents.trade,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _OverviewMetric(
                  icon: Icons.trending_up_rounded,
                  label: 'Đã đầu\ntư',
                  value: _formatCompactVnd(overview.totalInvestedVnd),
                  subtitle: _formatFullVnd(overview.totalInvestedVnd),
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _OverviewMetric(
                  icon: Icons.bar_chart_rounded,
                  label: 'TB/plan',
                  value: _formatCompactVnd(overview.averagePerPlanVnd),
                  subtitle: 'VND / kế hoạch',
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          _NextPurchaseRow(overview: overview),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _OverviewAction(
                  key: DCAPage.overviewCreateKey,
                  icon: Icons.add_rounded,
                  label: 'Tạo mới',
                  color: AppColors.buy,
                  onTap: onCreate,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _OverviewAction(
                  key: DCAPage.pauseAllKey,
                  icon: Icons.pause_rounded,
                  label: 'Tạm dừng',
                  color: AppColors.warn,
                  onTap: onPauseAll,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _OverviewAction(
                  key: DCAPage.chartKey,
                  icon: Icons.bar_chart_rounded,
                  label: 'Biểu đồ',
                  color: AppColors.accent,
                  onTap: onChart,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _OverviewAction(
                  key: DCAPage.historyKey,
                  icon: Icons.format_list_bulleted_rounded,
                  label: 'Lịch sử',
                  color: AppColors.text2,
                  onTap: onHistory,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeltaPill extends StatelessWidget {
  const _DeltaPill({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        decoration: BoxDecoration(
          color: AppColors.buy15,
          borderRadius: AppRadii.inputRadius,
          border: Border.all(color: AppColors.buy20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.arrow_upward_rounded,
              color: AppColors.buy,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: SizedBox(
        height: 78,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: AppSpacing.x6,
                  height: AppSpacing.x6,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .15),
                    borderRadius: AppRadii.mdRadius,
                    border: Border.all(color: color.withValues(alpha: .2)),
                  ),
                  child: Icon(icon, color: color, size: AppSpacing.iconMd),
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.portfolioTextDim,
                      fontWeight: AppTextStyles.bold,
                      height: 1.15,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.sectionTitle.copyWith(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                height: 1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.portfolioTextMuted,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
