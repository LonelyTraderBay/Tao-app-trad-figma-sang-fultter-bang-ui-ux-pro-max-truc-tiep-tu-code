part of '../../pages/hub/trading_bots_page.dart';

class _BotsTabs extends StatelessWidget {
  const _BotsTabs({
    required this.active,
    required this.botCount,
    required this.onChanged,
  });

  final _TradingBotsTab active;
  final int botCount;
  final ValueChanged<_TradingBotsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedTabBar(
      activeKey: active.name,
      onChanged: (key) => onChanged(
        key == _TradingBotsTab.myBots.name
            ? _TradingBotsTab.myBots
            : _TradingBotsTab.strategies,
      ),
      tabs: [
        VitTabItem(
          key: _TradingBotsTab.myBots.name,
          label: 'Bot của tôi ($botCount)',
          icon: Icons.smart_toy_outlined,
          widgetKey: TradingBotsPage.tabKey('mybots'),
        ),
        VitTabItem(
          key: _TradingBotsTab.strategies.name,
          label: 'Chiến lược',
          icon: Icons.storefront_outlined,
          widgetKey: TradingBotsPage.tabKey('strategies'),
        ),
      ],
    );
  }
}

class _MyBotsTab extends StatelessWidget {
  const _MyBotsTab({
    required this.bots,
    required this.onToggle,
    required this.onDelete,
    required this.onAdd,
  });

  final List<TradeBot> bots;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    if (bots.isEmpty) {
      return _EmptyBots(onAdd: onAdd);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final bot in bots) ...[
          _BotCard(bot: bot, onToggle: onToggle, onDelete: onDelete),
          if (bot != bots.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}
