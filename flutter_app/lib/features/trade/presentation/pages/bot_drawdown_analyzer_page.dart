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

part '../widgets/bot_drawdown_analyzer_page_sections.dart';
part '../widgets/bot_drawdown_analyzer_page_common.dart';

const _drawdownBackground = AppColors.bg;
const _drawdownPanel = AppColors.surface;
const _drawdownPanel2 = AppColors.surface2;
const _drawdownRed = AppColors.sell;
const _drawdownAmber = AppColors.caution;
const _drawdownGreen = AppColors.buy;
const _drawdownPrimary = AppColors.primary;
const _drawdownAxis = AppColors.chartAxisStrong;

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
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 96
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: contentKey,
                  padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _MetricGrid(summary: snapshot.summary),
                      const SizedBox(height: 17),
                      const _SectionLabel('Underwater Equity'),
                      const SizedBox(height: 10),
                      _UnderwaterCard(points: snapshot.underwaterPoints),
                      const SizedBox(height: 18),
                      const _SectionLabel('Drawdown Duration Distribution'),
                      const SizedBox(height: 10),
                      _DurationCard(buckets: snapshot.durationBuckets),
                      const SizedBox(height: 18),
                      const _SectionLabel('Major Drawdown Events'),
                      const SizedBox(height: 10),
                      _EventsList(events: snapshot.events),
                      const SizedBox(height: 18),
                      _AnalysisCard(insights: snapshot.insights),
                      const SizedBox(height: 12),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        padding: EdgeInsets.all(12),
                        child: VitHighRiskStatePanel(
                          state: VitHighRiskUiState.riskReview,
                          title: 'Drawdown review state',
                          message:
                              'Peak-to-trough metrics, duration distribution, event evidence and mitigation next steps are reviewed before strategy changes.',
                          contractId: 'bot-drawdown-review',
                        ),
                      ),
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
