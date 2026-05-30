import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

class P2PDeviceManagementPage extends ConsumerStatefulWidget {
  const P2PDeviceManagementPage({super.key, this.shellRenderMode});

  static const statsKey = Key('sc255_p2p_devices_stats');
  static const infoKey = Key('sc255_p2p_devices_info');
  static const trustedSectionKey = Key('sc255_p2p_devices_trusted_section');
  static const otherSectionKey = Key('sc255_p2p_devices_other_section');
  static const tipsKey = Key('sc255_p2p_devices_tips');

  static Key deviceKey(String id) => Key('sc255_p2p_device_$id');
  static Key trustButtonKey(String id) => Key('sc255_p2p_device_trust_$id');
  static Key revokeButtonKey(String id) => Key('sc255_p2p_device_revoke_$id');
  static Key removeButtonKey(String id) => Key('sc255_p2p_device_remove_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PDeviceManagementPage> createState() =>
      _P2PDeviceManagementPageState();
}

class _P2PDeviceManagementPageState
    extends ConsumerState<P2PDeviceManagementPage> {
  late List<P2PTrustedDeviceDraft> _devices;
  String? _expandedDeviceId;

  @override
  void initState() {
    super.initState();
    final snapshot = ref.read(p2pDeviceManagementProvider);
    _devices = List.of(snapshot.devices);
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pDeviceManagementProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final trustedDevices = _devices
        .where((device) => device.isTrusted)
        .toList(growable: false);
    final otherDevices = _devices
        .where((device) => !device.isTrusted)
        .toList(growable: false);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-255 P2PDeviceManagementPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Quản lý thiết bị',
              subtitle: 'Bảo mật · P2P',
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppModuleAccents.p2p,
                backgroundColor: AppColors.surface2,
                onRefresh: () async {
                  HapticFeedback.selectionClick();
                  await Future<void>.delayed(const Duration(milliseconds: 120));
                },
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.contentPad,
                      AppSpacing.x4,
                      AppSpacing.contentPad,
                      bottomInset,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _DeviceStatsCard(
                          total: _devices.length,
                          trusted: trustedDevices.length,
                          untrusted: otherDevices.length,
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        _TrustedDeviceNotice(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x6),
                        _DeviceSection(
                          key: P2PDeviceManagementPage.trustedSectionKey,
                          title: 'Thiết bị tin cậy (${trustedDevices.length})',
                          devices: trustedDevices,
                          expandedDeviceId: _expandedDeviceId,
                          onToggleExpanded: _toggleExpanded,
                          onTrust: _trustDevice,
                          onRevoke: _revokeTrust,
                          onRemove: _removeDevice,
                        ),
                        const SizedBox(height: AppSpacing.x6),
                        _DeviceSection(
                          key: P2PDeviceManagementPage.otherSectionKey,
                          title: 'Thiết bị khác (${otherDevices.length})',
                          devices: otherDevices,
                          expandedDeviceId: _expandedDeviceId,
                          onToggleExpanded: _toggleExpanded,
                          onTrust: _trustDevice,
                          onRevoke: _revokeTrust,
                          onRemove: _removeDevice,
                        ),
                        const SizedBox(height: AppSpacing.x6),
                        _SecurityTips(tips: snapshot.securityTips),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleExpanded(String deviceId) {
    HapticFeedback.selectionClick();
    setState(() {
      _expandedDeviceId = _expandedDeviceId == deviceId ? null : deviceId;
    });
  }

  void _trustDevice(String deviceId) {
    HapticFeedback.selectionClick();
    setState(() {
      _devices = [
        for (final device in _devices)
          if (device.id == deviceId)
            device.copyWith(isTrusted: true)
          else
            device,
      ];
      _expandedDeviceId = deviceId;
    });
  }

  void _revokeTrust(String deviceId) {
    HapticFeedback.selectionClick();
    setState(() {
      _devices = [
        for (final device in _devices)
          if (device.id == deviceId)
            device.copyWith(isTrusted: false)
          else
            device,
      ];
      _expandedDeviceId = deviceId;
    });
  }

  void _removeDevice(String deviceId) {
    HapticFeedback.selectionClick();
    setState(() {
      _devices = _devices.where((device) => device.id != deviceId).toList();
      if (_expandedDeviceId == deviceId) _expandedDeviceId = null;
    });
  }
}

class _DeviceStatsCard extends StatelessWidget {
  const _DeviceStatsCard({
    required this.total,
    required this.trusted,
    required this.untrusted,
  });

  final int total;
  final int trusted;
  final int untrusted;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PDeviceManagementPage.statsKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Expanded(
            child: _DeviceStat(
              icon: Icons.desktop_windows_rounded,
              value: '$total',
              label: 'Tổng số',
              color: AppModuleAccents.p2p,
            ),
          ),
          Expanded(
            child: _DeviceStat(
              icon: Icons.shield_outlined,
              value: '$trusted',
              label: 'Tin cậy',
              color: AppColors.buy,
            ),
          ),
          Expanded(
            child: _DeviceStat(
              icon: Icons.warning_amber_rounded,
              value: '$untrusted',
              label: 'Chưa tin cậy',
              color: AppColors.warn,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceStat extends StatelessWidget {
  const _DeviceStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSpacing.inputHeight,
          height: AppSpacing.inputHeight,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .12),
            borderRadius: AppRadii.lgRadius,
          ),
          child: Icon(icon, color: color, size: AppSpacing.iconMd),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(
            color: color,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _TrustedDeviceNotice extends StatelessWidget {
  const _TrustedDeviceNotice({required this.snapshot});

  final P2PDeviceManagementSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: P2PDeviceManagementPage.infoKey,
      decoration: BoxDecoration(
        color: AppColors.primary08,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppColors.primary20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppModuleAccents.p2p,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.infoTitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppModuleAccents.p2p,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    snapshot.infoBody,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceSection extends StatelessWidget {
  const _DeviceSection({
    super.key,
    required this.title,
    required this.devices,
    required this.expandedDeviceId,
    required this.onToggleExpanded,
    required this.onTrust,
    required this.onRevoke,
    required this.onRemove,
  });

  final String title;
  final List<P2PTrustedDeviceDraft> devices;
  final String? expandedDeviceId;
  final ValueChanged<String> onToggleExpanded;
  final ValueChanged<String> onTrust;
  final ValueChanged<String> onRevoke;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        for (var index = 0; index < devices.length; index++) ...[
          _DeviceCard(
            device: devices[index],
            expanded: expandedDeviceId == devices[index].id,
            onToggleExpanded: () => onToggleExpanded(devices[index].id),
            onTrust: () => onTrust(devices[index].id),
            onRevoke: () => onRevoke(devices[index].id),
            onRemove: () => onRemove(devices[index].id),
          ),
          if (index != devices.length - 1)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({
    required this.device,
    required this.expanded,
    required this.onToggleExpanded,
    required this.onTrust,
    required this.onRevoke,
    required this.onRemove,
  });

  final P2PTrustedDeviceDraft device;
  final bool expanded;
  final VoidCallback onToggleExpanded;
  final VoidCallback onTrust;
  final VoidCallback onRevoke;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final color = _deviceColor(device);

    return VitCard(
      key: P2PDeviceManagementPage.deviceKey(device.id),
      radius: VitCardRadius.lg,
      variant: VitCardVariant.standard,
      borderColor: device.isTrusted ? null : AppColors.warningBorder,
      padding: EdgeInsets.zero,
      onTap: onToggleExpanded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DeviceIconBadge(device: device, color: color),
                const SizedBox(width: AppSpacing.x3),
                Expanded(child: _DeviceMainInfo(device: device)),
                if (!device.isTrusted && !device.isCurrent)
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warn,
                    size: AppSpacing.iconMd,
                  ),
              ],
            ),
          ),
          if (expanded)
            _ExpandedDeviceDetails(
              device: device,
              onTrust: onTrust,
              onRevoke: onRevoke,
              onRemove: onRemove,
            ),
        ],
      ),
    );
  }
}

class _DeviceIconBadge extends StatelessWidget {
  const _DeviceIconBadge({required this.device, required this.color});

  final P2PTrustedDeviceDraft device;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.inputHeight,
      height: AppSpacing.inputHeight,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Icon(_deviceIcon(device.type), color: color, size: 24),
    );
  }
}

class _DeviceMainInfo extends StatelessWidget {
  const _DeviceMainInfo({required this.device});

  final P2PTrustedDeviceDraft device;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                device.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            if (device.isCurrent) ...[
              const SizedBox(width: AppSpacing.x2),
              const _TinyBadge(label: 'Hiện tại', color: AppColors.buy),
            ],
            if (device.isTrusted && !device.isCurrent) ...[
              const SizedBox(width: AppSpacing.x2),
              const Icon(
                Icons.shield_outlined,
                color: AppModuleAccents.p2p,
                size: 14,
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          '${device.os} · ${device.browser}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x2),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x1,
          children: [
            _InlineMeta(
              icon: Icons.location_on_outlined,
              text: device.location,
            ),
            Text(
              '·',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            _InlineMeta(
              icon: Icons.access_time_rounded,
              text: device.lastActive,
            ),
          ],
        ),
      ],
    );
  }
}

class _InlineMeta extends StatelessWidget {
  const _InlineMeta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.text3, size: 11),
        const SizedBox(width: AppSpacing.x1),
        Text(text, style: AppTextStyles.micro.copyWith(color: AppColors.text3)),
      ],
    );
  }
}

class _ExpandedDeviceDetails extends StatelessWidget {
  const _ExpandedDeviceDetails({
    required this.device,
    required this.onTrust,
    required this.onRevoke,
    required this.onRemove,
  });

  final P2PTrustedDeviceDraft device;
  final VoidCallback onTrust;
  final VoidCallback onRevoke;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: _DetailValue(label: 'IP Address', value: device.ip),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: _DetailValue(
                    label: 'First Seen',
                    value: device.firstSeen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
            _DetailValue(label: 'Fingerprint', value: device.fingerprint),
            const SizedBox(height: AppSpacing.x4),
            if (device.isCurrent)
              const _CurrentDeviceMessage()
            else
              Row(
                children: [
                  Expanded(
                    child: device.isTrusted
                        ? _ActionButton(
                            key: P2PDeviceManagementPage.revokeButtonKey(
                              device.id,
                            ),
                            label: 'Hủy tin cậy',
                            icon: Icons.cancel_outlined,
                            color: AppColors.warn,
                            onTap: onRevoke,
                          )
                        : _ActionButton(
                            key: P2PDeviceManagementPage.trustButtonKey(
                              device.id,
                            ),
                            label: 'Đánh dấu tin cậy',
                            icon: Icons.shield_outlined,
                            color: AppColors.buy,
                            onTap: onTrust,
                          ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  _ActionButton(
                    key: P2PDeviceManagementPage.removeButtonKey(device.id),
                    label: 'Xóa',
                    icon: Icons.delete_outline_rounded,
                    color: AppColors.sell,
                    compact: true,
                    onTap: onRemove,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailValue extends StatelessWidget {
  const _DetailValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontFeatures: AppTextStyles.tabularFigures,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _CurrentDeviceMessage extends StatelessWidget {
  const _CurrentDeviceMessage();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.md,
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.buy,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            'Thiết bị hiện tại',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.compact = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .12),
      borderRadius: AppRadii.mdRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? AppSpacing.x4 : AppSpacing.x3,
            vertical: AppSpacing.x3,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
            children: [
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: AppRadii.smRadius,
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

class _SecurityTips extends StatelessWidget {
  const _SecurityTips({required this.tips});

  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PDeviceManagementPage.tipsKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.buy,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Mẹo bảo mật',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final tip in tips) ...[
            _TipRow(text: tip),
            if (tip != tips.last) const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  const _TipRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 5,
          height: 5,
          margin: const EdgeInsets.only(top: 7),
          decoration: const BoxDecoration(
            color: AppColors.text3,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}

Color _deviceColor(P2PTrustedDeviceDraft device) {
  if (device.isCurrent) return AppColors.buy;
  if (device.isTrusted) return AppModuleAccents.p2p;
  return AppColors.text3;
}

IconData _deviceIcon(String type) {
  return switch (type) {
    'mobile' => Icons.phone_iphone_rounded,
    'tablet' => Icons.tablet_mac_rounded,
    _ => Icons.desktop_windows_rounded,
  };
}
