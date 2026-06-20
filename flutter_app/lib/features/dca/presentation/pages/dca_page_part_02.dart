part of 'dca_page.dart';

class _NextPurchaseRow extends StatelessWidget {
  const _NextPurchaseRow({required this.overview});

  final DcaOverview overview;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      density: VitDensity.compact,
      child: Row(
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: AppColors.primary12,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.mdRadius,
                  side: const BorderSide(color: AppColors.primary20),
                ),
              ),
              child: const Icon(
                Icons.schedule_rounded,
                color: AppColors.primary,
                size: AppSpacing.iconMd,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lần mua tiếp',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.portfolioTextMuted,
                    fontWeight: AppTextStyles.bold,
                    height: 1.04,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${overview.nextRelativeTime} · ${_formatCompactVnd(overview.nextAmountVnd)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1.04,
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
      density: VitDensity.compact,
      child: SizedBox(
        height: VitDensity.compact.controlHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: AppSpacing.iconMd),
            const SizedBox(height: AppSpacing.x1),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: 1.04,
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
        const SizedBox(height: AppSpacing.x2),
        Row(
          children: [
            Expanded(
              child: _ToolCard(
                tool: tools[0],
                onTap: () => onOpen(tools[0].route),
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: _ToolCard(
                tool: tools[1],
                onTap: () => onOpen(tools[1].route),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        Row(
          children: [
            Expanded(
              child: _ToolCard(
                tool: tools[2],
                onTap: () => onOpen(tools[2].route),
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
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
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: color.withValues(alpha: .13),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.mdRadius,
                  side: BorderSide(color: color.withValues(alpha: .2)),
                ),
              ),
              child: Icon(_toolIcon(tool.icon), color: color, size: 18),
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            tool.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1.04,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            tool.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.18,
            ),
          ),
        ],
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
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: const BorderSide(color: AppColors.cardBorder),
        ),
      ),
      child: Padding(
        padding: AppSpacing.dcaPaddingX2,
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
          if (index > 0) const SizedBox(height: AppSpacing.x2),
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
      padding: AppSpacing.zeroInsets,
      borderColor: plan.status == DcaPlanStatus.active
          ? AppColors.buy20
          : AppColors.cardBorder,
      child: Column(
        children: [
          SizedBox(
            height: 3,
            child: ColoredBox(
              color: plan.status == DcaPlanStatus.active
                  ? AppColors.buy
                  : AppColors.warn,
            ),
          ),
          Padding(
            padding: VitDensity.compact.cardPadding,
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
                                    height: 1.04,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.x2),
                              VitStatusPill(
                                label: _frequencyLabel(plan.frequency),
                                status: VitStatusPillStatus.neutral,
                                size: VitStatusPillSize.sm,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.x1),
                          Text(
                            plan.coinName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                              height: 1.04,
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
                const SizedBox(height: AppSpacing.x2),
                VitCard(
                  variant: VitCardVariant.inner,
                  radius: VitCardRadius.md,
                  density: VitDensity.compact,
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
                const SizedBox(height: AppSpacing.x2),
                VitCard(
                  variant: VitCardVariant.inner,
                  radius: VitCardRadius.sm,
                  density: VitDensity.compact,
                  borderColor: AppColors.primary20,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        color: AppColors.primary,
                        size: AppSpacing.iconMd,
                      ),
                      const SizedBox(width: AppSpacing.x2),
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
                const SizedBox(height: AppSpacing.x2),
                Row(
                  children: [
                    Expanded(
                      child: VitCtaButton(
                        onPressed: onPause,
                        variant: VitCtaButtonVariant.secondary,
                        height: VitDensity.compact.controlHeight,
                        leading: const Icon(Icons.pause_rounded),
                        child: const Text('Tạm dừng'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    _PlanIconButton(
                      icon: Icons.edit_rounded,
                      color: AppColors.text2,
                      onTap: onPause,
                    ),
                    const SizedBox(width: AppSpacing.x2),
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
