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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/earn/data/earn_repository.dart';

class AutoCompoundSettingsPage extends ConsumerStatefulWidget {
  const AutoCompoundSettingsPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc341_summary');
  static const infoButtonKey = Key('sc341_info_button');
  static const infoSheetKey = Key('sc341_info_sheet');
  static const saveButtonKey = Key('sc341_save_button');
  static const successToastKey = Key('sc341_success_toast');
  static const calculatorKey = Key('sc341_calculator');

  static Key positionKey(String id) => Key('sc341_position_$id');
  static Key toggleKey(String id) => Key('sc341_toggle_$id');
  static Key settingsButtonKey(String id) => Key('sc341_settings_$id');
  static Key frequencyKey(String id) => Key('sc341_frequency_$id');
  static Key thresholdKey(double value) => Key('sc341_threshold_$value');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AutoCompoundSettingsPage> createState() =>
      _AutoCompoundSettingsPageState();
}

class _AutoCompoundSettingsPageState
    extends ConsumerState<AutoCompoundSettingsPage> {
  final Map<String, bool> _enabled = {};
  final Map<String, String> _frequencies = {};
  final Map<String, double> _thresholds = {};
  String? _editingId;
  bool _showSuccess = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(autoCompoundSettingsRepositoryProvider)
        .getSettings();
    final positions = [
      for (final position in snapshot.positions) _resolved(position),
    ];
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-341 AutoCompoundSettingsPage',
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
                  trailing: IconButton(
                    key: AutoCompoundSettingsPage.infoButtonKey,
                    onPressed: () => _openInfo(snapshot),
                    icon: const Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.text2,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.defaultGap,
                      children: [
                        _SummaryCard(positions: positions),
                        VitPageSection(
                          label: 'Vị thế tiết kiệm',
                          accentColor: AppColors.buy,
                          children: [
                            for (final position in positions)
                              _PositionCard(
                                position: position,
                                onToggle: () => _toggle(position),
                                onSettings: () =>
                                    _openSettings(snapshot, position),
                              ),
                          ],
                        ),
                        _CalculatorPreview(),
                        _NoteCard(text: snapshot.note),
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
                  onDismiss: () {
                    setState(() => _showSuccess = false);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  AutoCompoundPositionDraft _resolved(AutoCompoundPositionDraft position) {
    return AutoCompoundPositionDraft(
      id: position.id,
      product: position.product,
      asset: position.asset,
      amount: position.amount,
      earned: position.earned,
      apy: position.apy,
      type: position.type,
      autoCompound: _enabled[position.id] ?? position.autoCompound,
      compoundFrequency:
          _frequencies[position.id] ?? position.compoundFrequency,
      compoundThreshold: _thresholds[position.id] ?? position.compoundThreshold,
      lastCompounded: position.lastCompounded,
      totalCompounded: position.totalCompounded,
      compoundCount: position.compoundCount,
      estimatedBoost: position.estimatedBoost,
    );
  }

  void _toggle(AutoCompoundPositionDraft position) {
    HapticFeedback.selectionClick();
    setState(() => _enabled[position.id] = !position.autoCompound);
  }

  Future<void> _openInfo(AutoCompoundSettingsSnapshot snapshot) async {
    HapticFeedback.selectionClick();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _SheetFrame(child: _InfoSheet(snapshot: snapshot));
      },
    );
  }

  Future<void> _openSettings(
    AutoCompoundSettingsSnapshot snapshot,
    AutoCompoundPositionDraft position,
  ) async {
    HapticFeedback.selectionClick();
    setState(() => _editingId = position.id);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _SheetFrame(
          child: _SettingsSheet(
            snapshot: snapshot,
            position: _resolved(position),
            onToggle: () {
              _toggle(_resolved(position));
              Navigator.of(context).pop();
              _openSettings(snapshot, position);
            },
            onFrequency: (frequency) {
              HapticFeedback.selectionClick();
              setState(() => _frequencies[position.id] = frequency);
              Navigator.of(context).pop();
              _openSettings(snapshot, position);
            },
            onThreshold: (threshold) {
              HapticFeedback.selectionClick();
              setState(() => _thresholds[position.id] = threshold);
              Navigator.of(context).pop();
              _openSettings(snapshot, position);
            },
            onSave: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
              setState(() {
                _editingId = null;
                _showSuccess = true;
              });
            },
          ),
        );
      },
    );
    if (mounted && _editingId == position.id) {
      setState(() => _editingId = null);
    }
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.positions});

  final List<AutoCompoundPositionDraft> positions;

  @override
  Widget build(BuildContext context) {
    final active = positions.where((position) => position.autoCompound).length;
    final totalCompounded = positions.fold<double>(
      0,
      (sum, position) =>
          sum + _usdValue(position.asset, position.totalCompounded),
    );
    final totalEvents = positions.fold<int>(
      0,
      (sum, position) => sum + position.compoundCount,
    );

    return VitCard(
      key: AutoCompoundSettingsPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.autorenew_rounded,
                color: AppColors.primary,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Auto-Compound Overview',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _SummaryStat(
                  label: 'Đang bật',
                  value: '$active/${positions.length}',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SummaryStat(
                  label: 'Đã compound (USD)',
                  value: _formatUsd(totalCompounded),
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SummaryStat(
                  label: 'Tổng lần',
                  value: '$totalEvents',
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.sectionTitle.copyWith(
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

class _PositionCard extends StatelessWidget {
  const _PositionCard({
    required this.position,
    required this.onToggle,
    required this.onSettings,
  });

  final AutoCompoundPositionDraft position;
  final VoidCallback onToggle;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final effectiveApy = position.autoCompound
        ? position.apy + position.estimatedBoost / 100
        : position.apy;
    final accent = _assetColor(position.asset);

    return VitCard(
      key: AutoCompoundSettingsPage.positionKey(position.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _AssetBadge(asset: position.asset, color: accent),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(position.product, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      children: [
                        Text(
                          '${_formatAmount(position.amount)} ${position.asset}',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                        Text(
                          '${effectiveApy.toStringAsFixed(2)}% APY',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.buy,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _ToggleSwitch(
                key: AutoCompoundSettingsPage.toggleKey(position.id),
                on: position.autoCompound,
                onTap: onToggle,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          if (position.autoCompound)
            _CompoundDetails(position: position)
          else
            _DisabledWarning(),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Icon(
                Icons.trending_up_rounded,
                color: position.autoCompound ? AppColors.buy : AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  position.autoCompound
                      ? '+${(position.estimatedBoost / 100).toStringAsFixed(2)}% APY từ compound'
                      : 'Bật compound để tăng APY',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ),
              TextButton.icon(
                key: AutoCompoundSettingsPage.settingsButtonKey(position.id),
                onPressed: onSettings,
                icon: const Icon(Icons.settings_outlined),
                label: const Text('Cài đặt'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompoundDetails extends StatelessWidget {
  const _CompoundDetails({required this.position});

  final AutoCompoundPositionDraft position;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  _frequencyLabel(position.compoundFrequency),
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                'Ngưỡng: ${_formatAmount(position.compoundThreshold)} ${position.asset}',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Đã compound: ${_formatAmount(position.totalCompounded)} ${position.asset}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              Text(
                '${position.compoundCount} lần',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          if (position.lastCompounded != '—') ...[
            const SizedBox(height: AppSpacing.x1),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Gần nhất: ${position.lastCompounded}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DisabledWarning extends StatelessWidget {
  const _DisabledWarning();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn15,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Auto-compound đang tắt — lãi sẽ tích luỹ riêng, không cộng vào gốc',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalculatorPreview extends StatelessWidget {
  const _CalculatorPreview();

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Mô phỏng hiệu quả',
      accentColor: AppColors.accent,
      children: [
        VitCard(
          key: AutoCompoundSettingsPage.calculatorKey,
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calculate_outlined,
                    color: AppColors.accent,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      'Ví dụ: 1,000 USDT × 4.5% APY',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x3),
              Row(
                children: [
                  Expanded(
                    child: _CalculatorStat(
                      label: 'Không compound',
                      value: '\$45.00',
                      caption: 'sau 1 năm',
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _CalculatorStat(
                      label: 'Compound hàng ngày',
                      value: '\$46.03',
                      caption: '+\$1.03 thêm',
                      color: AppColors.buy,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CalculatorStat extends StatelessWidget {
  const _CalculatorStat({
    required this.label,
    required this.value,
    required this.caption,
    required this.color,
  });

  final String label;
  final String value;
  final String caption;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        children: [
          Text(label, textAlign: TextAlign.center, style: AppTextStyles.micro),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          Text(
            caption,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.86,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadii.xl),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentPad,
              AppSpacing.x5,
              AppSpacing.contentPad,
              AppSpacing.x6,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _SettingsSheet extends StatelessWidget {
  const _SettingsSheet({
    required this.snapshot,
    required this.position,
    required this.onToggle,
    required this.onFrequency,
    required this.onThreshold,
    required this.onSave,
  });

  final AutoCompoundSettingsSnapshot snapshot;
  final AutoCompoundPositionDraft position;
  final VoidCallback onToggle;
  final ValueChanged<String> onFrequency;
  final ValueChanged<double> onThreshold;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final thresholds = _thresholdPresets(position.asset);
    final effectiveApy = position.autoCompound
        ? position.apy + position.estimatedBoost / 100
        : position.apy;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Cài đặt lãi kép — ${position.product}',
                style: AppTextStyles.sectionTitle,
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded, color: AppColors.text3),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        _PositionSummary(position: position),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          variant: VitCardVariant.inner,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            children: [
              Icon(
                Icons.autorenew_rounded,
                color: position.autoCompound ? AppColors.buy : AppColors.text3,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Tự động lãi kép',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _ToggleSwitch(on: position.autoCompound, onTap: onToggle),
            ],
          ),
        ),
        if (position.autoCompound) ...[
          const SizedBox(height: AppSpacing.x5),
          Text(
            'Tần suất compound',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final frequency in snapshot.frequencies) ...[
            _FrequencyTile(
              frequency: frequency,
              selected: frequency.id == position.compoundFrequency,
              onTap: () => onFrequency(frequency.id),
            ),
            if (frequency != snapshot.frequencies.last)
              const SizedBox(height: AppSpacing.x3),
          ],
          const SizedBox(height: AppSpacing.x5),
          Text(
            'Ngưỡng tối thiểu',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              for (final threshold in thresholds) ...[
                Expanded(
                  child: _ThresholdChip(
                    value: threshold,
                    asset: position.asset,
                    selected: threshold == position.compoundThreshold,
                    onTap: () => onThreshold(threshold),
                  ),
                ),
                if (threshold != thresholds.last)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.x5),
        VitCard(
          variant: VitCardVariant.inner,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            children: [
              _SheetMetric(label: 'APY cơ bản', value: '${position.apy}%'),
              _SheetMetric(
                label: 'APY thực tế (compound)',
                value: position.autoCompound
                    ? '~${effectiveApy.toStringAsFixed(2)}%'
                    : '${position.apy}% (không compound)',
                color: position.autoCompound ? AppColors.buy : AppColors.text2,
              ),
              if (position.autoCompound)
                _SheetMetric(
                  label: 'Lợi ích thêm',
                  value:
                      '+${(position.estimatedBoost / 100).toStringAsFixed(2)}% APY',
                  color: AppColors.buy,
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        VitCtaButton(
          key: AutoCompoundSettingsPage.saveButtonKey,
          onPressed: onSave,
          child: const Text('Lưu cài đặt'),
        ),
      ],
    );
  }
}

class _PositionSummary extends StatelessWidget {
  const _PositionSummary({required this.position});

  final AutoCompoundPositionDraft position;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _AssetBadge(asset: position.asset, color: _assetColor(position.asset)),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(position.product, style: AppTextStyles.baseMedium),
              Text(
                'Số dư: ${_formatAmount(position.amount)} ${position.asset}',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FrequencyTile extends StatelessWidget {
  const _FrequencyTile({
    required this.frequency,
    required this.selected,
    required this.onTap,
  });

  final AutoCompoundFrequencyDraft frequency;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: AutoCompoundSettingsPage.frequencyKey(frequency.id),
      variant: VitCardVariant.inner,
      borderColor: selected ? AppColors.buy : null,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            selected ? Icons.check_circle_rounded : Icons.circle_outlined,
            color: selected ? AppColors.buy : AppColors.text3,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  frequency.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  frequency.description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          _SmallPill(label: frequency.boostLabel, color: AppColors.buy),
        ],
      ),
    );
  }
}

class _ThresholdChip extends StatelessWidget {
  const _ThresholdChip({
    required this.value,
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  final double value;
  final String asset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.buy10 : AppColors.surface2,
      borderRadius: AppRadii.mdRadius,
      child: InkWell(
        key: AutoCompoundSettingsPage.thresholdKey(value),
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
          child: Text(
            _formatAmount(value),
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: selected ? AppColors.buy : AppColors.text2,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetMetric extends StatelessWidget {
  const _SheetMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSheet extends StatelessWidget {
  const _InfoSheet({required this.snapshot});

  final AutoCompoundSettingsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: AutoCompoundSettingsPage.infoSheetKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Lãi kép là gì?', style: AppTextStyles.sectionTitle),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded, color: AppColors.text3),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          variant: VitCardVariant.inner,
          padding: const EdgeInsets.all(AppSpacing.x5),
          child: Column(
            children: [
              const Icon(
                Icons.autorenew_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconLg,
              ),
              const SizedBox(height: AppSpacing.x3),
              Text('Auto-Compound', style: AppTextStyles.baseMedium),
              const SizedBox(height: AppSpacing.x2),
              Text(
                'Lãi kép tự động cộng phần lãi kiếm được vào số gốc, giúp bạn kiếm lãi trên cả lãi theo thời gian.',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        for (final item in snapshot.infoItems) ...[
          _InfoItem(item: item),
          if (item != snapshot.infoItems.last)
            const SizedBox(height: AppSpacing.x3),
        ],
        const SizedBox(height: AppSpacing.x5),
        _NoteCard(text: snapshot.note),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.item});

  final AutoCompoundInfoDraft item;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(item.tone);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: AppRadii.mdRadius,
          ),
          child: SizedBox(
            width: AppSpacing.x7,
            height: AppSpacing.x7,
            child: Icon(
              Icons.check_rounded,
              color: color,
              size: AppSpacing.iconSm,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                item.description,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SuccessToast extends StatelessWidget {
  const _SuccessToast({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: AutoCompoundSettingsPage.successToastKey,
      borderColor: AppColors.buy,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Đã lưu cài đặt!', style: AppTextStyles.baseMedium),
                Text(
                  'Compound sẽ áp dụng từ kỳ tiếp theo.',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            icon: const Icon(Icons.close_rounded, color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({super.key, required this.on, required this.onTap});

  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: on,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 44,
          height: 24,
          padding: const EdgeInsets.all(AppSpacing.x1),
          decoration: BoxDecoration(
            color: on ? AppColors.buy : AppColors.borderSolid,
            borderRadius: AppRadii.mdRadius,
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 180),
            alignment: on ? Alignment.centerRight : Alignment.centerLeft,
            child: const SizedBox(
              width: AppSpacing.x4,
              height: AppSpacing.x4,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AssetBadge extends StatelessWidget {
  const _AssetBadge({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        borderRadius: AppRadii.xlRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Center(
          child: Text(
            asset.length > 3 ? asset.substring(0, 3) : asset,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

List<double> _thresholdPresets(String asset) {
  return switch (asset) {
    'BTC' => const [0.00001, 0.0001, 0.001, 0.01],
    'ETH' => const [0.001, 0.005, 0.01, 0.05],
    _ => const [0.1, 0.5, 1, 5],
  };
}

String _frequencyLabel(String frequency) {
  return switch (frequency) {
    'daily' => 'Hàng ngày',
    'weekly' => 'Hàng tuần',
    'monthly' => 'Hàng tháng',
    _ => frequency,
  };
}

double _usdValue(String asset, double amount) {
  return switch (asset) {
    'BTC' => amount * 67543,
    'ETH' => amount * 2800,
    'SOL' => amount * 130,
    _ => amount,
  };
}

String _formatUsd(double value) {
  return '\$${value.toStringAsFixed(2)}';
}

String _formatAmount(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  if (value < 0.01) return value.toStringAsFixed(6);
  if (value < 1) return value.toStringAsFixed(4);
  return value.toStringAsFixed(2);
}

Color _assetColor(String asset) {
  return switch (asset) {
    'USDT' => AppColors.buy,
    'BTC' => AppColors.warn,
    'ETH' => AppColors.primary,
    _ => AppColors.accent,
  };
}

Color _riskColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.primary,
    EarnRiskLevel.high => AppColors.warn,
  };
}
