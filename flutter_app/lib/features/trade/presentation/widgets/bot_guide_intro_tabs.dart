part of '../pages/bot_guide_page.dart';

class _IntroBanner extends StatelessWidget {
  const _IntroBanner();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _guidePrimary.withValues(alpha: .35),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.menu_book_outlined,
            color: _guidePrimary,
            size: AppSpacing.inputPrefixIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete Guide to Trading Bots',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Tìm hiểu từng chiến lược bot, khi nào nên dùng và cách '
                  'tránh sai lầm phổ biến — phù hợp người mới và trader có '
                  'kinh nghiệm.',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
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
    const tabs = <({String id, String label})>[
      (id: 'strategies', label: 'Chiến lược'),
      (id: 'best-practices', label: 'Thực hành'),
      (id: 'mistakes', label: 'Sai lầm'),
    ];
    return VitTabBar(
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.id,
            label: tab.label,
            widgetKey: BotGuidePage.tabKey(tab.id),
          ),
      ],
      activeKey: active,
      onChanged: onChanged,
      variant: VitTabBarVariant.pill,
    );
  }
}
