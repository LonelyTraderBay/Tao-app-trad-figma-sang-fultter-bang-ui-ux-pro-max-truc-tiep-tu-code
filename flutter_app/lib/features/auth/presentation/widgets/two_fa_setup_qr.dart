part of '../pages/two_fa_setup_page.dart';

class _QrStep extends StatelessWidget {
  const _QrStep({required this.onCopy, required this.copied});

  final VoidCallback onCopy;
  final bool copied;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _ShieldHero(),
        const Padding(padding: EdgeInsets.only(top: 18)),
        Text(
          'Bước 1: Quét mã QR',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle,
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
        Text.rich(
          TextSpan(
            text: 'Mở ứng dụng ',
            children: [
              TextSpan(
                text: 'Google Authenticator',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: 1.5,
                ),
              ),
              const TextSpan(text: ' hoặc '),
              TextSpan(
                text: 'Authy',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: 1.5,
                ),
              ),
              const TextSpan(text: ' và quét mã QR\nbên dưới.'),
            ],
          ),
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            height: 1.5,
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 22)),
        const _QrPreview(),
        const Padding(padding: EdgeInsets.only(top: 20)),
        _SecretKeyCard(copied: copied, onCopy: onCopy),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const _WarningBanner(text: 'Giữ bí mật khóa này.'),
      ],
    );
  }
}

class _ShieldHero extends StatelessWidget {
  const _ShieldHero();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: _authPrimary10,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: _authPrimary30),
        ),
        child: const Icon(Icons.shield_outlined, color: _authPrimary, size: 34),
      ),
    );
  }
}

class _QrPreview extends StatelessWidget {
  const _QrPreview();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 192,
        height: 192,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.onAccent,
          borderRadius: AppRadii.cardLargeRadius,
        ),
        child: const CustomPaint(painter: _QrPainter()),
      ),
    );
  }
}

class _QrPainter extends CustomPainter {
  const _QrPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const qrColor = AppColors.qrNavy;
    final paint = Paint()..color = qrColor;
    final module = size.width / 21;

    void moduleRect(int x, int y, [int w = 1, int h = 1]) {
      canvas.drawRect(
        Rect.fromLTWH(x * module, y * module, w * module, h * module),
        paint,
      );
    }

    void finder(int x, int y) {
      moduleRect(x, y, 7, 1);
      moduleRect(x, y + 6, 7, 1);
      moduleRect(x, y, 1, 7);
      moduleRect(x + 6, y, 1, 7);
      moduleRect(x + 2, y + 2, 3, 3);
    }

    finder(0, 0);
    finder(14, 1);
    finder(1, 14);

    const modules = <(int, int)>[
      (8, 0),
      (10, 0),
      (12, 0),
      (8, 1),
      (11, 1),
      (13, 2),
      (8, 3),
      (10, 3),
      (9, 4),
      (12, 4),
      (8, 5),
      (13, 5),
      (7, 7),
      (9, 7),
      (11, 7),
      (13, 7),
      (15, 8),
      (17, 8),
      (19, 8),
      (8, 9),
      (10, 9),
      (14, 9),
      (16, 9),
      (9, 10),
      (12, 10),
      (15, 10),
      (18, 10),
      (7, 11),
      (11, 11),
      (17, 11),
      (20, 11),
      (8, 12),
      (10, 12),
      (12, 12),
      (14, 12),
      (16, 12),
      (18, 12),
      (8, 14),
      (10, 14),
      (12, 14),
      (14, 14),
      (17, 14),
      (20, 14),
      (9, 15),
      (13, 15),
      (15, 15),
      (19, 15),
      (8, 16),
      (12, 16),
      (16, 16),
      (18, 16),
      (10, 17),
      (14, 17),
      (20, 17),
      (8, 18),
      (11, 18),
      (13, 18),
      (17, 18),
      (19, 18),
      (9, 19),
      (12, 19),
      (15, 19),
      (18, 19),
      (20, 19),
      (8, 20),
      (10, 20),
      (14, 20),
      (16, 20),
      (19, 20),
    ];

    for (final (x, y) in modules) {
      moduleRect(x, y);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SecretKeyCard extends StatelessWidget {
  const _SecretKeyCard({required this.copied, required this.onCopy});

  final bool copied;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      borderColor: _authPrimary30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Hoặc nhập thủ công khóa bí mật:',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
          Row(
            children: [
              Expanded(
                child: SelectableText(
                  _secretKey,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                    letterSpacing: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              TextButton.icon(
                key: TwoFASetupPage.copyKey,
                onPressed: onCopy,
                style: TextButton.styleFrom(
                  foregroundColor: _authPrimary,
                  backgroundColor: _authPrimary10,
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.cardRadius,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Icon(
                  copied ? Icons.check_rounded : Icons.content_copy_rounded,
                  size: 15,
                ),
                label: Text(
                  copied ? 'Đã sao chép' : 'Sao chép',
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
    );
  }
}
