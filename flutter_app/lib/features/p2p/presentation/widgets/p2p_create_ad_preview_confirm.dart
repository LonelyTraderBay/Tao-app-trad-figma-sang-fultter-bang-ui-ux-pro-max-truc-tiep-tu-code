part of 'p2p_create_ad_sections.dart';

class P2PCreateAdLivePreviewCard extends StatelessWidget {
  const P2PCreateAdLivePreviewCard({
    super.key,
    required this.expanded,
    required this.onTap,
    required this.preview,
  });

  final bool expanded;
  final VoidCallback onTap;
  final P2PCreateAdPreview preview;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.p2pMerchantCommerceCardPadding,
      child: Column(
        children: [
          VitCard(
            onTap: onTap,
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.standard,
            padding: AppSpacing.zeroInsets,
            child: Row(
              children: [
                const Icon(
                  Icons.radio_button_checked_rounded,
                  color: AppColors.buy,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    'Live Preview',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                P2PCreateAdPreviewBadge(
                  label: preview.canPublish ? '100%' : '0%',
                ),
                const SizedBox(width: AppSpacing.x2),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconMd,
                ),
              ],
            ),
          ),
          if (expanded) ...[
            const SizedBox(height: AppSpacing.x4),
            P2PCreateAdConfirmRow(
              label: preview.typeLabel,
              value: preview.totalAmountLabel,
            ),
            P2PCreateAdConfirmRow(label: 'Giá', value: preview.priceLabel),
            P2PCreateAdConfirmRow(
              label: 'Thanh toán',
              value: preview.paymentSummary,
            ),
            P2PCreateAdConfirmRow(label: 'Limit', value: preview.limitSummary),
            P2PCreateAdConfirmRow(label: 'Fee', value: preview.feeReviewLabel),
          ],
        ],
      ),
    );
  }
}

class P2PCreateAdConfirmRow extends StatelessWidget {
  const P2PCreateAdConfirmRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.p2pMerchantCommerceSectionLabelPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSpacing.p2pMerchantCommerceConfirmLabelWidth,
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class P2PCreateAdInputBlock extends StatelessWidget {
  const P2PCreateAdInputBlock({
    super.key,
    required this.label,
    required this.child,
    this.hint,
  });

  final String label;
  final Widget child;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: AppSpacing.p2pMerchantCommerceSectionLabelPadding,
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        child,
        if (hint != null) ...[
          const SizedBox(height: AppSpacing.x2),
          Text(
            hint!,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ],
    );
  }
}
