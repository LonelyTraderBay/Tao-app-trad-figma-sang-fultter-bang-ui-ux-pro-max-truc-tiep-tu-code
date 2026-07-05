import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/vit_trade_compliance_section.dart';

part '../widgets/ex_ante_costs_overview.dart';
part '../widgets/ex_ante_costs_summary_breakdown.dart';
part '../widgets/ex_ante_costs_scenarios_actions.dart';
part '../widgets/ex_ante_costs_common.dart';

const _costBorder = AppColors.borderSolid;
const _costPrimary = AppColors.primary;
const _costGreen = AppColors.buy;
const _costAmber = AppColors.caution;
const _costRed = AppColors.sell;
const _costSpace = AppSpacing.x2;
const _costTinySpace = AppSpacing.x1;
const _costIconTile = 34.0;
const _costButtonExtent = 44.0;
const _costTabExtent = 44.0;
const _costSwatchExtent = 14.0;
const _costLineTight = 1.2;

class ExAnteCostsPage extends ConsumerStatefulWidget {
  const ExAnteCostsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc105_ex_ante_content');
  static const riyKey = Key('sc105_ex_ante_riy');
  static const exPostKey = Key('sc105_ex_ante_ex_post');
  static const kidKey = Key('sc105_ex_ante_kid');
  static Key tabKey(String id) => Key('sc105_ex_ante_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ExAnteCostsPage> createState() => _ExAnteCostsPageState();
}

class _ExAnteCostsPageState extends ConsumerState<ExAnteCostsPage> {
  String _tab = 'summary';
  int _holdingPeriod = 3;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getExAnteCosts();
    return VitTradeHubScaffold(
      title: 'Cost Disclosure (Ex-Ante)',
      subtitle: 'Before You Invest',
      semanticLabel: 'SC-105 ExAnteCostsPage',
      contentKey: ExAnteCostsPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
      headerActions: [
        VitHeaderActionItem(type: VitHeaderActionType.export, onPressed: null),
      ],
      children: [
        VitTradeSection(
          title: 'Review',
          child: const VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            title: 'Ex-ante cost preview',
            message:
                'Review fees, RIY impact, limits, and next-step documents before investing.',
            contractId: 'SC-105 ex-ante costs review',
            density: VitDensity.compact,
          ),
        ),
        VitTradeComplianceSection(
          title: 'Cost preview',
          statusPill: const VitStatusPill(
            label: 'Review required',
            status: VitStatusPillStatus.info,
            size: VitStatusPillSize.sm,
          ),
          items: [
            VitTradeComplianceItem(
              label: 'Investment',
              value: '€${snapshot.investmentAmount.toStringAsFixed(0)}',
            ),
            VitTradeComplianceItem(
              label: 'Holding period',
              value: '$_holdingPeriod years',
            ),
          ],
        ),
        VitTradeSection(title: 'Notice', child: const _RegulatoryNotice()),
        VitTradeSection(
          title: 'Costs',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _InvestmentCard(snapshot: snapshot),
              _Tabs(activeId: _tab, onChanged: _setTab),
              if (_tab == 'summary')
                _Summary(snapshot: snapshot)
              else if (_tab == 'breakdown')
                _Breakdown(snapshot: snapshot)
              else
                _Scenarios(
                  snapshot: snapshot,
                  holdingPeriod: _holdingPeriod,
                  onChanged: (period) =>
                      setState(() => _holdingPeriod = period),
                ),
              const _QuickLinks(),
            ],
          ),
        ),
      ],
    );
  }

  void _setTab(String id) => setState(() => _tab = id);
}
