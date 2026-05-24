import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/market_repository.dart';

const _marketPrimary = AppColors.primary;

class MarketNewsPage extends ConsumerStatefulWidget {
  const MarketNewsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc022_market_news_scroll_content');
  static const categoryAllKey = Key('sc022_category_all');
  static const categoryBreakingKey = Key('sc022_category_breaking');
  static const sentimentBullishKey = Key('sc022_sentiment_bullish');
  static const sentimentBearishKey = Key('sc022_sentiment_bearish');

  static Key newsCardKey(String id) => Key('sc022_news_$id');
  static Key saveKey(String id) => Key('sc022_save_$id');
  static Key tokenKey(String token) => Key('sc022_token_$token');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MarketNewsPage> createState() => _MarketNewsPageState();
}

class _MarketNewsPageState extends ConsumerState<MarketNewsPage> {
  String _category = 'all';
  MarketNewsSentiment? _sentimentFilter;
  final Set<String> _savedIds = <String>{};
  String? _expandedId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(marketRepositoryProvider)
        .getMarketNews(category: _category, sentiment: _sentimentFilter);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-022 MarketNewsPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Tin thị trường',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.markets),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: MarketNewsPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 14,
                    children: [
                      if (snapshot.breakingNews.isNotEmpty &&
                          _category == 'all')
                        _BreakingNewsCard(news: snapshot.breakingNews.first),
                      _CategoryFilters(
                        categories: snapshot.categories,
                        activeCategory: _category,
                        onSelected: (value) => setState(() {
                          _category = value;
                        }),
                      ),
                      _SentimentFilters(
                        badges: snapshot.sentimentBadges,
                        active: _sentimentFilter,
                        onSelected: (value) => setState(() {
                          _sentimentFilter = _sentimentFilter == value
                              ? null
                              : value;
                        }),
                      ),
                      if (snapshot.news.isEmpty)
                        _NewsEmptyState(
                          onReset: () => setState(() {
                            _category = 'all';
                            _sentimentFilter = null;
                          }),
                        )
                      else
                        _NewsFeed(
                          news: snapshot.news,
                          categories: snapshot.categories,
                          badges: snapshot.sentimentBadges,
                          savedIds: _savedIds,
                          expandedId: _expandedId,
                          onToggleExpanded: (id) => setState(() {
                            _expandedId = _expandedId == id ? null : id;
                          }),
                          onToggleSaved: (id) => setState(() {
                            if (_savedIds.contains(id)) {
                              _savedIds.remove(id);
                            } else {
                              _savedIds.add(id);
                            }
                          }),
                          onTokenTap: (token) =>
                              context.go('/pair/${token.toLowerCase()}usdt'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
                : Colors.transparent,
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
              : Colors.transparent,
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
              fontSize: 8,
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
        Text(news.timeAgo, style: style),
        _MetaSeparator(style: style),
        Text(news.readTime, style: style),
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
      child: Text('•', style: style.copyWith(fontSize: 8)),
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
