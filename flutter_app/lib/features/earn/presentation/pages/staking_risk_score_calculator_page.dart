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

part '../widgets/staking_risk_score_inputs.dart';
part '../widgets/staking_risk_score_results.dart';
part '../widgets/staking_risk_score_radar.dart';

class StakingRiskScoreCalculatorPage extends ConsumerStatefulWidget {
  const StakingRiskScoreCalculatorPage({super.key, this.shellRenderMode});

  static const formKey = Key('sc384_form');
  static const amountFieldKey = Key('sc384_amount_field');
  static const assetSelectorKey = Key('sc384_asset_selector');
  static const durationSelectorKey = Key('sc384_duration_selector');
  static const validatorSliderKey = Key('sc384_validator_slider');
  static const scoreKey = Key('sc384_score');
  static const radarKey = Key('sc384_radar');
  static const recommendationsKey = Key('sc384_recommendations');
  static const footerButtonKey = Key('sc384_footer_button');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingRiskScoreCalculatorPage> createState() =>
      _StakingRiskScoreCalculatorPageState();
}

class _StakingRiskScoreCalculatorPageState
    extends ConsumerState<StakingRiskScoreCalculatorPage> {
  late final TextEditingController _amountController;
  String _asset = 'ETH';
  String _duration = 'flexible';
  int _validators = 3;

  @override
  void initState() {
    super.initState();
    final snapshot = ref
        .read(stakingRiskScoreCalculatorRepositoryProvider)
        .getCalculator();
    _amountController = TextEditingController(
      text: snapshot.defaultAmountUsd.toStringAsFixed(0),
    );
    _asset = snapshot.defaultAsset;
    _duration = snapshot.defaultDuration;
    _validators = snapshot.defaultValidators;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingRiskScoreCalculatorRepositoryProvider)
        .getCalculator();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final navInset = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final scrollTailReserve = navInset + safeBottom + AppSpacing.x4;
    final riskScore = _riskScore;
    final riskColor = _riskColor(riskScore);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-384 StakingRiskScoreCalculatorPage',
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
                  padding: EdgeInsetsDirectional.only(
                    bottom: scrollTailReserve,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    gap: VitContentGap.tight,
                    children: [
                      _ScenarioInputs(
                        snapshot: snapshot,
                        amountController: _amountController,
                        asset: _asset,
                        duration: _duration,
                        validators: _validators,
                        onAmountChanged: (_) => setState(() {}),
                        onAssetChanged: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _asset = value);
                        },
                        onDurationChanged: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _duration = value);
                        },
                        onValidatorsChanged: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _validators = value);
                        },
                      ),
                      _RiskScoreCard(
                        score: riskScore,
                        label: _riskLabel(riskScore),
                        color: riskColor,
                        axes: _radarAxes,
                      ),
                      _RecommendationsSection(
                        recommendations: _activeRecommendations(snapshot),
                      ),
                      VitCtaButton(
                        key: StakingRiskScoreCalculatorPage.footerButtonKey,
                        height: AppSpacing.buttonStandard,
                        onPressed: () {},
                        child: Text(snapshot.proceedLabel),
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

  double get _amount =>
      double.tryParse(_amountController.text.replaceAll(',', '').trim()) ?? 0;

  int get _riskScore {
    var score = 0;
    if (_amount > 50000) {
      score += 20;
    } else if (_amount > 10000) {
      score += 10;
    }

    if (_duration == 'fixed-180') {
      score += 15;
    } else if (_duration == 'fixed-90') {
      score += 10;
    }

    if (_asset == 'SOL') {
      score += 15;
    } else if (_asset == 'ETH') {
      score += 5;
    }

    if (_validators < 3) score += 20;
    return score.clamp(0, 100);
  }

  List<_RiskRadarAxis> get _radarAxes {
    return [
      _RiskRadarAxis(
        label: 'Amount',
        value: _amount > 50000 ? 80 : (_amount > 10000 ? 40 : 20),
      ),
      _RiskRadarAxis(
        label: 'Duration',
        value: _duration == 'fixed-180'
            ? 75
            : (_duration == 'fixed-90' ? 50 : 25),
      ),
      _RiskRadarAxis(
        label: 'Asset Volatility',
        value: _asset == 'SOL' ? 75 : (_asset == 'ETH' ? 45 : 20),
      ),
      _RiskRadarAxis(
        label: 'Diversification',
        value: _validators < 3 ? 80 : (_validators < 5 ? 40 : 20),
      ),
      const _RiskRadarAxis(label: 'Market Risk', value: 45),
    ];
  }

  String _riskLabel(int score) {
    if (score < 25) return 'Low Risk';
    if (score < 50) return 'Moderate Risk';
    if (score < 75) return 'High Risk';
    return 'Critical Risk';
  }

  Color _riskColor(int score) {
    if (score < 25) return AppColors.buy;
    if (score < 75) return AppColors.warn;
    return AppColors.sell;
  }

  List<StakingRiskScoreRecommendationDraft> _activeRecommendations(
    StakingRiskScoreCalculatorSnapshot snapshot,
  ) {
    return snapshot.recommendations
        .where((recommendation) {
          return switch (recommendation.trigger) {
            'reduce-risk' => _riskScore >= 50,
            'large-position' => _amount > 50000,
            'balanced' => _riskScore < 25,
            _ => false,
          };
        })
        .toList(growable: false);
  }
}
