import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

import '../widgets/trade_body_review_widgets.dart';

part '../widgets/trade_history_export_summary_sections.dart';
part '../widgets/trade_history_export_selectors_includes.dart';
part '../widgets/trade_history_export_footer.dart';

const _tradePrimary = AppColors.primary;
const double _exportFramedFooterClearance =
    AppSpacing.buttonStandard + AppSpacing.x5;
const double _exportNativeFooterClearance =
    AppSpacing.buttonStandard + AppSpacing.x3;
const double _exportFooterHeight = AppSpacing.buttonStandard + AppSpacing.x4;
const double _exportFormatExtent = AppSpacing.buttonStandard + AppSpacing.x7;

class TradeHistoryExportPage extends ConsumerStatefulWidget {
  const TradeHistoryExportPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc054_export_content');
  static const exportKey = Key('sc054_export');
  static const newExportKey = Key('sc054_new_export');
  static const downloadKey = Key('sc054_download');

  static Key formatKey(String id) => Key('sc054_format_$id');
  static Key periodKey(String id) => Key('sc054_period_$id');
  static Key includeKey(String id) => Key('sc054_include_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TradeHistoryExportPage> createState() =>
      _TradeHistoryExportPageState();
}

class _TradeHistoryExportPageState
    extends ConsumerState<TradeHistoryExportPage> {
  late String _format;
  late String _period;
  late List<TradeExportInclude> _includes;
  bool _isExporting = false;
  TradeExportResult? _result;

  @override
  void initState() {
    super.initState();
    final snapshot = ref
        .read(tradeReadModelControllerProvider)
        .getTradeExport();
    _format = snapshot.formats.first.id;
    _period = '30d';
    _includes = snapshot.includes.toList(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getTradeExport();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final footerSafePadding =
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? _exportFramedFooterClearance
            : _exportNativeFooterClearance);
    final scrollEndClearance =
        tradeScrollBottomInset(context, shellRenderMode: mode) +
        _exportFooterHeight +
        footerSafePadding;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-054 TradeHistoryExportPage',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitHeader(
            title: 'Xuất lịch sử giao dịch',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.trade),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: VitInsetScrollView(
                    key: TradeHistoryExportPage.contentKey,
                    bottomInset: scrollEndClearance,
                    child: VitPageContent(
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: [
                        VitTradeSection(
                          title: 'Tổng quan',
                          child: _SummaryCard(stats: snapshot.stats),
                        ),
                        VitTradeSection(
                          title: 'Định dạng file',
                          child: _FormatSelector(
                            formats: snapshot.formats,
                            activeFormat: _format,
                            onChanged: (format) {
                              setState(() {
                                _format = format;
                                _result = null;
                              });
                            },
                          ),
                        ),
                        VitTradeSection(
                          title: 'Khoảng thời gian',
                          child: _PeriodSelector(
                            periods: snapshot.periods,
                            activePeriod: _period,
                            onChanged: (period) {
                              setState(() {
                                _period = period;
                                _result = null;
                              });
                            },
                          ),
                        ),
                        VitTradeSection(
                          title: 'Bao gồm dữ liệu',
                          child: _IncludeList(
                            includes: _includes,
                            onToggle: _toggleInclude,
                          ),
                        ),
                        VitTradeSection(title: 'Thuế', child: const _TaxNote()),
                        VitTradeSection(
                          title: 'Đánh giá xuất',
                          child: const VitCard(
                            variant: VitCardVariant.inner,
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: AppSpacing.x3,
                              vertical: AppSpacing.x2,
                            ),
                            child: VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Export review state',
                              message:
                                  'Format, period, included records, tax note, generated result and download next step are reviewed before export.',
                              contractId: 'trade-history-export-review',
                              density: VitDensity.compact,
                            ),
                          ),
                        ),
                        const TradeBodyReviewSection(
                          title: 'Export body review',
                          message: 'Trade export body reviewed',
                          detail:
                              'Format, period, includes, tax note, export, download, and result states stay visible.',
                          primary:
                              'Export selectors remain above generated result state.',
                          secondary:
                              'Tax note stays visible before export confirmation.',
                          tertiary:
                              'Download/new-export actions remain in the sticky footer.',
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: footerSafePadding,
                  child: _ExportFooter(
                    format: _format,
                    period: _period,
                    isExporting: _isExporting,
                    result: _result,
                    onExport: _handleExport,
                    onNewExport: () => setState(() => _result = null),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleInclude(String id) {
    setState(() {
      _result = null;
      _includes = [
        for (final item in _includes)
          item.id == id ? item.copyWith(checked: !item.checked) : item,
      ];
    });
  }

  Future<void> _handleExport() async {
    if (_isExporting) return;
    setState(() {
      _isExporting = true;
      _result = null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final request = TradeExportRequest(
      format: _format,
      period: _period,
      includeIds: [
        for (final item in _includes)
          if (item.checked) item.id,
      ],
    );
    final result = ref
        .read(tradeReadModelControllerProvider)
        .createTradeExport(request);
    if (!mounted) return;
    setState(() {
      _isExporting = false;
      _result = result;
    });
  }
}
