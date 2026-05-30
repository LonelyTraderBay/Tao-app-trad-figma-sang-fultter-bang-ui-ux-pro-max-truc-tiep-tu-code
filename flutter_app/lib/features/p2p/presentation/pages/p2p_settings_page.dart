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
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

class P2PSettingsPage extends ConsumerStatefulWidget {
  const P2PSettingsPage({super.key, this.shellRenderMode});

  static const tradeOptionsKey = Key('sc279_p2p_settings_trade_options');
  static const notificationsKey = Key('sc279_p2p_settings_notifications');
  static const privacyKey = Key('sc279_p2p_settings_privacy');
  static const securityKey = Key('sc279_p2p_settings_security');
  static const hoursKey = Key('sc279_p2p_settings_hours');
  static const autoReplyKey = Key('sc279_p2p_settings_auto_reply');
  static const saveKey = Key('sc279_p2p_settings_save');
  static const blacklistKey = Key('sc279_p2p_settings_blacklist');
  static const trustedDevicesKey = Key('sc279_p2p_settings_devices');

  static Key optionKey(String group, String id) =>
      Key('sc279_p2p_settings_${group}_$id');

  static Key toggleKey(String id) => Key('sc279_p2p_settings_toggle_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PSettingsPage> createState() => _P2PSettingsPageState();
}

class _P2PSettingsPageState extends ConsumerState<P2PSettingsPage> {
  final Map<String, bool> _toggles = {};
  late String _asset;
  late String _currency;
  late String _paymentWindow;
  String _hoursMode = '247';
  bool _saved = false;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pSettingsProvider);
    _ensureState(snapshot);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-279 P2PSettingsPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SectionLabel(
                        icon: Icons.tune_rounded,
                        label: 'Tùy chọn giao dịch',
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      _TradeOptionsCard(
                        snapshot: snapshot,
                        asset: _asset,
                        currency: _currency,
                        paymentWindow: _paymentWindow,
                        autoConfirm: _toggles['auto_confirm'] ?? false,
                        onAsset: (value) => setState(() => _asset = value),
                        onCurrency: (value) =>
                            setState(() => _currency = value),
                        onPaymentWindow: (value) =>
                            setState(() => _paymentWindow = value),
                        onToggleAutoConfirm: () => _toggle('auto_confirm'),
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _ToggleSection(
                        key: P2PSettingsPage.notificationsKey,
                        icon: Icons.notifications_none_rounded,
                        label: 'Thông báo',
                        color: AppColors.warn,
                        toggles: snapshot.notificationToggles,
                        values: _toggles,
                        onToggle: _toggle,
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _ToggleSection(
                        key: P2PSettingsPage.privacyKey,
                        icon: Icons.visibility_outlined,
                        label: 'Quyền riêng tư',
                        color: AppColors.accent,
                        toggles: snapshot.privacyToggles,
                        values: _toggles,
                        onToggle: _toggle,
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _SecuritySection(
                        snapshot: snapshot,
                        values: _toggles,
                        onToggle: _toggle,
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _HoursSection(
                        mode: _hoursMode,
                        onChanged: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _hoursMode = value);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _AutoReplySection(
                        autoReply: snapshot.autoReply,
                        enabled: _toggles['auto_reply'] ?? true,
                        onToggle: () => _toggle('auto_reply'),
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      VitCtaButton(
                        key: P2PSettingsPage.saveKey,
                        variant: _saved
                            ? VitCtaButtonVariant.success
                            : VitCtaButtonVariant.primary,
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          setState(() => _saved = true);
                        },
                        child: Text(
                          _saved ? 'Đã lưu thành công!' : 'Lưu cài đặt',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _ensureState(P2PSettingsSnapshot snapshot) {
    if (_initialized) return;
    _asset = snapshot.defaultAsset;
    _currency = snapshot.defaultCurrency;
    _paymentWindow = snapshot.defaultPaymentWindow;
    _toggles['auto_confirm'] = false;
    _toggles['auto_reply'] = snapshot.autoReply.enabled;
    for (final toggle in [
      ...snapshot.notificationToggles,
      ...snapshot.privacyToggles,
      ...snapshot.securityToggles,
    ]) {
      _toggles[toggle.id] = toggle.enabled;
    }
    _initialized = true;
  }

  void _toggle(String id) {
    HapticFeedback.selectionClick();
    setState(() => _toggles[id] = !(_toggles[id] ?? false));
  }
}

class _TradeOptionsCard extends StatelessWidget {
  const _TradeOptionsCard({
    required this.snapshot,
    required this.asset,
    required this.currency,
    required this.paymentWindow,
    required this.autoConfirm,
    required this.onAsset,
    required this.onCurrency,
    required this.onPaymentWindow,
    required this.onToggleAutoConfirm,
  });

  final P2PSettingsSnapshot snapshot;
  final String asset;
  final String currency;
  final String paymentWindow;
  final bool autoConfirm;
  final ValueChanged<String> onAsset;
  final ValueChanged<String> onCurrency;
  final ValueChanged<String> onPaymentWindow;
  final VoidCallback onToggleAutoConfirm;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PSettingsPage.tradeOptionsKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _OptionGroup(
            group: 'asset',
            label: 'Tài sản mặc định',
            values: snapshot.assetOptions,
            selected: asset,
            onChanged: onAsset,
          ),
          const SizedBox(height: AppSpacing.x4),
          _OptionGroup(
            group: 'currency',
            label: 'Tiền tệ mặc định',
            values: snapshot.currencyOptions,
            selected: currency,
            onChanged: onCurrency,
          ),
          const SizedBox(height: AppSpacing.x4),
          _OptionGroup(
            group: 'window',
            label: 'Thời gian thanh toán mặc định',
            values: snapshot.paymentWindows,
            selected: paymentWindow,
            suffix: ' phút',
            expanded: true,
            onChanged: onPaymentWindow,
          ),
          const SizedBox(height: AppSpacing.x4),
          _SettingToggleRow(
            toggle: const P2PSettingsToggleDraft(
              id: 'auto_confirm',
              label: 'Tự động xác nhận',
              description: 'Tắt - xác nhận thủ công',
              iconKey: 'wallet',
              toneKey: 'success',
              enabled: false,
            ),
            value: autoConfirm,
            onToggle: onToggleAutoConfirm,
            last: true,
          ),
        ],
      ),
    );
  }
}

class _OptionGroup extends StatelessWidget {
  const _OptionGroup({
    required this.group,
    required this.label,
    required this.values,
    required this.selected,
    required this.onChanged,
    this.suffix = '',
    this.expanded = false,
  });

  final String group;
  final String label;
  final List<String> values;
  final String selected;
  final ValueChanged<String> onChanged;
  final String suffix;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final children = values.map((value) {
      final isSelected = value == selected;
      final chip = _OptionChip(
        group: group,
        value: value,
        label: '$value$suffix',
        selected: isSelected,
        onTap: () {
          HapticFeedback.selectionClick();
          onChanged(value);
        },
      );
      return expanded ? Expanded(child: chip) : chip;
    }).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Row(
          children: [
            for (var index = 0; index < children.length; index++) ...[
              children[index],
              if (index != children.length - 1)
                const SizedBox(width: AppSpacing.x3),
            ],
          ],
        ),
      ],
    );
  }
}

class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.group,
    required this.value,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String group;
  final String value;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PSettingsPage.optionKey(group, value),
      color: selected ? AppColors.primary12 : AppColors.surface,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? AppColors.primary40 : AppColors.transparent,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: selected ? AppColors.primary : AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToggleSection extends StatelessWidget {
  const _ToggleSection({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.toggles,
    required this.values,
    required this.onToggle,
  });

  final IconData icon;
  final String label;
  final Color color;
  final List<P2PSettingsToggleDraft> toggles;
  final Map<String, bool> values;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(icon: icon, label: label, color: color),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          child: Column(
            children: [
              for (var index = 0; index < toggles.length; index++)
                _SettingToggleRow(
                  toggle: toggles[index],
                  value: values[toggles[index].id] ?? false,
                  onToggle: () => onToggle(toggles[index].id),
                  last: index == toggles.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SecuritySection extends StatelessWidget {
  const _SecuritySection({
    required this.snapshot,
    required this.values,
    required this.onToggle,
  });

  final P2PSettingsSnapshot snapshot;
  final Map<String, bool> values;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel(
          icon: Icons.shield_outlined,
          label: 'Bảo mật giao dịch',
          color: AppColors.sell,
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          key: P2PSettingsPage.securityKey,
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          child: Column(
            children: [
              for (final toggle in snapshot.securityToggles)
                _SettingToggleRow(
                  toggle: toggle,
                  value: values[toggle.id] ?? false,
                  onToggle: () => onToggle(toggle.id),
                ),
              _NavigationRow(
                key: P2PSettingsPage.trustedDevicesKey,
                icon: Icons.smartphone_rounded,
                label: 'Thiết bị tin cậy',
                description: '3 thiết bị đã xác minh',
                color: AppColors.buy,
                onTap: () => context.go(snapshot.trustedDevicesRoute),
              ),
              _NavigationRow(
                key: P2PSettingsPage.blacklistKey,
                icon: Icons.person_remove_alt_1_outlined,
                label: 'Danh sách chặn',
                description: 'Quản lý người dùng đã chặn',
                color: AppColors.sell,
                onTap: () => context.go(snapshot.blacklistRoute),
                last: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingToggleRow extends StatelessWidget {
  const _SettingToggleRow({
    required this.toggle,
    required this.value,
    required this.onToggle,
    this.last = false,
  });

  final P2PSettingsToggleDraft toggle;
  final bool value;
  final VoidCallback onToggle;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(toggle.toneKey);
    return Container(
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
      child: Row(
        children: [
          _SettingIcon(icon: _settingsIcon(toggle.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  toggle.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  toggle.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          _SwitchButton(
            key: P2PSettingsPage.toggleKey(toggle.id),
            value: value,
            color: color,
            onTap: onToggle,
          ),
        ],
      ),
    );
  }
}

class _NavigationRow extends StatelessWidget {
  const _NavigationRow({
    super.key,
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.onTap,
    this.last = false,
  });

  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final VoidCallback onTap;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          border: last
              ? null
              : const Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
        child: Row(
          children: [
            _SettingIcon(icon: icon, color: color),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    description,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconMd,
            ),
          ],
        ),
      ),
    );
  }
}

class _HoursSection extends StatelessWidget {
  const _HoursSection({required this.mode, required this.onChanged});

  final String mode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PSettingsPage.hoursKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel(
          icon: Icons.schedule_rounded,
          label: 'Giờ giao dịch',
          color: AppColors.buy,
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.x1),
                decoration: BoxDecoration(
                  color: AppColors.surface2,
                  borderRadius: AppRadii.inputRadius,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _SegmentButton(
                        label: '24/7',
                        selected: mode == '247',
                        onTap: () => onChanged('247'),
                      ),
                    ),
                    Expanded(
                      child: _SegmentButton(
                        label: 'Tùy chỉnh',
                        selected: mode == 'custom',
                        onTap: () => onChanged('custom'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.x3),
              Text(
                mode == '247'
                    ? 'Quảng cáo của bạn hiển thị mọi lúc.'
                    : 'Quảng cáo chỉ hiển thị từ 08:00 đến 22:00 (GMT+7).',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AutoReplySection extends StatelessWidget {
  const _AutoReplySection({
    required this.autoReply,
    required this.enabled,
    required this.onToggle,
  });

  final P2PSettingsAutoReplyDraft autoReply;
  final bool enabled;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PSettingsPage.autoReplyKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel(
          icon: Icons.chat_bubble_outline_rounded,
          label: 'Tin nhắn tự động',
          color: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SettingToggleRow(
                toggle: const P2PSettingsToggleDraft(
                  id: 'auto_reply',
                  label: 'Tự động gửi tin nhắn',
                  description: 'Gửi ngay khi đối tác tạo đơn',
                  iconKey: 'message',
                  toneKey: 'primary',
                  enabled: true,
                ),
                value: enabled,
                onToggle: onToggle,
                last: true,
              ),
              if (enabled) ...[
                const SizedBox(height: AppSpacing.x3),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Mẫu tin nhắn MUA',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Sửa',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.primary,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x2),
                VitCard(
                  variant: VitCardVariant.inner,
                  padding: const EdgeInsets.all(AppSpacing.x3),
                  child: Text(
                    autoReply.buyTemplate,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.bold),
        ),
      ],
    );
  }
}

class _SettingIcon extends StatelessWidget {
  const _SettingIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Icon(icon, color: color, size: AppSpacing.iconSm),
    );
  }
}

class _SwitchButton extends StatelessWidget {
  const _SwitchButton({
    super.key,
    required this.value,
    required this.color,
    required this.onTap,
  });

  final bool value;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 44,
        height: 24,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? color : AppColors.surface2,
          border: Border.all(color: value ? color : AppColors.borderSolid),
          borderRadius: AppRadii.mdRadius,
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: const DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.onAccent,
            shape: BoxShape.circle,
          ),
          child: SizedBox(width: 18, height: 18),
        ),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary12 : AppColors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: selected ? AppColors.primary : AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

IconData _settingsIcon(String iconKey) {
  return switch (iconKey) {
    'bell' => Icons.notifications_none_rounded,
    'message' => Icons.chat_bubble_outline_rounded,
    'alert' => Icons.report_problem_outlined,
    'globe' => Icons.public_rounded,
    'volume' => Icons.volume_up_outlined,
    'eye' => Icons.visibility_outlined,
    'shield' => Icons.shield_outlined,
    'wallet' => Icons.account_balance_wallet_outlined,
    'clock' => Icons.schedule_rounded,
    'lock' => Icons.lock_outline_rounded,
    'fingerprint' => Icons.fingerprint_rounded,
    _ => Icons.tune_rounded,
  };
}

Color _toneColor(String toneKey) {
  return switch (toneKey) {
    'success' => AppColors.buy,
    'danger' => AppColors.sell,
    'accent' => AppColors.accent,
    'warning' => AppColors.warn,
    _ => AppColors.primary,
  };
}
