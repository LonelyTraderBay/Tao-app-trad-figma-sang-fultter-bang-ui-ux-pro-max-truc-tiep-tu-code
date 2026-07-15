import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/dev/domain/entities/dev_tools_entities.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/design_system_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/admin_spacing_tokens.dart';

class DesignSystemTokensSection extends StatelessWidget {
  const DesignSystemTokensSection({
    super.key,
    required this.sectionKey,
    required this.tokens,
  });

  final Key sectionKey;
  final List<DesignTokenDraft> tokens;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: sectionKey,
      label: 'Design Tokens',
      children: [
        VitCard(
          padding: AdminSpacingTokens.devTokenCardPadding,
          radius: VitCardRadius.large,
          child: Column(
            children: [
              for (final token in tokens) ...[
                VitKeyValueRow(
                  padding: AdminSpacingTokens.devVerticalPaddingX3,
                  label: token.label,
                  value: token.value,
                  labelStyle: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                  ),
                  valueStyle: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                if (token != tokens.last) const DesignSystemDivider(),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
