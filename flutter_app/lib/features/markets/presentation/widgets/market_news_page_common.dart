part of '../pages/market_news_page.dart';

class _NewsCard extends StatelessWidget {
  const _NewsCard({
    super.key,
    required this.news,
    required this.category,
    required this.sentimentBadge,
    required this.expanded,
    required this.saved,
    required this.onToggleExpanded,
    required this.onToggleSaved,
    required this.onTokenTap,
  });

  final MarketNewsItem news;
  final MarketNewsCategory category;
  final MarketNewsSentimentBadge sentimentBadge;
  final bool expanded;
  final bool saved;
  final VoidCallback onToggleExpanded;
  final VoidCallback onToggleSaved;
  final ValueChanged<String> onTokenTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: news.isBreaking
          ? AppColors.sell.withValues(alpha: .18)
          : null,
      clip: true,
      child: Column(
        children: [
          InkWell(
            onTap: onToggleExpanded,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _NewsIcon(item: news, category: category),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _NewsTags(
                          news: news,
                          category: category,
                          sentimentBadge: sentimentBadge,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          news.title,
                          maxLines: expanded ? 4 : 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _NewsMeta(news: news),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    key: MarketNewsPage.saveKey(news.id),
                    onTap: onToggleSaved,
                    borderRadius: AppRadii.cardRadius,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        saved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        size: 18,
                        color: saved ? _marketPrimary : AppColors.text3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            _ExpandedNewsDetails(news: news, onTokenTap: onTokenTap),
        ],
      ),
    );
  }
}

class _NewsIcon extends StatelessWidget {
  const _NewsIcon({required this.item, required this.category});

  final MarketNewsItem item;
  final MarketNewsCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: category.color.withValues(alpha: .08),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(item.icon, size: 21, color: item.iconColor),
    );
  }
}

class _NewsTags extends StatelessWidget {
  const _NewsTags({
    required this.news,
    required this.category,
    required this.sentimentBadge,
  });

  final MarketNewsItem news;
  final MarketNewsCategory category;
  final MarketNewsSentimentBadge sentimentBadge;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        if (news.isBreaking)
          _TagPill(label: 'NÓNG', color: AppColors.sell, strong: true),
        _TagPill(label: category.label, color: category.color, strong: true),
        _TagPill(
          label: sentimentBadge.label,
          color: sentimentBadge.color,
          icon: _sentimentIcon(news.sentiment),
        ),
      ],
    );
  }
}

class _TagPill extends StatelessWidget {
  const _TagPill({
    required this.label,
    required this.color,
    this.icon,
    this.strong = false,
  });

  final String label;
  final Color color;
  final IconData? icon;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: strong ? .16 : .08),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 8, color: color),
            const SizedBox(width: 2),
          ],
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: strong ? AppTextStyles.bold : AppTextStyles.medium,
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsMeta extends StatelessWidget {
  const _NewsMeta({required this.news});

  final MarketNewsItem news;

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.micro.copyWith(color: AppColors.text3);
    return Row(
      children: [
        Flexible(
          child: Text(
            news.source,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
        _MetaSeparator(style: style),
        const Icon(Icons.schedule_rounded, size: 10, color: AppColors.text3),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            news.timeAgo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
        _MetaSeparator(style: style),
        Flexible(
          child: Text(
            news.readTime,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ],
    );
  }
}

class _MetaSeparator extends StatelessWidget {
  const _MetaSeparator({required this.style});

  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Text('•', style: style),
    );
  }
}

class _ExpandedNewsDetails extends StatelessWidget {
  const _ExpandedNewsDetails({required this.news, required this.onTokenTap});

  final MarketNewsItem news;
  final ValueChanged<String> onTokenTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderSolid)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            news.summary,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Liên quan:',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              for (final token in news.relatedTokens)
                InkWell(
                  key: MarketNewsPage.tokenKey(token),
                  onTap: () => onTokenTap(token),
                  borderRadius: AppRadii.mdRadius,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface2,
                      border: Border.all(color: AppColors.borderSolid),
                      borderRadius: AppRadii.mdRadius,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          token,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 14,
                          color: AppColors.text3,
                        ),
                      ],
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

class _NewsEmptyState extends StatelessWidget {
  const _NewsEmptyState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          const Icon(Icons.article_outlined, size: 40, color: AppColors.text3),
          const SizedBox(height: 12),
          Text(
            'Không có tin tức phù hợp',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: onReset,
            borderRadius: AppRadii.cardRadius,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _marketPrimary.withValues(alpha: .12),
                borderRadius: AppRadii.cardRadius,
              ),
              child: Text(
                'Xem tất cả',
                style: AppTextStyles.caption.copyWith(
                  color: _marketPrimary,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

IconData _sentimentIcon(MarketNewsSentiment sentiment) {
  return switch (sentiment) {
    MarketNewsSentiment.bullish => Icons.trending_up_rounded,
    MarketNewsSentiment.neutral => Icons.remove_rounded,
    MarketNewsSentiment.bearish => Icons.trending_down_rounded,
  };
}
