import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_api_documentation_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class StakingApiDocumentationExamplesTab extends StatelessWidget {
  const StakingApiDocumentationExamplesTab({
    super.key,
    required this.snapshot,
    required this.language,
    required this.copied,
    required this.onLanguageChanged,
    required this.onCopy,
  });

  final StakingApiDocumentationSnapshot snapshot;
  final String language;
  final bool copied;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    final selected = snapshot.codeExamples.firstWhere(
      (item) => item.language == language,
      orElse: () => snapshot.codeExamples.first,
    );
    return Column(
      key: StakingApiDocumentationKeys.examples,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            for (final example in snapshot.codeExamples)
              _LanguageButton(
                example: example,
                selected: example.language == selected.language,
                onTap: () => onLanguageChanged(example.language),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        VitPageSection(
          label: 'Code Examples',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.x3),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Create Stake Position',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        StakingApiDocumentationCopyButton(
                          key: StakingApiDocumentationKeys.copyExample,
                          copied: copied,
                          onTap: () => onCopy(selected.source),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: AppColors.borderSolid, height: 1),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.x3),
                    child: StakingApiDocumentationCodeBlock(
                      text: selected.source,
                      tall: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          key: StakingApiDocumentationKeys.sandbox,
          label: 'Try in Sandbox',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: AppSpacing.buttonHero,
                        height: AppSpacing.buttonHero,
                        decoration: BoxDecoration(
                          color: AppColors.warn.withValues(alpha: 0.12),
                          borderRadius: AppRadii.lgRadius,
                        ),
                        child: const Icon(
                          Icons.bolt_rounded,
                          color: AppColors.warn,
                          size: AppSpacing.iconMd,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sandbox Environment',
                              style: AppTextStyles.baseMedium,
                            ),
                            const SizedBox(height: AppSpacing.x2),
                            Text(
                              'Test your integration with fake data before going live. No real funds involved.',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  VitCard(
                    variant: VitCardVariant.inner,
                    padding: const EdgeInsets.all(AppSpacing.x3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sandbox Base URL',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                snapshot.sandboxBaseUrl,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.micro.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.content_copy_rounded,
                              color: AppColors.text3,
                              size: AppSpacing.iconSm,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  SizedBox(
                    height: AppSpacing.ctaHeight,
                    child: FilledButton(
                      onPressed: () {},
                      child: const Text('Get Sandbox API Key'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({
    required this.example,
    required this.selected,
    required this.onTap,
  });

  final StakingApiCodeExampleDraft example;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.surface2,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        key: StakingApiDocumentationKeys.language(example.language),
        borderRadius: AppRadii.inputRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          child: Text(
            example.label,
            style: AppTextStyles.caption.copyWith(
              color: selected ? AppColors.onAccent : AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}
