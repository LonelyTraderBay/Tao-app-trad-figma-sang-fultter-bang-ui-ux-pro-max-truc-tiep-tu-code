import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class P2PDisputeActionsCard extends StatelessWidget {
  const P2PDisputeActionsCard({
    super.key,
    required this.manageEvidenceKey,
    required this.disputesKey,
    required this.onManageEvidence,
    required this.onOpenDisputes,
  });

  final Key manageEvidenceKey;
  final Key disputesKey;
  final VoidCallback onManageEvidence;
  final VoidCallback onOpenDisputes;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.p2pDisputeCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.description_outlined,
                color: AppColors.text1,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Hành động',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _ActionTile(
            key: manageEvidenceKey,
            icon: Icons.upload_outlined,
            title: 'Quản lý bằng chứng',
            subtitle:
                'Upload & xem tài liệu đã gửi; mock/fail-closed, chưa gửi backend.',
            color: AppModuleAccents.p2p,
            onTap: onManageEvidence,
          ),
          const SizedBox(height: AppSpacing.x2),
          _ActionTile(
            key: disputesKey,
            icon: Icons.balance_rounded,
            title: 'Danh sách tranh chấp',
            subtitle: 'Xem tất cả tranh chấp của bạn',
            color: AppColors.text2,
            onTap: onOpenDisputes,
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.sm,
      borderColor: color.withValues(alpha: .18),
      background: ColoredBox(color: color.withValues(alpha: .08)),
      clip: true,
      constraints: const BoxConstraints(minHeight: AppSpacing.buttonStandard),
      padding: AppSpacing.p2pDisputeActionTilePadding,
      child: Row(
        children: [
          Material(
            color: color.withValues(alpha: .14),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.smRadius,
            ),
            child: SizedBox(
              width: AppSpacing.p2pDisputeActionIconBox,
              height: AppSpacing.p2pDisputeActionIconBox,
              child: Icon(icon, color: color, size: AppSpacing.iconSm),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}
