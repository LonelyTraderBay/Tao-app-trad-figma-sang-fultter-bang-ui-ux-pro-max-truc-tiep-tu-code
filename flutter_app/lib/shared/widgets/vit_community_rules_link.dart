import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

/// Open Arena community rules entry — ghost chip with book icon.
///
/// Do not wrap in an extra [VitCard] or duplicate local `_CommunityRules*`
/// widgets. Pass [onTap] as `null` for display-only footers.
class VitCommunityRulesLink extends StatelessWidget {
  const VitCommunityRulesLink({
    super.key,
    this.onTap,
    this.label = 'Quy tắc cộng đồng',
    this.center = true,
    this.semanticLabel,
  });

  final VoidCallback? onTap;
  final String label;
  final bool center;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final chip = VitCard(
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: AppSpacing.arenaCommunityRulesLinkPadding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.menu_book_outlined,
            color: AppColors.primary,
            size: AppSpacing.arenaCommunityRulesLinkIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.arenaCommunityRulesLinkLineHeight,
            ),
          ),
        ],
      ),
    );

    final content = Semantics(
      label: semanticLabel ?? label,
      button: onTap != null,
      enabled: onTap != null,
      child: chip,
    );

    if (!center) return content;

    return Align(alignment: AlignmentDirectional.center, child: content);
  }
}
