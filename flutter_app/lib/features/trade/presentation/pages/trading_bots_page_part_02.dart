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
          const SizedBox(height: AppSpacing.x4),
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
              const SizedBox(width: AppSpacing.x3),
              _BotActionButton(
                key: TradingBotsPage.botSettingsKey(bot.id),
                label: 'Cài đặt',
                icon: Icons.settings_outlined,
                color: _botPrimary,
                compact: true,
                onTap: () {},
              ),
              const SizedBox(width: AppSpacing.x3),
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
    return VitCard(
      width: AppSpacing.launchpadBox40,
      height: AppSpacing.launchpadBox40,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
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
    return SizedBox(
      width: compact ? AppSpacing.buttonHero : null,
      child: VitCtaButton(
        onPressed: onTap,
        height: AppSpacing.buttonCompact + AppSpacing.x3,
        variant: _botButtonVariant(color),
        fullWidth: true,
        padding: AppSpacing.tradeBotActionButtonPadding(compact),
        leading: Icon(icon),
        child: Text(label),
      ),
    );
  }
}

VitCtaButtonVariant _botButtonVariant(Color color) {
  if (color == AppColors.buy) return VitCtaButtonVariant.success;
  if (color == AppColors.sell) return VitCtaButtonVariant.danger;
  if (color == AppColors.warn) return VitCtaButtonVariant.warning;
  return VitCtaButtonVariant.primary;
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
        const SizedBox(height: AppSpacing.x4),
        for (final strategy in strategies) ...[
          _StrategyCard(strategy: strategy, onCreate: () => onCreate(strategy)),
          const SizedBox(height: AppSpacing.x4),
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
    return VitCard(
      padding: AppSpacing.tradeBotCardPadding,
      borderColor: _botPrimary.withValues(alpha: .20),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                color: _botPrimary,
                size: AppSpacing.tradeBotMediumIcon,
              ),
              const SizedBox(width: AppSpacing.x3),
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
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              _StrategyStat(
                label: 'DCA Bot',
                value: '+9.4%',
                color: _botPrimary,
              ),
              const SizedBox(width: AppSpacing.x3),
              _StrategyStat(
                label: 'Grid Bot',
                value: '+27.1%',
                color: AppColors.warn,
              ),
              const SizedBox(width: AppSpacing.x3),
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
      child: VitCard(
        padding: AppSpacing.tradeBotInnerPanelPadding,
        variant: VitCardVariant.inner,
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
