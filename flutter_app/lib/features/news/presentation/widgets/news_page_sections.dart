part of '../pages/news_page.dart';

class _NewsBody extends StatelessWidget {
  const _NewsBody({
    required this.snapshot,
    required this.activeType,
    required this.onRetry,
    required this.onArticleTap,
  });

  final NewsScreenSnapshot snapshot;
  final NewsArticleType? activeType;
  final VoidCallback onRetry;
  final ValueChanged<NewsArticle> onArticleTap;

  @override
  Widget build(BuildContext context) {
    return switch (snapshot.screenState) {
      NewsScreenState.loading => const VitSkeletonList(
        key: NewsPage.loadingKey,
        rows: 4,
      ),
      NewsScreenState.error => VitErrorState(
        key: NewsPage.errorKey,
        title: 'Không tải được tin tức',
        message: 'Kiểm tra kết nối và thử lại.',
        actionLabel: 'Thử lại',
        onAction: onRetry,
      ),
      NewsScreenState.empty ||
      NewsScreenState.offline when snapshot.articles.isEmpty =>
        VitEmptyState(
          key: NewsPage.emptyKey,
          icon: Icons.newspaper_rounded,
          title: 'Không có tin tức nào',
          message: activeType == null
              ? 'Hãy quay lại sau để xem cập nhật mới.'
              : 'Không có tin thuộc danh mục đã chọn.',
        ),
      _ => _NewsArticleFeed(
        snapshot: snapshot,
        onArticleTap: onArticleTap,
      ),
    };
  }
}

class _NewsArticleFeed extends StatelessWidget {
  const _NewsArticleFeed({
    required this.snapshot,
    required this.onArticleTap,
  });

  final NewsScreenSnapshot snapshot;
  final ValueChanged<NewsArticle> onArticleTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (snapshot.pinnedArticles.isNotEmpty)
          VitPageSection(
            density: VitDensity.compact,
            children: [
              VitModuleSectionHeader(
                title: 'GHIM (${snapshot.pinnedArticles.length})',
                accentColor: AppColors.primary,
              ),
              for (final article in snapshot.pinnedArticles)
                _NewsArticleCard(
                  key: NewsPage.articleCardKey(article.id),
                  article: article,
                  pinned: true,
                  onTap: () => onArticleTap(article),
                ),
            ],
          ),
        if (snapshot.normalArticles.isNotEmpty)
          VitPageSection(
            density: VitDensity.compact,
            children: [
              const VitModuleSectionHeader(
                title: 'TIN TỨC KHÁC',
                accentColor: AppColors.text2,
              ),
              for (final article in snapshot.normalArticles)
                _NewsArticleCard(
                  key: NewsPage.articleCardKey(article.id),
                  article: article,
                  onTap: () => onArticleTap(article),
                ),
            ],
          ),
      ],
    );
  }
}

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
              selectedColor: AppColors.primary,
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
    return VitChoicePill(
      label: label,
      selected: selected,
      onTap: onTap,
      height: AppSpacing.newsFilterChipHeight,
      accentColor: selectedColor,
      padding: AppSpacing.newsFilterChipPadding,
      semanticLabel: label,
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
          ? AppColors.primary.withValues(alpha: .28)
          : AppColors.cardBorder,
      density: VitDensity.compact,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TypeAvatar(type: type),
              const SizedBox(width: AppSpacing.x2),
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
                    const SizedBox(height: AppSpacing.x1),
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
            const SizedBox(height: AppSpacing.x2),
            Wrap(
              spacing: AppSpacing.x3,
              runSpacing: AppSpacing.x2 + 1,
              children: [
                for (final tag in article.tags)
                  VitStatusPill(
                    label: tag,
                    status: VitStatusPillStatus.neutral,
                    size: VitStatusPillSize.sm,
                    icon: Icons.sell_outlined,
                  ),
              ],
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
          const Icon(
            Icons.push_pin_rounded,
            size: AppSpacing.newsSheetCalendarIconSize,
            color: AppColors.primary,
          ),
        VitAccentPill(
          label: type.label,
          accentColor: type.color,
          size: VitStatusPillSize.sm,
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
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
        ),
        child: Center(
          child: Text(type.emoji, style: AppTextStyles.sectionTitleSm),
        ),
      ),
    );
  }
}
