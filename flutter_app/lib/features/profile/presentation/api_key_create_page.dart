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
const _apiBorder = AppColors.borderSolid;
const _apiBlue = AppColors.primary;
const _apiGreen = AppColors.buy;
const _apiAmber = AppColors.warn;
const _apiRed = AppColors.sell;
const _apiMuted = AppColors.text3;

enum _ApiCreateStep { form, confirm, result }

class ApiKeyCreatePage extends ConsumerStatefulWidget {
  const ApiKeyCreatePage({super.key, this.shellRenderMode});

  static const nameFieldKey = Key('sc162_api_name_field');
  static const ipFieldKey = Key('sc162_api_ip_field');
  static const continueKey = Key('sc162_api_continue');
  static Key permissionKey(String id) => Key('sc162_api_permission_$id');
  static Key expiryKey(String id) => Key('sc162_api_expiry_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ApiKeyCreatePage> createState() => _ApiKeyCreatePageState();
}

class _ApiKeyCreatePageState extends ConsumerState<ApiKeyCreatePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ipController = TextEditingController();
  Set<String> _permissions = const {'read'};
  final List<String> _ips = [];
  String _expiry = 'none';
  _ApiCreateStep _step = _ApiCreateStep.form;

  bool get _canProceed => _nameController.text.trim().length >= 3;

  @override
  void dispose() {
    _nameController.dispose();
    _ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(profileRepositoryProvider).getApiKeyCreate();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 120
            : DeviceMetrics.nativeBottomChrome + 32) +
        MediaQuery.paddingOf(context).bottom;

    return switch (_step) {
      _ApiCreateStep.confirm => _buildConfirm(snapshot, bottomInset),
      _ApiCreateStep.result => _buildResult(snapshot, bottomInset),
      _ => _buildForm(snapshot, bottomInset),
    };
  }

  Widget _buildForm(ProfileApiKeyCreateSnapshot snapshot, double bottomInset) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-162 ApiKeyCreatePage',
      child: Material(
        color: _apiBg,
        child: Column(
          children: [
            VitHeader(
              title: 'T\u1EA1o API Key m\u1EDBi',
              subtitle: 'API \u00B7 Profile',
              showBack: true,
              onBack: _close,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20, 17, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _NameSection(
                      controller: _nameController,
                      onChanged: () => setState(() {}),
                    ),
                    const SizedBox(height: 26),
                    _PermissionsSection(
                      permissions: snapshot.permissions,
                      selected: _permissions,
                      onToggle: _togglePermission,
                    ),
                    const SizedBox(height: 27),
                    _IpWhitelistSection(
                      controller: _ipController,
                      ips: _ips,
                      onAdd: _addIp,
                      onRemove: (ip) => setState(() => _ips.remove(ip)),
                    ),
                    const SizedBox(height: 28),
                    _ExpirySection(
                      options: snapshot.expiryOptions,
                      selected: _expiry,
                      onSelect: (id) {
                        HapticFeedback.selectionClick();
                        setState(() => _expiry = id);
                      },
                    ),
                    const SizedBox(height: 24),
                    _SecurityTips(tips: snapshot.securityTips),
                    const SizedBox(height: 10),
                    _PrimaryCta(
                      key: ApiKeyCreatePage.continueKey,
                      label: 'Ti\u1EBFp t\u1EE5c',
                      enabled: _canProceed,
                      onTap: () =>
                          setState(() => _step = _ApiCreateStep.confirm),
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

  Widget _buildConfirm(
    ProfileApiKeyCreateSnapshot snapshot,
    double bottomInset,
  ) {
    final permissionLabels = snapshot.permissions
        .where((permission) => _permissions.contains(permission.id))
        .map((permission) => permission.label)
        .join(', ');
    final expiry = snapshot.expiryOptions.firstWhere(
      (option) => option.id == _expiry,
      orElse: () => snapshot.expiryOptions.first,
    );

    return _SimpleStepScaffold(
      title: 'X\u00E1c nh\u1EADn t\u1EA1o API Key',
      subtitle: 'API \u00B7 Profile',
      bottomInset: bottomInset,
      onBack: () => setState(() => _step = _ApiCreateStep.form),
      children: [
        const _SuccessIcon(title: 'X\u00E1c nh\u1EADn t\u1EA1o API Key'),
        _SummaryCard(
          rows: [
            ProfileInfoRow(
              label: 'T\u00EAn API Key',
              value: _nameController.text.trim(),
            ),
            ProfileInfoRow(
              label: 'Quy\u1EC1n truy c\u1EADp',
              value: permissionLabels,
            ),
            ProfileInfoRow(
              label: 'IP Whitelist',
              value: _ips.isEmpty
                  ? 'Kh\u00F4ng gi\u1EDBi h\u1EA1n'
                  : _ips.join(', '),
            ),
            ProfileInfoRow(label: 'Th\u1EDDi h\u1EA1n', value: expiry.label),
          ],
        ),
        if (_ips.isEmpty)
          const _WarningCard(
            text:
                'Key kh\u00F4ng gi\u1EDBi h\u1EA1n IP. Khuy\u1EBFn ngh\u1ECB th\u00EAm IP whitelist.',
            amber: true,
          ),
        _PrimaryCta(
          label: 'T\u1EA1o API Key',
          enabled: true,
          onTap: () => setState(() => _step = _ApiCreateStep.result),
        ),
      ],
    );
  }

  Widget _buildResult(
    ProfileApiKeyCreateSnapshot snapshot,
    double bottomInset,
  ) {
    return _SimpleStepScaffold(
      title: 'API Key \u0111\u00E3 t\u1EA1o',
      subtitle: 'API \u00B7 Profile',
      bottomInset: bottomInset,
      showBack: false,
      children: [
        const _SuccessIcon(title: 'T\u1EA1o th\u00E0nh c\u00F4ng!'),
        const _WarningCard(
          text:
              'Secret Key ch\u1EC9 hi\u1EC3n th\u1ECB m\u1ED9t l\u1EA7n duy nh\u1EA5t. H\u00E3y l\u01B0u ngay.',
        ),
        const _KeyResultCard(
          label: 'API Key',
          value: 'vt_live_demo_7h3k9m2p4x8q',
        ),
        const _KeyResultCard(
          label: 'Secret Key',
          value: 'sk_live_demo_only_once',
        ),
        _PrimaryCta(
          label: '\u0110\u00E3 l\u01B0u, quay l\u1EA1i',
          enabled: true,
          onTap: () => context.go(AppRoutePaths.profileApi),
        ),
      ],
    );
  }

  void _togglePermission(String id) {
    if (id == 'read') return;
    HapticFeedback.selectionClick();
    setState(() {
      final next = {..._permissions};
      if (next.contains(id)) {
        next.remove(id);
      } else {
        next.add(id);
      }
      _permissions = next;
    });
  }

  void _addIp() {
    final ip = _ipController.text.trim();
    if (ip.isEmpty) return;
    if (!_ips.contains(ip)) {
      HapticFeedback.selectionClick();
      setState(() => _ips.add(ip));
    }
    _ipController.clear();
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.profileApi);
  }
}

class _NameSection extends StatelessWidget {
  const _NameSection({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return _FieldSection(
      label: 'T\u00EAn API Key',
      required: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TextInput(
            key: ApiKeyCreatePage.nameFieldKey,
            controller: controller,
            hint: 'VD: Trading Bot Alpha, Portfolio Tracker...',
            maxLength: 30,
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'T\u1ED1i thi\u1EC3u 3 k\u00FD t\u1EF1',
                style: AppTextStyles.micro.copyWith(
                  color: _apiMuted,
                  fontSize: 11,
                  height: 1,
                ),
              ),
              const Spacer(),
              Text(
                '${controller.text.length}/30',
                style: AppTextStyles.micro.copyWith(
                  color: _apiMuted,
                  fontSize: 11,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PermissionsSection extends StatelessWidget {
  const _PermissionsSection({
    required this.permissions,
    required this.selected,
    required this.onToggle,
  });

  final List<ProfileApiPermission> permissions;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return _FieldSection(
      label: 'Quy\u1EC1n truy c\u1EADp',
      required: true,
      child: Column(
        children: [
          for (final permission in permissions) ...[
            _PermissionCard(
              permission: permission,
              selected: selected.contains(permission.id),
              onTap: () => onToggle(permission.id),
            ),
            if (permission != permissions.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
    required this.permission,
    required this.selected,
    required this.onTap,
  });

  final ProfileApiPermission permission;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = Color(permission.colorHex);

    return GestureDetector(
      key: ApiKeyCreatePage.permissionKey(permission.id),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 73,
        padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
        decoration: BoxDecoration(
          color: selected ? accent.withValues(alpha: .04) : _apiSurface2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? accent.withValues(alpha: .42) : _apiBorder,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected ? accent.withValues(alpha: .12) : _apiSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected ? accent.withValues(alpha: .25) : _apiBorder,
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                _apiPermissionIcon(permission.iconKey),
                color: selected ? accent : _apiMuted,
                size: 18,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          permission.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: selected ? AppColors.text1 : AppColors.text2,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ),
                      if (permission.required)
                        Text(
                          ' (b\u1EAFt bu\u1ED9c)',
                          style: AppTextStyles.caption.copyWith(
                            color: _apiMuted,
                            fontSize: 14,
                            height: 1,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    permission.description,
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
            const SizedBox(width: 10),
            _PermissionCheck(selected: selected, color: accent),
          ],
        ),
      ),
    );
  }
}

class _PermissionCheck extends StatelessWidget {
  const _PermissionCheck({required this.selected, required this.color});

  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: selected ? color : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: selected ? color : _apiBorder, width: 2),
      ),
      alignment: Alignment.center,
      child: selected
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 15)
          : null,
    );
  }
}

class _IpWhitelistSection extends StatelessWidget {
  const _IpWhitelistSection({
    required this.controller,
    required this.ips,
    required this.onAdd,
    required this.onRemove,
  });

  final TextEditingController controller;
  final List<String> ips;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return _FieldSection(
      label: 'IP Whitelist',
      optional: 'khuy\u1EBFn ngh\u1ECB',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _TextInput(
                  key: ApiKeyCreatePage.ipFieldKey,
                  controller: controller,
                  hint: 'VD: 192.168.1.100',
                  height: 48,
                  onSubmitted: (_) => onAdd(),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onAdd,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 56,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _apiBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          if (ips.isEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Kh\u00F4ng c\u00F3 IP whitelist \u2014 key c\u00F3 th\u1EC3 \u0111\u01B0\u1EE3c d\u00F9ng t\u1EEB b\u1EA5t k\u1EF3 \u0111\u00E2u',
              style: AppTextStyles.micro.copyWith(
                color: _apiAmber,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1,
              ),
            ),
          ] else ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final ip in ips)
                  GestureDetector(
                    onTap: () => onRemove(ip),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: _apiGreen.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _apiGreen.withValues(alpha: .25),
                        ),
                      ),
                      child: Text(
                        ip,
                        style: AppTextStyles.micro.copyWith(
                          color: _apiGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ExpirySection extends StatelessWidget {
  const _ExpirySection({
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  final List<ProfileApiExpiryOption> options;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return _FieldSection(
      label: 'Th\u1EDDi h\u1EA1n',
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          mainAxisExtent: 57,
        ),
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = option.id == selected;
          return GestureDetector(
            key: ApiKeyCreatePage.expiryKey(option.id),
            onTap: () => onSelect(option.id),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.fromLTRB(13, 10, 13, 9),
              decoration: BoxDecoration(
                color: isSelected
                    ? _apiBlue.withValues(alpha: .12)
                    : _apiSurface2,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? _apiBlue.withValues(alpha: .55)
                      : _apiBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    option.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: isSelected ? _apiBlue : AppColors.text2,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    option.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: _apiMuted,
                      fontSize: 10,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SecurityTips extends StatelessWidget {
  const _SecurityTips({required this.tips});

  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      decoration: BoxDecoration(
        color: _apiSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _apiBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined, color: _apiBlue, size: 15),
              const SizedBox(width: 8),
              Text(
                'M\u1EB9o b\u1EA3o m\u1EADt',
                style: AppTextStyles.caption.copyWith(
                  color: _apiBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < tips.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _apiBlue.withValues(alpha: .14),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${i + 1}',
                    style: AppTextStyles.micro.copyWith(
                      color: _apiBlue,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    tips[i],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            if (i != tips.length - 1) const SizedBox(height: 9),
          ],
        ],
      ),
    );
  }
}

class _FieldSection extends StatelessWidget {
  const _FieldSection({
    required this.label,
    required this.child,
    this.required = false,
    this.optional,
  });

  final String label;
  final Widget child;
  final bool required;
  final String? optional;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            children: [
              if (required)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: _apiRed),
                ),
              if (optional != null)
                TextSpan(
                  text: ' ($optional)',
                  style: const TextStyle(
                    color: _apiMuted,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _TextInput extends StatelessWidget {
  const _TextInput({
    super.key,
    required this.controller,
    required this.hint,
    this.height = 52,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final double height;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextField(
        controller: controller,
        maxLength: maxLength,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        cursorColor: _apiBlue,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text1,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: _apiSurface2,
          hintText: hint,
          hintStyle: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: _inputBorder(_apiBorder),
          enabledBorder: _inputBorder(_apiBorder),
          focusedBorder: _inputBorder(_apiBlue, width: 1.5),
        ),
      ),
    );
  }
}

class _PrimaryCta extends StatelessWidget {
  const _PrimaryCta({
    super.key,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: enabled ? _apiBlue : _apiSurface2,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.baseMedium.copyWith(
            color: enabled ? Colors.white : AppColors.borderSolid,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _SimpleStepScaffold extends StatelessWidget {
  const _SimpleStepScaffold({
    required this.title,
    required this.subtitle,
    required this.bottomInset,
    required this.children,
    this.onBack,
    this.showBack = true,
  });

  final String title;
  final String subtitle;
  final double bottomInset;
  final List<Widget> children;
  final VoidCallback? onBack;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      child: Material(
        color: _apiBg,
        child: Column(
          children: [
            VitHeader(
              title: title,
              subtitle: subtitle,
              showBack: showBack,
              onBack: onBack,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 28, 20, bottomInset),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final child in children) ...[
                      child,
                      if (child != children.last) const SizedBox(height: 18),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessIcon extends StatelessWidget {
  const _SuccessIcon({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: _apiGreen.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _apiGreen.withValues(alpha: .25)),
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.check_circle_outline_rounded,
            color: _apiGreen,
            size: 42,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 20),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.rows});

  final List<ProfileInfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _apiSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _apiBorder),
      ),
      child: Column(
        children: [
          for (final row in rows) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    row.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontSize: 13,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    row.value,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            if (row != rows.last)
              const Divider(height: 18, color: AppColors.divider),
          ],
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.text, this.amber = false});

  final String text;
  final bool amber;

  @override
  Widget build(BuildContext context) {
    final color = amber ? _apiAmber : _apiRed;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: .22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: color, size: 17),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyResultCard extends StatelessWidget {
  const _KeyResultCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _apiSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _apiBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

OutlineInputBorder _inputBorder(Color color, {double width = 1.5}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(color: color, width: width),
  );
}

IconData _apiPermissionIcon(String key) {
  return switch (key) {
    'refresh' => Icons.refresh_rounded,
    'lock' => Icons.lock_outline_rounded,
    _ => Icons.remove_red_eye_outlined,
  };
}
