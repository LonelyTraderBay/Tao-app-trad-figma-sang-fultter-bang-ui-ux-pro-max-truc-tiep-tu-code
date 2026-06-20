import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_api_documentation_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

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
              radius: VitCardRadius.lg,
              padding: AppSpacing.earnCardPaddingX4,
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
                            Text(
                              'API Key Authentication',
                              style: AppTextStyles.baseMedium,
                            ),
                            const SizedBox(height: AppSpacing.x2),
                            Text(
                              'Include your API key in the X-API-Key header with every request.',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                                height: AppSpacing.stakingApiAuthLineHeight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  StakingApiDocumentationCodeBlock(
                    text: snapshot.authHeaderExample,
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  SizedBox(
                    height: AppSpacing.ctaHeight,
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Generate API Key in Settings ->'),
                    ),
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
              radius: VitCardRadius.lg,
              padding: AppSpacing.earnCardPaddingX4,
              child: Column(
                children: [
                  for (final error in snapshot.errorCodes) ...[
                    _ErrorCodeRow(error: error),
                    if (error != snapshot.errorCodes.last)
                      const SizedBox(height: AppSpacing.x2),
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
      radius: VitCardRadius.lg,
      borderColor: tier.recommended ? AppColors.primary : null,
      padding: AppSpacing.earnCardPaddingX4,
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
          const SizedBox(height: AppSpacing.x3),
          VitCard(
            variant: VitCardVariant.inner,
            padding: AppSpacing.earnCardPaddingX3,
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
                      padding: AppSpacing.earnBottomPaddingX1,
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
            const SizedBox(height: AppSpacing.x3),
            SizedBox(
              height: AppSpacing.ctaHeight,
              child: FilledButton(
                onPressed: () {},
                child: const Text('Contact Sales'),
              ),
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
      padding: AppSpacing.earnCardPaddingX3,
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
