part of '../pages/bot_emergency_stop_page.dart';

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
                : AppColors.transparent,
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
