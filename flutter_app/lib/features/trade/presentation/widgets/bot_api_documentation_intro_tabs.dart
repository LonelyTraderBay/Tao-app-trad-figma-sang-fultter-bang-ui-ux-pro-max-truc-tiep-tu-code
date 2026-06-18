part of '../pages/bot_api_documentation_page.dart';

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      padding: AppSpacing.tradeBotCardPaddingLoose,
      borderColor: _apiPrimary.withValues(alpha: .25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.code_rounded,
            color: _apiPrimary,
            size: AppSpacing.tradeBotCheckbox,
          ),
          const SizedBox(width: AppSpacing.tradeBotCardIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bot API Documentation',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.tradeBotLineHeightShort,
                  ),
                ),
                const SizedBox(height: AppSpacing.tradeBotSmallGap),
                Text(
                  'Programmatically create, manage, and monitor trading '
                  'bots using our REST API and WebSocket connections. '
                  'Available for Enterprise tier users.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.tradeBotLineHeightRelaxed,
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
  const _Tabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<TradeBotApiTab> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: active,
      onChanged: onChanged,
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.id,
            label: tab.label,
            widgetKey: BotApiDocumentationPage.tabKey(tab.id),
          ),
      ],
    );
  }
}
