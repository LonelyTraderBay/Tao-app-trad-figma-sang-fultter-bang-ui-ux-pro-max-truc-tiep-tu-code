import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/news_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part '../widgets/news_page_sections.dart';
part '../widgets/news_page_common.dart';

const _newsPrimary = AppColors.primary;
const _visualNavClearance = 90.0;
const _nativeNavClearance = 72.0;
const _visualScrollExtra = 54.0;
const _nativeScrollExtra = 20.0;
const _newsFilterBarHeight = 52.0;
const _newsFilterChipHeight = 30.0;
const _newsArticleAvatarSize = 34.0;
const _newsEmptyIconSize = 36.0;
const _newsTightLineHeight = 1.0;
const _newsTitleLineHeight = 1.12;
const _newsSummaryLineHeight = 1.2;
const _newsSheetHandleHeight = 4.0;
const _newsSheetTitleLineHeight = 1.18;
const _newsSheetSummaryLineHeight = 1.28;
const _newsSheetBodyLineHeight = 1.42;

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
    final navClearance = mode.usesVisualQaFrame
        ? _visualNavClearance
        : _nativeNavClearance;
    final scrollEndPadding =
        navClearance +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? _visualScrollExtra : _nativeScrollExtra);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-047 NewsPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Tin tức & Thông báo',
            subtitle: 'Tin tức · Cập nhật',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.home),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                    padding: EdgeInsets.only(bottom: scrollEndPadding),
                    child: VitPageContent(
                      density: VitDensity.compact,
                      children: [
                        if (snapshot.screenState == NewsScreenState.empty)
                          const _NewsEmptyState()
                        else ...[
                          if (snapshot.pinnedArticles.isNotEmpty)
                            VitPageSection(
                              density: VitDensity.compact,
                              children: [
                                VitModuleSectionHeader(
                                  title:
                                      'GHIM (${snapshot.pinnedArticles.length})',
                                  accentColor: _newsPrimary,
                                ),
                                for (final article in snapshot.pinnedArticles)
                                  _NewsArticleCard(
                                    key: NewsPage.articleCardKey(article.id),
                                    article: article,
                                    pinned: true,
                                    onTap: () =>
                                        _showArticleSheet(context, article),
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
                                    onTap: () =>
                                        _showArticleSheet(context, article),
                                  ),
                              ],
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showArticleSheet(BuildContext context, NewsArticle article) {
    showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      barrierColor: AppColors.dynamicIslandBg.withValues(alpha: .80),
      backgroundColor: AppColors.transparent,
      builder: (context) => _ArticleSheet(article: article),
    );
  }
}
