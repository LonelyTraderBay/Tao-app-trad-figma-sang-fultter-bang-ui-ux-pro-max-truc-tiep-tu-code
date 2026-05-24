import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/profile_repository.dart';

const _securityBackground = AppColors.bg;
const _securityPanel = AppColors.surface;
const _securityPanel2 = AppColors.surface2;
const _securityBorder = AppColors.cardBorder;
const _securityDivider = AppColors.divider;
const _securityPrimary = AppColors.primary;
const _securityGreen = AppColors.buy;
const _securityAmber = AppColors.warn;
const _securityRed = AppColors.sell;
const _securityMuted = AppColors.text3;

class SecurityPage extends ConsumerStatefulWidget {
  const SecurityPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc158_security_content');
  static const scoreCardKey = Key('sc158_security_score_card');
  static const antiPhishingFieldKey = Key('sc158_security_anti_phishing_field');
  static const antiPhishingSaveKey = Key('sc158_security_anti_phishing_save');

  static Key itemKey(String id) => Key('sc158_security_item_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends ConsumerState<SecurityPage> {
  final TextEditingController _antiPhishingController = TextEditingController();
  bool _showDevices = false;
  bool _saving = false;

  @override
  void dispose() {
    _antiPhishingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(profileRepositoryProvider).getSecurity();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 58
            : DeviceMetrics.nativeBottomChrome + 24) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-158 SecurityPage',
      child: Material(
        color: _securityBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'B\u1EA3o m\u1EADt',
              subtitle: 'B\u1EA3o m\u1EADt \u00B7 Profile',
              showBack: true,
              onBack: _close,
            ),
            Expanded(
              child: SingleChildScrollView(
                key: SecurityPage.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ScoreCard(snapshot: snapshot),
                    const SizedBox(height: 18),
                    _SecurityList(
                      items: snapshot.items,
                      onItemTap: _handleItemTap,
                    ),
                    if (_showDevices) ...[
                      const SizedBox(height: 16),
                      _DeviceList(devices: snapshot.devices),
                    ],
                    const SizedBox(height: 18),
                    _AntiPhishingCard(
                      controller: _antiPhishingController,
                      saving: _saving,
                      onSave: _saveAntiPhishingCode,
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

  void _handleItemTap(ProfileSecurityItem item) {
    HapticFeedback.selectionClick();
    if (item.id == 'devices') {
      setState(() => _showDevices = !_showDevices);
      return;
    }
    if (item.route != null) {
      context.go(item.route!);
    }
  }

  Future<void> _saveAntiPhishingCode() async {
    HapticFeedback.selectionClick();
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 280));
    if (!mounted) return;
    setState(() => _saving = false);
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.profile);
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({required this.snapshot});

  final ProfileSecuritySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final scoreColor = Color(snapshot.scoreColorHex);

    return Container(
      key: SecurityPage.scoreCardKey,
      height: 140,
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      decoration: _cardDecoration(radius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                '\u0110i\u1EC3m b\u1EA3o m\u1EADt',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 13,
                  height: 1,
                ),
              ),
              const Spacer(),
              Text(
                '${snapshot.scoreLabel} (${snapshot.score}/4)',
                style: AppTextStyles.caption.copyWith(
                  color: scoreColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              for (var i = 0; i < 4; i++) ...[
                Expanded(
                  child: Container(
                    height: 7,
                    decoration: BoxDecoration(
                      color: i < snapshot.score
                          ? scoreColor
                          : AppColors.surface3,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                if (i < 3) const SizedBox(width: 8),
              ],
            ],
          ),
          const SizedBox(height: 13),
          Container(
            height: 53,
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: BoxDecoration(
              color: _securityAmber.withValues(alpha: .12),
              borderRadius: AppRadii.cardRadius,
              border: Border.all(color: _securityAmber.withValues(alpha: .28)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: _securityAmber,
                  size: 14,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'B\u1EADt t\u1EA5t c\u1EA3 t\u00EDnh n\u0103ng b\u1EA3o m\u1EADt \u0111\u1EC3 b\u1EA3o v\u1EC7 t\u00E0i s\u1EA3n c\u1EE7a b\u1EA1n\n'
                    't\u1ED1t nh\u1EA5t.',
                    style: AppTextStyles.micro.copyWith(
                      color: _securityAmber,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1.48,
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

class _SecurityList extends StatelessWidget {
  const _SecurityList({required this.items, required this.onItemTap});

  final List<ProfileSecurityItem> items;
  final ValueChanged<ProfileSecurityItem> onItemTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(radius: 16),
      child: ClipRRect(
        borderRadius: AppRadii.cardRadius,
        child: Column(
          children: [
            for (final item in items) ...[
              _SecurityRow(item: item, onTap: () => onItemTap(item)),
              if (item != items.last)
                const Divider(height: 1, color: _securityDivider),
            ],
          ],
        ),
      ),
    );
  }
}

class _SecurityRow extends StatelessWidget {
  const _SecurityRow({required this.item, required this.onTap});

  final ProfileSecurityItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = item.danger ? _securityRed : _securityPrimary;

    return GestureDetector(
      key: SecurityPage.itemKey(item.id),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: .13),
                borderRadius: AppRadii.lgRadius,
              ),
              alignment: Alignment.center,
              child: Icon(_iconFor(item.iconKey), color: accent, size: 21),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: _securityMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1.12,
                    ),
                  ),
                ],
              ),
            ),
            if (item.status != null) ...[
              const SizedBox(width: 8),
              _StatusPill(label: item.status!, color: Color(item.statusHex!)),
            ],
            const SizedBox(width: 11),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 19,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class _DeviceList extends StatelessWidget {
  const _DeviceList({required this.devices});

  final List<ProfileDevice> devices;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'THI\u1EBET B\u1ECA \u0110\u0102NG NH\u1EACP',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: _cardDecoration(radius: 16),
          child: ClipRRect(
            borderRadius: AppRadii.cardRadius,
            child: Column(
              children: [
                for (final device in devices) ...[
                  _DeviceRow(device: device),
                  if (device != devices.last)
                    const Divider(height: 1, color: _securityDivider),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DeviceRow extends StatelessWidget {
  const _DeviceRow({required this.device});

  final ProfileDevice device;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 73),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.laptop_mac_rounded,
            color: AppColors.text3,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
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
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                    ),
                    if (device.isCurrent) ...[
                      const SizedBox(width: 8),
                      _StatusPill(
                        label: 'Hi\u1EC7n t\u1EA1i',
                        color: _securityGreen,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  '${device.os} \u2022 ${device.location}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: _securityMuted,
                    fontSize: 11,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  device.lastSeen,
                  style: AppTextStyles.micro.copyWith(
                    color: _securityMuted,
                    fontSize: 11,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          if (!device.isCurrent) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: _securityRed.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                '\u0110\u0103ng xu\u1EA5t',
                style: AppTextStyles.micro.copyWith(
                  color: _securityRed,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AntiPhishingCard extends StatelessWidget {
  const _AntiPhishingCard({
    required this.controller,
    required this.saving,
    required this.onSave,
  });

  final TextEditingController controller;
  final bool saving;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.buttonHero + AppSpacing.inputHeight,
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      decoration: _cardDecoration(radius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: _securityPrimary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'M\u00E3 ch\u1ED1ng l\u1EEBa \u0111\u1EA3o',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            '\u0110\u1EB7t m\u00E3 c\u00E1 nh\u00E2n. Email t\u1EEB VitTrade s\u1EBD lu\u00F4n hi\u1EC3n th\u1ECB m\u00E3 n\u00E0y.',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              height: 1,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: AppSpacing.inputHeight,
            decoration: BoxDecoration(
              color: _securityPanel2,
              borderRadius: AppRadii.cardLargeRadius,
              border: Border.all(color: AppColors.borderSolid),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: SecurityPage.antiPhishingFieldKey,
                    controller: controller,
                    maxLength: 8,
                    cursorColor: _securityPrimary,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                      fontSize: 14,
                      height: 1,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      isCollapsed: true,
                      contentPadding: const EdgeInsets.only(left: 17),
                      hintText: 'Nh\u1EADp m\u00E3 4\u20138 k\u00FD t\u1EF1',
                      hintStyle: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  key: SecurityPage.antiPhishingSaveKey,
                  onTap: saving ? null : onSave,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 50,
                    height: 30,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: _securityPrimary,
                      borderRadius: AppRadii.cardRadius,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      saving ? '...' : 'L\u01B0u',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
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

BoxDecoration _cardDecoration({required double radius}) {
  return BoxDecoration(
    color: _securityPanel,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: _securityBorder),
  );
}

IconData _iconFor(String key) {
  return switch (key) {
    'phone' => Icons.phone_android_rounded,
    'key' => Icons.key_rounded,
    'shield' => Icons.shield_outlined,
    'laptop' => Icons.laptop_mac_rounded,
    'activity' => Icons.monitor_heart_outlined,
    _ => Icons.circle_outlined,
  };
}
