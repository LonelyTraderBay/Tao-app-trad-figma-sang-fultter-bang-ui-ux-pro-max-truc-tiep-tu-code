part of '../pages/social_sentiment_page.dart';

class _TrendingList extends StatelessWidget {
  const _TrendingList({required this.tokens});

  final List<SocialSentimentToken> tokens;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final token in tokens) ...[
          _SentimentRow(token: token),
          if (token != tokens.last)
            const SizedBox(height: AppSpacing.socialSentimentListGap),
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
      padding: AppSpacing.socialSentimentRowPadding,
      child: Row(
        children: [
          CircleAvatar(
            radius: AppSpacing.socialSentimentAvatarLg / 2,
            backgroundColor: token.color.withValues(alpha: .16),
            child: Text(
              token.symbol.substring(0, math.min(2, token.symbol.length)),
              style: AppTextStyles.caption.copyWith(
                color: token.color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.socialSentimentRowGap),
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
              Icon(
                Icons.circle,
                color: _sentimentColor(token.sentimentScore),
                size: AppSpacing.socialSentimentStatusDot,
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
            if (entry.key != chips.keys.last)
              const SizedBox(width: AppSpacing.socialSentimentSortGap),
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
    return Material(
      color: active ? AppColors.primary15 : AppColors.surface2,
      borderRadius: AppRadii.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: Padding(
          padding: AppSpacing.socialSentimentSortChipPadding,
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: active ? AppColors.primarySoft : AppColors.text3,
              fontWeight: AppTextStyles.medium,
            ),
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
      padding: AppSpacing.socialSentimentTokenDetailPadding,
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: AppSpacing.socialSentimentAvatarMd / 2,
                backgroundColor: token.color.withValues(alpha: .16),
                child: Text(
                  token.symbol.substring(0, math.min(2, token.symbol.length)),
                  style: AppTextStyles.caption.copyWith(
                    color: token.color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.socialSentimentRowGap),
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
          const SizedBox(height: AppSpacing.socialSentimentRowGap),
          ClipRRect(
            borderRadius: AppRadii.smRadius,
            child: SizedBox(
              width: double.infinity,
              height: AppSpacing.socialSentimentSplitBarHeight,
              child: Row(
                children: [
                  Expanded(
                    flex: token.bullishPct,
                    child: const ColoredBox(color: AppColors.buy),
                  ),
                  Expanded(
                    flex: token.neutralPct,
                    child: const ColoredBox(color: AppColors.text3),
                  ),
                  Expanded(
                    flex: token.bearishPct,
                    child: const ColoredBox(color: AppColors.sell),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.socialSentimentTokenMetricGap),
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
