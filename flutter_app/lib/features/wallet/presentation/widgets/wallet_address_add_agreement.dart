import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_address_add_common.dart';

class AddressWhitelistCard extends StatelessWidget {
  const AddressWhitelistCard({
    super.key,
    required this.enabled,
    required this.onTap,
  });

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: enabled,
      label: 'Add address to withdrawal whitelist',
      value: enabled ? 'Enabled' : 'Disabled',
      child: GestureDetector(
        key: const Key('sc143_address_whitelist'),
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: AppSpacing.walletAddressAddWhitelistHeight,
          padding: AppSpacing.walletAddressSecurityPadding,
          decoration: BoxDecoration(
            color: addressAddPanel,
            borderRadius: AppRadii.cardRadius,
            border: Border.all(color: AppColors.overlayStroke),
          ),
          child: Row(
            children: [
              Container(
                width: AppSpacing.walletAddressIconSize,
                height: AppSpacing.walletAddressIconSize,
                decoration: BoxDecoration(
                  color: enabled ? AppColors.buy10 : addressAddPanel2,
                  borderRadius: AppRadii.cardRadius,
                  border: Border.all(
                    color: enabled
                        ? AppColors.buy.withValues(alpha: .30)
                        : AppColors.borderSolid,
                  ),
                ),
                child: Icon(
                  Icons.shield_outlined,
                  color: enabled ? addressAddGreen : AppColors.text3,
                  size: AppSpacing.walletAddressAddIcon,
                ),
              ),
              const SizedBox(width: AppSpacing.walletAddressPrimaryGap),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thêm vào Whitelist',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Chỉ rút tiền đến địa chỉ whitelist',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _SwitchPill(enabled: enabled),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwitchPill extends StatelessWidget {
  const _SwitchPill({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.walletAddressAddSwitchWidth,
      height: AppSpacing.walletAddressAddSwitchHeight,
      decoration: BoxDecoration(
        color: enabled ? addressAddGreen : addressAddPanel2,
        borderRadius: AppRadii.mdRadius,
        border: Border.all(
          color: enabled ? addressAddGreen : AppColors.borderSolid,
          width: AppSpacing.walletAddressAddSwitchBorder,
        ),
      ),
      child: AnimatedAlign(
        alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
        duration: const Duration(milliseconds: 160),
        child: Container(
          width: AppSpacing.walletAddressAddSwitchKnob,
          height: AppSpacing.walletAddressAddSwitchKnob,
          margin: AppSpacing.walletAddressAddSwitchKnobMargin,
          decoration: const BoxDecoration(
            color: AppColors.onAccent,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class AddressWarningCard extends StatelessWidget {
  const AddressWarningCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.walletAddressSecurityPadding,
      decoration: BoxDecoration(
        color: AppColors.caution.withValues(alpha: .06),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.caution.withValues(alpha: .15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: AppSpacing.walletAddressAddWarningIconPadding,
            child: Icon(
              Icons.warning_amber_rounded,
              color: addressAddAmber,
              size: AppSpacing.walletAddressAddIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.rowGapRegular),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lưu ý quan trọng',
                  style: AppTextStyles.caption.copyWith(
                    color: addressAddAmber,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.rowGap),
                Text(
                  'Kiểm tra kỹ địa chỉ và mạng lưới trước khi lưu. Rút tiền sai địa chỉ hoặc sai mạng sẽ mất vĩnh viễn và không thể khôi phục.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.58,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddressAgreementRow extends StatelessWidget {
  const AddressAgreementRow({
    super.key,
    required this.agreed,
    required this.onTap,
  });

  final bool agreed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: agreed,
      label: 'Confirm wallet address and network are correct',
      value: agreed ? 'Agreed' : 'Not agreed',
      child: GestureDetector(
        key: const Key('sc143_address_agreement'),
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: AppSpacing.walletAddressAddAgreementBox,
              height: AppSpacing.walletAddressAddAgreementBox,
              margin: AppSpacing.walletAddressAddAgreementBoxMargin,
              decoration: BoxDecoration(
                color: agreed ? addressAddGreen : AppColors.transparent,
                borderRadius: BorderRadius.circular(
                  AppSpacing.walletAddressAddAgreementRadius,
                ),
                border: Border.all(
                  color: agreed ? addressAddGreen : AppColors.borderSolid,
                  width: AppSpacing.walletAddressAddAgreementBorder,
                ),
              ),
              child: agreed
                  ? const Icon(
                      Icons.check_rounded,
                      color: AppColors.onAccent,
                      size: AppSpacing.walletAddressAddAgreementIcon,
                    )
                  : null,
            ),
            const SizedBox(width: AppSpacing.rowGapRegular),
            Expanded(
              child: Text(
                'Tôi xác nhận địa chỉ ví và mạng lưới chính xác. Tôi hiểu rằng gửi tiền sai địa chỉ sẽ không thể hoàn lại.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.5,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
