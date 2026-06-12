part of '../pages/staking_risk_disclosure_page.dart';

class _CategoriesTab extends StatelessWidget {
  const _CategoriesTab({
    required this.snapshot,
    required this.expandedRisk,
    required this.onToggle,
  });

  final StakingRiskDisclosureSnapshot snapshot;
  final String? expandedRisk;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final category in snapshot.categories) ...[
          _RiskCategoryCard(
            category: category,
            expanded: expandedRisk == category.id,
            onTap: () => onToggle(category.id),
          ),
          if (category != snapshot.categories.last)
            const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
        ],
      ],
    );
  }
}

class _RiskCategoryCard extends StatelessWidget {
  const _RiskCategoryCard({
    required this.category,
    required this.expanded,
    required this.onTap,
  });

  final StakingRiskCategoryDraft category;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(category.level);
    return VitCard(
      key: StakingRiskDisclosurePage.categoryKey(category.id),
      radius: VitCardRadius.lg,
      clip: true,
      child: Column(
        children: [
          Material(
            color: AppColors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.x4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: AppSpacing.stakingRiskDisclosureCategoryIconBox,
                      height: AppSpacing.stakingRiskDisclosureCategoryIconBox,
                      decoration: BoxDecoration(
                        color: _riskTint(category.level),
                        border: Border.all(
                          color: color.withValues(alpha: .28),
                          width: AppSpacing.stakingRiskDisclosureBorderWidth,
                        ),
                        borderRadius: AppRadii.lgRadius,
                      ),
                      child: Icon(
                        _categoryIcon(category.id),
                        color: color,
                        size: AppSpacing.stakingRiskDisclosureCategoryIcon,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: AppSpacing.x2,
                            runSpacing: AppSpacing.x2,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                category.title,
                                style: AppTextStyles.baseMedium.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              _RiskLevelBadge(level: category.level),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: AppSpacing.x2),
                          ),
                          Text(
                            category.description,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                              height: AppSpacing
                                  .stakingRiskDisclosureBodyLineHeight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: expanded ? .25 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _RiskCategoryDetails(category: category),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
            sizeCurve: Curves.easeOut,
          ),
        ],
      ),
    );
  }
}

class _RiskCategoryDetails extends StatelessWidget {
  const _RiskCategoryDetails({required this.category});

  final StakingRiskCategoryDraft category;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x4,
        AppSpacing.x4,
        AppSpacing.x3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailGroup(label: 'Chi tiết:', items: category.details),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
          _DetailGroup(label: 'Ví dụ thực tế:', items: category.examples),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
          _DetailGroup(label: 'Cách giảm thiểu:', items: category.mitigation),
        ],
      ),
    );
  }
}

class _DetailGroup extends StatelessWidget {
  const _DetailGroup({required this.label, required this.items});

  final String label;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
        for (final item in items) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  top: AppSpacing.stakingRiskDisclosureDetailBulletTop,
                ),
                child: SizedBox(
                  width: AppSpacing.stakingRiskDisclosureDetailBullet,
                  height: AppSpacing.stakingRiskDisclosureDetailBullet,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.text3,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  item,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.stakingRiskDisclosureBodyLineHeight,
                  ),
                ),
              ),
            ],
          ),
          if (item != items.last)
            const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
        ],
      ],
    );
  }
}
