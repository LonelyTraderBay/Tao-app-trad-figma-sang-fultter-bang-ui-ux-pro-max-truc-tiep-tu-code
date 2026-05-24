import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/auth_repository.dart';

const _authPrimary = AppColors.primary;
const _authPrimary10 = AppColors.primary12;
const _authPrimary30 = AppColors.primary30;

enum _ForgotPasswordStep { input, otp, reset, success }

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  static const contentKey = Key('sc005_forgot_content');
  static const emailFieldKey = Key('sc005_forgot_email_field');
  static const otpFieldKey = Key('sc005_forgot_otp_field');
  static const newPasswordFieldKey = Key('sc005_forgot_new_password_field');
  static const confirmPasswordFieldKey = Key(
    'sc005_forgot_confirm_password_field',
  );
  static const passwordToggleKey = Key('sc005_forgot_password_toggle');
  static const submitKey = Key('sc005_forgot_submit');
  static const loginKey = Key('sc005_forgot_login');

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  _ForgotPasswordStep _step = _ForgotPasswordStep.input;
  bool _showPassword = false;
  bool _submitting = false;
  String _emailError = '';
  String _otpError = '';
  String _passwordError = '';

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String get _email => _emailController.text.trim();

  String get _otp => _otpController.text;

  String get _newPassword => _newPasswordController.text;

  String get _confirmPassword => _confirmPasswordController.text;

  bool get _canSubmit {
    if (_submitting) return false;
    return switch (_step) {
      _ForgotPasswordStep.input => _email.isNotEmpty,
      _ForgotPasswordStep.otp => _otp.length == 6,
      _ForgotPasswordStep.reset =>
        _newPassword.isNotEmpty && _newPassword == _confirmPassword,
      _ForgotPasswordStep.success => true,
    };
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.authLogin);
  }

  void _clearEmailError() {
    setState(() => _emailError = '');
  }

  void _clearOtpError() {
    setState(() => _otpError = '');
  }

  void _clearPasswordError() {
    setState(() => _passwordError = '');
  }

  Future<void> _handleSendOtp() async {
    if (_submitting) return;
    if (_email.isEmpty) {
      setState(() => _emailError = 'Vui lòng nhập email đã đăng ký.');
      return;
    }
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(_email)) {
      setState(() => _emailError = 'Email không hợp lệ.');
      return;
    }

    setState(() {
      _submitting = true;
      _emailError = '';
    });
    try {
      final result = await ref
          .read(authRepositoryProvider)
          .requestPasswordReset(email: _email);

      if (!mounted) return;
      if (!result.success) {
        setState(() {
          _emailError =
              result.errorMessage ?? 'Không thể gửi mã. Vui lòng thử lại.';
        });
        return;
      }
      setState(() => _step = _ForgotPasswordStep.otp);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _handleVerifyOtp() async {
    if (_submitting || _otp.length < 6) return;
    setState(() {
      _submitting = true;
      _otpError = '';
    });

    try {
      final result = await ref
          .read(authRepositoryProvider)
          .verifyFactor(
            contact: _email,
            code: _otp,
            purpose: AuthOtpPurpose.passwordReset,
          );

      if (!mounted) return;
      if (!result.success) {
        setState(() {
          _otpError = result.errorMessage ?? 'Mã OTP không đúng.';
          _otpController.clear();
        });
        return;
      }
      setState(() => _step = _ForgotPasswordStep.reset);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _handleResetPassword() async {
    if (_submitting) return;
    if (_newPassword.length < 8) {
      setState(() => _passwordError = 'Mật khẩu tối thiểu 8 ký tự.');
      return;
    }
    if (_newPassword != _confirmPassword) {
      setState(() => _passwordError = 'Mật khẩu không khớp');
      return;
    }

    setState(() {
      _submitting = true;
      _passwordError = '';
    });
    try {
      final result = await ref
          .read(authRepositoryProvider)
          .resetPassword(email: _email, otp: _otp, newPassword: _newPassword);

      if (!mounted) return;
      if (!result.success) {
        setState(() {
          _passwordError =
              result.errorMessage ??
              'Không thể đặt lại mật khẩu. Vui lòng thử lại.';
        });
        return;
      }
      setState(() => _step = _ForgotPasswordStep.success);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _handleOtpChanged(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final next = digits.length > 6 ? digits.substring(0, 6) : digits;
    if (_otpController.text != next) {
      _otpController.value = TextEditingValue(
        text: next,
        selection: TextSelection.collapsed(offset: next.length),
      );
    }
    _clearOtpError();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      semanticLabel: 'SC-005 ForgotPasswordPage',
      child: Column(
        children: [
          VitHeader(
            title: 'Quên mật khẩu',
            subtitle: 'Xác thực · Bảo mật',
            showBack: true,
            onBack: _goBack,
          ),
          Expanded(
            child: SingleChildScrollView(
              key: ForgotPasswordPage.contentKey,
              padding: const EdgeInsets.only(bottom: AppSpacing.x6),
              child: VitPageContent(
                padding: VitContentPadding.relaxed,
                gap: VitContentGap.relaxed,
                children: [
                  if (_step == _ForgotPasswordStep.input)
                    _EmailStep(
                      controller: _emailController,
                      error: _emailError,
                      onChanged: _clearEmailError,
                    ),
                  if (_step == _ForgotPasswordStep.otp)
                    _OtpStep(
                      controller: _otpController,
                      email: _email,
                      error: _otpError,
                      onChanged: _handleOtpChanged,
                    ),
                  if (_step == _ForgotPasswordStep.reset)
                    _ResetStep(
                      newPasswordController: _newPasswordController,
                      confirmPasswordController: _confirmPasswordController,
                      showPassword: _showPassword,
                      error: _passwordError,
                      onChanged: _clearPasswordError,
                      onTogglePassword: () {
                        setState(() => _showPassword = !_showPassword);
                      },
                    ),
                  if (_step == _ForgotPasswordStep.success)
                    const _SuccessStep(),
                  VitCtaButton(
                    key: _step == _ForgotPasswordStep.success
                        ? ForgotPasswordPage.loginKey
                        : ForgotPasswordPage.submitKey,
                    onPressed: _canSubmit ? _handlePrimaryAction : null,
                    loading: _submitting,
                    variant: _step == _ForgotPasswordStep.success
                        ? VitCtaButtonVariant.auth
                        : VitCtaButtonVariant.auth,
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

  VoidCallback get _handlePrimaryAction {
    return switch (_step) {
      _ForgotPasswordStep.input => _handleSendOtp,
      _ForgotPasswordStep.otp => _handleVerifyOtp,
      _ForgotPasswordStep.reset => _handleResetPassword,
      _ForgotPasswordStep.success => () {
        context.go(AppRoutePaths.authLogin);
      },
    };
  }

  String get _buttonLabel {
    if (_submitting && _step == _ForgotPasswordStep.input) return 'Đang gửi...';
    if (_submitting && _step == _ForgotPasswordStep.otp) {
      return 'Đang xác minh...';
    }
    if (_submitting && _step == _ForgotPasswordStep.reset) {
      return 'Đang đặt lại...';
    }
    return switch (_step) {
      _ForgotPasswordStep.input => 'Gửi mã xác minh',
      _ForgotPasswordStep.otp => 'Xác nhận',
      _ForgotPasswordStep.reset => 'Đặt lại mật khẩu',
      _ForgotPasswordStep.success => 'Đến trang đăng nhập',
    };
  }
}

class _EmailStep extends StatelessWidget {
  const _EmailStep({
    required this.controller,
    required this.error,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String error;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _KeyHero(),
        const SizedBox(height: AppSpacing.x5),
        Text(
          'Đặt lại mật khẩu',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 22),
        ),
        const SizedBox(height: AppSpacing.x3),
        Text(
          'Nhập email đã đăng ký. Chúng tôi sẽ gửi mã xác minh để đặt lại\n'
          'mật khẩu.',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 17),
        VitInput(
          controller: controller,
          fieldKey: ForgotPasswordPage.emailFieldKey,
          label: 'Email đăng ký',
          hintText: 'you@example.com',
          prefix: const Icon(Icons.mail_outline_rounded),
          errorText: error.isEmpty ? null : error,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.email, AutofillHints.username],
          onChanged: (_) => onChanged(),
        ),
      ],
    );
  }
}

class _KeyHero extends StatelessWidget {
  const _KeyHero();

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
          border: Border.all(color: _authPrimary30, width: 1.5),
        ),
        child: const CustomPaint(
          size: Size(32, 32),
          painter: _KeyIconPainter(),
        ),
      ),
    );
  }
}

class _KeyIconPainter extends CustomPainter {
  const _KeyIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _authPrimary
      ..strokeWidth = 2.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width * 0.38, size.height * 0.38);
    canvas.drawCircle(center, 5.2, paint);
    final path = Path()
      ..moveTo(center.dx + 4.1, center.dy + 4.1)
      ..lineTo(size.width * 0.68, size.height * 0.68)
      ..lineTo(size.width * 0.68, size.height * 0.8)
      ..moveTo(size.width * 0.68, size.height * 0.68)
      ..lineTo(size.width * 0.8, size.height * 0.68)
      ..moveTo(size.width * 0.56, size.height * 0.56)
      ..lineTo(size.width * 0.43, size.height * 0.69);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _OtpStep extends StatelessWidget {
  const _OtpStep({
    required this.controller,
    required this.email,
    required this.error,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String email;
  final String error;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Nhập mã OTP',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 22),
        ),
        const SizedBox(height: AppSpacing.x3),
        Text.rich(
          TextSpan(
            text: 'Mã 6 số đã được gửi đến ',
            children: [
              TextSpan(
                text: email,
                style: const TextStyle(color: AppColors.text1),
              ),
            ],
          ),
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          '(Demo: nhập 123456)',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: AppSpacing.x6),
        Text(
          'Mã OTP',
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: 6),
        TextField(
          key: ForgotPasswordPage.otpFieldKey,
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          style: AppTextStyles.sectionTitle.copyWith(
            fontSize: 24,
            fontWeight: AppTextStyles.bold,
            letterSpacing: 8,
          ),
          cursorColor: _authPrimary,
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: AppColors.surface2,
            contentPadding: EdgeInsets.zero,
            border: _otpBorder(
              error.isEmpty ? AppColors.borderSolid : AppColors.sell,
            ),
            enabledBorder: _otpBorder(
              error.isEmpty ? AppColors.borderSolid : AppColors.sell,
            ),
            focusedBorder: _otpBorder(_authPrimary, width: 2),
            errorBorder: _otpBorder(AppColors.sell),
            focusedErrorBorder: _otpBorder(AppColors.sell, width: 2),
          ),
          onChanged: onChanged,
        ),
        if (error.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.x2),
          Text(
            error,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.sell,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  OutlineInputBorder _otpBorder(Color color, {double width = 1.5}) {
    return OutlineInputBorder(
      borderRadius: AppRadii.inputRadius,
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class _ResetStep extends StatelessWidget {
  const _ResetStep({
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.showPassword,
    required this.error,
    required this.onChanged,
    required this.onTogglePassword,
  });

  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool showPassword;
  final String error;
  final VoidCallback onChanged;
  final VoidCallback onTogglePassword;

  @override
  Widget build(BuildContext context) {
    final confirmMismatch =
        confirmPasswordController.text.isNotEmpty &&
        confirmPasswordController.text != newPasswordController.text;

    return Column(
      children: [
        Text(
          'Mật khẩu mới',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 22),
        ),
        const SizedBox(height: AppSpacing.x3),
        Text(
          'Tạo mật khẩu mạnh để bảo vệ tài khoản',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x6),
        VitInput(
          controller: newPasswordController,
          fieldKey: ForgotPasswordPage.newPasswordFieldKey,
          label: 'Mật khẩu mới',
          hintText: '••••••••',
          prefix: const Icon(Icons.lock_outline_rounded),
          suffix: VitIconButton(
            key: ForgotPasswordPage.passwordToggleKey,
            icon: showPassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            tooltip: showPassword ? 'Ẩn mật khẩu' : 'Hiện mật khẩu',
            onPressed: onTogglePassword,
            variant: VitIconButtonVariant.transparent,
            size: VitIconButtonSize.sm,
          ),
          obscureText: !showPassword,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitInput(
          controller: confirmPasswordController,
          fieldKey: ForgotPasswordPage.confirmPasswordFieldKey,
          label: 'Xác nhận mật khẩu',
          hintText: '••••••••',
          prefix: const Icon(Icons.lock_outline_rounded),
          errorText: confirmMismatch ? 'Mật khẩu không khớp' : null,
          obscureText: !showPassword,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.newPassword],
          onChanged: (_) => onChanged(),
        ),
        if (error.isNotEmpty && !confirmMismatch) ...[
          const SizedBox(height: AppSpacing.x3),
          Text(
            error,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.sell,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}

class _SuccessStep extends StatelessWidget {
  const _SuccessStep();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x6),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.buy15,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.buy20, width: 2),
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.buy,
              size: 48,
            ),
          ),
          const SizedBox(height: AppSpacing.x6),
          Text(
            'Thành công!',
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(fontSize: 22),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Mật khẩu của bạn đã được đặt lại thành công.\n'
            'Vui lòng đăng nhập với mật khẩu mới.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text2,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
