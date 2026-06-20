part of 'savings_autopilot_page.dart';

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
      padding: AppSpacing.earnPaddingX5,
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
    return VitStatusPill(
      key: SavingsAutoPilotPage.statusButtonKey,
      label: _statusLabel(status),
      icon: _statusIcon(status),
      status: _statusPillStatus(status),
      size: VitStatusPillSize.md,
      onTap: onPressed,
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
    return Material(
      color: AppColors.surface,
      child: Column(
        children: [
          Padding(
            padding: AppSpacing.earnHorizontalPaddingX4,
            child: VitTabBar(
              variant: VitTabBarVariant.underline,
              activeKey: active,
              onChanged: onChanged,
              tabs: [
                for (final tab in tabs)
                  VitTabItem(key: tab.id, label: tab.label),
              ],
            ),
          ),
          const Divider(height: AppSpacing.dividerHairline),
        ],
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
        VitCtaButton(
          onPressed: onShowActions,
          variant: VitCtaButtonVariant.secondary,
          leading: const Icon(Icons.list_alt_rounded),
          trailing: const Icon(Icons.chevron_right_rounded),
          child: const Text('Xem tất cả'),
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
        crossAxisCount: AppSpacing.savingsAutoPilotMetricGridColumns,
        mainAxisSpacing: AppSpacing.x3,
        crossAxisSpacing: AppSpacing.x3,
        childAspectRatio: AppSpacing.savingsAutoPilotMetricGridAspect,
      ),
      itemBuilder: (context, index) {
        final metric = metrics[index];
        final color = _toneColor(metric.tone);
        return VitCard(
          padding: AppSpacing.earnPaddingX3,
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
      padding: AppSpacing.earnPaddingX3,
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
