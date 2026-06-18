part of '../pages/two_fa_setup_page.dart';

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      width: double.infinity,
      padding: AppSpacing.authTwoFaBannerPadding,
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn15,
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: AppSpacing.authTwoFaWarningIcon,
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
          const Padding(padding: AppSpacing.authTwoFaHeroTopPadding),
          Text(
            'Bước 2: Xác minh mã',
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle,
          ),
          const Padding(padding: AppSpacing.authTopGapX3),
          Text(
            'Nhập mã 6 chữ số từ ứng dụng xác thực của bạn',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const Padding(padding: AppSpacing.authTwoFaVerifyCodeTopPadding),
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var index = 0; index < 6; index++) ...[
                    if (index > 0)
                      const SizedBox(width: AppSpacing.authTwoFaCodeDigitGap),
                    _CodeDigitBox(
                      digit: index < code.length ? code[index] : '',
                      hasError: error.isNotEmpty,
                    ),
                  ],
                ],
              ),
              SizedBox(
                width: AppSpacing.authTwoFaHiddenInputSize,
                height: AppSpacing.authTwoFaHiddenInputSize,
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
          const Padding(padding: AppSpacing.authTopGapX4),
          Text(
            'Chạm vào đây để nhập mã',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: _authPrimary),
          ),
          if (error.isNotEmpty) ...[
            const Padding(padding: AppSpacing.authTopGapX4),
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

    return SizedBox(
      width: AppSpacing.authTwoFaCodeDigitWidth,
      height: AppSpacing.authTwoFaCodeDigitHeight,
      child: Material(
        color: filled ? _authPrimary10 : AppColors.surface2,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.inputRadius,
          side: BorderSide(color: borderColor, width: AppSpacing.borderWidth),
        ),
        child: Center(
          child: Text(
            digit,
            style: AppTextStyles.sectionTitle.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
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
      padding: AppSpacing.authErrorBannerPadding,
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
