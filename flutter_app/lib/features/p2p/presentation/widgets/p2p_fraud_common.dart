part of '../pages/p2p_fraud_prevention_page.dart';

class _Disclosure extends StatelessWidget {
  const _Disclosure({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: P2PFraudPreventionPage.disclosureKey,
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppColors.divider),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeverityBadge extends StatelessWidget {
  const _SeverityBadge({required this.severity});

  final String severity;

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(severity);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          _severityLabel(severity),
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontSize: 9,
          ),
        ),
      ),
    );
  }
}

String _categoryLabel(String category) {
  return switch (category) {
    'during' => 'Trong giao dịch',
    'after' => 'Sau giao dịch',
    _ => 'Trước giao dịch',
  };
}

String _severityLabel(String severity) {
  return switch (severity) {
    'medium' => 'Trung bình',
    'high' => 'Cao',
    _ => 'Nguy hiểm',
  };
}

Color _scoreColor(int score) {
  if (score >= 80) return AppColors.buy;
  if (score >= 50) return AppColors.warn;
  return AppColors.sell;
}

Color _severityColor(String severity) {
  return switch (severity) {
    'medium' => AppModuleAccents.p2p,
    'high' => AppColors.warn,
    _ => AppColors.sell,
  };
}

Color _actionColor(String toneKey) {
  return switch (toneKey) {
    'warning' => AppColors.warn,
    'muted' => AppColors.text2,
    _ => AppColors.sell,
  };
}

IconData _patternIcon(String iconKey) {
  return switch (iconKey) {
    'globe' => Icons.public_rounded,
    'bank' => Icons.account_balance_wallet_outlined,
    'user' => Icons.person_off_outlined,
    'triangle' => Icons.report_gmailerrorred_rounded,
    _ => Icons.credit_card_off_outlined,
  };
}

IconData _actionIcon(String iconKey) {
  return switch (iconKey) {
    'phone' => Icons.phone_outlined,
    'flag' => Icons.flag_outlined,
    _ => Icons.shield_outlined,
  };
}
