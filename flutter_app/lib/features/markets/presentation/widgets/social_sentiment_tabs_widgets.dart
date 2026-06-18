part of '../pages/social_sentiment_page.dart';

class _SentimentTabs extends StatelessWidget {
  const _SentimentTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: SizedBox(
        height: AppSpacing.socialSentimentTabsHeight,
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
              height: AppSpacing.socialSentimentTabIndicatorHeight,
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
    return VitCard(
      width: double.infinity,
      padding: AppSpacing.socialSentimentHeroPadding,
      borderColor: _marketPrimary.withValues(alpha: .2),
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
          const SizedBox(height: AppSpacing.socialSentimentHeroHeaderGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${global.overallScore}',
                style: AppTextStyles.heroNumber.copyWith(color: scoreColor),
              ),
              const SizedBox(width: AppSpacing.socialSentimentHeroScoreGap),
              Padding(
                padding: AppSpacing.socialSentimentHeroScorePadding,
                child: Text(
                  '/ 100',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.socialSentimentHeroGaugeGap),
          ClipRRect(
            borderRadius: AppRadii.xlRadius,
            child: SizedBox(
              width: double.infinity,
              height: AppSpacing.socialSentimentHeroGaugeHeight,
              child: Stack(
                children: [
                  const ColoredBox(
                    color: AppColors.surface2,
                    child: SizedBox.expand(),
                  ),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: gaugePct.toDouble(),
                    child: ColoredBox(
                      color: scoreColor,
                      child: SizedBox.expand(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.socialSentimentHeroLegendGap),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cực sợ',
                style: AppTextStyles.micro.copyWith(color: AppColors.sell),
              ),
              Text(
                'Trung lập',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              Text(
                'Cực tham',
                style: AppTextStyles.micro.copyWith(color: AppColors.buy),
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
        const SizedBox(width: AppSpacing.socialSentimentStatGap),
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
      padding: AppSpacing.socialSentimentStatPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: AppSpacing.socialSentimentStatIcon,
                color: iconColor,
              ),
              const SizedBox(width: AppSpacing.socialSentimentStatIconGap),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.socialSentimentStatValueGap),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.socialSentimentStatSubGap),
          Text(sub, style: AppTextStyles.micro.copyWith(color: subColor)),
        ],
      ),
    );
  }
}
