import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/margin_trading_hub_widgets.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

part '../widgets/margin_trading_hub_hero_nav.dart';
part '../widgets/margin_trading_hub_cards.dart';

const _hubHeroBorder = AppColors.primary20;
const _hubBorder = AppColors.borderSolid;
const _hubPrimary = AppColors.primary;
const _hubGreen = AppColors.buy;
const _hubSpace = AppSpacing.x2;
const _hubTinySpace = AppSpacing.x1;
const _hubHeroIconTile = 44.0;
const _hubIconTile = 34.0;
const _hubLineTight = 1.2;
const _hubLineBody = 1.24;
const _hubComplianceGridColumns =
    AppSpacing.marginTradingHubComplianceGridColumns;
const _hubComplianceGridExtent =
    AppSpacing.marginTradingHubComplianceGridExtent;

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

    return VitTradeHubScaffold(
      title: 'Hub ký quỹ',
      subtitle: 'Công cụ · Tuân thủ',
      semanticLabel: 'SC-090 MarginTradingHubPage',
      contentKey: contentKey,
      shellRenderMode: mode,
      onBack: () => context.go(AppRoutePaths.tradeMargin),
      activeProductId: 'margin',
      children: [
        VitTradeSection(
          title: 'Tổng quan ký quỹ',
          child: _HeroCard(stats: snapshot.stats),
        ),
        VitTradeSection(
          title: 'Điều hướng',
          child: _NavigationCard(items: snapshot.menuItems),
        ),
        const VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: 'Xem lại rủi ro ký quỹ',
          message:
              'Kiểm tra hạn đòn bẩy, rủi ro thanh lý, phí và ký quỹ khả dụng trước khi mở bất kỳ luồng margin nào.',
          contractId: 'SC-090 margin hub review',
          density: VitDensity.compact,
        ),
        VitTradeSection(
          title: 'Tính năng',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final feature in snapshot.features) ...[
                _FeatureCard(feature: feature),
                if (feature != snapshot.features.last)
                  const SizedBox(height: AppSpacing.x3),
              ],
            ],
          ),
        ),
        VitTradeSection(
          title: 'Tuân thủ',
          child: _ComplianceCard(compliance: snapshot.compliance),
        ),
      ],
    );
  }
}
