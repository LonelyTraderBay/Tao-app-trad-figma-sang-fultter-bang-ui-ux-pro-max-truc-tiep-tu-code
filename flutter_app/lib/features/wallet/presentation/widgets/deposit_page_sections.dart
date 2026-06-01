part of '../pages/deposit_page.dart';

class _NetworkSelector extends StatelessWidget {
  const _NetworkSelector({
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  final String asset;
  final WalletDepositNetwork selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Chọn mạng lưới',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 14,
            height: 1,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          key: DepositPage.networkSelectorKey,
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: _depositPanel2,
              border: Border.all(color: _depositPrimary, width: 1.5),
              borderRadius: AppRadii.inputRadius,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selected.name,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'Phí: ${selected.fee} · Nạp tối thiểu: ${_formatDeposit(selected.minDeposit)} $asset',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text2,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: _depositGreen,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                'Mạng hoạt động tốt  ·  ${selected.arrivalTime}  ·  ${selected.confirmations} xác nhận',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.asset, required this.network});

  final String asset;
  final WalletDepositNetwork network;

  @override
  Widget build(BuildContext context) {
    final warningItems = [
      'Chỉ gửi $asset qua mạng ${network.name}',
      'Gửi sai mạng sẽ mất tiền vĩnh viễn, không thể khôi phục',
      'Nạp tối thiểu: ${_formatDeposit(network.minDeposit)} $asset',
      'Cần ${network.confirmations} xác nhận blockchain',
    ];

    return Container(
      constraints: const BoxConstraints(minHeight: 129),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: _depositRed.withValues(alpha: .08),
        border: Border.all(color: _depositRed.withValues(alpha: .38)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: _depositRed, size: 15),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quan trọng — Đọc trước khi nạp',
                  style: AppTextStyles.body.copyWith(
                    color: _depositRed,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 9),
                for (final item in warningItems) ...[
                  Text(
                    '• $item',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.sell,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      height: 1.18,
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QrAddressCard extends StatelessWidget {
  const _QrAddressCard({
    required this.asset,
    required this.network,
    required this.copied,
    required this.onCopy,
  });

  final String asset;
  final WalletDepositNetwork network;
  final bool copied;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: _depositPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          _QrCode(address: network.address),
          const SizedBox(height: 17),
          Text(
            'Địa chỉ $asset (${network.name.split(' ').first})',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 11,
              height: 1,
            ),
          ),
          const SizedBox(height: 11),
          Text(
            network.address,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
              height: 1,
            ),
          ),
          const SizedBox(height: 19),
          GestureDetector(
            key: DepositPage.copyAddressKey,
            onTap: onCopy,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: copied
                    ? _depositGreen.withValues(alpha: .15)
                    : _depositPrimary.withValues(alpha: .18),
                borderRadius: AppRadii.cardRadius,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    copied ? Icons.check_circle_outline : Icons.copy_rounded,
                    color: copied ? _depositGreen : _depositPrimary,
                    size: 15,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      copied ? 'Đã sao chép địa chỉ!' : 'Sao chép địa chỉ',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: copied ? _depositGreen : _depositPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QrCode extends StatelessWidget {
  const _QrCode({required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.onAccent,
        borderRadius: AppRadii.lgRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.dynamicIslandBg.withValues(alpha: .32),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: CustomPaint(painter: _QrPainter(address)),
    );
  }
}

class _QrPainter extends CustomPainter {
  const _QrPainter(this.address);

  final String address;

  @override
  void paint(Canvas canvas, Size size) {
    final seed = address.codeUnits.fold<int>(0, (sum, code) => sum + code);
    final cell = size.width / 21;
    final fill = Paint()..color = AppColors.qrDark;
    final stroke = Paint()
      ..color = AppColors.qrDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(.5, cell * .08);

    for (var row = 0; row < 21; row++) {
      for (var col = 0; col < 21; col++) {
        final finder =
            (row < 7 && col < 7) ||
            (row < 7 && col > 13) ||
            (row > 13 && col < 7);
        final filled = finder || ((seed * (row + 1) * (col + 1)) % 7) < 3;
        if (!filled) continue;
        canvas.drawRect(
          Rect.fromLTWH(col * cell, row * cell, cell, cell),
          fill,
        );
      }
    }

    void finder(double x, double y) {
      canvas.drawRect(Rect.fromLTWH(x, y, cell * 7, cell * 7), stroke);
      canvas.drawRect(
        Rect.fromLTWH(x + cell, y + cell, cell * 5, cell * 5),
        stroke,
      );
      canvas.drawRect(
        Rect.fromLTWH(x + cell * 2, y + cell * 2, cell * 3, cell * 3),
        fill,
      );
    }

    finder(0, 0);
    finder(cell * 14, 0);
    finder(0, cell * 14);
  }

  @override
  bool shouldRepaint(covariant _QrPainter oldDelegate) =>
      oldDelegate.address != address;
}
