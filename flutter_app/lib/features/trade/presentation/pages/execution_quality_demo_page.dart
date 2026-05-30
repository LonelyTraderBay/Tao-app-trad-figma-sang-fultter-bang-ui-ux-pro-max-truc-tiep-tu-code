import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

const _qualityPrimary = AppColors.primary;
const _cardBackground = AppColors.surface2;
const _chipBackground = AppColors.surface2;

enum _QualityTab { slippage, execution, amendment }

class ExecutionQualityDemoPage extends ConsumerStatefulWidget {
  const ExecutionQualityDemoPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc061_execution_quality_scroll_content');
  static const slippageButtonKey = Key('sc061_open_slippage');
  static const executionButtonKey = Key('sc061_open_execution');
  static const amendmentButtonKey = Key('sc061_open_amendment');
  static const slippageSaveKey = Key('sc061_save_slippage');
  static const amendmentSaveKey = Key('sc061_save_amendment');

  static Key tabKey(String id) => Key('sc061_tab_$id');
  static Key featureKey(String id) => Key('sc061_feature_$id');
  static Key toleranceKey(double value) => Key('sc061_tolerance_$value');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ExecutionQualityDemoPage> createState() =>
      _ExecutionQualityDemoPageState();
}

class _ExecutionQualityDemoPageState
    extends ConsumerState<ExecutionQualityDemoPage> {
  _QualityTab _tab = _QualityTab.slippage;
  late TradeSlippageSettings _settings;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _settings = ref
        .read(tradeReadModelControllerProvider)
        .getExecutionQuality()
        .slippageSettings;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getExecutionQuality();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 104 : 24);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-061 ExecutionQualityDemoPage',
      child: Stack(
        children: [
          Material(
            type: MaterialType.transparency,
            child: Column(
              children: [
                VitHeader(
                  title: 'Execution Quality',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.trade),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: ExecutionQualityDemoPage.contentKey,
                    padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _IntroCard(),
                        const SizedBox(height: 12),
                        for (final feature in snapshot.features) ...[
                          _FeatureCard(
                            feature: feature,
                            onTap: () => _onFeatureTap(feature),
                          ),
                          const SizedBox(height: 12),
                        ],
                        const _BenefitsCard(),
                        const SizedBox(height: 12),
                        _ProgressCard(items: snapshot.statusItems),
                        const SizedBox(height: 12),
                        const _ParityCard(),
                        const SizedBox(height: 18),
                        _QualityTabs(
                          active: _tab,
                          onChanged: (tab) => setState(() => _tab = tab),
                        ),
                        const SizedBox(height: 14),
                        if (_tab == _QualityTab.slippage)
                          _SlippageTab(
                            settings: _settings,
                            onOpen: _openSlippageSheet,
                          )
                        else if (_tab == _QualityTab.execution)
                          _ExecutionTab(onOpen: _openExecutionSheet)
                        else
                          _AmendmentTab(onOpen: _openAmendmentSheet),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_successMessage != null)
            Positioned(
              left: 20,
              right: 20,
              top: mode.usesVisualQaFrame ? 80 : 24,
              child: _SuccessToast(
                message: _successMessage!,
                onClose: () => setState(() => _successMessage = null),
              ),
            ),
        ],
      ),
    );
  }

  void _onFeatureTap(TradeExecutionFeature feature) {
    if (feature.id == 'execution') {
      setState(() => _tab = _QualityTab.execution);
      _openExecutionSheet();
      return;
    }
    if (feature.id == 'amendment') {
      setState(() => _tab = _QualityTab.amendment);
      _openAmendmentSheet();
      return;
    }
    setState(() => _tab = _QualityTab.slippage);
    _openSlippageSheet();
  }

  Future<void> _openSlippageSheet() async {
    final updated = await showModalBottomSheet<TradeSlippageSettings>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => _SlippageSheet(settings: _settings),
    );
    if (updated == null || !mounted) return;
    final saved = ref
        .read(tradeReadModelControllerProvider)
        .updateSlippageSettings(updated);
    setState(() {
      _settings = saved;
      _successMessage =
          'Slippage tolerance updated to ${saved.tolerancePct.toStringAsFixed(1)}%';
    });
  }

  Future<void> _openExecutionSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => _ExecutionSheet(
        report: ref
            .read(tradeReadModelControllerProvider)
            .getExecutionQuality()
            .report,
      ),
    );
  }

  Future<void> _openAmendmentSheet() async {
    final order = ref
        .read(tradeReadModelControllerProvider)
        .getExecutionQuality()
        .openOrder;
    final amended = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => _AmendmentSheet(order: order),
    );
    if (amended != true || !mounted) return;
    final result = ref
        .read(tradeReadModelControllerProvider)
        .amendOrder(
          TradeOrderAmendmentRequest(
            orderId: order.id,
            newPrice: 68600,
            newAmount: order.amount,
          ),
        );
    setState(() => _successMessage = 'Order Modified · ${result.orderId}');
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      borderColor: _qualityPrimary.withValues(alpha: .30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconTile(icon: Icons.bolt_rounded, color: _qualityPrimary, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phase 2: Execution Quality',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '3 công cụ đảm bảo execution tối ưu: bảo vệ khỏi slippage xấu, transparency về routing, và modify orders không mất queue position.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                    height: 1.55,
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

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature, required this.onTap});

  final TradeExecutionFeature feature;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(feature.colorHex);
    return InkWell(
      key: ExecutionQualityDemoPage.featureKey(feature.id),
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: _Panel(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _IconTile(icon: _iconFor(feature.id), color: color, size: 48),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature.title,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 14,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feature.description,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String id) {
    return switch (id) {
      'execution' => Icons.bar_chart_rounded,
      'amendment' => Icons.edit_rounded,
      _ => Icons.shield_rounded,
    };
  }
}

class _BenefitsCard extends StatelessWidget {
  const _BenefitsCard();

  static const _items = [
    (
      Icons.security_rounded,
      'Slippage giảm 25 bps',
      'Trung bình từ 0.15% xuống 0.025%',
    ),
    (Icons.diamond_rounded, 'Best execution', 'Smart routing qua 3+ venues'),
    (
      Icons.flash_on_rounded,
      'Modify nhanh hơn',
      'Amend thay vì cancel + replace',
    ),
    (
      Icons.query_stats_rounded,
      'Full transparency',
      'Chi tiết mọi fill + quality score',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Execution Quality Improvements',
            style: AppTextStyles.caption.copyWith(
              fontSize: 14,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 12),
          for (final item in _items) ...[
            _BenefitItem(icon: item.$1, title: item.$2, description: item.$3),
            if (item != _items.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  const _BenefitItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _qualityPrimary, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontSize: 12,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.items});

  final List<TradeRiskStatusItem> items;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Phase 2 Progress',
            style: AppTextStyles.caption.copyWith(
              fontSize: 14,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 12),
          for (final item in items) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontSize: 12,
                    ),
                  ),
                ),
                _StatusPill(complete: item.complete),
              ],
            ),
            if (item != items.last) const SizedBox(height: 9),
          ],
        ],
      ),
    );
  }
}

class _ParityCard extends StatelessWidget {
  const _ParityCard();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      borderColor: AppColors.buy.withValues(alpha: .30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.buy,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tier-1 Exchange Parity Achieved',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Phase 1 + Phase 2 = 100% feature parity với Binance/Coinbase Pro cho execution quality. Order amendment + slippage protection là standard features trên các sàn hàng đầu.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                    height: 1.5,
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

class _QualityTabs extends StatelessWidget {
  const _QualityTabs({required this.active, required this.onChanged});

  final _QualityTab active;
  final ValueChanged<_QualityTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (_QualityTab.slippage, 'Slippage'),
      (_QualityTab.execution, 'Execution'),
      (_QualityTab.amendment, 'Amendment'),
    ];
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _chipBackground,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            Expanded(
              child: _TabButton(
                key: ExecutionQualityDemoPage.tabKey(tabs[i].$1.name),
                label: tabs[i].$2,
                active: active == tabs[i].$1,
                onTap: () => onChanged(tabs[i].$1),
              ),
            ),
            if (i < tabs.length - 1) const SizedBox(width: 4),
          ],
        ],
      ),
    );
  }
}

class _SlippageTab extends StatelessWidget {
  const _SlippageTab({required this.settings, required this.onOpen});

  final TradeSlippageSettings settings;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final reject = settings.rejectOnExceed
        ? 'Auto-reject enabled'
        : 'Warn only';
    return _ActionTab(
      description:
          'Current settings: ${settings.tolerancePct.toStringAsFixed(1)}% tolerance · $reject',
      buttonKey: ExecutionQualityDemoPage.slippageButtonKey,
      label: 'Configure Slippage Protection',
      icon: Icons.shield_rounded,
      colors: const [AppColors.buy, AppColors.buyDark],
      onOpen: onOpen,
    );
  }
}

class _ExecutionTab extends StatelessWidget {
  const _ExecutionTab({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return _ActionTab(
      description: 'View detailed execution breakdown after order fills',
      buttonKey: ExecutionQualityDemoPage.executionButtonKey,
      label: 'View Sample Execution Report',
      icon: Icons.bar_chart_rounded,
      colors: const [AppColors.caution, AppColors.medalBronzeMuted],
      onOpen: onOpen,
    );
  }
}

class _AmendmentTab extends StatelessWidget {
  const _AmendmentTab({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return _ActionTab(
      description: 'Modify open order price or quantity',
      buttonKey: ExecutionQualityDemoPage.amendmentButtonKey,
      label: 'Modify Open Order',
      icon: Icons.edit_rounded,
      colors: const [AppColors.accent, AppColors.accentDark],
      onOpen: onOpen,
    );
  }
}

class _ActionTab extends StatelessWidget {
  const _ActionTab({
    required this.description,
    required this.buttonKey,
    required this.label,
    required this.icon,
    required this.colors,
    required this.onOpen,
  });

  final String description;
  final Key buttonKey;
  final String label;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          description,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        _GradientButton(
          key: buttonKey,
          label: label,
          icon: icon,
          colors: colors,
          onTap: onOpen,
        ),
      ],
    );
  }
}

class _SlippageSheet extends StatefulWidget {
  const _SlippageSheet({required this.settings});

  final TradeSlippageSettings settings;

  @override
  State<_SlippageSheet> createState() => _SlippageSheetState();
}

class _SlippageSheetState extends State<_SlippageSheet> {
  late double _tolerance = widget.settings.tolerancePct;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Slippage Protection',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Set max slippage tolerance before the order is rejected.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (final value in const [.1, .5, 1.0]) ...[
                Expanded(
                  child: _ToleranceChip(
                    value: value,
                    active: _tolerance == value,
                    onTap: () => setState(() => _tolerance = value),
                  ),
                ),
                if (value != 1.0) const SizedBox(width: 8),
              ],
            ],
          ),
          const SizedBox(height: 16),
          _GradientButton(
            key: ExecutionQualityDemoPage.slippageSaveKey,
            label: 'Save Slippage Settings',
            icon: Icons.check_rounded,
            colors: const [AppColors.buy, AppColors.buyDark],
            onTap: () => Navigator.pop(
              context,
              TradeSlippageSettings(
                tolerancePct: _tolerance,
                rejectOnExceed: true,
                partialFillAllowed: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExecutionSheet extends StatelessWidget {
  const _ExecutionSheet({required this.report});

  final TradeExecutionReport report;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Execution Report',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SheetRow(label: 'Order ID', value: report.orderId),
          _SheetRow(label: 'Symbol', value: report.symbol),
          _SheetRow(
            label: 'Average fill',
            value: '\$${_formatMoney(report.averageFillPrice)}',
          ),
          _SheetRow(
            label: 'Execution time',
            value: '${report.executionTimeMs}ms',
          ),
          _SheetRow(
            label: 'Savings',
            value: '\$${report.savingsVsSingleVenue.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 10),
          for (final fill in report.fills) ...[
            _FillTile(fill: fill),
            if (fill != report.fills.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _AmendmentSheet extends StatelessWidget {
  const _AmendmentSheet({required this.order});

  final TradeExecutionOpenOrder order;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Modify Order',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SheetRow(label: 'Order ID', value: order.id),
          _SheetRow(label: 'Symbol', value: order.symbol),
          _SheetRow(
            label: 'Current price',
            value: '\$${_formatMoney(order.price)}',
          ),
          _SheetRow(
            label: 'Queue position',
            value: '#${order.queuePosition} / ${order.totalInQueue}',
          ),
          const SizedBox(height: 16),
          _GradientButton(
            key: ExecutionQualityDemoPage.amendmentSaveKey,
            label: 'Modify Order',
            icon: Icons.check_rounded,
            colors: const [AppColors.accent, AppColors.accentDark],
            onTap: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottom),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: AppColors.borderSolid)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SheetHandle(),
              const SizedBox(height: 18),
              Text(
                title,
                style: AppTextStyles.sectionTitle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _ToleranceChip extends StatelessWidget {
  const _ToleranceChip({
    required this.value,
    required this.active,
    required this.onTap,
  });

  final double value;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ExecutionQualityDemoPage.toleranceKey(value),
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? AppColors.buy.withValues(alpha: .16)
              : _chipBackground,
          border: Border.all(
            color: active ? AppColors.buy : AppColors.cardBorder,
          ),
          borderRadius: AppRadii.smRadius,
        ),
        child: Text(
          '${value.toStringAsFixed(1)}%',
          style: AppTextStyles.caption.copyWith(
            color: active ? AppColors.buy : AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _FillTile extends StatelessWidget {
  const _FillTile({required this.fill});

  final TradeExecutionFill fill;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _chipBackground,
        borderRadius: AppRadii.smRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              fill.venue,
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Text(
            '${fill.amount.toStringAsFixed(1)} BTC @ \$${_formatMoney(fill.price)}',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.complete});

  final bool complete;

  @override
  Widget build(BuildContext context) {
    final color = complete ? AppColors.buy : AppColors.caution;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        complete ? '✓ Complete' : '⏳ Pending',
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
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
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? _qualityPrimary : AppColors.transparent,
          borderRadius: AppRadii.smRadius,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: active ? AppColors.onAccent : AppColors.text2,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    super.key,
    required this.label,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        constraints: const BoxConstraints(minHeight: 52),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: AppRadii.inputRadius,
          boxShadow: [
            BoxShadow(
              color: colors.first.withValues(alpha: .28),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.onAccent, size: 17),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onAccent,
                  fontSize: 14,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({
    required this.icon,
    required this.color,
    required this.size,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: size * .5),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderColor = AppColors.cardBorder,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _cardBackground,
        border: Border.all(color: borderColor),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.borderSolid,
          borderRadius: AppRadii.xsRadius,
        ),
      ),
    );
  }
}

class _SheetRow extends StatelessWidget {
  const _SheetRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontSize: 12,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessToast extends StatelessWidget {
  const _SuccessToast({required this.message, required this.onClose});

  final String message;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.buy10,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: AppColors.buy.withValues(alpha: .38)),
          boxShadow: [
            BoxShadow(
              color: AppColors.dynamicIslandBg.withValues(alpha: .22),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.buy,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            InkWell(
              onTap: onClose,
              borderRadius: AppRadii.xsRadius,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.close_rounded,
                  color: AppColors.text2,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatMoney(double value) {
  if (value >= 1000) {
    final fixed = value.toStringAsFixed(2);
    final parts = fixed.split('.');
    final buffer = StringBuffer();
    for (var i = 0; i < parts.first.length; i++) {
      final remaining = parts.first.length - i;
      buffer.write(parts.first[i]);
      if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
    }
    return '${buffer.toString()}.${parts.last}';
  }
  return value.toStringAsFixed(2);
}
