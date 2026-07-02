part of 'trading_bots_page.dart';

class _BotsMetricsSummary extends StatelessWidget {
  const _BotsMetricsSummary({required this.bots});

  final List<TradeBot> bots;

  @override
  Widget build(BuildContext context) {
    final running = bots
        .where((bot) => bot.status == TradeBotStatus.running)
        .length;
    final totalInvestment = bots.fold(0.0, (sum, bot) => sum + bot.investment);
    final totalProfit = bots.fold(0.0, (sum, bot) => sum + bot.profit);
    return VitCard(
      variant: VitCardVariant.inner,
      padding: VitDensity.compact.cardPadding,
      child: Row(
        children: [
          Expanded(
            child: _CompactStat(
              value: '$running',
              label: 'Bot đang chạy',
              valueColor: AppColors.buy,
            ),
          ),
          Expanded(
            child: _CompactStat(
              value: '\$${_formatWholeNumber(totalInvestment)}',
              label: 'Tổng đầu tư',
              valueColor: AppColors.text1,
            ),
          ),
          Expanded(
            child: _CompactStat(
              value: _formatSignedMoney(totalProfit),
              label: 'Lãi nhuận',
              valueColor: totalProfit >= 0 ? AppColors.buy : AppColors.sell,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactStat extends StatelessWidget {
  const _CompactStat({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  final String value;
  final String label;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.numericCode.copyWith(
            color: valueColor,
            fontFeatures: AppTextStyles.tabularFigures,
            height: AppSpacing.tradeBotLineHeightTight,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
      ],
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
      return VitTradeSection(
        title: 'Bot của tôi',
        child: _EmptyBots(onAdd: onAdd),
      );
    }
    return VitTradeSection(
      title: 'Bot của tôi',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final bot in bots) ...[
            _BotCard(bot: bot, onToggle: onToggle, onDelete: onDelete),
            if (bot != bots.last) const SizedBox(height: AppSpacing.x3),
          ],
          const SizedBox(height: AppSpacing.x3),
          VitCtaButton(
            key: TradingBotsPage.addBotKey,
            onPressed: onAdd,
            height: AppSpacing.inputHeight,
            variant: VitCtaButtonVariant.secondary,
            leading: const Icon(Icons.add_rounded),
            child: const Text('Thêm Bot mới'),
          ),
        ],
      ),
    );
  }
}
