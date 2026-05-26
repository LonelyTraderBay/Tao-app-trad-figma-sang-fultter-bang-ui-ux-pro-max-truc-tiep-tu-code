import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';

const _stopBackground = AppColors.bg;
const _stopPanel = AppColors.surface;
const _stopPanel2 = AppColors.surface2;
const _stopPrimary = AppColors.primary;
const _stopGreen = Color(0xFF10B981);
const _stopRed = Color(0xFFEF4444);
const _stopOptionBorder = AppColors.borderSolid;

class BotEmergencyStopPage extends ConsumerStatefulWidget {
  const BotEmergencyStopPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc121_bot_emergency_stop_content');
  static const cancelKey = Key('sc121_bot_emergency_stop_cancel');
  static const submitKey = Key('sc121_bot_emergency_stop_submit');
  static const closePositionsKey = Key(
    'sc121_bot_emergency_stop_close_positions',
  );
  static const confirmationKey = Key('sc121_bot_emergency_stop_confirm');

  static Key reasonKey(String reasonId) =>
      Key('sc121_bot_emergency_stop_reason_$reasonId');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotEmergencyStopPage> createState() =>
      _BotEmergencyStopPageState();
}

class _BotEmergencyStopPageState extends ConsumerState<BotEmergencyStopPage> {
  String? _reasonId;
  bool _closePositions = false;
  bool _confirmed = false;
  bool _stopping = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeRepositoryProvider).getBotEmergencyStop();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 116
            : DeviceMetrics.nativeBottomChrome + 40) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-121 BotEmergencyStopPage',
      child: Material(
        color: _stopBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Emergency Stop',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeBots),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: BotEmergencyStopPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 13, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _WarningBanner(snapshot: snapshot),
                    const SizedBox(height: 19),
                    _SectionLabel('Bots to Stop (${snapshot.bots.length})'),
                    const SizedBox(height: 10),
                    for (final bot in snapshot.bots) ...[
                      _BotCard(bot: bot),
                      if (bot != snapshot.bots.last) const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 18),
                    const _SectionLabel('Reason for Emergency Stop'),
                    const SizedBox(height: 10),
                    for (final reason in snapshot.reasons) ...[
                      _ReasonOption(
                        reason: reason,
                        selected: reason.id == _reasonId,
                        onTap: () => setState(() => _reasonId = reason.id),
                      ),
                      if (reason != snapshot.reasons.last)
                        const SizedBox(height: 9),
                    ],
                    const SizedBox(height: 18),
                    const _SectionLabel('Additional Actions'),
                    const SizedBox(height: 10),
                    _CheckActionCard(
                      key: BotEmergencyStopPage.closePositionsKey,
                      selected: _closePositions,
                      title: snapshot.closePositionsTitle,
                      description: snapshot.closePositionsDescription,
                      danger: false,
                      onTap: () {
                        setState(() => _closePositions = !_closePositions);
                      },
                    ),
                    const SizedBox(height: 18),
                    const _SectionLabel('Confirmation'),
                    const SizedBox(height: 10),
                    _CheckActionCard(
                      key: BotEmergencyStopPage.confirmationKey,
                      selected: _confirmed,
                      title: snapshot.confirmationTitle,
                      description: snapshot.confirmationDescription,
                      danger: true,
                      onTap: () => setState(() => _confirmed = !_confirmed),
                    ),
                    const SizedBox(height: 18),
                    _SupportNotice(snapshot: snapshot),
                  ],
                ),
              ),
            ),
            _StickyActions(
              bottomPadding: mode.usesVisualQaFrame
                  ? DeviceMetrics.bottomChrome + 6
                  : 20 + MediaQuery.paddingOf(context).bottom,
              canSubmit: _reasonId != null && _confirmed && !_stopping,
              stopping: _stopping,
              onCancel: () => context.go(AppRoutePaths.tradeBots),
              onSubmit: () => _submit(snapshot),
            ),
          ],
        ),
      ),
    );
  }

  void _submit(TradeBotEmergencyStopSnapshot snapshot) {
    if (_reasonId == null || !_confirmed || _stopping) return;
    setState(() => _stopping = true);
    final result = ref
        .read(tradeRepositoryProvider)
        .submitBotEmergencyStop(
          TradeBotEmergencyStopDraft(
            reasonId: _reasonId!,
            closePositions: _closePositions,
            confirmed: _confirmed,
          ),
        );
    context.go(result.redirectPath);
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.snapshot});

  final TradeBotEmergencyStopSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 160),
      padding: const EdgeInsets.fromLTRB(20, 23, 18, 20),
      decoration: BoxDecoration(
        color: _stopRed.withValues(alpha: .14),
        border: Border.all(color: _stopRed.withValues(alpha: .62), width: 2),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _stopRed, width: 3),
            ),
            child: const Icon(Icons.priority_high_rounded, color: _stopRed),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.warningTitle,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: _stopRed,
                    fontSize: 20,
                    letterSpacing: .8,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 13),
                Text(
                  snapshot.warningDescription,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    fontWeight: AppTextStyles.bold,
                    height: 1.55,
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

class _BotCard extends StatelessWidget {
  const _BotCard({required this.bot});

  final TradeBotEmergencyBot bot;

  @override
  Widget build(BuildContext context) {
    final profitColor = bot.profit >= 0 ? _stopGreen : _stopRed;
    return Container(
      constraints: const BoxConstraints(minHeight: 70),
      padding: const EdgeInsets.fromLTRB(12, 14, 13, 13),
      decoration: BoxDecoration(
        color: _stopPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        bot.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 13,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      decoration: BoxDecoration(
                        color: _stopGreen.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        bot.statusLabel,
                        style: AppTextStyles.micro.copyWith(
                          color: _stopGreen,
                          fontSize: 11,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                Text(
                  bot.pair,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${bot.profit >= 0 ? '+' : ''}${bot.profit.toStringAsFixed(2)} USDT',
            style: AppTextStyles.caption.copyWith(
              color: profitColor,
              fontSize: 14,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReasonOption extends StatelessWidget {
  const _ReasonOption({
    required this.reason,
    required this.selected,
    required this.onTap,
  });

  final TradeBotEmergencyReason reason;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: BotEmergencyStopPage.reasonKey(reason.id),
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        constraints: const BoxConstraints(minHeight: AppSpacing.buttonStandard),
        padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
        decoration: BoxDecoration(
          color: selected ? _stopRed.withValues(alpha: .08) : _stopPanel,
          border: Border.all(
            color: selected ? _stopRed : _stopOptionBorder,
            width: 2,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          children: [
            _RadioMark(selected: selected, danger: selected),
            const SizedBox(width: 13),
            Icon(
              _reasonIcon(reason.iconName),
              color: _reasonColor(reason),
              size: 20,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                reason.label,
                style: AppTextStyles.caption.copyWith(
                  color: selected ? _stopRed : AppColors.text1,
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckActionCard extends StatelessWidget {
  const _CheckActionCard({
    super.key,
    required this.selected,
    required this.title,
    required this.description,
    required this.danger,
    required this.onTap,
  });

  final bool selected;
  final String title;
  final String description;
  final bool danger;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = danger ? _stopRed : _stopPrimary;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        padding: const EdgeInsets.fromLTRB(15, 14, 14, 15),
        decoration: BoxDecoration(
          color: danger
              ? _stopRed.withValues(alpha: .08)
              : _stopPanel2.withValues(alpha: .9),
          border: Border.all(
            color: danger
                ? _stopRed.withValues(alpha: .48)
                : Colors.transparent,
            width: 2,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CheckboxMark(selected: selected, color: activeColor),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.caption.copyWith(
                      color: danger ? _stopRed : AppColors.text1,
                      fontSize: 13,
                      fontWeight: AppTextStyles.bold,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: AppTextStyles.caption.copyWith(
                      color: danger ? AppColors.text2 : AppColors.text3,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportNotice extends StatelessWidget {
  const _SupportNotice({required this.snapshot});

  final TradeBotEmergencyStopSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: _stopPanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.text3, size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.supportTitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  snapshot.supportDescription,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                    height: 1.55,
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

class _StickyActions extends StatelessWidget {
  const _StickyActions({
    required this.bottomPadding,
    required this.canSubmit,
    required this.stopping,
    required this.onCancel,
    required this.onSubmit,
  });

  final double bottomPadding;
  final bool canSubmit;
  final bool stopping;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, bottomPadding),
      decoration: BoxDecoration(
        color: _stopBackground.withValues(alpha: .94),
        border: Border(
          top: BorderSide(color: AppColors.cardBorder.withValues(alpha: .7)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 44,
              child: FilledButton(
                key: BotEmergencyStopPage.cancelKey,
                onPressed: onCancel,
                style: FilledButton.styleFrom(
                  backgroundColor: _stopPanel2,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.inputRadius,
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 44,
              child: FilledButton.icon(
                key: BotEmergencyStopPage.submitKey,
                onPressed: canSubmit ? onSubmit : null,
                style: FilledButton.styleFrom(
                  backgroundColor: canSubmit ? _stopRed : _stopPanel,
                  disabledBackgroundColor: _stopPanel,
                  foregroundColor: Colors.white,
                  disabledForegroundColor: AppColors.text3.withValues(
                    alpha: .4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.inputRadius,
                  ),
                ),
                icon: stopping
                    ? const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.pause_rounded,
                        size: 16,
                        color: canSubmit
                            ? Colors.white
                            : AppColors.text3.withValues(alpha: .32),
                      ),
                label: Text(
                  stopping ? 'Stopping...' : 'Stop All Bots Now',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: canSubmit
                        ? Colors.white
                        : AppColors.text3.withValues(alpha: .32),
                    fontSize: 13,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _stopPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _RadioMark extends StatelessWidget {
  const _RadioMark({required this.selected, required this.danger});

  final bool selected;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? _stopRed : _stopOptionBorder;
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: selected
          ? Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            )
          : null,
    );
  }
}

class _CheckboxMark extends StatelessWidget {
  const _CheckboxMark({required this.selected, required this.color});

  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.only(top: 1),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? color : Colors.transparent,
        border: Border.all(
          color: selected ? color : _stopOptionBorder,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: selected
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
          : null,
    );
  }
}

IconData _reasonIcon(String iconName) {
  return switch (iconName) {
    'crash' => Icons.show_chart_rounded,
    'bug' => Icons.settings_suggest_rounded,
    'unauthorized' => Icons.warning_amber_rounded,
    'drawdown' => Icons.error_outline_rounded,
    _ => Icons.help_outline_rounded,
  };
}

Color _reasonColor(TradeBotEmergencyReason reason) {
  return switch (reason.iconName) {
    'crash' => const Color(0xFFE879F9),
    'bug' => const Color(0xFF34D399),
    'unauthorized' => const Color(0xFFF87171),
    'drawdown' => const Color(0xFFFBBF24),
    _ => AppColors.text2,
  };
}
