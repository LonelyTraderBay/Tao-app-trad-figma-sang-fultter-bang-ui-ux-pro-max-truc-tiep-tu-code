part of '../pages/register_page.dart';

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
          color: AppColors.transparent,
          borderRadius: AppRadii.cardRadius,
          child: InkWell(
            onTap: onPressed,
            borderRadius: AppRadii.cardRadius,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? _authSegmentActive : AppColors.transparent,
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
                    color: agreed ? _authPrimary : AppColors.transparent,
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
                          color: AppColors.onAccent,
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
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
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
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
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
