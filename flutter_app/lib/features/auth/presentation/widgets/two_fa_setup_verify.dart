part of '../pages/two_fa_setup_page.dart';

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn15,
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
          const Padding(padding: EdgeInsets.only(top: 18)),
          Text(
            'Bước 2: Xác minh mã',
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle,
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
          Text(
            'Nhập mã 6 chữ số từ ứng dụng xác thực của bạn',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const Padding(padding: EdgeInsets.only(top: 28)),
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
                  child: VitInput(
                    fieldKey: TwoFASetupPage.codeFieldKey,
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
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
          Text(
            'Chạm vào đây để nhập mã',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: _authPrimary),
          ),
          if (error.isNotEmpty) ...[
            const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
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
    return VitCard(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      variant: VitCardVariant.inner,
      borderColor: AppColors.sell20,
      child: Text(
        error,
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(color: AppColors.sell),
      ),
    );
  }
}
