import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/profile_repository.dart';

const _apiBg = AppColors.bg;
const _apiSurface = AppColors.surface;
const _apiSurface2 = AppColors.surface2;
const _apiBorder = AppColors.cardBorder;
const _apiBlue = AppColors.primary;
const _apiGreen = AppColors.buy;
const _apiAmber = AppColors.warn;
const _apiRed = AppColors.sell;
const _apiMuted = AppColors.text3;

class ApiManagementPage extends ConsumerStatefulWidget {
  const ApiManagementPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc163_api_content');
  static const createKey = Key('sc163_api_create');
  static Key cardKey(String id) => Key('sc163_api_card_$id');
  static Key toggleKey(String id) => Key('sc163_api_toggle_$id');
  static Key revealKey(String id) => Key('sc163_api_reveal_$id');
  static Key deleteKey(String id) => Key('sc163_api_delete_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ApiManagementPage> createState() => _ApiManagementPageState();
}

class _ApiManagementPageState extends ConsumerState<ApiManagementPage> {
  bool _initialized = false;
  List<ProfileApiKey> _keys = const [];
  String? _showSecretId;
  String? _copiedId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(profileRepositoryProvider).getApiManagement();
    _initializeFrom(snapshot);

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 126
            : DeviceMetrics.nativeBottomChrome + 32) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-163 ApiManagementPage',
      child: Material(
        color: _apiBg,
        child: Column(
          children: [
            VitHeader(
              title: 'Qu\u1EA3n l\u00FD API',
              subtitle: 'API \u00B7 Profile',
              showBack: true,
              onBack: _close,
              trailing: _CreateButton(onTap: _createApiKey),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: ApiManagementPage.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final apiKey in _keys) ...[
                      _ApiKeyCard(
                        apiKey: apiKey,
                        showSecret: _showSecretId == apiKey.id,
                        copiedId: _copiedId,
                        onToggle: () => _toggleKey(apiKey.id),
                        onReveal: () => _toggleSecret(apiKey.id),
                        onCopy: _copyText,
                        onDelete: () => _confirmDelete(apiKey),
                      ),
                      if (apiKey != _keys.last) const SizedBox(height: 18),
                    ],
                    const SizedBox(height: 18),
                    const _ApiDocsCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _initializeFrom(ProfileApiManagementSnapshot snapshot) {
    if (_initialized) return;
    _keys = List<ProfileApiKey>.of(snapshot.keys);
    _initialized = true;
  }

  void _createApiKey() {
    HapticFeedback.selectionClick();
    context.go(AppRoutePaths.profileApiCreate);
  }

  void _toggleKey(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      _keys = [
        for (final apiKey in _keys)
          if (apiKey.id == id)
            apiKey.copyWith(isActive: !apiKey.isActive)
          else
            apiKey,
      ];
    });
  }

  void _toggleSecret(String id) {
    HapticFeedback.selectionClick();
    setState(() => _showSecretId = _showSecretId == id ? null : id);
  }

  Future<void> _copyText(String id, String value) async {
    HapticFeedback.selectionClick();
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    setState(() => _copiedId = id);
  }

  Future<void> _confirmDelete(ProfileApiKey apiKey) async {
    HapticFeedback.selectionClick();
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _apiSurface,
          title: Text(
            'Xo\u00E1 API Key?',
            style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
          ),
          content: Text(
            'Thao t\u00E1c n\u00E0y kh\u00F4ng th\u1EC3 ho\u00E0n t\u00E1c. T\u1EA5t c\u1EA3 k\u1EBFt n\u1ED1i s\u1EED d\u1EE5ng key n\u00E0y s\u1EBD ng\u1EEBng ho\u1EA1t \u0111\u1ED9ng.',
            style: AppTextStyles.body.copyWith(color: AppColors.text2),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Hu\u1EF7'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Xo\u00E1', style: TextStyle(color: _apiRed)),
            ),
          ],
        );
      },
    );
    if (shouldDelete != true || !mounted) return;
    setState(() => _keys = _keys.where((key) => key.id != apiKey.id).toList());
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.profile);
  }
}

class _CreateButton extends StatelessWidget {
  const _CreateButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: ApiManagementPage.createKey,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _apiBlue.withValues(alpha: .15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _apiBlue.withValues(alpha: .28)),
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.add_rounded, color: _apiBlue, size: 24),
      ),
    );
  }
}

class _ApiKeyCard extends StatelessWidget {
  const _ApiKeyCard({
    required this.apiKey,
    required this.showSecret,
    required this.copiedId,
    required this.onToggle,
    required this.onReveal,
    required this.onCopy,
    required this.onDelete,
  });

  final ProfileApiKey apiKey;
  final bool showSecret;
  final String? copiedId;
  final VoidCallback onToggle;
  final VoidCallback onReveal;
  final void Function(String id, String value) onCopy;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final active = apiKey.isActive;
    return Opacity(
      opacity: active ? 1 : .65,
      child: Container(
        key: ApiManagementPage.cardKey(apiKey.id),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        decoration: BoxDecoration(
          color: _apiSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active ? _apiBorder : _apiRed.withValues(alpha: .15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ApiKeyHeader(apiKey: apiKey, onToggle: onToggle),
            const SizedBox(height: 12),
            _SecretRow(
              label: 'API KEY',
              value: _maskedKey(apiKey.key),
              labelColor: _apiMuted,
              trailing: _IconTap(
                icon: copiedId == '${apiKey.id}_key'
                    ? Icons.check_circle_outline_rounded
                    : Icons.copy_rounded,
                color: copiedId == '${apiKey.id}_key'
                    ? _apiGreen
                    : AppColors.text2,
                onTap: () => onCopy('${apiKey.id}_key', apiKey.key),
              ),
            ),
            const SizedBox(height: 8),
            _SecretRow(
              label: 'SECRET',
              value: showSecret
                  ? apiKey.secret
                  : '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
              labelColor: _apiRed,
              redBorder: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _IconTap(
                    key: ApiManagementPage.revealKey(apiKey.id),
                    icon: showSecret
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.text2,
                    onTap: onReveal,
                  ),
                  if (showSecret) ...[
                    const SizedBox(width: 7),
                    _IconTap(
                      icon: copiedId == '${apiKey.id}_secret'
                          ? Icons.check_circle_outline_rounded
                          : Icons.copy_rounded,
                      color: copiedId == '${apiKey.id}_secret'
                          ? _apiGreen
                          : AppColors.text2,
                      onTap: () => onCopy('${apiKey.id}_secret', apiKey.secret),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            _PermissionBadges(apiKey: apiKey),
            const SizedBox(height: 13),
            _UsageRow(apiKey: apiKey),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _RegenerateButton(onTap: () {})),
                const SizedBox(width: 10),
                _DeleteButton(onTap: onDelete, id: apiKey.id),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ApiKeyHeader extends StatelessWidget {
  const _ApiKeyHeader({required this.apiKey, required this.onToggle});

  final ProfileApiKey apiKey;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final active = apiKey.isActive;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: active
                ? _apiBlue.withValues(alpha: .15)
                : _apiRed.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: active
                  ? _apiBlue.withValues(alpha: .22)
                  : _apiRed.withValues(alpha: .22),
            ),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.key_rounded,
            color: active ? _apiBlue : _apiRed,
            size: 19,
          ),
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
                      apiKey.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  _StatusBadge(active: active),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                'T\u1EA1o: ${apiKey.createdAt} \u2022 ${apiKey.expiresAt == null ? 'Kh\u00F4ng h\u1EBFt h\u1EA1n' : 'H\u1EBFt h\u1EA1n: ${apiKey.expiresAt}'}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: _apiMuted,
                  fontSize: 11,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 9),
        _ToggleSwitch(
          key: ApiManagementPage.toggleKey(apiKey.id),
          active: active,
          onTap: onToggle,
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? _apiGreen : _apiRed;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        active ? '\u2022 Active' : '\u2022 Disabled',
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({super.key, required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? _apiGreen : AppColors.borderSolid;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 27,
        height: 16,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color, width: 2),
        ),
        alignment: active ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

class _SecretRow extends StatelessWidget {
  const _SecretRow({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.trailing,
    this.redBorder = false,
  });

  final String label;
  final String value;
  final Color labelColor;
  final Widget trailing;
  final bool redBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _apiSurface2,
        borderRadius: BorderRadius.circular(14),
        border: redBorder
            ? Border.all(color: _apiRed.withValues(alpha: .1))
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: labelColor,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          trailing,
        ],
      ),
    );
  }
}

class _IconTap extends StatelessWidget {
  const _IconTap({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Icon(icon, color: color, size: 14),
    );
  }
}

class _PermissionBadges extends StatelessWidget {
  const _PermissionBadges({required this.apiKey});

  final ProfileApiKey apiKey;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final permission in apiKey.permissions)
          _SmallBadge(
            label: _permissionLabel(permission),
            color: _permissionColor(permission),
          ),
        if (apiKey.ipWhitelist.isNotEmpty)
          _SmallBadge(
            label: '${apiKey.ipWhitelist.length} IPs',
            color: _apiGreen,
            icon: Icons.language_rounded,
          )
        else
          const _SmallBadge(
            label: 'Kh\u00F4ng gi\u1EDBi h\u1EA1n IP',
            color: _apiAmber,
            icon: Icons.warning_amber_rounded,
          ),
      ],
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: .24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 12),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _UsageRow extends StatelessWidget {
  const _UsageRow({required this.apiKey});

  final ProfileApiKey apiKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.access_time_rounded, color: _apiMuted, size: 11),
        const SizedBox(width: 3),
        Expanded(
          child: Text(
            'D\u00F9ng l\u1EA7n cu\u1ED1i: ${apiKey.lastUsed ?? 'Ch\u01B0a d\u00F9ng'}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: _apiMuted,
              fontSize: 11,
              height: 1,
            ),
          ),
        ),
        Text(
          '${_formatInt(apiKey.requestCount)} requests',
          style: AppTextStyles.micro.copyWith(
            color: _apiMuted,
            fontSize: 11,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _RegenerateButton extends StatelessWidget {
  const _RegenerateButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: _apiBlue.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _apiBlue.withValues(alpha: .25)),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sync_rounded, color: _apiBlue, size: 13),
            const SizedBox(width: 5),
            Text(
              'T\u1EA1o l\u1EA1i Secret',
              style: AppTextStyles.micro.copyWith(
                color: _apiBlue,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onTap, required this.id});

  final VoidCallback onTap;
  final String id;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: ApiManagementPage.deleteKey(id),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40,
        height: 36,
        decoration: BoxDecoration(
          color: _apiRed.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _apiRed.withValues(alpha: .25)),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.delete_outline_rounded,
          color: _apiRed,
          size: 17,
        ),
      ),
    );
  }
}

class _ApiDocsCard extends StatelessWidget {
  const _ApiDocsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
      decoration: BoxDecoration(
        color: _apiSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _apiBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _apiBlue.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.info_outline_rounded,
              color: _apiBlue,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'T\u00E0i li\u1EC7u API',
                  style: AppTextStyles.body.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Xem h\u01B0\u1EDBng d\u1EABn t\u00EDch h\u1EE3p v\u00E0 endpoint',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: _apiMuted,
                    fontSize: 12,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: _apiMuted, size: 18),
        ],
      ),
    );
  }
}

String _maskedKey(String value) {
  if (value.length <= 18) return value;
  return '${value.substring(0, 12)}\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022${value.substring(value.length - 6)}';
}

String _permissionLabel(String id) {
  return switch (id) {
    'trade' => 'Giao d\u1ECBch',
    'withdraw' => 'R\u00FAt ti\u1EC1n',
    _ => '\u0110\u1ECDc',
  };
}

Color _permissionColor(String id) {
  return switch (id) {
    'trade' => _apiAmber,
    'withdraw' => _apiRed,
    _ => _apiBlue,
  };
}

String _formatInt(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final remaining = text.length - i;
    buffer.write(text[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}
