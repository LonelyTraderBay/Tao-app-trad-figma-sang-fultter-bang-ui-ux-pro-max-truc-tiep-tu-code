import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

part '../widgets/risk_management_overview.dart';
part '../widgets/risk_management_tabs.dart';
part '../widgets/risk_management_common.dart';

const _riskPrimary = AppColors.primary;
const _riskSpace = AppSpacing.x2;
const _riskTinySpace = AppSpacing.x1;
const _riskCardSpace = AppSpacing.x3;
const _riskControlExtent = 44.0;
const _riskTabExtent = 44.0;

enum _RiskTab { oco, positions, calculator }

class RiskManagementDemoPage extends ConsumerStatefulWidget {
  const RiskManagementDemoPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc060_risk_management_scroll_content');
  static const backKey = Key('sc060_back');
  static const ocoButtonKey = Key('sc060_open_oco');
  static const ocoSubmitKey = Key('sc060_submit_oco');
  static const calculatorButtonKey = Key('sc060_open_calculator');
  static const calculatorApplyKey = Key('sc060_apply_calculator');

  static Key tabKey(String id) => Key('sc060_tab_$id');
  static Key featureKey(String id) => Key('sc060_feature_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<RiskManagementDemoPage> createState() =>
      _RiskManagementDemoPageState();
}

class _RiskManagementDemoPageState
    extends ConsumerState<RiskManagementDemoPage> {
  _RiskTab _tab = _RiskTab.oco;
  String? _successMessage;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeRiskManagementControllerProvider)
        .state
        .snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance = tradeScrollBottomInset(
      context,
      shellRenderMode: mode,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-060 RiskManagementDemoPage',
      child: Stack(
        children: [
          Material(
            type: MaterialType.transparency,
            child: VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: 'Quản lý rủi ro',
                subtitle: 'OCO · Vị thế · Khối lượng',
                showBack: true,
                onBack: () => context.go(AppRoutePaths.trade),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      key: RiskManagementDemoPage.contentKey,
                      padding: EdgeInsetsDirectional.only(
                        bottom: scrollEndClearance,
                      ),
                      child: VitPageContent(
     rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        density: VitDensity.compact,
                        fullBleed: true,
                        children: tradeShellWithProductTabs(
                          context: context,
                          children: [
                            const _IntroCard(),
                          const VitCard(
                            variant: VitCardVariant.inner,
                            padding: AppSpacing.tradeToolRiskReviewPadding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                VitHighRiskStatePanel(
                                  state: VitHighRiskUiState.riskReview,
                                  title: 'Xem lại công cụ rủi ro',
                                  message:
                                      'Lệnh OCO, vị thế bảo vệ, kết quả máy tính khối lượng và phí được xem trước trước khi áp dụng.',
                                  contractId: 'risk-management-demo-review',
                                  density: VitDensity.compact,
                                ),
                                SizedBox(height: _riskSpace),
                                VitStatusPill(
                                  label: 'Xem trước khi thực hiện',
                                  status: VitStatusPillStatus.warning,
                                  size: VitStatusPillSize.sm,
                                ),
                              ],
                            ),
                          ),
                          for (final feature in snapshot.features) ...[
                            _FeatureCard(
                              feature: feature,
                              onTap: () => _onFeatureTap(feature),
                            ),
                          ],
                          const _BenefitsCard(),
                          _StatusCard(items: snapshot.statusItems),
                          _RiskTabs(
                            active: _tab,
                            onChanged: (tab) => setState(() => _tab = tab),
                          ),
                          VitPageSection(
                            density: VitDensity.compact,
                            children: [
                              if (_tab == _RiskTab.oco)
                                _OcoTab(onOpen: _openOcoSheet)
                              else if (_tab == _RiskTab.positions)
                                _PositionsTab(positions: snapshot.positions)
                              else
                                _CalculatorTab(onOpen: _openCalculatorSheet),
                            ],
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
          if (_successMessage != null)
            Positioned(
              left: AppSpacing.contentPad,
              right: AppSpacing.contentPad,
              top: mode.usesVisualQaFrame
                  ? AppSpacing.buttonHero
                  : AppSpacing.x5,
              child: _SuccessToast(
                message: _successMessage!,
                onClose: () => setState(() => _successMessage = null),
              ),
            ),
        ],
      ),
    );
  }

  void _onFeatureTap(TradeRiskFeature feature) {
    if (feature.id == 'positions') {
      setState(() => _tab = _RiskTab.positions);
      return;
    }
    if (feature.id == 'calculator') {
      setState(() => _tab = _RiskTab.calculator);
      _openCalculatorSheet();
      return;
    }
    setState(() => _tab = _RiskTab.oco);
    _openOcoSheet();
  }

  Future<void> _openOcoSheet() async {
    final submitted = await showVitBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => const _OcoSheet(),
    );
    if (submitted != true || !mounted) return;
    final result = ref
        .read(tradeRiskManagementControllerProvider)
        .submitOcoOrder(
          const TradeOcoOrderDraft(
            symbol: 'BTC/USDT',
            side: TradeOrderSide.buy,
            quantity: .015,
            limitPrice: 69000,
            takeProfitPrice: 72000,
            stopPrice: 66000,
          ),
        );
    setState(() => _successMessage = 'Đã đặt ${result.orderId}');
  }

  Future<void> _openCalculatorSheet() async {
    final applied = await showVitBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => _CalculatorSheet(
        result: ref
            .read(tradeRiskManagementControllerProvider)
            .calculatePositionSize(
              const TradePositionSizeRequest(
                accountBalance: 50000,
                riskPct: 1,
                entryPrice: 69000,
                stopPrice: 67500,
              ),
            ),
      ),
    );
    if (applied != true || !mounted) return;
    setState(() => _successMessage = 'Đã áp dụng khối lượng đề xuất');
  }
}
