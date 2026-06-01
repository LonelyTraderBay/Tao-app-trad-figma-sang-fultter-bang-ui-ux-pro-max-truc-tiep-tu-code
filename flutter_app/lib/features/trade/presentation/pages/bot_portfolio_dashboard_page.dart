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
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/bot_portfolio_dashboard_page_sections.dart';
part '../widgets/bot_portfolio_dashboard_page_common.dart';

const _portfolioBackground = AppColors.bg;
const _portfolioPanel = AppColors.surface;
const _portfolioPrimary = AppColors.primary;
const _portfolioGreen = AppColors.buy;
const _portfolioAmber = AppColors.caution;
const _portfolioRed = AppColors.sell;
const _portfolioAxis = AppColors.chartAxisStrong;

class BotPortfolioDashboardPage extends ConsumerWidget {
  const BotPortfolioDashboardPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc128_bot_portfolio_dashboard_content');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getBotPortfolioDashboard();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-128 BotPortfolioDashboardPage',
      child: Material(
        color: _portfolioBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Portfolio Dashboard',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeBots),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: contentKey,
                padding: EdgeInsets.fromLTRB(20, 11, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SummaryGrid(summary: snapshot.summary),
                    const SizedBox(height: 12),
                    const _SectionLabel('Portfolio Equity Curve'),
                    const SizedBox(height: 10),
                    _EquityCard(points: snapshot.equityPoints),
                    const SizedBox(height: 18),
                    const _SectionLabel('Allocation Breakdown'),
                    const SizedBox(height: 10),
                    _AllocationCard(allocations: snapshot.allocations),
                    const SizedBox(height: 18),
                    const _SectionLabel('Bot Correlation Matrix'),
                    const SizedBox(height: 10),
                    _CorrelationCard(rows: snapshot.correlations),
                    const SizedBox(height: 18),
                    _HealthCard(items: snapshot.healthItems),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
