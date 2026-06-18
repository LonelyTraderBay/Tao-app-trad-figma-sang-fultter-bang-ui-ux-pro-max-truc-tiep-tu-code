part of '../pages/audit_trail_page.dart';

class _ComplianceNotice extends StatelessWidget {
  const _ComplianceNotice({required this.snapshot});

  final TradeAuditTrailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.description_outlined,
          color: AppColors.text1,
          size: AppSpacing.tradeToolCloseIcon,
        ),
        const SizedBox(width: AppSpacing.tradeToolIconGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snapshot.noticeTitle,
                style: AppTextStyles.badge.copyWith(color: AppColors.text1),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                snapshot.noticeDescription,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final List<TradeAuditStat> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final stat in stats) ...[
          Expanded(child: _StatCard(stat: stat)),
          if (stat != stats.last)
            const SizedBox(width: AppSpacing.tradeToolPageTopGap),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final TradeAuditStat stat;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: AppSpacing.tradeToolMetricHeight,
      padding: AppSpacing.tradeToolMetricPadding,
      radius: VitCardRadius.sm,
      borderColor: _auditBorder.withValues(alpha: .76),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const Spacer(),
          Text(
            stat.value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: stat.emphasized ? _auditGreen : AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchAndFilter extends StatelessWidget {
  const _SearchAndFilter({required this.placeholder, required this.onChanged});

  final String placeholder;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitSearchBar(
            fieldKey: AuditTrailPage.searchKey,
            placeholder: placeholder,
            variant: VitSearchBarVariant.compact,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: AppSpacing.tradeToolInlineGap),
        VitIconButton(
          icon: Icons.filter_alt_outlined,
          tooltip: 'Filter audit trail',
          onPressed: () {},
          variant: VitIconButtonVariant.ghost,
          size: VitIconButtonSize.md,
        ),
      ],
    );
  }
}

class _AuditTabs extends StatelessWidget {
  const _AuditTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeAuditTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.underline,
      activeKey: activeId,
      onChanged: onChanged,
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.id,
            label: tab.label,
            widgetKey: AuditTrailPage.tabKey(tab.id),
          ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return VitSectionHeader(
      title: label,
      variant: VitSectionHeaderVariant.accentBar,
      accentColor: _auditPrimary,
    );
  }
}
