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
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SizedBox(
        height: 60,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          children: [
            _FilterChipButton(
              key: NewsPage.filterAllKey,
              label: 'Tất cả',
              selected: activeType == null,
              selectedColor: _newsPrimary,
              onTap: () => onSelected(null),
            ),
            const SizedBox(width: 8),
            for (final type in filters) ...[
              _FilterChipButton(
                key: NewsPage.filterKey(type),
                label: '${type.emoji}  ${type.label}',
                selected: activeType == type,
                selectedColor: type.color,
                onTap: () => onSelected(type),
              ),
              const SizedBox(width: 8),
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
      height: 32,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.mdRadius,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: bg,
              border: Border.all(color: border),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Text(
                  label,
                  maxLines: 1,
                  style: AppTextStyles.caption.copyWith(
                    color: textColor,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
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
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            letterSpacing: .1,
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
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TypeAvatar(type: type),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ArticleMeta(article: article, pinned: pinned),
                    const SizedBox(height: 8),
                    Text(
                      article.title,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontSize: 15,
                        height: 1.25,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      article.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontSize: 13,
                        height: 1.34,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: 22,
                ),
              ),
            ],
          ),
          if (article.tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
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
      spacing: 8,
      runSpacing: 4,
      children: [
        if (pinned) Icon(Icons.push_pin_rounded, size: 13, color: _newsPrimary),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: type.color.withValues(alpha: .18),
            borderRadius: AppRadii.smRadius,
          ),
          child: Text(
            type.label,
            style: AppTextStyles.micro.copyWith(
              color: type.color,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              size: 10,
              color: AppColors.text3,
            ),
            const SizedBox(width: 4),
            Text(
              article.publishedAtLabel,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: 1,
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
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: type.color.withValues(alpha: .18),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Text(type.emoji, style: const TextStyle(fontSize: 20)),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface3,
        borderRadius: AppRadii.smRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.sell_outlined, color: AppColors.text2, size: 11),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsEmptyState extends StatelessWidget {
  const _NewsEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Icon(Icons.newspaper_rounded, color: AppColors.borderSolid, size: 48),
          SizedBox(height: 12),
          Text('Không có tin tức nào', style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
