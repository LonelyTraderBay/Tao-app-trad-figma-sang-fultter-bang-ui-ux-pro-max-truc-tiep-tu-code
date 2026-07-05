part of 'trading_bots_page.dart';

class _BotsHero extends StatelessWidget {
  const _BotsHero({required this.bots});

  final List<TradeBot> bots;

  @override
  Widget build(BuildContext context) {
    final running = bots
        .where((bot) => bot.status == TradeBotStatus.running)
        .length;
    final totalProfit = bots.fold(0.0, (sum, bot) => sum + bot.profit);
    final profitColor = totalProfit >= 0 ? AppColors.buy : AppColors.sell;

    return VitCard(
      padding: AppSpacing.cardPaddingCompact,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đang chạy',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '$running',
                  style: AppTextStyles.heroNumber.copyWith(
                    color: AppColors.buy,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: AppSpacing.x6,
            color: AppColors.border,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lãi/lỗ',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    _formatSignedMoney(totalProfit),
                    style: AppTextStyles.heroNumber.copyWith(
                      color: profitColor,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
    return SizedBox(
      height: AppSpacing.tradeBotTabsHeight,
      child: VitSegmentedTabBar(
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
      ),
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
          if (bot != bots.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}
