import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/p2p_repository.dart';

class P2PTaxReportingPage extends ConsumerStatefulWidget {
  const P2PTaxReportingPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc272_p2p_tax_hero');
  static const yearsKey = Key('sc272_p2p_tax_years');
  static const jurisdictionsKey = Key('sc272_p2p_tax_jurisdictions');
  static const summaryKey = Key('sc272_p2p_tax_summary');
  static const documentsKey = Key('sc272_p2p_tax_documents');
  static const disclaimerKey = Key('sc272_p2p_tax_disclaimer');
  static const detailCtaKey = Key('sc272_p2p_tax_detail_cta');

  static Key yearKey(int year) => Key('sc272_p2p_tax_year_$year');

  static Key jurisdictionKey(String code) =>
      Key('sc272_p2p_tax_jurisdiction_$code');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PTaxReportingPage> createState() =>
      _P2PTaxReportingPageState();
}

class _P2PTaxReportingPageState extends ConsumerState<P2PTaxReportingPage> {
  int _selectedYear = 2025;
  String _jurisdiction = 'US';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(p2pRepositoryProvider)
        .getTaxReporting(
          selectedYear: _selectedYear,
          selectedJurisdiction: _jurisdiction,
        );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-272 P2PTaxReportingPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TaxHero(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      _YearSelector(
                        years: snapshot.years,
                        selectedYear: _selectedYear,
                        onChanged: (year) {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedYear = year);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _JurisdictionSelector(
                        jurisdictions: snapshot.jurisdictions,
                        selectedCode: _jurisdiction,
                        onChanged: (code) {
                          HapticFeedback.selectionClick();
                          setState(() => _jurisdiction = code);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x6),
                      _TaxSummary(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x6),
                      _TaxDocuments(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      _TaxDisclaimer(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      VitCtaButton(
                        key: P2PTaxReportingPage.detailCtaKey,
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          context.go(snapshot.detailRoute);
                        },
                        child: const Text('View Detailed Tax Report'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaxHero extends StatelessWidget {
  const _TaxHero({required this.snapshot});

  final P2PTaxReportingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: P2PTaxReportingPage.heroKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: AppRadii.cardLargeRadius,
        border: Border.all(color: AppColors.accent),
      ),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .20),
              borderRadius: AppRadii.lgRadius,
            ),
            child: const SizedBox(
              width: AppSpacing.inputHeight,
              height: AppSpacing.inputHeight,
              child: Icon(
                Icons.description_outlined,
                color: Colors.white,
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
                    color: Colors.white,
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
                    color: Colors.white.withValues(alpha: .90),
                    fontWeight: AppTextStyles.bold,
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
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.buttonCompact,
            minWidth: 64,
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
          decoration: BoxDecoration(
            borderRadius: AppRadii.inputRadius,
            border: Border.all(
              color: selected ? AppColors.accent : AppColors.borderSolid,
            ),
          ),
          child: Text(
            '$year',
            style: AppTextStyles.caption.copyWith(
              color: selected ? Colors.white : AppColors.text2,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
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
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          constraints: const BoxConstraints(minHeight: AppSpacing.ctaHeight),
          padding: const EdgeInsets.all(AppSpacing.x3),
          decoration: BoxDecoration(
            borderRadius: AppRadii.inputRadius,
            border: Border.all(
              color: selected ? AppColors.accent : AppColors.borderSolid,
            ),
          ),
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
                DecoratedBox(
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: const SizedBox(
                    width: AppSpacing.iconMd,
                    height: AppSpacing.iconMd,
                    child: Center(
                      child: Icon(
                        Icons.circle,
                        color: Colors.white,
                        size: AppSpacing.x2,
                      ),
                    ),
                  ),
                ),
            ],
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
          padding: const EdgeInsets.all(AppSpacing.x4),
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
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Text(
                      document.format,
                      style: AppTextStyles.micro.copyWith(
                        color: Colors.white,
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
