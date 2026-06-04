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
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part '../widgets/p2p_anti_phishing_code_page_sections.dart';
part '../widgets/p2p_anti_phishing_code_page_common.dart';

class P2PAntiPhishingCodePage extends ConsumerStatefulWidget {
  const P2PAntiPhishingCodePage({super.key, this.shellRenderMode});

  static const statusKey = Key('sc256_p2p_anti_phishing_status');
  static const explainerKey = Key('sc256_p2p_anti_phishing_explainer');
  static const codeCardKey = Key('sc256_p2p_anti_phishing_code_card');
  static const examplesKey = Key('sc256_p2p_anti_phishing_examples');
  static const warningKey = Key('sc256_p2p_anti_phishing_warning');
  static const revealKey = Key('sc256_p2p_anti_phishing_reveal');
  static const copyKey = Key('sc256_p2p_anti_phishing_copy');
  static const editKey = Key('sc256_p2p_anti_phishing_edit');
  static const inputKey = Key('sc256_p2p_anti_phishing_input');
  static const generateKey = Key('sc256_p2p_anti_phishing_generate');
  static const saveKey = Key('sc256_p2p_anti_phishing_save');

  static Key exampleKey(String id) =>
      Key('sc256_p2p_anti_phishing_example_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PAntiPhishingCodePage> createState() =>
      _P2PAntiPhishingCodePageState();
}

class _P2PAntiPhishingCodePageState
    extends ConsumerState<P2PAntiPhishingCodePage> {
  late final TextEditingController _codeController;
  late String _code;
  late bool _editing;
  bool _showCode = false;

  @override
  void initState() {
    super.initState();
    final snapshot = ref.read(p2pAntiPhishingCodeProvider);
    _code = snapshot.currentCode;
    _editing = !snapshot.hasCode;
    _codeController = TextEditingController(text: _code);
    _codeController.addListener(_handleCodeChanged);
  }

  @override
  void dispose() {
    _codeController.removeListener(_handleCodeChanged);
    _codeController.dispose();
    super.dispose();
  }

  void _handleCodeChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pAntiPhishingCodeProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-256 P2PAntiPhishingCodePage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Anti-Phishing Code',
            subtitle: 'Bảo mật · P2P',
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.contentPad,
                      AppSpacing.x4,
                      AppSpacing.contentPad,
                      bottomInset,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _StatusCard(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x5),
                        _ExplainerCard(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x6),
                        _SectionTitle(
                          _editing ? 'Thiết lập code' : 'Code hiện tại',
                        ),
                        const SizedBox(height: AppSpacing.x3),
                        _editing
                            ? _editCodeCard()
                            : _currentCodeCard(code: _code),
                        const SizedBox(height: AppSpacing.x6),
                        const _SectionTitle('Ví dụ email'),
                        const SizedBox(height: AppSpacing.x3),
                        _EmailExamples(examples: snapshot.examples),
                        const SizedBox(height: AppSpacing.x6),
                        _WarningCard(snapshot: snapshot),
                      ],
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

  Widget _currentCodeCard({required String code}) {
    return VitCard(
      key: P2PAntiPhishingCodePage.codeCardKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Your Code',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _IconAction(
                key: P2PAntiPhishingCodePage.revealKey,
                icon: _showCode
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _showCode = !_showCode);
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            radius: VitCardRadius.md,
            variant: VitCardVariant.inner,
            borderColor: AppColors.borderSolid,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x4,
              vertical: AppSpacing.x5,
            ),
            child: Center(
              child: Text(
                _showCode ? code : List.filled(code.length, '•').join(),
                style: AppTextStyles.sectionTitle.copyWith(
                  fontFeatures: AppTextStyles.tabularFigures,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _SoftActionButton(
                  key: P2PAntiPhishingCodePage.copyKey,
                  label: 'Copy',
                  icon: Icons.copy_rounded,
                  color: AppModuleAccents.p2p,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    Clipboard.setData(ClipboardData(text: _code));
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _SoftActionButton(
                  key: P2PAntiPhishingCodePage.editKey,
                  label: 'Đổi code',
                  icon: Icons.edit_outlined,
                  color: AppColors.text2,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    _codeController.text = _code;
                    setState(() => _editing = true);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _editCodeCard() {
    return VitCard(
      key: P2PAntiPhishingCodePage.codeCardKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitInput(
            controller: _codeController,
            fieldKey: P2PAntiPhishingCodePage.inputKey,
            label: 'Anti-Phishing Code',
            hintText: 'Nhập code tối thiểu 6 ký tự',
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              LengthLimitingTextInputFormatter(20),
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_-]')),
            ],
            onChanged: (value) {
              final upper = value.toUpperCase();
              if (upper != value) {
                _codeController.value = TextEditingValue(
                  text: upper,
                  selection: TextSelection.collapsed(offset: upper.length),
                );
              }
            },
          ),
          const SizedBox(height: AppSpacing.x3),
          _SoftActionButton(
            key: P2PAntiPhishingCodePage.generateKey,
            label: 'Tạo code ngẫu nhiên',
            icon: Icons.refresh_rounded,
            color: AppColors.text1,
            onTap: () {
              HapticFeedback.selectionClick();
              _codeController.text = 'SEC8F2K9';
            },
          ),
          const SizedBox(height: AppSpacing.x3),
          VitCtaButton(
            key: P2PAntiPhishingCodePage.saveKey,
            variant: VitCtaButtonVariant.success,
            onPressed: _codeController.text.trim().length < 6
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _code = _codeController.text.trim().toUpperCase();
                      _showCode = true;
                      _editing = false;
                    });
                  },
            leading: const Icon(Icons.check_circle_outline_rounded),
            child: const Text('Lưu code'),
          ),
        ],
      ),
    );
  }
}
