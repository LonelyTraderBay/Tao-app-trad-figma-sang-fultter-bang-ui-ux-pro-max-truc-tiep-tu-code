import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/earn_repository.dart';

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
    final snapshot = const MockStakingRiskScoreCalculatorRepository()
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
    final footerBottomInset = navInset + safeBottom;
    final bottomInset = navInset + safeBottom + AppSpacing.x7 + AppSpacing.x7;
    final riskScore = _riskScore;
    final riskColor = _riskColor(riskScore);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-384 StakingRiskScoreCalculatorPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
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
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: footerBottomInset),
              child: VitStickyFooter(
                backgroundColor: AppColors.bg,
                child: VitCtaButton(
                  key: StakingRiskScoreCalculatorPage.footerButtonKey,
                  height: AppSpacing.ctaHeight,
                  onPressed: () {},
                  child: Text(snapshot.proceedLabel),
                ),
              ),
            ),
          ],
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

class _ScenarioInputs extends StatelessWidget {
  const _ScenarioInputs({
    required this.snapshot,
    required this.amountController,
    required this.asset,
    required this.duration,
    required this.validators,
    required this.onAmountChanged,
    required this.onAssetChanged,
    required this.onDurationChanged,
    required this.onValidatorsChanged,
  });

  final StakingRiskScoreCalculatorSnapshot snapshot;
  final TextEditingController amountController;
  final String asset;
  final String duration;
  final int validators;
  final ValueChanged<String> onAmountChanged;
  final ValueChanged<String> onAssetChanged;
  final ValueChanged<String> onDurationChanged;
  final ValueChanged<int> onValidatorsChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingRiskScoreCalculatorPage.formKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Scenario Inputs', style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.x4),
          _FieldLabel(
            label: 'Stake Amount (USD)',
            child: _AmountInput(
              controller: amountController,
              onChanged: onAmountChanged,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          _FieldLabel(
            label: 'Asset',
            child: _RiskDropdown(
              fieldKey: StakingRiskScoreCalculatorPage.assetSelectorKey,
              value: asset,
              options: snapshot.assetOptions,
              onChanged: onAssetChanged,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          _FieldLabel(
            label: 'Lock-up Period',
            child: _RiskDropdown(
              fieldKey: StakingRiskScoreCalculatorPage.durationSelectorKey,
              value: duration,
              options: snapshot.durationOptions,
              onChanged: onDurationChanged,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          _ValidatorSlider(
            validators: validators,
            onChanged: onValidatorsChanged,
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x2),
        child,
      ],
    );
  }
}

class _AmountInput extends StatelessWidget {
  const _AmountInput({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      child: TextField(
        key: StakingRiskScoreCalculatorPage.amountFieldKey,
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        cursorColor: AppColors.primary,
        onChanged: onChanged,
        style: AppTextStyles.baseMedium.copyWith(
          fontFeatures: AppTextStyles.tabularFigures,
        ),
        decoration: InputDecoration(
          hintText: '0',
          hintStyle: AppTextStyles.baseMedium.copyWith(color: AppColors.text3),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _RiskDropdown extends StatelessWidget {
  const _RiskDropdown({
    required this.fieldKey,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final Key fieldKey;
  final String value;
  final List<StakingRiskScoreOptionDraft> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = options.firstWhere(
      (option) => option.value == value,
      orElse: () => options.first,
    );
    return VitCard(
      key: fieldKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      onTap: () => _showOptions(context),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x4,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              selected.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.baseMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.text2,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      barrierColor: AppColors.bg.withValues(alpha: 0.72),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentPad,
              AppSpacing.x5,
              AppSpacing.contentPad,
              AppSpacing.x7 + AppSpacing.x5,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final option in options)
                  _RiskOptionRow(
                    option: option,
                    selected: option.value == value,
                    onTap: () {
                      Navigator.of(context).pop();
                      onChanged(option.value);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RiskOptionRow extends StatelessWidget {
  const _RiskOptionRow({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final StakingRiskScoreOptionDraft option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
      child: VitCard(
        variant: VitCardVariant.inner,
        borderColor: selected ? AppColors.primary30 : null,
        onTap: onTap,
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option.label,
                style: AppTextStyles.body.copyWith(
                  fontWeight: selected
                      ? AppTextStyles.bold
                      : AppTextStyles.normal,
                ),
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: AppSpacing.iconMd,
              ),
          ],
        ),
      ),
    );
  }
}

class _ValidatorSlider extends StatelessWidget {
  const _ValidatorSlider({required this.validators, required this.onChanged});

  final int validators;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Number of Validators: $validators',
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        Slider(
          key: StakingRiskScoreCalculatorPage.validatorSliderKey,
          min: 1,
          max: 10,
          divisions: 9,
          value: validators.toDouble(),
          activeColor: AppColors.primary,
          inactiveColor: AppColors.surface3,
          onChanged: (next) => onChanged(next.round()),
        ),
      ],
    );
  }
}

class _RiskScoreCard extends StatelessWidget {
  const _RiskScoreCard({
    required this.score,
    required this.label,
    required this.color,
    required this.axes,
  });

  final int score;
  final String label;
  final Color color;
  final List<_RiskRadarAxis> axes;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingRiskScoreCalculatorPage.scoreKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          Text(
            'Calculated Risk Score',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x3),
          Container(
            width: AppSpacing.buttonHero + AppSpacing.x6 + AppSpacing.x3,
            height: AppSpacing.buttonHero + AppSpacing.x6 + AppSpacing.x3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.12),
              border: Border.all(color: color, width: 4),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$score',
                  style: AppTextStyles.display.copyWith(
                    color: color,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                Text(
                  '/ 100',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x4,
              vertical: AppSpacing.x2,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber_rounded, color: color, size: 17),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  label,
                  style: AppTextStyles.body.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          SizedBox(
            key: StakingRiskScoreCalculatorPage.radarKey,
            height: 220,
            child: _RiskRadarChart(axes: axes, color: color),
          ),
        ],
      ),
    );
  }
}

class _RecommendationsSection extends StatelessWidget {
  const _RecommendationsSection({required this.recommendations});

  final List<StakingRiskScoreRecommendationDraft> recommendations;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingRiskScoreCalculatorPage.recommendationsKey,
      label: 'Recommendations',
      accentColor: AppColors.primarySoft,
      children: [
        for (final recommendation in recommendations)
          _RecommendationCard(recommendation: recommendation),
      ],
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.recommendation});

  final StakingRiskScoreRecommendationDraft recommendation;

  @override
  Widget build(BuildContext context) {
    final color = _recommendationColor(recommendation.tone);
    final icon = switch (recommendation.tone) {
      'success' => Icons.check_circle_outline_rounded,
      'warning' => Icons.error_outline_rounded,
      _ => Icons.lightbulb_outline_rounded,
    };
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: color.withValues(alpha: 0.28),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  recommendation.title,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  recommendation.body,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _recommendationColor(String tone) {
    return switch (tone) {
      'success' => AppColors.buy,
      'warning' => AppColors.warn,
      _ => AppColors.primarySoft,
    };
  }
}

final class _RiskRadarAxis {
  const _RiskRadarAxis({required this.label, required this.value});

  final String label;
  final double value;
}

class _RiskRadarChart extends StatelessWidget {
  const _RiskRadarChart({required this.axes, required this.color});

  final List<_RiskRadarAxis> axes;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _RiskRadarPainter(axes: axes, color: color),
          ),
        ),
        _RadarLabel(
          label: axes[0].label,
          left: 0,
          right: 0,
          top: 0,
          textAlign: TextAlign.center,
        ),
        _RadarLabel(
          label: axes[1].label,
          right: 0,
          top: 94,
          textAlign: TextAlign.right,
        ),
        _RadarLabel(
          label: axes[2].label,
          left: 0,
          bottom: 34,
          textAlign: TextAlign.left,
        ),
        _RadarLabel(
          label: axes[3].label,
          right: 0,
          bottom: 22,
          textAlign: TextAlign.right,
        ),
        _RadarLabel(
          label: axes[4].label,
          left: 0,
          top: 94,
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}

class _RadarLabel extends StatelessWidget {
  const _RadarLabel({
    required this.label,
    this.left,
    this.right,
    this.top,
    this.bottom,
    required this.textAlign,
  });

  final String label;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Text(
        label,
        maxLines: 2,
        textAlign: textAlign,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
    );
  }
}

class _RiskRadarPainter extends CustomPainter {
  const _RiskRadarPainter({required this.axes, required this.color});

  final List<_RiskRadarAxis> axes;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (axes.length < 3) return;
    final center = Offset(size.width / 2, size.height / 2 + AppSpacing.x2);
    final radius = math.min(size.width, size.height) * 0.32;
    final gridPaint = Paint()
      ..color = AppColors.borderSolid
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final axisPaint = Paint()
      ..color = AppColors.borderSolid
      ..strokeWidth = 1;

    for (var ring = 1; ring <= 4; ring++) {
      final ringPath = Path();
      final ringRadius = radius * ring / 4;
      for (var i = 0; i < axes.length; i++) {
        final point = _pointFor(center, ringRadius, i, axes.length);
        if (i == 0) {
          ringPath.moveTo(point.dx, point.dy);
        } else {
          ringPath.lineTo(point.dx, point.dy);
        }
      }
      ringPath.close();
      canvas.drawPath(ringPath, gridPaint);
    }

    for (var i = 0; i < axes.length; i++) {
      final end = _pointFor(center, radius, i, axes.length);
      canvas.drawLine(center, end, axisPaint);
    }

    final profilePath = Path();
    for (var i = 0; i < axes.length; i++) {
      final valueRadius = radius * (axes[i].value / 100).clamp(0, 1);
      final point = _pointFor(center, valueRadius, i, axes.length);
      if (i == 0) {
        profilePath.moveTo(point.dx, point.dy);
      } else {
        profilePath.lineTo(point.dx, point.dy);
      }
    }
    profilePath.close();

    canvas.drawPath(
      profilePath,
      Paint()
        ..color = color.withValues(alpha: 0.24)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      profilePath,
      Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );
  }

  Offset _pointFor(Offset center, double radius, int index, int count) {
    final angle = -math.pi / 2 + index * 2 * math.pi / count;
    return Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
  }

  @override
  bool shouldRepaint(covariant _RiskRadarPainter oldDelegate) {
    return oldDelegate.axes != axes || oldDelegate.color != color;
  }
}
