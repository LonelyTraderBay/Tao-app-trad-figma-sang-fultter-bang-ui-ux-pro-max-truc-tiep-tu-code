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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/margin_trading_hub_widgets.dart';

part '../widgets/margin_trading_hub_hero_nav.dart';
part '../widgets/margin_trading_hub_cards.dart';

const _hubBackground = AppColors.bg;
const _hubHeroBorder = AppColors.primary20;
const _hubBorder = AppColors.borderSolid;
const _hubPrimary = AppColors.primary;
const _hubGreen = AppColors.buy;

class MarginTradingHubPage extends ConsumerWidget {
  const MarginTradingHubPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc090_margin_trading_hub_content');
  static Key menuKey(String id) => Key('sc090_margin_hub_menu_$id');
  static Key featureKey(String phase) => Key('sc090_margin_hub_feature_$phase');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getMarginTradingHub();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 118
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-090 MarginTradingHubPage',
      child: Material(
        color: _hubBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Margin Trading Hub',
            subtitle: 'Enterprise Features',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeMargin),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: contentKey,
                  padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: 0,
                    children: [
                      _HeroCard(stats: snapshot.stats),
                      const SizedBox(height: 16),
                      _NavigationCard(items: snapshot.menuItems),
                      const SizedBox(height: 14),
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Margin suite risk review',
                        message:
                            'Review leverage limits, liquidation risk, fees, available margin, and next steps before opening any margin workflow.',
                        contractId: 'SC-090 margin hub review',
                      ),
                      const SizedBox(height: 14),
                      for (final feature in snapshot.features) ...[
                        _FeatureCard(feature: feature),
                        const SizedBox(height: 14),
                      ],
                      _ComplianceCard(compliance: snapshot.compliance),
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
