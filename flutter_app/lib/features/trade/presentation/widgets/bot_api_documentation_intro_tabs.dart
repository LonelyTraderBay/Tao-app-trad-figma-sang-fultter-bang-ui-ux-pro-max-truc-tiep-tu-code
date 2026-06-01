part of '../pages/bot_api_documentation_page.dart';

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      decoration: BoxDecoration(
        color: _apiPrimary.withValues(alpha: .08),
        border: Border.all(color: _apiPrimary.withValues(alpha: .25)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.code_rounded, color: _apiPrimary, size: 25),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bot API Documentation',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontSize: 17,
                    fontWeight: AppTextStyles.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Programmatically create, manage, and monitor trading '
                  'bots using our REST API and WebSocket connections. '
                  'Available for Enterprise tier users.',
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
    final widths = <String, double>{
      'endpoints': 93,
      'websocket': 96,
      'examples': 90,
    };
    return Row(
      children: [
        for (var i = 0; i < tabs.length; i++) ...[
          GestureDetector(
            key: BotApiDocumentationPage.tabKey(tabs[i].id),
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged(tabs[i].id),
            child: Container(
              width: widths[tabs[i].id] ?? 90,
              height: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active == tabs[i].id
                    ? _apiPrimary.withValues(alpha: .13)
                    : _apiTabBackground,
                border: Border.all(
                  color: active == tabs[i].id
                      ? _apiPrimary.withValues(alpha: .42)
                      : AppColors.transparent,
                ),
                borderRadius: AppRadii.cardRadius,
              ),
              child: Text(
                tabs[i].label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: active == tabs[i].id ? _apiPrimary : AppColors.text3,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
          ),
          if (i != tabs.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}
