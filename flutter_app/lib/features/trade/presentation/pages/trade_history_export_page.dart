import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/trade_history_export_summary_sections.dart';
part '../widgets/trade_history_export_selectors_includes.dart';
part '../widgets/trade_history_export_footer.dart';

const _tradePrimary = AppColors.primary;
const _tradePrimaryDark = AppColors.primaryDark;
const _cardBackground = AppColors.surface2;
const _chipBackground = AppColors.surface2;
const _inactiveFormatBackground = AppColors.surface3;

class TradeHistoryExportPage extends ConsumerStatefulWidget {
  const TradeHistoryExportPage({super.key, this.shellRenderMode});

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
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-054 TradeHistoryExportPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
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
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        14,
                        20,
                        bottomChrome + 126,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _SummaryCard(stats: snapshot.stats),
                          const SizedBox(height: 24),
                          _Section(
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
                          const SizedBox(height: 26),
                          _Section(
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
                          const SizedBox(height: 26),
                          _Section(
                            title: 'Bao gồm dữ liệu',
                            child: _IncludeList(
                              includes: _includes,
                              onToggle: _toggleInclude,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const _TaxNote(),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: bottomChrome,
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
