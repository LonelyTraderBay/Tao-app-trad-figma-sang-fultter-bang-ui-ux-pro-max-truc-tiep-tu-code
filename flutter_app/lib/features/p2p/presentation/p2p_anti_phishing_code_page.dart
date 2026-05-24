import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/p2p_repository.dart';

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
    final snapshot = ref.read(p2pRepositoryProvider).getAntiPhishingCode();
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
    final snapshot = ref.watch(p2pRepositoryProvider).getAntiPhishingCode();
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
        child: Column(
          children: [
            VitHeader(
              title: 'Anti-Phishing Code',
              subtitle: 'Bảo mật · P2P',
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
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

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.snapshot});

  final P2PAntiPhishingCodeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final color = snapshot.hasCode ? AppColors.buy : AppColors.warn;

    return DecoratedBox(
      key: P2PAntiPhishingCodePage.statusKey,
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: AppSpacing.inputHeight,
              height: AppSpacing.inputHeight,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .18),
                borderRadius: AppRadii.lgRadius,
              ),
              child: const Icon(
                Icons.shield_outlined,
                color: Colors.white,
                size: AppSpacing.iconMd,
              ),
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.statusTitle,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                      height: 1.12,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    snapshot.statusBody,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white.withValues(alpha: .9),
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExplainerCard extends StatelessWidget {
  const _ExplainerCard({required this.snapshot});

  final P2PAntiPhishingCodeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PAntiPhishingCodePage.explainerKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  snapshot.explainerTitle,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            snapshot.explainerBody,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.55,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final benefit in snapshot.benefits) ...[
            _CheckRow(text: benefit),
            if (benefit != snapshot.benefits.last)
              const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _EmailExamples extends StatelessWidget {
  const _EmailExamples({required this.examples});

  final List<P2PAntiPhishingExampleDraft> examples;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PAntiPhishingCodePage.examplesKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < examples.length; index++) ...[
          _EmailExampleCard(example: examples[index]),
          if (index != examples.length - 1)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _EmailExampleCard extends StatelessWidget {
  const _EmailExampleCard({required this.example});

  final P2PAntiPhishingExampleDraft example;

  @override
  Widget build(BuildContext context) {
    final color = example.isLegit ? AppColors.buy : AppColors.sell;

    return VitCard(
      key: P2PAntiPhishingCodePage.exampleKey(example.id),
      radius: VitCardRadius.lg,
      borderColor: color,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                example.isLegit
                    ? Icons.check_circle_outline_rounded
                    : Icons.warning_amber_rounded,
                color: color,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.mail_outline_rounded,
                          color: AppColors.text3,
                          size: 12,
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        Expanded(
                          child: Text(
                            example.subject,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    VitCard(
                      radius: VitCardRadius.sm,
                      variant: VitCardVariant.inner,
                      borderColor: Colors.transparent,
                      padding: const EdgeInsets.all(AppSpacing.x3),
                      child: Text(
                        example.preview,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          height: 1.55,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Align(
            alignment: Alignment.centerLeft,
            child: _SmallBadge(
              label: example.isLegit ? 'Email chính thức' : 'Email lừa đảo',
              icon: example.isLegit ? Icons.check_rounded : Icons.close_rounded,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.snapshot});

  final P2PAntiPhishingCodeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: P2PAntiPhishingCodePage.warningKey,
      decoration: BoxDecoration(
        color: AppColors.sell10,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppColors.sell20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.sell,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.warningTitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.sell,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  for (final warning in snapshot.warnings) ...[
                    _BulletRow(text: warning),
                    if (warning != snapshot.warnings.last)
                      const SizedBox(height: AppSpacing.x1),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.baseMedium.copyWith(fontWeight: AppTextStyles.bold),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_outline_rounded,
          color: AppColors.buy,
          size: 13,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.only(top: 7),
          decoration: const BoxDecoration(
            color: AppColors.text3,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 12),
            const SizedBox(width: AppSpacing.x1),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SoftActionButton extends StatelessWidget {
  const _SoftActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: color == AppColors.text1 ? .08 : .12),
      borderRadius: AppRadii.mdRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x3,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 32,
      child: IconButton(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: AppColors.text3, size: AppSpacing.iconSm),
      ),
    );
  }
}
