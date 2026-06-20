part of 'trading_bots_page.dart';

class _TradingBotsHeader extends StatelessWidget {
  const _TradingBotsHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.inputHeight + AppSpacing.hairlineStroke,
      child: Row(
        children: [
          VitIconButton(
            key: TradingBotsPage.backKey,
            icon: Icons.chevron_left_rounded,
            tooltip: 'Back to Trade',
            onPressed: onBack,
            variant: VitIconButtonVariant.transparent,
            size: VitIconButtonSize.md,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trading Bots',
                  style: AppTextStyles.sectionTitle.copyWith(
                    height: AppSpacing.tradeBotLineHeightShort,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Bot giao dịch · Trade',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.tradeBotLineHeightTight,
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

class _BotsHero extends StatelessWidget {
  const _BotsHero({required this.bots});

  final List<TradeBot> bots;

  @override
  Widget build(BuildContext context) {
    final running = bots
        .where((bot) => bot.status == TradeBotStatus.running)
        .length;
    final totalInvestment = bots.fold(0.0, (sum, bot) => sum + bot.investment);
    final totalProfit = bots.fold(0.0, (sum, bot) => sum + bot.profit);
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      borderColor: AppColors.primary20,
      padding: AppSpacing.tradeBotHeroPadding,
      child: Column(
        children: [
          Row(
            children: [
              VitCard(
                width: AppSpacing.x7,
                height: AppSpacing.x7,
                variant: VitCardVariant.inner,
                radius: VitCardRadius.md,
                borderColor: AppColors.primary20,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.smart_toy_outlined,
                  color: AppColors.primarySoft,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Giao dịch tự động 24/7',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.onAccent,
                        height: AppSpacing.tradeBotLineHeightCaption,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      'Bot hoạt động ngay cả khi bạn ngủ',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.onAccent.withValues(alpha: .65),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              _HeroStat(
                value: '$running',
                label: 'Bot đang chạy',
                valueColor: AppColors.buy,
              ),
              const SizedBox(width: AppSpacing.x3),
              _HeroStat(
                value: '\$${_formatWholeNumber(totalInvestment)}',
                label: 'Tổng đầu tư',
                valueColor: AppColors.onAccent,
              ),
              const SizedBox(width: AppSpacing.x3),
              _HeroStat(
                value: _formatSignedMoney(totalProfit),
                label: 'Lãi nhuận',
                valueColor: totalProfit >= 0 ? AppColors.buy : AppColors.sell,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  final String value;
  final String label;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VitCard(
        height: AppSpacing.launchpadBox64 + AppSpacing.x3,
        alignment: Alignment.center,
        variant: VitCardVariant.inner,
        borderColor: AppColors.onAccent.withValues(alpha: .08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.onAccent.withValues(alpha: .45),
              ),
            ),
          ],
        ),
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
    return VitCard(
      height: AppSpacing.tradeBotTabsHeight,
      padding: AppSpacing.tradeBotTabShellPadding,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      child: VitTabBar(
        variant: VitTabBarVariant.segment,
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
          const SizedBox(height: AppSpacing.x4),
        ],
        VitCtaButton(
          key: TradingBotsPage.addBotKey,
          onPressed: onAdd,
          height: AppSpacing.inputHeight,
          variant: VitCtaButtonVariant.secondary,
          leading: const Icon(Icons.add_rounded),
          child: const Text('Thêm Bot mới'),
        ),
      ],
    );
  }
}
