import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';

part '../widgets/api_management_keys.dart';
part '../widgets/api_management_key_controls.dart';
part '../widgets/api_management_docs.dart';

const _apiBackground = AppColors.bg;
const _apiPanel = AppColors.surface;
const _apiPanel2 = AppColors.surface2;
const _apiBorder = AppColors.cardBorder;
const _apiPrimary = AppColors.primary;
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
    final snapshot = ref.watch(profileControllerProvider).getApiManagement();
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
        color: _apiBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Qu\u1EA3n l\u00FD API',
            subtitle: 'API \u00B7 Profile',
            showBack: true,
            onBack: _close,
            actions: [
              VitHeaderActionItem(
                key: ApiManagementPage.createKey,
                type: VitHeaderActionType.add,
                tooltip: 'Tạo API key',
                onPressed: _createApiKey,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
          backgroundColor: _apiPanel,
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
    goBackOrFallback(context, fallbackPath: AppRoutePaths.profile);
  }
}
