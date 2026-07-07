import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/dev/domain/entities/dev_tools_entities.dart';
import 'package:vit_trade_flutter/app/theme/spacing/admin_spacing_tokens.dart';

class DesignSystemFooter extends StatelessWidget {
  const DesignSystemFooter({super.key, required this.snapshot});

  final DesignSystemSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        shape: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: AdminSpacingTokens.devVerticalPaddingX5,
        child: Column(
          children: [
            Text(
              snapshot.footerTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              snapshot.footerSubtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.chartLabelXs.copyWith(
                color: AppColors.text3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
