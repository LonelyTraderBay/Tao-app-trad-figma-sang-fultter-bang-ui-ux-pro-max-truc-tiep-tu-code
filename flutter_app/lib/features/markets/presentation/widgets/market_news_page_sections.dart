part of '../pages/market_news_page.dart';

class _BreakingNewsCard extends StatelessWidget {
  const _BreakingNewsCard({required this.news});

  final MarketNewsItem news;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.sell.withValues(alpha: .28),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.sell.withValues(alpha: .16),
                  borderRadius: AppRadii.smRadius,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.sell,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'NÓNG',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.sell,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                news.timeAgo,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            news.title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1.38,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              for (final token in news.relatedTokens)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: Text(
                    token,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryFilters extends StatelessWidget {
  const _CategoryFilters({
    required this.categories,
    required this.activeCategory,
    required this.onSelected,
  });

  final List<MarketNewsCategory> categories;
  final String activeCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (final category in categories) ...[
            _CategoryChip(
              key: category.id == 'all'
                  ? MarketNewsPage.categoryAllKey
                  : category.id == 'breaking'
                  ? MarketNewsPage.categoryBreakingKey
                  : null,
              category: category,
              active: activeCategory == category.id,
              onTap: () => onSelected(category.id),
            ),
            if (category != categories.last) const SizedBox(width: 8),
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
    required this.active,
    required this.onTap,
  });

  final MarketNewsCategory category;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? category.color.withValues(alpha: .14)
              : AppColors.surface2,
          border: Border.all(
            color: active
                ? category.color.withValues(alpha: .32)
                : AppColors.transparent,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          category.label,
          style: AppTextStyles.caption.copyWith(
            color: active ? category.color : AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _SentimentFilters extends StatelessWidget {
  const _SentimentFilters({
    required this.badges,
    required this.active,
    required this.onSelected,
  });

  final Map<MarketNewsSentiment, MarketNewsSentimentBadge> badges;
  final MarketNewsSentiment? active;
  final ValueChanged<MarketNewsSentiment> onSelected;

  @override
  Widget build(BuildContext context) {
    const order = [
      MarketNewsSentiment.bullish,
      MarketNewsSentiment.neutral,
      MarketNewsSentiment.bearish,
    ];
    return Row(
      children: [
        for (final sentiment in order) ...[
          _SentimentChip(
            key: sentiment == MarketNewsSentiment.bullish
                ? MarketNewsPage.sentimentBullishKey
                : sentiment == MarketNewsSentiment.bearish
                ? MarketNewsPage.sentimentBearishKey
                : null,
            sentiment: sentiment,
            badge: badges[sentiment]!,
            active: active == sentiment,
            onTap: () => onSelected(sentiment),
          ),
          if (sentiment != order.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _SentimentChip extends StatelessWidget {
  const _SentimentChip({
    super.key,
    required this.sentiment,
    required this.badge,
    required this.active,
    required this.onTap,
  });

  final MarketNewsSentiment sentiment;
  final MarketNewsSentimentBadge badge;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: active
              ? badge.color.withValues(alpha: .12)
              : AppColors.transparent,
          border: Border.all(
            color: active
                ? badge.color.withValues(alpha: .32)
                : AppColors.borderSolid,
          ),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_sentimentIcon(sentiment), size: 12, color: badge.color),
            const SizedBox(width: 5),
            Text(
              badge.label,
              style: AppTextStyles.micro.copyWith(
                color: active ? badge.color : AppColors.text3,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewsFeed extends StatelessWidget {
  const _NewsFeed({
    required this.news,
    required this.categories,
    required this.badges,
    required this.savedIds,
    required this.expandedId,
    required this.onToggleExpanded,
    required this.onToggleSaved,
    required this.onTokenTap,
  });

  final List<MarketNewsItem> news;
  final List<MarketNewsCategory> categories;
  final Map<MarketNewsSentiment, MarketNewsSentimentBadge> badges;
  final Set<String> savedIds;
  final String? expandedId;
  final ValueChanged<String> onToggleExpanded;
  final ValueChanged<String> onToggleSaved;
  final ValueChanged<String> onTokenTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in news) ...[
          _NewsCard(
            key: MarketNewsPage.newsCardKey(item.id),
            news: item,
            category: categories.firstWhere(
              (category) => category.id == item.category,
              orElse: () => categories.first,
            ),
            sentimentBadge: badges[item.sentiment]!,
            expanded: expandedId == item.id,
            saved: savedIds.contains(item.id),
            onToggleExpanded: () => onToggleExpanded(item.id),
            onToggleSaved: () => onToggleSaved(item.id),
            onTokenTap: onTokenTap,
          ),
          if (item != news.last) const SizedBox(height: 6),
        ],
      ],
    );
  }
}
