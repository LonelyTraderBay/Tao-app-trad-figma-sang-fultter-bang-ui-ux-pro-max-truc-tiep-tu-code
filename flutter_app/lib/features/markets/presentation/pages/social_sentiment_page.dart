import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import '../widgets/market_body_review_widgets.dart';

part '../widgets/social_sentiment_tabs_widgets.dart';
part '../widgets/social_sentiment_overview_widgets.dart';
part '../widgets/social_sentiment_token_widgets.dart';
part '../widgets/social_sentiment_trends_widgets.dart';

const _marketPrimary = AppColors.primary;

class SocialSentimentPage extends ConsumerStatefulWidget {
  const SocialSentimentPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc020_social_sentiment_scroll_content');
  static const overviewTabKey = Key('sc020_tab_overview');
  static const tokenTabKey = Key('sc020_tab_token');
  static const trendsTabKey = Key('sc020_tab_trends');

  static Key sortKey(MarketSentimentSort sort) =>
      Key('sc020_sort_${sort.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SocialSentimentPage> createState() =>
      _SocialSentimentPageState();
}

class _SocialSentimentPageState extends ConsumerState<SocialSentimentPage> {
  String _tab = 'overview';
  MarketSentimentSort _sortBy = MarketSentimentSort.sentiment;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(marketControllerProvider)
        .getSocialSentiment(sortBy: _sortBy);
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
      semanticLabel: 'SC-020 SocialSentimentPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Tâm lý thị trường',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.markets),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SentimentTabs(
                activeTab: _tab,
                onChanged: (value) => setState(() => _tab = value),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: SocialSentimentPage.contentKey,
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.relaxed,
                      customGap: 12,
                      children: [
                        if (_tab == 'overview') ...[
                          _SentimentHero(global: snapshot.global),
                          _SentimentStats(global: snapshot.global),
                          _SocialDominanceCard(global: snapshot.global),
                          _SectionHeader(
                            label: 'Diễn biến 7 ngày',
                            accentColor: _marketPrimary,
                          ),
                          _TimelineCard(points: snapshot.timeline),
                          _SectionHeader(
                            label: 'Top Trending',
                            accentColor: AppColors.warn,
                          ),
                          _TrendingList(
                            tokens: snapshot.trendingTokens.take(4).toList(),
                          ),
                        ] else if (_tab == 'token') ...[
                          _SentimentSortChips(
                            active: _sortBy,
                            onSelected: (value) => setState(() {
                              _sortBy = value;
                            }),
                          ),
                          for (final token in snapshot.tokens)
                            _TokenDetailCard(token: token),
                        ] else ...[
                          _TopicCloud(tokens: snapshot.tokens),
                          _SectionHeader(
                            label: 'Sentiment Heatmap',
                            accentColor: AppColors.accent,
                          ),
                          _SentimentHeatmap(tokens: snapshot.tokens),
                          _TrendLeaderboards(tokens: snapshot.tokens),
                          _SectionHeader(
                            label: 'Tốc độ đề cập (24h)',
                            accentColor: AppAssetColors.cyanChain,
                          ),
                          _MentionVelocity(tokens: snapshot.tokens),
                        ],
                        const MarketBodyReviewSection(
                          title: 'Sentiment state review',
                          message: 'Social sentiment data reviewed',
                          detail:
                              'Overview, token ranking, trend, empty, and refresh states remain visible for sentiment review.',
                          primary:
                              'Global sentiment stays separated from token-level rankings.',
                          secondary:
                              'Sort and trend controls keep social data comparable across tabs.',
                          tertiary:
                              'Mention velocity and heatmap panels remain informational, not execution prompts.',
                        ),
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
}
