import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';

enum _DcaBuilderTab { strategies, history, create }

class LaunchpadDcaBuilderPage extends ConsumerStatefulWidget {
  const LaunchpadDcaBuilderPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc316_launchpad_dca_content');
  static const tabsKey = Key('sc316_launchpad_dca_tabs');
  static const summaryKey = Key('sc316_launchpad_dca_summary');
  static const strategiesKey = Key('sc316_launchpad_dca_strategies');
  static const historyKey = Key('sc316_launchpad_dca_history');
  static const chartKey = Key('sc316_launchpad_dca_chart');
  static const createKey = Key('sc316_launchpad_dca_create');
  static const headerCreateKey = Key('sc316_launchpad_dca_header_create');
  static const tokenFieldKey = Key('sc316_launchpad_dca_token_field');
  static const amountFieldKey = Key('sc316_launchpad_dca_amount_field');
  static const budgetFieldKey = Key('sc316_launchpad_dca_budget_field');
  static const startDateFieldKey = Key('sc316_launchpad_dca_start_field');
  static const previewKey = Key('sc316_launchpad_dca_preview');
  static const ctaKey = Key('sc316_launchpad_dca_cta');

  static Key strategyKey(String id) => Key('sc316_launchpad_dca_strategy_$id');
  static Key frequencyKey(LaunchpadDcaFrequency frequency) =>
      Key('sc316_launchpad_dca_frequency_${frequency.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadDcaBuilderPage> createState() =>
      _LaunchpadDcaBuilderPageState();
}

class _LaunchpadDcaBuilderPageState
    extends ConsumerState<LaunchpadDcaBuilderPage> {
  late final TextEditingController _tokenController;
  late final TextEditingController _amountController;
  late final TextEditingController _budgetController;
  late final TextEditingController _startDateController;
  var _activeTab = _DcaBuilderTab.strategies;
  var _frequency = LaunchpadDcaFrequency.weekly;
  String? _submissionMessage;

  @override
  void initState() {
    super.initState();
    _tokenController = TextEditingController(text: 'ARB');
    _amountController = TextEditingController();
    _budgetController = TextEditingController();
    _startDateController = TextEditingController();
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _amountController.dispose();
    _budgetController.dispose();
    _startDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadControllerProvider).getDcaBuilder();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navInset = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final showCta =
        _activeTab == _DcaBuilderTab.create &&
        _amountController.text.trim().isNotEmpty &&
        _budgetController.text.trim().isNotEmpty &&
        _startDateController.text.trim().isNotEmpty;
    final ctaInset = showCta ? 118.0 : 0.0;
    final bottomInset = navInset + safeBottom + AppSpacing.x6 + ctaInset;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-316 LaunchpadDcaBuilderPage',
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
                  trailing: _HeaderCreateButton(
                    onTap: () => setState(() {
                      _activeTab = _DcaBuilderTab.create;
                    }),
                  ),
                ),
                _Tabs(
                  activeTab: _activeTab,
                  onChanged: (tab) => setState(() => _activeTab = tab),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: LaunchpadDcaBuilderPage.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.defaultPadding,
                      customGap: AppSpacing.x4,
                      children: [
                        if (_activeTab == _DcaBuilderTab.strategies) ...[
                          _SummaryCard(snapshot: snapshot),
                          _StrategiesSection(strategies: snapshot.strategies),
                        ] else if (_activeTab == _DcaBuilderTab.history) ...[
                          _HistorySection(executions: snapshot.executions),
                        ] else ...[
                          _CreateDcaSection(
                            tokenController: _tokenController,
                            amountController: _amountController,
                            budgetController: _budgetController,
                            startDateController: _startDateController,
                            frequency: _frequency,
                            submissionMessage: _submissionMessage,
                            onFrequencyChanged: (frequency) =>
                                setState(() => _frequency = frequency),
                            onInputChanged: () => setState(() {
                              _submissionMessage = null;
                            }),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (showCta)
              Positioned(
                left: 0,
                right: 0,
                bottom: navInset + safeBottom,
                child: VitStickyFooter(
                  backgroundColor: AppColors.surface.withValues(alpha: .94),
                  child: VitCtaButton(
                    key: LaunchpadDcaBuilderPage.ctaKey,
                    onPressed: _submitStrategy,
                    leading: const Icon(Icons.add_rounded),
                    child: const Text('Tao DCA Strategy'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _submitStrategy() {
    setState(() {
      _submissionMessage =
          'DCA strategy queued: ${_frequencyLabel(_frequency)} ${_amountController.text.trim()} USD vao ${_tokenController.text.trim()}';
    });
  }
}

class _HeaderCreateButton extends StatelessWidget {
  const _HeaderCreateButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.searchBg,
          border: Border.all(color: AppColors.border),
          borderRadius: AppRadii.smRadius,
        ),
        child: IconButton(
          key: LaunchpadDcaBuilderPage.headerCreateKey,
          onPressed: onTap,
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.add_rounded, color: AppColors.text1, size: 20),
        ),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.activeTab, required this.onChanged});

  final _DcaBuilderTab activeTab;
  final ValueChanged<_DcaBuilderTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadDcaBuilderPage.tabsKey,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
      child: VitTabBar(
        tabs: const [
          VitTabItem(key: 'strategies', label: 'Chien luoc'),
          VitTabItem(key: 'history', label: 'Lich su'),
          VitTabItem(key: 'create', label: 'Tao moi'),
        ],
        activeKey: activeTab.name,
        onChanged: (key) => onChanged(_DcaBuilderTab.values.byName(key)),
        variant: VitTabBarVariant.underline,
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.snapshot});

  final LaunchpadDcaBuilderSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadDcaBuilderPage.summaryKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            children: [
              _SummaryMetric(
                label: 'Total Invested',
                value: _formatMoney(snapshot.totalInvested),
                color: AppColors.text1,
                large: true,
              ),
              _SummaryMetric(
                label: 'Current Value',
                value: _formatMoney(snapshot.currentValue),
                color: AppColors.buy,
                large: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              _SummaryMetric(
                label: 'Active Strategies',
                value: '${snapshot.activeStrategyCount}',
                color: AppColors.text1,
              ),
              _SummaryMetric(
                label: 'Total Orders',
                value: '${snapshot.executedOrderCount}',
                color: AppColors.text1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.color,
    this.large = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            style: AppTextStyles.base.copyWith(
              color: color,
              fontSize: large ? 20 : 16,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StrategiesSection extends StatelessWidget {
  const _StrategiesSection({required this.strategies});

  final List<LaunchpadDcaStrategyDraft> strategies;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadDcaBuilderPage.strategiesKey,
      child: VitPageSection(
        label: 'Cac chien luoc',
        accentColor: AppColors.primary,
        children: [
          for (final strategy in strategies) _StrategyCard(strategy: strategy),
        ],
      ),
    );
  }
}

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({required this.strategy});

  final LaunchpadDcaStrategyDraft strategy;

  @override
  Widget build(BuildContext context) {
    final isActive = strategy.status == LaunchpadDcaStrategyStatus.active;
    return VitCard(
      key: LaunchpadDcaBuilderPage.strategyKey(strategy.id),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TrendIcon(accent: strategy.accent),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strategy.token,
                      style: AppTextStyles.base.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Wrap(
                      spacing: AppSpacing.x2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          _frequencyLabel(strategy.frequency),
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        _StatusPill(status: strategy.status),
                      ],
                    ),
                  ],
                ),
              ),
              _MiniIconButton(
                icon: isActive ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: isActive ? AppColors.text3 : AppColors.buy,
                onTap: () {},
              ),
              const SizedBox(width: AppSpacing.x2),
              _MiniIconButton(
                icon: Icons.settings_outlined,
                color: AppColors.text3,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          _StrategyMetricsGrid(strategy: strategy),
          const SizedBox(height: AppSpacing.x3),
          _PnlBand(strategy: strategy),
          const SizedBox(height: AppSpacing.x3),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.text3,
                size: 12,
              ),
              const SizedBox(width: AppSpacing.x1),
              Expanded(
                child: Text(
                  'Next: ${strategy.nextBuy}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                  ),
                ),
              ),
              Text(
                '${strategy.executedOrders} orders - \$${strategy.amount.toStringAsFixed(0)}/order',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendIcon extends StatelessWidget {
  const _TrendIcon({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: .12),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(Icons.trending_up_rounded, color: accent, size: 20),
    );
  }
}

class _MiniIconButton extends StatelessWidget {
  const _MiniIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: AppRadii.smRadius,
        ),
        child: IconButton(
          onPressed: onTap,
          padding: EdgeInsets.zero,
          icon: Icon(icon, color: color, size: 16),
        ),
      ),
    );
  }
}

class _StrategyMetricsGrid extends StatelessWidget {
  const _StrategyMetricsGrid({required this.strategy});

  final LaunchpadDcaStrategyDraft strategy;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: AppSpacing.x3,
      crossAxisSpacing: AppSpacing.x3,
      childAspectRatio: 3.7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        _MetricBlock(
          label: 'Invested',
          value: _formatMoney(strategy.totalInvested),
        ),
        _MetricBlock(
          label: 'Current Value',
          value: _formatMoney(strategy.currentValue),
          valueColor: strategy.pnl >= 0 ? AppColors.buy : AppColors.sell,
        ),
        _MetricBlock(
          label: 'Tokens',
          value:
              '${strategy.totalTokens.toStringAsFixed(2)} ${strategy.symbol}',
        ),
        _MetricBlock(
          label: 'Avg Price',
          value: _formatPrice(strategy.avgPrice),
        ),
      ],
    );
  }
}

class _MetricBlock extends StatelessWidget {
  const _MetricBlock({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _PnlBand extends StatelessWidget {
  const _PnlBand({required this.strategy});

  final LaunchpadDcaStrategyDraft strategy;

  @override
  Widget build(BuildContext context) {
    final color = strategy.pnl >= 0 ? AppColors.buy : AppColors.sell;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'P/L',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            '${strategy.pnl >= 0 ? '+' : ''}${strategy.pnlPercent.toStringAsFixed(2)}% (${strategy.pnl >= 0 ? r'$' : r'-$'}${strategy.pnl.abs().toStringAsFixed(2)})',
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final LaunchpadDcaStrategyStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      LaunchpadDcaStrategyStatus.active => AppColors.buy,
      LaunchpadDcaStrategyStatus.paused => AppColors.warn,
      LaunchpadDcaStrategyStatus.completed => AppColors.text3,
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Text(
          status.name.toUpperCase(),
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontSize: 8,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _HistorySection extends StatelessWidget {
  const _HistorySection({required this.executions});

  final List<LaunchpadDcaExecutionDraft> executions;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadDcaBuilderPage.historyKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitCard(
            key: LaunchpadDcaBuilderPage.chartKey,
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price & Tokens Purchased (ARB)',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                _ExecutionBars(executions: executions),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitPageSection(
            label: 'Lich su mua',
            accentColor: AppColors.buy,
            children: [
              for (final execution in executions)
                _ExecutionCard(execution: execution),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExecutionBars extends StatelessWidget {
  const _ExecutionBars({required this.executions});

  final List<LaunchpadDcaExecutionDraft> executions;

  @override
  Widget build(BuildContext context) {
    final maxTokens = executions.fold<double>(
      0,
      (max, execution) => execution.tokens > max ? execution.tokens : max,
    );
    return SizedBox(
      height: 170,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final execution in executions) ...[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    execution.tokens.toStringAsFixed(1),
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Flexible(
                    child: FractionallySizedBox(
                      heightFactor: maxTokens == 0
                          ? 0
                          : (execution.tokens / maxTokens).clamp(.2, 1),
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppRadii.sm),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    execution.date.split(' ').first,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
            if (execution != executions.last)
              const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _ExecutionCard extends StatelessWidget {
  const _ExecutionCard({required this.execution});

  final LaunchpadDcaExecutionDraft execution;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded, color: AppColors.buy),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$${execution.amount.toStringAsFixed(0)} -> ${execution.tokens.toStringAsFixed(2)} ARB',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  execution.date,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatPrice(execution.price),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                'Fee: \$${execution.fee.toStringAsFixed(1)}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreateDcaSection extends StatelessWidget {
  const _CreateDcaSection({
    required this.tokenController,
    required this.amountController,
    required this.budgetController,
    required this.startDateController,
    required this.frequency,
    required this.submissionMessage,
    required this.onFrequencyChanged,
    required this.onInputChanged,
  });

  final TextEditingController tokenController;
  final TextEditingController amountController;
  final TextEditingController budgetController;
  final TextEditingController startDateController;
  final LaunchpadDcaFrequency frequency;
  final String? submissionMessage;
  final ValueChanged<LaunchpadDcaFrequency> onFrequencyChanged;
  final VoidCallback onInputChanged;

  @override
  Widget build(BuildContext context) {
    final hasPreview =
        amountController.text.trim().isNotEmpty &&
        budgetController.text.trim().isNotEmpty;
    return Container(
      key: LaunchpadDcaBuilderPage.createKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitPageSection(
            label: 'Token',
            accentColor: AppColors.primary,
            children: [
              VitCard(
                padding: const EdgeInsets.all(AppSpacing.x4),
                child: _LabeledField(
                  fieldKey: LaunchpadDcaBuilderPage.tokenFieldKey,
                  label: 'Chon token',
                  controller: tokenController,
                  hintText: 'ARB, OP, MATIC...',
                  onChanged: onInputChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitPageSection(
            label: 'Tan suat mua',
            accentColor: AppColors.primary,
            children: [
              GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.x3,
                crossAxisSpacing: AppSpacing.x3,
                childAspectRatio: 1.65,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  for (final option in LaunchpadDcaFrequency.values)
                    _FrequencyChoice(
                      frequency: option,
                      active: option == frequency,
                      onTap: () => onFrequencyChanged(option),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitPageSection(
            label: 'So tien',
            accentColor: AppColors.primary,
            children: [
              VitCard(
                padding: const EdgeInsets.all(AppSpacing.x4),
                child: Column(
                  children: [
                    _LabeledField(
                      fieldKey: LaunchpadDcaBuilderPage.amountFieldKey,
                      label: 'So tien moi lan (USD)',
                      controller: amountController,
                      hintText: '100',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      prefixIcon: Icons.attach_money_rounded,
                      onChanged: onInputChanged,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    _LabeledField(
                      fieldKey: LaunchpadDcaBuilderPage.budgetFieldKey,
                      label: 'Tong ngan sach (USD)',
                      controller: budgetController,
                      hintText: '1000',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      prefixIcon: Icons.attach_money_rounded,
                      onChanged: onInputChanged,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    _LabeledField(
                      fieldKey: LaunchpadDcaBuilderPage.startDateFieldKey,
                      label: 'Ngay bat dau',
                      controller: startDateController,
                      hintText: '2026-05-25',
                      prefixIcon: Icons.calendar_today_outlined,
                      onChanged: onInputChanged,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (hasPreview) ...[
            const SizedBox(height: AppSpacing.x4),
            _StrategyPreview(
              token: tokenController.text.trim(),
              frequency: frequency,
              amount: amountController.text.trim(),
              totalBudget: budgetController.text.trim(),
            ),
          ],
          if (submissionMessage != null) ...[
            const SizedBox(height: AppSpacing.x4),
            VitCard(
              padding: const EdgeInsets.all(AppSpacing.x3),
              borderColor: AppColors.buy20,
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.buy,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      submissionMessage!,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FrequencyChoice extends StatelessWidget {
  const _FrequencyChoice({
    required this.frequency,
    required this.active,
    required this.onTap,
  });

  final LaunchpadDcaFrequency frequency;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: LaunchpadDcaBuilderPage.frequencyKey(frequency),
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.x4),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary.withValues(alpha: .10)
              : AppColors.surface,
          border: Border.all(
            color: active ? AppColors.primary : AppColors.cardBorder,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _frequencyIcon(frequency),
              color: active ? AppColors.primary : AppColors.text3,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              _frequencyLabel(frequency),
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: active ? AppColors.primary : AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.fieldKey,
    required this.label,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
  });

  final Key fieldKey;
  final String label;
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onChanged;
  final TextInputType keyboardType;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x2),
        TextField(
          key: fieldKey,
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: keyboardType == TextInputType.text
              ? const []
              : [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
          onChanged: (_) => onChanged(),
          style: AppTextStyles.base.copyWith(color: AppColors.text1),
          decoration: InputDecoration(
            prefixIcon: prefixIcon == null
                ? null
                : Icon(prefixIcon, color: AppColors.text3, size: 18),
            hintText: hintText,
            hintStyle: AppTextStyles.base.copyWith(color: AppColors.text3),
            isDense: true,
            filled: true,
            fillColor: AppColors.bg,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x4,
              vertical: AppSpacing.x3,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadii.inputRadius,
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadii.inputRadius,
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class _StrategyPreview extends StatelessWidget {
  const _StrategyPreview({
    required this.token,
    required this.frequency,
    required this.amount,
    required this.totalBudget,
  });

  final String token;
  final LaunchpadDcaFrequency frequency;
  final String amount;
  final String totalBudget;

  @override
  Widget build(BuildContext context) {
    final perOrder = double.tryParse(amount) ?? 0;
    final budget = double.tryParse(totalBudget) ?? 0;
    final estimatedOrders = perOrder == 0 ? 0 : (budget / perOrder).floor();
    return Container(
      key: LaunchpadDcaBuilderPage.previewKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.buy10,
        border: Border.all(color: AppColors.buy20),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Xem truoc chien luoc',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _PreviewMetric(label: 'Token', value: token),
              _PreviewMetric(
                label: 'Frequency',
                value: _frequencyLabel(frequency),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _PreviewMetric(label: 'Per Order', value: '\$$amount'),
              _PreviewMetric(label: 'Est. Orders', value: '$estimatedOrders'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewMetric extends StatelessWidget {
  const _PreviewMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatMoney(double value) => '\$${value.toStringAsFixed(2)}';

String _formatPrice(double value) => '\$${value.toStringAsFixed(2)}';

String _frequencyLabel(LaunchpadDcaFrequency frequency) {
  return switch (frequency) {
    LaunchpadDcaFrequency.daily => 'Hang ngay',
    LaunchpadDcaFrequency.weekly => 'Hang tuan',
    LaunchpadDcaFrequency.biweekly => '2 tuan/lan',
    LaunchpadDcaFrequency.monthly => 'Hang thang',
  };
}

IconData _frequencyIcon(LaunchpadDcaFrequency frequency) {
  return switch (frequency) {
    LaunchpadDcaFrequency.daily => Icons.calendar_view_day_outlined,
    LaunchpadDcaFrequency.weekly => Icons.calendar_view_week_outlined,
    LaunchpadDcaFrequency.biweekly => Icons.date_range_outlined,
    LaunchpadDcaFrequency.monthly => Icons.calendar_month_outlined,
  };
}
