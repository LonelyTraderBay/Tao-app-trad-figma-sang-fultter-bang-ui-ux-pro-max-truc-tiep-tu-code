import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_custody_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class StakingCustodyHeroCard extends StatelessWidget {
  const StakingCustodyHeroCard({super.key, required this.snapshot});

  final StakingCustodySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingCustodyKeys.hero,
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: AppSpacing.earnCardPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            color: AppColors.buy,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.heroTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.heroBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.stakingCustodyBodyLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StakingCustodyFeedbackNote extends StatelessWidget {
  const StakingCustodyFeedbackNote({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingCustodyKeys.feedback,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: AppSpacing.earnCardPaddingX3,
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.primarySoft,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StakingCustodyCustodianSection extends StatelessWidget {
  const StakingCustodyCustodianSection({super.key, required this.custodian});

  final StakingCustodianDraft custodian;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Third-Party Custodian',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          key: StakingCustodyKeys.custodian,
          radius: VitCardRadius.large,
          padding: AppSpacing.earnCardPaddingX4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StakingCustodyLargeIconBox(
                    icon: Icons.local_fire_department_rounded,
                    color: AppColors.primarySoft,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(custodian.name, style: AppTextStyles.sectionTitle),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          custodian.type,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        Wrap(
                          spacing: AppSpacing.x2,
                          runSpacing: AppSpacing.x2,
                          children: const [
                            StakingCustodySmallPill(
                              label: 'Regulated',
                              color: AppColors.buy,
                            ),
                            StakingCustodySmallPill(
                              label: 'Insured',
                              color: AppColors.primarySoft,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: AppSpacing.stakingCustodyMetricGridColumns,
                childAspectRatio: AppSpacing.stakingCustodyMetricGridAspect,
                crossAxisSpacing: AppSpacing.x3,
                mainAxisSpacing: AppSpacing.x3,
                children: [
                  StakingCustodyMetricTile(
                    label: 'Founded',
                    value: custodian.founded,
                  ),
                  StakingCustodyMetricTile(
                    label: 'Headquarters',
                    value: custodian.headquarters,
                  ),
                  StakingCustodyMetricTile(
                    label: 'Clients',
                    value: custodian.clients,
                  ),
                  StakingCustodyMetricTile(
                    label: 'AUM Transferred',
                    value: custodian.aum,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              VitCard(
                variant: VitCardVariant.inner,
                borderColor: AppColors.buy20,
                padding: AppSpacing.earnCardPaddingX3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      color: AppColors.buy,
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Insurance Coverage',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x2),
                          Text(
                            custodian.insurance,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                'Licenses & Certifications',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.x2),
              Wrap(
                spacing: AppSpacing.x2,
                runSpacing: AppSpacing.x2,
                children: [
                  for (final license in custodian.licenses)
                    StakingCustodySmallPill(
                      label: license,
                      color: AppColors.text1,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
