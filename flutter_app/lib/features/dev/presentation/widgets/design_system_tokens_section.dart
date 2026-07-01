import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/dev/domain/entities/dev_tools_entities.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/design_system_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

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
          padding: AppSpacing.devTokenCardPadding,
          radius: VitCardRadius.large,
          child: Column(
            children: [
              for (final token in tokens) ...[
                _TokenRow(token: token),
                if (token != tokens.last) const DesignSystemDivider(),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TokenRow extends StatelessWidget {
  const _TokenRow({required this.token});

  final DesignTokenDraft token;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.devVerticalPaddingX3,
      child: Row(
        children: [
          Expanded(
            child: Text(
              token.label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          Text(
            token.value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
