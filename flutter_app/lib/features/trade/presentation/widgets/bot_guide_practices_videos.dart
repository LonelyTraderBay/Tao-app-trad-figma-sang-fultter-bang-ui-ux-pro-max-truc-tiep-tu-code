part of '../pages/bot_guide_page.dart';

class _BestPracticesView extends StatelessWidget {
  const _BestPracticesView({required this.items});

  final List<TradeBotGuidePractice> items;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Best Practices',
      customGap: 12,
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
      customGap: 12,
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
    return _Card(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 30),
          const SizedBox(width: 13),
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
                const SizedBox(height: 5),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.55,
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
    return _Card(
      padding: const EdgeInsets.all(16),
      child: VitPageContent(
        padding: VitContentPadding.none,
        customGap: 12,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.cancel_outlined, color: _guideRed, size: 19),
              const SizedBox(width: 8),
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
          Padding(
            padding: const EdgeInsets.only(left: 27),
            child: VitPageContent(
              padding: VitContentPadding.none,
              customGap: 9,
              children: [
                Text(
                  "WHY IT'S BAD:",
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: 3),
                Text(
                  item.why,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                VitCard(
                  padding: const EdgeInsets.all(9),
                  variant: VitCardVariant.inner,
                  borderColor: _guideGreen.withValues(alpha: .24),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    customGap: 4,
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
                          height: 1.35,
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
    );
  }
}

class _VideoTutorialsCard extends StatelessWidget {
  const _VideoTutorialsCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 14),
      variant: VitCardVariant.inner,
      child: VitPageContent(
        padding: VitContentPadding.none,
        customGap: 10,
        children: [
          Row(
            children: [
              const Icon(
                Icons.play_arrow_outlined,
                color: _guidePrimary,
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                'Video Tutorials',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          Text(
            'Watch our step-by-step video guides to master each bot strategy.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.45,
            ),
          ),
          VitCtaButton(
            height: 32,
            onPressed: () {},
            child: const Text('View All Tutorials'),
          ),
        ],
      ),
    );
  }
}
