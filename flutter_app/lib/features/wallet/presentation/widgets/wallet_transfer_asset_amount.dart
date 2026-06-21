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
    return VitCard(
      key: const Key('sc146_transfer_asset'),
      onTap: onTap,
      variant: VitCardVariant.standard,
      padding: _transferCardInnerPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'T\u00e0i s\u1ea3n',
            style: AppTextStyles.badge.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: _transferTinyGap),
          Row(
            children: [
              _AssetLogo(asset: asset, size: _transferIconBox),
              const SizedBox(width: _transferInlineGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(asset.symbol, style: AppTextStyles.baseMedium),
                    const SizedBox(height: _transferTinyGap),
                    Text(
                      'Kh\u1ea3 d\u1ee5ng: ${formatTransferAssetAmount(asset.available)} ${asset.symbol}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.text3,
                size: _transferActionIcon,
              ),
            ],
          ),
        ],
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
    return VitAssetAvatar(
      label: asset.symbol,
      accentColor: color,
      size: size,
      radius: AppRadii.avatarRadius,
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
    return VitCard(
      variant: VitCardVariant.standard,
      padding: _transferCardInnerPadding,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'S\u1ed1 l\u01b0\u1ee3ng',
                  style: AppTextStyles.badge.copyWith(color: AppColors.text3),
                ),
              ),
              GestureDetector(
                key: const Key('sc146_transfer_max'),
                onTap: onMax,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  'T\u1edbi \u0111a',
                  style: AppTextStyles.badge.copyWith(color: _transferPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: _transferSectionGap),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: _transferAmountFieldHeight,
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
                    style: AppTextStyles.amountSm,
                    decoration: InputDecoration(
                      hintText: '0.00',
                      hintStyle: AppTextStyles.amountSm.copyWith(
                        color: AppColors.text2,
                      ),
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                  ),
                ),
              ),
              Text(
                asset.symbol,
                style: AppTextStyles.control.copyWith(color: AppColors.text2),
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
    return VitCard(
      variant: VitCardVariant.inner,
      constraints: const BoxConstraints(minHeight: 52),
      padding: _transferNoticePadding,
      borderColor: _transferPrimary.withValues(alpha: .20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 1),
            child: Icon(
              Icons.info_outline_rounded,
              color: _transferPrimary,
              size: _transferActionIcon,
            ),
          ),
          const SizedBox(width: _transferInlineGap),
          Expanded(
            child: Text(
              'Chuy\u1ec3n n\u1ed9i b\u1ed9 gi\u00e1 tr\u1ecb v\u00ed, t\u00ednh ph\u00ed, x\u1eed l\u00fd ngay l\u1eadp t\u1ee5c. Kh\u00f4ng c\u1ea7n x\u00e1c nh\u1eadn blockchain.',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
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
    return VitCtaButton(
      onPressed: enabled ? onTap : null,
      height: _transferButtonHeight,
      child: Text(
        'X\u00e1c nh\u1eadn chuy\u1ec3n',
        style: AppTextStyles.control.copyWith(
          color: enabled ? AppColors.onAccent : AppColors.text3,
        ),
      ),
    );
  }
}
