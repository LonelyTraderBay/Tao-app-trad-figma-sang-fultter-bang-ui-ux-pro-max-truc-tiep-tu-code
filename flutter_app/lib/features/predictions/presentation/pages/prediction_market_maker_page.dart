import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';

const _predictionPrimary = AppColors.primary;

enum _MarketMakerTab { provide, positions, earnings }

class PredictionMarketMakerPage extends ConsumerStatefulWidget {
  const PredictionMarketMakerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc037_market_maker_content');
  static const provideTabKey = Key('sc037_tab_provide');
  static const positionsTabKey = Key('sc037_tab_positions');
  static const earningsTabKey = Key('sc037_tab_earnings');
  static const amountFieldKey = Key('sc037_liquidity_amount');
  static const spread25Key = Key('sc037_spread_25');
  static const spread50Key = Key('sc037_spread_50');
  static const spread100Key = Key('sc037_spread_100');
  static const spread200Key = Key('sc037_spread_200');
  static const addLiquidityKey = Key('sc037_add_liquidity');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionMarketMakerPage> createState() =>
      _PredictionMarketMakerPageState();
}

class _PredictionMarketMakerPageState
    extends ConsumerState<PredictionMarketMakerPage> {
  _MarketMakerTab _activeTab = _MarketMakerTab.provide;
  late final TextEditingController _eventController;
  late final TextEditingController _amountController;
  late final TextEditingController _minDepthController;
  int _spreadBps = 50;

  @override
  void initState() {
    super.initState();
    final snapshot = ref
        .read(predictionsReadModelControllerProvider)
        .getMarketMaker();
    _spreadBps = snapshot.defaultSpreadBps;
    _eventController = TextEditingController(text: snapshot.defaultEventName);
    _amountController = TextEditingController();
    _minDepthController = TextEditingController(
      text: _formatInput(snapshot.defaultMinDepth),
    );
    _amountController.addListener(_refresh);
  }

  @override
  void dispose() {
    _amountController
      ..removeListener(_refresh)
      ..dispose();
    _eventController.dispose();
    _minDepthController.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(predictionsReadModelControllerProvider)
        .getMarketMaker();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-037 PredictionMarketMakerPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Market Maker',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.marketsPredictions),
            ),
            _MarketMakerTabBar(
              activeTab: _activeTab,
              onChanged: (tab) => setState(() => _activeTab = tab),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: PredictionMarketMakerPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 16,
                    children: _activeTab == _MarketMakerTab.provide
                        ? [
                            _LiquidityOverview(snapshot: snapshot),
                            _AddLiquidityForm(
                              eventController: _eventController,
                              amountController: _amountController,
                              minDepthController: _minDepthController,
                              spreadBps: _spreadBps,
                              onSpreadChanged: (value) =>
                                  setState(() => _spreadBps = value),
                            ),
                            const _LiquidityWarning(),
                          ]
                        : _activeTab == _MarketMakerTab.positions
                        ? [_PositionsTab(snapshot: snapshot)]
                        : [_EarningsTab(snapshot: snapshot)],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarketMakerTabBar extends StatelessWidget {
  const _MarketMakerTabBar({required this.activeTab, required this.onChanged});

  final _MarketMakerTab activeTab;
  final ValueChanged<_MarketMakerTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (
        key: PredictionMarketMakerPage.provideTabKey,
        tab: _MarketMakerTab.provide,
        label: 'Cung cap',
      ),
      (
        key: PredictionMarketMakerPage.positionsTabKey,
        tab: _MarketMakerTab.positions,
        label: 'Vi the',
      ),
      (
        key: PredictionMarketMakerPage.earningsTabKey,
        tab: _MarketMakerTab.earnings,
        label: 'Thu nhap',
      ),
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SizedBox(
        height: 54,
        child: Row(
          children: [
            for (final item in tabs)
              Expanded(
                child: InkWell(
                  key: item.key,
                  onTap: () => onChanged(item.tab),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            item.label,
                            style: AppTextStyles.caption.copyWith(
                              color: activeTab == item.tab
                                  ? _predictionPrimary
                                  : AppColors.text3,
                              fontWeight: AppTextStyles.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        height: 2,
                        width: activeTab == item.tab ? 116 : 0,
                        decoration: BoxDecoration(
                          color: _predictionPrimary,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LiquidityOverview extends StatelessWidget {
  const _LiquidityOverview({required this.snapshot});

  final PredictionMarketMakerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary08,
                  borderRadius: AppRadii.inputRadius,
                ),
                child: const Icon(
                  Icons.water_drop_outlined,
                  color: _predictionPrimary,
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Liquidity Provider',
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      'Thu nhap tu phi giao dich',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  label: 'Total Provided',
                  value: _formatMoney(snapshot.totalLiquidity),
                ),
              ),
              Expanded(
                child: _OverviewMetric(
                  label: 'Avg APR',
                  value: '${snapshot.averageApr.toStringAsFixed(1)}%',
                  valueColor: AppColors.buy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddLiquidityForm extends StatelessWidget {
  const _AddLiquidityForm({
    required this.eventController,
    required this.amountController,
    required this.minDepthController,
    required this.spreadBps,
    required this.onSpreadChanged,
  });

  final TextEditingController eventController;
  final TextEditingController amountController;
  final TextEditingController minDepthController;
  final int spreadBps;
  final ValueChanged<int> onSpreadChanged;

  @override
  Widget build(BuildContext context) {
    final hasAmount = amountController.text.trim().isNotEmpty;
    final amount = double.tryParse(amountController.text) ?? 0;

    return VitPageSection(
      label: 'Them thanh khoan',
      accentColor: _predictionPrimary,
      children: [
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _MarketInput(label: 'Select Event', controller: eventController),
              const SizedBox(height: 16),
              _MarketInput(
                label: 'Liquidity Amount (USD)',
                controller: amountController,
                fieldKey: PredictionMarketMakerPage.amountFieldKey,
                hintText: '0.00',
                numeric: true,
                prefix: const Icon(
                  Icons.attach_money_rounded,
                  color: AppColors.text3,
                  size: 19,
                ),
              ),
              const SizedBox(height: 16),
              _SpreadSelector(value: spreadBps, onChanged: onSpreadChanged),
              const SizedBox(height: 16),
              _MarketInput(
                label: 'Minimum Depth (USD)',
                controller: minDepthController,
                numeric: true,
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Thanh khoan toi thieu moi ben',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              if (hasAmount) ...[
                const SizedBox(height: 14),
                _EstimatedReturns(amount: amount),
              ],
              const SizedBox(height: 16),
              _AddLiquidityButton(enabled: hasAmount),
            ],
          ),
        ),
      ],
    );
  }
}

class _MarketInput extends StatelessWidget {
  const _MarketInput({
    required this.label,
    required this.controller,
    this.fieldKey,
    this.hintText = '',
    this.numeric = false,
    this.prefix,
  });

  final String label;
  final TextEditingController controller;
  final Key? fieldKey;
  final String hintText;
  final bool numeric;
  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 42,
          padding: EdgeInsets.only(left: prefix == null ? 16 : 10, right: 16),
          decoration: BoxDecoration(
            color: AppColors.bg,
            border: Border.all(color: AppColors.border),
            borderRadius: AppRadii.lgRadius,
          ),
          child: Row(
            children: [
              if (prefix != null) ...[prefix!, const SizedBox(width: 8)],
              Expanded(
                child: TextField(
                  key: fieldKey,
                  controller: controller,
                  keyboardType: numeric
                      ? const TextInputType.numberWithOptions(decimal: true)
                      : TextInputType.text,
                  inputFormatters: numeric
                      ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
                      : null,
                  cursorColor: _predictionPrimary,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 14,
                    fontWeight: AppTextStyles.medium,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: hintText,
                    hintStyle: AppTextStyles.body.copyWith(
                      color: AppColors.text3,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SpreadSelector extends StatelessWidget {
  const _SpreadSelector({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Spread (basis points)',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (final bps in [25, 50, 100, 200]) ...[
              Expanded(
                child: _SpreadButton(
                  key: _spreadKey(bps),
                  value: bps,
                  selected: value == bps,
                  onTap: () => onChanged(bps),
                ),
              ),
              if (bps != 200) const SizedBox(width: 8),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Hieu gia bid/ask: ${(value / 100).toStringAsFixed(2)}%',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _SpreadButton extends StatelessWidget {
  const _SpreadButton({
    super.key,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final int value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Material(
        color: selected ? _predictionPrimary : AppColors.bg,
        borderRadius: AppRadii.cardRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.cardRadius,
          child: Center(
            child: Text(
              '$value',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EstimatedReturns extends StatelessWidget {
  const _EstimatedReturns({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: _OverviewMetric(
              label: 'Daily Fees',
              value: _formatMoney(amount * .0012),
              valueColor: AppColors.buy,
              small: true,
            ),
          ),
          Expanded(
            child: _OverviewMetric(
              label: 'Est. APR',
              value: '~22.5%',
              valueColor: AppColors.buy,
              small: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddLiquidityButton extends StatelessWidget {
  const _AddLiquidityButton({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.inputHeight,
      width: double.infinity,
      child: Material(
        color: _predictionPrimary.withValues(alpha: enabled ? 1 : .66),
        borderRadius: AppRadii.inputRadius,
        child: InkWell(
          key: PredictionMarketMakerPage.addLiquidityKey,
          onTap: enabled ? () {} : null,
          borderRadius: AppRadii.inputRadius,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_rounded,
                color: AppColors.onAccent.withValues(alpha: enabled ? 1 : .5),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Them thanh khoan',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.onAccent.withValues(
                    alpha: enabled ? 1 : .55,
                  ),
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LiquidityWarning extends StatelessWidget {
  const _LiquidityWarning();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: 15,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Cung cap thanh khoan co rui ro impermanent loss. APR khong co dinh va phu thuoc vao volume giao dich. Khong dam bao loi nhuan.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PositionsTab extends StatelessWidget {
  const _PositionsTab({required this.snapshot});

  final PredictionMarketMakerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Cac vi the',
      accentColor: _predictionPrimary,
      children: [
        _PositionSummary(snapshot: snapshot),
        for (final position in snapshot.positions) _PositionCard(position),
      ],
    );
  }
}

class _PositionSummary extends StatelessWidget {
  const _PositionSummary({required this.snapshot});

  final PredictionMarketMakerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  label: 'Current Value',
                  value: _formatMoney(snapshot.totalValue),
                ),
              ),
              Expanded(
                child: _OverviewMetric(
                  label: 'Total Fees',
                  value: _formatMoney(snapshot.totalFees),
                  valueColor: AppColors.buy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  label: 'IL',
                  value: _formatMoney(snapshot.totalImpermanentLoss),
                  valueColor: AppColors.sell,
                  small: true,
                ),
              ),
              Expanded(
                child: _OverviewMetric(
                  label: 'Net Return',
                  value:
                      '${snapshot.netReturn >= 0 ? '+' : ''}${_formatMoney(snapshot.netReturn)}',
                  valueColor: snapshot.netReturn >= 0
                      ? AppColors.buy
                      : AppColors.sell,
                  small: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard(this.position);

  final PredictionLiquidityPositionDraft position;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  position.eventName,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '${position.apr.toStringAsFixed(1)}% APR',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  label: 'Provided',
                  value: _formatMoney(position.liquidityProvided),
                  small: true,
                ),
              ),
              Expanded(
                child: _OverviewMetric(
                  label: 'Fees Earned',
                  value: '+${_formatMoney(position.feesEarned)}',
                  valueColor: AppColors.buy,
                  small: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EarningsTab extends StatelessWidget {
  const _EarningsTab({required this.snapshot});

  final PredictionMarketMakerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Phan tich thu nhap',
      accentColor: _predictionPrimary,
      children: [
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fee Earnings Over Time',
                style: AppTextStyles.body.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 160,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final point in snapshot.earningsHistory)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _FeeBar(point: point),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _AnalysisRow(
                label: 'Total Fees',
                value: _formatMoney(snapshot.totalFees),
                valueColor: AppColors.buy,
                icon: Icons.local_activity_rounded,
              ),
              _AnalysisRow(
                label: 'Avg Daily Fees',
                value: _formatMoney(snapshot.totalFees / 60),
                icon: Icons.bar_chart_rounded,
              ),
              _AnalysisRow(
                label: 'Fee Yield (annualized)',
                value: '${snapshot.averageApr.toStringAsFixed(1)}%',
                icon: Icons.percent_rounded,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeeBar extends StatelessWidget {
  const _FeeBar({required this.point});

  final PredictionEarningsPointDraft point;

  @override
  Widget build(BuildContext context) {
    final height = 36 + point.fees;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: height,
          decoration: const BoxDecoration(
            color: _predictionPrimary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          point.date,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.small = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: (small ? AppTextStyles.caption : AppTextStyles.baseMedium)
              .copyWith(
                color: valueColor,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
        ),
      ],
    );
  }
}

class _AnalysisRow extends StatelessWidget {
  const _AnalysisRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.text3, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

Key _spreadKey(int value) {
  return switch (value) {
    25 => PredictionMarketMakerPage.spread25Key,
    50 => PredictionMarketMakerPage.spread50Key,
    100 => PredictionMarketMakerPage.spread100Key,
    200 => PredictionMarketMakerPage.spread200Key,
    _ => Key('sc037_spread_$value'),
  };
}

String _formatMoney(double value) => '\$${value.toStringAsFixed(2)}';

String _formatInput(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toString();
}
