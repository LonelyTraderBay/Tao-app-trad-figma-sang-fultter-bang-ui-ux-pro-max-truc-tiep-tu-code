part of '../pages/bot_api_documentation_page.dart';

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      density: VitDensity.compact,
      borderColor: _apiPrimary.withValues(alpha: .25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.code_rounded,
            color: _apiPrimary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bot API Documentation',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Tạo, quản lý và giám sát bot qua REST API và WebSocket. '
                  'Dành cho người dùng Enterprise — đọc kỹ xác thực và '
                  'giới hạn tần suất trước khi tích hợp.',
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
