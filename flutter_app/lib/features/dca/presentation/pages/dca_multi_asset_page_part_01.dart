part of 'dca_multi_asset_page.dart';

class _DCAMultiAssetPageState extends ConsumerState<DCAMultiAssetPage> {
  late final TextEditingController _budgetController;
  late final TextEditingController _thresholdController;
  _MultiAssetTab _activeTab = _MultiAssetTab.setup;
  DcaMultiAssetFrequency _frequency = DcaMultiAssetFrequency.monthly;
  bool _rebalanceEnabled = true;

  @override
  void initState() {
    super.initState();
    final snapshot = ref.read(dcaMultiAssetProvider);
    _budgetController = TextEditingController(
      text: snapshot.totalBudgetUsd.toString(),
    );
    _thresholdController = TextEditingController(
      text: snapshot.rebalanceThresholdPercent.toStringAsFixed(0),
    );
    _frequency = snapshot.activeFrequency;
    _rebalanceEnabled = snapshot.rebalanceEnabled;
  }

  @override
  void dispose() {
    _budgetController.dispose();
    _thresholdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(dcaMultiAssetProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? _dcaMultiAssetVisualNavClearance
        : _dcaMultiAssetNativeNavClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'SC-177 DCAMultiAssetPage',
      child: VitAutoHideHeaderScaffold(
        header: VitHeader(
          title: 'Multi-Asset DCA',
          subtitle: 'Đầu tư có kỷ luật · đa tài sản',
          showBack: true,
          onBack: _close,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopTabs(
              activeTab: _activeTab,
              onChanged: (tab) => setState(() => _activeTab = tab),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: VitInsetScrollView(
                  key: DCAMultiAssetPage.contentKey,
                  physics: const ClampingScrollPhysics(),
                  bottomInset: scrollEndPadding,
                  child: VitPageContent(
                    rhythm: VitPageRhythm.standard,
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    children: [
                      if (_activeTab == _MultiAssetTab.setup)
                        ..._buildSetup(snapshot),
                      if (_activeTab == _MultiAssetTab.assets)
                        ..._buildAssets(snapshot),
                      if (_activeTab == _MultiAssetTab.performance)
                        ..._buildPerformance(snapshot),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSetup(DcaMultiAssetSnapshot snapshot) {
    return [
      _BudgetCard(
        controller: _budgetController,
        frequency: _frequency,
        onFrequencyChanged: (frequency) {
          HapticFeedback.selectionClick();
          setState(() => _frequency = frequency);
        },
      ),
      VitPageSection(
        label: 'Phân bổ tài sản',
        children: [
          for (var i = 0; i < snapshot.allocations.length; i++)
            _AllocationSetupCard(
              key: DCAMultiAssetPage.assetKey(snapshot.allocations[i].symbol),
              asset: snapshot.allocations[i],
              accent: _assetColor(i),
              onDelete: _showDeleteNotice,
            ),
        ],
      ),
      VitCtaButton(
        key: DCAMultiAssetPage.addAssetKey,
        onPressed: _showAddAssetNotice,
        variant: VitCtaButtonVariant.ghost,
        leading: const Icon(Icons.add_rounded),
        child: const Text('Add Asset'),
      ),
      _RebalancingCard(
        enabled: _rebalanceEnabled,
        controller: _thresholdController,
        onToggle: () {
          HapticFeedback.selectionClick();
          setState(() => _rebalanceEnabled = !_rebalanceEnabled);
        },
      ),
      const _InfoCallout(
        icon: Icons.info_outline_rounded,
        text:
            'Multi-asset DCA giúp đa dạng hóa danh mục. Tự động phân bổ theo tỷ lệ mục tiêu mỗi kỳ.',
      ),
      const VitHighRiskStatePanel(
        state: VitHighRiskUiState.riskReview,
        title: 'Multi-asset DCA setup state review',
        message:
            'Budget, frequency, target allocations, asset removal notice, rebalance threshold, and disabled automation state remain visible before saving multi-asset DCA settings.',
        contractId: 'SC-177',
      ),
    ];
  }

  List<Widget> _buildAssets(DcaMultiAssetSnapshot snapshot) {
    return [
      _PortfolioOverviewCard(snapshot: snapshot),
      VitPageSection(
        label: 'Chi tiết tài sản',
        children: [
          for (var i = 0; i < snapshot.allocations.length; i++)
            _AssetDetailCard(
              asset: snapshot.allocations[i],
              accent: _assetColor(i),
            ),
        ],
      ),
      if (snapshot.needsRebalance && _rebalanceEnabled)
        const _WarningCallout(
          icon: Icons.tune_rounded,
          title: 'Rebalancing Required',
          text:
              'Some allocations deviate from target. Next purchase will rebalance automatically.',
        ),
      const VitHighRiskStatePanel(
        state: VitHighRiskUiState.riskReview,
        title: 'Multi-asset portfolio state review',
        message:
            'Portfolio value, per-asset allocation, rebalance requirement, and automatic rebalance toggle remain visible before the next DCA execution.',
        contractId: 'SC-177',
      ),
    ];
  }

  List<Widget> _buildPerformance(DcaMultiAssetSnapshot snapshot) {
    final ranked = [...snapshot.allocations]
      ..sort((a, b) => b.returnPercent.compareTo(a.returnPercent));

    return [
      _GrowthCard(points: snapshot.performance),
      VitPageSection(
        label: 'Asset Performance',
        children: [
          for (var i = 0; i < ranked.length; i++)
            _PerformanceRankRow(
              rank: i + 1,
              asset: ranked[i],
              accent: _assetColor(
                snapshot.allocations.indexWhere(
                  (asset) => asset.id == ranked[i].id,
                ),
              ),
            ),
        ],
      ),
      _DiversificationCard(assetCount: snapshot.allocations.length),
      const VitHighRiskStatePanel(
        state: VitHighRiskUiState.riskReview,
        title: 'Multi-asset performance state review',
        message:
            'Growth chart, ranked asset returns, diversification count, and performance context remain visible before adjusting DCA allocation strategy.',
        contractId: 'SC-177',
      ),
    ];
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.dca);
  }

  void _showAddAssetNotice() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Add asset flow ready')));
  }

  void _showDeleteNotice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Asset removal preview ready')),
    );
  }
}

class _TopTabs extends StatelessWidget {
  const _TopTabs({required this.activeTab, required this.onChanged});

  final _MultiAssetTab activeTab;
  final ValueChanged<_MultiAssetTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          VitTabBar(
            variant: VitTabBarVariant.underline,
            activeKey: activeTab.name,
            onChanged: (key) => onChanged(_MultiAssetTab.values.byName(key)),
            tabs: [
              VitTabItem(
                key: _MultiAssetTab.setup.name,
                label: 'Cài đặt',
                widgetKey: DCAMultiAssetPage.tabKey(_MultiAssetTab.setup.name),
              ),
              VitTabItem(
                key: _MultiAssetTab.assets.name,
                label: 'Tài sản',
                widgetKey: DCAMultiAssetPage.tabKey(_MultiAssetTab.assets.name),
              ),
              VitTabItem(
                key: _MultiAssetTab.performance.name,
                label: 'Hiệu suất',
                widgetKey: DCAMultiAssetPage.tabKey(
                  _MultiAssetTab.performance.name,
                ),
              ),
            ],
          ),
          const Divider(
            height: AppSpacing.hairlineStroke,
            thickness: AppSpacing.hairlineStroke,
            color: AppColors.border,
          ),
        ],
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  const _BudgetCard({
    required this.controller,
    required this.frequency,
    required this.onFrequencyChanged,
  });

  final TextEditingController controller;
  final DcaMultiAssetFrequency frequency;
  final ValueChanged<DcaMultiAssetFrequency> onFrequencyChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.dcaPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle('Total Budget per Period'),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitInput(
            controller: controller,
            fieldKey: DCAMultiAssetPage.budgetFieldKey,
            keyboardType: TextInputType.number,
            prefix: const Icon(Icons.attach_money_rounded),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Frequency',
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: _FrequencyButton(
                  label: 'Weekly',
                  active: frequency == DcaMultiAssetFrequency.weekly,
                  onPressed: () =>
                      onFrequencyChanged(DcaMultiAssetFrequency.weekly),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _FrequencyButton(
                  label: 'Monthly',
                  active: frequency == DcaMultiAssetFrequency.monthly,
                  onPressed: () =>
                      onFrequencyChanged(DcaMultiAssetFrequency.monthly),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FrequencyButton extends StatelessWidget {
  const _FrequencyButton({
    required this.label,
    required this.active,
    required this.onPressed,
  });

  final String label;
  final bool active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: active,
      onTap: onPressed,
      fullWidth: true,
      semanticLabel: label,
    );
  }
}

class _AllocationSetupCard extends StatelessWidget {
  const _AllocationSetupCard({
    super.key,
    required this.asset,
    required this.accent,
    required this.onDelete,
  });

  final DcaMultiAssetAllocation asset;
  final Color accent;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.dcaPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.symbol,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      asset.assetName,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _DeleteButton(onPressed: onDelete),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _MetricText(
                  label: 'Target %',
                  value: _formatPercent(asset.targetPercent),
                ),
              ),
              Expanded(
                child: _MetricText(
                  label: 'Amount per Period',
                  value: _formatUsd(asset.amountPerPeriodUsd),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _PercentBar(
            label: 'Current Allocation',
            valueLabel: _formatPercent(asset.currentPercent),
            percent: asset.currentPercent,
            color: (asset.currentPercent - asset.targetPercent).abs() <= 2
                ? AppColors.buy
                : AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      onTap: onPressed,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: EdgeInsets.zero,
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      borderColor: AppColors.transparent,
      clip: true,
      child: const DecoratedBox(
        decoration: ShapeDecoration(
          color: AppColors.sell10,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          size: AppSpacing.dcaMultiIcon,
          color: AppColors.sell,
        ),
      ),
    );
  }
}
