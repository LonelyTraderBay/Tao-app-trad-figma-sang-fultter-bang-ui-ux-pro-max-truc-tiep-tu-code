part of '../pages/enterprise_states_page.dart';

class _PageHero extends StatelessWidget {
  const _PageHero({required this.snapshot, required this.onBack});

  final EnterpriseStatesSnapshot snapshot;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VitIconButton(
          key: EnterpriseStatesPage.backKey,
          icon: Icons.chevron_left_rounded,
          tooltip: 'Back to Home',
          onPressed: onBack,
          variant: VitIconButtonVariant.transparent,
          size: VitIconButtonSize.md,
        ),
        const SizedBox(width: AppSpacing.x2),
        SizedBox.square(
          dimension: AppSpacing.enterpriseStatesIconBox,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: AppColors.buy,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.cardRadius,
                side: const BorderSide(color: AppColors.buy20),
              ),
            ),
            child: const Icon(
              Icons.layers_outlined,
              color: AppColors.text1,
              size: AppSpacing.iconLg,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snapshot.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                snapshot.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTabs extends StatelessWidget {
  const _SectionTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<EnterpriseTabDraft> tabs;
  final EnterpriseStateSection active;
  final ValueChanged<EnterpriseStateSection> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedTabBar(
      activeKey: active.name,
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.section.name,
            label: tab.label,
            widgetKey: EnterpriseStatesPage.sectionKey(tab.section),
          ),
      ],
      onChanged: (key) => onChanged(_sectionFromKey(key)),
    );
  }
}
