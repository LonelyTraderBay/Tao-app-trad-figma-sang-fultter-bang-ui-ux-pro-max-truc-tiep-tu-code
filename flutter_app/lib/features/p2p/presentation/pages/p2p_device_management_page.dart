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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part '../widgets/p2p_device_management_overview.dart';
part '../widgets/p2p_device_management_cards.dart';
part '../widgets/p2p_device_management_tips.dart';

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
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Quản lý thiết bị',
            subtitle: 'Bảo mật · P2P',
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: RefreshIndicator(
                  color: AppModuleAccents.p2p,
                  backgroundColor: AppColors.surface2,
                  onRefresh: () async {
                    HapticFeedback.selectionClick();
                    await Future<void>.delayed(
                      const Duration(milliseconds: 120),
                    );
                  },
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: AppSpacing.p2pSecurityDetailsScrollPadding(
                        bottomInset,
                      ),
                      child: VitPageContent(
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        customGap: 0,
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
                            title:
                                'Thiết bị tin cậy (${trustedDevices.length})',
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
                          const SizedBox(height: AppSpacing.x3),
                          const VitCard(
                            variant: VitCardVariant.inner,
                            padding: AppSpacing.p2pSecurityDetailsInnerPadding,
                            child: VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Trusted device review',
                              message:
                                  'Trusted status, revoke/remove action, device evidence, security risk and next verification step are reviewed before device changes.',
                              contractId: 'p2p-device-management-review',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
