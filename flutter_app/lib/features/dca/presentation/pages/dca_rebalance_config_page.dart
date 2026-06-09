import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
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
import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';

part 'dca_rebalance_config_page_part_01.dart';
part 'dca_rebalance_config_page_part_02.dart';
part 'dca_rebalance_config_page_part_03.dart';

class DCARebalanceConfig extends ConsumerStatefulWidget {
  const DCARebalanceConfig({super.key, this.shellRenderMode});

  static const contentKey = Key('sc170_rebalance_content');
  static const addTargetKey = Key('sc170_add_target');
  static const previewKey = Key('sc170_preview');
  static const saveKey = Key('sc170_save');
  static const previewSheetKey = Key('sc170_preview_sheet');
  static const confirmSaveKey = Key('sc170_confirm_save');
  static const advancedToggleKey = Key('sc170_advanced_toggle');

  static Key strategyKey(DcaRebalanceStrategy strategy) {
    return Key('sc170_strategy_${strategy.name}');
  }

  static Key targetSliderKey(String id) {
    return Key('sc170_target_slider_$id');
  }

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DCARebalanceConfig> createState() => _DCARebalanceConfigState();
}

class _DCARebalanceConfigState extends ConsumerState<DCARebalanceConfig> {
  late List<DcaRebalanceTarget> _targets;
  late DcaRebalanceStrategy _strategy;
  late DcaRebalanceFrequency _frequency;
  late double _driftThreshold;
  late double _minTradeAmountUsd;
  bool _autoExecute = false;
  bool _showAdvanced = false;
  bool _showPreview = false;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(dcaRebalanceConfigProvider);
    _initialize(snapshot);

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom +
        AppSpacing.x7;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-170 DCARebalanceConfig',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Auto-Rebalance',
            subtitle: 'Cân bằng · DCA',
            showBack: true,
            onBack: _close,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        key: DCARebalanceConfig.contentKey,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(bottom: bottomInset),
                        child: VitPageContent(
                          padding: VitContentPadding.relaxed,
                          customGap: AppSpacing.x5,
                          children: [
                            const _InfoBanner(),
                            _AllocationSummary(
                              targets: _targets,
                              totalPercent: _totalPercent,
                              onAdd: _addTarget,
                            ),
                            _TargetList(
                              targets: _targets,
                              onPercentChanged: _updateTargetPercent,
                              onToleranceChanged: _updateTargetTolerance,
                              onRemove: _removeTarget,
                            ),
                            _StrategySection(
                              options: snapshot.strategyOptions,
                              active: _strategy,
                              onChanged: (strategy) {
                                HapticFeedback.selectionClick();
                                setState(() => _strategy = strategy);
                              },
                            ),
                            if (_strategy == DcaRebalanceStrategy.threshold ||
                                _strategy == DcaRebalanceStrategy.hybrid)
                              _ThresholdCard(
                                value: _driftThreshold,
                                onChanged: (value) =>
                                    setState(() => _driftThreshold = value),
                              ),
                            if (_strategy == DcaRebalanceStrategy.periodic ||
                                _strategy == DcaRebalanceStrategy.hybrid)
                              _FrequencyCard(
                                options: snapshot.frequencyOptions,
                                active: _frequency,
                                onChanged: (frequency) {
                                  HapticFeedback.selectionClick();
                                  setState(() => _frequency = frequency);
                                },
                              ),
                            _AdvancedSettings(
                              expanded: _showAdvanced,
                              minTradeAmountUsd: _minTradeAmountUsd,
                              autoExecute: _autoExecute,
                              onToggleExpanded: () {
                                HapticFeedback.selectionClick();
                                setState(() => _showAdvanced = !_showAdvanced);
                              },
                              onMinTradeChanged: (value) =>
                                  setState(() => _minTradeAmountUsd = value),
                              onAutoExecuteChanged: (value) {
                                HapticFeedback.selectionClick();
                                setState(() => _autoExecute = value);
                              },
                            ),
                            _InlineRebalanceActions(
                              valid: _isValidTotal,
                              onPreview: _openPreview,
                              onSave: _openPreview,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_showPreview)
                      _PreviewSheet(
                        previews: _tradePreviews(snapshot.totalPortfolioUsd),
                        totalFeesUsd: _totalFeesUsd(snapshot.totalPortfolioUsd),
                        onClose: _closePreview,
                        onConfirm: _saveConfig,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _initialize(DcaRebalanceConfigSnapshot snapshot) {
    if (_initialized) return;
    _targets = List<DcaRebalanceTarget>.from(snapshot.targets);
    _strategy = snapshot.strategy;
    _frequency = snapshot.frequency;
    _driftThreshold = snapshot.driftThreshold;
    _minTradeAmountUsd = snapshot.minTradeAmountUsd.toDouble();
    _initialized = true;
  }

  double get _totalPercent {
    return _targets.fold<double>(
      0,
      (sum, target) => sum + target.targetPercent,
    );
  }

  bool get _isValidTotal => (_totalPercent - 100).abs() < 0.01;

  void _addTarget() {
    HapticFeedback.selectionClick();
    if (_targets.length >= 4) return;
    final nextId = 'target-extra-${_targets.length + 1}';
    final accent = _targets.length.isEven
        ? DcaRebalanceAccent.warning
        : DcaRebalanceAccent.accent;
    setState(() {
      _targets = [
        ..._targets,
        DcaRebalanceTarget(
          id: nextId,
          symbol: _targets.length.isEven ? 'BNB' : 'SOL',
          assetName: _targets.length.isEven ? 'BNB' : 'Solana',
          currentPercent: 0,
          targetPercent: 0,
          tolerance: 5,
          currentValueUsd: 0,
          unitPriceUsd: _targets.length.isEven ? 320 : 105,
          accent: accent,
        ),
      ];
    });
  }

  void _removeTarget(String id) {
    HapticFeedback.selectionClick();
    if (_targets.length <= 2) return;
    setState(() {
      _targets = _targets.where((target) => target.id != id).toList();
    });
  }

  void _updateTargetPercent(String id, double value) {
    setState(() {
      _targets = _targets
          .map(
            (target) => target.id == id
                ? target.copyWith(targetPercent: value.roundToDouble())
                : target,
          )
          .toList();
    });
  }

  void _updateTargetTolerance(String id, double value) {
    setState(() {
      _targets = _targets
          .map(
            (target) => target.id == id
                ? target.copyWith(tolerance: value.clamp(1, 20).toDouble())
                : target,
          )
          .toList();
    });
  }

  void _openPreview() {
    if (!_isValidTotal) return;
    HapticFeedback.selectionClick();
    setState(() => _showPreview = true);
  }

  void _closePreview() {
    HapticFeedback.selectionClick();
    setState(() => _showPreview = false);
  }

  void _saveConfig() {
    HapticFeedback.selectionClick();
    context.go(AppRoutePaths.dcaRebalanceDashboard);
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.dca);
  }

  List<DcaRebalanceTradePreview> _tradePreviews(int totalPortfolioUsd) {
    return _targets.map((target) {
      final targetValue = totalPortfolioUsd * target.targetPercent / 100;
      final diff = targetValue - target.currentValueUsd;
      final tradeAmount = diff.abs();
      final action = tradeAmount < _minTradeAmountUsd
          ? DcaRebalanceTradeAction.hold
          : diff > 0
          ? DcaRebalanceTradeAction.buy
          : DcaRebalanceTradeAction.sell;
      return DcaRebalanceTradePreview(
        symbol: target.symbol,
        action: action,
        currentPercent: target.currentPercent,
        targetPercent: target.targetPercent,
        tradeAmountUsd: tradeAmount,
        tradeQuantity: target.unitPriceUsd == 0
            ? 0
            : tradeAmount / target.unitPriceUsd,
      );
    }).toList();
  }

  double _totalFeesUsd(int totalPortfolioUsd) {
    return _tradePreviews(totalPortfolioUsd)
        .where((preview) => preview.action != DcaRebalanceTradeAction.hold)
        .fold<double>(
          0,
          (sum, preview) => sum + preview.tradeAmountUsd * 0.001,
        );
  }
}
