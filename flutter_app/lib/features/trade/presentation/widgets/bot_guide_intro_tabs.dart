part of '../pages/bot_guide_page.dart';

class _IntroBanner extends StatelessWidget {
  const _IntroBanner();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 17),
      borderColor: _guidePrimary.withValues(alpha: .35),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.menu_book_outlined, color: _guidePrimary, size: 25),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete Guide to Trading Bots',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  'Learn how each bot strategy works, when to use it, and '
                  'how to avoid common mistakes. Perfect for beginners and '
                  'experienced traders.',
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

class _Tabs extends StatelessWidget {
  const _Tabs({required this.active, required this.onChanged});

  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      ('strategies', 93.0),
      ('best-practices', 116.0),
      ('mistakes', 86.0),
    ];
    return Row(
      children: [
        for (var i = 0; i < tabs.length; i++) ...[
          SizedBox(
            width: tabs[i].$2,
            child: VitStatusPill(
              key: BotGuidePage.tabKey(tabs[i].$1),
              label: tabs[i].$1,
              status: active == tabs[i].$1
                  ? VitStatusPillStatus.info
                  : VitStatusPillStatus.neutral,
              size: VitStatusPillSize.lg,
              onTap: () => onChanged(tabs[i].$1),
            ),
          ),
          if (i != tabs.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}
