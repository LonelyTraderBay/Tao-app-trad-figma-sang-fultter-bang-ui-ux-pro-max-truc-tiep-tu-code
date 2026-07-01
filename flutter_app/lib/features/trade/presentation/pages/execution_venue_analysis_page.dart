import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
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
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

part '../widgets/execution_venue_summary.dart';
part '../widgets/execution_venue_comparison.dart';
part '../widgets/execution_venue_speed_trends.dart';
part '../widgets/execution_venue_common.dart';

const _venueBackground = AppColors.bg;
const _venuePanel2 = AppColors.surface2;
const _venueBorder = AppColors.borderSolid;
const _venueGreen = AppColors.buy;
const _venueAmber = AppColors.caution;
const _venuePrimary = AppColors.primary;

class ExecutionVenueAnalysisPage extends ConsumerStatefulWidget {
  const ExecutionVenueAnalysisPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc097_execution_venue_content');
  static Key tabKey(String id) => Key('sc097_execution_venue_tab_$id');
  static Key sortKey(String id) => Key('sc097_execution_venue_sort_$id');
  static Key venueKey(String venue) => Key('sc097_execution_venue_$venue');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ExecutionVenueAnalysisPage> createState() =>
      _ExecutionVenueAnalysisPageState();
}

class _ExecutionVenueAnalysisPageState
    extends ConsumerState<ExecutionVenueAnalysisPage> {
  String _tab = 'comparison';
  String _sort = 'volume';
  String? _notice;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getExecutionVenueAnalysis();
    final venues = _sorted(snapshot.venues);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollClearance = tradeScrollBottomInset(
        context,
        shellRenderMode: mode,
      );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-097 ExecutionVenueAnalysisPage',
      child: Material(
        color: _venueBackground,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: 'Execution Venue Analysis',
                subtitle: 'Detailed Comparison',
                showBack: true,
                onBack: () =>
                    context.go(AppRoutePaths.tradeCopyBestExecutionReports),
                actions: [
                  VitHeaderActionItem(
                    type: VitHeaderActionType.export,
                    onPressed: () =>
                        setState(() => _notice = 'Analysis export queued'),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      key: ExecutionVenueAnalysisPage.contentKey,
                      padding: EdgeInsetsDirectional.fromSTEB(
                        AppSpacing.contentPad,
                        AppSpacing.tradeBotCardGap,
                        AppSpacing.contentPad,
                        scrollClearance,
                      ),
                      child: VitPageContent(
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        density: VitDensity.compact,
                        children: [
                          _SummaryGrid(summary: snapshot.summary),
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            density: VitDensity.compact,
                            title: 'Execution venue review',
                            message:
                                'Compare fill quality, total cost, speed, venue concentration, fee impact, and next-step export before changing routing decisions.',
                            contractId: 'SC-097 venue analysis review',
                          ),
                          _SortSelector(
                            activeId: _sort,
                            onChanged: (id) => setState(() => _sort = id),
                          ),
                          _Tabs(
                            activeId: _tab,
                            onChanged: (id) => setState(() => _tab = id),
                          ),
                          if (_tab == 'comparison')
                            _ComparisonTab(venues: venues)
                          else if (_tab == 'costs')
                            _CostsTab(venues: venues)
                          else if (_tab == 'speed')
                            _SpeedTab(venues: venues)
                          else
                            _TrendsTab(trends: snapshot.costTrends),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_notice != null)
              _NoticePanel(
                text: _notice!,
                onClose: () => setState(() => _notice = null),
              ),
          ],
        ),
      ),
    );
  }

  List<TradeExecutionVenueAnalysisMetric> _sorted(
    List<TradeExecutionVenueAnalysisMetric> venues,
  ) {
    final sorted = [...venues];
    switch (_sort) {
      case 'cost':
        sorted.sort((a, b) => a.totalCost.compareTo(b.totalCost));
      case 'speed':
        sorted.sort((a, b) => a.avgFillTime.compareTo(b.avgFillTime));
      case 'fill-rate':
        sorted.sort((a, b) => b.fillRate.compareTo(a.fillRate));
      default:
        sorted.sort((a, b) => b.volume.compareTo(a.volume));
    }
    return sorted;
  }
}
