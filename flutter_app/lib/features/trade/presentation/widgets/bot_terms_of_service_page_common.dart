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
    return SizedBox(
      key: BotTermsOfServicePage.ctaKey,
      height: 44,
      child: FilledButton(
        onPressed: agreed ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: agreed ? AppColors.primary : _termsPanel2,
          disabledBackgroundColor: _termsPanel2,
          disabledForegroundColor: AppColors.text3,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
        ),
        child: Text(
          agreed ? snapshot.enabledCta : snapshot.disabledCta,
          style: AppTextStyles.body.copyWith(
            color: agreed ? AppColors.onAccent : AppColors.text3,
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

class _ComplianceNote extends StatelessWidget {
  const _ComplianceNote({required this.snapshot});

  final TradeBotTermsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 112),
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      decoration: BoxDecoration(
        color: _termsPanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.shield_outlined,
              color: AppColors.text3,
              size: 17,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.complianceTitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.complianceDescription,
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
            color: _termsPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
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
