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
import 'otp_page.dart';

const _authPrimary = AppColors.primary;
const _authSegmentActive = AppColors.primary20;

enum _RegisterContactType { email, phone }

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  static const contentKey = Key('sc002_register_content');
  static const emailTabKey = Key('sc002_register_email_tab');
  static const phoneTabKey = Key('sc002_register_phone_tab');
  static const nameFieldKey = Key('sc002_register_name_field');
  static const contactFieldKey = Key('sc002_register_contact_field');
  static const passwordFieldKey = Key('sc002_register_password_field');
  static const confirmFieldKey = Key('sc002_register_confirm_field');
  static const referralFieldKey = Key('sc002_register_referral_field');
  static const passwordToggleKey = Key('sc002_register_password_toggle');
  static const agreementKey = Key('sc002_register_agreement');
  static const submitKey = Key('sc002_register_submit');
  static const loginKey = Key('sc002_register_login');

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _referralController = TextEditingController();

  _RegisterContactType _contactType = _RegisterContactType.email;
  bool _showPassword = false;
  bool _agreed = false;
  bool _submitting = false;
  Map<String, String> _errors = const {};

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  void _setContactType(_RegisterContactType value) {
    if (_contactType == value) return;
    setState(() {
      _contactType = value;
      _errors = {..._errors}..remove('contact');
    });
  }

  void _clearError(String key) {
    setState(() {
      final nextErrors = {..._errors}..remove(key);
      _errors = nextErrors;
    });
  }

  void _formatReferral(String value) {
    final formatted = value.toUpperCase();
    if (value == formatted) return;
    _referralController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  bool _validate() {
    final nextErrors = <String, String>{};
    final contact = _contactController.text.trim();
    final password = _passwordController.text;

    if (_nameController.text.trim().isEmpty) {
      nextErrors['name'] = 'Vui lòng nhập họ tên';
    }
    if (contact.isEmpty) {
      nextErrors['contact'] = _contactType == _RegisterContactType.email
          ? 'Vui lòng nhập email'
          : 'Vui lòng nhập số điện thoại';
    } else if (_contactType == _RegisterContactType.email &&
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(contact)) {
      nextErrors['contact'] = 'Email không hợp lệ';
    }
    if (password.length < 8) {
      nextErrors['password'] = 'Mật khẩu tối thiểu 8 ký tự';
    }
    if (password != _confirmController.text) {
      nextErrors['confirm'] = 'Mật khẩu xác nhận không khớp';
    }
    if (!_agreed) {
      nextErrors['agreed'] = 'Vui lòng đồng ý điều khoản dịch vụ';
    }

    setState(() => _errors = nextErrors);
    return nextErrors.isEmpty;
  }

  Future<void> _handleRegister() async {
    if (_submitting || !_validate()) return;

    setState(() => _submitting = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .register(
            name: _nameController.text.trim(),
            contact: _contactController.text.trim(),
            contactType: _contactType == _RegisterContactType.email
                ? AuthContactType.email
                : AuthContactType.phone,
            password: _passwordController.text,
            referralCode: _referralController.text.trim().isEmpty
                ? null
                : _referralController.text.trim(),
          );
      if (mounted) {
        context.go(
          AppRoutePaths.authOtp,
          extra: OtpPageRouteArgs(
            contact: _contactController.text.trim(),
            contactType: _contactType == _RegisterContactType.email
                ? AuthContactType.email
                : AuthContactType.phone,
            purpose: AuthOtpPurpose.register,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEmail = _contactType == _RegisterContactType.email;

    return VitPageLayout(
      semanticLabel: 'SC-002 RegisterPage',
      child: Column(
        children: [
          VitHeader(
            title: 'Tạo tài khoản',
            subtitle: 'Xác thực · Đăng ký',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.authLogin),
          ),
          Expanded(
            child: SingleChildScrollView(
              key: RegisterPage.contentKey,
              padding: const EdgeInsets.only(bottom: AppSpacing.x6),
              child: AutofillGroup(
                child: VitPageContent(
                  customGap: 16,
                  children: [
                    _RegisterSegmentedControl(
                      contactType: _contactType,
                      onChanged: _setContactType,
                    ),
                    VitInput(
                      controller: _nameController,
                      fieldKey: RegisterPage.nameFieldKey,
                      label: 'Họ và tên',
                      hintText: 'Nguyễn Văn A',
                      prefix: const Icon(Icons.person_outline_rounded),
                      errorText: _errors['name'],
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                      onChanged: (_) => _clearError('name'),
                    ),
                    VitInput(
                      controller: _contactController,
                      fieldKey: RegisterPage.contactFieldKey,
                      label: isEmail ? 'Email' : 'Số điện thoại',
                      hintText: isEmail ? 'you@example.com' : '+84 912 345 678',
                      prefix: Icon(
                        isEmail
                            ? Icons.mail_outline_rounded
                            : Icons.phone_iphone_rounded,
                      ),
                      errorText: _errors['contact'],
                      keyboardType: isEmail
                          ? TextInputType.emailAddress
                          : TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      autofillHints: isEmail
                          ? const [AutofillHints.email]
                          : const [AutofillHints.telephoneNumber],
                      onChanged: (_) => _clearError('contact'),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        VitInput(
                          controller: _passwordController,
                          fieldKey: RegisterPage.passwordFieldKey,
                          label: 'Mật khẩu',
                          hintText: '••••••••',
                          prefix: const Icon(Icons.lock_outline_rounded),
                          suffix: VitIconButton(
                            key: RegisterPage.passwordToggleKey,
                            icon: _showPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            tooltip: _showPassword
                                ? 'Ẩn mật khẩu'
                                : 'Hiện mật khẩu',
                            onPressed: () {
                              setState(() => _showPassword = !_showPassword);
                            },
                            variant: VitIconButtonVariant.transparent,
                            size: VitIconButtonSize.sm,
                          ),
                          errorText: _errors['password'],
                          obscureText: !_showPassword,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.newPassword],
                          onChanged: (_) => _clearError('password'),
                        ),
                        if (_passwordController.text.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.x3),
                            child: _PasswordStrength(
                              password: _passwordController.text,
                            ),
                          ),
                      ],
                    ),
                    VitInput(
                      controller: _confirmController,
                      fieldKey: RegisterPage.confirmFieldKey,
                      label: 'Xác nhận mật khẩu',
                      hintText: '••••••••',
                      prefix: const Icon(Icons.lock_outline_rounded),
                      errorText: _errors['confirm'],
                      obscureText: !_showPassword,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newPassword],
                      onChanged: (_) => _clearError('confirm'),
                    ),
                    VitInput(
                      controller: _referralController,
                      fieldKey: RegisterPage.referralFieldKey,
                      label: 'Mã giới thiệu (tuỳ chọn)',
                      hintText: 'VD: VITTA-A2B3C',
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: const [],
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {
                        _formatReferral(value);
                        _clearError('referral');
                      },
                      onSubmitted: (_) => _handleRegister(),
                    ),
                    _AgreementRow(
                      agreed: _agreed,
                      error: _errors['agreed'],
                      onTap: () {
                        setState(() {
                          _agreed = !_agreed;
                          final nextErrors = {..._errors}..remove('agreed');
                          _errors = nextErrors;
                        });
                      },
                    ),
                    VitCtaButton(
                      key: RegisterPage.submitKey,
                      onPressed: _submitting ? null : _handleRegister,
                      loading: _submitting,
                      variant: VitCtaButtonVariant.auth,
                      child: const Text('Tiếp tục'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Đã có tài khoản?',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                        TextButton(
                          key: RegisterPage.loginKey,
                          onPressed: _submitting
                              ? null
                              : () => context.go(AppRoutePaths.authLogin),
                          style: TextButton.styleFrom(
                            foregroundColor: _authPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            minimumSize: const Size(0, 32),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Đăng nhập',
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegisterSegmentedControl extends StatelessWidget {
  const _RegisterSegmentedControl({
    required this.contactType,
    required this.onChanged,
  });

  final _RegisterContactType contactType;
  final ValueChanged<_RegisterContactType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        children: [
          _RegisterSegmentButton(
            key: RegisterPage.emailTabKey,
            label: 'Email',
            selected: contactType == _RegisterContactType.email,
            onPressed: () => onChanged(_RegisterContactType.email),
          ),
          _RegisterSegmentButton(
            key: RegisterPage.phoneTabKey,
            label: 'Điện thoại',
            selected: contactType == _RegisterContactType.phone,
            onPressed: () => onChanged(_RegisterContactType.phone),
          ),
        ],
      ),
    );
  }
}

class _RegisterSegmentButton extends StatelessWidget {
  const _RegisterSegmentButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox.expand(
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadii.cardRadius,
          child: InkWell(
            onTap: onPressed,
            borderRadius: AppRadii.cardRadius,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? _authSegmentActive : Colors.transparent,
                borderRadius: AppRadii.cardRadius,
              ),
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(
                  color: selected ? _authPrimary : AppColors.text2,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AgreementRow extends StatelessWidget {
  const _AgreementRow({required this.agreed, required this.onTap, this.error});

  final bool agreed;
  final VoidCallback onTap;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final hasError = error != null && error!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          checked: agreed,
          label: 'Đồng ý điều khoản dịch vụ',
          child: InkWell(
            key: RegisterPage.agreementKey,
            onTap: onTap,
            borderRadius: AppRadii.mdRadius,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: agreed ? _authPrimary : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: hasError
                          ? AppColors.sell
                          : agreed
                          ? _authPrimary
                          : AppColors.borderSolid,
                      width: 1.3,
                    ),
                  ),
                  child: agreed
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 14,
                        )
                      : null,
                ),
                const SizedBox(width: AppSpacing.x4),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'Tôi đã đọc và đồng ý với ',
                      children: const [
                        TextSpan(
                          text: 'Điều khoản dịch vụ',
                          style: TextStyle(color: _authPrimary),
                        ),
                        TextSpan(text: ' và '),
                        TextSpan(
                          text: 'Chính sách bảo mật',
                          style: TextStyle(color: _authPrimary),
                        ),
                        TextSpan(text: ' của VitTrade.'),
                      ],
                    ),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.x2),
          Text(
            error!,
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

class _PasswordStrength extends StatelessWidget {
  const _PasswordStrength({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final checks = [
      _PasswordCheck('Ít nhất 8 ký tự', password.length >= 8),
      _PasswordCheck(
        'Chữ hoa & thường',
        RegExp('[A-Z]').hasMatch(password) &&
            RegExp('[a-z]').hasMatch(password),
      ),
      _PasswordCheck('Có số', RegExp(r'\d').hasMatch(password)),
      _PasswordCheck(
        'Ký tự đặc biệt',
        RegExp(r'[!@#$%^&*]').hasMatch(password),
      ),
    ];
    final score = checks.where((item) => item.ok).length;
    final color = switch (score) {
      0 || 1 => AppColors.sell,
      2 => AppColors.warn,
      3 || 4 => AppColors.buy,
      _ => AppColors.text3,
    };
    final label = switch (score) {
      1 => 'Yếu',
      2 => 'Trung bình',
      3 => 'Mạnh',
      4 => 'Rất mạnh',
      _ => '',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (var index = 0; index < 4; index++) ...[
              if (index > 0) const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: index < score ? color : AppColors.borderSolid,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        Wrap(
          spacing: AppSpacing.x3,
          runSpacing: AppSpacing.x2,
          children: [
            for (final check in checks)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    check.ok
                        ? Icons.check_circle_outline_rounded
                        : Icons.cancel_outlined,
                    size: 11,
                    color: check.ok ? AppColors.buy : AppColors.text3,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Text(
                    check.label,
                    style: AppTextStyles.micro.copyWith(
                      color: check.ok ? AppColors.buy : AppColors.text3,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
          ],
        ),
        if (label.isNotEmpty)
          Text(
            'Mật khẩu $label',
            style: AppTextStyles.micro.copyWith(color: color, fontSize: 12),
          ),
      ],
    );
  }
}

class _PasswordCheck {
  const _PasswordCheck(this.label, this.ok);

  final String label;
  final bool ok;
}
