part of '../pages/bot_risk_disclosure_page.dart';

class _AcknowledgmentCard extends StatelessWidget {
  const _AcknowledgmentCard({
    required this.snapshot,
    required this.acknowledged,
    required this.onTap,
  });

  final TradeBotRiskDisclosureSnapshot snapshot;
  final bool acknowledged;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: BotRiskDisclosurePage.acknowledgmentKey,
      onTap: onTap,
      variant: VitCardVariant.inner,
      constraints: const BoxConstraints(
        minHeight: AppSpacing.tradeBotApiKeyCardMinHeight,
      ),
      padding: AppSpacing.tradeBotCardPadding,
      borderColor: acknowledged ? _botRiskRed : AppColors.borderSolid,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            acknowledged
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank_rounded,
            color: acknowledged ? _botRiskRed : AppColors.text3,
            size: AppSpacing.tradeBotCheckbox,
          ),
          const SizedBox(width: AppSpacing.tradeBotCardGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.acknowledgmentTitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.tradeBotSmallGap),
                Text(
                  snapshot.acknowledgmentDescription,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskCta extends StatelessWidget {
  const _RiskCta({
    required this.snapshot,
    required this.acknowledged,
    required this.onPressed,
  });

  final TradeBotRiskDisclosureSnapshot snapshot;
  final bool acknowledged;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: BotRiskDisclosurePage.ctaKey,
      height: AppSpacing.tradeBotSheetActionHeight,
      variant: VitCtaButtonVariant.danger,
      onPressed: acknowledged ? onPressed : null,
      child: Text(acknowledged ? snapshot.enabledCta : snapshot.disabledCta),
    );
  }
}

class _HelpCard extends StatelessWidget {
  const _HelpCard({required this.snapshot});

  final TradeBotRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.tradeBotCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            snapshot.helpTitle,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeBotSmallGap),
          Text(
            snapshot.helpDescription,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.tradeBotRowGap),
          Text(
            snapshot.helpCta,
            style: AppTextStyles.caption.copyWith(
              color: _botRiskPrimary,
              fontWeight: AppTextStyles.bold,
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
    return VitSectionHeader(
      title: label,
      variant: VitSectionHeaderVariant.accentBar,
      accentColor: _botRiskPrimary,
    );
  }
}

class _BulletText extends StatelessWidget {
  const _BulletText(this.text, {required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('â€¢', style: AppTextStyles.caption.copyWith(color: color)),
        const SizedBox(width: AppSpacing.tradeBotRowGap),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

Color _colorForKind(TradeBotRiskKind kind) {
  return switch (kind) {
    TradeBotRiskKind.market => _botRiskRed,
    TradeBotRiskKind.leverage => _botRiskAmber,
    TradeBotRiskKind.liquidity => _botRiskPurple,
    TradeBotRiskKind.technical => _botRiskRed,
    TradeBotRiskKind.timing => _botRiskPrimary,
    TradeBotRiskKind.regulatory => _botRiskGreen,
  };
}

IconData _iconForKind(TradeBotRiskKind kind) {
  return switch (kind) {
    TradeBotRiskKind.market => Icons.trending_down_rounded,
    TradeBotRiskKind.leverage => Icons.bolt_rounded,
    TradeBotRiskKind.liquidity => Icons.attach_money_rounded,
    TradeBotRiskKind.technical => Icons.warning_amber_rounded,
    TradeBotRiskKind.timing => Icons.schedule_rounded,
    TradeBotRiskKind.regulatory => Icons.shield_outlined,
  };
}
