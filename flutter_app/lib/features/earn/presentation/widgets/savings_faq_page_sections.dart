part of '../pages/savings_faq_page.dart';

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.snapshot});

  final SavingsFAQSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      borderColor: AppColors.primary20,
      padding: AppSpacing.earnCardPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.chat_bubble_outline_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.heroTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.heroSubtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.stakingEarnHeroTabLabelLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.placeholder, required this.onChanged});

  final String placeholder;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSearchBar(
      fieldKey: SavingsFAQPage.searchFieldKey,
      placeholder: placeholder,
      variant: VitSearchBarVariant.compact,
      onChanged: onChanged,
    );
  }
}

class _CategoryScroller extends StatelessWidget {
  const _CategoryScroller({
    required this.categories,
    required this.activeId,
    required this.counts,
    required this.onChanged,
  });

  final List<SavingsFAQCategoryDraft> categories;
  final String activeId;
  final Map<String, int> counts;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Row(
        children: [
          for (final category in categories) ...[
            _CategoryChip(
              key: SavingsFAQPage.categoryKey(category.id),
              category: category,
              count: counts[category.id] ?? 0,
              selected: category.id == activeId,
              onTap: () => onChanged(category.id),
            ),
            if (category != categories.last)
              const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    super.key,
    required this.category,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final SavingsFAQCategoryDraft category;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.large,
      onTap: onTap,
      clip: true,
      padding: AppSpacing.earnPillPaddingLarge,
      background: DecoratedBox(
        decoration: ShapeDecoration(
          color: selected ? AppColors.primary12 : AppColors.surface2,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: selected ? AppColors.primary30 : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.lgRadius,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            category.label,
            style: AppTextStyles.caption.copyWith(
              color: selected ? AppColors.primary : AppColors.text3,
              fontWeight: selected ? AppTextStyles.bold : AppTextStyles.normal,
            ),
          ),
          const SizedBox(width: AppSpacing.x1),
          Text(
            '$count',
            style: AppTextStyles.micro.copyWith(
              color: selected ? AppColors.primary : AppColors.text3,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _FAQList extends StatelessWidget {
  const _FAQList({
    required this.items,
    required this.expandedIds,
    required this.onToggle,
  });

  final List<SavingsFAQItemDraft> items;
  final Set<String> expandedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsFAQPage.faqListKey,
      children: [
        for (final item in items) ...[
          _FAQCard(
            key: item == items.first ? SavingsFAQPage.firstFaqKey : null,
            item: item,
            expanded: expandedIds.contains(item.id),
            onTap: () => onToggle(item.id),
          ),
          if (item != items.last) const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _FAQCard extends StatelessWidget {
  const _FAQCard({
    super.key,
    required this.item,
    required this.expanded,
    required this.onTap,
  });

  final SavingsFAQItemDraft item;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(item.category);
    return VitCard(
      radius: VitCardRadius.large,
      padding: AppSpacing.zeroInsets,
      child: Column(
        children: [
          VitCard(
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.large,
            onTap: onTap,
            padding: AppSpacing.earnPillPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _QuestionIcon(color: color),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    item.question,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      height: AppSpacing.stakingEarnHeroTabLabelLineHeight,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.iconMd,
                  ),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: AppSpacing.earnDisclosureDetailsPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    item.answer,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: AppSpacing.stakingEarnHeroTabLabelLineHeight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  const Divider(
                    color: AppColors.divider,
                    height: AppSpacing.dividerHairline,
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Row(
                    children: [
                      Text(
                        'Hữu ích?',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      _FeedbackPill(
                        icon: Icons.thumb_up_alt_outlined,
                        label: 'Có',
                        color: AppColors.buy,
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      _FeedbackPill(
                        icon: Icons.thumb_down_alt_outlined,
                        label: 'Không',
                        color: AppColors.sell,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
          ),
        ],
      ),
    );
  }
}

class _QuestionIcon extends StatelessWidget {
  const _QuestionIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.14),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
      ),
      child: SizedBox(
        width: AppSpacing.x6,
        height: AppSpacing.x6,
        child: Icon(
          Icons.help_outline_rounded,
          color: color,
          size: AppSpacing.iconSm,
        ),
      ),
    );
  }
}
