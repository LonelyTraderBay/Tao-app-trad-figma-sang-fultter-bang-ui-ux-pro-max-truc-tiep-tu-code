import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/trade_repository.dart';

const _securityBg = Color(0xFF080C14);
const _securitySurface = Color(0xFF151A23);
const _securitySurface2 = Color(0xFF1D2436);
const _securityBlue = Color(0xFF3B82F6);
const _securityGreen = Color(0xFF10B981);
const _securityAmber = Color(0xFFF59E0B);
const _securityRed = Color(0xFFEF4444);

class BotSecuritySettingsPage extends ConsumerStatefulWidget {
  const BotSecuritySettingsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc122_bot_security_settings_content');
  static const twoFaToggleKey = Key('sc122_bot_security_settings_2fa_toggle');
  static const createApiKeyKey = Key(
    'sc122_bot_security_settings_create_api_key',
  );
  static const addIpKey = Key('sc122_bot_security_settings_add_ip');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotSecuritySettingsPage> createState() =>
      _BotSecuritySettingsPageState();
}

class _BotSecuritySettingsPageState
    extends ConsumerState<BotSecuritySettingsPage> {
  late bool _twoFaEnabled;

  @override
  void initState() {
    super.initState();
    _twoFaEnabled = ref
        .read(tradeRepositoryProvider)
        .getBotSecuritySettings()
        .twoFaEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeRepositoryProvider)
        .getBotSecuritySettings();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 28
            : DeviceMetrics.nativeBottomChrome + 24) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-122 BotSecuritySettingsPage',
      child: Material(
        color: _securityBg,
        child: Column(
          children: [
            VitHeader(
              title: 'Security Settings',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeBots),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: BotSecuritySettingsPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 13, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _SectionLabel('Two-Factor Authentication'),
                    const SizedBox(height: 10),
                    _TwoFaCard(
                      enabled: _twoFaEnabled,
                      onTap: () => _toggleTwoFa(snapshot),
                    ),
                    const SizedBox(height: 18),
                    const _SectionLabel('API Keys'),
                    const SizedBox(height: 10),
                    for (final key in snapshot.apiKeys) ...[
                      _ApiKeyCard(apiKey: key),
                      if (key != snapshot.apiKeys.last)
                        const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 10),
                    _DashedActionButton(
                      key: BotSecuritySettingsPage.createApiKeyKey,
                      label: 'Create New API Key',
                      icon: Icons.add_rounded,
                      onTap: () => _showApiKeySheet(context, snapshot),
                    ),
                    const SizedBox(height: 18),
                    const _SectionLabel('IP Whitelist'),
                    const SizedBox(height: 10),
                    for (final entry in snapshot.ipWhitelist) ...[
                      _IpCard(entry: entry),
                      if (entry != snapshot.ipWhitelist.last)
                        const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 10),
                    _DashedActionButton(
                      key: BotSecuritySettingsPage.addIpKey,
                      label: 'Add IP Address',
                      icon: Icons.add_rounded,
                      onTap: () => _showIpSheet(context),
                    ),
                    const SizedBox(height: 18),
                    const _SectionLabel('Recent Activity'),
                    const SizedBox(height: 10),
                    _ActivityCard(activities: snapshot.recentActivity),
                    const SizedBox(height: 18),
                    _SecurityTipsCard(tips: snapshot.securityTips),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleTwoFa(TradeBotSecuritySettingsSnapshot snapshot) {
    setState(() => _twoFaEnabled = !_twoFaEnabled);
    ref
        .read(tradeRepositoryProvider)
        .patchBotSecuritySettings(
          TradeBotSecuritySettingsDraft(twoFaEnabled: _twoFaEnabled),
        );
  }

  void _showApiKeySheet(
    BuildContext context,
    TradeBotSecuritySettingsSnapshot snapshot,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _securitySurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _ApiKeySheet(snapshot: snapshot),
    );
  }

  void _showIpSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _securitySurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const _IpSheet(),
    );
  }
}

class _TwoFaCard extends StatelessWidget {
  const _TwoFaCard({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Card(
      constraints: const BoxConstraints(minHeight: 72),
      padding: const EdgeInsets.fromLTRB(20, 16, 17, 16),
      child: Row(
        children: [
          Icon(
            Icons.smartphone_rounded,
            color: enabled ? _securityGreen : AppColors.text3,
            size: 24,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '2FA for Bot Actions',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Required for creating/deleting bots',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          _Switch(
            key: BotSecuritySettingsPage.twoFaToggleKey,
            enabled: enabled,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _ApiKeyCard extends StatelessWidget {
  const _ApiKeyCard({required this.apiKey});

  final TradeBotApiKey apiKey;

  @override
  Widget build(BuildContext context) {
    return _Card(
      constraints: const BoxConstraints(minHeight: 114),
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  apiKey.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 11),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(9, 5, 9, 5),
                      decoration: BoxDecoration(
                        color: _securityBlue.withValues(alpha: .14),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        apiKey.permissions,
                        style: AppTextStyles.micro.copyWith(
                          color: _securityBlue,
                          fontSize: 12,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Created ${apiKey.created}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontSize: 10,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'Last used: ${apiKey.lastUsed}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.delete_outline_rounded,
            color: _securityRed,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _IpCard extends StatelessWidget {
  const _IpCard({required this.entry});

  final TradeBotIpWhitelistEntry entry;

  @override
  Widget build(BuildContext context) {
    return _Card(
      constraints: const BoxConstraints(minHeight: 63),
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  entry.ip,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${entry.label} - Added ${entry.added}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.delete_outline_rounded,
            color: _securityRed,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.activities});

  final List<TradeBotSecurityActivity> activities;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      child: Column(
        children: [
          for (final activity in activities) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.action,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 12,
                          fontWeight: AppTextStyles.medium,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        activity.time,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontSize: 10,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 1),
                  decoration: BoxDecoration(
                    color:
                        activity.status ==
                            TradeBotSecurityActivityStatus.success
                        ? _securityGreen
                        : _securityAmber,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            if (activity != activities.last) ...[
              const SizedBox(height: 14),
              const Divider(color: AppColors.borderSolid, height: 1),
              const SizedBox(height: 14),
            ],
          ],
        ],
      ),
    );
  }
}

class _SecurityTipsCard extends StatelessWidget {
  const _SecurityTipsCard({required this.tips});

  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: _securitySurface2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Security Best Practices',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 17),
          for (final tip in tips) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '-',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    tip,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            if (tip != tips.last) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _DashedActionButton extends StatelessWidget {
  const _DashedActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: CustomPaint(
        painter: _DashedBorderPainter(),
        child: Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: _securityBlue, size: 18),
              const SizedBox(width: 9),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: _securityBlue,
                  fontSize: 14,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Switch extends StatelessWidget {
  const _Switch({super.key, required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        width: 48,
        height: 24,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: enabled ? _securityGreen : _securitySurface2,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Align(
          alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding, this.constraints});

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      padding: padding,
      decoration: BoxDecoration(
        color: _securitySurface,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _securityBlue,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _securityBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final radius = Radius.circular(18);
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      radius,
    ).deflate(.5);
    final path = Path()..addRRect(rect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final segment = metric.extractPath(distance, distance + 4);
        canvas.drawPath(segment, paint);
        distance += 8;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) => false;
}

class _ApiKeySheet extends StatefulWidget {
  const _ApiKeySheet({required this.snapshot});

  final TradeBotSecuritySettingsSnapshot snapshot;

  @override
  State<_ApiKeySheet> createState() => _ApiKeySheetState();
}

class _ApiKeySheetState extends State<_ApiKeySheet> {
  bool _generated = false;
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final keyText = widget.snapshot.generatedApiKeyPreview;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        24 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Create API Key',
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 18),
          const _SheetInput(label: 'Key Name', hint: 'e.g., Trading Bot Key'),
          const SizedBox(height: 14),
          Text(
            'Permissions',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Expanded(child: _PermissionChip('Read Only')),
              SizedBox(width: 8),
              Expanded(child: _PermissionChip('Trade + Read')),
            ],
          ),
          const SizedBox(height: 16),
          if (_generated)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _securityGreen.withValues(alpha: .08),
                border: Border.all(color: _securityGreen.withValues(alpha: .2)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'API Key Generated',
                    style: AppTextStyles.caption.copyWith(
                      color: _securityGreen,
                      fontSize: 12,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _securitySurface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _visible ? keyText : '********************',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontFamily: 'Roboto',
                              fontSize: 12,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() => _visible = !_visible),
                          icon: Icon(
                            _visible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.text3,
                            size: 18,
                          ),
                        ),
                        const Icon(
                          Icons.copy_rounded,
                          color: AppColors.text3,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Save this key now - you will not be able to see it again.',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              height: 44,
              child: FilledButton(
                onPressed: () => setState(() => _generated = true),
                style: FilledButton.styleFrom(
                  backgroundColor: _securityBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Generate API Key'),
              ),
            ),
        ],
      ),
    );
  }
}

class _IpSheet extends StatelessWidget {
  const _IpSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        24 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add IP to Whitelist',
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 18),
          const _SheetInput(label: 'IP Address', hint: 'e.g., 192.168.1.100'),
          const SizedBox(height: 14),
          const _SheetInput(
            label: 'Label (Optional)',
            hint: 'e.g., Home Network',
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 44,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: _securityBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Add IP Address'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetInput extends StatelessWidget {
  const _SheetInput({required this.label, required this.hint});

  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 44,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: _securitySurface2,
            border: Border.all(color: AppColors.borderSolid),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            hint,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class _PermissionChip extends StatelessWidget {
  const _PermissionChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _securitySurface2,
        border: Border.all(color: AppColors.borderSolid),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text1,
          fontSize: 12,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}
