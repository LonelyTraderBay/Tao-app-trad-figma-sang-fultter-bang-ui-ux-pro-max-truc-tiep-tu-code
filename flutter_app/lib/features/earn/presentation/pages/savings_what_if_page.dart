import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

part 'savings_what_if_page_part_01.dart';
part 'savings_what_if_page_part_02.dart';
part 'savings_what_if_page_part_03.dart';
part 'savings_what_if_page_part_04.dart';
part '../widgets/savings_what_if_results.dart';
part '../widgets/savings_what_if_stress.dart';
part '../widgets/savings_what_if_stress_components.dart';
part '../widgets/savings_what_if_asset_impact.dart';
part '../widgets/savings_what_if_common_widgets.dart';
part '../widgets/savings_what_if_painters.dart';
part '../widgets/savings_what_if_models.dart';

TextStyle get _captionBold =>
    AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.bold);
TextStyle get _microBold =>
    AppTextStyles.micro.copyWith(fontWeight: AppTextStyles.bold);

class SavingsWhatIfPage extends ConsumerStatefulWidget {
  const SavingsWhatIfPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc352_summary');
  static const scenariosKey = Key('sc352_scenarios');
  static const portfolioKey = Key('sc352_portfolio');
  static const runKey = Key('sc352_run');
  static const resultsKey = Key('sc352_results');
  static const stressKey = Key('sc352_stress');
  static const assetImpactKey = Key('sc352_asset_impact');
  static const resetKey = Key('sc352_reset');

  static Key scenarioKey(SavingsWhatIfScenarioId id) =>
      Key('sc352_scenario_${id.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsWhatIfPage> createState() => _SavingsWhatIfPageState();
}

class _SavingsWhatIfPageState extends ConsumerState<SavingsWhatIfPage> {
  String? _tab;
  SavingsWhatIfScenarioId? _selectedScenario;
  double? _customMultiplier;
  double? _customVolatility;
  bool _hasRun = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(savingsWhatIfRepositoryProvider).getWhatIf();
    final activeTab = _tab ?? snapshot.defaultTab;
    final selectedId = _selectedScenario ?? snapshot.defaultScenario;
    final scenario = _scenarioById(snapshot, selectedId);
    final multiplier = _customMultiplier ?? snapshot.defaultCustomMultiplier;
    final volatility = _customVolatility ?? snapshot.defaultCustomVolatility;
    final result = _simulateScenario(
      snapshot.portfolio,
      scenario,
      multiplier,
      volatility,
    );
    final totalValue = _totalPortfolioValue(snapshot.portfolio);
    final weightedApy = _weightedApy(snapshot.portfolio);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-352 SavingsWhatIfPage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: AppSpacing.earnBottomInsetPadding(bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    gap: VitContentGap.defaultGap,
                    children: [
                      _WhatIfHero(
                        snapshot: snapshot,
                        totalValue: totalValue,
                        weightedApy: weightedApy,
                        selectedScenario: scenario,
                        assetCount: snapshot.portfolio.length,
                      ),
                      _WhatIfTabs(
                        tabs: snapshot.tabs,
                        active: activeTab,
                        onChanged: (tab) {
                          HapticFeedback.selectionClick();
                          setState(() => _tab = tab);
                        },
                      ),
                      if (activeTab == 'scenarios')
                        ..._buildScenariosTab(
                          snapshot,
                          scenario,
                          multiplier,
                          volatility,
                        )
                      else if (activeTab == 'results')
                        _ResultsTab(
                          result: result,
                          scenario: scenario,
                          hasRun: _hasRun,
                          onRun: () => _runScenario(snapshot),
                          onReset: _resetScenario,
                        )
                      else
                        _StressTab(snapshot: snapshot),
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

  List<Widget> _buildScenariosTab(
    SavingsWhatIfSnapshot snapshot,
    SavingsWhatIfScenarioDraft selectedScenario,
    double multiplier,
    double volatility,
  ) {
    return [
      const _SectionTitle(label: 'Chọn kịch bản'),
      _ScenarioList(
        scenarios: snapshot.scenarios,
        selected: selectedScenario.id,
        customMultiplier: multiplier,
        customVolatility: volatility,
        onScenarioChanged: (id) {
          HapticFeedback.selectionClick();
          setState(() => _selectedScenario = id);
        },
        onCustomMultiplierChanged: (value) {
          HapticFeedback.selectionClick();
          setState(() => _customMultiplier = value);
        },
        onCustomVolatilityChanged: (value) {
          HapticFeedback.selectionClick();
          setState(() => _customVolatility = value);
        },
      ),
      const _SectionTitle(label: 'Danh mục hiện tại'),
      _PortfolioList(positions: snapshot.portfolio),
      _Disclaimer(text: snapshot.disclaimer, tone: AppColors.warn),
      VitCtaButton(
        key: SavingsWhatIfPage.runKey,
        onPressed: () => _runScenario(snapshot),
        leading: const Icon(Icons.play_arrow_rounded),
        child: Text('Chạy mô phỏng · ${selectedScenario.label}'),
      ),
    ];
  }

  void _runScenario(SavingsWhatIfSnapshot snapshot) {
    HapticFeedback.mediumImpact();
    setState(() {
      _hasRun = true;
      _tab = 'results';
      _selectedScenario = _selectedScenario ?? snapshot.defaultScenario;
    });
  }

  void _resetScenario() {
    HapticFeedback.selectionClick();
    setState(() {
      _hasRun = false;
      _tab = 'scenarios';
      _selectedScenario = null;
      _customMultiplier = null;
      _customVolatility = null;
    });
  }
}
