part of '../pages/otp_page.dart';

class _OtpDigitRow extends StatelessWidget {
  const _OtpDigitRow({
    required this.controllers,
    required this.focusNodes,
    required this.hasError,
    required this.onChanged,
    required this.onKey,
  });

  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final bool hasError;
  final void Function(int index, String value) onChanged;
  final KeyEventResult Function(FocusNode node, KeyEvent event, int index)
  onKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var index = 0; index < controllers.length; index++) ...[
          if (index > 0) const SizedBox(width: 12),
          _OtpDigitField(
            index: index,
            controller: controllers[index],
            focusNode: focusNodes[index],
            hasError: hasError,
            onChanged: (value) => onChanged(index, value),
            onKey: (node, event) => onKey(node, event, index),
          ),
        ],
      ],
    );
  }
}

class _OtpDigitField extends StatelessWidget {
  const _OtpDigitField({
    required this.index,
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.onChanged,
    required this.onKey,
  });

  final int index;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final ValueChanged<String> onChanged;
  final FocusOnKeyEventCallback onKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _otpBoxSize,
      height: _otpBoxHeight,
      child: Focus(
        onKeyEvent: onKey,
        child: VitInput(
          fieldKey: OTPPage.digitFieldKey(index),
          controller: controller,
          focusNode: focusNode,
          semanticLabel: 'OTP digit ${index + 1}',
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          textInputAction: index == 5
              ? TextInputAction.done
              : TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          textStyle: AppTextStyles.sectionTitle.copyWith(
            fontSize: 24,
            fontWeight: AppTextStyles.bold,
          ),
          errorText: hasError ? '' : null,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _OtpProgress extends StatelessWidget {
  const _OtpProgress({required this.filled});

  final int filled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < 6; index++) ...[
          if (index > 0) const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: index < filled ? _authPrimary : AppColors.borderSolid,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _OtpErrorBanner extends StatelessWidget {
  const _OtpErrorBanner({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.sell10,
        borderRadius: AppRadii.mdRadius,
        border: Border.all(color: AppColors.sell20),
      ),
      child: Text(
        error,
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(color: AppColors.sell),
      ),
    );
  }
}

class _ResendControl extends StatelessWidget {
  const _ResendControl({
    required this.canResend,
    required this.countdown,
    required this.onResend,
  });

  final bool canResend;
  final int countdown;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final timer = '0:${countdown.toString().padLeft(2, '0')}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.refresh_rounded,
          size: 14,
          color: canResend ? _authPrimary : AppColors.text3,
        ),
        const SizedBox(width: AppSpacing.x3),
        if (canResend)
          TextButton(
            key: OTPPage.resendKey,
            onPressed: onResend,
            style: TextButton.styleFrom(
              foregroundColor: _authPrimary,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Gửi lại mã OTP',
              style: AppTextStyles.caption.copyWith(
                color: _authPrimary,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          )
        else
          Text.rich(
            TextSpan(
              text: 'Gửi lại sau ',
              children: [
                TextSpan(
                  text: timer,
                  style: const TextStyle(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
      ],
    );
  }
}
