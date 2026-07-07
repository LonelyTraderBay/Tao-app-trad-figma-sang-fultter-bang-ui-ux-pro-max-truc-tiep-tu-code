import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/news_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/news_spacing_tokens.dart';

part '../widgets/news_page_sections.dart';
part '../widgets/news_page_common.dart';

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
  static const emptyKey = Key('sc047_news_empty');
  static const loadingKey = Key('sc047_news_loading');
  static const errorKey = Key('sc047_news_error');
  static const offlineKey = Key('sc047_news_offline');

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
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final showOfflineBanner =
        snapshot.screenState == NewsScreenState.offline &&
        snapshot.articles.isNotEmpty;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-047 NewsPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Tin tức & Thông báo',
            subtitle: 'Sản phẩm · bảo trì · niêm yết',
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
              if (showOfflineBanner)
                Padding(
                  key: NewsPage.offlineKey,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x3,
                    AppSpacing.contentPad,
                    0,
                  ),
                  child: const VitOfflineBanner(
                    message: 'Đang ngoại tuyến',
                    detail: 'Hiển thị tin tức đã lưu gần nhất.',
                  ),
                ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: NewsPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: NewsSpacingTokens.newsScrollPadding(bottomInset),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      density: VitDensity.compact,
                      children: _newsPageChildren(
                        snapshot: snapshot,
                        activeType: _activeType,
                        onRetry: () => setState(() {}),
                        onArticleTap: (article) =>
                            _showArticleSheet(context, article),
                      ),
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
