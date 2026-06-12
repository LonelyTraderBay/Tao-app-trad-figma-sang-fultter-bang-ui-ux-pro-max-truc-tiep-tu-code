import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part '../widgets/p2p_tax_reporting_page_sections.dart';
part '../widgets/p2p_tax_reporting_page_common.dart';

class P2PTaxReportingPage extends ConsumerStatefulWidget {
  const P2PTaxReportingPage({
    super.key,
    this.initialYear,
    this.shellRenderMode,
  });

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

  final int? initialYear;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PTaxReportingPage> createState() =>
      _P2PTaxReportingPageState();
}

class _P2PTaxReportingPageState extends ConsumerState<P2PTaxReportingPage> {
  int _selectedYear = 2025;
  String _jurisdiction = 'US';

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialYear ?? _selectedYear;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(
      p2pTaxReportingProvider((
        selectedYear: _selectedYear,
        selectedJurisdiction: _jurisdiction,
      )),
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
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                    child: VitPageContent(
                      padding: VitContentPadding.none,
                      fullBleed: true,
                      customGap: 0,
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
      ),
    );
  }
}
