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
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/bot_optimization_page_sections.dart';
part '../widgets/bot_optimization_page_common.dart';

const _optimizationBackground = AppColors.bg;
const _optimizationPanel = AppColors.surface;
const _optimizationPanel2 = AppColors.surface2;
const _optimizationPrimary = AppColors.primary;

class BotOptimizationPage extends ConsumerStatefulWidget {
  const BotOptimizationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc127_bot_optimization_content');
  static const startKey = Key('sc127_bot_optimization_start');

  static Key targetKey(String id) => Key('sc127_bot_optimization_target_$id');
  static Key rangeKey(String id) => Key('sc127_bot_optimization_range_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotOptimizationPage> createState() =>
      _BotOptimizationPageState();
}

class _BotOptimizationPageState extends ConsumerState<BotOptimizationPage> {
  String _selectedTarget = 'sharpe';
  double _gridCount = 25;
  double _gridRange = 35;
  TradeBotOptimizationResult? _lastResult;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getBotOptimization();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-127 BotOptimizationPage',
      child: Material(
        color: _optimizationBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Parameter Optimization',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeBots),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final baseBodyHeight =
                        DeviceMetrics.height - DeviceMetrics.safeTop;
                    final visualExtra = mode.usesVisualQaFrame
                        ? math.max(0.0, constraints.maxHeight - baseBodyHeight)
                        : 0.0;
                    final footerBottom =
                        (mode.usesVisualQaFrame
                            ? DeviceMetrics.bottomChrome -
                                  14 +
                                  visualExtra * .90
                            : DeviceMetrics.nativeBottomChrome) +
                        MediaQuery.paddingOf(context).bottom;

                    return Stack(
                      children: [
                        Positioned.fill(
                          child: SingleChildScrollView(
                            key: BotOptimizationPage.contentKey,
                            padding: EdgeInsets.fromLTRB(
                              20,
                              14,
                              20,
                              footerBottom + 74,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const _IntroCard(),
                                const SizedBox(height: 31),
                                const _SectionLabel('Optimization Target'),
                                const SizedBox(height: 10),
                                _TargetCard(
                                  targets: snapshot.targets,
                                  selectedId: _selectedTarget,
                                  onChanged: (id) =>
                                      setState(() => _selectedTarget = id),
                                ),
                                const SizedBox(height: 18),
                                const _SectionLabel('Parameter Ranges'),
                                const SizedBox(height: 10),
                                _RangeCard(
                                  ranges: snapshot.parameterRanges,
                                  gridCount: _gridCount,
                                  gridRange: _gridRange,
                                  onGridCountChanged: (value) =>
                                      setState(() => _gridCount = value),
                                  onGridRangeChanged: (value) =>
                                      setState(() => _gridRange = value),
                                ),
                                const SizedBox(height: 18),
                                _HowItWorksCard(steps: snapshot.steps),
                                if (_lastResult != null) ...[
                                  const SizedBox(height: 12),
                                  _QueuedCard(result: _lastResult!),
                                ],
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: footerBottom,
                          child: _StartFooter(onStart: () => _handleStart()),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleStart() {
    final result = ref
        .read(tradeReadModelControllerProvider)
        .runBotOptimization(
          TradeBotOptimizationRequest(
            targetId: _selectedTarget,
            gridCount: _gridCount,
            gridRangePct: _gridRange,
          ),
        );
    setState(() => _lastResult = result);
  }
}
