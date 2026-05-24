import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
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

enum _DcaTab { plans, history }

class DCAPage extends ConsumerStatefulWidget {
  const DCAPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc169_dca_content');
  static const createPlanKey = Key('sc169_create_plan');
  static const overviewCreateKey = Key('sc169_overview_create');
  static const pauseAllKey = Key('sc169_pause_all');
  static const chartKey = Key('sc169_chart');
  static const historyKey = Key('sc169_history');
  static const createSheetKey = Key('sc169_create_sheet');

  static Key toolKey(String route) => Key('sc169_tool_$route');
  static Key tabKey(String id) => Key('sc169_tab_$id');
  static Key planKey(String id) => Key('sc169_plan_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DCAPage> createState() => _DCAPageState();
}

class _DCAPageState extends ConsumerState<DCAPage> {
  _DcaTab _activeTab = _DcaTab.plans;
  bool _createSheetOpen = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(dcaRepositoryProvider).getDashboard();
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
        child: Column(
          children: [
            VitHeader(
              title: 'Mua tự động (DCA)',
              subtitle: 'Tự động mua crypto định kỳ',
              showBack: true,
              onBack: _close,
            ),
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
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.trade);
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

class _NextPurchaseRow extends StatelessWidget {
  const _NextPurchaseRow({required this.overview});

  final DcaOverview overview;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      ),
      child: Row(
        children: [
          Container(
            width: AppSpacing.x6,
            height: AppSpacing.x6,
            decoration: BoxDecoration(
              color: AppColors.primary12,
              borderRadius: AppRadii.mdRadius,
              border: Border.all(color: AppColors.primary20),
            ),
            child: const Icon(
              Icons.schedule_rounded,
              color: AppColors.primary,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lần mua tiếp',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.portfolioTextMuted,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  '${overview.nextRelativeTime} · ${_formatCompactVnd(overview.nextAmountVnd)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          VitStatusPill(
            label: '${overview.activePlans}',
            icon: Icons.play_arrow_rounded,
            status: VitStatusPillStatus.success,
            size: VitStatusPillSize.md,
          ),
        ],
      ),
    );
  }
}

class _OverviewAction extends StatelessWidget {
  const _OverviewAction({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x3,
      ),
      child: SizedBox(
        height: AppSpacing.ctaHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: AppSpacing.iconLg),
            const SizedBox(height: AppSpacing.x2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
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

class _AdvancedTools extends StatelessWidget {
  const _AdvancedTools({required this.tools, required this.onOpen});

  final List<DcaTool> tools;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Công cụ nâng cao',
          style: AppTextStyles.body.copyWith(
            fontWeight: AppTextStyles.bold,
            color: AppColors.text1,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Row(
          children: [
            Expanded(
              child: _ToolCard(
                tool: tools[0],
                onTap: () => onOpen(tools[0].route),
              ),
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: _ToolCard(
                tool: tools[1],
                onTap: () => onOpen(tools[1].route),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        Row(
          children: [
            Expanded(
              child: _ToolCard(
                tool: tools[2],
                onTap: () => onOpen(tools[2].route),
              ),
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: _ToolCard(
                tool: tools[3],
                onTap: () => onOpen(tools[3].route),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({required this.tool, required this.onTap});

  final DcaTool tool;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _toolAccentColor(tool.accent);
    return VitCard(
      key: DCAPage.toolKey(tool.route),
      radius: VitCardRadius.md,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: SizedBox(
        height: 98,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .13),
                borderRadius: AppRadii.mdRadius,
                border: Border.all(color: color.withValues(alpha: .2)),
              ),
              child: Icon(_toolIcon(tool.icon), color: color, size: 22),
            ),
            const Spacer(),
            Text(
              tool.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
            const SizedBox(height: AppSpacing.x3),
            Text(
              tool.subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DcaTabs extends StatelessWidget {
  const _DcaTabs({
    required this.active,
    required this.planCount,
    required this.onChanged,
  });

  final _DcaTab active;
  final int planCount;
  final ValueChanged<_DcaTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x2),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: VitTabBar(
        variant: VitTabBarVariant.segment,
        activeKey: active.name,
        onChanged: (key) => onChanged(_DcaTab.values.byName(key)),
        tabs: [
          VitTabItem(
            key: _DcaTab.plans.name,
            label: 'Kế hoạch ($planCount)',
            icon: Icons.trending_up_rounded,
          ),
          VitTabItem(
            key: _DcaTab.history.name,
            label: 'Lịch sử',
            icon: Icons.bar_chart_rounded,
          ),
        ],
      ),
    );
  }
}

class _PlansList extends StatelessWidget {
  const _PlansList({super.key, required this.plans, required this.onPause});

  final List<DcaPlan> plans;
  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < plans.length; index++) ...[
          if (index > 0) const SizedBox(height: AppSpacing.x5),
          _DcaPlanCard(plan: plans[index], onPause: onPause),
        ],
      ],
    );
  }
}

class _DcaPlanCard extends StatelessWidget {
  const _DcaPlanCard({required this.plan, required this.onPause});

  final DcaPlan plan;
  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    final isProfit = plan.profitLossPercent >= 0;
    final status = _statusPillStatus(plan.status);
    return VitCard(
      key: DCAPage.planKey(plan.id),
      clip: true,
      padding: EdgeInsets.zero,
      borderColor: plan.status == DcaPlanStatus.active
          ? AppColors.buy20
          : AppColors.cardBorder,
      child: Column(
        children: [
          Container(
            height: 3,
            color: plan.status == DcaPlanStatus.active
                ? AppColors.buy
                : AppColors.warn,
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.x5),
            child: Column(
              children: [
                Row(
                  children: [
                    _CoinAvatar(symbol: plan.coinSymbol),
                    const SizedBox(width: AppSpacing.x4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  plan.coinSymbol,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.base.copyWith(
                                    color: AppColors.text1,
                                    fontWeight: AppTextStyles.bold,
                                    height: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.x3),
                              VitStatusPill(
                                label: _frequencyLabel(plan.frequency),
                                status: VitStatusPillStatus.neutral,
                                size: VitStatusPillSize.sm,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.x2),
                          Text(
                            plan.coinName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    VitStatusPill(
                      label: _statusLabel(plan.status),
                      icon: Icons.sync_rounded,
                      status: status,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x4),
                VitCard(
                  variant: VitCardVariant.inner,
                  radius: VitCardRadius.md,
                  padding: const EdgeInsets.all(AppSpacing.x4),
                  child: Row(
                    children: [
                      Expanded(
                        child: _PlanMetric(
                          label: 'Mỗi lần mua',
                          value: _formatCompactVnd(plan.amountPerPurchaseVnd),
                          unit: 'VND',
                        ),
                      ),
                      Expanded(
                        child: _PlanMetric(
                          label: 'Đang nắm giữ',
                          value: plan.currentHoldings.toStringAsFixed(
                            plan.currentHoldings >= 1 ? 4 : 4,
                          ),
                          unit: plan.coinSymbol,
                        ),
                      ),
                      Expanded(
                        child: _PlanMetric(
                          label: 'Đã đầu tư',
                          value: _formatCompactVnd(plan.totalInvestedVnd),
                          unit: 'VND',
                        ),
                      ),
                      Expanded(
                        child: _PlanMetric(
                          label: 'Lãi / lỗ',
                          value:
                              '${isProfit ? '+' : ''}${plan.profitLossPercent.toStringAsFixed(2)}%',
                          unit: '',
                          color: isProfit ? AppColors.buy : AppColors.sell,
                          icon: isProfit
                              ? Icons.trending_up_rounded
                              : Icons.trending_down_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                VitCard(
                  variant: VitCardVariant.inner,
                  radius: VitCardRadius.sm,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x4,
                    vertical: AppSpacing.x3,
                  ),
                  borderColor: AppColors.primary20,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        color: AppColors.primary,
                        size: AppSpacing.iconMd,
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: Text(
                          'Lần mua tiếp theo',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            fontWeight: AppTextStyles.medium,
                          ),
                        ),
                      ),
                      Text(
                        plan.nextExecutionLabel,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                Row(
                  children: [
                    Expanded(
                      child: VitCtaButton(
                        onPressed: onPause,
                        variant: VitCtaButtonVariant.secondary,
                        height: 44,
                        leading: const Icon(Icons.pause_rounded),
                        child: const Text('Tạm dừng'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    _PlanIconButton(
                      icon: Icons.edit_rounded,
                      color: AppColors.text2,
                      onTap: onPause,
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    _PlanIconButton(
                      icon: Icons.delete_outline_rounded,
                      color: AppColors.sell,
                      onTap: onPause,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CoinAvatar extends StatelessWidget {
  const _CoinAvatar({required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context) {
    final color = switch (symbol) {
      'BTC' => AppColors.warn,
      'ETH' => AppColors.text2,
      'SOL' => AppColors.accent,
      _ => AppColors.primary,
    };
    final icon = switch (symbol) {
      'BTC' => Icons.currency_bitcoin_rounded,
      'ETH' => Icons.diamond_outlined,
      'SOL' => Icons.blur_on_rounded,
      _ => Icons.token_rounded,
    };
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: .24)),
      ),
      child: Icon(icon, color: color, size: 27),
    );
  }
}

class _PlanMetric extends StatelessWidget {
  const _PlanMetric({
    required this.label,
    required this.value,
    required this.unit,
    this.color = AppColors.text1,
    this.icon,
  });

  final String label;
  final String value;
  final String unit;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x1),
            ],
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                  height: 1,
                ),
              ),
            ),
            if (unit.isNotEmpty) ...[
              const SizedBox(width: AppSpacing.x1),
              Text(
                unit,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: 1,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _PlanIconButton extends StatelessWidget {
  const _PlanIconButton({
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
      width: AppSpacing.ctaHeight,
      height: 44,
      child: VitCard(
        variant: VitCardVariant.inner,
        radius: VitCardRadius.sm,
        onTap: onTap,
        child: Icon(icon, color: color, size: AppSpacing.iconMd),
      ),
    );
  }
}

class _HistoryPanel extends StatelessWidget {
  const _HistoryPanel({super.key, required this.snapshot});

  final DcaDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                color: AppColors.primary,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Lịch sử danh mục',
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const VitStatusPill(
                label: '90 ngày',
                status: VitStatusPillStatus.info,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          SizedBox(
            height: 220,
            child: CustomPaint(
              painter: _HistoryChartPainter(
                values: snapshot.history,
                lineColor: AppColors.buy,
                investedColor: AppColors.primary,
                gridColor: AppColors.divider,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _HistoryStat(
                  label: 'Giá trị',
                  value: _formatCompactVnd(snapshot.overview.currentValueVnd),
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _HistoryStat(
                  label: 'Đã đầu tư',
                  value: _formatCompactVnd(snapshot.overview.totalInvestedVnd),
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryStat extends StatelessWidget {
  const _HistoryStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitMetricCard(label: label, value: value, accentColor: color);
  }
}

class _CreatePlanSheet extends StatelessWidget {
  const _CreatePlanSheet({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.black54,
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onClose,
                child: const SizedBox.expand(),
              ),
            ),
            VitCard(
              key: DCAPage.createSheetKey,
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.contentPad),
              margin: const EdgeInsets.fromLTRB(
                AppSpacing.contentPad,
                0,
                AppSpacing.contentPad,
                AppSpacing.contentPad,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: AppColors.primary12,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_chart_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tạo kế hoạch DCA',
                              style: AppTextStyles.base.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            Text(
                              'Chọn coin, số tiền và lịch mua trong bước sau.',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x5),
                  VitCtaButton(
                    onPressed: onClose,
                    leading: const Icon(Icons.check_rounded),
                    child: const Text('Đã hiểu'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  const _SparklinePainter({
    required this.values,
    required this.lineColor,
    required this.fillColor,
  });

  final List<double> values;
  final Color lineColor;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final path = _buildLinePath(values, size);
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(fillPath, Paint()..color = fillColor);
    canvas.drawPath(
      path,
      Paint()
        ..color = lineColor
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawCircle(
      Offset(size.width, _yForValue(values.last, values, size)),
      4,
      Paint()..color = lineColor,
    );
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor;
  }
}

class _HistoryChartPainter extends CustomPainter {
  const _HistoryChartPainter({
    required this.values,
    required this.lineColor,
    required this.investedColor,
    required this.gridColor,
  });

  final List<DcaHistoryPoint> values;
  final Color lineColor;
  final Color investedColor;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (var i = 1; i <= 3; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final portfolioValues = values
        .map((point) => point.portfolioValueM)
        .toList();
    final investedValues = values.map((point) => point.investedM).toList();
    final maxValue = portfolioValues
        .followedBy(investedValues)
        .reduce((a, b) => a > b ? a : b);
    final minValue = investedValues.reduce((a, b) => a < b ? a : b);

    final portfolioPath = _buildLinePath(
      portfolioValues,
      size,
      minValue: minValue,
      maxValue: maxValue,
    );
    final investedPath = _buildLinePath(
      investedValues,
      size,
      minValue: minValue,
      maxValue: maxValue,
    );

    canvas.drawPath(
      investedPath,
      Paint()
        ..color = investedColor.withValues(alpha: .65)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      portfolioPath,
      Paint()
        ..color = lineColor
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _HistoryChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.investedColor != investedColor ||
        oldDelegate.gridColor != gridColor;
  }
}

Path _buildLinePath(
  List<double> values,
  Size size, {
  double? minValue,
  double? maxValue,
}) {
  final min = minValue ?? values.reduce((a, b) => a < b ? a : b);
  final max = maxValue ?? values.reduce((a, b) => a > b ? a : b);
  final range = (max - min).abs() < 0.01 ? 1 : max - min;
  final path = Path();
  for (var index = 0; index < values.length; index++) {
    final x = index / (values.length - 1) * size.width;
    final y = size.height - ((values[index] - min) / range * size.height);
    if (index == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  return path;
}

double _yForValue(double value, List<double> values, Size size) {
  final min = values.reduce((a, b) => a < b ? a : b);
  final max = values.reduce((a, b) => a > b ? a : b);
  final range = (max - min).abs() < 0.01 ? 1 : max - min;
  return size.height - ((value - min) / range * size.height);
}

Color _toolAccentColor(DcaToolAccent accent) {
  return switch (accent) {
    DcaToolAccent.purple => AppColors.accent,
    DcaToolAccent.primary => AppModuleAccents.trade,
    DcaToolAccent.success => AppColors.buy,
    DcaToolAccent.warning => AppColors.warn,
  };
}

IconData _toolIcon(DcaToolIcon icon) {
  return switch (icon) {
    DcaToolIcon.target => Icons.track_changes_rounded,
    DcaToolIcon.activity => Icons.show_chart_rounded,
    DcaToolIcon.sliders => Icons.tune_rounded,
    DcaToolIcon.clock => Icons.schedule_rounded,
  };
}

String _frequencyLabel(DcaFrequency frequency) {
  return switch (frequency) {
    DcaFrequency.daily => 'Hàng ngày',
    DcaFrequency.weekly => 'Hàng tuần',
    DcaFrequency.monthly => 'Hàng tháng',
  };
}

String _statusLabel(DcaPlanStatus status) {
  return switch (status) {
    DcaPlanStatus.active => 'Đang chạy',
    DcaPlanStatus.paused => 'Tạm dừng',
    DcaPlanStatus.error => 'Lỗi',
  };
}

VitStatusPillStatus _statusPillStatus(DcaPlanStatus status) {
  return switch (status) {
    DcaPlanStatus.active => VitStatusPillStatus.success,
    DcaPlanStatus.paused => VitStatusPillStatus.warning,
    DcaPlanStatus.error => VitStatusPillStatus.error,
  };
}

String _formatFullVnd(int amount) {
  final raw = amount.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final fromEnd = raw.length - i;
    buffer.write(raw[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) {
      buffer.write('.');
    }
  }
  return buffer.toString();
}

String _formatCompactVnd(int amount) {
  if (amount >= 1000000000) {
    return '${(amount / 1000000000).toStringAsFixed(2)}B';
  }
  if (amount >= 1000000) {
    return '${(amount / 1000000).toStringAsFixed(2)}M';
  }
  if (amount >= 1000) {
    return '${(amount / 1000).toStringAsFixed(0)}K';
  }
  return _formatFullVnd(amount);
}

String _formatPercent(double percent) {
  return percent.toStringAsFixed(1).replaceAll('.', ',');
}
