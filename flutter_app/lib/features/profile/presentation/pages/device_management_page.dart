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
import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';

part '../widgets/device_management_page_sections.dart';
part '../widgets/device_management_page_common.dart';

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
    final snapshot = ref.watch(profileControllerProvider).getDeviceManagement();
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
