part of '../pages/p2p_tax_reporting_page.dart';

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    this.tone = AppColors.text1,
    this.toneBg,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color tone;
  final Color? toneBg;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      variant: toneBg == null ? VitCardVariant.standard : VitCardVariant.inner,
      borderColor: toneBg == null ? null : tone.withValues(alpha: .18),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: tone == AppColors.text1 ? AppColors.text3 : tone,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: tone == AppColors.text1 ? AppColors.text3 : tone,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: tone,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaxDocuments extends StatelessWidget {
  const _TaxDocuments({required this.snapshot});

  final P2PTaxReportingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PTaxReportingPage.documentsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Download Tax Documents',
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        for (var index = 0; index < snapshot.documents.length; index++) ...[
          _TaxDocumentRow(document: snapshot.documents[index]),
          if (index != snapshot.documents.length - 1)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _TaxDocumentRow extends StatelessWidget {
  const _TaxDocumentRow({required this.document});

  final P2PTaxDocumentDraft document;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(document.toneKey);
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: color.withValues(alpha: .14),
              borderRadius: AppRadii.lgRadius,
            ),
            child: SizedBox(
              width: AppSpacing.inputHeight,
              height: AppSpacing.inputHeight,
              child: Icon(
                Icons.description_outlined,
                color: color,
                size: AppSpacing.iconMd,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  document.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Material(
            color: color,
            borderRadius: AppRadii.inputRadius,
            child: InkWell(
              onTap: () => HapticFeedback.selectionClick(),
              borderRadius: AppRadii.inputRadius,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x3,
                  vertical: AppSpacing.x2,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.download_rounded,
                      color: AppColors.onAccent,
                      size: 14,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Text(
                      document.format,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.onAccent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaxDisclaimer extends StatelessWidget {
  const _TaxDisclaimer({required this.snapshot});

  final P2PTaxReportingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: P2PTaxReportingPage.disclaimerKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.sell10,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppColors.sell20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.sell,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  height: 1.55,
                ),
                children: [
                  TextSpan(
                    text: 'Tax Disclaimer: ',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.sell,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  TextSpan(text: snapshot.disclaimer),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _toneColor(String toneKey) {
  return switch (toneKey) {
    'success' => AppColors.buy,
    'warning' => AppColors.warn,
    'primary' => AppColors.primary,
    _ => AppColors.accent,
  };
}
