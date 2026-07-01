import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
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
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

part '../widgets/bot_drawdown_analyzer_page_sections.dart';
part '../widgets/bot_drawdown_analyzer_page_common.dart';

const _drawdownBackground = AppColors.bg;
const _drawdownRed = AppColors.sell;
const _drawdownAmber = AppColors.caution;
const _drawdownGreen = AppColors.buy;
const _drawdownPrimary = AppColors.primary;
const _drawdownAxis = AppColors.chartAxisStrong;
const double _drawdownFramedScrollClearance =
    AppSpacing.buttonStandard + AppSpacing.x7;
const double _drawdownNativeScrollClearance =
    AppSpacing.buttonStandard + AppSpacing.x5;
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
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance = tradeScrollBottomInset(
        context,
        shellRenderMode: mode,
      );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-129 BotDrawdownAnalyzerPage',
      child: Material(
        color: _drawdownBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Drawdown Analyzer',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeBots),
          ),
          child: VitInsetScrollView(
            key: contentKey,
            bottomInset: scrollEndClearance,
            child: VitPageContent(
              padding: VitContentPadding.compact,
              density: VitDensity.compact,
              children: [
                _MetricGrid(summary: snapshot.summary),
                const VitCard(
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
                const _SectionLabel('Underwater Equity'),
                _UnderwaterCard(points: snapshot.underwaterPoints),
                const _SectionLabel('Drawdown Duration Distribution'),
                _DurationCard(buckets: snapshot.durationBuckets),
                const _SectionLabel('Major Drawdown Events'),
                _EventsList(events: snapshot.events),
                _AnalysisCard(insights: snapshot.insights),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
