import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_address_add_common.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

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
      child: VitCard(
        key: const Key('sc143_address_whitelist'),
        onTap: onTap,
        height: AppSpacing.walletAddressAddWhitelistHeight,
        padding: AppSpacing.walletAddressSecurityPadding,
        variant: VitCardVariant.ghost,
        borderColor: AppColors.overlayStroke,
        background: const ColoredBox(color: addressAddPanel),
        clip: true,
        child: Row(
          children: [
            VitCard(
              width: AppSpacing.walletAddressIconSize,
              height: AppSpacing.walletAddressIconSize,
              variant: VitCardVariant.ghost,
              borderColor: enabled
                  ? AppColors.buy.withValues(alpha: .30)
                  : AppColors.borderSolid,
              background: ColoredBox(
                color: enabled ? AppColors.buy10 : addressAddPanel2,
              ),
              alignment: Alignment.center,
              clip: true,
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
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            _SwitchPill(enabled: enabled),
          ],
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
    return VitCard(
      width: AppSpacing.walletAddressAddSwitchWidth,
      height: AppSpacing.walletAddressAddSwitchHeight,
      radius: VitCardRadius.sm,
      variant: VitCardVariant.ghost,
      borderColor: enabled ? addressAddGreen : AppColors.borderSolid,
      background: ColoredBox(
        color: enabled ? addressAddGreen : addressAddPanel2,
      ),
      clip: true,
      child: AnimatedAlign(
        alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
        duration: const Duration(milliseconds: 160),
        child: Padding(
          padding: AppSpacing.walletAddressAddSwitchKnobMargin,
          child: SizedBox(
            width: AppSpacing.walletAddressAddSwitchKnob,
            height: AppSpacing.walletAddressAddSwitchKnob,
            child: ClipOval(child: ColoredBox(color: AppColors.onAccent)),
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
    return VitCard(
      padding: AppSpacing.walletAddressSecurityPadding,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.caution.withValues(alpha: .15),
      background: ColoredBox(color: AppColors.caution.withValues(alpha: .06)),
      clip: true,
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
                    height: AppSpacing.tradeBotLineHeightLong,
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
      child: VitCard(
        key: const Key('sc143_address_agreement'),
        onTap: onTap,
        variant: VitCardVariant.ghost,
        borderColor: AppColors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VitCard(
              width: AppSpacing.walletAddressAddAgreementBox,
              height: AppSpacing.walletAddressAddAgreementBox,
              margin: AppSpacing.walletAddressAddAgreementBoxMargin,
              radius: VitCardRadius.sm,
              variant: VitCardVariant.ghost,
              borderColor: agreed ? addressAddGreen : AppColors.borderSolid,
              background: ColoredBox(
                color: agreed ? addressAddGreen : AppColors.transparent,
              ),
              alignment: Alignment.center,
              clip: true,
              child: agreed
                  ? const Icon(
                      Icons.check_rounded,
                      color: AppColors.onAccent,
                      size: AppSpacing.walletAddressAddAgreementIcon,
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(width: AppSpacing.rowGapRegular),
            Expanded(
              child: Text(
                'Tôi xác nhận địa chỉ ví và mạng lưới chính xác. Tôi hiểu rằng gửi tiền sai địa chỉ sẽ không thể hoàn lại.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: AppSpacing.tradeBotLineHeightLoose,
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
