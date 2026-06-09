import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/position_dashboard_page_sections.dart';
part '../widgets/position_dashboard_page_common.dart';

const _tradePrimary = AppColors.primary;
const _cardBackground = AppColors.surface2;
const _chipBackground = AppColors.surface2;
const _futuresColor = AppColors.caution;
const _marginColor = AppColors.accent;

class PositionDashboardPage extends ConsumerStatefulWidget {
  const PositionDashboardPage({super.key, this.shellRenderMode});

  static Key tabKey(String id) => Key('sc053_tab_$id');
  static Key sortKey(String id) => Key('sc053_sort_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PositionDashboardPage> createState() =>
      _PositionDashboardPageState();
}

class _PositionDashboardPageState extends ConsumerState<PositionDashboardPage> {
  String _activeTab = 'all';
  String _sortBy = 'pnl';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getTradePositions();
    final positions = _visiblePositions(snapshot.positions);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-053 PositionDashboardPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Vị thế đang mở',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.trade),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: bottomChrome + 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SummaryCard(positions: snapshot.positions),
                      const SizedBox(height: 12),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        padding: EdgeInsets.all(12),
                        child: VitHighRiskStatePanel(
                          state: VitHighRiskUiState.riskReview,
                          title: 'Open position risk review',
                          message:
                              'PnL, notional exposure, margin risk, close path, fees and next steps are reviewed before position actions.',
                          contractId: 'position-dashboard-review',
                        ),
                      ),
                      _TypeTabs(
                        active: _activeTab,
                        positions: snapshot.positions,
                        onChanged: (tab) => setState(() => _activeTab = tab),
                      ),
                      _SortChips(
                        active: _sortBy,
                        onChanged: (sort) => setState(() => _sortBy = sort),
                      ),
                      const SizedBox(height: 14),
                      if (positions.isEmpty)
                        const _EmptyPositions()
                      else
                        for (final position in positions) ...[
                          _PositionTile(position: position),
                          const SizedBox(height: 16),
                        ],
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

  List<TradeDashboardPosition> _visiblePositions(
    List<TradeDashboardPosition> source,
  ) {
    final filtered = _activeTab == 'all'
        ? source
        : source.where((position) => position.type.name == _activeTab);
    final sorted = filtered.toList(growable: false);
    sorted.sort((a, b) {
      if (_sortBy == 'pnlPct') return b.pnlPct.abs().compareTo(a.pnlPct.abs());
      if (_sortBy == 'size') return b.notional.compareTo(a.notional);
      return b.pnl.abs().compareTo(a.pnl.abs());
    });
    return sorted;
  }
}
