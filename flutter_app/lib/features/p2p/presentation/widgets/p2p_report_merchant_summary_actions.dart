part of '../pages/p2p_report_merchant_page.dart';

class _MerchantSummaryCard extends StatelessWidget {
  const _MerchantSummaryCard({required this.snapshot});

  final P2PReportMerchantSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final merchant = snapshot.merchant;
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _MerchantAvatar(name: merchant.name),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  merchant.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'ID: ${snapshot.merchantId}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MerchantAvatar extends StatelessWidget {
  const _MerchantAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppModuleAccents.p2p, AppColors.accent],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.x6),
      ),
      alignment: Alignment.center,
      child: Text(
        name.characters.first.toUpperCase(),
        style: AppTextStyles.baseMedium.copyWith(
          color: AppColors.navCenterIcon,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _ReportActionRow extends StatelessWidget {
  const _ReportActionRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.foreground,
    required this.background,
    required this.borderColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color foreground;
  final Color background;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      borderRadius: AppRadii.cardRadius,
      child: Ink(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: borderColor),
          borderRadius: AppRadii.cardRadius,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.cardRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x4,
              vertical: AppSpacing.x3,
            ),
            child: Row(
              children: [
                Icon(icon, color: foreground, size: AppSpacing.iconSm),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: foreground,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
