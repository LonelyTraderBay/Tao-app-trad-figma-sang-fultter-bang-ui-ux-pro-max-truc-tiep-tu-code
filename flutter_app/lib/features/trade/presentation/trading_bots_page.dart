import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/trade_repository.dart';

const _botBlue = Color(0xFF3B82F6);
const _botBlueDark = Color(0xFF1D4ED8);
const _panelBg = Color(0xFF121721);
const _chipBg = Color(0xFF1D263B);

enum _TradingBotsTab { myBots, strategies }

class TradingBotsPage extends ConsumerStatefulWidget {
  const TradingBotsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc059_trading_bots_scroll_content');
  static const backKey = Key('sc059_back');
  static const addBotKey = Key('sc059_add_bot');
  static const sheetAgreeKey = Key('sc059_sheet_agree');
  static const sheetCreateKey = Key('sc059_sheet_create');

  static Key tabKey(String id) => Key('sc059_tab_$id');
  static Key botToggleKey(String botId) => Key('sc059_bot_toggle_$botId');
  static Key botSettingsKey(String botId) => Key('sc059_bot_settings_$botId');
  static Key botDeleteKey(String botId) => Key('sc059_bot_delete_$botId');
  static Key strategyCreateKey(String strategyId) =>
      Key('sc059_strategy_create_$strategyId');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TradingBotsPage> createState() => _TradingBotsPageState();
}

class _TradingBotsPageState extends ConsumerState<TradingBotsPage> {
  _TradingBotsTab _tab = _TradingBotsTab.myBots;
  late List<TradeBot> _bots;
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _bots = List.of(
      ref.read(tradeRepositoryProvider).getTradingBots().activeBots,
    );
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeRepositoryProvider).getTradingBots();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 34 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-059 TradingBotsPage',
      child: Stack(
        children: [
          Material(
            type: MaterialType.transparency,
            child: SingleChildScrollView(
              key: TradingBotsPage.contentKey,
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: _TradingBotsHeader(
                      onBack: () => context.go(AppRoutePaths.trade),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.divider,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _BotsHero(bots: _bots),
                        const SizedBox(height: 16),
                        _BotsTabs(
                          active: _tab,
                          botCount: _bots.length,
                          onChanged: (tab) => setState(() => _tab = tab),
                        ),
                        const SizedBox(height: 16),
                        if (_tab == _TradingBotsTab.myBots)
                          _MyBotsTab(
                            bots: _bots,
                            onToggle: _toggleBot,
                            onDelete: _deleteBot,
                            onAdd: () => setState(
                              () => _tab = _TradingBotsTab.strategies,
                            ),
                          )
                        else
                          _StrategiesTab(
                            strategies: snapshot.strategies,
                            onCreate: _openCreateSheet,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showSuccess)
            Positioned(
              left: 20,
              right: 20,
              top: mode.usesVisualQaFrame ? 80 : 24,
              child: _SuccessToast(
                onClose: () => setState(() => _showSuccess = false),
              ),
            ),
        ],
      ),
    );
  }

  void _toggleBot(String botId) {
    setState(() {
      _bots = [
        for (final bot in _bots)
          if (bot.id == botId)
            bot.copyWith(
              status: bot.status == TradeBotStatus.running
                  ? TradeBotStatus.paused
                  : TradeBotStatus.running,
            )
          else
            bot,
      ];
    });
    ref
        .read(tradeRepositoryProvider)
        .submitBotAction(TradeBotActionRequest(botId: botId, action: 'toggle'));
  }

  void _deleteBot(String botId) {
    setState(() => _bots = _bots.where((bot) => bot.id != botId).toList());
    ref
        .read(tradeRepositoryProvider)
        .submitBotAction(TradeBotActionRequest(botId: botId, action: 'delete'));
  }

  Future<void> _openCreateSheet(TradeBotStrategy strategy) async {
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CreateBotSheet(strategy: strategy),
    );
    if (created != true || !mounted) return;
    ref
        .read(tradeRepositoryProvider)
        .createTradingBot(
          TradeBotCreateRequest(
            strategyId: strategy.id,
            params: {
              for (final param in strategy.params)
                param.key: param.defaultValue,
            },
          ),
        );
    setState(() => _showSuccess = true);
  }
}

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
            borderRadius: BorderRadius.circular(18),
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
          colors: [Color(0xFF152655), Color(0xFF101936)],
        ),
        borderRadius: AppRadii.cardLargeRadius,
        border: Border.all(color: const Color(0x333B82F6)),
        boxShadow: [
          BoxShadow(
            color: _botBlue.withValues(alpha: .10),
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
                      _botBlue.withValues(alpha: .28),
                      const Color(0xFF6366F1).withValues(alpha: .18),
                    ],
                  ),
                  borderRadius: AppRadii.cardRadius,
                  border: Border.all(color: _botBlue.withValues(alpha: .32)),
                ),
                child: const Icon(
                  Icons.smart_toy_outlined,
                  color: Color(0xFF60A5FA),
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
                        color: Colors.white,
                        fontSize: 20,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Bot hoạt động ngay cả khi bạn ngủ',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withValues(alpha: .65),
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
                valueColor: Colors.white,
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
          color: Colors.white.withValues(alpha: .07),
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: Colors.white.withValues(alpha: .08)),
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
                color: Colors.white.withValues(alpha: .45),
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
        color: _chipBg,
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
                ? const LinearGradient(colors: [_botBlue, _botBlueDark])
                : null,
            borderRadius: AppRadii.lgRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: active ? Colors.white : AppColors.text3,
                size: 15,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? Colors.white : AppColors.text3,
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
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _panelBg,
              borderRadius: AppRadii.cardRadius,
              border: Border.all(
                color: _botBlue.withValues(alpha: .48),
                style: BorderStyle.solid,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_rounded, color: _botBlue, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Thêm Bot mới',
                  style: AppTextStyles.body.copyWith(
                    color: _botBlue,
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
        color: _panelBg,
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
                              fontSize: 14,
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
                            fontSize: 12,
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
                              fontSize: 12,
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
                      fontSize: 14,
                      fontWeight: AppTextStyles.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Text(
                    _formatSignedPct(bot.profitPct),
                    style: AppTextStyles.caption.copyWith(
                      color: profitColor,
                      fontSize: 12,
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
                color: _botBlue,
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
          fontSize: 11,
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
          color: _chipBg,
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
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                fontSize: 12,
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
                    fontSize: 12,
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
        color: _panelBg,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _botBlue.withValues(alpha: .20)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart_rounded, color: _botBlue, size: 17),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Hiệu suất chiến lược (30 ngày gần đây)',
                  style: AppTextStyles.caption.copyWith(
                    color: _botBlue,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _StrategyStat(label: 'DCA Bot', value: '+9.4%', color: _botBlue),
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
          color: _chipBg,
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
            Text(label, style: AppTextStyles.micro.copyWith(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({required this.strategy, required this.onCreate});

  final TradeBotStrategy strategy;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final color = Color(strategy.colorHex);
    final risk = _riskStyle(strategy.risk);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _panelBg,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BotIcon(icon: strategy.icon, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            strategy.name,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: risk.$2,
                            borderRadius: AppRadii.smRadius,
                          ),
                          child: Text(
                            risk.$1,
                            style: AppTextStyles.micro.copyWith(
                              color: risk.$3,
                              fontWeight: AppTextStyles.bold,
                              height: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      strategy.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _StrategyDetail(
                label: 'Lợi nhuận kỳ vọng',
                value: strategy.avgReturn,
                valueColor: AppColors.buy,
              ),
              const SizedBox(width: 8),
              _StrategyDetail(
                label: 'Phù hợp với',
                value: strategy.suitableFor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            key: TradingBotsPage.strategyCreateKey(strategy.id),
            onTap: onCreate,
            borderRadius: AppRadii.cardRadius,
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: .68)],
                ),
                borderRadius: AppRadii.cardRadius,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: .25),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Tạo Bot ${strategy.name}',
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white,
                      fontWeight: AppTextStyles.bold,
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

class _StrategyDetail extends StatelessWidget {
  const _StrategyDetail({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _chipBg,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.micro.copyWith(fontSize: 10)),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: valueColor ?? AppColors.text1,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BotInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _panelBg,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.warn.withValues(alpha: .20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Lưu ý quan trọng: Bot giao dịch không đảm bảo lợi nhuận. '
              'Hiệu suất trong quá khứ không đại diện cho kết quả tương lai.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyBots extends StatelessWidget {
  const _EmptyBots({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: _chipBg,
            borderRadius: AppRadii.cardRadius,
          ),
          child: const Icon(
            Icons.smart_toy_outlined,
            color: AppColors.text3,
            size: 32,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Chưa có bot nào đang chạy',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: 12),
        _BotActionButton(
          label: 'Tạo Bot mới',
          icon: Icons.add_rounded,
          color: _botBlue,
          onTap: onAdd,
        ),
      ],
    );
  }
}

class _CreateBotSheet extends StatefulWidget {
  const _CreateBotSheet({required this.strategy});

  final TradeBotStrategy strategy;

  @override
  State<_CreateBotSheet> createState() => _CreateBotSheetState();
}

class _CreateBotSheetState extends State<_CreateBotSheet> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    final strategy = widget.strategy;
    final color = Color(strategy.colorHex);
    final bottom = MediaQuery.paddingOf(context).bottom;
    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * .85,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: AppColors.borderSolid)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderSolid,
                    borderRadius: AppRadii.xsRadius,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  _BotIcon(icon: strategy.icon, color: color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strategy.name,
                          style: AppTextStyles.sectionTitle.copyWith(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          strategy.suitableFor,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context, false),
                    icon: const Icon(Icons.close_rounded),
                    color: AppColors.text2,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .08),
                  borderRadius: AppRadii.cardRadius,
                  border: Border.all(color: color.withValues(alpha: .22)),
                ),
                child: Text(
                  strategy.longDescription,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              for (final param in strategy.params) ...[
                _ParamPreview(param: param, color: color),
                const SizedBox(height: 12),
              ],
              InkWell(
                key: TradingBotsPage.sheetAgreeKey,
                onTap: () => setState(() => _agreed = !_agreed),
                borderRadius: AppRadii.smRadius,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        color: _agreed ? color : Colors.transparent,
                        borderRadius: AppRadii.xsRadius,
                        border: Border.all(
                          color: _agreed ? color : AppColors.borderSolid,
                        ),
                      ),
                      child: _agreed
                          ? const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Tôi hiểu các rủi ro và đồng ý với điều khoản sử dụng Bot',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                key: TradingBotsPage.sheetCreateKey,
                onTap: _agreed ? () => Navigator.pop(context, true) : null,
                borderRadius: AppRadii.inputRadius,
                child: Container(
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _agreed ? null : _chipBg,
                    gradient: _agreed
                        ? LinearGradient(
                            colors: [color, color.withValues(alpha: .70)],
                          )
                        : null,
                    borderRadius: AppRadii.inputRadius,
                  ),
                  child: Text(
                    _agreed
                        ? 'Khởi chạy ${strategy.name}'
                        : 'Nhập thông số Bot',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: _agreed ? Colors.white : AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                    ),
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

class _ParamPreview extends StatelessWidget {
  const _ParamPreview({required this.param, required this.color});

  final TradeBotParam param;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          param.unit == null ? param.label : '${param.label} (${param.unit})',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          constraints: const BoxConstraints(minHeight: 46),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: _chipBg,
            borderRadius: AppRadii.inputRadius,
            border: Border.all(color: color.withValues(alpha: .26)),
          ),
          child: Text(
            param.defaultValue,
            style: AppTextStyles.baseMedium.copyWith(
              fontFamily: param.type == 'number' ? 'monospace' : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _SuccessToast extends StatelessWidget {
  const _SuccessToast({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: AppColors.buy),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .45),
              blurRadius: 28,
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.buy),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Bot đã được khởi chạy!',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    'Bot đang hoạt động và giao dịch tự động',
                    style: AppTextStyles.caption.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close_rounded, size: 18),
              color: AppColors.text3,
            ),
          ],
        ),
      ),
    );
  }
}

(String, Color, Color) _riskStyle(TradeBotRisk risk) {
  return switch (risk) {
    TradeBotRisk.low => (
      'Thấp',
      AppColors.buy.withValues(alpha: .12),
      AppColors.buy,
    ),
    TradeBotRisk.medium => (
      'Trung bình',
      AppColors.warn.withValues(alpha: .12),
      AppColors.warn,
    ),
    TradeBotRisk.high => (
      'Cao',
      AppColors.sell.withValues(alpha: .10),
      AppColors.sell,
    ),
  };
}

String _formatWholeNumber(double value) {
  final text = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) buffer.write(',');
    buffer.write(text[i]);
  }
  return buffer.toString();
}

String _formatSignedMoney(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign\$${value.abs().toStringAsFixed(2)}';
}

String _formatSignedPct(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}
