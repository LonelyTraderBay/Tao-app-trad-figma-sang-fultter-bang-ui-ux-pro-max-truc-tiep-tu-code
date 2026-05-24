import 'dart:math' as math;

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
        .watch(marketRepositoryProvider)
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
        child: Column(
          children: [
            VitHeader(
              title: 'Tâm lý thị trường',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.markets),
            ),
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
                          accentColor: const Color(0xFF06B6D4),
                        ),
                        _MentionVelocity(tokens: snapshot.tokens),
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
}

class _SentimentTabs extends StatelessWidget {
  const _SentimentTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SizedBox(
        height: 54,
        child: Row(
          children: [
            _UnderlinedTab(
              key: SocialSentimentPage.overviewTabKey,
              label: 'Tổng quan',
              value: 'overview',
              active: activeTab == 'overview',
              onChanged: onChanged,
            ),
            _UnderlinedTab(
              key: SocialSentimentPage.tokenTabKey,
              label: 'Theo token',
              value: 'token',
              active: activeTab == 'token',
              onChanged: onChanged,
            ),
            _UnderlinedTab(
              key: SocialSentimentPage.trendsTabKey,
              label: 'Xu hướng',
              value: 'trends',
              active: activeTab == 'trends',
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _UnderlinedTab extends StatelessWidget {
  const _UnderlinedTab({
    super.key,
    required this.label,
    required this.value,
    required this.active,
    required this.onChanged,
  });

  final String label;
  final String value;
  final bool active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onChanged(value),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? _marketPrimary : AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 2,
              child: FractionallySizedBox(
                widthFactor: active ? 1 : 0,
                child: const ColoredBox(color: _marketPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SentimentHero extends StatelessWidget {
  const _SentimentHero({required this.global});

  final SocialSentimentGlobal global;

  @override
  Widget build(BuildContext context) {
    final scoreColor = _sentimentColor(global.overallScore);
    final gaugePct = ((global.overallScore + 100) / 2).clamp(0, 100) / 100;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.surface, AppColors.surface2],
        ),
        border: Border.all(color: _marketPrimary.withValues(alpha: .2)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Chỉ số tâm lý chung',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              Text(
                global.overallLabel,
                style: AppTextStyles.micro.copyWith(
                  color: scoreColor,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${global.overallScore}',
                style: AppTextStyles.heroNumber.copyWith(
                  color: scoreColor,
                  fontSize: 30,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  '/ 100',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              width: double.infinity,
              height: 8,
              child: Stack(
                children: [
                  Container(color: AppColors.surface2),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: gaugePct.toDouble(),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.sell,
                            AppColors.warn,
                            AppColors.buy,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cực sợ',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.sell,
                  fontSize: 8,
                ),
              ),
              Text(
                'Trung lập',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 8,
                ),
              ),
              Text(
                'Cực tham',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.buy,
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SentimentStats extends StatelessWidget {
  const _SentimentStats({required this.global});

  final SocialSentimentGlobal global;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.mode_comment_outlined,
            iconColor: _marketPrimary,
            label: 'Lượt đề cập 24h',
            value: _formatCompact(global.totalMentions24h),
            sub: '+${global.mentionsChange.toStringAsFixed(2)}%',
            subColor: AppColors.buy,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            icon: Icons.tag_rounded,
            iconColor: AppColors.accent,
            label: 'Token trending',
            value: '${global.trendingTokens}',
            sub: 'trong 24h qua',
            subColor: AppColors.text3,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.sub,
    required this.subColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String sub;
  final Color subColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: iconColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(sub, style: AppTextStyles.micro.copyWith(color: subColor)),
        ],
      ),
    );
  }
}

class _SocialDominanceCard extends StatelessWidget {
  const _SocialDominanceCard({required this.global});

  final SocialSentimentGlobal global;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Social Dominance',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              width: double.infinity,
              height: 20,
              child: Row(
                children: [
                  Expanded(
                    flex: (global.socialDominanceBtc * 10).round(),
                    child: Container(color: const Color(0xFFF7931A)),
                  ),
                  Expanded(
                    flex: (global.socialDominanceEth * 10).round(),
                    child: Container(color: const Color(0xFF627EEA)),
                  ),
                  Expanded(
                    flex: (global.socialDominanceOther * 10).round(),
                    child: Container(color: AppColors.surface3),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _DominanceLegend(
                label: 'BTC ${global.socialDominanceBtc}%',
                color: const Color(0xFFF7931A),
              ),
              const SizedBox(width: 16),
              _DominanceLegend(
                label: 'ETH ${global.socialDominanceEth}%',
                color: const Color(0xFF627EEA),
              ),
              const SizedBox(width: 16),
              _DominanceLegend(
                label: 'Khác ${global.socialDominanceOther}%',
                color: const Color(0xFF1B2440),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DominanceLegend extends StatelessWidget {
  const _DominanceLegend({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.points});

  final List<SocialSentimentTimelinePoint> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        children: [
          for (final point in points)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  SizedBox(
                    width: 56,
                    child: Text(
                      point.time,
                      textAlign: TextAlign.right,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: SizedBox(
                        height: 6,
                        child: Stack(
                          children: [
                            Container(color: AppColors.surface2),
                            FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: ((point.score + 100) / 200)
                                  .clamp(0, 1)
                                  .toDouble(),
                              child: Container(
                                color: _sentimentColor(point.score),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 24,
                    child: Text(
                      '${point.score}',
                      textAlign: TextAlign.right,
                      style: AppTextStyles.micro.copyWith(
                        color: _sentimentColor(point.score),
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.accentColor});

  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _TrendingList extends StatelessWidget {
  const _TrendingList({required this.tokens});

  final List<SocialSentimentToken> tokens;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final token in tokens) ...[
          _SentimentRow(token: token),
          if (token != tokens.last) const SizedBox(height: 4),
        ],
      ],
    );
  }
}

class _SentimentRow extends StatelessWidget {
  const _SentimentRow({required this.token});

  final SocialSentimentToken token;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: token.color.withValues(alpha: .16),
              shape: BoxShape.circle,
            ),
            child: Text(
              token.symbol.substring(0, math.min(2, token.symbol.length)),
              style: AppTextStyles.caption.copyWith(
                color: token.color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                    children: [
                      TextSpan(text: token.symbol),
                      if (token.trendingRank != null)
                        TextSpan(
                          text: '  🔥 #${token.trendingRank}',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.warn,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  '${_formatCompact(token.mentions24h)} đề cập',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${token.sentimentScore}',
                style: AppTextStyles.baseMedium.copyWith(
                  color: _sentimentColor(token.sentimentScore),
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _sentimentColor(token.sentimentScore),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _sentimentColor(
                        token.sentimentScore,
                      ).withValues(alpha: .35),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SentimentSortChips extends StatelessWidget {
  const _SentimentSortChips({required this.active, required this.onSelected});

  final MarketSentimentSort active;
  final ValueChanged<MarketSentimentSort> onSelected;

  @override
  Widget build(BuildContext context) {
    const chips = {
      MarketSentimentSort.sentiment: 'Sentiment',
      MarketSentimentSort.mentions: 'Mentions',
      MarketSentimentSort.trending: 'Trending',
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final entry in chips.entries) ...[
            _SortChip(
              key: SocialSentimentPage.sortKey(entry.key),
              label: entry.value,
              active: active == entry.key,
              onTap: () => onSelected(entry.key),
            ),
            if (entry.key != chips.keys.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
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
          color: active ? AppColors.primary15 : AppColors.surface2,
          border: Border.all(
            color: active ? AppColors.primary30 : Colors.transparent,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? AppColors.primarySoft : AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _TokenDetailCard extends StatelessWidget {
  const _TokenDetailCard({required this.token});

  final SocialSentimentToken token;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: token.color.withValues(alpha: .16),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  token.symbol.substring(0, math.min(2, token.symbol.length)),
                  style: AppTextStyles.caption.copyWith(
                    color: token.color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      token.symbol,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      token.name,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${token.sentimentScore}',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: _sentimentColor(token.sentimentScore),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: double.infinity,
              height: 6,
              child: Row(
                children: [
                  Expanded(
                    flex: token.bullishPct,
                    child: Container(color: AppColors.buy),
                  ),
                  Expanded(
                    flex: token.neutralPct,
                    child: Container(color: AppColors.text3),
                  ),
                  Expanded(
                    flex: token.bearishPct,
                    child: Container(color: AppColors.sell),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _TokenMetric('Đề cập 24h', _formatCompact(token.mentions24h)),
              _TokenMetric('Twitter', _formatCompact(token.twitterFollowers)),
              _TokenMetric('Telegram', _formatCompact(token.telegramMembers)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TokenMetric extends StatelessWidget {
  const _TokenMetric(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicCloud extends StatelessWidget {
  const _TopicCloud({required this.tokens});

  final List<SocialSentimentToken> tokens;

  @override
  Widget build(BuildContext context) {
    final topics = <String>{};
    for (final token in tokens) {
      topics.addAll(token.topTopics);
    }
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final topic in topics)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface2,
                borderRadius: AppRadii.cardRadius,
              ),
              child: Text(
                '#$topic',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
        ],
      ),
    );
  }
}

class _SentimentHeatmap extends StatelessWidget {
  const _SentimentHeatmap({required this.tokens});

  final List<SocialSentimentToken> tokens;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 6,
      mainAxisSpacing: 6,
      childAspectRatio: .95,
      children: [
        for (final token in tokens)
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _sentimentColor(
                token.sentimentScore,
              ).withValues(alpha: .07),
              border: Border.all(
                color: _sentimentColor(
                  token.sentimentScore,
                ).withValues(alpha: .16),
              ),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  token.symbol,
                  style: AppTextStyles.caption.copyWith(
                    color: token.color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '${token.sentimentScore}',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: _sentimentColor(token.sentimentScore),
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _TrendLeaderboards extends StatelessWidget {
  const _TrendLeaderboards({required this.tokens});

  final List<SocialSentimentToken> tokens;

  @override
  Widget build(BuildContext context) {
    final positive = [...tokens]
      ..sort((a, b) => b.sentimentScore.compareTo(a.sentimentScore));
    final negative = [...tokens]
      ..sort((a, b) => a.sentimentScore.compareTo(b.sentimentScore));
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _LeaderboardColumn(
            label: 'Tích cực nhất',
            color: AppColors.buy,
            tokens: positive.take(4).toList(),
            positive: true,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _LeaderboardColumn(
            label: 'Tiêu cực nhất',
            color: AppColors.sell,
            tokens: negative.take(4).toList(),
            positive: false,
          ),
        ),
      ],
    );
  }
}

class _LeaderboardColumn extends StatelessWidget {
  const _LeaderboardColumn({
    required this.label,
    required this.color,
    required this.tokens,
    required this.positive,
  });

  final String label;
  final Color color;
  final List<SocialSentimentToken> tokens;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(label: label, accentColor: color),
        const SizedBox(height: 8),
        for (var index = 0; index < tokens.length; index += 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadii.mdRadius,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    child: Text(
                      '${index + 1}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      tokens[index].symbol,
                      style: AppTextStyles.caption.copyWith(
                        color: tokens[index].color,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${positive ? '+' : ''}${tokens[index].sentimentScore}',
                    style: AppTextStyles.caption.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _MentionVelocity extends StatelessWidget {
  const _MentionVelocity({required this.tokens});

  final List<SocialSentimentToken> tokens;

  @override
  Widget build(BuildContext context) {
    final sorted = [...tokens]
      ..sort((a, b) => b.mentionsChange.compareTo(a.mentionsChange));
    final maxChange = sorted.fold<double>(
      0,
      (maxValue, token) => math.max(maxValue, token.mentionsChange.abs()),
    );
    return Column(
      children: [
        for (final token in sorted.take(5)) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 44,
                  child: Text(
                    token.symbol,
                    style: AppTextStyles.caption.copyWith(
                      color: token.color,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: SizedBox(
                      height: 5,
                      child: Stack(
                        children: [
                          Container(color: AppColors.surface2),
                          FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: maxChange == 0
                                ? 0
                                : token.mentionsChange.abs() / maxChange,
                            child: Container(
                              color: token.mentionsChange >= 0
                                  ? AppColors.buy
                                  : AppColors.sell,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 52,
                  child: Text(
                    '${token.mentionsChange >= 0 ? '+' : ''}${token.mentionsChange.toStringAsFixed(1)}%',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.caption.copyWith(
                      color: token.mentionsChange >= 0
                          ? AppColors.buy
                          : AppColors.sell,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (token != sorted.take(5).last) const SizedBox(height: 4),
        ],
      ],
    );
  }
}

Color _sentimentColor(int score) {
  if (score >= 60) return AppColors.buy;
  if (score >= 30) return _marketPrimary;
  if (score >= -10) return AppColors.text3;
  if (score >= -40) return AppColors.warn;
  return AppColors.sell;
}

String _formatCompact(double value) {
  if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(2)}M';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toStringAsFixed(0);
}
