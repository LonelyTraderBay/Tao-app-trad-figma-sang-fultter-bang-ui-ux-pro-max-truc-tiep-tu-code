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

part '../widgets/performance_scenarios_intro_widgets.dart';
part '../widgets/performance_scenarios_outcome_widgets.dart';

const _scenarioBackground = AppColors.bg;
const _scenarioPanel = AppColors.surface;
const _scenarioPanel2 = AppColors.surface2;
const _scenarioBorder = AppColors.borderSolid;
const _scenarioPrimary = AppColors.primary;
const _scenarioRed = AppColors.sell;
const _scenarioAmber = AppColors.caution;
const _scenarioGreen = AppColors.buy;

class PerformanceScenariosPage extends ConsumerStatefulWidget {
  const PerformanceScenariosPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc109_performance_scenarios_content');
  static Key periodKey(int years) => Key('sc109_period_$years');
  static Key scenarioKey(String label) =>
      Key('sc109_scenario_${label.toLowerCase()}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PerformanceScenariosPage> createState() =>
      _PerformanceScenariosPageState();
}

class _PerformanceScenariosPageState
    extends ConsumerState<PerformanceScenariosPage> {
  int? _holdingPeriod;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getPerformanceScenarios();
    final selectedPeriod = _holdingPeriod ?? snapshot.defaultHoldingPeriod;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 70
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-109 PerformanceScenariosPage',
      child: Material(
        color: _scenarioBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Performance Scenarios',
              subtitle: 'Potential Outcomes',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: PerformanceScenariosPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _WarningNotice(),
                    const SizedBox(height: 25),
                    _InvestmentCard(investment: snapshot.investment),
                    const SizedBox(height: 26),
                    _HoldingPeriodSelector(
                      periods: snapshot.holdingPeriods,
                      selectedPeriod: selectedPeriod,
                      onChanged: (value) =>
                          setState(() => _holdingPeriod = value),
                    ),
                    const SizedBox(height: 25),
                    const _SectionLabel('Potential Outcomes'),
                    const SizedBox(height: 10),
                    for (final scenario in snapshot.scenarios) ...[
                      _ScenarioCard(
                        scenario: scenario,
                        investment: snapshot.investment,
                        holdingPeriod: selectedPeriod,
                      ),
                      if (scenario != snapshot.scenarios.last)
                        const SizedBox(height: 13),
                    ],
                    const SizedBox(height: 36),
                    const _InfoNote(),
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
