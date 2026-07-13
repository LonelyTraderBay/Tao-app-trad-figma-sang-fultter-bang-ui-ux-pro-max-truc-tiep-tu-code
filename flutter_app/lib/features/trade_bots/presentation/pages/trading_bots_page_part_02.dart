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
      padding: TradeSpacingTokens.tradeBotCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BotIcon(icon: bot.icon, color: color),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bot.strategyName,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                    VitStatusPill(
                      label: running ? 'Đang chạy' : 'Tạm dừng',
                      status: running
                          ? VitStatusPillStatus.success
                          : VitStatusPillStatus.warning,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                _formatSignedMoney(bot.profit),
                style: AppTextStyles.baseMedium.copyWith(
                  color: profitColor,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            '${bot.pair} · \$${_formatWholeNumber(bot.investment)} · ${bot.runtime}',
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
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
                  padding: TradeSpacingTokens.tradeBotActionButtonPadding(
                    false,
                  ),
                  leading: Icon(
                    running ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  ),
                  child: Text(running ? 'Tạm dừng' : 'Tiếp tục'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              PopupMenuButton<String>(
                key: TradingBotsPage.botSettingsKey(bot.id),
                tooltip: 'Tùy chọn bot',
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: (action) {
                  if (action == 'delete') onDelete(bot.id);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'settings',
                    child: ListTile(
                      leading: Icon(Icons.settings_outlined),
                      title: Text('Cài đặt'),
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  PopupMenuItem(
                    key: TradingBotsPage.botDeleteKey(bot.id),
                    value: 'delete',
                    child: const ListTile(
                      leading: Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.sell,
                      ),
                      title: Text('Xóa bot'),
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
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
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .12),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.smRadius,
          side: BorderSide(color: color.withValues(alpha: .22)),
        ),
      ),
      child: SizedBox(
        width: LaunchpadSpacingTokens.launchpadBox40,
        height: LaunchpadSpacingTokens.launchpadBox40,
        child: Center(
          child: Icon(
            iconData,
            color: color,
            size: TradeSpacingTokens.tradeBotActionIcon,
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
    if (strategies.isEmpty) {
      return VitEmptyState(
        title: 'Chưa có chiến lược',
        message: 'Danh sách chiến lược sẽ hiển thị tại đây.',
        icon: Icons.storefront_outlined,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final strategy in strategies) ...[
          _StrategyCard(strategy: strategy, onCreate: () => onCreate(strategy)),
          if (strategy != strategies.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}
