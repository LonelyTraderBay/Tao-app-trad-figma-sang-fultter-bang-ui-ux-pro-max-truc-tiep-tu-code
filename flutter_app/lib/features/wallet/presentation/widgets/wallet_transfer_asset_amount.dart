part of 'wallet_transfer_sections.dart';

class TransferAssetCard extends StatelessWidget {
  const TransferAssetCard({
    super.key,
    required this.asset,
    required this.onTap,
  });

  final WalletTransferAsset asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('sc146_transfer_asset'),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 99,
        padding: const EdgeInsets.fromLTRB(16, 14, 15, 14),
        decoration: BoxDecoration(
          color: _transferPanel,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: AppColors.overlayStroke),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tài sản',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 11,
                height: 1,
              ),
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                _AssetLogo(asset: asset, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        asset.symbol,
                        style: AppTextStyles.baseMedium.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'Khả dụng: ${formatTransferAssetAmount(asset.available)} ${asset.symbol}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          fontSize: 12,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text3,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AssetLogo extends StatelessWidget {
  const _AssetLogo({required this.asset, required this.size});

  final WalletTransferAsset asset;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = Color(asset.colorHex);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(size / 2),
      ),
      alignment: Alignment.center,
      child: Text(
        asset.symbol.substring(
          0,
          asset.symbol.length < 3 ? asset.symbol.length : 3,
        ),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: size >= 40 ? 10 : 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class TransferAmountCard extends StatelessWidget {
  const TransferAmountCard({
    super.key,
    required this.controller,
    required this.asset,
    required this.onChanged,
    required this.onMax,
  });

  final TextEditingController controller;
  final WalletTransferAsset asset;
  final VoidCallback onChanged;
  final VoidCallback onMax;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 14),
      decoration: BoxDecoration(
        color: _transferPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.overlayStroke),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Số lượng',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                    height: 1,
                  ),
                ),
              ),
              GestureDetector(
                key: const Key('sc146_transfer_max'),
                onTap: onMax,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  'Tối đa',
                  style: AppTextStyles.micro.copyWith(
                    color: _transferPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('sc146_transfer_amount'),
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  onChanged: (_) => onChanged(),
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Roboto',
                    height: 1,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.text2,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Roboto',
                    ),
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),
              Text(
                asset.symbol,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TransferInfoNotice extends StatelessWidget {
  const TransferInfoNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 59),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.primary08,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.info_outline_rounded,
              color: _transferPrimary,
              size: 14,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Chuyển nội bộ giữa các ví miễn phí, xử lý ngay lập tức. Không cần xác nhận blockchain.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransferButton extends StatelessWidget {
  const TransferButton({super.key, required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('sc146_transfer_submit'),
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? _transferPrimary : AppColors.surfacePressed,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          'Xác nhận chuyển',
          style: AppTextStyles.baseMedium.copyWith(
            color: enabled
                ? AppColors.onAccent
                : AppColors.controlBorderDisabled,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
