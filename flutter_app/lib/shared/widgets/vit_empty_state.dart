import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';

class VitEmptyState extends StatelessWidget {
  const VitEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.actionKey,
    this.onAction,
  });

  final String title;
  final String? message;
  final IconData icon;
  final String? actionLabel;
  final Key? actionKey;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x6,
        vertical: 64,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surface2,
              border: Border.all(color: AppColors.borderSolid),
              borderRadius: AppRadii.cardLargeRadius,
            ),
            child: Icon(icon, color: AppColors.borderSolid, size: 36),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(color: AppColors.text2),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.x2),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.x4),
            VitCtaButton(
              key: actionKey,
              onPressed: onAction,
              fullWidth: false,
              height: 44,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
