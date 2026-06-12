import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/auth_controller_providers.dart';

const _authPrimary = AppColors.primary;
const _authPrimaryDark = AppColors.primaryDark;
const _authPrimaryGlow = AppColors.primary40;

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  static const contentKey = Key('sc001_login_content');
  static const identifierFieldKey = Key('sc001_login_identifier_field');
  static const passwordFieldKey = Key('sc001_login_password_field');
  static const passwordToggleKey = Key('sc001_login_password_toggle');
  static const submitKey = Key('sc001_login_submit');
  static const demoSubmitKey = Key('sc001_login_demo_submit');
  static const forgotPasswordKey = Key('sc001_login_forgot_password');
  static const registerKey = Key('sc001_login_register');

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false;
  bool _submitting = false;
  String _error = '';

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearFieldError() {
    if (_error.isEmpty) return;
    setState(() => _error = '');
  }

  Future<void> _handleLogin() async {
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text;

    if (identifier.isEmpty) {
      setState(() => _error = 'Vui lòng nhập email hoặc số điện thoại.');
      return;
    }
    if (password.isEmpty) {
      setState(() => _error = 'Vui lòng nhập mật khẩu.');
      return;
    }

    await _submit(identifier: identifier, password: password);
  }

  Future<void> _handleDemoLogin() async {
    await _submit(identifier: 'demo@vittrade.vn', password: 'demo', demo: true);
  }

  Future<void> _submit({
    required String identifier,
    required String password,
    bool demo = false,
  }) async {
    if (_submitting) return;
    setState(() {
      _error = '';
      _submitting = true;
    });

    try {
      await ref
          .read(authControllerProvider)
          .login(identifier: identifier, password: password, demo: demo);
      if (mounted) context.go(AppRoutePaths.home);
    } catch (error) {
      if (mounted) {
        setState(() => _error = authOperationErrorMessage(error));
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final missingIdentifier =
        _error.isNotEmpty && _identifierController.text.trim().isEmpty;
    final missingPassword =
        _error.isNotEmpty &&
        _identifierController.text.trim().isNotEmpty &&
        _passwordController.text.isEmpty;

    return VitPageLayout(
      semanticLabel: 'SC-001 LoginPage',
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            key: LoginPage.contentKey,
            padding: const EdgeInsets.only(bottom: AppSpacing.x6),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    52,
                    AppSpacing.contentPad,
                    AppSpacing.x3,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    customGap: 0,
                    fullBleed: true,
                    children: [
                      const VitCard(
                        padding: EdgeInsets.zero,
                        child: _LoginHero(),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 49)),
                      VitCard(
                        padding: EdgeInsets.zero,
                        child: _LoginForm(
                          identifierController: _identifierController,
                          passwordController: _passwordController,
                          showPassword: _showPassword,
                          submitting: _submitting,
                          error: _error,
                          missingIdentifier: missingIdentifier,
                          missingPassword: missingPassword,
                          onChanged: _clearFieldError,
                          onTogglePassword: () {
                            setState(() => _showPassword = !_showPassword);
                          },
                          onLogin: _handleLogin,
                          onDemoLogin: _handleDemoLogin,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 52)),
                      const VitCard(
                        padding: EdgeInsets.zero,
                        child: _LegalFooter(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LoginHero extends StatelessWidget {
  const _LoginHero();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_authPrimary, _authPrimaryDark],
            ),
            borderRadius: AppRadii.cardRadius,
            boxShadow: const [
              BoxShadow(
                color: _authPrimaryGlow,
                blurRadius: 32,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: const Center(child: _VitTradeLogoMark()),
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
        Text('VitTrade', style: AppTextStyles.pageTitle),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
        Text(
          'Giao dịch thông minh, an toàn, tốc độ',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.identifierController,
    required this.passwordController,
    required this.showPassword,
    required this.submitting,
    required this.error,
    required this.missingIdentifier,
    required this.missingPassword,
    required this.onChanged,
    required this.onTogglePassword,
    required this.onLogin,
    required this.onDemoLogin,
  });

  final TextEditingController identifierController;
  final TextEditingController passwordController;
  final bool showPassword;
  final bool submitting;
  final String error;
  final bool missingIdentifier;
  final bool missingPassword;
  final VoidCallback onChanged;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;
  final VoidCallback onDemoLogin;

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitInput(
            controller: identifierController,
            fieldKey: LoginPage.identifierFieldKey,
            label: 'Email / Số điện thoại',
            hintText: 'you@example.com',
            prefix: const Icon(Icons.mail_outline_rounded),
            errorText: missingIdentifier ? ' ' : null,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.username, AutofillHints.email],
            onChanged: (_) => onChanged(),
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
          VitInput(
            controller: passwordController,
            fieldKey: LoginPage.passwordFieldKey,
            label: 'Mật khẩu',
            hintText: '••••••••',
            prefix: const Icon(Icons.lock_outline_rounded),
            suffix: VitIconButton(
              key: LoginPage.passwordToggleKey,
              icon: showPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              tooltip: showPassword ? 'Ẩn mật khẩu' : 'Hiện mật khẩu',
              onPressed: onTogglePassword,
              variant: VitIconButtonVariant.transparent,
              size: VitIconButtonSize.sm,
            ),
            errorText: missingPassword ? ' ' : null,
            obscureText: !showPassword,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            onChanged: (_) => onChanged(),
            onSubmitted: (_) => onLogin(),
          ),
          if (error.isNotEmpty) ...[
            const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
            _LoginErrorBanner(error: error),
          ],
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              key: LoginPage.forgotPasswordKey,
              onPressed: submitting
                  ? null
                  : () => context.go(AppRoutePaths.authForgotPassword),
              style: TextButton.styleFrom(
                foregroundColor: _authPrimary,
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Quên mật khẩu?',
                style: AppTextStyles.caption.copyWith(color: _authPrimary),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
          VitCtaButton(
            key: LoginPage.submitKey,
            onPressed: submitting ? null : onLogin,
            loading: submitting,
            variant: VitCtaButtonVariant.auth,
            child: const Text('Đăng nhập'),
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
          const _DividerLabel(),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
          VitCtaButton(
            key: LoginPage.demoSubmitKey,
            onPressed: submitting ? null : onDemoLogin,
            variant: VitCtaButtonVariant.ghost,
            leading: const Icon(Icons.fingerprint_rounded, color: _authPrimary),
            child: const Text('Đăng nhập Demo'),
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Chưa có tài khoản?',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              TextButton(
                key: LoginPage.registerKey,
                onPressed: submitting
                    ? null
                    : () => context.go(AppRoutePaths.authRegister),
                style: TextButton.styleFrom(
                  foregroundColor: _authPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Đăng ký ngay',
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

class _LoginErrorBanner extends StatelessWidget {
  const _LoginErrorBanner({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.sell10,
        borderRadius: AppRadii.mdRadius,
        border: Border.all(color: AppColors.sell20),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.sell,
            size: 14,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              error,
              style: AppTextStyles.caption.copyWith(color: AppColors.sell),
            ),
          ),
        ],
      ),
    );
  }
}

class _DividerLabel extends StatelessWidget {
  const _DividerLabel();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.borderSolid, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          child: Text(
            'hoặc',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.borderSolid, height: 1)),
      ],
    );
  }
}

class _LegalFooter extends StatelessWidget {
  const _LegalFooter();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'Bằng cách đăng nhập, bạn đồng ý với ',
        children: const [
          TextSpan(
            text: 'Điều khoản dịch vụ',
            style: TextStyle(color: AppColors.text2),
          ),
          TextSpan(text: ' và '),
          TextSpan(
            text: 'Chính sách bảo mật',
            style: TextStyle(color: AppColors.text2),
          ),
          TextSpan(text: ' của VitTrade.'),
        ],
      ),
      textAlign: TextAlign.center,
      style: AppTextStyles.micro.copyWith(color: AppColors.text3, fontSize: 11),
    );
  }
}

class _VitTradeLogoMark extends StatelessWidget {
  const _VitTradeLogoMark();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(36, 36),
      painter: _VitTradeLogoPainter(),
    );
  }
}

class _VitTradeLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final primary = Paint()
      ..color = AppColors.onAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final secondary = Paint()
      ..color = AppColors.onAccent.withValues(alpha: 0.5)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final first = Path()
      ..moveTo(6, 18)
      ..lineTo(14, 10)
      ..lineTo(20, 16)
      ..lineTo(28, 8);
    final second = Path()
      ..moveTo(6, 26)
      ..lineTo(14, 18)
      ..lineTo(20, 24)
      ..lineTo(30, 14);

    canvas.drawPath(first, primary);
    canvas.drawPath(second, secondary);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
