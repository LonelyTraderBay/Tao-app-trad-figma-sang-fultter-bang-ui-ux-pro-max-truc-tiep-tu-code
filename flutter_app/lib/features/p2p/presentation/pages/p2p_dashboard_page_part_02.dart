part of 'p2p_dashboard_page.dart';

class _ExtraStats extends StatelessWidget {
  const _ExtraStats({required this.snapshot});

  final P2PDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final stats = snapshot.stats;
    return Row(
      children: [
        Expanded(
          child: _CenteredStat(
            icon: Icons.groups_outlined,
            value: '${stats.uniqueCounterparties}',
            label: 'Đối tác',
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _CenteredStat(
            icon: Icons.swap_horiz_rounded,
            value: '${stats.repeatCustomerRate.toStringAsFixed(1)}%',
            label: 'Quay lại',
            color: AppModuleAccents.p2p,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _CenteredStat(
            icon: Icons.attach_money_rounded,
            value: _formatMoneyCompact(stats.avgOrderSize),
            label: 'TB đơn hàng',
            color: AppColors.buy,
          ),
        ),
      ],
    );
  }
}

class _OrderBreakdownCard extends StatelessWidget {
  const _OrderBreakdownCard({required this.snapshot});

  final P2PDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final stats = snapshot.stats;
    final rows = [
      _BreakdownConfig(
        label: 'Hoàn thành',
        count: stats.completedOrders,
        color: AppColors.buy,
        icon: Icons.check_circle_outline_rounded,
      ),
      _BreakdownConfig(
        label: 'Đã hủy',
        count: stats.cancelledOrders,
        color: AppColors.sell,
        icon: Icons.cancel_outlined,
      ),
      _BreakdownConfig(
        label: 'Tranh chấp',
        count: stats.disputedOrders,
        color: AppColors.warn,
        icon: Icons.warning_amber_rounded,
      ),
    ];
    return VitCard(
      key: P2PDashboardPage.breakdownKey,
      radius: VitCardRadius.lg,
      padding: AppSpacing.p2pDashboardCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionTitle(
            icon: Icons.shopping_cart_outlined,
            label: 'Phân tích đơn hàng',
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final row in rows) ...[
            _BreakdownLine(row: row, total: stats.totalOrders),
            const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _TopMerchantsCard extends StatelessWidget {
  const _TopMerchantsCard({required this.snapshot});

  final P2PDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PDashboardPage.merchantsKey,
      radius: VitCardRadius.lg,
      padding: AppSpacing.p2pDashboardCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: _SectionTitle(
                  icon: Icons.star_border_rounded,
                  label: 'Top Merchants',
                ),
              ),
              Text(
                '30 ngày qua',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var index = 0; index < snapshot.topMerchants.length; index++)
            _MerchantRow(
              rank: index + 1,
              merchant: snapshot.topMerchants[index],
              onTap: () {
                HapticFeedback.selectionClick();
                context.go('/p2p/merchant/${snapshot.topMerchants[index].id}');
              },
            ),
        ],
      ),
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  const _RecentActivityCard({required this.snapshot});

  final P2PDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PDashboardPage.activityKey,
      radius: VitCardRadius.lg,
      padding: AppSpacing.p2pDashboardCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: _SectionTitle(
                  icon: Icons.schedule_rounded,
                  label: 'Hoạt động gần đây',
                ),
              ),
              _TextLinkButton(
                key: P2PDashboardPage.myOrdersKey,
                label: 'Xem tất cả',
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.go(snapshot.myOrdersRoute);
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var index = 0; index < snapshot.recentActivity.length; index++)
            _ActivityRow(
              activity: snapshot.recentActivity[index],
              last: index == snapshot.recentActivity.length - 1,
            ),
        ],
      ),
    );
  }
}

class _QuickNavigation extends StatelessWidget {
  const _QuickNavigation({required this.snapshot});

  final P2PDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PDashboardPage.quickNavKey,
      children: [
        for (var row = 0; row < 2; row++) ...[
          Row(
            children: [
              Expanded(
                child: _QuickActionTile(action: snapshot.quickActions[row * 2]),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _QuickActionTile(
                  action: snapshot.quickActions[row * 2 + 1],
                ),
              ),
            ],
          ),
          if (row == 0)
            const SizedBox(height: AppSpacing.p2pDashboardMetricRowGap),
        ],
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.action});

  final P2PDashboardQuickActionDraft action;

  @override
  Widget build(BuildContext context) {
    final color = _quickColor(action.id);
    return Material(
      key: P2PDashboardPage.quickActionKey(action.id),
      color: AppColors.surface,
      borderRadius: AppRadii.cardRadius,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          context.go(action.route);
        },
        borderRadius: AppRadii.cardRadius,
        child: Container(
          padding: AppSpacing.p2pDashboardQuickActionPadding,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Row(
            children: [
              _IconBubble(icon: _quickIcon(action.iconKey), color: color),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  action.label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.text2, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({
    required this.icon,
    required this.color,
    this.small = false,
  });

  final IconData icon;
  final Color color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final size = small ? AppSpacing.buttonCompact : AppSpacing.inputHeight;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.inputRadius,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Icon(
          icon,
          color: color,
          size: small
              ? AppSpacing.p2pDashboardIconBubbleSmallIcon
              : AppSpacing.iconMd,
        ),
      ),
    );
  }
}

class _TrendBadge extends StatelessWidget {
  const _TrendBadge({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.arrow_outward_rounded,
          color: AppColors.buy,
          size: AppSpacing.p2pDashboardTrendIcon,
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _TinyLegend extends StatelessWidget {
  const _TinyLegend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Container(
            width: AppSpacing.x2,
            height: AppSpacing.x2,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
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
        color: color.withValues(alpha: .16),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Padding(
        padding: AppSpacing.p2pDashboardPillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _RequirementPill extends StatelessWidget {
  const _RequirementPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: AppSpacing.p2pDashboardRequirementPillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
  });

  final String label;
  final String value;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
              value,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: AppSpacing.x2,
            backgroundColor: AppColors.surface2,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _ComparisonLine extends StatelessWidget {
  const _ComparisonLine({required this.item});

  final P2PDashboardComparisonDraft item;

  @override
  Widget build(BuildContext context) {
    final better = item.lowerBetter
        ? item.yours < item.platform
        : item.yours > item.platform;
    final color = better ? AppColors.buy : AppColors.warn;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.label,
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
            ),
            Text(
              '${_formatDecimal(item.yours)}${item.suffix}',
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              'vs ${_formatDecimal(item.platform)}${item.suffix}',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: LinearProgressIndicator(
            value: (item.yours / 100).clamp(.02, 1),
            minHeight: AppSpacing.x2,
            backgroundColor: AppColors.surface2,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
