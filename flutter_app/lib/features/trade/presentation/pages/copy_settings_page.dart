import 'dart:async';

import 'package:flutter/material.dart';
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
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

const _settingsPrimary = AppColors.primary;
const _settingsPanel = AppColors.surface2;
const _settingsInput = AppColors.surface3;
const _sliderInactive = AppColors.tierPlatinum;

class CopySettingsPage extends ConsumerStatefulWidget {
  const CopySettingsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc067_copy_settings_scroll_content');
  static const circuitBreakerKey = Key('sc067_circuit_breaker_toggle');
  static const saveKey = Key('sc067_save_settings');
  static const emailChannelKey = Key('sc067_email_channel');
  static const pushChannelKey = Key('sc067_push_channel');

  static Key modeKey(TradeCopySettingsMode mode) =>
      Key('sc067_mode_${mode.name}');
  static Key notificationKey(String id) => Key('sc067_notification_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopySettingsPage> createState() => _CopySettingsPageState();
}

class _CopySettingsPageState extends ConsumerState<CopySettingsPage> {
  TradeCopySettings? _settings;
  bool _saved = false;
  Timer? _savedTimer;

  @override
  void dispose() {
    _savedTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(tradeCopySettingsControllerProvider);
    final snapshot = controller.state.snapshot;
    final settings = _settings ?? snapshot.settings;
    _settings ??= snapshot.settings;

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 112 : 28);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-067 CopySettingsPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Cài đặt Copy Trading',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: CopySettingsPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SettingsSection(
                      label: 'Cài đặt mặc định',
                      accent: _settingsPrimary,
                      showAccent: false,
                      children: [
                        _ModeCard(
                          selected: settings.defaultCopyMode,
                          onChanged: (value) => _update(
                            settings.copyWith(defaultCopyMode: value),
                          ),
                        ),
                        if (settings.defaultCopyMode ==
                            TradeCopySettingsMode.fixed)
                          _SliderCard(
                            title: 'Copy Ratio mặc định',
                            valueLabel:
                                '${settings.defaultCopyRatio.toStringAsFixed(0)}%',
                            caption:
                                'Copy ${settings.defaultCopyRatio.toStringAsFixed(0)}% position size của provider',
                            value: settings.defaultCopyRatio,
                            min: 10,
                            max: 100,
                            divisions: 18,
                            color: _settingsPrimary,
                            onChanged: (value) => _update(
                              settings.copyWith(defaultCopyRatio: value),
                            ),
                          ),
                        _SliderCard(
                          title: 'Stop-Loss mặc định',
                          valueLabel:
                              '-${settings.defaultStopLoss.toStringAsFixed(0)}%',
                          value: settings.defaultStopLoss,
                          min: 5,
                          max: 50,
                          divisions: 9,
                          color: AppColors.sell,
                          onChanged: (value) => _update(
                            settings.copyWith(defaultStopLoss: value),
                          ),
                        ),
                        _SliderCard(
                          title: 'Take-Profit mặc định',
                          valueLabel:
                              '+${settings.defaultTakeProfit.toStringAsFixed(0)}%',
                          value: settings.defaultTakeProfit,
                          min: 10,
                          max: 100,
                          divisions: 18,
                          color: AppColors.buy,
                          onChanged: (value) => _update(
                            settings.copyWith(defaultTakeProfit: value),
                          ),
                        ),
                      ],
                    ),
                    _SettingsSection(
                      label: 'Giới hạn rủi ro',
                      accent: AppColors.sell,
                      children: [
                        _SliderCard(
                          title: 'Max allocation per provider',
                          subtitle:
                              'Không copy quá X% tổng portfolio vào 1 provider',
                          valueLabel:
                              '${settings.maxPortfolioAllocation.toStringAsFixed(0)}%',
                          value: settings.maxPortfolioAllocation,
                          min: 5,
                          max: 50,
                          divisions: 9,
                          color: _settingsPrimary,
                          onChanged: (value) => _update(
                            settings.copyWith(maxPortfolioAllocation: value),
                          ),
                        ),
                        _SliderCard(
                          title: 'Max số copy đồng thời',
                          subtitle:
                              'Giới hạn số provider bạn có thể copy cùng lúc',
                          valueLabel: '${settings.maxCopiesActive}',
                          value: settings.maxCopiesActive.toDouble(),
                          min: 1,
                          max: 10,
                          divisions: 9,
                          color: _settingsPrimary,
                          onChanged: (value) => _update(
                            settings.copyWith(maxCopiesActive: value.round()),
                          ),
                        ),
                        _CircuitBreakerCard(
                          enabled: settings.enableCircuitBreaker,
                          threshold: settings.circuitBreakerThreshold,
                          onToggle: () => _update(
                            settings.copyWith(
                              enableCircuitBreaker:
                                  !settings.enableCircuitBreaker,
                            ),
                          ),
                          onThresholdChanged: (value) => _update(
                            settings.copyWith(circuitBreakerThreshold: value),
                          ),
                        ),
                      ],
                    ),
                    _SettingsSection(
                      label: 'Thông báo',
                      accent: _settingsPrimary,
                      children: [
                        _NotificationRow(
                          id: 'newTrades',
                          label: 'Trades mới',
                          description:
                              'Thông báo mỗi khi provider mở/đóng lệnh',
                          value: settings.notifyNewTrades,
                          onChanged: (value) => _update(
                            settings.copyWith(notifyNewTrades: value),
                          ),
                        ),
                        _NotificationRow(
                          id: 'pnlChanges',
                          label: 'Thay đổi P/L',
                          description: 'Cảnh báo khi P/L thay đổi >5%',
                          value: settings.notifyPnlChanges,
                          onChanged: (value) => _update(
                            settings.copyWith(notifyPnlChanges: value),
                          ),
                        ),
                        _NotificationRow(
                          id: 'riskAlerts',
                          label: 'Cảnh báo rủi ro',
                          description:
                              'Provider gần stop-loss hoặc có drawdown lớn',
                          value: settings.notifyRiskAlerts,
                          onChanged: (value) => _update(
                            settings.copyWith(notifyRiskAlerts: value),
                          ),
                        ),
                        _NotificationRow(
                          id: 'providerUpdates',
                          label: 'Cập nhật provider',
                          description:
                              'Thông báo khi provider thay đổi chiến lược',
                          value: settings.notifyProviderUpdates,
                          onChanged: (value) => _update(
                            settings.copyWith(notifyProviderUpdates: value),
                          ),
                        ),
                        const _SectionDivider(),
                        Row(
                          children: [
                            Expanded(
                              child: _ChannelButton(
                                key: CopySettingsPage.emailChannelKey,
                                icon: Icons.mail_outline_rounded,
                                label: 'Email',
                                active: settings.emailNotifications,
                                onTap: () => _update(
                                  settings.copyWith(
                                    emailNotifications:
                                        !settings.emailNotifications,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _ChannelButton(
                                key: CopySettingsPage.pushChannelKey,
                                icon: Icons.notifications_none_rounded,
                                label: 'Push',
                                active: settings.pushNotifications,
                                onTap: () => _update(
                                  settings.copyWith(
                                    pushNotifications:
                                        !settings.pushNotifications,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    _SettingsSection(
                      label: 'Liên hệ khẩn cấp',
                      accent: AppColors.warn,
                      children: [
                        _EmergencyContactCard(
                          email: settings.emergencyContact,
                          phone: settings.emergencyPhone,
                          onEmailChanged: (value) => _update(
                            settings.copyWith(emergencyContact: value),
                          ),
                          onPhoneChanged: (value) =>
                              _update(settings.copyWith(emergencyPhone: value)),
                        ),
                      ],
                    ),
                    _SettingsSection(
                      label: 'Quyền riêng tư',
                      accent: AppColors.text3,
                      children: [
                        _PrivacyCard(
                          active: settings.showPortfolioPublic,
                          onChanged: (value) => _update(
                            settings.copyWith(showPortfolioPublic: value),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    _SaveButton(
                      saved: _saved,
                      onTap: () {
                        final result = controller.save(settings);
                        _update(result.settings);
                        setState(() => _saved = result.status == 'saved');
                        _savedTimer?.cancel();
                        _savedTimer = Timer(const Duration(seconds: 2), () {
                          if (mounted) setState(() => _saved = false);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _update(TradeCopySettings settings) {
    setState(() {
      _settings = settings;
      _saved = false;
    });
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.label,
    required this.accent,
    required this.children,
    this.showAccent = true,
  });

  final String label;
  final Color accent;
  final List<Widget> children;
  final bool showAccent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (showAccent) ...[
                Container(
                  width: 4,
                  height: 14,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(width: 7),
              ] else
                const SizedBox(width: 10),
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          for (final child in children) ...[
            child,
            if (child != children.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({required this.selected, required this.onChanged});

  final TradeCopySettingsMode selected;
  final ValueChanged<TradeCopySettingsMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      height: 84,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Copy Mode mặc định', style: _cardTitleStyle()),
          const Spacer(),
          Row(
            children: [
              for (final mode in TradeCopySettingsMode.values) ...[
                Expanded(
                  child: _ModeButton(
                    mode: mode,
                    active: selected == mode,
                    onTap: () => onChanged(mode),
                  ),
                ),
                if (mode != TradeCopySettingsMode.values.last)
                  const SizedBox(width: 9),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.mode,
    required this.active,
    required this.onTap,
  });

  final TradeCopySettingsMode mode;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: CopySettingsPage.modeKey(mode),
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _settingsPrimary
              : AppColors.bg.withValues(alpha: .56),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          _modeLabel(mode),
          style: AppTextStyles.caption.copyWith(
            color: active ? AppColors.onAccent : AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _SliderCard extends StatelessWidget {
  const _SliderCard({
    required this.title,
    required this.valueLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.color,
    required this.onChanged,
    this.subtitle,
    this.caption,
  });

  final String title;
  final String valueLabel;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final Color color;
  final ValueChanged<double> onChanged;
  final String? subtitle;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final hasSubtext = subtitle != null || caption != null;

    return _SettingsCard(
      height: hasSubtext ? 93 : 76,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: _cardTitleStyle()),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontSize: 9,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                valueLabel,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontSize: 14,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const Spacer(),
          _CompactSlider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            color: color,
            onChanged: onChanged,
          ),
          if (caption != null) ...[
            const SizedBox(height: 6),
            Text(
              caption!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 9,
                height: 1,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CircuitBreakerCard extends StatelessWidget {
  const _CircuitBreakerCard({
    required this.enabled,
    required this.threshold,
    required this.onToggle,
    required this.onThresholdChanged,
  });

  final bool enabled;
  final double threshold;
  final VoidCallback onToggle;
  final ValueChanged<double> onThresholdChanged;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      height: enabled ? 122 : 72,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: _settingsPrimary, size: 16),
              const SizedBox(width: 7),
              Expanded(
                child: Text('Circuit Breaker', style: _cardTitleStyle()),
              ),
              _ToggleSwitch(
                key: CopySettingsPage.circuitBreakerKey,
                value: enabled,
                onChanged: (_) => onToggle(),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            'Tự động dừng TẤT CẢ copy khi tổng portfolio lỗ quá X%',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1,
            ),
          ),
          if (enabled) ...[
            const Spacer(),
            Row(
              children: [
                Text(
                  'Ngưỡng kích hoạt',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 10,
                    height: 1,
                  ),
                ),
                const Spacer(),
                Text(
                  '-${threshold.toStringAsFixed(0)}%',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.sell,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _CompactSlider(
              value: threshold,
              min: 10,
              max: 50,
              divisions: 8,
              color: AppColors.sell,
              onChanged: onThresholdChanged,
            ),
          ],
        ],
      ),
    );
  }
}

class _CompactSlider extends StatelessWidget {
  const _CompactSlider({
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.color,
    required this.onChanged,
  });

  final double value;
  final double min;
  final double max;
  final int divisions;
  final Color color;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 6,
          activeTrackColor: color,
          inactiveTrackColor: _sliderInactive,
          thumbColor: color,
          overlayColor: AppColors.transparent,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
          overlayShape: SliderComponentShape.noOverlay,
        ),
        child: Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({
    required this.id,
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final String id;
  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      height: 56,
      padding: const EdgeInsets.fromLTRB(12, 9, 12, 9),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: _cardTitleStyle()),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 9,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _ToggleSwitch(
            key: CopySettingsPage.notificationKey(id),
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 48,
        height: 26,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? _settingsPrimary : AppColors.surface3,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Align(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: AppColors.onAccent,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: AppColors.cardBorder);
  }
}

class _ChannelButton extends StatelessWidget {
  const _ChannelButton({
    super.key,
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: active
              ? _settingsPrimary.withValues(alpha: .08)
              : AppColors.transparent,
          border: Border.all(
            color: active ? _settingsPrimary : AppColors.cardBorder,
          ),
          borderRadius: AppRadii.inputRadius,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: active ? _settingsPrimary : AppColors.text3,
              size: 15,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: active ? _settingsPrimary : AppColors.text2,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmergencyContactCard extends StatelessWidget {
  const _EmergencyContactCard({
    required this.email,
    required this.phone,
    required this.onEmailChanged,
    required this.onPhoneChanged,
  });

  final String email;
  final String phone;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPhoneChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warn08,
        border: Border.all(color: AppColors.warn15),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.warn,
                size: 15,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Người liên hệ khẩn cấp sẽ được thông báo nếu tài khoản của bạn có hoạt động bất thường hoặc kích hoạt circuit breaker.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.warn,
                    fontSize: 10,
                    fontWeight: AppTextStyles.medium,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          _SettingsTextField(
            label: 'Email',
            initialValue: email,
            hint: 'emergency@example.com',
            keyboardType: TextInputType.emailAddress,
            onChanged: onEmailChanged,
          ),
          const SizedBox(height: 10),
          _SettingsTextField(
            label: 'Số điện thoại',
            initialValue: phone,
            hint: '+84 xxx xxx xxx',
            keyboardType: TextInputType.phone,
            onChanged: onPhoneChanged,
          ),
        ],
      ),
    );
  }
}

class _SettingsTextField extends StatelessWidget {
  const _SettingsTextField({
    required this.label,
    required this.initialValue,
    required this.hint,
    required this.keyboardType,
    required this.onChanged,
  });

  final String label;
  final String initialValue;
  final String hint;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 10,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontSize: 12,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
            ),
            filled: true,
            fillColor: _settingsInput,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: AppRadii.inputRadius,
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadii.inputRadius,
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadii.inputRadius,
              borderSide: const BorderSide(color: _settingsPrimary),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrivacyCard extends StatelessWidget {
  const _PrivacyCard({required this.active, required this.onChanged});

  final bool active;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      height: 84,
      child: Row(
        children: [
          Icon(
            active ? Icons.visibility_rounded : Icons.visibility_off_rounded,
            color: active ? _settingsPrimary : AppColors.text3,
            size: 15,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hiển thị portfolio công khai', style: _cardTitleStyle()),
                const SizedBox(height: 5),
                Text(
                  'Cho phép người khác xem portfolio copy của bạn (không hiện số tiền cụ thể)',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 9,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _ToggleSwitch(value: active, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.saved, required this.onTap});

  final bool saved;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: CopySettingsPage.saveKey,
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: AppSpacing.inputHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: saved ? AppColors.buy : _settingsPrimary,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              saved ? Icons.shield_rounded : Icons.settings_rounded,
              color: AppColors.onAccent,
              size: 16,
            ),
            const SizedBox(width: 9),
            Text(
              saved ? 'Đã lưu!' : 'Lưu cài đặt',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.onAccent,
                fontSize: 14,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.child,
    required this.height,
    this.padding = const EdgeInsets.all(12),
  });

  final Widget child;
  final double height;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: _settingsPanel,
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

TextStyle _cardTitleStyle() {
  return AppTextStyles.caption.copyWith(
    color: AppColors.text1,
    fontSize: 12,
    fontWeight: AppTextStyles.bold,
    height: 1.15,
  );
}

String _modeLabel(TradeCopySettingsMode mode) {
  return switch (mode) {
    TradeCopySettingsMode.mirror => 'Mirror',
    TradeCopySettingsMode.fixed => 'Fixed',
    TradeCopySettingsMode.smart => 'Smart',
  };
}
