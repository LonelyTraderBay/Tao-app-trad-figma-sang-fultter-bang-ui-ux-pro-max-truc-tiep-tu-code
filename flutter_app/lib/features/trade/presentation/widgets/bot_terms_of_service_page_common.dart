part of '../pages/bot_terms_of_service_page.dart';

class _TermsCta extends StatelessWidget {
  const _TermsCta({
    required this.snapshot,
    required this.agreed,
    required this.onPressed,
  });

  final TradeBotTermsSnapshot snapshot;
  final bool agreed;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: BotTermsOfServicePage.ctaKey,
      height: AppSpacing.tradeBotControlCompact,
      onPressed: agreed ? onPressed : null,
      child: Text(
        agreed ? snapshot.enabledCta : snapshot.disabledCta,
        style: AppTextStyles.body.copyWith(
          fontWeight: AppTextStyles.bold,
          height: _termsLineTight,
        ),
      ),
    );
  }
}

class _ComplianceNote extends StatelessWidget {
  const _ComplianceNote({required this.snapshot});

  final TradeBotTermsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      constraints: const BoxConstraints(minHeight: _termsComplianceMinExtent),
      padding: AppSpacing.tradeBotCardPaddingLoose,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: AppSpacing.tradeBotIntroIconTopPadding,
            child: Icon(
              Icons.shield_outlined,
              color: AppColors.text3,
              size: AppSpacing.tradeBotMediumIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.tradeBotCardIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.complianceTitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: _termsLineCaption,
                  ),
                ),
                const SizedBox(height: _termsTinySpace),
                Text(
                  snapshot.complianceDescription,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: _termsLineReadable,
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
