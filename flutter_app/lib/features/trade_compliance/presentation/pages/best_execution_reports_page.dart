import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

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
        .watch(tradeRegulatoryRepositoryProvider)
        .getBestExecutionReports();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    return Material(
      color: _bestBackground,
      child: Stack(
        children: [
          VitTradeHubScaffold(
            title: 'Best Execution Reports',
            subtitle: 'RTS 27 / RTS 28 Compliance',
            semanticLabel: 'SC-096 BestExecutionReportsPage',
            contentKey: BestExecutionReportsPage.contentKey,
            shellRenderMode: widget.shellRenderMode,
            onBack: () => goBackOrFallback(
              context,
              fallbackPath: AppRoutePaths.tradeCopyTrading,
              mode: BackNavigationMode.historyThenFallback,
            ),
            headerActions: [
              VitHeaderActionItem(
                type: VitHeaderActionType.export,
                onPressed: () => setState(() => _notice = 'PDF export queued'),
              ),
            ],
            children: [
              VitTradeSection(
                title: 'Notice',
                child: const _ComplianceNotice(),
              ),
              VitTradeComplianceSection(
                title: 'Execution review',
                statusPill: VitStatusPill(
                  label: 'Updated ${snapshot.lastUpdatedLabel}',
                  status: VitStatusPillStatus.info,
                  size: VitStatusPillSize.sm,
                ),
                items: [
                  VitTradeComplianceItem(
                    label: 'Venues',
                    value: '${snapshot.venues.length} tracked',
                  ),
                  VitTradeComplianceItem(
                    label: 'Archive',
                    value: '${snapshot.archive.length} reports',
                  ),
                ],
              ),
              VitTradeSection(
                title: 'Reports',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SummaryGrid(summary: snapshot.summary),
                    _Tabs(activeId: _tab, onChanged: _setTab),
                    if (_tab == 'current')
                      _CurrentReport(
                        venues: snapshot.venues,
                        onAnalysis: () => context.push(
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
            ],
          ),
          if (_notice != null)
            Positioned(
              left: AppSpacing.contentPad,
              right: AppSpacing.contentPad,
              top: mode.usesVisualQaFrame
                  ? AppSpacing.buttonHero
                  : AppSpacing.x5,
              child: VitBanner(
                variant: VitBannerVariant.success,
                icon: Icons.check_circle_outline,
                message: _notice!,
                onDismiss: () => setState(() => _notice = null),
              ),
            ),
        ],
      ),
    );
  }

  void _setTab(String tab) => setState(() => _tab = tab);
}
