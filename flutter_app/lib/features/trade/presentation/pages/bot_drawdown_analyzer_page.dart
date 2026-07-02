import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

part '../widgets/bot_drawdown_analyzer_page_sections.dart';
part '../widgets/bot_drawdown_analyzer_page_common.dart';

const _drawdownRed = AppColors.sell;
const _drawdownAmber = AppColors.caution;
const _drawdownGreen = AppColors.buy;
const _drawdownPrimary = AppColors.primary;
const _drawdownAxis = AppColors.chartAxisStrong;
const double _drawdownUnderwaterExtent =
    AppSpacing.buttonStandard * 3 + AppSpacing.x2;
const double _drawdownDurationExtent =
    AppSpacing.buttonStandard * 2 + AppSpacing.x5;

class BotDrawdownAnalyzerPage extends ConsumerWidget {
  const BotDrawdownAnalyzerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc129_bot_drawdown_analyzer_content');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getBotDrawdownAnalyzer();
    return VitTradeHubScaffold(
      title: 'Drawdown Analyzer',
      semanticLabel: 'SC-129 BotDrawdownAnalyzerPage',
      contentKey: BotDrawdownAnalyzerPage.contentKey,
      shellRenderMode: shellRenderMode,
      onBack: () => context.go(AppRoutePaths.tradeBots),
      children: [
        VitTradeSection(
          title: 'Metrics',
          child: _MetricGrid(summary: snapshot.summary),
        ),
        VitTradeSection(
          title: 'Đánh giá rủi ro',
          child: const VitCard(
            variant: VitCardVariant.inner,
            padding: AppSpacing.tradeBotCompactCardPadding,
            child: VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Drawdown review state',
              message:
                  'Peak-to-trough metrics, duration distribution, event evidence and mitigation next steps are reviewed before strategy changes.',
              contractId: 'bot-drawdown-review',
            ),
          ),
        ),
        VitTradeSection(
          title: 'Underwater Equity',
          child: _UnderwaterCard(points: snapshot.underwaterPoints),
        ),
        VitTradeSection(
          title: 'Drawdown Duration Distribution',
          child: _DurationCard(buckets: snapshot.durationBuckets),
        ),
        VitTradeSection(
          title: 'Major Drawdown Events',
          child: _EventsList(events: snapshot.events),
        ),
        VitTradeSection(
          title: 'Analysis',
          child: _AnalysisCard(insights: snapshot.insights),
        ),
      ],
    );
  }
}
