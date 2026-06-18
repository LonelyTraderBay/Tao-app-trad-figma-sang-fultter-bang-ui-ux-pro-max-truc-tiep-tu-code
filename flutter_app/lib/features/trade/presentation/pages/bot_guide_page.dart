import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
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

part '../widgets/bot_guide_intro_tabs.dart';
part '../widgets/bot_guide_strategies.dart';
part '../widgets/bot_guide_blocks.dart';
part '../widgets/bot_guide_practices_videos.dart';
part '../widgets/bot_guide_common.dart';

const _guideBackground = AppColors.bg;
const _guidePrimary = AppColors.primary;
const _guideGreen = AppColors.buy;
const _guideRed = AppColors.sell;

class BotGuidePage extends ConsumerStatefulWidget {
  const BotGuidePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc131_bot_guide_content');
  static Key tabKey(String id) => Key('sc131_bot_guide_tab_$id');
  static Key strategyKey(String id) => Key('sc131_bot_guide_strategy_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotGuidePage> createState() => _BotGuidePageState();
}

class _BotGuidePageState extends ConsumerState<BotGuidePage> {
  String _view = 'strategies';
  String? _expandedStrategyId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeReadModelControllerProvider).getBotGuide();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.tradeBotBottomInsetVisual
            : DeviceMetrics.nativeBottomChrome +
                  AppSpacing.tradeBotBottomInsetNative) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-131 BotGuidePage',
      child: Material(
        color: _guideBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Trading Bots Guide',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeBots),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: BotGuidePage.contentKey,
                  padding: AppSpacing.tradeBotScrollPaddingWithBottom(
                    bottomInset,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: 16,
                    children: [
                      const _IntroBanner(),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        padding: AppSpacing.tradeBotInnerPanelPadding,
                        child: VitPageContent(
                          padding: VitContentPadding.none,
                          customGap: AppSpacing.tradeBotSmallGap,
                          children: [
                            VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Bot education review',
                              message:
                                  'Strategy type, setup risk, operational limits, mistakes and next steps are reviewed before bot activation.',
                              contractId: 'bot-guide-review',
                            ),
                            VitStatusPill(
                              label: 'Education before activation',
                              status: VitStatusPillStatus.warning,
                              size: VitStatusPillSize.sm,
                            ),
                          ],
                        ),
                      ),
                      _Tabs(active: _view, onChanged: _setView),
                      VitPageSection(
                        customGap: 0,
                        children: [
                          if (_view == 'strategies')
                            _StrategiesView(
                              strategies: snapshot.strategies,
                              expandedStrategyId: _expandedStrategyId,
                              onToggle: _toggleStrategy,
                            )
                          else if (_view == 'best-practices')
                            _BestPracticesView(items: snapshot.bestPractices)
                          else
                            _MistakesView(items: snapshot.mistakes),
                        ],
                      ),
                      const _VideoTutorialsCard(),
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

  void _setView(String view) {
    setState(() {
      _view = view;
      _expandedStrategyId = null;
    });
  }

  void _toggleStrategy(String strategyId) {
    setState(() {
      _expandedStrategyId = _expandedStrategyId == strategyId
          ? null
          : strategyId;
    });
  }
}
