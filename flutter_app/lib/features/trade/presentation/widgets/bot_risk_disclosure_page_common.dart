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
    return InkWell(
      key: BotRiskDisclosurePage.acknowledgmentKey,
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        constraints: const BoxConstraints(minHeight: 101),
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
        decoration: BoxDecoration(
          color: _botRiskPanel2,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: acknowledged ? _botRiskRed : AppColors.transparent,
                border: Border.all(
                  color: acknowledged ? _botRiskRed : AppColors.borderSolid,
                ),
                borderRadius: AppRadii.mdRadius,
              ),
              child: acknowledged
                  ? const Icon(
                      Icons.check_circle_outline_rounded,
                      color: AppColors.onAccent,
                      size: 16,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.acknowledgmentTitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 13,
                      fontWeight: AppTextStyles.bold,
                      height: 1.28,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    snapshot.acknowledgmentDescription,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontSize: 12,
                      height: 1.38,
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
    return SizedBox(
      key: BotRiskDisclosurePage.ctaKey,
      height: 44,
      child: FilledButton(
        onPressed: acknowledged ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: acknowledged ? _botRiskRed : _botRiskPanel2,
          disabledBackgroundColor: _botRiskPanel2,
          disabledForegroundColor: AppColors.text3,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
        ),
        child: Text(
          acknowledged ? snapshot.enabledCta : snapshot.disabledCta,
          style: AppTextStyles.body.copyWith(
            color: acknowledged ? AppColors.onAccent : AppColors.text3,
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _HelpCard extends StatelessWidget {
  const _HelpCard({required this.snapshot});

  final TradeBotRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 15),
      decoration: BoxDecoration(
        color: _botRiskPanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            snapshot.helpTitle,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            snapshot.helpDescription,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            snapshot.helpCta,
            style: AppTextStyles.caption.copyWith(
              color: _botRiskPrimary,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1,
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
            color: _botRiskPrimary,
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

class _BulletText extends StatelessWidget {
  const _BulletText(this.text, {required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•',
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontSize: 12,
            height: 1.45,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontSize: 12,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({super.key, required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _botRiskPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
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
