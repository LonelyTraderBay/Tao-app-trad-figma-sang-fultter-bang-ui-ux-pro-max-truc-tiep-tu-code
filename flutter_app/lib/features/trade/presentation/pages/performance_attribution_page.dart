import 'dart:math' as math;

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

part '../widgets/performance_attribution_summary_tabs.dart';
part '../widgets/performance_attribution_tabs.dart';
part '../widgets/performance_attribution_painters.dart';
part '../widgets/performance_attribution_common.dart';

const _attributionPrimary = AppColors.primary;
const _attributionPurple = AppColors.accent;
const _attributionGreen = AppColors.buy;
const _attributionRed = AppColors.sell;
const _attributionGray = AppColors.text3;

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
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 26 : 14);

    return VitPageLayout(
      semanticLabel: 'SC-075 PerformanceAttributionPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Phân tích hiệu suất',
            showBack: true,
            onBack: () =>
                context.go(AppRoutePaths.tradeCopyPerformance(widget.copyId)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: PerformanceAttributionPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 12, 20, bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SummaryGrid(snapshot: snapshot),
                      const SizedBox(height: 24),
                      _AttributionTabs(
                        activeTab: _activeTab,
                        onChanged: (value) =>
                            setState(() => _activeTab = value),
                      ),
                      const SizedBox(height: 22),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
