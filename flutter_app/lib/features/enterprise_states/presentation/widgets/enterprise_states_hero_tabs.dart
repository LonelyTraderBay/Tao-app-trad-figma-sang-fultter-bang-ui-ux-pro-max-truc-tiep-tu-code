part of '../pages/enterprise_states_page.dart';

class _PageHero extends StatelessWidget {
  const _PageHero({required this.snapshot});

  final EnterpriseStatesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: AppSpacing.enterpriseStatesTabShellPadding,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: _SectionTabButton(
                tab: tab,
                active: tab.section == active,
                onTap: () => onChanged(tab.section),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionTabButton extends StatelessWidget {
  const _SectionTabButton({
    required this.tab,
    required this.active,
    required this.onTap,
  });

  final EnterpriseTabDraft tab;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        key: EnterpriseStatesPage.sectionKey(tab.section),
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: active ? AppColors.primary : AppColors.transparent,
            shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
          ),
          child: Padding(
            padding: AppSpacing.enterpriseStatesTabButtonPadding,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                tab.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: active ? AppColors.text1 : AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
