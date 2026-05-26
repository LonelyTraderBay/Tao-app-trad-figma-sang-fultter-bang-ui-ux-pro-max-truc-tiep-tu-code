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
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/features/profile/data/profile_repository.dart';

const _devicesBackground = AppColors.bg;
const _devicesPanel = AppColors.surface;
const _devicesPanel3 = AppColors.surface3;
const _devicesBorder = AppColors.cardBorder;
const _devicesDivider = AppColors.divider;
const _devicesPrimary = AppColors.primary;
const _devicesGreen = AppColors.buy;
const _devicesAmber = AppColors.warn;
const _devicesRed = AppColors.sell;
const _devicesMuted = AppColors.text3;

class DeviceManagementPage extends ConsumerStatefulWidget {
  const DeviceManagementPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc165_devices_content');
  static const summaryKey = Key('sc165_devices_summary');
  static const logoutAllKey = Key('sc165_devices_logout_all');

  static Key deviceCardKey(String id) => Key('sc165_device_card_$id');
  static Key trustKey(String id) => Key('sc165_device_trust_$id');
  static Key logoutKey(String id) => Key('sc165_device_logout_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DeviceManagementPage> createState() =>
      _DeviceManagementPageState();
}

class _DeviceManagementPageState extends ConsumerState<DeviceManagementPage> {
  bool _initialized = false;
  List<ProfileManagedDevice> _devices = const [];

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(profileRepositoryProvider).getDeviceManagement();
    _initializeFrom(snapshot);

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 126
            : DeviceMetrics.nativeBottomChrome + 32) +
        MediaQuery.paddingOf(context).bottom;
    final currentDevice = _currentDevice;
    final otherDevices = _otherDevices;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-165 DeviceManagementPage',
      child: Material(
        color: _devicesBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Qu\u1EA3n l\u00FD thi\u1EBFt b\u1ECB',
              subtitle: 'B\u1EA3o m\u1EADt \u00B7 Profile',
              showBack: true,
              onBack: _close,
            ),
            Expanded(
              child: SingleChildScrollView(
                key: DeviceManagementPage.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SecuritySummaryCard(
                      totalDevices: _devices.length,
                      trustedCount: _trustedCount,
                      untrustedCount: _untrustedCount,
                      activeCount: _activeCount,
                    ),
                    const SizedBox(height: 27),
                    if (currentDevice != null) ...[
                      const _SectionHeader(
                        label: 'THI\u1EBET B\u1ECA HI\u1EC6N T\u1EA0I',
                      ),
                      const SizedBox(height: 10),
                      _DeviceCard(
                        device: currentDevice,
                        showActions: false,
                        onToggleTrust: () {},
                        onLogout: () {},
                      ),
                      const SizedBox(height: 26),
                    ],
                    _OtherDevicesHeader(
                      count: otherDevices.length,
                      onLogoutAll: otherDevices.isEmpty ? null : _logoutAll,
                    ),
                    const SizedBox(height: 10),
                    for (final device in otherDevices) ...[
                      _DeviceCard(
                        device: device,
                        showActions: true,
                        onToggleTrust: () => _toggleTrust(device.id),
                        onLogout: () => _logoutDevice(device.id),
                      ),
                      if (device != otherDevices.last)
                        const SizedBox(height: 13),
                    ],
                    const SizedBox(height: 27),
                    _SecuritySummaryCard(
                      totalDevices: _devices.length,
                      trustedCount: _trustedCount,
                      untrustedCount: _untrustedCount,
                      activeCount: _activeCount,
                      compactBorder: true,
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

  ProfileManagedDevice? get _currentDevice {
    for (final device in _devices) {
      if (device.isCurrent) return device;
    }
    return null;
  }

  List<ProfileManagedDevice> get _otherDevices =>
      _devices.where((device) => !device.isCurrent).toList(growable: false);

  int get _trustedCount => _devices.where((device) => device.isTrusted).length;
  int get _untrustedCount =>
      _devices.where((device) => !device.isTrusted).length;
  int get _activeCount => _devices.where((device) => device.isCurrent).length;

  void _initializeFrom(ProfileDeviceManagementSnapshot snapshot) {
    if (_initialized) return;
    _devices = List<ProfileManagedDevice>.of(snapshot.devices);
    _initialized = true;
  }

  void _toggleTrust(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      _devices = [
        for (final device in _devices)
          if (device.id == id)
            device.copyWith(isTrusted: !device.isTrusted)
          else
            device,
      ];
    });
  }

  void _logoutDevice(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      _devices = _devices.where((device) => device.id != id).toList();
    });
  }

  void _logoutAll() {
    HapticFeedback.selectionClick();
    setState(() {
      _devices = _devices.where((device) => device.isCurrent).toList();
    });
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.profile);
  }
}

class _SecuritySummaryCard extends StatelessWidget {
  const _SecuritySummaryCard({
    required this.totalDevices,
    required this.trustedCount,
    required this.untrustedCount,
    required this.activeCount,
    this.compactBorder = false,
  });

  final int totalDevices;
  final int trustedCount;
  final int untrustedCount;
  final int activeCount;
  final bool compactBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: compactBorder ? null : DeviceManagementPage.summaryKey,
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      decoration: BoxDecoration(
        color: _devicesPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(
          color: compactBorder ? _devicesBorder : AppColors.primary20,
        ),
        gradient: const RadialGradient(
          center: Alignment(.82, -.85),
          radius: 1.2,
          colors: [AppColors.primary12, _devicesPanel],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary15,
                  borderRadius: AppRadii.lgRadius,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.shield_outlined,
                  color: _devicesPrimary,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'B\u1EA3o m\u1EADt thi\u1EBFt b\u1ECB',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '$totalDevices thi\u1EBFt b\u1ECB \u0111\u00E3 \u0111\u0103ng nh\u1EADp',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontSize: 12,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SummaryStat(
                  label: 'Tin c\u1EADy',
                  value: '$trustedCount',
                  color: _devicesGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryStat(
                  label: 'Kh\u00F4ng tin c\u1EADy',
                  value: '$untrustedCount',
                  color: _devicesAmber,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryStat(
                  label: '\u0110ang ho\u1EA1t \u0111\u1ED9ng',
                  value: '$activeCount',
                  color: _devicesPrimary,
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
    return Container(
      height: 58,
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 8),
      decoration: BoxDecoration(
        color: _devicesPanel3.withValues(alpha: .82),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: _devicesMuted,
              fontSize: 10,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text2,
        fontSize: 12,
        fontWeight: FontWeight.w900,
        height: 1,
      ),
    );
  }
}

class _OtherDevicesHeader extends StatelessWidget {
  const _OtherDevicesHeader({required this.count, required this.onLogoutAll});

  final int count;
  final VoidCallback? onLogoutAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SectionHeader(
            label: 'C\u00C1C THI\u1EBET B\u1ECA KH\u00C1C ($count)',
          ),
        ),
        GestureDetector(
          key: DeviceManagementPage.logoutAllKey,
          onTap: onLogoutAll,
          behavior: HitTestBehavior.opaque,
          child: Opacity(
            opacity: onLogoutAll == null ? .45 : 1,
            child: Text(
              '\u0110\u0103ng xu\u1EA5t t\u1EA5t c\u1EA3',
              style: AppTextStyles.micro.copyWith(
                color: _devicesRed,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({
    required this.device,
    required this.showActions,
    required this.onToggleTrust,
    required this.onLogout,
  });

  final ProfileManagedDevice device;
  final bool showActions;
  final VoidCallback onToggleTrust;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final suspicious = !device.isTrusted && !device.isCurrent;
    final accent = suspicious ? _devicesAmber : _devicesPrimary;

    return Container(
      key: DeviceManagementPage.deviceCardKey(device.id),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: suspicious
            ? _devicesAmber.withValues(alpha: .05)
            : _devicesPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(
          color: suspicious
              ? _devicesAmber.withValues(alpha: .42)
              : _devicesBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: .14),
                  borderRadius: AppRadii.lgRadius,
                ),
                alignment: Alignment.center,
                child: Icon(_deviceIcon(device.type), color: accent, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DeviceDetails(device: device, suspicious: suspicious),
              ),
            ],
          ),
          if (showActions) ...[
            const SizedBox(height: 14),
            const Divider(height: 1, color: _devicesDivider),
            const SizedBox(height: 13),
            Row(
              children: [
                Expanded(
                  child: _TrustButton(device: device, onTap: onToggleTrust),
                ),
                const SizedBox(width: 9),
                _LogoutButton(deviceId: device.id, onTap: onLogout),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DeviceDetails extends StatelessWidget {
  const _DeviceDetails({required this.device, required this.suspicious});

  final ProfileManagedDevice device;
  final bool suspicious;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                device.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
            if (device.isCurrent) ...[
              const SizedBox(width: 8),
              const _TinyPill(
                label: 'Hi\u1EC7n t\u1EA1i',
                color: _devicesGreen,
              ),
            ],
            if (suspicious) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.warning_amber_rounded,
                color: _devicesAmber,
                size: 15,
              ),
            ],
          ],
        ),
        const SizedBox(height: 7),
        Text(
          '${device.browser} \u2022 ${device.os}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 11,
          runSpacing: 5,
          children: [
            _MetaItem(
              icon: Icons.location_on_outlined,
              value: _locationLabel(device.location),
            ),
            _MetaItem(
              icon: Icons.access_time_rounded,
              value: _lastActiveLabel(device.lastActive),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Text(
          'IP: ${device.ip}',
          style: AppTextStyles.micro.copyWith(
            color: _devicesMuted,
            fontSize: 11,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: _devicesMuted, size: 12),
        const SizedBox(width: 4),
        Text(
          value,
          style: AppTextStyles.micro.copyWith(
            color: _devicesMuted,
            fontSize: 11,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _TrustButton extends StatelessWidget {
  const _TrustButton({required this.device, required this.onTap});

  final ProfileManagedDevice device;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final trusted = device.isTrusted;
    final color = trusted ? _devicesGreen : _devicesAmber;

    return GestureDetector(
      key: DeviceManagementPage.trustKey(device.id),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppSpacing.buttonCompact,
        decoration: BoxDecoration(
          color: color.withValues(alpha: .12),
          borderRadius: AppRadii.cardRadius,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              trusted ? Icons.shield_outlined : Icons.warning_amber_rounded,
              color: color,
              size: 14,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                trusted
                    ? 'Tin c\u1EADy'
                    : '\u0110\u00E1nh d\u1EA5u tin c\u1EADy',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.deviceId, required this.onTap});

  final String deviceId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: DeviceManagementPage.logoutKey(deviceId),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppSpacing.buttonCompact,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.sell10,
          borderRadius: AppRadii.cardRadius,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.delete_outline_rounded,
              color: _devicesRed,
              size: 15,
            ),
            const SizedBox(width: 6),
            Text(
              '\u0110\u0103ng xu\u1EA5t',
              style: AppTextStyles.micro.copyWith(
                color: _devicesRed,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TinyPill extends StatelessWidget {
  const _TinyPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

IconData _deviceIcon(String type) {
  return switch (type) {
    'mobile' => Icons.phone_iphone_rounded,
    'tablet' => Icons.tablet_mac_rounded,
    _ => Icons.desktop_windows_outlined,
  };
}

String _locationLabel(String value) {
  return switch (value) {
    'Ho Chi Minh, VN' => 'H\u1ED3 Ch\u00ED Minh, VN',
    'Ha Noi, VN' => 'H\u00E0 N\u1ED9i, VN',
    _ => value,
  };
}

String _lastActiveLabel(String value) {
  return switch (value) {
    'Dang hoat dong' => '\u0110ang ho\u1EA1t \u0111\u1ED9ng',
    '2 gio truoc' => '2 gi\u1EDD tr\u01B0\u1EDBc',
    '3 ngay truoc' => '3 ng\u00E0y tr\u01B0\u1EDBc',
    '5 ngay truoc' => '5 ng\u00E0y tr\u01B0\u1EDBc',
    _ => value,
  };
}
