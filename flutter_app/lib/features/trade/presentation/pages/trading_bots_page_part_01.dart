part of 'trading_bots_page.dart';

class _TradingBotsHeader extends StatelessWidget {
  const _TradingBotsHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Row(
        children: [
          InkWell(
            key: TradingBotsPage.backKey,
            onTap: onBack,
            borderRadius: AppRadii.cardRadius,
            child: const SizedBox(
              width: 36,
              height: 36,
              child: Icon(
                Icons.chevron_left_rounded,
                color: AppColors.text1,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trading Bots',
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontSize: 18,
                    height: 1.12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bot giao dịch · Trade',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1,
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surface3, AppColors.surface],
        ),
        borderRadius: AppRadii.cardLargeRadius,
        border: Border.all(color: AppColors.primary20),
        boxShadow: [
          BoxShadow(
            color: _botPrimary.withValues(alpha: .10),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _botPrimary.withValues(alpha: .28),
                      AppColors.accent20,
                    ],
                  ),
                  borderRadius: AppRadii.cardRadius,
                  border: Border.all(color: _botPrimary.withValues(alpha: .32)),
                ),
                child: const Icon(
                  Icons.smart_toy_outlined,
                  color: AppColors.primarySoft,
                  size: 27,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Giao dịch tự động 24/7',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.onAccent,
                        fontSize: 20,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Bot hoạt động ngay cả khi bạn ngủ',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.onAccent.withValues(alpha: .65),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _HeroStat(
                value: '$running',
                label: 'Bot đang chạy',
                valueColor: AppColors.buy,
              ),
              const SizedBox(width: 12),
              _HeroStat(
                value: '\$${_formatWholeNumber(totalInvestment)}',
                label: 'Tổng đầu tư',
                valueColor: AppColors.onAccent,
              ),
              const SizedBox(width: 12),
              _HeroStat(
                value: _formatSignedMoney(totalProfit),
                label: 'Lợi nhuận',
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
      child: Container(
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.onAccent.withValues(alpha: .07),
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: AppColors.onAccent.withValues(alpha: .08)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: valueColor,
                fontSize: 14,
                fontWeight: AppTextStyles.bold,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.onAccent.withValues(alpha: .45),
                fontSize: 10,
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
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _chipBackground,
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Row(
        children: [
          _TabButton(
            key: TradingBotsPage.tabKey('mybots'),
            active: active == _TradingBotsTab.myBots,
            label: 'Bot của tôi ($botCount)',
            icon: Icons.smart_toy_outlined,
            onTap: () => onChanged(_TradingBotsTab.myBots),
          ),
          const SizedBox(width: 4),
          _TabButton(
            key: TradingBotsPage.tabKey('strategies'),
            active: active == _TradingBotsTab.strategies,
            label: 'Chiến lược',
            icon: Icons.storefront_outlined,
            onTap: () => onChanged(_TradingBotsTab.strategies),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    super.key,
    required this.active,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final bool active;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.lgRadius,
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: active
                ? const LinearGradient(colors: [_botPrimary, _botPrimaryDark])
                : null,
            borderRadius: AppRadii.lgRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: active ? AppColors.onAccent : AppColors.text3,
                size: 15,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? AppColors.onAccent : AppColors.text3,
                    fontSize: 13,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
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
          const SizedBox(height: 12),
        ],
        InkWell(
          key: TradingBotsPage.addBotKey,
          onTap: onAdd,
          borderRadius: AppRadii.cardRadius,
          child: Container(
            height: AppSpacing.inputHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _panelBackground,
              borderRadius: AppRadii.cardRadius,
              border: Border.all(
                color: _botPrimary.withValues(alpha: .48),
                style: BorderStyle.solid,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_rounded, color: _botPrimary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Thêm Bot mới',
                  style: AppTextStyles.body.copyWith(
                    color: _botPrimary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
