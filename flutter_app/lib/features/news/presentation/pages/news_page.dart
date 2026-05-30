import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/news_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

const _newsPrimary = AppColors.primary;

extension _NewsArticleTypePresentationColor on NewsArticleType {
  Color get color => switch (this) {
    NewsArticleType.maintenance => AppColors.textMutedBlue,
    NewsArticleType.newFeature => AppColors.info,
    NewsArticleType.promotion => AppColors.buy,
    NewsArticleType.security => AppColors.sell,
    NewsArticleType.listing => AppColors.caution,
    NewsArticleType.general => AppColors.accent,
  };
}

class NewsPage extends ConsumerStatefulWidget {
  const NewsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc047_news_scroll_content');
  static const filterAllKey = Key('sc047_filter_all');
  static const closeSheetKey = Key('sc047_close_sheet');

  static Key filterKey(NewsArticleType type) =>
      Key('sc047_filter_${type.name}');
  static Key articleCardKey(String id) => Key('sc047_article_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends ConsumerState<NewsPage> {
  NewsArticleType? _activeType;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(newsControllerProvider)
        .getNews(type: _activeType);
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
      semanticLabel: 'SC-047 NewsPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Tin tức & Thông báo',
              subtitle: 'Tin tức · Cập nhật',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.home),
            ),
            _NewsFilterBar(
              activeType: _activeType,
              filters: snapshot.newsReferenceData.filters,
              onSelected: (type) => setState(() {
                _activeType = type;
              }),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: NewsPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 12,
                    children: [
                      if (snapshot.screenState == NewsScreenState.empty)
                        const _NewsEmptyState()
                      else ...[
                        if (snapshot.pinnedArticles.isNotEmpty) ...[
                          _SectionLabel(
                            icon: Icons.push_pin_rounded,
                            label: 'GHIM (${snapshot.pinnedArticles.length})',
                            color: _newsPrimary,
                          ),
                          for (final article in snapshot.pinnedArticles)
                            _NewsArticleCard(
                              key: NewsPage.articleCardKey(article.id),
                              article: article,
                              pinned: true,
                              onTap: () => _showArticleSheet(context, article),
                            ),
                        ],
                        if (snapshot.normalArticles.isNotEmpty) ...[
                          const SizedBox(height: 18),
                          const _SectionLabel(label: 'TIN TỨC KHÁC'),
                          for (final article in snapshot.normalArticles)
                            _NewsArticleCard(
                              key: NewsPage.articleCardKey(article.id),
                              article: article,
                              onTap: () => _showArticleSheet(context, article),
                            ),
                        ],
                      ],
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

  void _showArticleSheet(BuildContext context, NewsArticle article) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      useSafeArea: true,
      barrierColor: AppColors.dynamicIslandBg.withValues(alpha: .80),
      backgroundColor: AppColors.transparent,
      builder: (context) => _ArticleSheet(article: article),
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
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: pinned
                ? _newsPrimary.withValues(alpha: .06)
                : AppColors.cardBg,
            border: Border.all(
              color: pinned
                  ? _newsPrimary.withValues(alpha: .28)
                  : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.cardRadius,
          ),
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
                  children: [
                    for (final tag in article.tags) _TagChip(label: tag),
                  ],
                ),
              ],
            ],
          ),
        ),
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

class _ArticleSheet extends StatelessWidget {
  const _ArticleSheet({required this.article});

  final NewsArticle article;

  @override
  Widget build(BuildContext context) {
    final type = article.type;
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * .85,
          ),
          decoration: const BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.borderSolid,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            type.emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: type.color.withValues(alpha: .18),
                              borderRadius: AppRadii.mdRadius,
                            ),
                            child: Text(
                              type.label,
                              style: AppTextStyles.caption.copyWith(
                                color: type.color,
                                fontSize: 12,
                                fontWeight: AppTextStyles.bold,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        article.title,
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontSize: 22,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 13,
                            color: AppColors.text2,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            article.publishedAtLabel,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _newsPrimary.withValues(alpha: .06),
                          border: Border.all(
                            color: _newsPrimary.withValues(alpha: .12),
                          ),
                          borderRadius: AppRadii.lgRadius,
                        ),
                        child: Text(
                          article.summary,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text2,
                            fontStyle: FontStyle.italic,
                            height: 1.45,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        article.content,
                        style: AppTextStyles.body.copyWith(height: 1.7),
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final tag in article.tags) _TagChip(label: tag),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: AppSpacing.inputHeight,
                        child: FilledButton(
                          key: NewsPage.closeSheetKey,
                          onPressed: () => Navigator.of(context).pop(),
                          style: FilledButton.styleFrom(
                            backgroundColor: _newsPrimary,
                            foregroundColor: AppColors.onAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadii.lgRadius,
                            ),
                          ),
                          child: Text(
                            'Đóng',
                            style: AppTextStyles.baseMedium.copyWith(
                              color: AppColors.onAccent,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
