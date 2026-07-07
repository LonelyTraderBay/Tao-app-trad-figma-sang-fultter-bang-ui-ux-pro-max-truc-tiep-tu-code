import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
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

part '../widgets/bot_optimization_page_sections.dart';
part '../widgets/bot_optimization_page_common.dart';

const _optimizationBackground = AppColors.bg;
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
    const stickyFooterHeight =
        AppSpacing.tradeBotSheetActionHeight + AppSpacing.x3;
    final scrollEndClearance =
        tradeScrollBottomInset(context, shellRenderMode: mode) +
        stickyFooterHeight;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-127 BotOptimizationPage',
      child: Material(
        color: _optimizationBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitHeader(
              title: 'Parameter Optimization',
              subtitle: 'Tối ưu tham số chiến lược bot',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeBots),
            ),
            if (_lastResult != null)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  AppSpacing.contentPad,
                  AppSpacing.x2,
                  AppSpacing.contentPad,
                  0,
                ),
                child: _QueuedCard(result: _lastResult!),
              ),
            Expanded(
              child: VitInsetScrollView(
                key: BotOptimizationPage.contentKey,
                bottomInset: scrollEndClearance,
                child: VitPageContent(rhythm: VitPageRhythm.standard, 
                  padding: VitContentPadding.compact,
                  density: VitDensity.compact,
                  children: tradeShellWithProductTabs(
                    context: context,
                    activeProductId: 'bots',
                    children: [
                      VitBotSubpageHero(
                        primaryLabel: 'Mục tiêu',
                        primaryValue: _selectedTarget.toUpperCase(),
                        secondaryLabel: 'Kết quả',
                        secondaryValue: _lastResult == null ? '—' : 'Sẵn sàng',
                        secondaryColor:
                            _lastResult == null ? AppColors.text3 : _optimizationPrimary,
                      ),
                      VitTradeSection(
                        title: 'Overview',
                      child: const _IntroCard(),
                    ),
                    VitTradeSection(
                      title: 'Optimization Target',
                      child: _TargetCard(
                        targets: snapshot.targets,
                        selectedId: _selectedTarget,
                        onChanged: (id) => setState(() => _selectedTarget = id),
                      ),
                    ),
                    VitTradeSection(
                      title: 'Parameter Ranges',
                      child: _RangeCard(
                        ranges: snapshot.parameterRanges,
                        gridCount: _gridCount,
                        gridRange: _gridRange,
                        onGridCountChanged: (value) =>
                            setState(() => _gridCount = value),
                        onGridRangeChanged: (value) =>
                            setState(() => _gridRange = value),
                      ),
                    ),
                    VitTradeSection(
                      title: 'How it works',
                      child: _HowItWorksCard(steps: snapshot.steps),
                    ),
                    const VitBotRiskReviewFooter(
                      title: 'Optimization review required',
                      message:
                          'Target metric, parameter range, queue state, result preview and rollback next step are reviewed before bot changes.',
                      contractId: 'bot-optimization-review',
                      statusLabel: 'Queued before apply',
                    ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                bottom: tradeScrollBottomInset(
                  context,
                  shellRenderMode: widget.shellRenderMode,
                ),
              ),
              child: _StartFooter(onStart: () => _handleStart()),
            ),
          ],
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
