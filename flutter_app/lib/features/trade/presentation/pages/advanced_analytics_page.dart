import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
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
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

part '../widgets/advanced_analytics_page_hero.dart';
part '../widgets/advanced_analytics_page_ai_signals.dart';
part '../widgets/advanced_analytics_page_signal_card.dart';
part '../widgets/advanced_analytics_page_risk_journal.dart';
part '../widgets/advanced_analytics_page_sizing_footer.dart';
part '../widgets/advanced_analytics_page_shared.dart';

const _advancedBackground = AppColors.bg;
const _advancedBorder = AppColors.borderSolid;
const _advancedPrimary = AppColors.primary;
const _advancedGreen = AppColors.buy;
const _advancedRed = AppColors.sell;
const _advancedPurple = AppColors.accent;
const _advancedAmber = AppColors.caution;

class AdvancedAnalyticsPage extends ConsumerStatefulWidget {
  const AdvancedAnalyticsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc092_advanced_analytics_content');
  static Key tabKey(String id) => Key('sc092_advanced_tab_$id');
  static Key filterKey(String id) => Key('sc092_advanced_filter_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AdvancedAnalyticsPage> createState() =>
      _AdvancedAnalyticsPageState();
}

class _AdvancedAnalyticsPageState extends ConsumerState<AdvancedAnalyticsPage> {
  String _tab = 'ai';
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getAdvancedAnalytics();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollClearance = tradeScrollBottomInset(
      context,
      shellRenderMode: mode,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-092 AdvancedAnalyticsPage',
      child: Material(
        color: _advancedBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Phân tích nâng cao',
            subtitle: 'AI · Rủi ro · Nhật ký',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeMargin),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: VitInsetScrollView(
                  key: AdvancedAnalyticsPage.contentKey,
                  bottomInset: scrollClearance,
                  child: VitPageContent(
                    rhythm: VitPageRhythm.standard,
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    children: tradeShellWithProductTabs(
                      context: context,
                      children: [
                        VitTradeSection(
                          title: 'Tổng quan',
                          child: _HeroCard(stats: snapshot.stats),
                        ),
                        const VitHighRiskStatePanel(
                          state: VitHighRiskUiState.riskReview,
                          density: VitDensity.compact,
                          title: 'Xem lại phân tích nâng cao',
                          message:
                              'Tín hiệu AI, sizing và nhật ký chỉ hỗ trợ quyết định. Xác nhận giới hạn rủi ro trước khi dùng cho lệnh thật.',
                          contractId: 'SC-092',
                        ),
                        _UnderlineTabs(
                          activeId: _tab,
                          onChanged: (id) => setState(() => _tab = id),
                        ),
                        if (_tab == 'ai')
                          _AiSignalsTab(
                            snapshot: snapshot,
                            activeFilter: _filter,
                            onFilterChanged: (id) =>
                                setState(() => _filter = id),
                          )
                        else if (_tab == 'risk')
                          _RiskAnalysisTab(snapshot: snapshot)
                        else if (_tab == 'journal')
                          _TradeJournalTab(snapshot: snapshot)
                        else
                          _PositionSizingTab(snapshot: snapshot),
                        VitTradeSection(
                          title: 'Model info',
                          child: _ModelInfoCard(),
                        ),
                        VitTradeSection(
                          title: 'Features',
                          child: _FeaturesCard(features: snapshot.features),
                        ),
                      ],
                    ),
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
