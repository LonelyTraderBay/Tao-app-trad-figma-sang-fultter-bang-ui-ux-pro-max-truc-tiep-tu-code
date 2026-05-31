part of '../pages/copy_settings_page.dart';

class _EmergencyContactCard extends StatelessWidget {
  const _EmergencyContactCard({
    required this.email,
    required this.phone,
    required this.onEmailChanged,
    required this.onPhoneChanged,
  });

  final String email;
  final String phone;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPhoneChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warn08,
        border: Border.all(color: AppColors.warn15),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.warn,
                size: 15,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Người liên hệ khẩn cấp sẽ được thông báo nếu tài khoản của bạn có hoạt động bất thường hoặc kích hoạt circuit breaker.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.warn,
                    fontSize: 10,
                    fontWeight: AppTextStyles.medium,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          _SettingsTextField(
            label: 'Email',
            initialValue: email,
            hint: 'emergency@example.com',
            keyboardType: TextInputType.emailAddress,
            onChanged: onEmailChanged,
          ),
          const SizedBox(height: 10),
          _SettingsTextField(
            label: 'Số điện thoại',
            initialValue: phone,
            hint: '+84 xxx xxx xxx',
            keyboardType: TextInputType.phone,
            onChanged: onPhoneChanged,
          ),
        ],
      ),
    );
  }
}

class _SettingsTextField extends StatelessWidget {
  const _SettingsTextField({
    required this.label,
    required this.initialValue,
    required this.hint,
    required this.keyboardType,
    required this.onChanged,
  });

  final String label;
  final String initialValue;
  final String hint;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 10,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontSize: 12,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
            ),
            filled: true,
            fillColor: _settingsInput,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: AppRadii.inputRadius,
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadii.inputRadius,
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadii.inputRadius,
              borderSide: const BorderSide(color: _settingsPrimary),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrivacyCard extends StatelessWidget {
  const _PrivacyCard({required this.active, required this.onChanged});

  final bool active;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      height: 84,
      child: Row(
        children: [
          Icon(
            active ? Icons.visibility_rounded : Icons.visibility_off_rounded,
            color: active ? _settingsPrimary : AppColors.text3,
            size: 15,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hiển thị portfolio công khai', style: _cardTitleStyle()),
                const SizedBox(height: 5),
                Text(
                  'Cho phép người khác xem portfolio copy của bạn (không hiện số tiền cụ thể)',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 9,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _ToggleSwitch(value: active, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.saved, required this.onTap});

  final bool saved;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: CopySettingsPage.saveKey,
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: AppSpacing.inputHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: saved ? AppColors.buy : _settingsPrimary,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              saved ? Icons.shield_rounded : Icons.settings_rounded,
              color: AppColors.onAccent,
              size: 16,
            ),
            const SizedBox(width: 9),
            Text(
              saved ? 'Đã lưu!' : 'Lưu cài đặt',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.onAccent,
                fontSize: 14,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.child,
    required this.height,
    this.padding = const EdgeInsets.all(12),
  });

  final Widget child;
  final double height;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: _settingsPanel,
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

TextStyle _cardTitleStyle() {
  return AppTextStyles.caption.copyWith(
    color: AppColors.text1,
    fontSize: 12,
    fontWeight: AppTextStyles.bold,
    height: 1.15,
  );
}

String _modeLabel(TradeCopySettingsMode mode) {
  return switch (mode) {
    TradeCopySettingsMode.mirror => 'Mirror',
    TradeCopySettingsMode.fixed => 'Fixed',
    TradeCopySettingsMode.smart => 'Smart',
  };
}
