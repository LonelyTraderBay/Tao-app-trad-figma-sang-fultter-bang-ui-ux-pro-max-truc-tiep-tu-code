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
import 'package:vit_trade_flutter/features/earn/data/earn_repository.dart';

TextStyle get _captionBold =>
    AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.bold);
TextStyle get _microBold =>
    AppTextStyles.micro.copyWith(fontWeight: AppTextStyles.bold);

class SavingsAutoPilotPage extends ConsumerStatefulWidget {
  const SavingsAutoPilotPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc350_summary');
  static const modulesKey = Key('sc350_modules');
  static const actionsKey = Key('sc350_actions');
  static const settingsKey = Key('sc350_settings');
  static const statusButtonKey = Key('sc350_status_button');
  static const approveActionKey = Key('sc350_approve_action');
  static const skipActionKey = Key('sc350_skip_action');

  static Key tabKey(String id) => Key('sc350_tab_$id');
  static Key moduleKey(String id) => Key('sc350_module_$id');
  static Key actionKey(String id) => Key('sc350_action_$id');
  static Key modeKey(SavingsAutoPilotMode mode) =>
      Key('sc350_mode_${mode.name}');
  static Key budgetKey(int amount) => Key('sc350_budget_$amount');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsAutoPilotPage> createState() =>
      _SavingsAutoPilotPageState();
}

class _SavingsAutoPilotPageState extends ConsumerState<SavingsAutoPilotPage> {
  String? _tab;
  SavingsAutoPilotStatus? _status;
  SavingsAutoPilotMode? _mode;
  int? _monthlyBudgetUsd;
  bool? _approvalRequired;
  bool? _notificationsEnabled;
  final Map<String, bool> _moduleStates = {};
  final Map<String, SavingsAutoPilotActionStatus> _actionStates = {};

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(savingsAutoPilotRepositoryProvider)
        .getAutoPilot();
    final activeTab = _tab ?? snapshot.defaultTab;
    final status = _status ?? snapshot.config.status;
    final selectedMode = _mode ?? snapshot.config.mode;
    final monthlyBudget = _monthlyBudgetUsd ?? snapshot.config.monthlyBudgetUsd;
    final mode = _modeById(snapshot, selectedMode);
    final pendingCount = _pendingCount(snapshot);
    final executedCount = _executedCount(snapshot);
    final modeRender = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (modeRender.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-350 SavingsAutoPilotPage',
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
                    _AutoPilotHero(
                      snapshot: snapshot,
                      mode: mode,
                      status: status,
                      monthlyBudgetUsd: monthlyBudget,
                      executedCount: executedCount,
                      pendingCount: pendingCount,
                      onToggleStatus: _toggleStatus,
                    ),
                    _AutoPilotTabs(
                      tabs: snapshot.tabs,
                      active: activeTab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _tab = tab);
                      },
                    ),
                    if (activeTab == 'overview')
                      _OverviewTab(
                        snapshot: snapshot,
                        moduleStates: _moduleStates,
                        onOpenModule: (route) => context.go(route),
                        onShowActions: () => setState(() => _tab = 'actions'),
                        actionStatusFor: _actionStatus,
                        onOpenAction: (action) =>
                            _showActionDetail(context, action),
                      )
                    else if (activeTab == 'actions')
                      _ActionsTab(
                        snapshot: snapshot,
                        actionStatusFor: _actionStatus,
                        onOpenAction: (action) =>
                            _showActionDetail(context, action),
                        onApprove: _approveAction,
                        onSkip: _skipAction,
                      )
                    else
                      _SettingsTab(
                        snapshot: snapshot,
                        mode: selectedMode,
                        monthlyBudgetUsd: monthlyBudget,
                        approvalRequired:
                            _approvalRequired ??
                            snapshot.config.approvalRequired,
                        notificationsEnabled:
                            _notificationsEnabled ??
                            snapshot.config.notificationsEnabled,
                        moduleEnabled: _moduleEnabled,
                        onModeChanged: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _mode = value);
                        },
                        onBudgetChanged: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _monthlyBudgetUsd = value);
                        },
                        onModuleChanged: (id, enabled) {
                          HapticFeedback.selectionClick();
                          setState(() => _moduleStates[id] = enabled);
                        },
                        onApprovalChanged: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _approvalRequired = value);
                        },
                        onNotificationChanged: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _notificationsEnabled = value);
                        },
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

  void _toggleStatus() {
    HapticFeedback.mediumImpact();
    final current =
        _status ??
        ref
            .read(savingsAutoPilotRepositoryProvider)
            .getAutoPilot()
            .config
            .status;
    setState(() {
      _status = switch (current) {
        SavingsAutoPilotStatus.active => SavingsAutoPilotStatus.paused,
        SavingsAutoPilotStatus.paused => SavingsAutoPilotStatus.active,
        SavingsAutoPilotStatus.inactive => SavingsAutoPilotStatus.active,
      };
    });
  }

  void _approveAction(String id) {
    HapticFeedback.mediumImpact();
    setState(() => _actionStates[id] = SavingsAutoPilotActionStatus.executed);
  }

  void _skipAction(String id) {
    HapticFeedback.selectionClick();
    setState(() => _actionStates[id] = SavingsAutoPilotActionStatus.skipped);
  }

  bool _moduleEnabled(SavingsAutoPilotModuleDraft module) {
    return _moduleStates[module.id] ?? module.enabled;
  }

  SavingsAutoPilotActionStatus _actionStatus(
    SavingsAutoPilotActionDraft action,
  ) {
    return _actionStates[action.id] ?? action.status;
  }

  int _pendingCount(SavingsAutoPilotSnapshot snapshot) {
    return snapshot.actions
        .where(
          (action) =>
              _actionStatus(action) ==
              SavingsAutoPilotActionStatus.needsApproval,
        )
        .length;
  }

  int _executedCount(SavingsAutoPilotSnapshot snapshot) {
    return snapshot.actions
        .where(
          (action) =>
              _actionStatus(action) == SavingsAutoPilotActionStatus.executed,
        )
        .length;
  }

  void _showActionDetail(
    BuildContext context,
    SavingsAutoPilotActionDraft action,
  ) {
    HapticFeedback.selectionClick();
    final status = _actionStatus(action);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _ActionDetailSheet(
        action: action,
        status: status,
        onApprove: status == SavingsAutoPilotActionStatus.needsApproval
            ? () {
                Navigator.of(context).pop();
                _approveAction(action.id);
              }
            : null,
        onSkip: status == SavingsAutoPilotActionStatus.needsApproval
            ? () {
                Navigator.of(context).pop();
                _skipAction(action.id);
              }
            : null,
      ),
    );
  }
}

class _AutoPilotHero extends StatelessWidget {
  const _AutoPilotHero({
    required this.snapshot,
    required this.mode,
    required this.status,
    required this.monthlyBudgetUsd,
    required this.executedCount,
    required this.pendingCount,
    required this.onToggleStatus,
  });

  final SavingsAutoPilotSnapshot snapshot;
  final SavingsAutoPilotModeDraft mode;
  final SavingsAutoPilotStatus status;
  final int monthlyBudgetUsd;
  final int executedCount;
  final int pendingCount;
  final VoidCallback onToggleStatus;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(status);
    return VitCard(
      key: SavingsAutoPilotPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology_alt_rounded,
                color: statusColor,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  snapshot.heroLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextMuted,
                  ),
                ),
              ),
              _StatusButton(status: status, onPressed: onToggleStatus),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chế độ',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.portfolioTextMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      mode.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: _toneColor(mode.tone),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Ngân sách/tháng',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.portfolioTextMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    _money(monthlyBudgetUsd),
                    style: AppTextStyles.base.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _HeroStat(label: 'Hành động', value: '$executedCount'),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(
                  label: 'Cần duyệt',
                  value: '$pendingCount',
                  valueColor: pendingCount > 0 ? AppColors.primary : null,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              const Expanded(
                child: _HeroStat(
                  label: 'APY tăng',
                  value: '+10.1%',
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

class _StatusButton extends StatelessWidget {
  const _StatusButton({required this.status, required this.onPressed});

  final SavingsAutoPilotStatus status;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Material(
      color: color.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        key: SavingsAutoPilotPage.statusButtonKey,
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: color.withValues(alpha: .3)),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_statusIcon(status), color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x1),
              Text(
                _statusLabel(status),
                style: _microBold.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.base.copyWith(
              color: valueColor ?? AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _AutoPilotTabs extends StatelessWidget {
  const _AutoPilotTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<SavingsPreferenceTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
        child: VitTabBar(
          variant: VitTabBarVariant.underline,
          activeKey: active,
          onChanged: onChanged,
          tabs: [
            for (final tab in tabs) VitTabItem(key: tab.id, label: tab.label),
          ],
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    required this.snapshot,
    required this.moduleStates,
    required this.onOpenModule,
    required this.onShowActions,
    required this.actionStatusFor,
    required this.onOpenAction,
  });

  final SavingsAutoPilotSnapshot snapshot;
  final Map<String, bool> moduleStates;
  final ValueChanged<String> onOpenModule;
  final VoidCallback onShowActions;
  final SavingsAutoPilotActionStatus Function(SavingsAutoPilotActionDraft)
  actionStatusFor;
  final ValueChanged<SavingsAutoPilotActionDraft> onOpenAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsAutoPilotPage.modulesKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MetricGrid(metrics: snapshot.metrics),
        const SizedBox(height: AppSpacing.x5),
        const _SectionTitle(label: 'Modules đang hoạt động'),
        const SizedBox(height: AppSpacing.x3),
        for (final module in snapshot.modules) ...[
          _ModuleTile(
            module: module,
            enabled: moduleStates[module.id] ?? module.enabled,
            onTap: () => onOpenModule(module.route),
          ),
          const SizedBox(height: AppSpacing.x2),
        ],
        const SizedBox(height: AppSpacing.x3),
        const _SectionTitle(label: 'Hành động gần đây'),
        const SizedBox(height: AppSpacing.x3),
        for (final action in snapshot.actions.take(3)) ...[
          _ActionTile(
            action: action,
            status: actionStatusFor(action),
            onTap: () => onOpenAction(action),
          ),
          const SizedBox(height: AppSpacing.x2),
        ],
        OutlinedButton.icon(
          onPressed: onShowActions,
          icon: const Icon(Icons.chevron_right_rounded),
          label: const Text('Xem tất cả'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary30),
            shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        _InfoCallout(text: snapshot.disclaimer, tone: EarnRiskLevel.medium),
      ],
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.metrics});

  final List<SavingsAutoPilotMetricDraft> metrics;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: metrics.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.x3,
        crossAxisSpacing: AppSpacing.x3,
        childAspectRatio: 1.95,
      ),
      itemBuilder: (context, index) {
        final metric = metrics[index];
        final color = _toneColor(metric.tone);
        return VitCard(
          padding: const EdgeInsets.all(AppSpacing.x3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    _iconFor(metric.iconKey),
                    color: color,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      metric.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _microBold.copyWith(color: AppColors.text3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                metric.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.base.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ModuleTile extends StatelessWidget {
  const _ModuleTile({
    required this.module,
    required this.enabled,
    required this.onTap,
  });

  final SavingsAutoPilotModuleDraft module;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? _toneColor(module.tone) : AppColors.text3;
    return VitCard(
      key: SavingsAutoPilotPage.moduleKey(module.id),
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      borderColor: enabled ? null : AppColors.borderSolid,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          _IconBadge(icon: _iconFor(module.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  module.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _captionBold.copyWith(color: AppColors.text1),
                ),
                Text(
                  module.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          _SmallPill(
            label: enabled ? 'BẬT' : 'TẮT',
            color: enabled ? AppColors.buy : AppColors.sell,
          ),
          const SizedBox(width: AppSpacing.x2),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _ActionsTab extends StatelessWidget {
  const _ActionsTab({
    required this.snapshot,
    required this.actionStatusFor,
    required this.onOpenAction,
    required this.onApprove,
    required this.onSkip,
  });

  final SavingsAutoPilotSnapshot snapshot;
  final SavingsAutoPilotActionStatus Function(SavingsAutoPilotActionDraft)
  actionStatusFor;
  final ValueChanged<SavingsAutoPilotActionDraft> onOpenAction;
  final ValueChanged<String> onApprove;
  final ValueChanged<String> onSkip;

  @override
  Widget build(BuildContext context) {
    final pending = snapshot.actions
        .where(
          (action) =>
              actionStatusFor(action) ==
              SavingsAutoPilotActionStatus.needsApproval,
        )
        .toList();

    return Column(
      key: SavingsAutoPilotPage.actionsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (pending.isNotEmpty) ...[
          _SectionTitle(label: 'Cần phê duyệt (${pending.length})'),
          const SizedBox(height: AppSpacing.x3),
          for (final action in pending) ...[
            _ApprovalCard(
              action: action,
              onOpen: () => onOpenAction(action),
              onApprove: () => onApprove(action.id),
              onSkip: () => onSkip(action.id),
            ),
            const SizedBox(height: AppSpacing.x3),
          ],
          const SizedBox(height: AppSpacing.x3),
        ],
        const _SectionTitle(label: 'Lịch sử hành động'),
        const SizedBox(height: AppSpacing.x3),
        for (final action in snapshot.actions) ...[
          _ActionTile(
            action: action,
            status: actionStatusFor(action),
            onTap: () => onOpenAction(action),
            showImpact: true,
          ),
          const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  const _ApprovalCard({
    required this.action,
    required this.onOpen,
    required this.onApprove,
    required this.onSkip,
  });

  final SavingsAutoPilotActionDraft action;
  final VoidCallback onOpen;
  final VoidCallback onApprove;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final color = _actionTypeColor(action.type);
    return VitCard(
      borderColor: AppColors.primary30,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconBadge(icon: _actionTypeIcon(action.type), color: color),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      children: [
                        _SmallPill(
                          label: _actionTypeLabel(action.type),
                          color: color,
                        ),
                        const _SmallPill(
                          label: 'Cần duyệt',
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      action.title,
                      style: _captionBold.copyWith(color: AppColors.text1),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      action.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: SavingsAutoPilotPage.skipActionKey,
                  onPressed: onSkip,
                  variant: VitCtaButtonVariant.ghost,
                  height: 40,
                  leading: const Icon(Icons.close_rounded),
                  child: const Text('Bỏ qua'),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: VitCtaButton(
                  onPressed: onOpen,
                  variant: VitCtaButtonVariant.secondary,
                  height: 40,
                  leading: const Icon(Icons.visibility_outlined),
                  child: const Text('Xem'),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: VitCtaButton(
                  key: SavingsAutoPilotPage.approveActionKey,
                  onPressed: onApprove,
                  variant: VitCtaButtonVariant.success,
                  height: 40,
                  leading: const Icon(Icons.check_circle_outline_rounded),
                  child: const Text('Duyệt'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.action,
    required this.status,
    required this.onTap,
    this.showImpact = false,
  });

  final SavingsAutoPilotActionDraft action;
  final SavingsAutoPilotActionStatus status;
  final VoidCallback onTap;
  final bool showImpact;

  @override
  Widget build(BuildContext context) {
    final typeColor = _actionTypeColor(action.type);
    final statusColor = _actionStatusColor(status);
    return VitCard(
      key: SavingsAutoPilotPage.actionKey(action.id),
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      onTap: onTap,
      child: Row(
        children: [
          _IconBadge(icon: _actionTypeIcon(action.type), color: typeColor),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x1,
                  children: [
                    _SmallPill(
                      label: _actionTypeLabel(action.type),
                      color: typeColor,
                    ),
                    _SmallPill(
                      label: _actionStatusLabel(status),
                      color: statusColor,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  action.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _captionBold.copyWith(color: AppColors.text1),
                ),
                Text(
                  action.timestamp,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          if (showImpact && action.impact.isNotEmpty)
            Flexible(
              child: Text(
                action.impact,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: _microBold.copyWith(color: AppColors.buy),
              ),
            ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab({
    required this.snapshot,
    required this.mode,
    required this.monthlyBudgetUsd,
    required this.approvalRequired,
    required this.notificationsEnabled,
    required this.moduleEnabled,
    required this.onModeChanged,
    required this.onBudgetChanged,
    required this.onModuleChanged,
    required this.onApprovalChanged,
    required this.onNotificationChanged,
  });

  final SavingsAutoPilotSnapshot snapshot;
  final SavingsAutoPilotMode mode;
  final int monthlyBudgetUsd;
  final bool approvalRequired;
  final bool notificationsEnabled;
  final bool Function(SavingsAutoPilotModuleDraft module) moduleEnabled;
  final ValueChanged<SavingsAutoPilotMode> onModeChanged;
  final ValueChanged<int> onBudgetChanged;
  final void Function(String id, bool enabled) onModuleChanged;
  final ValueChanged<bool> onApprovalChanged;
  final ValueChanged<bool> onNotificationChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsAutoPilotPage.settingsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle(label: 'Chế độ AutoPilot'),
        const SizedBox(height: AppSpacing.x3),
        for (final item in snapshot.modes) ...[
          _ModeCard(
            item: item,
            selected: item.id == mode,
            onTap: () => onModeChanged(item.id),
          ),
          const SizedBox(height: AppSpacing.x2),
        ],
        const SizedBox(height: AppSpacing.x4),
        const _SectionTitle(label: 'Ngân sách hằng tháng (USD)'),
        const SizedBox(height: AppSpacing.x3),
        _BudgetCard(selected: monthlyBudgetUsd, onChanged: onBudgetChanged),
        const SizedBox(height: AppSpacing.x5),
        const _SectionTitle(label: 'Modules tự động'),
        const SizedBox(height: AppSpacing.x3),
        for (final module in snapshot.modules) ...[
          _SwitchRow(
            icon: _iconFor(module.iconKey),
            color: _toneColor(module.tone),
            title: module.label,
            subtitle: module.description,
            value: moduleEnabled(module),
            onChanged: (value) => onModuleChanged(module.id, value),
          ),
          const SizedBox(height: AppSpacing.x2),
        ],
        const SizedBox(height: AppSpacing.x5),
        const _SectionTitle(label: 'An toàn & Kiểm soát'),
        const SizedBox(height: AppSpacing.x3),
        _SwitchRow(
          icon: Icons.security_rounded,
          color: AppColors.primary,
          title: 'Phê duyệt thủ công',
          subtitle: 'Yêu cầu xác nhận trước khi chuyển SP',
          value: approvalRequired,
          onChanged: onApprovalChanged,
        ),
        const SizedBox(height: AppSpacing.x2),
        _SwitchRow(
          icon: Icons.notifications_active_outlined,
          color: AppColors.warn,
          title: 'Thông báo hành động',
          subtitle: 'Nhận thông báo khi AutoPilot hành động',
          value: notificationsEnabled,
          onChanged: onNotificationChanged,
        ),
        const SizedBox(height: AppSpacing.x5),
        const _SectionTitle(label: 'Tham số rủi ro'),
        const SizedBox(height: AppSpacing.x3),
        _RiskParameter(
          label: 'Ngưỡng rebalance',
          value: '${snapshot.config.rebalanceThresholdPct}%',
          minLabel: '3% (nhạy)',
          maxLabel: '25% (ổn định)',
          color: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.x3),
        _RiskParameter(
          label: 'Min APY gain cho switch',
          value: '${snapshot.config.switchMinApyGainPct.toStringAsFixed(1)}%',
          minLabel: '0.1% (nhạy)',
          maxLabel: '3.0% (thận trọng)',
          color: AppColors.accent,
        ),
        const SizedBox(height: AppSpacing.x3),
        _RiskParameter(
          label: 'Max single-asset',
          value: '${snapshot.config.maxSingleAssetPct}%',
          minLabel: '20% (đa dạng)',
          maxLabel: '80% (tập trung)',
          color: AppColors.sell,
        ),
        const SizedBox(height: AppSpacing.x4),
        _InfoCallout(text: snapshot.disclaimer, tone: EarnRiskLevel.high),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final SavingsAutoPilotModeDraft item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(item.tone);
    return VitCard(
      key: SavingsAutoPilotPage.modeKey(item.id),
      variant: selected ? VitCardVariant.standard : VitCardVariant.inner,
      radius: VitCardRadius.lg,
      borderColor: selected ? color.withValues(alpha: .4) : null,
      padding: const EdgeInsets.all(AppSpacing.x3),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBadge(icon: _iconFor(item.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.label, style: _captionBold),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  item.description,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.x2),
                Wrap(
                  spacing: AppSpacing.x3,
                  runSpacing: AppSpacing.x1,
                  children: [
                    Text(
                      'DCA: ${item.dcaFrequency}',
                      style: AppTextStyles.micro,
                    ),
                    Text(
                      'Rebalance: ${item.rebalanceThreshold}',
                      style: AppTextStyles.micro,
                    ),
                    Text(
                      'Switch: ${item.switchMinGain}',
                      style: AppTextStyles.micro,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Icon(
            selected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_off_rounded,
            color: selected ? color : AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  const _BudgetCard({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const options = [500, 1000, 2000, 5000];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          variant: VitCardVariant.inner,
          radius: VitCardRadius.lg,
          borderColor: AppColors.primary30,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x3,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.attach_money_rounded,
                color: AppColors.primary,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  '$selected',
                  style: AppTextStyles.base.copyWith(
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              Text(
                'USD/tháng',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Row(
          children: [
            for (final amount in options) ...[
              Expanded(
                child: _ChoicePill(
                  key: SavingsAutoPilotPage.budgetKey(amount),
                  label: _money(amount),
                  selected: selected == amount,
                  onTap: () => onChanged(amount),
                ),
              ),
              if (amount != options.last) const SizedBox(width: AppSpacing.x2),
            ],
          ],
        ),
      ],
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _captionBold.copyWith(color: AppColors.text1),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeThumbColor: AppColors.buy,
            activeTrackColor: AppColors.buy20,
            inactiveThumbColor: AppColors.text3,
            inactiveTrackColor: AppColors.toggleTrackOff,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _RiskParameter extends StatelessWidget {
  const _RiskParameter({
    required this.label,
    required this.value,
    required this.minLabel,
    required this.maxLabel,
    required this.color,
  });

  final String label;
  final String value;
  final String minLabel;
  final String maxLabel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: _captionBold)),
              Text(value, style: _captionBold.copyWith(color: color)),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 5,
              value: .42,
              color: color,
              backgroundColor: AppColors.surface3,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              Expanded(child: Text(minLabel, style: AppTextStyles.micro)),
              Text(maxLabel, style: AppTextStyles.micro),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionDetailSheet extends StatelessWidget {
  const _ActionDetailSheet({
    required this.action,
    required this.status,
    required this.onApprove,
    required this.onSkip,
  });

  final SavingsAutoPilotActionDraft action;
  final SavingsAutoPilotActionStatus status;
  final VoidCallback? onApprove;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final typeColor = _actionTypeColor(action.type);
    return SafeArea(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _IconBadge(
                    icon: _actionTypeIcon(action.type),
                    color: typeColor,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(action.title, style: _captionBold),
                        Text(
                          action.timestamp,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _SmallPill(
                    label: _actionStatusLabel(status),
                    color: _actionStatusColor(status),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                action.description,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: AppSpacing.x4),
              VitCard(
                variant: VitCardVariant.inner,
                padding: const EdgeInsets.all(AppSpacing.x3),
                child: Column(
                  children: [
                    for (final entry in action.details.entries)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.x1,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                entry.key,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                            ),
                            Text(entry.value, style: _captionBold),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (onApprove != null && onSkip != null) ...[
                const SizedBox(height: AppSpacing.x4),
                Row(
                  children: [
                    Expanded(
                      child: VitCtaButton(
                        onPressed: onSkip,
                        variant: VitCtaButtonVariant.secondary,
                        child: const Text('Bỏ qua'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: VitCtaButton(
                        onPressed: onApprove,
                        variant: VitCtaButtonVariant.success,
                        child: const Text('Phê duyệt'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: AppSpacing.iconSm),
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

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
        child: Text(label, style: _microBold.copyWith(color: color)),
      ),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
        foregroundColor: selected ? AppColors.primary : AppColors.text2,
        side: BorderSide(
          color: selected ? AppColors.primary40 : AppColors.borderSolid,
        ),
        backgroundColor: selected ? AppColors.primary12 : AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(label, style: _microBold),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            label,
            style: _captionBold.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}

class _InfoCallout extends StatelessWidget {
  const _InfoCallout({required this.text, required this.tone});

  final String text;
  final EarnRiskLevel tone;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(tone);
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: color.withValues(alpha: .18),
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: color,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
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

SavingsAutoPilotModeDraft _modeById(
  SavingsAutoPilotSnapshot snapshot,
  SavingsAutoPilotMode id,
) {
  return snapshot.modes.firstWhere((mode) => mode.id == id);
}

String _money(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i += 1) {
    final left = raw.length - i;
    buffer.write(raw[i]);
    if (left > 1 && left % 3 == 1) buffer.write(',');
  }
  return '\$${buffer.toString()}.00';
}

IconData _iconFor(String key) {
  return switch (key) {
    'shield' => Icons.shield_outlined,
    'target' => Icons.track_changes_rounded,
    'bolt' => Icons.bolt_rounded,
    'repeat' => Icons.repeat_rounded,
    'rebalance' => Icons.sync_rounded,
    'spark' => Icons.auto_awesome_rounded,
    'trend' => Icons.trending_up_rounded,
    _ => Icons.tune_rounded,
  };
}

Color _toneColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.primary,
    EarnRiskLevel.high => AppColors.accent,
  };
}

Color _statusColor(SavingsAutoPilotStatus status) {
  return switch (status) {
    SavingsAutoPilotStatus.active => AppColors.buy,
    SavingsAutoPilotStatus.paused => AppColors.warn,
    SavingsAutoPilotStatus.inactive => AppColors.text3,
  };
}

IconData _statusIcon(SavingsAutoPilotStatus status) {
  return switch (status) {
    SavingsAutoPilotStatus.active => Icons.play_arrow_rounded,
    SavingsAutoPilotStatus.paused => Icons.pause_rounded,
    SavingsAutoPilotStatus.inactive => Icons.power_settings_new_rounded,
  };
}

String _statusLabel(SavingsAutoPilotStatus status) {
  return switch (status) {
    SavingsAutoPilotStatus.active => 'Đang chạy',
    SavingsAutoPilotStatus.paused => 'Tạm dừng',
    SavingsAutoPilotStatus.inactive => 'Kích hoạt',
  };
}

IconData _actionTypeIcon(SavingsAutoPilotActionType type) {
  return switch (type) {
    SavingsAutoPilotActionType.dcaExecuted => Icons.repeat_rounded,
    SavingsAutoPilotActionType.rebalanced => Icons.sync_rounded,
    SavingsAutoPilotActionType.switchProduct => Icons.swap_horiz_rounded,
    SavingsAutoPilotActionType.compoundActivated => Icons.bolt_rounded,
    SavingsAutoPilotActionType.apyOptimized => Icons.trending_up_rounded,
    SavingsAutoPilotActionType.riskAdjusted => Icons.shield_outlined,
  };
}

Color _actionTypeColor(SavingsAutoPilotActionType type) {
  return switch (type) {
    SavingsAutoPilotActionType.dcaExecuted => AppColors.buy,
    SavingsAutoPilotActionType.rebalanced => AppColors.primary,
    SavingsAutoPilotActionType.switchProduct => AppColors.accent,
    SavingsAutoPilotActionType.compoundActivated => AppColors.buy,
    SavingsAutoPilotActionType.apyOptimized => AppColors.warn,
    SavingsAutoPilotActionType.riskAdjusted => AppColors.sell,
  };
}

String _actionTypeLabel(SavingsAutoPilotActionType type) {
  return switch (type) {
    SavingsAutoPilotActionType.dcaExecuted => 'DCA',
    SavingsAutoPilotActionType.rebalanced => 'Rebalance',
    SavingsAutoPilotActionType.switchProduct => 'Chuyển SP',
    SavingsAutoPilotActionType.compoundActivated => 'Lãi kép',
    SavingsAutoPilotActionType.apyOptimized => 'Tối ưu APY',
    SavingsAutoPilotActionType.riskAdjusted => 'Rủi ro',
  };
}

Color _actionStatusColor(SavingsAutoPilotActionStatus status) {
  return switch (status) {
    SavingsAutoPilotActionStatus.executed => AppColors.buy,
    SavingsAutoPilotActionStatus.pending => AppColors.warn,
    SavingsAutoPilotActionStatus.skipped => AppColors.text3,
    SavingsAutoPilotActionStatus.needsApproval => AppColors.primary,
  };
}

String _actionStatusLabel(SavingsAutoPilotActionStatus status) {
  return switch (status) {
    SavingsAutoPilotActionStatus.executed => 'Đã thực hiện',
    SavingsAutoPilotActionStatus.pending => 'Đang xử lý',
    SavingsAutoPilotActionStatus.skipped => 'Bỏ qua',
    SavingsAutoPilotActionStatus.needsApproval => 'Cần duyệt',
  };
}
