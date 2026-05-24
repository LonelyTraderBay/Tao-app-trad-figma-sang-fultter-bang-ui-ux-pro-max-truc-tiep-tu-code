import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/dca_repository.dart';

enum _MultiAssetTab { setup, assets, performance }

class DCAMultiAssetPage extends ConsumerStatefulWidget {
  const DCAMultiAssetPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc177_multi_asset_content');
  static const addAssetKey = Key('sc177_add_asset');
  static const rebalanceToggleKey = Key('sc177_rebalance_toggle');
  static const budgetFieldKey = Key('sc177_budget_field');
  static const thresholdFieldKey = Key('sc177_threshold_field');

  static Key tabKey(String tabName) => Key('sc177_tab_$tabName');
  static Key assetKey(String symbol) => Key('sc177_asset_$symbol');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DCAMultiAssetPage> createState() => _DCAMultiAssetPageState();
}

class _DCAMultiAssetPageState extends ConsumerState<DCAMultiAssetPage> {
  late final TextEditingController _budgetController;
  late final TextEditingController _thresholdController;
  _MultiAssetTab _activeTab = _MultiAssetTab.setup;
  DcaMultiAssetFrequency _frequency = DcaMultiAssetFrequency.monthly;
  bool _rebalanceEnabled = true;

  @override
  void initState() {
    super.initState();
    final snapshot = const DcaRepository().getMultiAsset();
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
    final snapshot = ref.watch(dcaRepositoryProvider).getMultiAsset();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollBottom =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        AppSpacing.x6 +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'SC-177 DCAMultiAssetPage',
      child: Column(
        children: [
          VitHeader(title: 'Multi-Asset DCA', showBack: true, onBack: _close),
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
                  color: active ? AppColors.primary : Colors.transparent,
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
        color: Colors.transparent,
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
                  color: active ? Colors.white : AppColors.text1,
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

class _RebalancingCard extends StatelessWidget {
  const _RebalancingCard({
    required this.enabled,
    required this.controller,
    required this.onToggle,
  });

  final bool enabled;
  final TextEditingController controller;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.settings_outlined,
                color: AppColors.text1,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Auto Rebalancing',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _TokenSwitch(enabled: enabled, onToggle: onToggle),
            ],
          ),
          if (enabled) ...[
            const SizedBox(height: AppSpacing.x4),
            VitInput(
              controller: controller,
              fieldKey: DCAMultiAssetPage.thresholdFieldKey,
              label: 'Rebalance Threshold (%)',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              'Rebalance when allocation deviates by this %',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ],
      ),
    );
  }
}

class _TokenSwitch extends StatelessWidget {
  const _TokenSwitch({required this.enabled, required this.onToggle});

  final bool enabled;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: DCAMultiAssetPage.rebalanceToggleKey,
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 52,
        height: 32,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: enabled ? AppColors.primary : AppColors.surface3,
          borderRadius: AppRadii.xlRadius,
          border: Border.all(
            color: enabled ? AppColors.primary : AppColors.borderSolid,
          ),
        ),
        alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _PortfolioOverviewCard extends StatelessWidget {
  const _PortfolioOverviewCard({required this.snapshot});

  final DcaMultiAssetSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle('Portfolio Overview'),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _MetricText(
                  label: 'Total Invested',
                  value: _formatUsd(snapshot.totalInvestedUsd),
                  large: true,
                ),
              ),
              Expanded(
                child: _MetricText(
                  label: 'Current Value',
                  value: _formatUsd(snapshot.currentValueUsd),
                  color: AppColors.buy,
                  large: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _MetricText(
                  label: 'Total Return',
                  value: '+${_formatUsd(snapshot.totalReturnUsd)}',
                  color: AppColors.buy,
                ),
              ),
              Expanded(
                child: _MetricText(
                  label: 'Return %',
                  value: '+${snapshot.totalReturnPercent.toStringAsFixed(2)}%',
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: _AllocationDonutPainter(
                allocations: snapshot.allocations,
              ),
              child: Center(
                child: Text(
                  'Portfolio',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetDetailCard extends StatelessWidget {
  const _AssetDetailCard({required this.asset, required this.accent});

  final DcaMultiAssetAllocation asset;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: AppRadii.xsRadius,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.symbol,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      asset.assetName,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _MetricText(
                  label: 'Invested',
                  value: _formatUsd(asset.totalInvestedUsd),
                ),
              ),
              Expanded(
                child: _MetricText(
                  label: 'Value',
                  value: _formatUsd(asset.currentValueUsd),
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _MetricText(
                  label: 'Shares',
                  value: asset.shares.toStringAsFixed(4),
                ),
              ),
              Expanded(
                child: _MetricText(
                  label: 'Avg Price',
                  value: _formatUsd(asset.averagePriceUsd),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GrowthCard extends StatelessWidget {
  const _GrowthCard({required this.points});

  final List<DcaMultiAssetPerformancePoint> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle('Investment Growth by Asset'),
          const SizedBox(height: AppSpacing.x5),
          SizedBox(
            height: 240,
            width: double.infinity,
            child: CustomPaint(painter: _StackedBarsPainter(points: points)),
          ),
          const SizedBox(height: AppSpacing.x4),
          Wrap(
            spacing: AppSpacing.x4,
            runSpacing: AppSpacing.x3,
            children: const [
              _LegendItem(label: 'BTC', color: AppColors.primary),
              _LegendItem(label: 'ETH', color: AppColors.buy),
              _LegendItem(label: 'BNB', color: AppColors.warn),
              _LegendItem(label: 'SOL', color: AppColors.accent),
            ],
          ),
        ],
      ),
    );
  }
}

class _PerformanceRankRow extends StatelessWidget {
  const _PerformanceRankRow({
    required this.rank,
    required this.asset,
    required this.accent,
  });

  final int rank;
  final DcaMultiAssetAllocation asset;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.iconLg,
            child: rank == 1
                ? Icon(
                    Icons.trending_up_rounded,
                    color: accent,
                    size: AppSpacing.iconMd,
                  )
                : Text(
                    '#$rank',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.symbol,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  asset.assetName,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+${asset.returnPercent.toStringAsFixed(2)}%',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                '+${_formatUsd(asset.returnUsd)}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DiversificationCard extends StatelessWidget {
  const _DiversificationCard({required this.assetCount});

  final int assetCount;

  @override
  Widget build(BuildContext context) {
    return _SuccessCallout(
      icon: Icons.check_circle_outline_rounded,
      title: 'Diversification Score',
      score: '8.5',
      text: 'Portfolio well diversified across $assetCount assets',
    );
  }
}

class _InfoCallout extends StatelessWidget {
  const _InfoCallout({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.sm,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningCallout extends StatelessWidget {
  const _WarningCallout({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.warn, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessCallout extends StatelessWidget {
  const _SuccessCallout({
    required this.icon,
    required this.title,
    required this.text,
    required this.score,
  });

  final IconData icon;
  final String title;
  final String text;
  final String score;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.buy, size: AppSpacing.iconMd),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      text,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                score,
                style: AppTextStyles.heroNumber.copyWith(
                  color: AppColors.buy,
                  fontSize: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  '/ 10',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricText extends StatelessWidget {
  const _MetricText({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
    this.large = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: (large ? AppTextStyles.sectionTitle : AppTextStyles.baseMedium)
              .copyWith(color: color, fontWeight: AppTextStyles.bold),
        ),
      ],
    );
  }
}

class _PercentBar extends StatelessWidget {
  const _PercentBar({
    required this.label,
    required this.valueLabel,
    required this.percent,
    required this.color,
  });

  final String label;
  final String valueLabel;
  final double percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
            Text(
              valueLabel,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: LinearProgressIndicator(
            minHeight: 6,
            value: (percent / 100).clamp(0.0, 1.0),
            backgroundColor: AppColors.surface3,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.baseMedium.copyWith(
        color: AppColors.text1,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}

class _AllocationDonutPainter extends CustomPainter {
  const _AllocationDonutPainter({required this.allocations});

  final List<DcaMultiAssetAllocation> allocations;

  @override
  void paint(Canvas canvas, Size size) {
    if (allocations.isEmpty) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.34;
    final rect = Rect.fromCircle(center: center, radius: radius);
    var start = -math.pi / 2;
    for (var i = 0; i < allocations.length; i++) {
      final sweep = allocations[i].currentPercent / 100 * math.pi * 2;
      final paint = Paint()
        ..color = _assetColor(i)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 24
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, start, sweep - 0.04, false, paint);
      _drawDonutLabel(
        canvas,
        center,
        radius + 26,
        start + sweep / 2,
        allocations[i].symbol,
      );
      start += sweep;
    }
    final innerPaint = Paint()
      ..color = AppColors.cardBg
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 22, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _AllocationDonutPainter oldDelegate) {
    return oldDelegate.allocations != allocations;
  }
}

class _StackedBarsPainter extends CustomPainter {
  const _StackedBarsPainter({required this.points});

  final List<DcaMultiAssetPerformancePoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    const bottomLabelHeight = 20.0;
    final chartHeight = size.height - bottomLabelHeight;
    final maxTotal = points.map((point) => point.totalUsd).reduce(math.max);
    final gap = size.width / (points.length * 3 + 1);
    final barWidth = gap * 1.6;
    final baseY = chartHeight;
    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;

    for (var i = 0; i <= 3; i++) {
      final y = chartHeight - chartHeight * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final x = gap + i * gap * 3 + gap * 0.7;
      var top = baseY;
      final segments = [
        (point.btcUsd, AppColors.primary),
        (point.ethUsd, AppColors.buy),
        (point.bnbUsd, AppColors.warn),
        (point.solUsd, AppColors.accent),
      ];
      for (final segment in segments) {
        final height = chartHeight * segment.$1 / maxTotal;
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, top - height, barWidth, height),
          const Radius.circular(AppRadii.xs),
        );
        canvas.drawRRect(rect, Paint()..color = segment.$2);
        top -= height;
      }
      _drawBottomLabel(
        canvas,
        point.month,
        Offset(x + barWidth / 2, baseY + 5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StackedBarsPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

void _drawDonutLabel(
  Canvas canvas,
  Offset center,
  double radius,
  double angle,
  String label,
) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: label,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text2,
        fontWeight: AppTextStyles.bold,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  final offset = Offset(
    center.dx + math.cos(angle) * radius - textPainter.width / 2,
    center.dy + math.sin(angle) * radius - textPainter.height / 2,
  );
  textPainter.paint(canvas, offset);
}

void _drawBottomLabel(Canvas canvas, String label, Offset center) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: label,
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  textPainter.paint(
    canvas,
    Offset(center.dx - textPainter.width / 2, center.dy),
  );
}

Color _assetColor(int index) {
  switch (index % 4) {
    case 0:
      return AppColors.primary;
    case 1:
      return AppColors.buy;
    case 2:
      return AppColors.warn;
    default:
      return AppColors.accent;
  }
}

String _formatUsd(num value) => '\$${value.round()}';

String _formatPercent(double value) {
  final rounded = value.roundToDouble();
  if (rounded == value) return '${rounded.toInt()}%';
  return '${value.toStringAsFixed(1)}%';
}
