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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';

part '../widgets/news_page_sections.dart';
part '../widgets/news_page_common.dart';

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
                                onTap: () =>
                                    _showArticleSheet(context, article),
                              ),
                          ],
                          if (snapshot.normalArticles.isNotEmpty) ...[
                            const SizedBox(height: 18),
                            const _SectionLabel(label: 'TIN TỨC KHÁC'),
                            for (final article in snapshot.normalArticles)
                              _NewsArticleCard(
                                key: NewsPage.articleCardKey(article.id),
                                article: article,
                                onTap: () =>
                                    _showArticleSheet(context, article),
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
