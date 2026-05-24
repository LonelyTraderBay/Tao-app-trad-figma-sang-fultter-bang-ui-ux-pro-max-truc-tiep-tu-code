import 'package:flutter/material.dart';
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

final class PasswordRule {
  const PasswordRule({required this.label, required this.test});

  final String label;
  final bool Function(String value) test;
}

const _passwordRules = [
  PasswordRule(label: 'Tối thiểu 8 ký tự', test: _hasMinLength),
  PasswordRule(label: 'Có ít nhất 1 chữ cái', test: _hasLetter),
  PasswordRule(label: 'Có ít nhất 1 chữ số', test: _hasDigit),
];

bool _hasMinLength(String value) => value.length >= 8;

bool _hasLetter(String value) => RegExp('[a-zA-Z]').hasMatch(value);

bool _hasDigit(String value) => RegExp(r'\d').hasMatch(value);

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({
    super.key,
    this.email = 'user@vittrade.vn',
    this.otp = '123456',
  });

  final String email;
  final String otp;

  static const contentKey = Key('sc006_reset_content');
  static const newPasswordFieldKey = Key('sc006_reset_new_password_field');
  static const confirmPasswordFieldKey = Key(
    'sc006_reset_confirm_password_field',
  );
  static const newPasswordToggleKey = Key('sc006_reset_new_password_toggle');
  static const confirmPasswordToggleKey = Key(
    'sc006_reset_confirm_password_toggle',
  );
  static const submitKey = Key('sc006_reset_submit');
  static const loginKey = Key('sc006_reset_login');

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _submitting = false;
  bool _success = false;
  bool _confirmTouched = false;
  String _error = '';

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String get _newPassword => _newPasswordController.text;

  String get _confirmPassword => _confirmPasswordController.text;

  bool get _allRulesPass =>
      _passwordRules.every((rule) => rule.test(_newPassword));

  bool get _passwordsMatch => _newPassword == _confirmPassword;

  bool get _showMismatch =>
      _confirmTouched && _confirmPassword.isNotEmpty && !_passwordsMatch;

  bool get _showMatch =>
      _confirmTouched && _confirmPassword.isNotEmpty && _passwordsMatch;

  bool get _canSubmit =>
      !_submitting &&
      _allRulesPass &&
      _passwordsMatch &&
      _confirmPassword.isNotEmpty;

  void _goBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.authLogin);
  }

  void _handleNewPasswordChanged() {
    setState(() {
      _error = '';
    });
  }

  void _handleConfirmPasswordChanged() {
    setState(() {
      _confirmTouched = true;
      _error = '';
    });
  }

  Future<void> _handleSubmit() async {
    if (!_canSubmit) return;
    setState(() {
      _submitting = true;
      _error = '';
    });

    try {
      final result = await ref
          .read(authRepositoryProvider)
          .resetPassword(
            email: widget.email,
            otp: widget.otp,
            newPassword: _newPassword,
          );

      if (!mounted) return;
      if (!result.success) {
        setState(() {
          _error =
              result.errorMessage ??
              'Không thể cập nhật mật khẩu. Vui lòng thử lại.';
        });
        return;
      }

      setState(() => _success = true);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      semanticLabel: 'SC-006 ResetPasswordPage',
      child: Column(
        children: [
          VitHeader(
            title: 'Đặt lại mật khẩu',
            subtitle: 'Xác thực · Bảo mật',
            showBack: true,
            onBack: _goBack,
          ),
          Expanded(
            child: SingleChildScrollView(
              key: ResetPasswordPage.contentKey,
              padding: const EdgeInsets.only(bottom: AppSpacing.x6),
              child: VitPageContent(
                padding: VitContentPadding.relaxed,
                gap: VitContentGap.relaxed,
                children: _success ? _successContent : _formContent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> get _formContent => [
    const _ResetHero(),
    Column(
      children: [
        VitInput(
          controller: _newPasswordController,
          fieldKey: ResetPasswordPage.newPasswordFieldKey,
          label: 'Mật khẩu mới',
          hintText: '••••••••',
          prefix: const Icon(Icons.lock_outline_rounded),
          suffix: VitIconButton(
            key: ResetPasswordPage.newPasswordToggleKey,
            icon: _showNewPassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            tooltip: _showNewPassword ? 'Ẩn mật khẩu' : 'Hiện mật khẩu',
            onPressed: () {
              setState(() => _showNewPassword = !_showNewPassword);
            },
            variant: VitIconButtonVariant.transparent,
            size: VitIconButtonSize.sm,
          ),
          errorText: _newPassword.isNotEmpty && !_allRulesPass ? ' ' : null,
          obscureText: !_showNewPassword,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
          onChanged: (_) => _handleNewPasswordChanged(),
        ),
        const SizedBox(height: 12),
        _PasswordRulesList(password: _newPassword),
      ],
    ),
    VitInput(
      controller: _confirmPasswordController,
      fieldKey: ResetPasswordPage.confirmPasswordFieldKey,
      label: 'Nhập lại mật khẩu',
      hintText: '••••••••',
      prefix: const Icon(Icons.lock_outline_rounded),
      suffix: VitIconButton(
        key: ResetPasswordPage.confirmPasswordToggleKey,
        icon: _showConfirmPassword
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
        tooltip: _showConfirmPassword ? 'Ẩn mật khẩu' : 'Hiện mật khẩu',
        onPressed: () {
          setState(() => _showConfirmPassword = !_showConfirmPassword);
        },
        variant: VitIconButtonVariant.transparent,
        size: VitIconButtonSize.sm,
      ),
      errorText: _showMismatch ? 'Mật khẩu không khớp' : null,
      obscureText: !_showConfirmPassword,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.newPassword],
      onChanged: (_) => _handleConfirmPasswordChanged(),
      onSubmitted: (_) => _handleSubmit(),
    ),
    if (_showMatch) const _InlinePasswordState(success: true),
    if (_error.isNotEmpty) _InlinePasswordState(error: _error),
    VitCtaButton(
      key: ResetPasswordPage.submitKey,
      onPressed: _canSubmit ? _handleSubmit : null,
      loading: _submitting,
      variant: VitCtaButtonVariant.auth,
      child: Text(_submitting ? 'Đang cập nhật...' : 'Cập nhật mật khẩu'),
    ),
    TextButton(
      key: ResetPasswordPage.loginKey,
      onPressed: _submitting ? null : () => context.go(AppRoutePaths.authLogin),
      style: TextButton.styleFrom(
        foregroundColor: _authPrimary,
        minimumSize: const Size(0, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        'Quay lại đăng nhập',
        style: AppTextStyles.caption.copyWith(
          color: _authPrimary,
          fontWeight: AppTextStyles.medium,
        ),
      ),
    ),
  ];

  List<Widget> get _successContent => [
    const _ResetSuccess(),
    VitCtaButton(
      key: ResetPasswordPage.loginKey,
      onPressed: () => context.go(AppRoutePaths.authLogin),
      variant: VitCtaButtonVariant.auth,
      child: const Text('Đăng nhập'),
    ),
  ];
}

class _ResetHero extends StatelessWidget {
  const _ResetHero();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: _authPrimary10,
            borderRadius: AppRadii.cardRadius,
            border: Border.all(color: _authPrimary30, width: 1.5),
          ),
          child: const Icon(
            Icons.lock_outline_rounded,
            color: _authPrimary,
            size: 34,
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        Text(
          'Tạo mật khẩu mới',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 22),
        ),
        const SizedBox(height: AppSpacing.x3),
        Text(
          'Chọn mật khẩu mạnh để bảo vệ tài khoản của bạn.',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _PasswordRulesList extends StatelessWidget {
  const _PasswordRulesList({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final rule in _passwordRules) ...[
          _PasswordRuleRow(label: rule.label, pass: rule.test(password)),
          if (rule != _passwordRules.last) const SizedBox(height: 6),
        ],
      ],
    );
  }
}

class _PasswordRuleRow extends StatelessWidget {
  const _PasswordRuleRow({required this.label, required this.pass});

  final String label;
  final bool pass;

  @override
  Widget build(BuildContext context) {
    final color = pass ? AppColors.buy : AppColors.text3;
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: pass ? AppColors.buy15 : AppColors.hoverBg,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check_rounded, color: color, size: 10),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: color, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _InlinePasswordState extends StatelessWidget {
  const _InlinePasswordState({this.success = false, this.error});

  final bool success;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final color = success ? AppColors.buy : AppColors.sell;
    final text = success ? 'Mật khẩu khớp' : error ?? 'Mật khẩu không khớp';
    final icon = success
        ? Icons.check_circle_outline_rounded
        : Icons.error_outline_rounded;

    return Row(
      children: [
        Icon(icon, color: color, size: 12),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.micro.copyWith(color: color, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _ResetSuccess extends StatelessWidget {
  const _ResetSuccess();

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
            'Đổi mật khẩu thành công!',
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(fontSize: 22),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Mật khẩu của bạn đã được cập nhật.\n'
            'Vui lòng đăng nhập lại với mật khẩu mới.',
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
