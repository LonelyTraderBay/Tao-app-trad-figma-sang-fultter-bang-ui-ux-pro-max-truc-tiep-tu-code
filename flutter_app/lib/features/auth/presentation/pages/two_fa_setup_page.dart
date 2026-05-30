import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/auth_controller_providers.dart';

const _authPrimary = AppColors.primary;
const _authPrimary10 = AppColors.primary12;
const _authPrimary20 = AppColors.primary20;
const _authPrimary30 = AppColors.primary30;
const _authStepInactive = AppColors.surface3;
const _secretKey = 'JBSWY3DPEHPK3PXP';
const _backupCodes = [
  '84923-13721',
  '29381-84752',
  '56743-29187',
  '93847-65432',
  '12837-49283',
];

class TwoFASetupPage extends ConsumerStatefulWidget {
  const TwoFASetupPage({super.key});

  static const contentKey = Key('sc004_two_fa_content');
  static const copyKey = Key('sc004_two_fa_copy');
  static const codeFieldKey = Key('sc004_two_fa_code_field');
  static const backupSavedKey = Key('sc004_two_fa_backup_saved');
  static const submitKey = Key('sc004_two_fa_submit');

  @override
  ConsumerState<TwoFASetupPage> createState() => _TwoFASetupPageState();
}

class _TwoFASetupPageState extends ConsumerState<TwoFASetupPage> {
  final _codeController = TextEditingController();
  final _codeFocusNode = FocusNode();

  int _step = 1;
  bool _copied = false;
  bool _backupCodesSaved = false;
  bool _submitting = false;
  String _error = '';

  @override
  void dispose() {
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  String get _code => _codeController.text;

  void _goBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.authOtp);
  }

  Future<void> _copySecret() async {
    if (mounted) setState(() => _copied = true);
    await Clipboard.setData(const ClipboardData(text: _secretKey));
  }

  void _nextFromQr() {
    setState(() {
      _step = 2;
      _error = '';
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _codeFocusNode.requestFocus();
    });
  }

  void _handleCodeChanged(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final next = digits.length > 6 ? digits.substring(0, 6) : digits;
    if (_codeController.text != next) {
      _codeController.value = TextEditingValue(
        text: next,
        selection: TextSelection.collapsed(offset: next.length),
      );
    }
    if (_error.isNotEmpty) {
      setState(() => _error = '');
      return;
    }
    setState(() {});
  }

  Future<void> _verifyCode() async {
    if (_submitting || _code.length != 6) return;
    setState(() {
      _submitting = true;
      _error = '';
    });

    try {
      final result = await ref
          .read(authControllerProvider)
          .verifyFactor(
            contact: 'user@vittrade.vn',
            code: _code,
            purpose: AuthOtpPurpose.twoFactor,
          );

      if (!mounted) return;
      if (!result.success) {
        setState(() {
          _error = result.errorMessage ?? 'Mã xác thực không đúng.';
          _codeController.clear();
        });
        _codeFocusNode.requestFocus();
        return;
      }

      setState(() => _step = 3);
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = authOperationErrorMessage(error);
          _codeController.clear();
        });
        _codeFocusNode.requestFocus();
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _completeSetup() async {
    if (_submitting || !_backupCodesSaved) return;
    setState(() {
      _submitting = true;
      _error = '';
    });

    try {
      final result = await ref
          .read(authControllerProvider)
          .setupTwoFactor(
            secretKey: _secretKey,
            code: _code,
            backupCodesSaved: _backupCodesSaved,
          );

      if (!mounted) return;
      if (!result.success) {
        setState(() {
          _error =
              result.errorMessage ??
              'Không thể hoàn tất 2FA. Vui lòng thử lại.';
        });
        return;
      }

      context.go(AppRoutePaths.home);
    } catch (error) {
      if (mounted) {
        setState(() => _error = authOperationErrorMessage(error));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  VoidCallback? get _primaryAction {
    if (_submitting) return null;
    if (_step == 1) return _nextFromQr;
    if (_step == 2) return _code.length == 6 ? _verifyCode : null;
    return _backupCodesSaved ? _completeSetup : null;
  }

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      semanticLabel: 'SC-004 TwoFASetupPage',
      child: Column(
        children: [
          VitHeader(
            title: 'Thiết lập 2FA',
            subtitle: 'Xác thực · Bảo mật',
            showBack: true,
            onBack: _goBack,
          ),
          _TwoFaStepper(step: _step),
          Expanded(
            child: SingleChildScrollView(
              key: TwoFASetupPage.contentKey,
              padding: const EdgeInsets.only(bottom: AppSpacing.x6),
              child: VitPageContent(
                padding: VitContentPadding.relaxed,
                customGap: 20,
                children: [
                  if (_step == 1) _QrStep(onCopy: _copySecret, copied: _copied),
                  if (_step == 2)
                    _VerifyStep(
                      controller: _codeController,
                      focusNode: _codeFocusNode,
                      error: _error,
                      onChanged: _handleCodeChanged,
                    ),
                  if (_step == 3)
                    _BackupCodesStep(
                      saved: _backupCodesSaved,
                      error: _error,
                      onSavedChanged: () {
                        setState(() {
                          _backupCodesSaved = !_backupCodesSaved;
                          _error = '';
                        });
                      },
                    ),
                  VitCtaButton(
                    key: TwoFASetupPage.submitKey,
                    onPressed: _primaryAction,
                    loading: _submitting,
                    variant: _step == 3
                        ? VitCtaButtonVariant.success
                        : VitCtaButtonVariant.auth,
                    trailing: _step == 1
                        ? const Icon(Icons.chevron_right_rounded)
                        : null,
                    leading: _step == 3
                        ? const Icon(Icons.check_rounded)
                        : null,
                    child: Text(_buttonLabel),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get _buttonLabel {
    if (_submitting && _step == 2) return 'Đang xác minh...';
    if (_submitting && _step == 3) return 'Đang hoàn tất...';
    if (_step == 1) return 'Tiếp theo';
    if (_step == 2) return 'Xác nhận';
    return 'Hoàn tất thiết lập 2FA';
  }
}

class _TwoFaStepper extends StatelessWidget {
  const _TwoFaStepper({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          for (var index = 1; index <= 3; index++) ...[
            _StepDot(index: index, activeStep: step),
            if (index < 3)
              Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: index < step ? _authPrimary : _authPrimary30,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.index, required this.activeStep});

  final int index;
  final int activeStep;

  @override
  Widget build(BuildContext context) {
    final isActive = index == activeStep;
    final isComplete = index < activeStep;
    final color = isActive || isComplete ? _authPrimary : _authStepInactive;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: isComplete
          ? const Icon(Icons.check_rounded, color: AppColors.onAccent, size: 17)
          : Text(
              '$index',
              style: AppTextStyles.caption.copyWith(
                color: isActive ? AppColors.onAccent : AppColors.text3,
                fontWeight: AppTextStyles.bold,
              ),
            ),
    );
  }
}

class _QrStep extends StatelessWidget {
  const _QrStep({required this.onCopy, required this.copied});

  final VoidCallback onCopy;
  final bool copied;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _ShieldHero(),
        const SizedBox(height: 18),
        Text(
          'Bước 1: Quét mã QR',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 22),
        ),
        const SizedBox(height: AppSpacing.x3),
        Text.rich(
          TextSpan(
            text: 'Mở ứng dụng ',
            children: const [
              TextSpan(
                text: 'Google Authenticator',
                style: TextStyle(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              TextSpan(text: ' hoặc '),
              TextSpan(
                text: 'Authy',
                style: TextStyle(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              TextSpan(text: ' và quét mã QR\nbên dưới.'),
            ],
          ),
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 22),
        const _QrPreview(),
        const SizedBox(height: 20),
        _SecretKeyCard(copied: copied, onCopy: onCopy),
        const SizedBox(height: 20),
        const _WarningBanner(text: 'Giữ bí mật khóa này.'),
      ],
    );
  }
}

class _ShieldHero extends StatelessWidget {
  const _ShieldHero();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: _authPrimary10,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: _authPrimary30),
        ),
        child: const Icon(Icons.shield_outlined, color: _authPrimary, size: 34),
      ),
    );
  }
}

class _QrPreview extends StatelessWidget {
  const _QrPreview();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 192,
        height: 192,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.onAccent,
          borderRadius: AppRadii.cardLargeRadius,
        ),
        child: const CustomPaint(painter: _QrPainter()),
      ),
    );
  }
}

class _QrPainter extends CustomPainter {
  const _QrPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const qrColor = AppColors.qrNavy;
    final paint = Paint()..color = qrColor;
    final module = size.width / 21;

    void moduleRect(int x, int y, [int w = 1, int h = 1]) {
      canvas.drawRect(
        Rect.fromLTWH(x * module, y * module, w * module, h * module),
        paint,
      );
    }

    void finder(int x, int y) {
      moduleRect(x, y, 7, 1);
      moduleRect(x, y + 6, 7, 1);
      moduleRect(x, y, 1, 7);
      moduleRect(x + 6, y, 1, 7);
      moduleRect(x + 2, y + 2, 3, 3);
    }

    finder(0, 0);
    finder(14, 1);
    finder(1, 14);

    const modules = <(int, int)>[
      (8, 0),
      (10, 0),
      (12, 0),
      (8, 1),
      (11, 1),
      (13, 2),
      (8, 3),
      (10, 3),
      (9, 4),
      (12, 4),
      (8, 5),
      (13, 5),
      (7, 7),
      (9, 7),
      (11, 7),
      (13, 7),
      (15, 8),
      (17, 8),
      (19, 8),
      (8, 9),
      (10, 9),
      (14, 9),
      (16, 9),
      (9, 10),
      (12, 10),
      (15, 10),
      (18, 10),
      (7, 11),
      (11, 11),
      (17, 11),
      (20, 11),
      (8, 12),
      (10, 12),
      (12, 12),
      (14, 12),
      (16, 12),
      (18, 12),
      (8, 14),
      (10, 14),
      (12, 14),
      (14, 14),
      (17, 14),
      (20, 14),
      (9, 15),
      (13, 15),
      (15, 15),
      (19, 15),
      (8, 16),
      (12, 16),
      (16, 16),
      (18, 16),
      (10, 17),
      (14, 17),
      (20, 17),
      (8, 18),
      (11, 18),
      (13, 18),
      (17, 18),
      (19, 18),
      (9, 19),
      (12, 19),
      (15, 19),
      (18, 19),
      (20, 19),
      (8, 20),
      (10, 20),
      (14, 20),
      (16, 20),
      (19, 20),
    ];

    for (final (x, y) in modules) {
      moduleRect(x, y);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SecretKeyCard extends StatelessWidget {
  const _SecretKeyCard({required this.copied, required this.onCopy});

  final bool copied;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: _authStepInactive,
        borderRadius: AppRadii.inputRadius,
        border: Border.all(color: _authPrimary30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Hoặc nhập thủ công khóa bí mật:',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: SelectableText(
                  _secretKey,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                    letterSpacing: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              TextButton.icon(
                key: TwoFASetupPage.copyKey,
                onPressed: onCopy,
                style: TextButton.styleFrom(
                  foregroundColor: _authPrimary,
                  backgroundColor: _authPrimary10,
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.cardRadius,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Icon(
                  copied ? Icons.check_rounded : Icons.content_copy_rounded,
                  size: 15,
                ),
                label: Text(
                  copied ? 'Đã sao chép' : 'Sao chép',
                  style: AppTextStyles.caption.copyWith(
                    color: _authPrimary,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.warn08,
        borderRadius: AppRadii.mdRadius,
        border: Border.all(color: AppColors.warn15),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerifyStep extends StatelessWidget {
  const _VerifyStep({
    required this.controller,
    required this.focusNode,
    required this.error,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String error;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final code = controller.text;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: focusNode.requestFocus,
      child: Column(
        children: [
          const _ShieldHero(),
          const SizedBox(height: 18),
          Text(
            'Bước 2: Xác minh mã',
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(fontSize: 22),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Nhập mã 6 chữ số từ ứng dụng xác thực của bạn',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: 28),
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var index = 0; index < 6; index++) ...[
                    if (index > 0) const SizedBox(width: 10),
                    _CodeDigitBox(
                      digit: index < code.length ? code[index] : '',
                      hasError: error.isNotEmpty,
                    ),
                  ],
                ],
              ),
              SizedBox(
                width: 1,
                height: 1,
                child: Opacity(
                  opacity: 0,
                  child: TextField(
                    key: TwoFASetupPage.codeFieldKey,
                    controller: controller,
                    focusNode: focusNode,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Chạm vào đây để nhập mã',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: _authPrimary,
              fontSize: 12,
            ),
          ),
          if (error.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.x4),
            _ErrorBanner(error: error),
          ],
        ],
      ),
    );
  }
}

class _CodeDigitBox extends StatelessWidget {
  const _CodeDigitBox({required this.digit, required this.hasError});

  final String digit;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final filled = digit.isNotEmpty;
    final borderColor = hasError
        ? AppColors.sell
        : filled
        ? _authPrimary
        : AppColors.borderSolid;

    return Container(
      width: 44,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: filled ? _authPrimary10 : AppColors.surface2,
        borderRadius: AppRadii.inputRadius,
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Text(
        digit,
        style: AppTextStyles.sectionTitle.copyWith(
          fontSize: 24,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.sell10,
        borderRadius: AppRadii.mdRadius,
        border: Border.all(color: AppColors.sell20),
      ),
      child: Text(
        error,
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(color: AppColors.sell),
      ),
    );
  }
}

class _BackupCodesStep extends StatelessWidget {
  const _BackupCodesStep({
    required this.saved,
    required this.error,
    required this.onSavedChanged,
  });

  final bool saved;
  final String error;
  final VoidCallback onSavedChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.buy10,
            borderRadius: AppRadii.cardRadius,
            border: Border.all(color: AppColors.buy20),
          ),
          child: const Icon(
            Icons.file_download_outlined,
            color: AppColors.buy,
            size: 34,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Bước 3: Mã dự phòng',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 22),
        ),
        const SizedBox(height: AppSpacing.x3),
        Text(
          'Lưu các mã này ở nơi an toàn. Dùng khi mất thiết bị xác thực.',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        _BackupCodeList(codes: _backupCodes),
        const SizedBox(height: 20),
        const _WarningBanner(text: 'Mỗi mã chỉ dùng được 1 lần.'),
        const SizedBox(height: 16),
        _BackupSavedRow(saved: saved, onTap: onSavedChanged),
        if (error.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.x4),
          _ErrorBanner(error: error),
        ],
      ],
    );
  }
}

class _BackupCodeList extends StatelessWidget {
  const _BackupCodeList({required this.codes});

  final List<String> codes;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.inputRadius,
        border: Border.all(color: AppColors.borderSolid),
      ),
      child: Column(
        children: [
          for (var index = 0; index < codes.length; index++) ...[
            if (index > 0) const SizedBox(height: AppSpacing.x3),
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: _authPrimary20,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: AppTextStyles.micro.copyWith(
                      color: _authPrimary,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x4),
                Expanded(
                  child: SelectableText(
                    codes[index],
                    style: AppTextStyles.body.copyWith(
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                      letterSpacing: 0.8,
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

class _BackupSavedRow extends StatelessWidget {
  const _BackupSavedRow({required this.saved, required this.onTap});

  final bool saved;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      checked: saved,
      label: 'Tôi đã lưu các mã dự phòng',
      child: InkWell(
        key: TwoFASetupPage.backupSavedKey,
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 22,
              height: 22,
              margin: const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                color: saved ? _authPrimary : AppColors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: saved ? _authPrimary : AppColors.borderSolid,
                  width: 1.4,
                ),
              ),
              child: saved
                  ? const Icon(
                      Icons.check_rounded,
                      color: AppColors.onAccent,
                      size: 15,
                    )
                  : null,
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Text(
                'Tôi đã lưu các mã dự phòng',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
