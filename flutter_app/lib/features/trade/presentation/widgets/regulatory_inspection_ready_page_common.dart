part of '../pages/regulatory_inspection_ready_page.dart';

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({required this.document});

  final TradeRegulatoryDocument document;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 56,
      padding: const EdgeInsets.fromLTRB(12, 9, 12, 9),
      radius: VitCardRadius.sm,
      borderColor: _inspectionBorder.withValues(alpha: .76),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _inspectionGreen.withValues(alpha: .13),
              borderRadius: AppRadii.cardRadius,
            ),
            child: const Icon(
              Icons.description_outlined,
              color: _inspectionGreen,
              size: 15,
            ),
          ),
          const SizedBox(width: 12),
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
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  document.countLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: _inspectionGreen.withValues(alpha: .13),
              borderRadius: AppRadii.inputRadius,
            ),
              child: Text(
              document.status,
              style: AppTextStyles.micro.copyWith(
                color: _inspectionGreen,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      borderColor: _inspectionBorder.withValues(alpha: .76),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _inspectionPrimary.withValues(alpha: .13),
                  borderRadius: AppRadii.inputRadius,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: _inspectionPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.portalTitle,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      snapshot.portalDescription,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.normal,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          VitCtaButton(
            key: RegulatoryInspectionReadyPage.portalKey,
            onPressed: () {},
            variant: VitCtaButtonVariant.secondary,
            height: 40,
            leading: const Icon(Icons.open_in_new_rounded, size: 15),
            child: Text(
              snapshot.portalCta,
              style: AppTextStyles.control.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: 1,
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
      leading: const Icon(Icons.download_rounded, size: 18),
      child: Text(
        snapshot.reportCta,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.body.copyWith(
          color: AppColors.onAccent,
          fontWeight: AppTextStyles.bold,
          height: 1,
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
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _inspectionPrimary,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
            height: 1,
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
