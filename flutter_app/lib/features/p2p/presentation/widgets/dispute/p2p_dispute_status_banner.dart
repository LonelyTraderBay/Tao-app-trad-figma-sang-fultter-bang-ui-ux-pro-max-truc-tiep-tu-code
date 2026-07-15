part of 'p2p_dispute_widgets.dart';

class P2PDisputeStatusBanner extends StatelessWidget {
  const P2PDisputeStatusBanner({super.key, required this.dispute});

  final P2PDisputeDraft dispute;

  @override
  Widget build(BuildContext context) {
    final color = p2pDisputeStatusColor(dispute.status);
    return Material(
      color: color.withValues(alpha: .08),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.cardRadius,
        side: BorderSide(color: color.withValues(alpha: .22)),
      ),
      child: Padding(
        padding: P2PSpacingTokens.p2pDisputeCardPadding,
        child: Row(
          children: [
            Material(
              color: color.withValues(alpha: .12),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.inputRadius,
              ),
              child: SizedBox(
                width: P2PSpacingTokens.p2pDisputeStatusIconBox,
                height: P2PSpacingTokens.p2pDisputeStatusIconBox,
                child: Icon(
                  p2pDisputeStatusIcon(dispute.status),
                  color: color,
                  size: P2PSpacingTokens.p2pDisputeStatusIcon,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dispute.statusLabel,
                    style: AppTextStyles.amountSm.copyWith(color: color),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    'Đơn hàng #${dispute.orderNumber}',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text2),
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

class P2PDisputeReasonCard extends StatelessWidget {
  const P2PDisputeReasonCard({super.key, required this.dispute});

  final P2PDisputeDraft dispute;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pDisputeCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lý do khiếu nại',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            dispute.reason,
            style: AppTextStyles.body.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const Divider(
            color: AppColors.divider,
            height: AppSpacing.dividerHairline,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Mô tả chi tiết',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            dispute.description,
            style: AppTextStyles.body.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}
