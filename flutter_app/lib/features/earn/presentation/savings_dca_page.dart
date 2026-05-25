import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../data/earn_repository.dart';

TextStyle get _captionBold =>
    AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.bold);
TextStyle get _microBold =>
    AppTextStyles.micro.copyWith(fontWeight: AppTextStyles.bold);

class SavingsDCAPage extends ConsumerStatefulWidget {
  const SavingsDCAPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc346_summary');
  static const plansListKey = Key('sc346_plans_list');
  static const historyListKey = Key('sc346_history_list');
  static const createPlanKey = Key('sc346_create_plan');
  static const createSheetKey = Key('sc346_create_sheet');

  static Key tabKey(String tab) => Key('sc346_tab_$tab');
  static Key planKey(String id) => Key('sc346_plan_$id');
  static Key executionKey(String id) => Key('sc346_execution_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsDCAPage> createState() => _SavingsDCAPageState();
}

class _SavingsDCAPageState extends ConsumerState<SavingsDCAPage> {
  String? _tab;
  final Set<String> _locallyPaused = {};

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(savingsDcaRepositoryProvider).getDca();
    final activeTab = _tab ?? snapshot.defaultTab;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-346 SavingsDCAPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _DcaSummaryCard(
                      snapshot: snapshot,
                      onCreate: () => _openCreateSheet(snapshot),
                      onPlans: () => setState(() => _tab = 'plans'),
                      onHistory: () => setState(() => _tab = 'history'),
                    ),
                    _InfoBanner(text: snapshot.infoText),
                    _DcaTabs(
                      tabs: snapshot.tabs,
                      active: activeTab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _tab = tab);
                      },
                    ),
                    if (activeTab == 'plans')
                      _PlansList(
                        plans: snapshot.plans,
                        locallyPaused: _locallyPaused,
                        onToggle: _togglePlan,
                      )
                    else
                      _HistoryList(executions: snapshot.executions),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _togglePlan(SavingsDcaPlanDraft plan) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_locallyPaused.contains(plan.id)) {
        _locallyPaused.remove(plan.id);
      } else {
        _locallyPaused.add(plan.id);
      }
    });
  }

  Future<void> _openCreateSheet(SavingsDcaSnapshot snapshot) async {
    HapticFeedback.selectionClick();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CreatePlanSheet(snapshot: snapshot),
    );
  }
}

class _DcaSummaryCard extends StatelessWidget {
  const _DcaSummaryCard({
    required this.snapshot,
    required this.onCreate,
    required this.onPlans,
    required this.onHistory,
  });

  final SavingsDcaSnapshot snapshot;
  final VoidCallback onCreate;
  final VoidCallback onPlans;
  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsDCAPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.repeat_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  snapshot.heroLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.base.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Tổng đã gửi (USD)',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          Text(
            snapshot.totalInvestedUsd,
            style: AppTextStyles.heroNumber.copyWith(
              color: AppColors.text1,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              _GainPill(
                icon: Icons.trending_up_rounded,
                label: snapshot.gainUsd,
              ),
              const Spacer(),
              Text(
                snapshot.gainLabel,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: 'Kế hoạch đang chạy',
                  value: '${snapshot.activePlanCount}',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Giá trị hiện tại',
                  value: snapshot.totalCurrentUsd,
                  valueColor: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Chiến lược',
                  value: snapshot.strategyLabel,
                  icon: Icons.shield_outlined,
                  valueColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: SavingsDCAPage.createPlanKey,
                  fullWidth: true,
                  height: AppSpacing.ctaHeight,
                  variant: VitCtaButtonVariant.success,
                  leading: const Icon(Icons.add_rounded),
                  onPressed: onCreate,
                  child: const Text('Tạo DCA'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroAction(
                  label: 'Danh mục',
                  icon: Icons.bar_chart_rounded,
                  onTap: onPlans,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroAction(
                  label: 'Lịch sử',
                  icon: Icons.schedule_rounded,
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

class _GainPill extends StatelessWidget {
  const _GainPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.buy10,
        borderRadius: AppRadii.xlRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x1,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.buy, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x1),
            Text(label, style: _microBold.copyWith(color: AppColors.buy)),
          ],
        ),
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    this.icon,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: valueColor, size: AppSpacing.iconSm),
                const SizedBox(width: AppSpacing.x1),
              ],
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _captionBold.copyWith(
                    color: valueColor,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroAction extends StatelessWidget {
  const _HeroAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.ctaHeight,
      child: Material(
        color: AppColors.portfolioBtnGhost,
        borderRadius: AppRadii.inputRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.inputRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.text1, size: AppSpacing.iconSm),
                const SizedBox(width: AppSpacing.x2),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _captionBold.copyWith(color: AppColors.text1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      borderColor: AppColors.primary20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconSm,
          ),
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

class _DcaTabs extends StatelessWidget {
  const _DcaTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<SavingsPreferenceTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: active,
      onChanged: onChanged,
      tabs: [
        for (final tab in tabs)
          VitTabItem(key: tab.id, label: tab.label, icon: _tabIcon(tab.id)),
      ],
    );
  }

  IconData _tabIcon(String id) {
    return id == 'history'
        ? Icons.history_rounded
        : Icons.account_tree_outlined;
  }
}

class _PlansList extends StatelessWidget {
  const _PlansList({
    required this.plans,
    required this.locallyPaused,
    required this.onToggle,
  });

  final List<SavingsDcaPlanDraft> plans;
  final Set<String> locallyPaused;
  final ValueChanged<SavingsDcaPlanDraft> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsDCAPage.plansListKey,
      children: [
        for (final plan in plans) ...[
          _PlanCard(
            plan: plan,
            paused:
                locallyPaused.contains(plan.id) ||
                plan.status == SavingsDcaPlanStatus.paused,
            onToggle: () => onToggle(plan),
          ),
          if (plan != plans.last) const SizedBox(height: AppSpacing.x4),
        ],
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.paused,
    required this.onToggle,
  });

  final SavingsDcaPlanDraft plan;
  final bool paused;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final statusColor = paused ? AppColors.warn : AppColors.buy;
    final statusLabel = paused ? 'Tạm dừng' : plan.statusLabel;

    return VitCard(
      key: SavingsDCAPage.planKey(plan.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AssetBadge(
                asset: plan.assetLabel,
                color: _assetColor(plan.asset),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(plan.productName, style: _captionBold),
                        _StatusPill(label: statusLabel, color: statusColor),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Row(
                      children: [
                        const Icon(
                          Icons.sync_rounded,
                          color: AppColors.text3,
                          size: AppSpacing.iconSm,
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        Expanded(
                          child: Text(
                            '${plan.amountPerPeriodLabel} / ${plan.frequencyLabel}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    plan.currentApyLabel,
                    style: _captionBold.copyWith(
                      color: AppColors.buy,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    'APY',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _PlanMetric(
                  label: 'Đã gửi',
                  value: plan.totalInvestedLabel,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _PlanMetric(
                  label: 'Giá trị',
                  value: plan.currentValueLabel,
                  valueColor: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _PlanMetric(
                  label: 'Lợi nhuận',
                  value: plan.gainLabel,
                  valueColor: plan.gainPositive
                      ? AppColors.buy
                      : AppColors.sell,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Tiếp theo: ${plan.nextExecution}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              _PlanIconButton(paused: paused, onTap: onToggle),
              const SizedBox(width: AppSpacing.x2),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlanMetric extends StatelessWidget {
  const _PlanMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _microBold.copyWith(
              color: valueColor,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanIconButton extends StatelessWidget {
  const _PlanIconButton({required this.paused, required this.onTap});

  final bool paused;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = paused ? AppColors.buy : AppColors.warn;
    final icon = paused ? Icons.play_arrow_rounded : Icons.pause_rounded;

    return Material(
      color: color.withValues(alpha: .12),
      borderRadius: AppRadii.smRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.smRadius,
        child: SizedBox(
          width: AppSpacing.buttonCompact,
          height: AppSpacing.buttonCompact,
          child: Icon(icon, color: color, size: AppSpacing.iconSm),
        ),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.executions});

  final List<SavingsDcaExecutionDraft> executions;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsDCAPage.historyListKey,
      children: [
        for (final execution in executions) ...[
          _ExecutionCard(execution: execution),
          if (execution != executions.last)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _ExecutionCard extends StatelessWidget {
  const _ExecutionCard({required this.execution});

  final SavingsDcaExecutionDraft execution;

  @override
  Widget build(BuildContext context) {
    final color = _executionColor(execution.status);

    return VitCard(
      key: SavingsDCAPage.executionKey(execution.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: AppRadii.mdRadius,
            ),
            child: SizedBox(
              width: AppSpacing.x7,
              height: AppSpacing.x7,
              child: Icon(_executionIcon(execution.status), color: color),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x1,
                  children: [
                    Text(execution.planName, style: _captionBold),
                    _StatusPill(
                      label: _executionLabel(execution.status),
                      color: color,
                    ),
                  ],
                ),
                Text(
                  '${execution.date} · APY ${execution.apyLabel}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Text(
            execution.amountLabel,
            textAlign: TextAlign.end,
            style: _captionBold.copyWith(
              color: execution.status == SavingsDcaExecutionStatus.failed
                  ? AppColors.sell
                  : AppColors.text1,
              decoration: execution.status == SavingsDcaExecutionStatus.failed
                  ? TextDecoration.lineThrough
                  : null,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreatePlanSheet extends StatelessWidget {
  const _CreatePlanSheet({required this.snapshot});

  final SavingsDcaSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: VitCard(
        key: SavingsDCAPage.createSheetKey,
        radius: VitCardRadius.lg,
        padding: const EdgeInsets.all(AppSpacing.x5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text('Tạo kế hoạch DCA', style: AppTextStyles.baseMedium),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
            Text(
              'Chọn sản phẩm linh hoạt để tự động gửi tiết kiệm theo lịch.',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
            const SizedBox(height: AppSpacing.x4),
            for (final product in snapshot.products) ...[
              _ProductRow(product: product),
              if (product != snapshot.products.last)
                const SizedBox(height: AppSpacing.x3),
            ],
            const SizedBox(height: AppSpacing.x5),
            VitCtaButton(
              variant: VitCtaButtonVariant.success,
              onPressed: () => Navigator.of(context).pop(),
              leading: const Icon(Icons.check_rounded),
              child: const Text('Xem trước lịch DCA'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({required this.product});

  final SavingsDcaProductDraft product;

  @override
  Widget build(BuildContext context) {
    final color = _assetColor(product.asset);

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          _AssetBadge(asset: product.asset, color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: _captionBold),
                Text(
                  'Khả dụng: ${product.balanceLabel}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Text(
            product.apyLabel,
            style: _captionBold.copyWith(color: AppColors.buy),
          ),
        ],
      ),
    );
  }
}

class _AssetBadge extends StatelessWidget {
  const _AssetBadge({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        border: Border.all(color: color.withValues(alpha: .35)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Center(
          child: Text(
            asset.length > 3 ? asset.substring(0, 3) : asset,
            style: _microBold.copyWith(color: color),
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

Color _assetColor(String asset) {
  return switch (asset) {
    'USDT' || 'USD' => AppColors.buy,
    'ETH' => AppColors.accent,
    'SOL' => AppColors.warn,
    _ => AppColors.primary,
  };
}

Color _executionColor(SavingsDcaExecutionStatus status) {
  return switch (status) {
    SavingsDcaExecutionStatus.success => AppColors.buy,
    SavingsDcaExecutionStatus.failed => AppColors.sell,
    SavingsDcaExecutionStatus.pending => AppColors.warn,
  };
}

IconData _executionIcon(SavingsDcaExecutionStatus status) {
  return switch (status) {
    SavingsDcaExecutionStatus.success => Icons.check_circle_outline_rounded,
    SavingsDcaExecutionStatus.failed => Icons.error_outline_rounded,
    SavingsDcaExecutionStatus.pending => Icons.schedule_rounded,
  };
}

String _executionLabel(SavingsDcaExecutionStatus status) {
  return switch (status) {
    SavingsDcaExecutionStatus.success => 'Thành công',
    SavingsDcaExecutionStatus.failed => 'Thất bại',
    SavingsDcaExecutionStatus.pending => 'Đang xử lý',
  };
}
