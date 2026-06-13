part of 'trading_bots_page.dart';

class _BotCard extends StatelessWidget {
  const _BotCard({
    required this.bot,
    required this.onToggle,
    required this.onDelete,
  });

  final TradeBot bot;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    final color = Color(bot.colorHex);
    final running = bot.status == TradeBotStatus.running;
    final profitColor = bot.profit >= 0 ? AppColors.buy : AppColors.sell;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _panelBackground,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _BotIcon(icon: bot.icon, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            bot.strategyName,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _PairBadge(pair: bot.pair, color: color),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: running ? AppColors.buy : AppColors.warn,
                            borderRadius: AppRadii.xsRadius,
                            boxShadow: running
                                ? [
                                    BoxShadow(
                                      color: AppColors.buy.withValues(
                                        alpha: .7,
                                      ),
                                      blurRadius: 8,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          running ? 'Đang chạy' : 'Tạm dừng',
                          style: AppTextStyles.caption.copyWith(
                            color: running ? AppColors.buy : AppColors.warn,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '· ${bot.runtime}',
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                              height: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatSignedMoney(bot.profit),
                    style: AppTextStyles.caption.copyWith(
                      color: profitColor,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures
                    ),
                  ),
                  Text(
                    _formatSignedPct(bot.profitPct),
                    style: AppTextStyles.caption.copyWith(
                      color: profitColor,
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _BotMiniStat(
                label: 'Đầu tư',
                value: '\$${_formatWholeNumber(bot.investment)}',
              ),
              const SizedBox(width: 8),
              _BotMiniStat(label: 'Lệnh', value: '${bot.trades}'),
              const SizedBox(width: 8),
              _BotMiniStat(label: 'Từ', value: bot.startDate),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _BotActionButton(
                  key: TradingBotsPage.botToggleKey(bot.id),
                  label: running ? 'Tạm dừng' : 'Tiếp tục',
                  icon: running
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: running ? AppColors.warn : AppColors.buy,
                  onTap: () => onToggle(bot.id),
                ),
              ),
              const SizedBox(width: 8),
              _BotActionButton(
                key: TradingBotsPage.botSettingsKey(bot.id),
                label: 'Cài đặt',
                icon: Icons.settings_outlined,
                color: _botPrimary,
                compact: true,
                onTap: () {},
              ),
              const SizedBox(width: 8),
              _BotActionButton(
                key: TradingBotsPage.botDeleteKey(bot.id),
                label: 'Xóa',
                icon: Icons.delete_outline_rounded,
                color: AppColors.sell,
                compact: true,
                onTap: () => onDelete(bot.id),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BotIcon extends StatelessWidget {
  const _BotIcon({required this.icon, required this.color});

  final String icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final iconData = switch (icon) {
      'calendar' => Icons.calendar_month_rounded,
      'bolt' => Icons.bolt_rounded,
      'chart' => Icons.show_chart_rounded,
      'target' => Icons.gps_fixed_rounded,
      _ => Icons.smart_toy_outlined,
    };
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .18),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Icon(iconData, color: color, size: 20),
    );
  }
}

class _PairBadge extends StatelessWidget {
  const _PairBadge({required this.pair, required this.color});

  final String pair;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .18),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        pair,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _BotMiniStat extends StatelessWidget {
  const _BotMiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: _chipBackground,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BotActionButton extends StatelessWidget {
  const _BotActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.compact = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        width: compact ? 90 : null,
        height: 42,
        padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .10),
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: color.withValues(alpha: .24)),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 14),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StrategiesTab extends StatelessWidget {
  const _StrategiesTab({required this.strategies, required this.onCreate});

  final List<TradeBotStrategy> strategies;
  final ValueChanged<TradeBotStrategy> onCreate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PerformanceCard(strategies: strategies),
        const SizedBox(height: 12),
        for (final strategy in strategies) ...[
          _StrategyCard(strategy: strategy, onCreate: () => onCreate(strategy)),
          const SizedBox(height: 12),
        ],
        _BotInfoCard(),
      ],
    );
  }
}

class _PerformanceCard extends StatelessWidget {
  const _PerformanceCard({required this.strategies});

  final List<TradeBotStrategy> strategies;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _panelBackground,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _botPrimary.withValues(alpha: .20)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart_rounded, color: _botPrimary, size: 17),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Hiệu suất chiến lược (30 ngày gần đây)',
                  style: AppTextStyles.caption.copyWith(
                    color: _botPrimary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _StrategyStat(
                label: 'DCA Bot',
                value: '+9.4%',
                color: _botPrimary,
              ),
              const SizedBox(width: 8),
              _StrategyStat(
                label: 'Grid Bot',
                value: '+27.1%',
                color: AppColors.warn,
              ),
              const SizedBox(width: 8),
              _StrategyStat(
                label: 'Momentum',
                value: '+18.3%',
                color: AppColors.buy,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StrategyStat extends StatelessWidget {
  const _StrategyStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _chipBackground,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            Text(label, style: AppTextStyles.micro),
          ],
        ),
      ),
    );
  }
}


