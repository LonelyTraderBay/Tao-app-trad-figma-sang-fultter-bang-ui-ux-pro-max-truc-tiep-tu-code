part of '../pages/reset_password_page.dart';

class _ResetExpired extends StatelessWidget {
  const _ResetExpired();

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: ResetPasswordPage.expiredKey,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x6),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.warn10,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.warningBorder, width: 2),
            ),
            child: const Icon(
              Icons.lock_clock_outlined,
              color: AppColors.warn,
              size: 40,
            ),
          ),
          const SizedBox(height: AppSpacing.x6),
          Text(
            'Phiên xác minh đã hết hạn',
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(fontSize: 22),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Vui lòng xác minh OTP lại để tạo mật khẩu mới. '
            'Mã OTP không được lưu trong URL.',
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
