import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import '../data/launchpad_repository.dart';

enum _GasTab { prices, estimator, alerts }

class LaunchpadGasTrackerPage extends ConsumerStatefulWidget {
  const LaunchpadGasTrackerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc311_launchpad_gas_content');
  static const heroKey = Key('sc311_launchpad_gas_hero');
  static const tabsKey = Key('sc311_launchpad_gas_tabs');
  static const pricesTabKey = Key('sc311_launchpad_gas_tab_prices');
  static const estimatorTabKey = Key('sc311_launchpad_gas_tab_estimator');
  static const alertsTabKey = Key('sc311_launchpad_gas_tab_alerts');
  static const chainSelectorKey = Key('sc311_launchpad_gas_chains');
  static const chartKey = Key('sc311_launchpad_gas_chart');
  static const eipKey = Key('sc311_launchpad_gas_eip1559');
  static const allChainsKey = Key('sc311_launchpad_gas_all_chains');
  static const estimatesKey = Key('sc311_launchpad_gas_estimates');
  static const alertsKey = Key('sc311_launchpad_gas_alerts');
  static const addAlertKey = Key('sc311_launchpad_gas_add_alert');
  static const addSheetKey = Key('sc311_launchpad_gas_add_sheet');
  static const addSubmitKey = Key('sc311_launchpad_gas_add_submit');
  static const addCloseKey = Key('sc311_launchpad_gas_add_close');

  static Key chainKey(String chain) => Key('sc311_launchpad_gas_chain_$chain');
  static Key estimateKey(String operation) =>
      Key('sc311_launchpad_gas_estimate_$operation');
  static Key alertKey(String id) => Key('sc311_launchpad_gas_alert_$id');
  static Key alertToggleKey(String id) =>
      Key('sc311_launchpad_gas_alert_toggle_$id');
  static Key alertDeleteKey(String id) =>
      Key('sc311_launchpad_gas_alert_delete_$id');
  static Key sheetChainKey(String chain) =>
      Key('sc311_launchpad_gas_sheet_chain_$chain');
  static Key sheetDirectionKey(String value) =>
      Key('sc311_launchpad_gas_sheet_direction_$value');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadGasTrackerPage> createState() =>
      _LaunchpadGasTrackerPageState();
}

class _LaunchpadGasTrackerPageState
    extends ConsumerState<LaunchpadGasTrackerPage> {
  late List<LaunchpadGasAlertDraft> _alerts;
  var _activeTab = _GasTab.prices;
  var _selectedChain = 'Ethereum';
  var _showAddAlert = false;

  @override
  void initState() {
    super.initState();
    final snapshot = ref.read(launchpadRepositoryProvider).getGasTracker();
    _alerts = List.of(snapshot.alerts);
    _selectedChain = snapshot.prices.first.chain;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadRepositoryProvider).getGasTracker();
    final selectedGas = snapshot.prices.firstWhere(
      (price) => price.chain == _selectedChain,
      orElse: () => snapshot.prices.first,
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-311 LaunchpadGasTrackerPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: snapshot.title,
                  showBack: true,
                  onBack: () => context.go(snapshot.backRoute),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x3,
                    AppSpacing.contentPad,
                    AppSpacing.x2,
                  ),
                  child: _FeaturedGasCard(price: selectedGas),
                ),
                Container(
                  key: LaunchpadGasTrackerPage.tabsKey,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                      top: BorderSide(color: AppColors.divider),
                      bottom: BorderSide(color: AppColors.divider),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.contentPad,
                  ),
                  child: _GasTabs(
                    activeTab: _activeTab,
                    onChanged: (tab) => setState(() => _activeTab = tab),
                  ),
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      key: LaunchpadGasTrackerPage.contentKey,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: bottomInset),
                      child: VitPageContent(
                        padding: VitContentPadding.defaultPadding,
                        customGap: AppSpacing.x4,
                        children: [
                          switch (_activeTab) {
                            _GasTab.prices => _PricesTab(
                              prices: snapshot.prices,
                              selectedGas: selectedGas,
                              selectedChain: _selectedChain,
                              onSelected: (chain) =>
                                  setState(() => _selectedChain = chain),
                            ),
                            _GasTab.estimator => _EstimatorTab(
                              estimates: snapshot.estimates,
                            ),
                            _GasTab.alerts => _AlertsTab(
                              alerts: _alerts,
                              onAdd: () => setState(() => _showAddAlert = true),
                              onToggle: _toggleAlert,
                              onDelete: _deleteAlert,
                            ),
                          },
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_showAddAlert)
              Positioned.fill(
                child: _AddAlertSheet(
                  prices: snapshot.prices,
                  onClose: () => setState(() => _showAddAlert = false),
                  onAdd: _addAlert,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _toggleAlert(String id) {
    setState(() {
      _alerts = [
        for (final alert in _alerts)
          if (alert.id == id)
            alert.copyWith(enabled: !alert.enabled)
          else
            alert,
      ];
    });
  }

  void _deleteAlert(String id) {
    setState(() {
      _alerts = [
        for (final alert in _alerts)
          if (alert.id != id) alert,
      ];
    });
  }

  void _addAlert(LaunchpadGasAlertDraft alert) {
    setState(() {
      _alerts = [..._alerts, alert];
      _showAddAlert = false;
    });
  }
}

class _FeaturedGasCard extends StatelessWidget {
  const _FeaturedGasCard({required this.price});

  final LaunchpadGasPriceDraft price;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadGasTrackerPage.heroKey,
      variant: VitCardVariant.hero,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_gas_station_outlined,
                color: AppColors.portfolioTextMuted,
                size: 15,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  '${price.chain} Gas',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.portfolioTextDim,
                    fontSize: 11,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              _TrendPill(price: price),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _TierValue(
                label: 'Slow',
                value: price.slow,
                color: AppColors.buy,
              ),
              _TierValue(
                label: 'Standard',
                value: price.standard,
                color: AppColors.primary,
              ),
              _TierValue(
                label: 'Fast',
                value: price.fast,
                color: AppColors.warn,
              ),
              _TierValue(
                label: 'Instant',
                value: price.instant,
                color: AppColors.sell,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${price.unit} - Updated ${price.lastUpdated}',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.portfolioTextMuted,
                fontSize: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TierValue extends StatelessWidget {
  const _TierValue({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            _formatGasValue(value),
            style: AppTextStyles.base.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              fontSize: 8,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _GasTabs extends StatelessWidget {
  const _GasTabs({required this.activeTab, required this.onChanged});

  final _GasTab activeTab;
  final ValueChanged<_GasTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TabButton(
          key: LaunchpadGasTrackerPage.pricesTabKey,
          label: 'prices',
          active: activeTab == _GasTab.prices,
          onTap: () => onChanged(_GasTab.prices),
        ),
        _TabButton(
          key: LaunchpadGasTrackerPage.estimatorTabKey,
          label: 'estimator',
          active: activeTab == _GasTab.estimator,
          onTap: () => onChanged(_GasTab.estimator),
        ),
        _TabButton(
          key: LaunchpadGasTrackerPage.alertsTabKey,
          label: 'alerts',
          active: activeTab == _GasTab.alerts,
          onTap: () => onChanged(_GasTab.alerts),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? AppColors.primary : AppColors.text3,
                    fontWeight: active
                        ? AppTextStyles.bold
                        : AppTextStyles.medium,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 2,
                width: active ? 116 : 0,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PricesTab extends StatelessWidget {
  const _PricesTab({
    required this.prices,
    required this.selectedGas,
    required this.selectedChain,
    required this.onSelected,
  });

  final List<LaunchpadGasPriceDraft> prices;
  final LaunchpadGasPriceDraft selectedGas;
  final String selectedChain;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ChainSelector(
          prices: prices,
          selectedChain: selectedChain,
          onSelected: onSelected,
        ),
        const SizedBox(height: AppSpacing.x4),
        _GasChartCard(price: selectedGas),
        if (selectedGas.baseFee != null && selectedGas.priorityFee != null) ...[
          const SizedBox(height: AppSpacing.x4),
          _Eip1559Card(price: selectedGas),
        ],
        const SizedBox(height: AppSpacing.x4),
        _AllChainsSection(
          prices: prices,
          selectedChain: selectedChain,
          onSelected: onSelected,
        ),
      ],
    );
  }
}

class _ChainSelector extends StatelessWidget {
  const _ChainSelector({
    required this.prices,
    required this.selectedChain,
    required this.onSelected,
  });

  final List<LaunchpadGasPriceDraft> prices;
  final String selectedChain;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: LaunchpadGasTrackerPage.chainSelectorKey,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final price in prices) ...[
            _SelectablePill(
              key: LaunchpadGasTrackerPage.chainKey(price.chain),
              label: price.chain,
              color: price.accent,
              active: selectedChain == price.chain,
              onTap: () => onSelected(price.chain),
            ),
            const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _GasChartCard extends StatelessWidget {
  const _GasChartCard({required this.price});

  final LaunchpadGasPriceDraft price;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadGasTrackerPage.chartKey,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gas 24h - ${price.chain}',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          SizedBox(
            height: 160,
            child: CustomPaint(
              painter: _GasChartPainter(price),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Eip1559Card extends StatelessWidget {
  const _Eip1559Card({required this.price});

  final LaunchpadGasPriceDraft price;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadGasTrackerPage.eipKey,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EIP-1559',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _FeeBox(
                  label: 'Base Fee',
                  value: _formatGasValue(price.baseFee ?? 0),
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _FeeBox(
                  label: 'Priority Fee',
                  value: _formatGasValue(price.priorityFee ?? 0),
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeeBox extends StatelessWidget {
  const _FeeBox({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.base.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AllChainsSection extends StatelessWidget {
  const _AllChainsSection({
    required this.prices,
    required this.selectedChain,
    required this.onSelected,
  });

  final List<LaunchpadGasPriceDraft> prices;
  final String selectedChain;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadGasTrackerPage.allChainsKey,
      child: VitPageSection(
        label: 'Tat ca chains',
        accentColor: AppColors.accent,
        children: [
          for (final price in prices)
            _ChainComparisonCard(
              price: price,
              selected: selectedChain == price.chain,
              onTap: () => onSelected(price.chain),
            ),
        ],
      ),
    );
  }
}

class _ChainComparisonCard extends StatelessWidget {
  const _ChainComparisonCard({
    required this.price,
    required this.selected,
    required this.onTap,
  });

  final LaunchpadGasPriceDraft price;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: selected
          ? price.accent.withValues(alpha: .35)
          : AppColors.cardBorder,
      padding: const EdgeInsets.all(AppSpacing.x3),
      onTap: onTap,
      child: Row(
        children: [
          _ChainBadge(price: price),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price.chain,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${_formatGasValue(price.slow)} / ${_formatGasValue(price.standard)} / ${_formatGasValue(price.fast)} ${price.unit}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          _TrendInline(price: price),
        ],
      ),
    );
  }
}

class _EstimatorTab extends StatelessWidget {
  const _EstimatorTab({required this.estimates});

  final List<LaunchpadGasEstimateDraft> estimates;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadGasTrackerPage.estimatesKey,
      child: VitPageSection(
        label: 'Chi phi uoc tinh',
        accentColor: AppColors.warn,
        children: [
          for (final estimate in estimates) _EstimateCard(estimate: estimate),
        ],
      ),
    );
  }
}

class _EstimateCard extends StatelessWidget {
  const _EstimateCard({required this.estimate});

  final LaunchpadGasEstimateDraft estimate;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadGasTrackerPage.estimateKey(estimate.operation),
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: AppColors.warn, size: 14),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  estimate.operation,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '${estimate.gasUnits} gas',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontFamily: 'monospace',
                  fontSize: 9,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          for (final cost in estimate.costs) _EstimateCostRow(cost: cost),
          const SizedBox(height: AppSpacing.x2),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _Legend(label: 'Slow', color: AppColors.buy),
              const SizedBox(width: AppSpacing.x3),
              _Legend(label: 'Standard', color: AppColors.primary),
              const SizedBox(width: AppSpacing.x3),
              _Legend(label: 'Fast', color: AppColors.warn),
            ],
          ),
        ],
      ),
    );
  }
}

class _EstimateCostRow extends StatelessWidget {
  const _EstimateCostRow({required this.cost});

  final LaunchpadGasEstimateCostDraft cost;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
        child: Row(
          children: [
            Expanded(
              child: Text(
                cost.chain,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontSize: 10,
                ),
              ),
            ),
            _CostText(cost.slow, AppColors.buy),
            const SizedBox(width: AppSpacing.x3),
            _CostText(cost.standard, AppColors.primary),
            const SizedBox(width: AppSpacing.x3),
            _CostText(cost.fast, AppColors.warn),
          ],
        ),
      ),
    );
  }
}

class _AlertsTab extends StatelessWidget {
  const _AlertsTab({
    required this.alerts,
    required this.onAdd,
    required this.onToggle,
    required this.onDelete,
  });

  final List<LaunchpadGasAlertDraft> alerts;
  final VoidCallback onAdd;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AddAlertCard(onTap: onAdd),
        const SizedBox(height: AppSpacing.x4),
        Container(
          key: LaunchpadGasTrackerPage.alertsKey,
          child: alerts.isEmpty
              ? const _EmptyAlerts()
              : VitPageSection(
                  label: 'Canh bao hien tai',
                  accentColor: AppColors.warn,
                  children: [
                    for (final alert in alerts)
                      _AlertCard(
                        alert: alert,
                        onToggle: () => onToggle(alert.id),
                        onDelete: () => onDelete(alert.id),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _AddAlertCard extends StatelessWidget {
  const _AddAlertCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadGasTrackerPage.addAlertKey,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.primary30,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primary15,
              borderRadius: AppRadii.cardRadius,
            ),
            child: const Icon(Icons.add_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Them canh bao gas',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'Thong bao khi gas dat nguong',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
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

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.alert,
    required this.onToggle,
    required this.onDelete,
  });

  final LaunchpadGasAlertDraft alert;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final trendIcon = alert.direction == LaunchpadGasAlertDirection.below
        ? Icons.trending_down_rounded
        : Icons.trending_up_rounded;

    return VitCard(
      key: LaunchpadGasTrackerPage.alertKey(alert.id),
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: alert.accent.withValues(alpha: .12),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Icon(trendIcon, color: alert.accent, size: 17),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${alert.chain} ${alert.direction == LaunchpadGasAlertDirection.below ? '<' : '>'} ${_formatGasValue(alert.threshold)} ${alert.unit}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '${alert.triggerCount} lan kich hoat${alert.lastTriggered == null ? '' : ' - ${alert.lastTriggered}'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            key: LaunchpadGasTrackerPage.alertToggleKey(alert.id),
            onPressed: onToggle,
            icon: Icon(
              alert.enabled
                  ? Icons.notifications_active_outlined
                  : Icons.notifications_off_outlined,
              color: alert.enabled ? AppColors.buy : AppColors.text3,
              size: 18,
            ),
          ),
          IconButton(
            key: LaunchpadGasTrackerPage.alertDeleteKey(alert.id),
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.sell,
              size: 17,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddAlertSheet extends StatefulWidget {
  const _AddAlertSheet({
    required this.prices,
    required this.onClose,
    required this.onAdd,
  });

  final List<LaunchpadGasPriceDraft> prices;
  final VoidCallback onClose;
  final ValueChanged<LaunchpadGasAlertDraft> onAdd;

  @override
  State<_AddAlertSheet> createState() => _AddAlertSheetState();
}

class _AddAlertSheetState extends State<_AddAlertSheet> {
  final _thresholdController = TextEditingController();
  late String _chain;
  var _direction = LaunchpadGasAlertDirection.below;

  @override
  void initState() {
    super.initState();
    _chain = widget.prices.first.chain;
  }

  @override
  void dispose() {
    _thresholdController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    return double.tryParse(_thresholdController.text.trim()) != null;
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.prices.firstWhere(
      (price) => price.chain == _chain,
      orElse: () => widget.prices.first,
    );

    return Material(
      key: LaunchpadGasTrackerPage.addSheetKey,
      color: Colors.black.withValues(alpha: .72),
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: DeviceMetrics.width),
            decoration: const BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadii.cardLarge),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.contentPad,
                AppSpacing.x3,
                AppSpacing.contentPad,
                AppSpacing.x6,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.borderSolid,
                        borderRadius: AppRadii.xsRadius,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Them canh bao gas',
                          style: AppTextStyles.base.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        key: LaunchpadGasTrackerPage.addCloseKey,
                        onPressed: widget.onClose,
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Text(
                    'Chain',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Wrap(
                    spacing: AppSpacing.x2,
                    runSpacing: AppSpacing.x2,
                    children: [
                      for (final price in widget.prices)
                        _SelectablePill(
                          key: LaunchpadGasTrackerPage.sheetChainKey(
                            price.chain,
                          ),
                          label: price.chain,
                          color: price.accent,
                          active: _chain == price.chain,
                          onTap: () => setState(() => _chain = price.chain),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Text(
                    'Dieu kien',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Row(
                    children: [
                      Expanded(
                        child: _SelectablePill(
                          key: LaunchpadGasTrackerPage.sheetDirectionKey(
                            'below',
                          ),
                          label: 'Thap hon',
                          color: AppColors.buy,
                          active:
                              _direction == LaunchpadGasAlertDirection.below,
                          onTap: () => setState(
                            () => _direction = LaunchpadGasAlertDirection.below,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Expanded(
                        child: _SelectablePill(
                          key: LaunchpadGasTrackerPage.sheetDirectionKey(
                            'above',
                          ),
                          label: 'Cao hon',
                          color: AppColors.sell,
                          active:
                              _direction == LaunchpadGasAlertDirection.above,
                          onTap: () => setState(
                            () => _direction = LaunchpadGasAlertDirection.above,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Text(
                    'Nguong (${selected.unit})',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  TextField(
                    controller: _thresholdController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (_) => setState(() {}),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                    ),
                    decoration: InputDecoration(
                      hintText: 'VD: 15',
                      hintStyle: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                      filled: true,
                      fillColor: AppColors.surface2,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.x3,
                        vertical: AppSpacing.x3,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.borderSolid),
                        borderRadius: AppRadii.inputRadius,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                        borderRadius: AppRadii.inputRadius,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x5),
                  VitCtaButton(
                    key: LaunchpadGasTrackerPage.addSubmitKey,
                    onPressed: _canSubmit ? () => _submit(selected) : null,
                    child: const Text('Them canh bao'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit(LaunchpadGasPriceDraft selected) {
    widget.onAdd(
      LaunchpadGasAlertDraft(
        id: 'ga_new_${DateTime.now().millisecondsSinceEpoch}',
        chain: selected.chain,
        accent: selected.accent,
        threshold: double.parse(_thresholdController.text.trim()),
        direction: _direction,
        unit: selected.unit,
        enabled: true,
        triggerCount: 0,
      ),
    );
  }
}

class _SelectablePill extends StatelessWidget {
  const _SelectablePill({
    super.key,
    required this.label,
    required this.color,
    required this.active,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.smRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            color: active ? color.withValues(alpha: .14) : AppColors.surface2,
            border: Border.all(
              color: active
                  ? color.withValues(alpha: .34)
                  : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.smRadius,
          ),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: active ? color : AppColors.text3,
                fontWeight: AppTextStyles.bold,
                fontSize: 11,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChainBadge extends StatelessWidget {
  const _ChainBadge({required this.price});

  final LaunchpadGasPriceDraft price;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: price.accent.withValues(alpha: .14),
        borderRadius: AppRadii.mdRadius,
      ),
      alignment: Alignment.center,
      child: Text(
        price.chainIcon,
        style: AppTextStyles.micro.copyWith(
          color: price.accent,
          fontWeight: AppTextStyles.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _TrendPill extends StatelessWidget {
  const _TrendPill({required this.price});

  final LaunchpadGasPriceDraft price;

  @override
  Widget build(BuildContext context) {
    final color = _trendColor(price.trend);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_trendIcon(price.trend), color: color, size: 10),
            const SizedBox(width: 3),
            Text(
              _formatChange(price.change24h),
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontSize: 9,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendInline extends StatelessWidget {
  const _TrendInline({required this.price});

  final LaunchpadGasPriceDraft price;

  @override
  Widget build(BuildContext context) {
    final color = _trendColor(price.trend);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(_trendIcon(price.trend), color: color, size: 13),
        const SizedBox(width: 4),
        Text(
          _formatChange(price.change24h),
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.micro.copyWith(color: color, fontSize: 8),
    );
  }
}

class _CostText extends StatelessWidget {
  const _CostText(this.value, this.color);

  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: AppTextStyles.micro.copyWith(
        color: color,
        fontFamily: 'monospace',
        fontWeight: AppTextStyles.medium,
        fontSize: 10,
      ),
    );
  }
}

class _EmptyAlerts extends StatelessWidget {
  const _EmptyAlerts();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x6),
      child: Column(
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.text3,
            size: 32,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Chua co canh bao nao',
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Them canh bao de biet khi gas giam',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _GasChartPainter extends CustomPainter {
  const _GasChartPainter(this.price);

  final LaunchpadGasPriceDraft price;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(34, 12, size.width - 44, size.height - 28);
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = chart.top + chart.height * i / 4;
      _drawDashedLine(
        canvas,
        Offset(chart.left, y),
        Offset(chart.right, y),
        gridPaint,
      );
    }
    for (var i = 0; i <= 4; i++) {
      final x = chart.left + chart.width * i / 4;
      _drawDashedLine(
        canvas,
        Offset(x, chart.top),
        Offset(x, chart.bottom),
        gridPaint,
      );
    }

    final slow = _series(price.standard * .7, 25);
    final standard = _series(price.standard, 25);
    final fast = _series(price.standard * 1.4, 25);
    final maxValue = [
      ...slow,
      ...standard,
      ...fast,
      price.instant,
    ].reduce(math.max);

    _drawSeries(canvas, chart, slow, maxValue, AppColors.buy);
    _drawSeries(canvas, chart, standard, maxValue, AppColors.primary);
    _drawSeries(canvas, chart, fast, maxValue, AppColors.warn);

    final labelPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );
    for (final label in const ['32', '16', '8', '0']) {
      final index = const ['32', '16', '8', '0'].indexOf(label);
      labelPainter.text = TextSpan(
        text: label,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontSize: 9,
        ),
      );
      labelPainter.layout();
      labelPainter.paint(
        canvas,
        Offset(0, chart.top + chart.height * index / 3 - 5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GasChartPainter oldDelegate) {
    return oldDelegate.price.chain != price.chain;
  }
}

List<double> _series(double base, int count) {
  return [
    for (var i = 0; i < count; i++)
      math.max(
        .01,
        base *
            (1 +
                (math.sin(i * .48) + math.cos(i * .27)) * .16 +
                math.sin(i * .93) * .05),
      ),
  ];
}

void _drawSeries(
  Canvas canvas,
  Rect chart,
  List<double> values,
  double maxValue,
  Color color,
) {
  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final x = chart.left + chart.width * i / (values.length - 1);
    final y = chart.bottom - chart.height * (values[i] / maxValue);
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  canvas.drawPath(
    path,
    Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2,
  );
}

void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
  const dash = 4.0;
  const gap = 5.0;
  final delta = end - start;
  final distance = delta.distance;
  final direction = delta / distance;
  var progress = 0.0;
  while (progress < distance) {
    final segmentStart = start + direction * progress;
    final segmentEnd = start + direction * math.min(progress + dash, distance);
    canvas.drawLine(segmentStart, segmentEnd, paint);
    progress += dash + gap;
  }
}

String _formatGasValue(double value) {
  if (value < 1) return value.toStringAsFixed(2);
  if (value == value.roundToDouble()) return value.round().toString();
  return value.toStringAsFixed(1);
}

String _formatChange(double value) {
  if (value == 0) return '0%';
  final prefix = value > 0 ? '+' : '';
  return '$prefix${value.toStringAsFixed(1)}%';
}

Color _trendColor(LaunchpadGasTrend trend) {
  return switch (trend) {
    LaunchpadGasTrend.up => AppColors.sell,
    LaunchpadGasTrend.down => AppColors.buy,
    LaunchpadGasTrend.stable => AppColors.text3,
  };
}

IconData _trendIcon(LaunchpadGasTrend trend) {
  return switch (trend) {
    LaunchpadGasTrend.up => Icons.trending_up_rounded,
    LaunchpadGasTrend.down => Icons.trending_down_rounded,
    LaunchpadGasTrend.stable => Icons.remove_rounded,
  };
}
