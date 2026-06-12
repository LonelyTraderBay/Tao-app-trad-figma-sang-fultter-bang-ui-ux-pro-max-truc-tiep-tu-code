part of '../pages/social_sentiment_page.dart';

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
            borderRadius: AppRadii.xlRadius,
            child: SizedBox(
              width: double.infinity,
              height: 20,
              child: Row(
                children: [
                  Expanded(
                    flex: (global.socialDominanceBtc * 10).round(),
                    child: const ColoredBox(color: AppAssetColors.btc),
                  ),
                  Expanded(
                    flex: (global.socialDominanceEth * 10).round(),
                    child: const ColoredBox(color: AppAssetColors.eth),
                  ),
                  Expanded(
                    flex: (global.socialDominanceOther * 10).round(),
                    child: const ColoredBox(color: AppColors.surface3),
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
                color: AppAssetColors.btc,
              ),
              const SizedBox(width: 16),
              _DominanceLegend(
                label: 'ETH ${global.socialDominanceEth}%',
                color: AppAssetColors.eth,
              ),
              const SizedBox(width: 16),
              _DominanceLegend(
                label: 'Khác ${global.socialDominanceOther}%',
                color: AppAssetColors.other,
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
                      borderRadius: AppRadii.xlRadius,
                      child: SizedBox(
                        height: 6,
                        child: Stack(
                          children: [
                            const ColoredBox(
                              color: AppColors.surface2,
                              child: SizedBox.expand(),
                            ),
                            FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: ((point.score + 100) / 200)
                                  .clamp(0, 1)
                                  .toDouble(),
                              child: ColoredBox(
                                color: _sentimentColor(point.score),
                                child: const SizedBox.expand(),
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
            borderRadius: AppRadii.xlRadius,
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
