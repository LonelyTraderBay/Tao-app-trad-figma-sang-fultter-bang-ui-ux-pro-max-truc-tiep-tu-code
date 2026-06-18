part of '../pages/reset_password_page.dart';

class _ResetExpired extends StatelessWidget {
  const _ResetExpired();

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: ResetPasswordPage.expiredKey,
      padding: AppSpacing.authStateVerticalPadding,
      child: Column(
        children: [
          SizedBox.square(
            dimension: AppSpacing.authHeroIconBoxMd,
            child: Material(
              color: AppColors.warn10,
              shape: const CircleBorder(
                side: BorderSide(
                  color: AppColors.warningBorder,
                  width: AppSpacing.hairlineStroke,
                ),
              ),
              child: const Icon(
                Icons.lock_clock_outlined,
                color: AppColors.warn,
                size: AppSpacing.authHeroIconLg,
              ),
            ),
          ),
          const Padding(padding: AppSpacing.authTopGapX6),
          Text(
            'Phiên xác minh đã hết hạn',
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle,
          ),
          const Padding(padding: AppSpacing.authTopGapX3),
          Text(
            'Vui lòng xác minh OTP lại để tạo mật khẩu mới. '
            'Mã OTP không được lưu trong URL.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text2,
              height: AppSpacing.authReadableLineHeight,
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
        SizedBox.square(
          dimension: AppSpacing.authHeroIconBoxSm,
          child: Material(
            color: _authPrimary10,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.cardRadius,
              side: BorderSide(
                color: _authPrimary30,
                width: AppSpacing.borderWidth,
              ),
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: _authPrimary,
              size: AppSpacing.authHeroIconMd,
            ),
          ),
        ),
        const Padding(padding: AppSpacing.authTopGapX5),
        Text(
          'Tạo mật khẩu mới',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle,
        ),
        const Padding(padding: AppSpacing.authTopGapX3),
        Text(
          'Chọn mật khẩu mạnh để bảo vệ tài khoản của bạn.',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            height: AppSpacing.authReadableLineHeight,
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
          if (rule != _passwordRules.last)
            const Padding(padding: AppSpacing.authCompactTopPadding),
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
        SizedBox.square(
          dimension: AppSpacing.authInlineCheckIcon,
          child: Material(
            color: pass ? AppColors.buy15 : AppColors.hoverBg,
            shape: const CircleBorder(),
            child: Icon(
              Icons.check_rounded,
              color: color,
              size: AppSpacing.authInlineIconSm,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: color),
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
        Icon(icon, color: color, size: AppSpacing.authInlineIcon),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(text, style: AppTextStyles.micro.copyWith(color: color)),
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
      padding: AppSpacing.authStateVerticalPadding,
      child: Column(
        children: [
          SizedBox.square(
            dimension: AppSpacing.authStateIconBox,
            child: Material(
              color: AppColors.buy15,
              shape: const CircleBorder(
                side: BorderSide(
                  color: AppColors.buy20,
                  width: AppSpacing.hairlineStroke,
                ),
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
                size: AppSpacing.authStateIconLg,
              ),
            ),
          ),
          const Padding(padding: AppSpacing.authTopGapX6),
          Text(
            'Đổi mật khẩu thành công!',
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle,
          ),
          const Padding(padding: AppSpacing.authTopGapX3),
          Text(
            'Mật khẩu của bạn đã được cập nhật.\n'
            'Vui lòng đăng nhập lại với mật khẩu mới.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text2,
              height: AppSpacing.authReadableLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}
