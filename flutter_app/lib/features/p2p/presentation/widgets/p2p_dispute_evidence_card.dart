import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/p2p/domain/entities/p2p_entities.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/widgets/p2p_dispute_detail_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class P2PDisputeEvidenceCard extends StatelessWidget {
  const P2PDisputeEvidenceCard({
    super.key,
    required this.addEvidenceKey,
    required this.evidence,
    required this.onAdd,
  });

  final Key addEvidenceKey;
  final List<P2PDisputeEvidenceDraft> evidence;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.p2pDisputeCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Bằng chứng (${evidence.length})',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              P2PDisputeSmallButton(
                key: addEvidenceKey,
                icon: Icons.upload_outlined,
                label: 'Thêm',
                color: AppModuleAccents.p2p,
                onPressed: onAdd,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final item in evidence)
                Container(
                  width: AppSpacing.p2pDisputeEvidenceThumb,
                  height: AppSpacing.p2pDisputeEvidenceThumb,
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    border: Border.all(color: AppColors.borderSolid),
                    borderRadius: AppRadii.inputRadius,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.image_outlined,
                        color: AppColors.text3,
                        size: AppSpacing.iconMd,
                      ),
                      Positioned(
                        left: AppSpacing.x1,
                        right: AppSpacing.x1,
                        bottom: AppSpacing.x1,
                        child: Text(
                          item.fileName,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
