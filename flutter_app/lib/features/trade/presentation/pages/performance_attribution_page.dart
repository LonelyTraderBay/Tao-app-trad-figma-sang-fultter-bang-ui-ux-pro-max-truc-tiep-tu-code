import 'dart:math' as math;

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
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

part '../widgets/performance_attribution_summary_tabs.dart';
part '../widgets/performance_attribution_tabs.dart';
part '../widgets/performance_attribution_painters.dart';
part '../widgets/performance_attribution_common.dart';

const _attributionPrimary = AppColors.primary;
const _attributionPurple = AppColors.accent;
const _attributionGreen = AppColors.buy;
const _attributionRed = AppColors.sell;
const _attributionGray = AppColors.text3;
const _attributionChartHeight = 132.0;
const _attributionLargeChartHeight = 148.0;

class PerformanceAttributionPage extends ConsumerStatefulWidget {
  const PerformanceAttributionPage({
    super.key,
    required this.copyId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc075_performance_attribution_content');

  static Key tabKey(String id) => Key('sc075_performance_attribution_tab_$id');

  final String copyId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PerformanceAttributionPage> createState() =>
      _PerformanceAttributionPageState();
}

class _PerformanceAttributionPageState
    extends ConsumerState<PerformanceAttributionPage> {
  String _activeTab = 'attribution';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getPerformanceAttribution(copyId: widget.copyId);

    return VitTradeDetailScaffold(
      title: 'Phân tích hiệu suất',
      semanticLabel: 'SC-075 PerformanceAttributionPage',
      contentKey: PerformanceAttributionPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () =>
          context.go(AppRoutePaths.tradeCopyPerformance(widget.copyId)),
      children: [
        VitTradeSection(
          title: 'Đánh giá rủi ro',
          child: const VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            density: VitDensity.compact,
            title: 'Xem lại phân bổ hiệu suất',
            message:
                'Xác nhận drawdown, mức phơi nhiễm, giới hạn và bước tiếp theo trước khi điều chỉnh phân bổ copy.',
          ),
        ),
        VitTradeSection(
          title: 'Tổng quan',
          child: _SummaryGrid(snapshot: snapshot),
        ),
        VitTradeSection(
          title: 'Phân tích',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _AttributionTabs(
                activeTab: _activeTab,
                onChanged: (value) => setState(() => _activeTab = value),
              ),
              if (_activeTab == 'attribution')
                _AttributionTab(snapshot: snapshot)
              else if (_activeTab == 'drawdown')
                _DrawdownTab(snapshot: snapshot)
              else if (_activeTab == 'projection')
                _ProjectionTab(snapshot: snapshot)
              else
                _CorrelationTab(snapshot: snapshot),
            ],
          ),
        ),
      ],
    );
  }
}
