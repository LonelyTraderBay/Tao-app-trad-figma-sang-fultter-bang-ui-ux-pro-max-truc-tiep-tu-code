import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

part '../widgets/bot_portfolio_dashboard_page_sections.dart';
part '../widgets/bot_portfolio_dashboard_page_common.dart';

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
    return VitTradeHubScaffold(
      title: 'Portfolio Dashboard',
      subtitle: 'Tổng quan danh mục bot đang chạy',
      semanticLabel: 'SC-128 BotPortfolioDashboardPage',
      contentKey: BotPortfolioDashboardPage.contentKey,
      shellRenderMode: shellRenderMode,
      activeProductId: 'bots',
      onBack: () => context.go(AppRoutePaths.tradeBots),
      children: [
        VitBotSubpageHero(
          primaryLabel: 'Tổng vốn',
          primaryValue: '\$${snapshot.summary.totalEquity.toStringAsFixed(0)}',
          secondaryLabel: 'Bot hoạt động',
          secondaryValue: '${snapshot.summary.activeBots}',
          secondaryColor: _portfolioGreen,
        ),
        VitTradeSection(
          title: 'Summary',
          child: _SummaryGrid(summary: snapshot.summary),
        ),
        VitTradeSection(
          title: 'Portfolio Equity Curve',
          child: _EquityCard(points: snapshot.equityPoints),
        ),
        VitTradeSection(
          title: 'Allocation Breakdown',
          child: _AllocationCard(allocations: snapshot.allocations),
        ),
        VitTradeSection(
          title: 'Bot Correlation Matrix',
          child: _CorrelationCard(rows: snapshot.correlations),
        ),
        VitTradeSection(
          title: 'Health',
          child: _HealthCard(items: snapshot.healthItems),
        ),
        const VitBotRiskReviewFooter(
          title: 'Portfolio risk review',
          message:
              'Equity curve, allocation concentration, correlation pressure and health next steps are reviewed before portfolio changes.',
          contractId: 'bot-portfolio-review',
        ),
      ],
    );
  }
}
