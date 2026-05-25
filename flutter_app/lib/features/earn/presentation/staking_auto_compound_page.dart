import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/earn_repository.dart';

class StakingAutoCompoundPage extends ConsumerStatefulWidget {
  const StakingAutoCompoundPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc363_info_banner');
  static const summaryKey = Key('sc363_summary_card');
  static const settingsKey = Key('sc363_settings_card');
  static const thresholdKey = Key('sc363_threshold_field');
  static const gasOptimizationKey = Key('sc363_gas_optimization');
  static const simulationKey = Key('sc363_simulation_card');
  static const principalKey = Key('sc363_principal_field');
  static const apyKey = Key('sc363_apy_field');
  static const monthsKey = Key('sc363_months_field');
  static const saveButtonKey = Key('sc363_save_button');
  static const successToastKey = Key('sc363_success_toast');
  static const footerKey = Key('sc363_footer_note');

  static Key frequencyKey(String id) => Key('sc363_frequency_$id');

  static Key positionKey(String id) => Key('sc363_position_$id');

  static Key toggleKey(String id) => Key('sc363_toggle_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingAutoCompoundPage> createState() =>
      _StakingAutoCompoundPageState();
}

class _StakingAutoCompoundPageState
    extends ConsumerState<StakingAutoCompoundPage> {
  late final TextEditingController _thresholdController;
  late final TextEditingController _principalController;
  late final TextEditingController _apyController;
  late final TextEditingController _monthsController;
  final Map<String, bool> _enabled = {};

  String _frequency = 'daily';
  bool _gasOptimization = true;
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _thresholdController = TextEditingController(text: '10');
    _principalController = TextEditingController(text: '1000');
    _apyController = TextEditingController(text: '7.5');
    _monthsController = TextEditingController(text: '12');
  }

  @override
  void dispose() {
    _thresholdController.dispose();
    _principalController.dispose();
    _apyController.dispose();
    _monthsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingAutoCompoundRepositoryProvider)
        .getAutoCompound();
    final positions = [
      for (final position in snapshot.positions) _resolved(position),
    ];
    final threshold = _parseDouble(_thresholdController.text, 10);
    final simulation = _buildSimulation();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-363 StakingAutoCompoundPage',
      child: Material(
        color: AppColors.bg,
        child: Stack(
          children: [
            Column(
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
                        _InfoBanner(snapshot: snapshot),
                        _SummaryCard(
                          positions: positions,
                          frequency: _frequency,
                          threshold: threshold,
                        ),
                        VitPageSection(
                          label: 'Cài đặt Auto-Compound',
                          accentColor: AppColors.primary,
                          children: [
                            _SettingsCard(
                              key: StakingAutoCompoundPage.settingsKey,
                              snapshot: snapshot,
                              frequency: _frequency,
                              thresholdController: _thresholdController,
                              gasOptimization: _gasOptimization,
                              onFrequencyChanged: (frequency) {
                                HapticFeedback.selectionClick();
                                setState(() => _frequency = frequency);
                              },
                              onThresholdChanged: (_) => setState(() {}),
                              onGasOptimizationChanged: () {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _gasOptimization = !_gasOptimization;
                                });
                              },
                            ),
                          ],
                        ),
                        VitPageSection(
                          label: 'Vị thế Auto-Compound',
                          accentColor: AppColors.primary,
                          children: [
                            for (final position in positions)
                              _PositionCard(
                                position: position,
                                frequency: _frequency,
                                onToggle: () => _toggle(position),
                              ),
                          ],
                        ),
                        VitPageSection(
                          label: 'Mô phỏng Lợi nhuận Kép',
                          accentColor: AppColors.primary,
                          children: [
                            _SimulationCard(
                              controllerPrincipal: _principalController,
                              controllerApy: _apyController,
                              controllerMonths: _monthsController,
                              simulation: simulation,
                              onChanged: (_) => setState(() {}),
                            ),
                          ],
                        ),
                        VitCtaButton(
                          key: StakingAutoCompoundPage.saveButtonKey,
                          variant: VitCtaButtonVariant.primary,
                          leading: const Icon(Icons.settings_outlined),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            setState(() => _showSuccess = true);
                          },
                          child: const Text('Lưu cài đặt'),
                        ),
                        _FooterNote(snapshot: snapshot),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_showSuccess)
              Positioned(
                left: AppSpacing.contentPad,
                right: AppSpacing.contentPad,
                top: MediaQuery.paddingOf(context).top + AppSpacing.x7,
                child: _SuccessToast(
                  onDismiss: () => setState(() => _showSuccess = false),
                ),
              ),
          ],
        ),
      ),
    );
  }

  StakingAutoCompoundPositionDraft _resolved(
    StakingAutoCompoundPositionDraft position,
  ) {
    return StakingAutoCompoundPositionDraft(
      id: position.id,
      product: position.product,
      asset: position.asset,
      amount: position.amount,
      autoCompound: _enabled[position.id] ?? position.autoCompound,
    );
  }

  void _toggle(StakingAutoCompoundPositionDraft position) {
    HapticFeedback.selectionClick();
    setState(() => _enabled[position.id] = !position.autoCompound);
  }

  _CompoundSimulation _buildSimulation() {
    final principal = _parseDouble(_principalController.text, 1000);
    final apy = _parseDouble(_apyController.text, 7.5);
    final months = _parseInt(_monthsController.text, 12).clamp(1, 36);
    final monthlyRate = apy / 100 / 12;
    final points = <StakingAutoCompoundPointDraft>[];

    for (var month = 0; month <= months; month++) {
      points.add(
        StakingAutoCompoundPointDraft(
          month: month,
          withCompound: principal * math.pow(1 + monthlyRate, month),
          withoutCompound: principal * (1 + monthlyRate * month),
        ),
      );
    }

    final last = points.last;
    final difference = last.withCompound - last.withoutCompound;
    final percentageGain = last.withoutCompound == 0
        ? 0.0
        : difference / last.withoutCompound * 100;

    return _CompoundSimulation(
      points: points,
      withCompound: last.withCompound,
      withoutCompound: last.withoutCompound,
      difference: difference,
      percentageGain: percentageGain,
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingAutoCompoundSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAutoCompoundPage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.autorenew_rounded,
            color: AppColors.buy,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.infoTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.positions,
    required this.frequency,
    required this.threshold,
  });

  final List<StakingAutoCompoundPositionDraft> positions;
  final String frequency;
  final double threshold;

  @override
  Widget build(BuildContext context) {
    final active = positions.where((position) => position.autoCompound).length;
    return VitCard(
      key: StakingAutoCompoundPage.summaryKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Auto-compound đang bật',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      '$active/${positions.length}',
                      style: AppTextStyles.heroNumber.copyWith(fontSize: 30),
                    ),
                    Text(
                      'positions',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: AppSpacing.buttonHero,
                height: AppSpacing.buttonHero,
                decoration: BoxDecoration(
                  color: AppColors.buy10,
                  borderRadius: AppRadii.xlRadius,
                  border: Border.all(color: AppColors.buy20, width: 3),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.autorenew_rounded,
                  color: AppColors.buy,
                  size: AppSpacing.iconLg,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _SummaryTile(
                  label: 'Tần suất',
                  value: _frequencyLabel(frequency),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _SummaryTile(
                  label: 'Ngưỡng tối thiểu',
                  value: _formatCurrency(threshold, compact: true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(value, style: AppTextStyles.baseMedium),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    super.key,
    required this.snapshot,
    required this.frequency,
    required this.thresholdController,
    required this.gasOptimization,
    required this.onFrequencyChanged,
    required this.onThresholdChanged,
    required this.onGasOptimizationChanged,
  });

  final StakingAutoCompoundSnapshot snapshot;
  final String frequency;
  final TextEditingController thresholdController;
  final bool gasOptimization;
  final ValueChanged<String> onFrequencyChanged;
  final ValueChanged<String> onThresholdChanged;
  final VoidCallback onGasOptimizationChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tần suất tái đầu tư',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              for (var i = 0; i < snapshot.frequencies.length; i++) ...[
                Expanded(
                  child: _FrequencyTile(
                    frequency: snapshot.frequencies[i],
                    selected: frequency == snapshot.frequencies[i].id,
                    onTap: () => onFrequencyChanged(snapshot.frequencies[i].id),
                  ),
                ),
                if (i != snapshot.frequencies.length - 1)
                  const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          VitInput(
            fieldKey: StakingAutoCompoundPage.thresholdKey,
            controller: thresholdController,
            label: 'Ngưỡng tối thiểu (USD)',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: onThresholdChanged,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Chỉ tái đầu tư khi phần thưởng >= ${_formatCurrency(_parseDouble(thresholdController.text, 10), compact: true)}',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x5),
          _GasOptimizationTile(
            enabled: gasOptimization,
            onTap: onGasOptimizationChanged,
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.primary20,
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primary,
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Gợi ý: ',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        TextSpan(
                          text: snapshot.suggestion,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ],
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

class _FrequencyTile extends StatelessWidget {
  const _FrequencyTile({
    required this.frequency,
    required this.selected,
    required this.onTap,
  });

  final StakingAutoCompoundFrequencyDraft frequency;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        key: StakingAutoCompoundPage.frequencyKey(frequency.id),
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(AppSpacing.x4),
          decoration: BoxDecoration(
            color: selected ? AppColors.buy10 : AppColors.surface2,
            borderRadius: AppRadii.inputRadius,
            border: Border.all(
              color: selected ? AppColors.buy : AppColors.borderSolid,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  frequency.label,
                  style: AppTextStyles.caption.copyWith(
                    color: selected ? AppColors.buy : AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  frequency.description,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GasOptimizationTile extends StatelessWidget {
  const _GasOptimizationTile({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        key: StakingAutoCompoundPage.gasOptimizationKey,
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: VitCard(
          variant: VitCardVariant.inner,
          radius: VitCardRadius.md,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            children: [
              _CheckBoxIndicator(checked: enabled),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tối ưu Gas Fee', style: AppTextStyles.baseMedium),
                    Text(
                      'Chỉ compound khi gas fee thấp (tiết kiệm ~30-50%)',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
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
}

class _PositionCard extends StatelessWidget {
  const _PositionCard({
    required this.position,
    required this.frequency,
    required this.onToggle,
  });

  final StakingAutoCompoundPositionDraft position;
  final String frequency;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAutoCompoundPage.positionKey(position.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(position.product, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${_formatAmount(position.amount)} ${position.asset}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _ToggleSwitch(
                key: StakingAutoCompoundPage.toggleKey(position.id),
                enabled: position.autoCompound,
                onTap: onToggle,
              ),
            ],
          ),
          if (position.autoCompound) ...[
            const SizedBox(height: AppSpacing.x3),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x3,
              ),
              decoration: const BoxDecoration(
                color: AppColors.buy10,
                borderRadius: AppRadii.inputRadius,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.bolt_rounded,
                    color: AppColors.buy,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      'Auto-compound đang bật • ${_frequencyLabel(frequency)}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.buy,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SimulationCard extends StatelessWidget {
  const _SimulationCard({
    required this.controllerPrincipal,
    required this.controllerApy,
    required this.controllerMonths,
    required this.simulation,
    required this.onChanged,
  });

  final TextEditingController controllerPrincipal;
  final TextEditingController controllerApy;
  final TextEditingController controllerMonths;
  final _CompoundSimulation simulation;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAutoCompoundPage.simulationKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _MiniInput(
                  fieldKey: StakingAutoCompoundPage.principalKey,
                  label: 'Số lượng gốc',
                  controller: controllerPrincipal,
                  onChanged: onChanged,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniInput(
                  fieldKey: StakingAutoCompoundPage.apyKey,
                  label: 'APY (%)',
                  controller: controllerApy,
                  onChanged: onChanged,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniInput(
                  fieldKey: StakingAutoCompoundPage.monthsKey,
                  label: 'Tháng',
                  controller: controllerMonths,
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          SizedBox(
            height: 190,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _CompoundChartPainter(points: simulation.points),
                  ),
                ),
                const Positioned(
                  left: AppSpacing.x6,
                  right: AppSpacing.x4,
                  bottom: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _AxisLabel('0'),
                      _AxisLabel('1'),
                      _AxisLabel('2'),
                      _AxisLabel('3'),
                      _AxisLabel('4'),
                      _AxisLabel('5'),
                      _AxisLabel('6'),
                      _AxisLabel('7'),
                      _AxisLabel('8'),
                      _AxisLabel('9'),
                      _AxisLabel('10'),
                      _AxisLabel('11'),
                      _AxisLabel('12'),
                    ],
                  ),
                ),
                Positioned(
                  left: AppSpacing.x6,
                  right: AppSpacing.x4,
                  bottom: AppSpacing.x5,
                  child: Center(
                    child: Text(
                      'Tháng',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _ResultCard(
                  label: 'Có compound',
                  value: _formatCurrency(simulation.withCompound),
                  color: AppColors.buy,
                  tone: AppColors.buy10,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _ResultCard(
                  label: 'Không compound',
                  value: _formatCurrency(simulation.withoutCompound),
                  color: AppColors.sell,
                  tone: AppColors.sell10,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.md,
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Column(
              children: [
                Text(
                  'Lợi thế compound',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  '+${_formatCurrency(simulation.difference)}',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.buy,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '(+${simulation.percentageGain.toStringAsFixed(2)}% cao hơn)',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniInput extends StatelessWidget {
  const _MiniInput({
    required this.fieldKey,
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  final Key fieldKey;
  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: AppRadii.inputRadius,
            border: Border.all(color: AppColors.borderSolid),
          ),
          child: TextField(
            key: fieldKey,
            controller: controller,
            textAlign: TextAlign.center,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            cursorColor: AppColors.primary,
            onChanged: onChanged,
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: AppSpacing.x3),
            ),
          ),
        ),
      ],
    );
  }
}

class _AxisLabel extends StatelessWidget {
  const _AxisLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.micro.copyWith(color: AppColors.text3, fontSize: 9),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.label,
    required this.value,
    required this.color,
    required this.tone,
  });

  final String label;
  final String value;
  final Color color;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(color: tone, borderRadius: AppRadii.cardRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppSpacing.x4,
                height: 2,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: AppRadii.xsRadius,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.baseMedium.copyWith(
                color: color,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.snapshot});

  final StakingAutoCompoundSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAutoCompoundPage.footerKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Text(
        snapshot.footerNote,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
    );
  }
}

class _SuccessToast extends StatelessWidget {
  const _SuccessToast({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAutoCompoundPage.successToastKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.buy,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Đã lưu cài đặt auto-compound',
              style: AppTextStyles.caption.copyWith(color: AppColors.text1),
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            icon: const Icon(
              Icons.close_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconMd,
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckBoxIndicator extends StatelessWidget {
  const _CheckBoxIndicator({required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: AppSpacing.x5,
      height: AppSpacing.x5,
      decoration: BoxDecoration(
        color: checked ? AppColors.buy : Colors.transparent,
        borderRadius: AppRadii.smRadius,
        border: Border.all(
          color: checked ? AppColors.buy : AppColors.borderSolid,
          width: 1.5,
        ),
      ),
      child: checked
          ? const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: AppSpacing.iconSm,
            )
          : null,
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({super.key, required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: enabled,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 48,
          height: 28,
          padding: const EdgeInsets.all(AppSpacing.x1),
          decoration: BoxDecoration(
            color: enabled ? AppColors.buy : AppColors.surface3,
            borderRadius: AppRadii.xlRadius,
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: AppSpacing.x5,
              height: AppSpacing.x5,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CompoundChartPainter extends CustomPainter {
  const _CompoundChartPainter({required this.points});

  final List<StakingAutoCompoundPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final chart = Rect.fromLTWH(
      AppSpacing.x6,
      AppSpacing.x2,
      size.width - AppSpacing.x7,
      size.height - AppSpacing.x6,
    );
    final values = [
      for (final point in points) point.withCompound,
      for (final point in points) point.withoutCompound,
      0.0,
    ];
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final span = math.max(maxValue - minValue, 1);

    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    final labelPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );

    for (var i = 0; i <= 4; i++) {
      final y = chart.bottom - chart.height * i / 4;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
      final value = minValue + span * i / 4;
      labelPainter.text = TextSpan(
        text: '\$${(value / 1000).toStringAsFixed(1)}k',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontSize: 9,
        ),
      );
      labelPainter.layout(maxWidth: AppSpacing.x6 - AppSpacing.x2);
      labelPainter.paint(
        canvas,
        Offset(
          chart.left - labelPainter.width - AppSpacing.x3,
          y - labelPainter.height / 2,
        ),
      );
    }

    Path buildPath(double Function(StakingAutoCompoundPointDraft point) value) {
      final path = Path();
      for (var i = 0; i < points.length; i++) {
        final point = points[i];
        final x = chart.left + chart.width * i / (points.length - 1);
        final y =
            chart.bottom - ((value(point) - minValue) / span) * chart.height;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      return path;
    }

    final withoutPaint = Paint()
      ..color = AppColors.sell
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final withPaint = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(buildPath((point) => point.withoutCompound), withoutPaint);
    canvas.drawPath(buildPath((point) => point.withCompound), withPaint);
  }

  @override
  bool shouldRepaint(covariant _CompoundChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

final class _CompoundSimulation {
  const _CompoundSimulation({
    required this.points,
    required this.withCompound,
    required this.withoutCompound,
    required this.difference,
    required this.percentageGain,
  });

  final List<StakingAutoCompoundPointDraft> points;
  final double withCompound;
  final double withoutCompound;
  final double difference;
  final double percentageGain;
}

String _frequencyLabel(String frequency) {
  return switch (frequency) {
    'daily' => 'Hàng ngày',
    'weekly' => 'Hàng tuần',
    'monthly' => 'Hàng tháng',
    _ => frequency,
  };
}

String _formatAmount(double value) {
  if (value >= 1000) return value.toStringAsFixed(0);
  if (value >= 1) {
    return value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(2);
  }
  return value.toString();
}

String _formatCurrency(double value, {bool compact = false}) {
  final fractionDigits = compact ? 0 : 2;
  final rounded = value.toStringAsFixed(fractionDigits);
  final parts = rounded.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  if (parts.length > 1) buffer.write('.${parts.last}');
  return '\$${buffer.toString()}';
}

double _parseDouble(String value, double fallback) {
  return double.tryParse(value.replaceAll(',', '').trim()) ?? fallback;
}

int _parseInt(String value, int fallback) {
  return int.tryParse(value.trim()) ?? fallback;
}
