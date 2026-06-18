part of '../pages/bot_guide_page.dart';

class _BestPracticesView extends StatelessWidget {
  const _BestPracticesView({required this.items});

  final List<TradeBotGuidePractice> items;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Best Practices',
      customGap: AppSpacing.tradeBotCardGap,
      children: [
        for (final item in items)
          _InfoCard(
            icon: _practiceIcon(item.iconKey),
            iconColor: _guidePrimary,
            title: item.title,
            description: item.description,
          ),
      ],
    );
  }
}

class _MistakesView extends StatelessWidget {
  const _MistakesView({required this.items});

  final List<TradeBotGuideMistake> items;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Common Mistakes to Avoid',
      customGap: AppSpacing.tradeBotCardGap,
      children: [for (final item in items) _MistakeCard(item: item)],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.tradeBotCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: AppSpacing.tradeBotCardGap * 2),
          const SizedBox(width: AppSpacing.tradeBotCardIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.tradeBotTinyGap),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
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

class _MistakeCard extends StatelessWidget {
  const _MistakeCard({required this.item});

  final TradeBotGuideMistake item;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.tradeBotCardPadding,
      child: VitPageContent(
        padding: VitContentPadding.none,
        customGap: AppSpacing.tradeBotCardGap,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.cancel_outlined,
                color: _guideRed,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.tradeBotSmallGap),
              Expanded(
                child: Text(
                  item.mistake,
                  style: AppTextStyles.caption.copyWith(
                    color: _guideRed,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: AppSpacing.tradeBotMethodTextIndent),
              Expanded(
                child: VitPageContent(
                  padding: VitContentPadding.none,
                  customGap: AppSpacing.tradeBotRowGap,
                  children: [
                    Text(
                      "WHY IT'S BAD:",
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    Text(
                      item.why,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                    VitCard(
                      padding: AppSpacing.tradeBotCodeBlockCompactPadding,
                      variant: VitCardVariant.inner,
                      borderColor: _guideGreen.withValues(alpha: .24),
                      child: VitPageContent(
                        padding: VitContentPadding.none,
                        customGap: AppSpacing.hairlineStroke * 2,
                        children: [
                          Text(
                            'HOW TO FIX:',
                            style: AppTextStyles.micro.copyWith(
                              color: _guideGreen,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          Text(
                            item.fix,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                        ],
                      ),
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

class _VideoTutorialsCard extends StatelessWidget {
  const _VideoTutorialsCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.tradeBotCardPaddingLoose,
      variant: VitCardVariant.inner,
      child: VitPageContent(
        padding: VitContentPadding.none,
        customGap: AppSpacing.tradeBotRowGap,
        children: [
          Row(
            children: [
              const Icon(
                Icons.play_arrow_outlined,
                color: _guidePrimary,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.tradeBotCardIconGap),
              Text(
                'Video Tutorials',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          Text(
            'Watch our step-by-step video guides to master each bot strategy.',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          VitCtaButton(
            height: AppSpacing.buttonCompact,
            onPressed: () {},
            child: const Text('View All Tutorials'),
          ),
        ],
      ),
    );
  }
}
