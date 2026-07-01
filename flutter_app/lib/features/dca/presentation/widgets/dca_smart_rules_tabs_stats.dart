part of '../pages/dca_smart_rules_page.dart';

class _TopTabs extends StatelessWidget {
  const _TopTabs({required this.activeTab, required this.onChanged});

  final _RulesTab activeTab;
  final ValueChanged<_RulesTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _TopTab(
                label: 'Luat cua toi',
                tab: _RulesTab.mine,
                active: activeTab == _RulesTab.mine,
                onChanged: onChanged,
              ),
              _TopTab(
                label: 'Mau',
                tab: _RulesTab.templates,
                active: activeTab == _RulesTab.templates,
                onChanged: onChanged,
              ),
              _TopTab(
                label: 'Lich su',
                tab: _RulesTab.history,
                active: activeTab == _RulesTab.history,
                onChanged: onChanged,
              ),
            ],
          ),
          const Divider(
            height: AppSpacing.hairlineStroke,
            thickness: AppSpacing.hairlineStroke,
            color: AppColors.border,
          ),
        ],
      ),
    );
  }
}

class _TopTab extends StatelessWidget {
  const _TopTab({
    required this.label,
    required this.tab,
    required this.active,
    required this.onChanged,
  });

  final String label;
  final _RulesTab tab;
  final bool active;
  final ValueChanged<_RulesTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VitCard(
        key: DCASmartRulesPage.tabKey(tab.name),
        onTap: () => onChanged(tab),
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.standard,
        padding: EdgeInsets.zero,
        borderColor: AppColors.transparent,
        child: Padding(
          padding: AppSpacing.dcaTopPaddingX4,
          child: Column(
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: active ? AppColors.primary : AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              AnimatedSize(
                duration: const Duration(milliseconds: 160),
                child: SizedBox(
                  height: AppSpacing.dcaSmartTabIndicatorHeight,
                  width: active ? AppSpacing.dcaSmartTabIndicatorWidth : 0,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: active ? AppColors.primary : AppColors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadii.xsRadius,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.snapshot});

  final DcaSmartRulesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.dcaPaddingX4,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: AppSpacing.dcaSmartStatsIconBox,
                height: AppSpacing.dcaSmartStatsIconBox,
                child: DecoratedBox(
                  decoration: const ShapeDecoration(
                    color: AppColors.accent10,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.inputRadius,
                    ),
                  ),
                  child: const Icon(
                    Icons.bolt_rounded,
                    color: AppColors.accent,
                    size: AppSpacing.dcaSmartStatsIcon,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Smart Rules', style: AppTextStyles.sectionTitleXs),
                    Text(
                      'Automated DCA optimization',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _StatValue(
                  label: 'Active',
                  value: '${snapshot.activeRules}',
                  color: AppColors.buy,
                ),
              ),
              Expanded(
                child: _StatValue(
                  label: 'Triggered',
                  value: '${snapshot.totalTriggers}',
                ),
              ),
              Expanded(
                child: _StatValue(
                  label: 'Success',
                  value: '${snapshot.successPercent}%',
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatValue extends StatelessWidget {
  const _StatValue({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
    this.caption,
  });

  final String label;
  final String value;
  final Color color;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        if (caption != null)
          Text(
            caption!,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
      ],
    );
  }
}
