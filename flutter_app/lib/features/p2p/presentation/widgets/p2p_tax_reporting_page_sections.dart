part of '../pages/p2p_tax_reporting_page.dart';

class _TaxHero extends StatelessWidget {
  const _TaxHero({required this.snapshot});

  final P2PTaxReportingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PTaxReportingPage.heroKey,
      color: AppColors.accent,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.cardLargeRadius,
        side: BorderSide(color: AppColors.accent),
      ),
      child: Padding(
        padding: AppSpacing.p2pDocumentCardPadding,
        child: Row(
          children: [
            SizedBox.square(
              dimension: AppSpacing.p2pDocumentIconBox,
              child: Material(
                color: AppColors.onAccent.withValues(alpha: .20),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.lgRadius,
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: AppColors.onAccent,
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
                    'Tax Year ${snapshot.selectedYear}',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.onAccent,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    '${snapshot.selectedJurisdiction.name} · ${snapshot.selectedJurisdiction.form}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onAccent.withValues(alpha: .90),
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YearSelector extends StatelessWidget {
  const _YearSelector({
    required this.years,
    required this.selectedYear,
    required this.onChanged,
  });

  final List<int> years;
  final int selectedYear;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PTaxReportingPage.yearsKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Tax Year',
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final year in years) ...[
                _YearChip(
                  year: year,
                  selected: selectedYear == year,
                  onTap: () => onChanged(year),
                ),
                const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _YearChip extends StatelessWidget {
  const _YearChip({
    required this.year,
    required this.selected,
    required this.onTap,
  });

  final int year;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PTaxReportingPage.yearKey(year),
      color: selected ? AppColors.accent : AppColors.bg,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.inputRadius,
        side: BorderSide(
          color: selected ? AppColors.accent : AppColors.borderSolid,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const RoundedRectangleBorder(
          borderRadius: AppRadii.inputRadius,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.buttonCompact,
            minWidth: AppSpacing.p2pDocumentChipMinWidth,
          ),
          child: Padding(
            padding: AppSpacing.p2pDocumentChipPadding,
            child: Center(
              child: Text(
                '$year',
                style: AppTextStyles.caption.copyWith(
                  color: selected ? AppColors.onAccent : AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _JurisdictionSelector extends StatelessWidget {
  const _JurisdictionSelector({
    required this.jurisdictions,
    required this.selectedCode,
    required this.onChanged,
  });

  final List<P2PTaxJurisdictionDraft> jurisdictions;
  final String selectedCode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PTaxReportingPage.jurisdictionsKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jurisdiction',
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        for (var index = 0; index < jurisdictions.length; index++) ...[
          _JurisdictionTile(
            jurisdiction: jurisdictions[index],
            selected: selectedCode == jurisdictions[index].code,
            onTap: () => onChanged(jurisdictions[index].code),
          ),
          if (index != jurisdictions.length - 1)
            const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _JurisdictionTile extends StatelessWidget {
  const _JurisdictionTile({
    required this.jurisdiction,
    required this.selected,
    required this.onTap,
  });

  final P2PTaxJurisdictionDraft jurisdiction;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PTaxReportingPage.jurisdictionKey(jurisdiction.code),
      color: selected ? AppColors.accent12 : AppColors.bg,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.inputRadius,
        side: BorderSide(
          color: selected ? AppColors.accent : AppColors.borderSolid,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const RoundedRectangleBorder(
          borderRadius: AppRadii.inputRadius,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSpacing.ctaHeight),
          child: Padding(
            padding: AppSpacing.p2pDocumentCardPadding,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jurisdiction.name,
                        style: AppTextStyles.caption.copyWith(
                          color: selected ? AppColors.accent : AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        jurisdiction.form,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                if (selected)
                  const SizedBox.square(
                    dimension: AppSpacing.iconMd,
                    child: Material(
                      color: AppColors.accent,
                      shape: CircleBorder(),
                      child: Center(
                        child: Icon(
                          Icons.circle,
                          color: AppColors.onAccent,
                          size: AppSpacing.x2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TaxSummary extends StatelessWidget {
  const _TaxSummary({required this.snapshot});

  final P2PTaxReportingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PTaxReportingPage.summaryKey,
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.calendar_today_outlined,
                label: 'Transactions',
                value: '${snapshot.summary.totalTransactions}',
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _MetricCard(
                icon: Icons.attach_money_rounded,
                label: 'Total Volume',
                value: snapshot.summary.totalVolumeLabel,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.trending_up_rounded,
                label: 'Capital Gains',
                value: snapshot.summary.capitalGainsLabel,
                tone: AppColors.buy,
                toneBg: AppColors.buy10,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _MetricCard(
                icon: Icons.trending_down_rounded,
                label: 'Capital Losses',
                value: snapshot.summary.capitalLossesLabel,
                tone: AppColors.sell,
                toneBg: AppColors.sell10,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          radius: VitCardRadius.lg,
          variant: VitCardVariant.inner,
          borderColor: AppColors.accent20,
          padding: AppSpacing.p2pDocumentCardPadding,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Net Capital Gains',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.accent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      snapshot.summary.netGainsLabel,
                      style: AppTextStyles.pageTitle.copyWith(
                        color: AppColors.accent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.attach_money_rounded,
                color: AppColors.accent,
                size: AppSpacing.iconLg,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
