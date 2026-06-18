part of '../pages/regulatory_inspection_ready_page.dart';

class _ComplianceScoreCard extends StatelessWidget {
  const _ComplianceScoreCard({required this.snapshot});

  final TradeRegulatoryInspectionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      constraints: const BoxConstraints(
        minHeight: AppSpacing.regulatoryInspectionScoreMinHeight,
      ),
      padding: AppSpacing.regulatoryInspectionCardPadding,
      borderColor: _inspectionBorder.withValues(alpha: .76),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VitCard(
                variant: VitCardVariant.inner,
                radius: VitCardRadius.md,
                width: AppSpacing.regulatoryInspectionScoreIconBox,
                height: AppSpacing.regulatoryInspectionScoreIconBox,
                borderColor: _inspectionGreen,
                alignment: Alignment.center,
                child: Icon(
                  Icons.military_tech_outlined,
                  color: _inspectionGreen,
                  size: AppSpacing.regulatoryInspectionScoreIcon,
                ),
              ),
              const SizedBox(width: AppSpacing.regulatoryInspectionSmallGap),
              Expanded(
                child: Padding(
                  padding: AppSpacing.regulatoryInspectionScoreTextPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.scoreLabel,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          fontWeight: AppTextStyles.normal,
                          height:
                              AppSpacing.regulatoryInspectionLineHeightCompact,
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.regulatoryInspectionMediumGap,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${snapshot.complianceScore}%',
                            style: AppTextStyles.amountLg.copyWith(
                              color: _inspectionGreen,
                              fontFeatures: AppTextStyles.tabularFigures,
                              height:
                                  AppSpacing.regulatoryInspectionLineHeightTight,
                            ),
                          ),
                          const SizedBox(
                            width: AppSpacing.regulatoryInspectionInlineGap,
                          ),
                          Text(
                            '/ 100%',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                              height:
                                  AppSpacing.regulatoryInspectionLineHeightTight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.regulatoryInspectionLargeGap),
          LayoutBuilder(
            builder: (context, constraints) {
              return ClipRRect(
                borderRadius: AppRadii.xlRadius,
                child: SizedBox(
                  height: AppSpacing.regulatoryInspectionProgressHeight,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ColoredBox(color: _inspectionPanel2),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width:
                              constraints.maxWidth *
                              snapshot.complianceScore /
                              100,
                          height: AppSpacing.regulatoryInspectionProgressHeight,
                          child: const ColoredBox(color: _inspectionGreen),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.regulatoryInspectionLooseGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: AppSpacing.regulatoryInspectionReadyIconPadding,
                child: Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.text1,
                  size: AppSpacing.regulatoryInspectionBodyIcon,
                ),
              ),
              const SizedBox(width: AppSpacing.regulatoryInspectionInlineGap),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      height: AppSpacing.regulatoryInspectionLineHeightNote,
                    ),
                    children: [
                      TextSpan(text: '${snapshot.readyTitle} '),
                      TextSpan(text: snapshot.readyDescription),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  const _QuickStats({required this.stats});

  final List<TradeRegulatoryInspectionStat> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final stat in stats) ...[
          Expanded(child: _QuickStatCard(stat: stat)),
          if (stat != stats.last)
            const SizedBox(width: AppSpacing.regulatoryInspectionMetricGap),
        ],
      ],
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  const _QuickStatCard({required this.stat});

  final TradeRegulatoryInspectionStat stat;

  @override
  Widget build(BuildContext context) {
    final style = _styleForStat(stat.icon);
    return VitCard(
      height: AppSpacing.regulatoryInspectionQuickStatHeight,
      padding: AppSpacing.regulatoryInspectionQuickStatPadding,
      radius: VitCardRadius.sm,
      borderColor: _inspectionBorder.withValues(alpha: .76),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            style.icon,
            color: style.color,
            size: AppSpacing.regulatoryInspectionQuickStatIcon,
          ),
          const SizedBox(height: AppSpacing.regulatoryInspectionMediumGap),
          Text(
            stat.value,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              height: AppSpacing.regulatoryInspectionLineHeightTight,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: AppSpacing.regulatoryInspectionLineHeightTight,
            ),
          ),
        ],
      ),
    );
  }
}

class _FrameworkCard extends StatelessWidget {
  const _FrameworkCard({required this.framework});

  final TradeRegulatoryFramework framework;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.regulatoryInspectionCardPadding,
      borderColor: _inspectionBorder.withValues(alpha: .76),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  framework.name,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    height: AppSpacing.regulatoryInspectionLineHeightTight,
                  ),
                ),
              ),
              Text(
                '${framework.compliance}%',
                style: AppTextStyles.baseMedium.copyWith(
                  color: _inspectionGreen,
                  fontWeight: AppTextStyles.bold,
                  height: AppSpacing.regulatoryInspectionLineHeightTight,
                ),
              ),
              const SizedBox(width: AppSpacing.regulatoryInspectionMetricGap),
              const Icon(
                Icons.check_circle_outline_rounded,
                color: _inspectionGreen,
                size: AppSpacing.regulatoryInspectionStandardIcon,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.regulatoryInspectionMediumGap),
          for (final requirement in framework.requirements) ...[
            _RequirementRow(requirement),
            if (requirement != framework.requirements.last)
              const SizedBox(
                height: AppSpacing.regulatoryInspectionProgressHeight,
              ),
          ],
        ],
      ),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  const _RequirementRow(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline_rounded,
          color: _inspectionGreen,
          size: AppSpacing.regulatoryInspectionRequirementIcon,
        ),
        const SizedBox(width: AppSpacing.regulatoryInspectionInlineGap),
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.regulatoryInspectionLineHeightTight,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              const Icon(
                Icons.check_rounded,
                color: AppColors.text2,
                size: AppSpacing.regulatoryInspectionTinyIcon,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
