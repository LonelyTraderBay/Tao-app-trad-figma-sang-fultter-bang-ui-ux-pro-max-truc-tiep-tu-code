part of '../pages/p2p_2fa_settings_page.dart';

class _SecurityRecommendation extends StatelessWidget {
  const _SecurityRecommendation({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2P2FASettingsPage.recommendationKey,
      radius: VitCardRadius.md,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppModuleAccents.p2p,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Khuyến nghị bảo mật',
                  style: AppTextStyles.caption.copyWith(
                    color: AppModuleAccents.p2p,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  text,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.baseMedium.copyWith(fontWeight: AppTextStyles.bold),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Icon(icon, color: color, size: AppSpacing.iconMd),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _InlineNotice extends StatelessWidget {
  const _InlineNotice({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x3,
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: color, size: 12),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _methodColor(String colorKey) {
  return switch (colorKey) {
    'warning' => AppColors.warn,
    'p2p' => AppModuleAccents.p2p,
    _ => AppColors.buy,
  };
}

IconData _methodIcon(String iconKey) {
  return switch (iconKey) {
    'sms' => Icons.phone_iphone_rounded,
    'authenticator' => Icons.key_rounded,
    'email' => Icons.mail_outline_rounded,
    _ => Icons.security_rounded,
  };
}
