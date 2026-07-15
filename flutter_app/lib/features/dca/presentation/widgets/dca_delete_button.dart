import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/dca_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Square, danger-tinted icon tile used to trigger row/card deletion across
/// DCA flows (smart rule cards, multi-asset allocation setup).
///
/// Shared so both hosts render the exact same tile (fixed [AppSpacing.buttonCompact]
/// square, no border, [AppColors.sell10] surface with a centered delete icon).
class DcaDeleteButton extends StatelessWidget {
  const DcaDeleteButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      onTap: onPressed,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: EdgeInsets.zero,
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      borderColor: AppColors.transparent,
      clip: true,
      child: const DecoratedBox(
        decoration: ShapeDecoration(
          color: AppColors.sell10,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          size: DcaSpacingTokens.dcaMainInlineIcon,
          color: AppColors.sell,
        ),
      ),
    );
  }
}
