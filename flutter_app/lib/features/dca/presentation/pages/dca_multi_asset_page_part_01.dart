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
    final scrollBottom =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        AppSpacing.x6 +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'SC-177 DCAMultiAssetPage',
      child: VitAutoHideHeaderScaffold(
        header: VitHeader(
          title: 'Multi-Asset DCA',
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
              child: SingleChildScrollView(
                key: DCAMultiAssetPage.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: scrollBottom),
                child: VitPageContent(
                  customGap: AppSpacing.x4,
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
        label: 'Phan bo tai san',
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
            'Multi-asset DCA giup da dang hoa danh muc. Tu dong phan bo theo ti le muc tieu moi ky.',
      ),
    ];
  }

  List<Widget> _buildAssets(DcaMultiAssetSnapshot snapshot) {
    return [
      _PortfolioOverviewCard(snapshot: snapshot),
      VitPageSection(
        label: 'Chi tiet tai san',
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
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _TopTab(
            label: 'Cai dat',
            tab: _MultiAssetTab.setup,
            active: activeTab == _MultiAssetTab.setup,
            onChanged: onChanged,
          ),
          _TopTab(
            label: 'Tai san',
            tab: _MultiAssetTab.assets,
            active: activeTab == _MultiAssetTab.assets,
            onChanged: onChanged,
          ),
          _TopTab(
            label: 'Hieu suat',
            tab: _MultiAssetTab.performance,
            active: activeTab == _MultiAssetTab.performance,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _TopTab extends StatelessWidget {
  const _TopTab({
    required this.label,
    required this.tab,
    required this.active,
    required this.onChanged,
  });

  final String label;
  final _MultiAssetTab tab;
  final bool active;
  final ValueChanged<_MultiAssetTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        key: DCAMultiAssetPage.tabKey(tab.name),
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(tab),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, AppSpacing.x4, 0, 0),
          child: Column(
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: active ? AppColors.primary : AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                height: 2,
                width: active ? 116 : 0,
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : AppColors.transparent,
                  borderRadius: AppRadii.xsRadius,
                ),
              ),
            ],
          ),
        ),
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
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle('Total Budget per Period'),
          const SizedBox(height: AppSpacing.x3),
          VitInput(
            controller: controller,
            fieldKey: DCAMultiAssetPage.budgetFieldKey,
            keyboardType: TextInputType.number,
            prefix: const Icon(Icons.attach_money_rounded),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Frequency',
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x2),
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
    return SizedBox(
      height: AppSpacing.inputHeight,
      child: Material(
        color: AppColors.transparent,
        borderRadius: AppRadii.inputRadius,
        child: Ink(
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.surface2,
            borderRadius: AppRadii.inputRadius,
            border: Border.all(
              color: active ? AppColors.primary : AppColors.borderSolid,
            ),
          ),
          child: InkWell(
            onTap: onPressed,
            borderRadius: AppRadii.inputRadius,
            child: Center(
              child: Text(
                label,
                style: AppTextStyles.baseMedium.copyWith(
                  color: active ? AppColors.onAccent : AppColors.text1,
                  height: 1,
                ),
              ),
            ),
          ),
        ),
      ),
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
      padding: const EdgeInsets.all(AppSpacing.x4),
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
          const SizedBox(height: AppSpacing.x4),
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
          const SizedBox(height: AppSpacing.x4),
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
    return SizedBox(
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.sell10,
          borderRadius: AppRadii.mdRadius,
        ),
        child: IconButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.delete_outline_rounded,
            size: 18,
            color: AppColors.sell,
          ),
        ),
      ),
    );
  }
}
