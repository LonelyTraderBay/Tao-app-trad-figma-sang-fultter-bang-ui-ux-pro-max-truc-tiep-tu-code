import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/execution_quality_common.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/execution_quality_overview.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/execution_quality_sheets.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/execution_quality_tabs.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

import '../widgets/trade_body_review_widgets.dart';

class ExecutionQualityDemoPage extends ConsumerStatefulWidget {
  const ExecutionQualityDemoPage({super.key, this.shellRenderMode});

  static const contentKey = executionQualityContentKey;
  static const slippageButtonKey = executionQualitySlippageButtonKey;
  static const executionButtonKey = executionQualityExecutionButtonKey;
  static const amendmentButtonKey = executionQualityAmendmentButtonKey;
  static const slippageSaveKey = executionQualitySlippageSaveKey;
  static const amendmentSaveKey = executionQualityAmendmentSaveKey;

  static Key tabKey(String id) => executionQualityTabKey(id);
  static Key featureKey(String id) => executionQualityFeatureKey(id);
  static Key toleranceKey(double value) => executionQualityToleranceKey(value);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ExecutionQualityDemoPage> createState() =>
      _ExecutionQualityDemoPageState();
}

class _ExecutionQualityDemoPageState
    extends ConsumerState<ExecutionQualityDemoPage> {
  ExecutionQualityTab _tab = ExecutionQualityTab.slippage;
  late TradeSlippageSettings _settings;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _settings = ref
        .read(tradeReadModelControllerProvider)
        .getExecutionQuality()
        .slippageSettings;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getExecutionQuality();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();

    final bottomInset = tradeScrollBottomInset(context, shellRenderMode: mode);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-061 ExecutionQualityDemoPage',
      child: Stack(
        children: [
          Material(
            type: MaterialType.transparency,
            child: VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: 'Execution Quality',
                showBack: true,
                onBack: () => context.go(AppRoutePaths.trade),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      key: ExecutionQualityDemoPage.contentKey,
                      padding: AppSpacing.tradeToolScrollPadding(bottomInset),
                      child: VitPageContent(
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        customGap: AppSpacing.tradeToolCardGap,
                        children: [
                          const ExecutionQualityIntroCard(),
                          for (final feature in snapshot.features)
                            ExecutionQualityFeatureCard(
                              feature: feature,
                              onTap: () => _onFeatureTap(feature),
                            ),
                          const ExecutionQualityBenefitsCard(),
                          ExecutionQualityProgressCard(
                            items: snapshot.statusItems,
                          ),
                          const ExecutionQualityParityCard(),
                          ExecutionQualityTabs(
                            active: _tab,
                            onChanged: (tab) => setState(() => _tab = tab),
                          ),
                          if (_tab == ExecutionQualityTab.slippage)
                            ExecutionQualitySlippageTab(
                              settings: _settings,
                              onOpen: _openSlippageSheet,
                            )
                          else if (_tab == ExecutionQualityTab.execution)
                            ExecutionQualityExecutionTab(
                              onOpen: _openExecutionSheet,
                            )
                          else
                            ExecutionQualityAmendmentTab(
                              onOpen: _openAmendmentSheet,
                            ),
                          const TradeBodyReviewSection(
                            title: 'Execution quality review',
                            message: 'Execution quality body reviewed',
                            detail:
                                'Slippage, execution report, amendment, sheet, success, and result states stay visible.',
                            primary:
                                'Feature cards keep execution safeguards visible before sheets open.',
                            secondary:
                                'Tabbed controls preserve the active quality workflow.',
                            tertiary:
                                'Success toast remains separate from the underlying settings state.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_successMessage != null)
            Positioned(
              left: 20,
              right: 20,
              top: mode.usesVisualQaFrame ? 80 : 24,
              child: ExecutionQualitySuccessToast(
                message: _successMessage!,
                onClose: () => setState(() => _successMessage = null),
              ),
            ),
        ],
      ),
    );
  }

  void _onFeatureTap(TradeExecutionFeature feature) {
    if (feature.id == 'execution') {
      setState(() => _tab = ExecutionQualityTab.execution);
      _openExecutionSheet();
      return;
    }
    if (feature.id == 'amendment') {
      setState(() => _tab = ExecutionQualityTab.amendment);
      _openAmendmentSheet();
      return;
    }
    setState(() => _tab = ExecutionQualityTab.slippage);
    _openSlippageSheet();
  }

  Future<void> _openSlippageSheet() async {
    final updated = await showVitBottomSheet<TradeSlippageSettings>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => ExecutionQualitySlippageSheet(settings: _settings),
    );
    if (updated == null || !mounted) return;
    final saved = ref
        .read(tradeReadModelControllerProvider)
        .updateSlippageSettings(updated);
    setState(() {
      _settings = saved;
      _successMessage =
          'Slippage tolerance updated to ${saved.tolerancePct.toStringAsFixed(1)}%';
    });
  }

  Future<void> _openExecutionSheet() async {
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => ExecutionQualityExecutionSheet(
        report: ref
            .read(tradeReadModelControllerProvider)
            .getExecutionQuality()
            .report,
      ),
    );
  }

  Future<void> _openAmendmentSheet() async {
    final order = ref
        .read(tradeReadModelControllerProvider)
        .getExecutionQuality()
        .openOrder;
    final amended = await showVitBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => ExecutionQualityAmendmentSheet(order: order),
    );
    if (amended != true || !mounted) return;
    final result = ref
        .read(tradeReadModelControllerProvider)
        .amendOrder(
          TradeOrderAmendmentRequest(
            orderId: order.id,
            newPrice: 68600,
            newAmount: order.amount,
          ),
        );
    setState(() => _successMessage = 'Order Modified · ${result.orderId}');
  }
}
