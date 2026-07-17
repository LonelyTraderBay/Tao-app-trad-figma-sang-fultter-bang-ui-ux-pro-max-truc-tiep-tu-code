import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/address/wallet_address_add_common.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_toggle_pill.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

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
      label: 'Thêm địa chỉ vào danh sách trắng rút tiền',
      value: enabled ? 'Đang bật' : 'Đang tắt',
      child: VitCard(
        key: const Key('sc143_address_whitelist'),
        onTap: onTap,
        density: VitDensity.compact,
        borderColor: AppColors.overlayStroke,
        child: Row(
          children: [
            // card-tile: allow-start — fixed surface, not horizontal strip tile
            VitCard(
              width: AppSpacing.buttonCompact,
              height: AppSpacing.buttonCompact,
              variant: VitCardVariant.inner,
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
                size: WalletSpacingTokens.walletAddressAddIcon,
              ),
            ),
            const SizedBox(width: WalletSpacingTokens.walletAddressPrimaryGap),
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
            VitTogglePill(
              enabled: enabled,
              activeColor: addressAddGreen,
              width: WalletSpacingTokens.walletAddressAddSwitchWidth,
              height: WalletSpacingTokens.walletAddressAddSwitchHeight,
              knobSize: WalletSpacingTokens.walletAddressAddSwitchKnob,
              knobMargin: WalletSpacingTokens.walletAddressAddSwitchKnobMargin,
            ),
          ],
        ),
      ),
    );
  }
}

class AddressWarningCard extends StatelessWidget {
  const AddressWarningCard({super.key, this.highRiskContractId});

  final String? highRiskContractId;

  @override
  Widget build(BuildContext context) {
    return VitHighRiskStatePanel(
      state: VitHighRiskUiState.riskReview,
      title: 'Lưu ý quan trọng',
      message:
          'Kiểm tra kỹ địa chỉ và mạng lưới trước khi lưu. Rút tiền sai địa chỉ hoặc sai mạng sẽ mất vĩnh viễn và không thể khôi phục.',
      contractId: highRiskContractId,
      density: VitDensity.compact,
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
      label: 'Xác nhận địa chỉ ví và mạng là chính xác',
      value: agreed ? 'Đã đồng ý' : 'Chưa đồng ý',
      child: VitCard(
        key: const Key('sc143_address_agreement'),
        onTap: onTap,
        variant: VitCardVariant.ghost,
        borderColor: AppColors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // card-tile: allow-start — fixed surface, not horizontal strip tile
            VitCard(
              width: WalletSpacingTokens.walletAddressAddAgreementBox,
              height: WalletSpacingTokens.walletAddressAddAgreementBox,
              margin: WalletSpacingTokens.walletAddressAddAgreementBoxMargin,
              radius: VitCardRadius.standard,
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
                      size: WalletSpacingTokens.walletAddressAddAgreementIcon,
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(width: AppSpacing.rowGapRegular),
            Expanded(
              child: Text(
                'Tôi xác nhận địa chỉ ví và mạng lưới chính xác. Tôi hiểu rằng gửi tiền sai địa chỉ sẽ không thể hoàn lại.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: TradeSpacingTokens.tradeBotLineHeightLoose,
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
