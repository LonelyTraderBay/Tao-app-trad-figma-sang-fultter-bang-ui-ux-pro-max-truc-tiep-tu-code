import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking/staking_api_documentation_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

void _showComingSoon(BuildContext context, String message) {
  HapticFeedback.selectionClick();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

class StakingApiDocumentationAuthTab extends StatelessWidget {
  const StakingApiDocumentationAuthTab({super.key, required this.snapshot});

  final StakingApiDocumentationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingApiDocumentationKeys.auth,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Authentication',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.large,
              padding: EarnSpacingTokens.earnCardPaddingX4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.key_rounded,
                        color: AppColors.primarySoft,
                        size: AppSpacing.iconMd,
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'API Key Authentication',
                              style: AppTextStyles.baseMedium,
                            ),
                            const SizedBox(
                              height: AppSpacing.pageRhythmCompactInnerGap,
                            ),
                            Text(
                              'Include your API key in the X-API-Key header with every request.',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                                height:
                                    EarnSpacingTokens.stakingApiAuthLineHeight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  StakingApiDocumentationCodeBlock(
                    text: snapshot.authHeaderExample,
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  VitCtaButton(
                    variant: VitCtaButtonVariant.ghost,
                    height: AppSpacing.ctaHeight,
                    onPressed: () => _showComingSoon(
                      context,
                      'Tạo API Key trong Cài đặt sẽ sớm ra mắt',
                    ),
                    child: const Text('Generate API Key in Settings ->'),
                  ),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          label: 'Rate Limits',
          accentColor: AppColors.primarySoft,
          children: [
            for (final tier in snapshot.rateLimits) _RateLimitCard(tier: tier),
          ],
        ),
        VitPageSection(
          label: 'Error Codes',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.large,
              padding: EarnSpacingTokens.earnCardPaddingX4,
              child: Column(
                children: [
                  for (final error in snapshot.errorCodes) ...[
                    _ErrorCodeRow(error: error),
                    if (error != snapshot.errorCodes.last)
                      const SizedBox(
                        height: AppSpacing.pageRhythmCompactInnerGap,
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RateLimitCard extends StatelessWidget {
  const _RateLimitCard({required this.tier});

  final StakingApiRateLimitDraft tier;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      borderColor: tier.recommended ? AppColors.primary : null,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tier.tier, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      tier.price,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              if (tier.recommended)
                const StakingApiDocumentationStatusPill(
                  label: 'Recommended',
                  color: AppColors.primarySoft,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCard(
            variant: VitCardVariant.inner,
            padding: EarnSpacingTokens.earnCardPaddingX3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      stakingApiDocumentationFormatInt(tier.requests),
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Padding(
                      padding: EarnSpacingTokens.earnBottomPaddingX1,
                      child: Text(
                        'requests',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'per ${tier.window}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          if (tier.tier == 'Enterprise') ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            VitCtaButton(
              height: AppSpacing.ctaHeight,
              onPressed: () =>
                  _showComingSoon(context, 'Liên hệ Sales sẽ sớm ra mắt'),
              child: const Text('Contact Sales'),
            ),
          ],
        ],
      ),
    );
  }
}

class _ErrorCodeRow extends StatelessWidget {
  const _ErrorCodeRow({required this.error});

  final StakingApiErrorCodeDraft error;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StakingApiDocumentationStatusPill(
            label: error.code.toString(),
            color: AppColors.sell,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              error.message,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}
