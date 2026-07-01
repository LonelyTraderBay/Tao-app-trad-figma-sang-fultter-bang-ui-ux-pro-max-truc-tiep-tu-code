part of '../pages/bot_emergency_stop_page.dart';

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.snapshot});

  final TradeBotEmergencyStopSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: const Key('sc121_bot_emergency_stop_warning'),
      variant: VitCardVariant.ghost,
      constraints: const BoxConstraints(minHeight: AppSpacing.buttonHero),
      padding: AppSpacing.tradeBotCardPadding,
      borderColor: _stopRed.withValues(alpha: .62),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitCard(
            width: AppSpacing.x6,
            height: AppSpacing.x6,
            alignment: Alignment.center,
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.large,
            borderColor: _stopRed,
            child: const Icon(Icons.priority_high_rounded, color: _stopRed),
          ),
          const SizedBox(width: AppSpacing.tradeBotContentGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.warningTitle,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: _stopRed,
                    letterSpacing: AppSpacing.dividerHairline,
                  ),
                ),
                const SizedBox(height: AppSpacing.tradeBotSmallGap),
                Text(
                  snapshot.warningDescription,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1.35,
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
    return VitCard(
      constraints: const BoxConstraints(minHeight: AppSpacing.buttonStandard),
      padding: AppSpacing.tradeBotCompactCardPadding,
      borderColor: AppColors.cardBorder,
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
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.tradeBotSmallGap),
                    VitAccentPill(
                      label: bot.statusLabel,
                      accentColor: _stopGreen,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.tradeBotRowGap),
                Text(
                  bot.pair,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.tradeBotRowGap),
          Text(
            '${bot.profit >= 0 ? '+' : ''}${bot.profit.toStringAsFixed(2)} USDT',
            style: AppTextStyles.caption.copyWith(
              color: profitColor,
              fontWeight: AppTextStyles.bold,
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
    return VitCard(
      key: BotEmergencyStopPage.reasonKey(reason.id),
      onTap: onTap,
      variant: selected ? VitCardVariant.ghost : VitCardVariant.standard,
      constraints: const BoxConstraints(minHeight: AppSpacing.buttonStandard),
      padding: AppSpacing.tradeBotCompactCardPadding,
      borderColor: selected ? _stopRed : _stopOptionBorder,
      child: Row(
        children: [
          _RadioMark(selected: selected, danger: selected),
          const SizedBox(width: AppSpacing.tradeBotRowGap),
          Icon(
            _reasonIcon(reason.iconName),
            color: _reasonColor(reason),
            size: AppSpacing.contentPad,
          ),
          const SizedBox(width: AppSpacing.tradeBotRowGap),
          Expanded(
            child: Text(
              reason.label,
              style: AppTextStyles.caption.copyWith(
                color: selected ? _stopRed : AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
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
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.ghost,
      padding: AppSpacing.tradeBotCompactCardPadding,
      borderColor: danger
          ? _stopRed.withValues(alpha: .48)
          : AppColors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CheckboxMark(selected: selected, color: activeColor),
          const SizedBox(width: AppSpacing.tradeBotRowGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: danger ? _stopRed : AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: danger ? AppColors.text2 : AppColors.text3,
                    height: 1.35,
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

class _SupportNotice extends StatelessWidget {
  const _SupportNotice({required this.snapshot});

  final TradeBotEmergencyStopSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.tradeBotCompactCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.tradeBotCardIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.supportTitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.tradeBotSmallGap),
                Text(
                  snapshot.supportDescription,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.35,
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
