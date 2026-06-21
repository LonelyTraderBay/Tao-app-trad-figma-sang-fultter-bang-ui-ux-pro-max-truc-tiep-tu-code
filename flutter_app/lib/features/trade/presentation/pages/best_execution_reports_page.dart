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

part '../widgets/best_execution_overview.dart';
part '../widgets/best_execution_current.dart';
part '../widgets/best_execution_archive_common.dart';

const _bestBackground = AppColors.bg;
const _bestPanel2 = AppColors.surface2;
const _bestBorder = AppColors.borderSolid;
const _bestGreen = AppColors.buy;
const _bestAmber = AppColors.caution;
const _bestPrimary = AppColors.primary;

class BestExecutionReportsPage extends ConsumerStatefulWidget {
  const BestExecutionReportsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc096_best_execution_content');
  static Key tabKey(String id) => Key('sc096_best_execution_tab_$id');
  static Key venueKey(int rank) => Key('sc096_best_execution_venue_$rank');
  static const analysisKey = Key('sc096_best_execution_analysis');
  static const exportKey = Key('sc096_best_execution_export');
  static const publishKey = Key('sc096_best_execution_publish');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BestExecutionReportsPage> createState() =>
      _BestExecutionReportsPageState();
}

class _BestExecutionReportsPageState
    extends ConsumerState<BestExecutionReportsPage> {
  String _tab = 'current';
  String? _notice;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getBestExecutionReports();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollClearance =
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x6);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-096 BestExecutionReportsPage',
      child: Material(
        color: _bestBackground,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: 'Best Execution Reports',
                subtitle: 'RTS 27 / RTS 28 Compliance',
                showBack: true,
                onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
                actions: [
                  VitHeaderActionItem(
                    type: VitHeaderActionType.export,
                    onPressed: () =>
                        setState(() => _notice = 'PDF export queued'),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      key: BestExecutionReportsPage.contentKey,
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
                          const _ComplianceNotice(),
                          _SummaryGrid(summary: snapshot.summary),
                          _Tabs(activeId: _tab, onChanged: _setTab),
                          if (_tab == 'current')
                            _CurrentReport(
                              venues: snapshot.venues,
                              onAnalysis: () => context.go(
                                AppRoutePaths.tradeCopyExecutionVenueAnalysis,
                              ),
                              onExport: () =>
                                  setState(() => _notice = 'PDF export queued'),
                              onPublish: () =>
                                  setState(() => _notice = 'Report submitted'),
                            )
                          else
                            _ArchiveReport(
                              reports: snapshot.archive,
                              onExport: (id) =>
                                  setState(() => _notice = '$id PDF queued'),
                            ),
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

  void _setTab(String tab) => setState(() => _tab = tab);
}
