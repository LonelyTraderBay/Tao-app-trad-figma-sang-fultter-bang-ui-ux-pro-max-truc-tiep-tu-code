part of '../pages/news_page.dart';

class _NewsFilterBar extends StatelessWidget {
  const _NewsFilterBar({
    required this.activeType,
    required this.filters,
    required this.onSelected,
  });

  final NewsArticleType? activeType;
  final List<NewsArticleType> filters;
  final ValueChanged<NewsArticleType?> onSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface,
        shape: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SizedBox(
        height: AppSpacing.newsFilterBarHeight,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: AppSpacing.newsFilterBarPadding,
          children: [
            _FilterChipButton(
              key: NewsPage.filterAllKey,
              label: 'Tất cả',
              selected: activeType == null,
              selectedColor: _newsPrimary,
              onTap: () => onSelected(null),
            ),
            const SizedBox(width: AppSpacing.x3),
            for (final type in filters) ...[
              _FilterChipButton(
                key: NewsPage.filterKey(type),
                label: '${type.emoji}  ${type.label}',
                selected: activeType == type,
                selectedColor: type.color,
                onTap: () => onSelected(type),
              ),
              const SizedBox(width: AppSpacing.x3),
            ],
          ],
        ),
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    super.key,
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? selectedColor.withValues(alpha: .18)
        : AppColors.surface2;
    final border = selected
        ? selectedColor.withValues(alpha: .72)
        : AppColors.borderSolid.withValues(alpha: .48);
    final textColor = selected ? selectedColor : AppColors.text2;

    return SizedBox(
      height: AppSpacing.newsFilterChipHeight,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.mdRadius,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: bg,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: border),
                borderRadius: AppRadii.mdRadius,
              ),
            ),
            child: Padding(
              padding: AppSpacing.newsFilterChipPadding,
              child: Center(
                child: Text(
                  label,
                  maxLines: 1,
                  style: AppTextStyles.captionSm.copyWith(
                    color: textColor,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.newsLineHeightTight,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.label,
    this.icon,
    this.color = AppColors.text2,
  });

  final String label;
  final IconData? icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: AppSpacing.newsSectionIconSize, color: color),
          const SizedBox(width: AppSpacing.x3),
        ],
        Text(
          label,
          style: AppTextStyles.captionSm.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            letterSpacing: AppSpacing.zero,
          ),
        ),
      ],
    );
  }
}

class _NewsArticleCard extends StatelessWidget {
  const _NewsArticleCard({
    super.key,
    required this.article,
    required this.onTap,
    this.pinned = false,
  });

  final NewsArticle article;
  final VoidCallback onTap;
  final bool pinned;

  @override
  Widget build(BuildContext context) {
    final type = article.type;
    return VitCard(
      width: double.infinity,
      variant: pinned ? VitCardVariant.inner : VitCardVariant.standard,
      borderColor: pinned
          ? _newsPrimary.withValues(alpha: .28)
          : AppColors.cardBorder,
      padding: AppSpacing.newsCardPadding,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TypeAvatar(type: type),
              const SizedBox(width: AppSpacing.newsFeedGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ArticleMeta(article: article, pinned: pinned),
                    const SizedBox(height: AppSpacing.x3),
                    Text(
                      article.title,
                      style: AppTextStyles.body.copyWith(
                        height: AppSpacing.newsTitleLineHeight,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.walletAssetSmallGap),
                    Text(
                      article.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: AppSpacing.newsSummaryLineHeight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3 + 2),
              const Padding(
                padding: AppSpacing.newsChevronPadding,
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.newsChevronIconSize,
                ),
              ),
            ],
          ),
          if (article.tags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.newsFeedGap),
            Wrap(
              spacing: AppSpacing.x3,
              runSpacing: AppSpacing.x2 + 1,
              children: [for (final tag in article.tags) _TagChip(label: tag)],
            ),
          ],
        ],
      ),
    );
  }
}

class _ArticleMeta extends StatelessWidget {
  const _ArticleMeta({required this.article, required this.pinned});

  final NewsArticle article;
  final bool pinned;

  @override
  Widget build(BuildContext context) {
    final type = article.type;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.x3,
      runSpacing: AppSpacing.x1 + 1,
      children: [
        if (pinned)
          Icon(
            Icons.push_pin_rounded,
            size: AppSpacing.newsSheetCalendarIconSize,
            color: _newsPrimary,
          ),
        DecoratedBox(
          decoration: ShapeDecoration(
            color: type.color.withValues(alpha: .18),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.smRadius,
            ),
          ),
          child: Padding(
            padding: AppSpacing.newsBadgePadding,
            child: Text(
              type.label,
              style: AppTextStyles.micro.copyWith(
                color: type.color,
                fontWeight: AppTextStyles.bold,
                height: AppSpacing.newsLineHeightTight,
              ),
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              size: AppSpacing.newsCalendarIconSize,
              color: AppColors.text3,
            ),
            const SizedBox(width: AppSpacing.x1 + 1),
            Text(
              article.publishedAtLabel,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: AppSpacing.newsLineHeightTight,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TypeAvatar extends StatelessWidget {
  const _TypeAvatar({required this.type});

  final NewsArticleType type;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.newsArticleAvatarSize,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: type.color.withValues(alpha: .18),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
        ),
        child: Center(
          child: Text(type.emoji, style: AppTextStyles.sectionTitleSm),
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface3,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: AppSpacing.newsTagPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.sell_outlined,
              color: AppColors.text2,
              size: AppSpacing.newsTagIconSize,
            ),
            const SizedBox(width: AppSpacing.x1 + 1),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: AppSpacing.newsLineHeightTight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewsEmptyState extends StatelessWidget {
  const _NewsEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: AppSpacing.newsEmptyPadding,
      child: Column(
        children: [
          Icon(
            Icons.newspaper_rounded,
            color: AppColors.borderSolid,
            size: AppSpacing.newsEmptyIconSize,
          ),
          SizedBox(height: AppSpacing.newsFeedGap),
          Text('Không có tin tức nào', style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
