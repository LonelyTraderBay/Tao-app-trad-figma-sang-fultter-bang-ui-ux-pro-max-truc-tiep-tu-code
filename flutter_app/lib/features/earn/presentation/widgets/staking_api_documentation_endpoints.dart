import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_api_documentation_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class StakingApiDocumentationEndpointsTab extends StatelessWidget {
  const StakingApiDocumentationEndpointsTab({
    super.key,
    required this.snapshot,
    required this.selectedIndex,
    required this.responseCopied,
    required this.onSelect,
    required this.onCopyResponse,
  });

  final StakingApiDocumentationSnapshot snapshot;
  final int selectedIndex;
  final bool responseCopied;
  final ValueChanged<int> onSelect;
  final VoidCallback onCopyResponse;

  @override
  Widget build(BuildContext context) {
    final selected = snapshot.endpoints[selectedIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          key: StakingApiDocumentationKeys.endpoints,
          label: 'API Endpoints',
          accentColor: AppColors.primarySoft,
          children: [
            for (var i = 0; i < snapshot.endpoints.length; i++)
              _EndpointSummaryCard(
                endpoint: snapshot.endpoints[i],
                selected: i == selectedIndex,
                onTap: () => onSelect(i),
              ),
          ],
        ),
        VitPageSection(
          key: StakingApiDocumentationKeys.detail,
          label: 'Endpoint Detail',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.large,
              padding: AppSpacing.earnCardPaddingX4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      StakingApiDocumentationMethodBadge(
                        method: selected.method,
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Expanded(
                        child: Text(
                          selected.path,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
                  Text(
                    selected.description,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: AppSpacing.stakingApiEndpointBodyLineHeight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
                  Text('Parameters', style: AppTextStyles.caption),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  for (final param in selected.params) ...[
                    _ParameterCard(param: param),
                    if (param != selected.params.last)
                      const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  ],
                  const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Response Example',
                          style: AppTextStyles.caption,
                        ),
                      ),
                      StakingApiDocumentationCopyButton(
                        key: StakingApiDocumentationKeys.copyResponse,
                        copied: responseCopied,
                        onTap: onCopyResponse,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  StakingApiDocumentationCodeBlock(text: selected.responseJson),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EndpointSummaryCard extends StatelessWidget {
  const _EndpointSummaryCard({
    required this.endpoint,
    required this.selected,
    required this.onTap,
  });

  final StakingApiEndpointDraft endpoint;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingApiDocumentationKeys.endpoint(endpoint.method, endpoint.path),
      onTap: onTap,
      borderColor: selected ? AppColors.primary : null,
      padding: AppSpacing.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StakingApiDocumentationMethodBadge(method: endpoint.method),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  endpoint.path,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            endpoint.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: AppSpacing.stakingApiEndpointDescriptionLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _ParameterCard extends StatelessWidget {
  const _ParameterCard({required this.param});

  final StakingApiParameterDraft param;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: AppSpacing.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x1,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                param.name,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                param.type,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              if (param.required)
                const StakingApiDocumentationStatusPill(
                  label: 'required',
                  color: AppColors.sell,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            param.description,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
