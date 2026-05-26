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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';

const _configurationPrimary = AppColors.primary;
const _configurationGreen = Color(0xFF10B981);
const _configurationRed = Color(0xFFEF4444);

class CopyConfigurationPage extends ConsumerStatefulWidget {
  const CopyConfigurationPage({
    super.key,
    required this.providerId,
    this.backPath,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc072_copy_configuration_content');
  static const confirmKey = Key('sc072_copy_configuration_confirm');
  static const capitalFieldKey = Key('sc072_copy_configuration_capital');

  static Key modeKey(TradeCopyConfigurationMode mode) =>
      Key('sc072_copy_configuration_mode_${mode.name}');

  final String providerId;
  final String? backPath;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopyConfigurationPage> createState() =>
      _CopyConfigurationPageState();
}

class _CopyConfigurationPageState extends ConsumerState<CopyConfigurationPage> {
  final TextEditingController _capitalController = TextEditingController();
  TradeCopyConfigurationDraft? _draft;
  String? _draftProviderId;

  @override
  void dispose() {
    _capitalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(tradeRepositoryProvider);
    final snapshot = repository.getCopyConfiguration(
      providerId: widget.providerId,
    );

    if (snapshot.isNotFound) {
      return const VitPageLayout(
        variant: VitPageVariant.flush,
        semanticLabel: 'SC-072 CopyConfigurationPage blank',
        child: SizedBox.expand(),
      );
    }

    _ensureDraft(snapshot);
    final draft = _draft!;
    final preview = repository.previewCopyConfiguration(draft);
    final provider = snapshot.provider!;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 84 : 24);
    final allocationPercent = draft.copyCapital / snapshot.totalPortfolio * 100;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-072 CopyConfigurationPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Cấu hình Copy',
              showBack: true,
              onBack: () => context.go(
                widget.backPath ??
                    AppRoutePaths.tradeCopyProvider(widget.providerId),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: CopyConfigurationPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ProviderCard(provider: provider),
                    const SizedBox(height: 18),
                    _CapitalSection(
                      controller: _capitalController,
                      allocationPercent: allocationPercent,
                      availableCapital: snapshot.availableCapital,
                      totalPortfolio: snapshot.totalPortfolio,
                      onChanged: _updateCapital,
                      onPreset: _setCapitalPercent,
                    ),
                    const SizedBox(height: 18),
                    _ModeSection(
                      selected: draft.copyMode,
                      copyRatio: draft.copyRatio,
                      onModeChanged: _setMode,
                      onRatioChanged: _setCopyRatio,
                    ),
                    const SizedBox(height: 18),
                    _RiskSection(draft: draft, onDraftChanged: _setDraft),
                    const SizedBox(height: 18),
                    _FeeSection(preview: preview),
                    const SizedBox(height: 18),
                    if (preview.validations.isNotEmpty) ...[
                      _ValidationList(items: preview.validations),
                      const SizedBox(height: 18),
                    ],
                    _SummaryCard(draft: draft),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: bottomChrome + MediaQuery.paddingOf(context).bottom,
              ),
              child: VitStickyFooter(
                child: VitCtaButton(
                  key: CopyConfigurationPage.confirmKey,
                  onPressed: preview.hasBlockingErrors
                      ? null
                      : () => context.go(
                          AppRoutePaths.tradeCopyProviderConfirmation(
                            widget.providerId,
                          ),
                        ),
                  variant: VitCtaButtonVariant.auth,
                  trailing: const Icon(Icons.chevron_right_rounded),
                  child: const Text('Xem xác nhận'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _ensureDraft(TradeCopyConfigurationSnapshot snapshot) {
    if (_draftProviderId == snapshot.providerId) return;
    _draftProviderId = snapshot.providerId;
    _draft = snapshot.defaultDraft;
    _capitalController.text = snapshot.defaultDraft.copyCapital.toStringAsFixed(
      0,
    );
  }

  void _setDraft(TradeCopyConfigurationDraft draft) {
    setState(() => _draft = draft);
  }

  void _updateCapital(String rawValue) {
    final value = double.tryParse(rawValue);
    if (value == null) return;
    _setDraft(_draft!.copyWith(copyCapital: value));
  }

  void _setCapitalPercent(double percent) {
    final capital = 25000 * percent / 100;
    _capitalController.text = capital.toStringAsFixed(0);
    _setDraft(_draft!.copyWith(copyCapital: capital));
  }

  void _setMode(TradeCopyConfigurationMode mode) {
    _setDraft(_draft!.copyWith(copyMode: mode));
  }

  void _setCopyRatio(double ratio) {
    _setDraft(_draft!.copyWith(copyRatio: ratio));
  }
}

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({required this.provider});

  final TradeCopyTrader provider;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: _configurationPrimary.withValues(alpha: .16),
            child: Text(
              provider.avatar,
              style: AppTextStyles.baseMedium.copyWith(
                color: _configurationPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đang cấu hình copy cho',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: 4),
                Text(
                  provider.name,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ROI +${provider.totalPnlPct.toStringAsFixed(1)}% · Max DD ${provider.maxDrawdown.toStringAsFixed(1)}%',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          _RiskPill(level: provider.riskLevel),
        ],
      ),
    );
  }
}

class _CapitalSection extends StatelessWidget {
  const _CapitalSection({
    required this.controller,
    required this.allocationPercent,
    required this.availableCapital,
    required this.totalPortfolio,
    required this.onChanged,
    required this.onPreset,
  });

  final TextEditingController controller;
  final double allocationPercent;
  final double availableCapital;
  final double totalPortfolio;
  final ValueChanged<String> onChanged;
  final ValueChanged<double> onPreset;

  @override
  Widget build(BuildContext context) {
    final allocationColor = allocationPercent > 20
        ? _configurationRed
        : allocationPercent > 15
        ? AppColors.warn
        : _configurationPrimary;

    return VitPageSection(
      label: 'Vốn copy',
      accentColor: _configurationPrimary,
      children: [
        VitInput(
          fieldKey: CopyConfigurationPage.capitalFieldKey,
          controller: controller,
          label: 'Số tiền copy (USD)',
          keyboardType: TextInputType.number,
          prefix: const Icon(Icons.attach_money_rounded),
          onChanged: onChanged,
        ),
        VitCard(
          variant: VitCardVariant.inner,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Phân bổ portfolio',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  Text(
                    '${allocationPercent.toStringAsFixed(1)}%',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: allocationColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: AppRadii.smRadius,
                child: LinearProgressIndicator(
                  minHeight: 8,
                  value: (allocationPercent / 100).clamp(0, 1),
                  backgroundColor: AppColors.borderSolid,
                  valueColor: AlwaysStoppedAnimation<Color>(allocationColor),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Khả dụng \$${availableCapital.toStringAsFixed(0)}',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  Text(
                    'Portfolio \$${totalPortfolio.toStringAsFixed(0)}',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            for (final percent in const [5.0, 10.0, 15.0, 20.0]) ...[
              Expanded(
                child: _PresetButton(
                  label: '${percent.toStringAsFixed(0)}%',
                  onPressed: () => onPreset(percent),
                ),
              ),
              if (percent != 20) const SizedBox(width: 8),
            ],
          ],
        ),
      ],
    );
  }
}

class _ModeSection extends StatelessWidget {
  const _ModeSection({
    required this.selected,
    required this.copyRatio,
    required this.onModeChanged,
    required this.onRatioChanged,
  });

  final TradeCopyConfigurationMode selected;
  final double copyRatio;
  final ValueChanged<TradeCopyConfigurationMode> onModeChanged;
  final ValueChanged<double> onRatioChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Chế độ copy',
      accentColor: _configurationPrimary,
      children: [
        for (final mode in TradeCopyConfigurationMode.values)
          _ModeTile(
            mode: mode,
            selected: selected == mode,
            onTap: () => onModeChanged(mode),
          ),
        if (selected == TradeCopyConfigurationMode.fixed)
          VitCard(
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tỷ lệ sao chép',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        min: 10,
                        max: 100,
                        divisions: 18,
                        value: copyRatio,
                        activeColor: _configurationPrimary,
                        onChanged: onRatioChanged,
                      ),
                    ),
                    SizedBox(
                      width: 54,
                      child: Text(
                        '${copyRatio.toStringAsFixed(0)}%',
                        textAlign: TextAlign.right,
                        style: AppTextStyles.baseMedium.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Provider mở \$1000 -> bạn mở \$${(1000 * copyRatio / 100).toStringAsFixed(0)}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _RiskSection extends StatelessWidget {
  const _RiskSection({required this.draft, required this.onDraftChanged});

  final TradeCopyConfigurationDraft draft;
  final ValueChanged<TradeCopyConfigurationDraft> onDraftChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Giới hạn rủi ro',
      accentColor: _configurationRed,
      children: [
        _RiskToggle(
          title: 'Stop-Loss riêng',
          value: draft.useCustomStopLoss,
          onChanged: (value) =>
              onDraftChanged(draft.copyWith(useCustomStopLoss: value)),
        ),
        _RiskToggle(
          title: 'Take-Profit riêng',
          value: draft.useCustomTakeProfit,
          onChanged: (value) =>
              onDraftChanged(draft.copyWith(useCustomTakeProfit: value)),
        ),
        _RiskToggle(
          title: 'Trailing Stop',
          value: draft.useTrailingStop,
          onChanged: (value) =>
              onDraftChanged(draft.copyWith(useTrailingStop: value)),
        ),
      ],
    );
  }
}

class _FeeSection extends StatelessWidget {
  const _FeeSection({required this.preview});

  final TradeCopyConfigurationPreview preview;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Dự kiến chi phí',
      accentColor: AppColors.warn,
      children: [
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _SummaryRow(
                label: 'Platform fee (0.1%)',
                value: '\$${preview.feePreview.platformFee.toStringAsFixed(2)}',
              ),
              _SummaryRow(
                label: 'Trading fees ước tính',
                value:
                    '\$${preview.feePreview.estimatedTradingFees.toStringAsFixed(2)}',
              ),
              _SummaryRow(
                label: 'Performance fee',
                value: preview.feePreview.performanceFeeNote,
              ),
              const Divider(color: AppColors.divider, height: 22),
              _SummaryRow(
                label: 'Tổng phí cố định',
                value:
                    '\$${preview.feePreview.totalFixedFees.toStringAsFixed(2)}',
                valueColor: _configurationRed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ValidationList extends StatelessWidget {
  const _ValidationList({required this.items});

  final List<TradeCopyConfigurationValidation> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items) ...[
          _ValidationCard(item: item),
          if (item != items.last) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.draft});

  final TradeCopyConfigurationDraft draft;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tóm tắt cấu hình',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: 'Số vốn copy',
            value: '\$${draft.copyCapital.toStringAsFixed(0)}',
          ),
          _SummaryRow(label: 'Chế độ', value: _modeLabel(draft.copyMode)),
          _SummaryRow(
            label: 'Stop-Loss',
            value: draft.useCustomStopLoss
                ? '-${draft.customStopLoss.toStringAsFixed(0)}%'
                : 'Theo provider',
          ),
          _SummaryRow(
            label: 'Take-Profit',
            value: draft.useCustomTakeProfit
                ? '+${draft.customTakeProfit.toStringAsFixed(0)}%'
                : 'Theo provider',
          ),
          _SummaryRow(
            label: 'Trailing Stop',
            value: draft.useTrailingStop
                ? '${draft.trailingStopPercent.toStringAsFixed(0)}%'
                : 'Không',
          ),
        ],
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final TradeCopyConfigurationMode mode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: CopyConfigurationPage.modeKey(mode),
      variant: selected ? VitCardVariant.standard : VitCardVariant.inner,
      borderColor: selected ? _configurationPrimary : null,
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            selected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_unchecked_rounded,
            color: selected ? _configurationPrimary : AppColors.text3,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _modeLabel(mode),
                  style: AppTextStyles.caption.copyWith(
                    color: selected ? _configurationPrimary : AppColors.text1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _modeDescription(mode),
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1.35,
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

class _RiskToggle extends StatelessWidget {
  const _RiskToggle({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.text3, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: _configurationPrimary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ValidationCard extends StatelessWidget {
  const _ValidationCard({required this.item});

  final TradeCopyConfigurationValidation item;

  @override
  Widget build(BuildContext context) {
    final color = switch (item.level) {
      TradeCopyConfigurationValidationLevel.error => _configurationRed,
      TradeCopyConfigurationValidationLevel.warning => AppColors.warn,
      TradeCopyConfigurationValidationLevel.info => _configurationPrimary,
    };

    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: color.withValues(alpha: .55),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_validationIcon(item.level), color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.message,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontSize: 11,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PresetButton extends StatelessWidget {
  const _PresetButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text2,
          side: const BorderSide(color: AppColors.borderSolid),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
          padding: EdgeInsets.zero,
        ),
        child: Text(label, style: AppTextStyles.caption),
      ),
    );
  }
}

class _RiskPill extends StatelessWidget {
  const _RiskPill({required this.level});

  final TradeCopyRiskLevel level;

  @override
  Widget build(BuildContext context) {
    final color = switch (level) {
      TradeCopyRiskLevel.low => _configurationGreen,
      TradeCopyRiskLevel.medium => AppColors.warn,
      TradeCopyRiskLevel.high => _configurationRed,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          switch (level) {
            TradeCopyRiskLevel.low => 'Low',
            TradeCopyRiskLevel.medium => 'Medium',
            TradeCopyRiskLevel.high => 'High',
          },
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

String _modeLabel(TradeCopyConfigurationMode mode) {
  return switch (mode) {
    TradeCopyConfigurationMode.mirror => 'Mirror Copy',
    TradeCopyConfigurationMode.fixed => 'Fixed Ratio',
    TradeCopyConfigurationMode.smart => 'Smart Copy',
  };
}

String _modeDescription(TradeCopyConfigurationMode mode) {
  return switch (mode) {
    TradeCopyConfigurationMode.mirror =>
      'Sao chép chính xác tỷ lệ vị thế của provider.',
    TradeCopyConfigurationMode.fixed =>
      'Copy với tỷ lệ cố định để kiểm soát vốn tốt hơn.',
    TradeCopyConfigurationMode.smart =>
      'Tự điều chỉnh size theo volatility và risk.',
  };
}

IconData _validationIcon(TradeCopyConfigurationValidationLevel level) {
  return switch (level) {
    TradeCopyConfigurationValidationLevel.error => Icons.error_outline_rounded,
    TradeCopyConfigurationValidationLevel.warning =>
      Icons.warning_amber_rounded,
    TradeCopyConfigurationValidationLevel.info => Icons.info_outline_rounded,
  };
}
