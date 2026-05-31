import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/p2p/domain/entities/p2p_entities.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/widgets/p2p_dispute_detail_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class P2PDisputeStatusBanner extends StatelessWidget {
  const P2PDisputeStatusBanner({super.key, required this.dispute});

  final P2PDisputeDraft dispute;

  @override
  Widget build(BuildContext context) {
    final color = p2pDisputeStatusColor(dispute.status);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        border: Border.all(color: color.withValues(alpha: .22)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: AppRadii.inputRadius,
            ),
            child: Icon(
              p2pDisputeStatusIcon(dispute.status),
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dispute.statusLabel,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: color,
                    fontSize: 20,
                  ),
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
    );
  }
}

class P2PDisputeReasonCard extends StatelessWidget {
  const P2PDisputeReasonCard({super.key, required this.dispute});

  final P2PDisputeDraft dispute;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
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
          const SizedBox(height: AppSpacing.x3),
          Text(
            dispute.reason,
            style: AppTextStyles.body.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: AppSpacing.x3),
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
