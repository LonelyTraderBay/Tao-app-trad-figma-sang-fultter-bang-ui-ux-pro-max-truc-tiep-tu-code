import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/dca_repository.dart';

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
    final snapshot = ref.watch(dcaRepositoryProvider).getRebalanceConfig();
    _initialize(snapshot);

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final stickyBottom =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final bottomInset = stickyBottom + AppSpacing.ctaHeight + AppSpacing.x7;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-170 DCARebalanceConfig',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: 'Auto-Rebalance',
              subtitle: 'Cân bằng · DCA',
              showBack: true,
              onBack: _close,
            ),
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
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 60,
                    right: 60,
                    bottom: stickyBottom,
                    child: _StickyActions(
                      valid: _isValidTotal,
                      onPreview: _openPreview,
                      onSave: _openPreview,
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

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.contentPad),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _AccentIcon(icon: Icons.verified_user_outlined),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tự động cân bằng danh mục',
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Duy trì tỷ lệ phân bổ tài sản theo mục tiêu. Hệ thống tự động mua/bán khi danh mục lệch khỏi ngưỡng.',
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
}

class _AllocationSummary extends StatelessWidget {
  const _AllocationSummary({
    required this.targets,
    required this.totalPercent,
    required this.onAdd,
  });

  final List<DcaRebalanceTarget> targets;
  final double totalPercent;
  final VoidCallback onAdd;

  bool get _valid => (totalPercent - 100).abs() < 0.01;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.contentPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(
            icon: Icons.bar_chart_rounded,
            title: 'Phân bổ mục tiêu',
            trailing: _PillButton(
              key: DCARebalanceConfig.addTargetKey,
              icon: Icons.add_rounded,
              label: 'Thêm',
              onTap: onAdd,
              enabled: targets.length < 4,
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              SizedBox(
                width: 132,
                height: 132,
                child: CustomPaint(
                  painter: _DonutPainter(targets: targets),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${totalPercent.toStringAsFixed(0)}%',
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: AppColors.text1,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          'Tổng phân bổ',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x5),
              Expanded(
                child: Column(
                  children: targets
                      .map(
                        (target) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.x3),
                          child: _LegendRow(target: target),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Container(
            decoration: BoxDecoration(
              color: _valid ? AppColors.buy10 : AppColors.sell10,
              borderRadius: AppRadii.inputRadius,
              border: Border.all(
                color: _valid ? AppColors.buy20 : AppColors.sell20,
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x4,
              vertical: AppSpacing.x3,
            ),
            child: Row(
              children: [
                Icon(
                  _valid
                      ? Icons.check_circle_outline_rounded
                      : Icons.error_outline_rounded,
                  color: _valid ? AppColors.buy : AppColors.sell,
                  size: 18,
                ),
                const SizedBox(width: AppSpacing.x3),
                Text(
                  'Tổng: ${totalPercent.toStringAsFixed(0)}%',
                  style: AppTextStyles.caption.copyWith(
                    color: _valid ? AppColors.buy : AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _valid
                            ? 'Hợp lệ - sẵn sàng lưu'
                            : 'Tổng phải bằng 100%',
                        style: AppTextStyles.micro.copyWith(
                          color: _valid ? AppColors.buy : AppColors.text3,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TargetList extends StatelessWidget {
  const _TargetList({
    required this.targets,
    required this.onPercentChanged,
    required this.onToleranceChanged,
    required this.onRemove,
  });

  final List<DcaRebalanceTarget> targets;
  final void Function(String id, double value) onPercentChanged;
  final void Function(String id, double value) onToleranceChanged;
  final void Function(String id) onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: targets
          .map(
            (target) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x4),
              child: _TargetCard(
                target: target,
                canRemove: targets.length > 2,
                onPercentChanged: (value) => onPercentChanged(target.id, value),
                onToleranceChanged: (value) =>
                    onToleranceChanged(target.id, value),
                onRemove: () => onRemove(target.id),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _TargetCard extends StatelessWidget {
  const _TargetCard({
    required this.target,
    required this.canRemove,
    required this.onPercentChanged,
    required this.onToleranceChanged,
    required this.onRemove,
  });

  final DcaRebalanceTarget target;
  final bool canRemove;
  final ValueChanged<double> onPercentChanged;
  final ValueChanged<double> onToleranceChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(target.accent);
    return VitCard(
      radius: VitCardRadius.lg,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            height: AppSpacing.x1,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadii.lg),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.contentPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    _CoinBadge(symbol: target.symbol, accent: accent),
                    const SizedBox(width: AppSpacing.x4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                target.symbol,
                                style: AppTextStyles.baseMedium.copyWith(
                                  color: AppColors.text1,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.x2),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.text3,
                                size: 18,
                              ),
                            ],
                          ),
                          Text(
                            target.assetName,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      target.targetPercent.toStringAsFixed(0),
                      style: AppTextStyles.pageTitle.copyWith(color: accent),
                    ),
                    Text(
                      '%',
                      style: AppTextStyles.base.copyWith(
                        color: accent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    if (canRemove) ...[
                      const SizedBox(width: AppSpacing.x3),
                      _IconBadgeButton(
                        icon: Icons.delete_outline_rounded,
                        onTap: onRemove,
                        color: AppColors.sell,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.x5),
                Text(
                  'Tỷ lệ mục tiêu',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
                _TokenSlider(
                  key: DCARebalanceConfig.targetSliderKey(target.id),
                  value: target.targetPercent,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  accent: accent,
                  onChanged: onPercentChanged,
                ),
                const SizedBox(height: AppSpacing.x3),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    borderRadius: AppRadii.inputRadius,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x4,
                    vertical: AppSpacing.x3,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Dung sai',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      const Icon(
                        Icons.help_outline_rounded,
                        size: 13,
                        color: AppColors.text3,
                      ),
                      const Spacer(),
                      _IconBadgeButton(
                        icon: Icons.remove_rounded,
                        onTap: () => onToleranceChanged(target.tolerance - 1),
                        color: AppColors.text1,
                        neutral: true,
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Text(
                        '±${target.tolerance.toStringAsFixed(0)}%',
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      _IconBadgeButton(
                        icon: Icons.add_rounded,
                        onTap: () => onToleranceChanged(target.tolerance + 1),
                        color: AppColors.text1,
                        neutral: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StrategySection extends StatelessWidget {
  const _StrategySection({
    required this.options,
    required this.active,
    required this.onChanged,
  });

  final List<DcaRebalanceStrategyOption> options;
  final DcaRebalanceStrategy active;
  final ValueChanged<DcaRebalanceStrategy> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(
          icon: Icons.track_changes_rounded,
          title: 'Chiến lược',
        ),
        const SizedBox(height: AppSpacing.x4),
        ...options.map(
          (option) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.x3),
            child: _StrategyOptionTile(
              option: option,
              selected: active == option.strategy,
              onTap: () => onChanged(option.strategy),
            ),
          ),
        ),
      ],
    );
  }
}

class _StrategyOptionTile extends StatelessWidget {
  const _StrategyOptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final DcaRebalanceStrategyOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadii.lgRadius,
      child: InkWell(
        key: DCARebalanceConfig.strategyKey(option.strategy),
        onTap: onTap,
        borderRadius: AppRadii.lgRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            color: selected ? AppColors.accent08 : AppColors.surface,
            borderRadius: AppRadii.lgRadius,
            border: Border.all(
              color: selected ? AppColors.accent30 : AppColors.cardBorder,
              width: selected ? 2 : 1,
            ),
            boxShadow: selected
                ? [
                    const BoxShadow(
                      color: AppColors.accent10,
                      blurRadius: 14,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          padding: const EdgeInsets.all(AppSpacing.contentPad),
          child: Row(
            children: [
              _AccentIcon(
                icon: _strategyIcon(option.icon),
                color: selected ? AppColors.accent : AppColors.text3,
                muted: !selected,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: AppTextStyles.base.copyWith(
                        color: selected ? AppColors.accent : AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      option.subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: AppSpacing.x5,
                height: AppSpacing.x5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? AppColors.accent : AppColors.borderSolid,
                    width: 2,
                  ),
                ),
                child: selected
                    ? Center(
                        child: Container(
                          width: AppSpacing.x3,
                          height: AppSpacing.x3,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.accent,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThresholdCard extends StatelessWidget {
  const _ThresholdCard({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.contentPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(icon: Icons.tune_rounded, title: 'Ngưỡng drift'),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Text(
                '${value.toStringAsFixed(0)}%',
                style: AppTextStyles.pageTitle.copyWith(
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              VitStatusPill(
                label: _driftLabel(value),
                status: VitStatusPillStatus.purple,
                size: VitStatusPillSize.sm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Trigger khi drift > ${value.toStringAsFixed(0)}%',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          _TokenSlider(
            value: value,
            min: 1,
            max: 50,
            divisions: 49,
            accent: AppColors.accent,
            onChanged: onChanged,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_FinePrint('1% Chặt chẽ'), _FinePrint('50% Linh hoạt')],
          ),
        ],
      ),
    );
  }
}

class _FrequencyCard extends StatelessWidget {
  const _FrequencyCard({
    required this.options,
    required this.active,
    required this.onChanged,
  });

  final List<DcaRebalanceFrequencyOption> options;
  final DcaRebalanceFrequency active;
  final ValueChanged<DcaRebalanceFrequency> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.contentPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(
            icon: Icons.calendar_month_rounded,
            title: 'Tần suất',
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: options
                .map(
                  (option) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.x1,
                      ),
                      child: _FrequencyOptionTile(
                        option: option,
                        selected: active == option.frequency,
                        onTap: () => onChanged(option.frequency),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _FrequencyOptionTile extends StatelessWidget {
  const _FrequencyOptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final DcaRebalanceFrequencyOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            color: selected ? AppColors.accent10 : AppColors.surface2,
            borderRadius: AppRadii.inputRadius,
            border: Border.all(
              color: selected ? AppColors.accent : Colors.transparent,
              width: 2,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x2,
            vertical: AppSpacing.x4,
          ),
          child: Column(
            children: [
              Text(
                option.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: selected ? AppColors.accent : AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                option.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdvancedSettings extends StatelessWidget {
  const _AdvancedSettings({
    required this.expanded,
    required this.minTradeAmountUsd,
    required this.autoExecute,
    required this.onToggleExpanded,
    required this.onMinTradeChanged,
    required this.onAutoExecuteChanged,
  });

  final bool expanded;
  final double minTradeAmountUsd;
  final bool autoExecute;
  final VoidCallback onToggleExpanded;
  final ValueChanged<double> onMinTradeChanged;
  final ValueChanged<bool> onAutoExecuteChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            key: DCARebalanceConfig.advancedToggleKey,
            onTap: onToggleExpanded,
            borderRadius: AppRadii.inputRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
              child: Row(
                children: [
                  const Icon(
                    Icons.settings_suggest_outlined,
                    color: AppColors.text3,
                    size: 16,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Text(
                      'Cài đặt nâng cao',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: expanded ? .5 : 0,
                    duration: const Duration(milliseconds: 160),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.text3,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 180),
          crossFadeState: expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            children: [
              VitCard(
                radius: VitCardRadius.lg,
                padding: const EdgeInsets.all(AppSpacing.contentPad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Giao dịch tối thiểu',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                              fontWeight: AppTextStyles.medium,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface2,
                            borderRadius: AppRadii.smRadius,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.x4,
                            vertical: AppSpacing.x2,
                          ),
                          child: Text(
                            '\$${minTradeAmountUsd.toStringAsFixed(0)}',
                            style: AppTextStyles.baseMedium.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    _TokenSlider(
                      value: minTradeAmountUsd,
                      min: 10,
                      max: 500,
                      divisions: 49,
                      accent: AppModuleAccents.trade,
                      onChanged: onMinTradeChanged,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [_FinePrint('\$10'), _FinePrint('\$500')],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              VitCard(
                radius: VitCardRadius.lg,
                padding: const EdgeInsets.all(AppSpacing.contentPad),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _AccentIcon(
                          icon: Icons.flash_on_rounded,
                          color: autoExecute ? AppColors.buy : AppColors.text3,
                          muted: !autoExecute,
                        ),
                        const SizedBox(width: AppSpacing.x4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tự động thực thi',
                                style: AppTextStyles.base.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.x1),
                              Text(
                                'Rebalance tự động không cần duyệt',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _TogglePill(
                          value: autoExecute,
                          onChanged: onAutoExecuteChanged,
                        ),
                      ],
                    ),
                    if (autoExecute) ...[
                      const SizedBox(height: AppSpacing.x4),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.warningBg,
                          borderRadius: AppRadii.inputRadius,
                          border: Border.all(color: AppColors.warningBorder),
                        ),
                        padding: const EdgeInsets.all(AppSpacing.x4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: AppColors.warn,
                              size: 16,
                            ),
                            const SizedBox(width: AppSpacing.x3),
                            Expanded(
                              child: Text(
                                'Hệ thống sẽ tự động thực hiện giao dịch khi danh mục lệch. Bạn có thể tắt bất kỳ lúc nào.',
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.warningText,
                                  height: 1.45,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StickyActions extends StatelessWidget {
  const _StickyActions({
    required this.valid,
    required this.onPreview,
    required this.onSave,
  });

  final bool valid;
  final VoidCallback onPreview;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            key: DCARebalanceConfig.previewKey,
            onPressed: valid ? onPreview : null,
            fullWidth: true,
            leading: const Icon(Icons.visibility_outlined),
            child: const Text('Xem trước'),
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: VitCtaButton(
            key: DCARebalanceConfig.saveKey,
            onPressed: valid ? onSave : null,
            fullWidth: true,
            leading: const Icon(Icons.save_outlined),
            child: const Text('Lưu cấu hình'),
          ),
        ),
      ],
    );
  }
}

class _PreviewSheet extends StatelessWidget {
  const _PreviewSheet({
    required this.previews,
    required this.totalFeesUsd,
    required this.onClose,
    required this.onConfirm,
  });

  final List<DcaRebalanceTradePreview> previews;
  final double totalFeesUsd;
  final VoidCallback onClose;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: AppColors.bg.withValues(alpha: .86),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentPad,
              0,
              AppSpacing.contentPad,
              DeviceMetrics.nativeBottomChrome + AppSpacing.x5,
            ),
            child: VitCard(
              key: DCARebalanceConfig.previewSheetKey,
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.contentPad),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const _AccentIcon(icon: Icons.preview_outlined),
                        const SizedBox(width: AppSpacing.x4),
                        Expanded(
                          child: Text(
                            'Preview Simulation',
                            style: AppTextStyles.baseMedium.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        _IconBadgeButton(
                          icon: Icons.close_rounded,
                          onTap: onClose,
                          color: AppColors.text2,
                          neutral: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x5),
                    ...previews.map(
                      (preview) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.x3),
                        child: _PreviewRow(preview: preview),
                      ),
                    ),
                    const Divider(color: AppColors.borderSolid),
                    Row(
                      children: [
                        Text(
                          'Phí ước tính',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '\$${totalFeesUsd.toStringAsFixed(2)}',
                          style: AppTextStyles.baseMedium.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x5),
                    VitCtaButton(
                      key: DCARebalanceConfig.confirmSaveKey,
                      onPressed: onConfirm,
                      leading: const Icon(Icons.check_rounded),
                      child: const Text('Xác nhận lưu'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({required this.preview});

  final DcaRebalanceTradePreview preview;

  @override
  Widget build(BuildContext context) {
    final color = switch (preview.action) {
      DcaRebalanceTradeAction.buy => AppColors.buy,
      DcaRebalanceTradeAction.sell => AppColors.sell,
      DcaRebalanceTradeAction.hold => AppColors.text3,
    };
    final label = switch (preview.action) {
      DcaRebalanceTradeAction.buy => 'Mua',
      DcaRebalanceTradeAction.sell => 'Bán',
      DcaRebalanceTradeAction.hold => 'Giữ',
    };
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.inputRadius,
      ),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Text(
            preview.symbol,
            style: AppTextStyles.base.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const Spacer(),
          Text(
            '${preview.currentPercent.toStringAsFixed(0)}% → ${preview.targetPercent.toStringAsFixed(0)}%',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(width: AppSpacing.x4),
          Text(
            '$label \$${preview.tradeAmountUsd.toStringAsFixed(0)}',
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _AccentIcon(icon: icon, color: AppColors.accent),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

class _AccentIcon extends StatelessWidget {
  const _AccentIcon({
    required this.icon,
    this.color = AppModuleAccents.trade,
    this.muted = false,
  });

  final IconData icon;
  final Color color;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.iconLg,
      height: AppSpacing.iconLg,
      decoration: BoxDecoration(
        color: muted ? AppColors.surface2 : color.withValues(alpha: .15),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: AppRadii.inputRadius,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: enabled ? 1 : .45,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.accent10,
              borderRadius: AppRadii.inputRadius,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x4,
              vertical: AppSpacing.x3,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: AppColors.accent, size: 16),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.accent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.target});

  final DcaRebalanceTarget target;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(target.accent);
    return Row(
      children: [
        Container(
          width: AppSpacing.x4,
          height: AppSpacing.x4,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            target.symbol,
            style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
          ),
        ),
        Text(
          '${target.targetPercent.toStringAsFixed(0)}%',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _CoinBadge extends StatelessWidget {
  const _CoinBadge({required this.symbol, required this.accent});

  final String symbol;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: accent.withValues(alpha: .12),
        border: Border.all(color: accent.withValues(alpha: .35)),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x2),
          child: Text(
            symbol.length > 3 ? symbol.substring(0, 3) : symbol,
            style: AppTextStyles.caption.copyWith(
              color: accent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBadgeButton extends StatelessWidget {
  const _IconBadgeButton({
    required this.icon,
    required this.onTap,
    required this.color,
    this.neutral = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final bool neutral;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: AppSpacing.iconLg,
          height: AppSpacing.iconLg,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: neutral ? AppColors.surface : color.withValues(alpha: .12),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  const _TogglePill({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      checked: value,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 52,
          height: 30,
          decoration: BoxDecoration(
            color: value ? AppColors.buy : AppColors.borderSolid,
            borderRadius: AppRadii.xlRadius,
          ),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          padding: const EdgeInsets.all(AppSpacing.x1),
          child: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.text1,
            ),
          ),
        ),
      ),
    );
  }
}

class _TokenSlider extends StatelessWidget {
  const _TokenSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.accent,
    required this.onChanged,
  });

  final double value;
  final double min;
  final double max;
  final int divisions;
  final Color accent;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: AppSpacing.x1,
        activeTrackColor: accent,
        inactiveTrackColor: AppColors.surface3,
        thumbColor: AppColors.text1,
        overlayColor: accent.withValues(alpha: .12),
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: AppSpacing.x3,
        ),
        overlayShape: const RoundSliderOverlayShape(
          overlayRadius: AppSpacing.x5,
        ),
      ),
      child: Slider(
        value: value.clamp(min, max).toDouble(),
        min: min,
        max: max,
        divisions: divisions,
        onChanged: onChanged,
      ),
    );
  }
}

class _FinePrint extends StatelessWidget {
  const _FinePrint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
    );
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({required this.targets});

  final List<DcaRebalanceTarget> targets;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = AppSpacing.x5;
    final radius = (math.min(size.width, size.height) - stroke) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = AppColors.surface3;
    canvas.drawCircle(center, radius, basePaint);

    var start = -math.pi / 2;
    final total = targets.fold<double>(
      0,
      (sum, target) => sum + target.targetPercent,
    );
    if (total <= 0) return;
    for (final target in targets) {
      final sweep = math.pi * 2 * (target.targetPercent / total);
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = _accentColor(target.accent);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        math.max(0, sweep - .05),
        false,
        paint,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.targets != targets;
  }
}

Color _accentColor(DcaRebalanceAccent accent) {
  return switch (accent) {
    DcaRebalanceAccent.primary => AppColors.primary,
    DcaRebalanceAccent.accent => AppColors.accent,
    DcaRebalanceAccent.success => AppColors.buy,
    DcaRebalanceAccent.warning => AppColors.warn,
  };
}

IconData _strategyIcon(DcaRebalanceOptionIcon icon) {
  return switch (icon) {
    DcaRebalanceOptionIcon.zap => Icons.flash_on_rounded,
    DcaRebalanceOptionIcon.clock => Icons.schedule_rounded,
    DcaRebalanceOptionIcon.combine => Icons.account_tree_rounded,
  };
}

String _driftLabel(double value) {
  if (value <= 3) return 'Rất chặt';
  if (value <= 8) return 'Chặt';
  if (value <= 15) return 'Trung bình';
  if (value <= 30) return 'Lỏng';
  return 'Rất lỏng';
}
