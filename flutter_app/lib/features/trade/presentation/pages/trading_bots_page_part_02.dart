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
    return VitCard(
      padding: AppSpacing.tradeBotCardPadding,
      child: Column(
        children: [
          Row(
            children: [
              _BotIcon(icon: bot.icon, color: color),
              const SizedBox(width: AppSpacing.x4),
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
                        const SizedBox(width: AppSpacing.x3),
                        _PairBadge(pair: bot.pair, color: color),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Row(
                      children: [
                        VitStatusPill(
                          label: running ? 'Đang chạy' : 'Tạm dừng',
                          status: running
                              ? VitStatusPillStatus.success
                              : VitStatusPillStatus.warning,
                          size: VitStatusPillSize.sm,
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Expanded(
                          child: Text(
                            '· ${bot.runtime}',
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                              height: AppSpacing.tradeBotLineHeightTight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatSignedMoney(bot.profit),
                    style: AppTextStyles.caption.copyWith(
                      color: profitColor,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    _formatSignedPct(bot.profitPct),
                    style: AppTextStyles.caption.copyWith(
                      color: profitColor,
                      height: AppSpacing.tradeBotLineHeightShort,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _BotMiniStat(
                label: 'Đầu tư',
                value: '\$${_formatWholeNumber(bot.investment)}',
              ),
              const SizedBox(width: AppSpacing.x3),
              _BotMiniStat(label: 'Lệnh', value: '${bot.trades}'),
              const SizedBox(width: AppSpacing.x3),
              _BotMiniStat(label: 'Từ', value: bot.startDate),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: TradingBotsPage.botToggleKey(bot.id),
                  onPressed: () => onToggle(bot.id),
                  height: AppSpacing.buttonCompact + AppSpacing.x3,
                  variant: running
                      ? VitCtaButtonVariant.warning
                      : VitCtaButtonVariant.success,
                  padding: AppSpacing.tradeBotActionButtonPadding(false),
                  leading: Icon(
                    running ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  ),
                  child: Text(running ? 'Tạm dừng' : 'Tiếp tục'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              VitIconButton(
                key: TradingBotsPage.botSettingsKey(bot.id),
                icon: Icons.settings_outlined,
                tooltip: 'Mở cài đặt bot',
                onPressed: () {},
                variant: VitIconButtonVariant.primary,
                size: VitIconButtonSize.lg,
              ),
              const SizedBox(width: AppSpacing.x3),
              VitIconButton(
                key: TradingBotsPage.botDeleteKey(bot.id),
                icon: Icons.delete_outline_rounded,
                tooltip: 'Xóa bot',
                onPressed: () => onDelete(bot.id),
                variant: VitIconButtonVariant.danger,
                size: VitIconButtonSize.lg,
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
    return VitCard(
      width: AppSpacing.launchpadBox40,
      height: AppSpacing.launchpadBox40,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      alignment: Alignment.center,
      borderColor: color.withValues(alpha: .22),
      child: Icon(iconData, color: color, size: AppSpacing.tradeBotActionIcon),
    );
  }
}

class _PairBadge extends StatelessWidget {
  const _PairBadge({required this.pair, required this.color});

  final String pair;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(
      label: pair,
      accentColor: color,
      size: VitStatusPillSize.sm,
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
      child: VitCard(
        height: AppSpacing.tradeBotMiniStatHeight,
        padding: AppSpacing.tradeBotMiniStatPadding,
        variant: VitCardVariant.inner,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
                height: AppSpacing.tradeBotLineHeightTight,
              ),
            ),
          ],
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
        VitTradeSection(
          title: 'Hiệu suất chiến lược',
          child: _PerformanceCard(strategies: strategies),
        ),
        VitTradeSection(
          title: 'Chiến lược',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final strategy in strategies) ...[
                _StrategyCard(
                  strategy: strategy,
                  onCreate: () => onCreate(strategy),
                ),
                if (strategy != strategies.last)
                  const SizedBox(height: AppSpacing.x3),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
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
    return VitCard(
      padding: AppSpacing.tradeBotCardPadding,
      borderColor: _botPrimary.withValues(alpha: .20),
      child: VitActionTileGrid(
        density: VitDensity.compact,
        crossAxisCount: 3,
        childAspectRatio: 1.35,
        itemCount: 3,
        itemBuilder: (context, index, tileDensity) {
          final tiles = [
            (
              label: 'DCA Bot',
              badge: '+9.4%',
              color: _botPrimary,
              icon: Icons.calendar_month_rounded,
            ),
            (
              label: 'Grid Bot',
              badge: '+27.1%',
              color: AppColors.warn,
              icon: Icons.grid_view_rounded,
            ),
            (
              label: 'Momentum',
              badge: '+18.3%',
              color: AppColors.buy,
              icon: Icons.show_chart_rounded,
            ),
          ];
          final tile = tiles[index];
          return VitServiceTile(
            density: tileDensity,
            icon: tile.icon,
            label: tile.label,
            badgeLabel: tile.badge,
            accentColor: tile.color,
          );
        },
      ),
    );
  }
}
