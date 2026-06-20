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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/copy_performance_summary_tabs.dart';
part '../widgets/copy_performance_details.dart';
part '../widgets/copy_performance_common.dart';

const _performancePrimary = AppColors.primary;
const _performancePurple = AppColors.accent;
const _performanceGreen = AppColors.buy;
const _performanceRed = AppColors.sell;
const _performanceSpace = AppSpacing.x2;
const _performanceCardSpace = AppSpacing.x3;
const _performanceVisualScrollClearance = 108.0;
const _performanceNativeScrollClearance = 72.0;
const _performanceReturnCardHeight = 92.0;
const _performanceTabsHeight = 48.0;
const _performanceEquityChartHeight = 128.0;
const _performanceSlippageChartHeight = 126.0;
const _performanceInfoLineHeight = 1.18;

class CopyPerformancePage extends ConsumerStatefulWidget {
  const CopyPerformancePage({
    super.key,
    required this.copyId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc074_copy_performance_content');

  static Key tabKey(String id) => Key('sc074_copy_performance_tab_$id');

  final String copyId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopyPerformancePage> createState() =>
      _CopyPerformancePageState();
}

class _CopyPerformancePageState extends ConsumerState<CopyPerformancePage> {
  String _activeTab = 'overview';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getCopyPerformance(copyId: widget.copyId);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? _performanceVisualScrollClearance
            : _performanceNativeScrollClearance);

    return VitPageLayout(
      semanticLabel: 'SC-074 CopyPerformancePage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Phân tích hiệu suất',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.trade),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: CopyPerformancePage.contentKey,
                  padding: EdgeInsets.only(bottom: scrollEndClearance),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    children: [
                      _PerformanceSummary(snapshot: snapshot),
                      VitCard(
                        variant: VitCardVariant.inner,
                        density: VitDensity.compact,
                        padding: AppSpacing.cardPaddingCompact,
                        child: VitHighRiskStatePanel(
                          state: VitHighRiskUiState.riskReview,
                          title: 'Copy performance review',
                          message:
                              'PnL, fees, drawdown, trade history, risk metrics and next steps are reviewed before copy allocation changes.',
                          contractId: 'copy-performance-${widget.copyId}',
                          density: VitDensity.compact,
                        ),
                      ),
                      _PerformanceTabs(
                        activeTab: _activeTab,
                        onChanged: (value) =>
                            setState(() => _activeTab = value),
                      ),
                      if (_activeTab == 'overview')
                        _OverviewTab(snapshot: snapshot)
                      else if (_activeTab == 'trades')
                        _TradesTab(snapshot: snapshot)
                      else if (_activeTab == 'costs')
                        _CostsTab(snapshot: snapshot)
                      else
                        _MetricsTab(snapshot: snapshot),
                    ],
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
