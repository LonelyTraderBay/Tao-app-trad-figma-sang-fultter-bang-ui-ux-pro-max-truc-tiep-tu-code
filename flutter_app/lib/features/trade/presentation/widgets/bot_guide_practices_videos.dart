part of '../pages/bot_guide_page.dart';

class _BestPracticesView extends StatelessWidget {
  const _BestPracticesView({required this.items});

  final List<TradeBotGuidePractice> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Best Practices'),
        const SizedBox(height: 10),
        for (final item in items) ...[
          _InfoCard(
            icon: _practiceIcon(item.iconKey),
            iconColor: _guidePrimary,
            title: item.title,
            description: item.description,
          ),
          if (item != items.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _MistakesView extends StatelessWidget {
  const _MistakesView({required this.items});

  final List<TradeBotGuideMistake> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Common Mistakes to Avoid'),
        const SizedBox(height: 10),
        for (final item in items) ...[
          _MistakeCard(item: item),
          if (item != items.last) const SizedBox(height: 12),
        ],
      ],
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
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 27),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "WHY IT'S BAD:",
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.why,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 9),
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: _guideGreen.withValues(alpha: .08),
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HOW TO FIX:',
                        style: AppTextStyles.micro.copyWith(
                          color: _guideGreen,
                          fontSize: 10,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.fix,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontSize: 11,
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
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 14),
      decoration: BoxDecoration(
        color: _guidePanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Watch our step-by-step video guides to master each bot strategy.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _guidePrimary,
              borderRadius: AppRadii.cardRadius,
            ),
            child: Text(
              'View All Tutorials',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.onAccent,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
