import 'dart:math' as math;

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
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

part '../widgets/bot_portfolio_dashboard_page_sections.dart';
part '../widgets/bot_portfolio_dashboard_page_common.dart';

const _portfolioBackground = AppColors.bg;
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
    final bottomInset = tradeScrollBottomInset(
      context,
      shellRenderMode: mode,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-128 BotPortfolioDashboardPage',
      child: Material(
        color: _portfolioBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Portfolio Dashboard',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeBots),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: contentKey,
                  clipBehavior: Clip.none,
                  padding: AppSpacing.tradeBotScrollPaddingWithBottom(
                    bottomInset,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    gap: VitContentGap.tight,
                    children: [
                      _SummaryGrid(summary: snapshot.summary),
                      VitPageSection(
                        label: 'Portfolio Equity Curve',
                        children: [_EquityCard(points: snapshot.equityPoints)],
                      ),
                      VitPageSection(
                        label: 'Allocation Breakdown',
                        children: [
                          _AllocationCard(allocations: snapshot.allocations),
                        ],
                      ),
                      VitPageSection(
                        label: 'Bot Correlation Matrix',
                        children: [
                          _CorrelationCard(rows: snapshot.correlations),
                        ],
                      ),
                      _HealthCard(items: snapshot.healthItems),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        padding: AppSpacing.tradeBotInnerPanelPadding,
                        child: VitHighRiskStatePanel(
                          state: VitHighRiskUiState.riskReview,
                          title: 'Portfolio risk review',
                          message:
                              'Equity curve, allocation concentration, correlation pressure and health next steps are reviewed before portfolio changes.',
                          contractId: 'bot-portfolio-review',
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
