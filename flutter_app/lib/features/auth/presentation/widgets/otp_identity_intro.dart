part of '../pages/otp_page.dart';

class _ShieldHero extends StatelessWidget {
  const _ShieldHero();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: _authPrimary10,
          borderRadius: AppRadii.cardLargeRadius,
          border: Border.all(color: _authPrimary30, width: 1.5),
        ),
        child: const Icon(
          Icons.gpp_good_outlined,
          color: _authPrimary,
          size: 40,
        ),
      ),
    );
  }
}

class _OtpIntro extends StatelessWidget {
  const _OtpIntro({required this.contact});

  final String contact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Nhập mã xác minh',
          textAlign: TextAlign.center,
          style: AppTextStyles.pageTitle,
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
        Text.rich(
          TextSpan(
            text: 'Chúng tôi đã gửi mã 6 chữ số đến ',
            children: [
              TextSpan(
                text: contact,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: 1.6,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            height: 1.6,
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x1)),
        Text.rich(
          TextSpan(
            text: '(Demo: nhập ',
            children: [
              TextSpan(
                text: '123456',
                style: AppTextStyles.caption.copyWith(color: _authPrimary),
              ),
              const TextSpan(text: ')'),
            ],
          ),
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}
