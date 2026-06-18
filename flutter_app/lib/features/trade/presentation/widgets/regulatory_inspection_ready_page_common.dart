part of '../pages/regulatory_inspection_ready_page.dart';

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({required this.document});

  final TradeRegulatoryDocument document;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: AppSpacing.regulatoryInspectionDocumentHeight,
      padding: AppSpacing.regulatoryInspectionDocumentPadding,
      radius: VitCardRadius.sm,
      borderColor: _inspectionBorder.withValues(alpha: .76),
      child: Row(
        children: [
          const VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.md,
            width: AppSpacing.regulatoryInspectionDocumentIconBox,
            height: AppSpacing.regulatoryInspectionDocumentIconBox,
            borderColor: _inspectionGreen,
            alignment: Alignment.center,
            child: Icon(
              Icons.description_outlined,
              color: _inspectionGreen,
              size: AppSpacing.regulatoryInspectionBodyIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.regulatoryInspectionSmallGap),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.regulatoryInspectionLineHeightTight,
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.regulatoryInspectionCompactGap,
                ),
                Text(
                  document.countLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: AppSpacing.regulatoryInspectionLineHeightTight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.regulatoryInspectionMetricGap),
          VitAccentPill(label: document.status, accentColor: _inspectionGreen),
        ],
      ),
    );
  }
}

class _InspectorPortalCard extends StatelessWidget {
  const _InspectorPortalCard({required this.snapshot});

  final TradeRegulatoryInspectionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.regulatoryInspectionPortalPadding,
      borderColor: _inspectionBorder.withValues(alpha: .76),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VitCard(
                variant: VitCardVariant.inner,
                radius: VitCardRadius.sm,
                width: AppSpacing.regulatoryInspectionPortalIconBox,
                height: AppSpacing.regulatoryInspectionPortalIconBox,
                borderColor: _inspectionPrimary,
                alignment: Alignment.center,
                child: Icon(
                  Icons.shield_outlined,
                  color: _inspectionPrimary,
                  size: AppSpacing.regulatoryInspectionPortalIcon,
                ),
              ),
              const SizedBox(width: AppSpacing.regulatoryInspectionSmallGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.portalTitle,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        height:
                            AppSpacing.regulatoryInspectionLineHeightCompact,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.regulatoryInspectionCompactGap,
                    ),
                    Text(
                      snapshot.portalDescription,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.normal,
                        height:
                            AppSpacing.regulatoryInspectionLineHeightReadable,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.regulatoryInspectionPortalGap),
          VitCtaButton(
            key: RegulatoryInspectionReadyPage.portalKey,
            onPressed: () {},
            variant: VitCtaButtonVariant.secondary,
            height: AppSpacing.regulatoryInspectionActionHeight,
            leading: const Icon(
              Icons.open_in_new_rounded,
              size: AppSpacing.regulatoryInspectionBodyIcon,
            ),
            child: Text(
              snapshot.portalCta,
              style: AppTextStyles.control.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: AppSpacing.regulatoryInspectionLineHeightTight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportButton extends StatelessWidget {
  const _ReportButton({required this.snapshot});

  final TradeRegulatoryInspectionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: RegulatoryInspectionReadyPage.reportKey,
      onPressed: () {},
      variant: VitCtaButtonVariant.success,
      height: AppSpacing.inputHeight,
      leading: const Icon(
        Icons.download_rounded,
        size: AppSpacing.regulatoryInspectionStandardIcon,
      ),
      child: Text(
        snapshot.reportCta,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.body.copyWith(
          color: AppColors.onAccent,
          fontWeight: AppTextStyles.bold,
          height: AppSpacing.regulatoryInspectionLineHeightTight,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitSectionHeader(
            title: label,
            variant: VitSectionHeaderVariant.accentBar,
            accentColor: _inspectionPrimary,
          ),
        ),
      ],
    );
  }
}

_StatStyle _styleForStat(TradeRegulatoryInspectionStatIcon icon) {
  return switch (icon) {
    TradeRegulatoryInspectionStatIcon.documents => const _StatStyle(
      color: _inspectionPrimary,
      icon: Icons.description_outlined,
    ),
    TradeRegulatoryInspectionStatIcon.clients => const _StatStyle(
      color: _inspectionGreen,
      icon: Icons.group_outlined,
    ),
    TradeRegulatoryInspectionStatIcon.auditLogs => const _StatStyle(
      color: _inspectionAmber,
      icon: Icons.bar_chart_rounded,
    ),
    TradeRegulatoryInspectionStatIcon.retention => const _StatStyle(
      color: _inspectionPrimary,
      icon: Icons.schedule_rounded,
    ),
  };
}

final class _StatStyle {
  const _StatStyle({required this.color, required this.icon});

  final Color color;
  final IconData icon;
}
