part of '../pages/regulatory_inspection_ready_page.dart';

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({required this.document});

  final TradeRegulatoryDocument document;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      radius: VitCardRadius.standard,
      borderColor: _inspectionBorder.withValues(alpha: .76),
      child: Row(
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          const VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.standard,
            width: AppSpacing.buttonCompact,
            height: AppSpacing.buttonCompact,
            borderColor: _inspectionGreen,
            alignment: Alignment.center,
            child: Icon(
              Icons.description_outlined,
              color: _inspectionGreen,
              size: AppSpacing.inputPrefixIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
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
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  document.countLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
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
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _inspectionBorder.withValues(alpha: .76),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // card-tile: allow-start — fixed surface, not horizontal strip tile
              const VitCard(
                variant: VitCardVariant.inner,
                radius: VitCardRadius.standard,
                width: AppSpacing.buttonCompact,
                height: AppSpacing.buttonCompact,
                borderColor: _inspectionPrimary,
                alignment: Alignment.center,
                child: Icon(
                  Icons.shield_outlined,
                  color: _inspectionPrimary,
                  size: AppSpacing.inputPrefixIcon,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.portalTitle,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      snapshot.portalDescription,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCtaButton(
            key: RegulatoryInspectionReadyPage.portalKey,
            onPressed: () =>
                _showComingSoon(context, 'Cổng thanh tra sẽ sớm ra mắt'),
            variant: VitCtaButtonVariant.secondary,
            density: VitDensity.compact,
            leading: const Icon(
              Icons.open_in_new_rounded,
              size: AppSpacing.inputPrefixIcon,
            ),
            child: Text(
              snapshot.portalCta,
              style: AppTextStyles.control.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
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
      onPressed: () => _showComingSoon(context, 'Tải báo cáo sẽ sớm ra mắt'),
      variant: VitCtaButtonVariant.success,
      density: VitDensity.compact,
      leading: const Icon(
        Icons.download_rounded,
        size: AppSpacing.inputPrefixIcon,
      ),
      child: Text(
        snapshot.reportCta,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.body.copyWith(
          color: AppColors.onAccent,
          fontWeight: AppTextStyles.bold,
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
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
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

void _showComingSoon(BuildContext context, String message) {
  HapticFeedback.selectionClick();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
