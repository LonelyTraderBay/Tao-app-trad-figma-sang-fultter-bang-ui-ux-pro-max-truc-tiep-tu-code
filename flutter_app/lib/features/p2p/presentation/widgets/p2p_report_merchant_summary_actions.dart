part of '../pages/p2p_report_merchant_page.dart';

class _MerchantSummaryCard extends StatelessWidget {
  const _MerchantSummaryCard({required this.snapshot});

  final P2PReportMerchantSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final merchant = snapshot.merchant;
    return VitCard(
      padding: AppSpacing.p2pRiskControlsCardPadding,
      child: Row(
        children: [
          VitAssetAvatar(
            label: merchant.name,
            accentColor: AppModuleAccents.p2p,
            size: AppSpacing.p2pRiskControlsAvatarSize,
            radius: AppRadii.pillRadius,
            border: true,
          ),
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
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.cardRadius,
        side: BorderSide(color: borderColor),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
        ),
        child: Padding(
          padding: AppSpacing.p2pRiskControlsActionPadding,
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
    );
  }
}
