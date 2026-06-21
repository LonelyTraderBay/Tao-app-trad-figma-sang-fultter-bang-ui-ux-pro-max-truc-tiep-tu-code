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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/ex_ante_costs_overview.dart';
part '../widgets/ex_ante_costs_summary_breakdown.dart';
part '../widgets/ex_ante_costs_scenarios_actions.dart';
part '../widgets/ex_ante_costs_common.dart';

const _costBackground = AppColors.bg;
const _costPanel2 = AppColors.surface2;
const _costBorder = AppColors.borderSolid;
const _costPrimary = AppColors.primary;
const _costGreen = AppColors.buy;
const _costAmber = AppColors.caution;
const _costRed = AppColors.sell;
const _costSpace = AppSpacing.x2;
const _costTinySpace = AppSpacing.x1;
const _costVisualScrollClearance = 112.0;
const _costNativeScrollClearance = 72.0;
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
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? _costVisualScrollClearance
            : _costNativeScrollClearance);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-105 ExAnteCostsPage',
      child: Material(
        color: _costBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Cost Disclosure (Ex-Ante)',
            subtitle: 'Before You Invest',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
            actions: const [
              VitHeaderActionItem(
                type: VitHeaderActionType.export,
                onPressed: null,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: ExAnteCostsPage.contentKey,
                  padding: EdgeInsetsDirectional.only(
                    bottom: scrollEndClearance,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    children: [
                      const _RegulatoryNotice(),
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
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Ex-ante cost preview',
                        message:
                            'Review fees, RIY impact, limits, and next-step documents before investing.',
                        contractId: 'SC-105 ex-ante costs review',
                        density: VitDensity.compact,
                      ),
                      const _QuickLinks(),
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

  void _setTab(String id) => setState(() => _tab = id);
}
