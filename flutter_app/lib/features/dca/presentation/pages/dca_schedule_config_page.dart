import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/dca/data/dca_repository.dart';

class DCAScheduleConfig extends ConsumerStatefulWidget {
  const DCAScheduleConfig({super.key, this.shellRenderMode});

  static const contentKey = Key('sc172_schedule_content');
  static const saveKey = Key('sc172_schedule_save');
  static const enabledKey = Key('sc172_schedule_enabled');
  static const maxDelayKey = Key('sc172_max_delay');
  static const maxAdvanceKey = Key('sc172_max_advance');
  static const volatilityKey = Key('sc172_volatility_threshold');
  static const gasKey = Key('sc172_gas_threshold');

  static Key strategyKey(DcaScheduleStrategy strategy) {
    return Key('sc172_strategy_${strategy.name}');
  }

  static Key timeKey(DcaScheduleTimePreference preference) {
    return Key('sc172_time_${preference.name}');
  }

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DCAScheduleConfig> createState() => _DCAScheduleConfigState();
}

class _DCAScheduleConfigState extends ConsumerState<DCAScheduleConfig> {
  late DcaScheduleStrategy _strategy;
  late DcaScheduleTimePreference _timePreference;
  late double _maxDelayHours;
  late double _maxAdvanceHours;
  late double _volatilityThreshold;
  late double _gasPriceThreshold;
  bool _enabled = true;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(dcaRepositoryProvider).getScheduleConfig();
    _initialize(snapshot);

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'SC-172 DCAScheduleConfig',
      child: Column(
        children: [
          VitHeader(
            title: 'Smart Scheduling',
            subtitle: 'Lịch mua · DCA',
            showBack: true,
            onBack: _close,
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(
                context,
              ).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                key: DCAScheduleConfig.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  customGap: AppSpacing.x5,
                  children: [
                    const _InfoBanner(),
                    _StrategySection(
                      strategies: snapshot.strategies,
                      active: _strategy,
                      onChanged: _setStrategy,
                    ),
                    _TimePreferenceSection(
                      preferences: snapshot.timePreferences,
                      active: _timePreference,
                      activeAccent: _strategyAccent,
                      onChanged: _setTimePreference,
                    ),
                    _LimitsCard(
                      maxDelayHours: _maxDelayHours,
                      maxAdvanceHours: _maxAdvanceHours,
                      onDelayChanged: (value) {
                        setState(() => _maxDelayHours = value.roundToDouble());
                      },
                      onAdvanceChanged: (value) {
                        setState(
                          () => _maxAdvanceHours = value.roundToDouble(),
                        );
                      },
                    ),
                    if (_strategy == DcaScheduleStrategy.volatility ||
                        _strategy == DcaScheduleStrategy.hybrid)
                      _ThresholdCard(
                        key: DCAScheduleConfig.volatilityKey,
                        title: 'Volatility Settings',
                        icon: Icons.trending_down,
                        accent: AppColors.accent,
                        label: 'Ngưỡng volatility',
                        valueLabel:
                            '${_volatilityThreshold.toStringAsFixed(1)}%',
                        min: 0.5,
                        max: 10,
                        divisions: 19,
                        value: _volatilityThreshold,
                        helper:
                            'Ưu tiên thời điểm volatility < ${_volatilityThreshold.toStringAsFixed(1)}%',
                        onChanged: (value) {
                          setState(() => _volatilityThreshold = value);
                        },
                      ),
                    if (_strategy == DcaScheduleStrategy.gasOptimized ||
                        _strategy == DcaScheduleStrategy.hybrid)
                      _ThresholdCard(
                        key: DCAScheduleConfig.gasKey,
                        title: 'Gas Settings',
                        icon: Icons.bolt_outlined,
                        accent: AppColors.warn,
                        label: 'Ngưỡng gas price',
                        valueLabel: '${_gasPriceThreshold.round()} gwei',
                        min: 5,
                        max: 100,
                        divisions: 19,
                        value: _gasPriceThreshold,
                        helper:
                            'Ưu tiên thời điểm gas < ${_gasPriceThreshold.round()} gwei',
                        onChanged: (value) {
                          setState(
                            () => _gasPriceThreshold = value.roundToDouble(),
                          );
                        },
                      ),
                    _EnableCard(
                      enabled: _enabled,
                      onChanged: (value) {
                        HapticFeedback.selectionClick();
                        setState(() => _enabled = value);
                      },
                    ),
                    if (_strategy == DcaScheduleStrategy.fixed)
                      const _FixedWarningCard(),
                    VitCtaButton(
                      key: DCAScheduleConfig.saveKey,
                      onPressed: _save,
                      leading: const Icon(Icons.save_outlined),
                      child: const Text('Lưu cấu hình'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _initialize(DcaScheduleConfigSnapshot snapshot) {
    if (_initialized) return;
    _strategy = snapshot.strategy;
    _timePreference = snapshot.timePreference;
    _maxDelayHours = snapshot.maxDelayHours.toDouble();
    _maxAdvanceHours = snapshot.maxAdvanceHours.toDouble();
    _volatilityThreshold = snapshot.volatilityThreshold;
    _gasPriceThreshold = snapshot.gasPriceThreshold.toDouble();
    _enabled = snapshot.enabled;
    _initialized = true;
  }

  Color get _strategyAccent => _accentForStrategy(_strategy);

  void _setStrategy(DcaScheduleStrategy strategy) {
    HapticFeedback.selectionClick();
    setState(() => _strategy = strategy);
  }

  void _setTimePreference(DcaScheduleTimePreference preference) {
    HapticFeedback.selectionClick();
    setState(() => _timePreference = preference);
  }

  void _save() {
    HapticFeedback.mediumImpact();
    context.go(AppRoutePaths.dcaScheduleAnalytics);
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.dca);
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.primary30,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.primary,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lịch trình thông minh',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Smart Scheduling tự động điều chỉnh thời gian DCA dựa trên điều kiện thị trường, giúp tối ưu chi phí và giảm rủi ro.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
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
    required this.strategies,
    required this.active,
    required this.onChanged,
  });

  final List<DcaScheduleStrategyOption> strategies;
  final DcaScheduleStrategy active;
  final ValueChanged<DcaScheduleStrategy> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle(icon: Icons.flash_on_outlined, title: 'Chiến lược'),
        const SizedBox(height: AppSpacing.x4),
        for (final option in strategies)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.x3),
            child: _StrategyTile(
              option: option,
              selected: option.strategy == active,
              onTap: () => onChanged(option.strategy),
            ),
          ),
      ],
    );
  }
}

class _StrategyTile extends StatelessWidget {
  const _StrategyTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final DcaScheduleStrategyOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForStrategy(option.strategy);
    return VitCard(
      key: DCAScheduleConfig.strategyKey(option.strategy),
      borderColor: selected
          ? accent.withValues(alpha: .72)
          : AppColors.cardBorder,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _AccentIcon(icon: _iconForOption(option.icon), accent: accent),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
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
          if (selected) _SelectedDot(accent: accent),
        ],
      ),
    );
  }
}

class _TimePreferenceSection extends StatelessWidget {
  const _TimePreferenceSection({
    required this.preferences,
    required this.active,
    required this.activeAccent,
    required this.onChanged,
  });

  final List<DcaScheduleTimePreferenceOption> preferences;
  final DcaScheduleTimePreference active;
  final Color activeAccent;
  final ValueChanged<DcaScheduleTimePreference> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle(
          icon: Icons.schedule_outlined,
          title: 'Khung giờ ưu tiên',
        ),
        const SizedBox(height: AppSpacing.x4),
        LayoutBuilder(
          builder: (context, constraints) {
            final tileWidth = (constraints.maxWidth - AppSpacing.x3) / 2;
            return Wrap(
              spacing: AppSpacing.x3,
              runSpacing: AppSpacing.x3,
              children: [
                for (final option in preferences)
                  SizedBox(
                    width: tileWidth,
                    child: _TimeTile(
                      option: option,
                      selected: option.preference == active,
                      accent: activeAccent,
                      onTap: () => onChanged(option.preference),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _TimeTile extends StatelessWidget {
  const _TimeTile({
    required this.option,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final DcaScheduleTimePreferenceOption option;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: DCAScheduleConfig.timeKey(option.preference),
      variant: VitCardVariant.inner,
      borderColor: selected ? accent.withValues(alpha: .72) : null,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x4,
      ),
      child: Column(
        children: [
          Text(
            option.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: selected ? accent : AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            option.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _LimitsCard extends StatelessWidget {
  const _LimitsCard({
    required this.maxDelayHours,
    required this.maxAdvanceHours,
    required this.onDelayChanged,
    required this.onAdvanceChanged,
  });

  final double maxDelayHours;
  final double maxAdvanceHours;
  final ValueChanged<double> onDelayChanged;
  final ValueChanged<double> onAdvanceChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Giới hạn điều chỉnh',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          _SliderField(
            key: DCAScheduleConfig.maxDelayKey,
            label: 'Trễ tối đa',
            valueLabel: '${maxDelayHours.round()}h',
            helper:
                'Cho phép trễ tối đa ${maxDelayHours.round()} giờ để đợi điều kiện tốt hơn',
            value: maxDelayHours,
            min: 1,
            max: 24,
            divisions: 23,
            onChanged: onDelayChanged,
          ),
          const SizedBox(height: AppSpacing.x5),
          _SliderField(
            key: DCAScheduleConfig.maxAdvanceKey,
            label: 'Sớm tối đa',
            valueLabel: '${maxAdvanceHours.round()}h',
            helper:
                'Cho phép thực thi sớm tối đa ${maxAdvanceHours.round()} giờ nếu điều kiện thuận lợi',
            value: maxAdvanceHours,
            min: 1,
            max: 24,
            divisions: 23,
            onChanged: onAdvanceChanged,
          ),
        ],
      ),
    );
  }
}

class _ThresholdCard extends StatelessWidget {
  const _ThresholdCard({
    super.key,
    required this.title,
    required this.icon,
    required this.accent,
    required this.label,
    required this.valueLabel,
    required this.min,
    required this.max,
    required this.divisions,
    required this.value,
    required this.helper,
    required this.onChanged,
  });

  final String title;
  final IconData icon;
  final Color accent;
  final String label;
  final String valueLabel;
  final double min;
  final double max;
  final int divisions;
  final double value;
  final String helper;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: accent, size: 18),
              const SizedBox(width: AppSpacing.x3),
              Text(
                title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          _SliderField(
            label: label,
            valueLabel: valueLabel,
            helper: helper,
            min: min,
            max: max,
            divisions: divisions,
            value: value,
            activeColor: accent,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SliderField extends StatelessWidget {
  const _SliderField({
    super.key,
    required this.label,
    required this.valueLabel,
    required this.helper,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    this.activeColor = AppColors.primary,
  });

  final String label;
  final String valueLabel;
  final String helper;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            Text(
              valueLabel,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: activeColor,
            inactiveTrackColor: AppColors.borderSolid,
            thumbColor: activeColor,
            overlayColor: activeColor.withValues(alpha: .12),
            trackHeight: 6,
          ),
          child: Slider(
            value: value.clamp(min, max).toDouble(),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
        Text(
          helper,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _EnableCard extends StatelessWidget {
  const _EnableCard({required this.enabled, required this.onChanged});

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kích hoạt Smart Scheduling',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Tự động tối ưu thời gian thực thi',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Switch(
            key: DCAScheduleConfig.enabledKey,
            value: enabled,
            activeThumbColor: AppColors.navCenterIcon,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: AppColors.text2,
            inactiveTrackColor: AppColors.surface3,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _FixedWarningCard extends StatelessWidget {
  const _FixedWarningCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_outlined,
            color: AppColors.warningText,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Chiến lược "Cố định" sẽ không tối ưu thời gian thực thi. Khuyên dùng "Hybrid" để có kết quả tốt nhất.',
              style: AppTextStyles.micro.copyWith(color: AppColors.warningText),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.text1, size: 18),
        const SizedBox(width: AppSpacing.x3),
        Text(title, style: AppTextStyles.sectionTitle.copyWith(fontSize: 18)),
      ],
    );
  }
}

class _AccentIcon extends StatelessWidget {
  const _AccentIcon({required this.icon, required this.accent});

  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: .14),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: accent, size: AppSpacing.iconMd),
    );
  }
}

class _SelectedDot extends StatelessWidget {
  const _SelectedDot({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Container(
        width: 7,
        height: 7,
        decoration: const BoxDecoration(
          color: AppColors.navCenterIcon,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

IconData _iconForOption(DcaScheduleOptionIcon icon) {
  switch (icon) {
    case DcaScheduleOptionIcon.clock:
      return Icons.schedule_outlined;
    case DcaScheduleOptionIcon.trend:
      return Icons.trending_down;
    case DcaScheduleOptionIcon.bolt:
      return Icons.bolt_outlined;
    case DcaScheduleOptionIcon.chart:
      return Icons.bar_chart;
  }
}

Color _accentForStrategy(DcaScheduleStrategy strategy) {
  switch (strategy) {
    case DcaScheduleStrategy.fixed:
      return AppColors.text3;
    case DcaScheduleStrategy.volatility:
      return AppColors.accent;
    case DcaScheduleStrategy.gasOptimized:
      return AppColors.warn;
    case DcaScheduleStrategy.volume:
      return AppColors.primarySoft;
    case DcaScheduleStrategy.hybrid:
      return AppColors.buy;
  }
}
