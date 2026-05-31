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

part '../widgets/profile_api_key_create_form.dart';
part '../widgets/profile_api_key_create_result.dart';

const _apiBackground = AppColors.bg;
const _apiPanel = AppColors.surface;
const _apiPanel2 = AppColors.surface2;
const _apiBorder = AppColors.borderSolid;
const _apiPrimary = AppColors.primary;
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
    final snapshot = ref.watch(profileControllerProvider).getApiKeyCreate();
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
        color: _apiBackground,
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
