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
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.rowGap),
        VitCard(
          key: DepositPage.networkSelectorKey,
          variant: VitCardVariant.inner,
          radius: VitCardRadius.sm,
          height: AppSpacing.inputHeight,
          padding: AppSpacing.walletDepositSelectorPadding,
          borderColor: _depositPrimary,
          onTap: onTap,
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
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.walletAssetSmallGap),
                    Text(
                      'Phí: ${selected.fee} · Nạp tối thiểu: ${_formatDeposit(selected.minDeposit)} $asset',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.text2,
                size: AppSpacing.iconMd + AppSpacing.x1,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.rowGap),
        Row(
          children: [
            Container(
              width: AppSpacing.x1 + AppSpacing.x1,
              height: AppSpacing.x1 + AppSpacing.x1,
              decoration: const BoxDecoration(
                color: _depositGreen,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.walletAssetSmallGap),
            Expanded(
              child: Text(
                'Mạng hoạt động tốt  ·  ${selected.arrivalTime}  ·  ${selected.confirmations} xác nhận',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: 'Review deposit network',
          message:
              'Use only ${network.name} for $asset. Wrong network deposits may be unrecoverable.',
          contractId:
              'Min ${_formatDeposit(network.minDeposit)} $asset / ${network.confirmations} confirmations',
        ),
        const SizedBox(height: AppSpacing.rowGap),
        VitCard(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.walletDepositWarningCardMinHeight,
          ),
          padding: AppSpacing.walletDepositWarningPadding,
          borderColor: _depositRed.withValues(alpha: .38),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: _depositRed,
                size: AppSpacing.iconSm + AppSpacing.x2,
              ),
              const SizedBox(width: AppSpacing.x2 + AppSpacing.x1),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quan trọng — Đọc trước khi nạp',
                      style: AppTextStyles.body.copyWith(
                        color: _depositRed,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2 + AppSpacing.x1),
                    for (final item in warningItems) ...[
                      Text(
                        '• $item',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.sell,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x2),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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
    return VitCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        children: [
          _QrCode(address: network.address),
          const SizedBox(height: AppSpacing.rowPy + AppSpacing.x1),
          Text(
            'Địa chỉ $asset (${network.name.split(' ').first})',
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.rowPy - AppSpacing.x1),
          Text(
            network.address,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.rowPy + AppSpacing.x5),
          GestureDetector(
            key: DepositPage.copyAddressKey,
            onTap: onCopy,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              height: AppSpacing.walletDepositCopyButtonHeight,
              padding: AppSpacing.walletDepositCopyButtonPadding,
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
                    size: AppSpacing.walletDepositCopyIcon,
                  ),
                  const SizedBox(width: AppSpacing.rowGap),
                  Flexible(
                    child: Text(
                      copied ? 'Đã sao chép địa chỉ!' : 'Sao chép địa chỉ',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: copied ? _depositGreen : _depositPrimary,
                        fontWeight: AppTextStyles.bold,
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
      width: AppSpacing.walletDepositQrCodeSize,
      height: AppSpacing.walletDepositQrCodeSize,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.onAccent,
        borderRadius: AppRadii.lgRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.dynamicIslandBg.withValues(alpha: .32),
            blurRadius: AppSpacing.walletDepositQrShadowBlur,
            offset: const Offset(0, AppSpacing.walletDepositQrShadowOffsetY),
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
