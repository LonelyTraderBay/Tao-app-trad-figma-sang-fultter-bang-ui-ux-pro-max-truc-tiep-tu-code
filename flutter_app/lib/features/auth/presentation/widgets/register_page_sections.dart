part of '../pages/register_page.dart';

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
            borderRadius: AppRadii.inputRadius,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: AppSpacing.authAgreementCheckMargin,
                  child: SizedBox.square(
                    dimension: AppSpacing.authAgreementCheckSize,
                    child: Material(
                      color: agreed ? _authPrimary : AppColors.transparent,
                      shape: CircleBorder(
                        side: BorderSide(
                          color: hasError
                              ? AppColors.sell
                              : agreed
                              ? _authPrimary
                              : AppColors.borderSolid,
                          width: AppSpacing.authAgreementCheckBorder,
                        ),
                      ),
                      child: agreed
                          ? const Icon(
                              Icons.check_rounded,
                              color: AppColors.onAccent,
                              size: AppSpacing.authInlineCheckIcon,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x4),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'Tôi đã đọc và đồng ý với ',
                      children: [
                        TextSpan(
                          text: 'Điều khoản dịch vụ',
                          style: AppTextStyles.caption.copyWith(
                            color: _authPrimary,
                          ),
                        ),
                        TextSpan(text: ' và '),
                        TextSpan(
                          text: 'Chính sách bảo mật',
                          style: AppTextStyles.caption.copyWith(
                            color: _authPrimary,
                          ),
                        ),
                        TextSpan(text: ' của VitTrade.'),
                      ],
                    ),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: AppSpacing.authAgreementLineHeight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          const Padding(padding: AppSpacing.authTopGapX2),
          Text(
            error!,
            style: AppTextStyles.micro.copyWith(color: AppColors.sell),
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
                child: ClipRRect(
                  borderRadius: AppRadii.pillRadius,
                  child: ColoredBox(
                    color: index < score ? color : AppColors.borderSolid,
                    child: const SizedBox(
                      height: AppSpacing.authPasswordStrengthHeight,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        const Padding(padding: AppSpacing.authTopGapX3),
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
                    size: AppSpacing.authPasswordStrengthIcon,
                    color: check.ok ? AppColors.buy : AppColors.text3,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Text(
                    check.label,
                    style: AppTextStyles.micro.copyWith(
                      color: check.ok ? AppColors.buy : AppColors.text3,
                    ),
                  ),
                ],
              ),
          ],
        ),
        if (label.isNotEmpty)
          Text(
            'Mật khẩu $label',
            style: AppTextStyles.captionSm.copyWith(color: color),
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
