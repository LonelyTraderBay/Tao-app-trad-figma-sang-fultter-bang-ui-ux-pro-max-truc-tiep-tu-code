import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_address_add_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

class AddressConfirmPreviewSheet extends StatelessWidget {
  const AddressConfirmPreviewSheet({
    super.key,
    required this.preview,
    required this.onConfirm,
  });

  static const confirmButtonKey = Key('sc143_address_confirm_save');

  final AddressAddPreview preview;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: AppSpacing.walletAddressAddSheetPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Xác nhận lưu địa chỉ', style: AppTextStyles.sectionTitle),
            const SizedBox(height: AppSpacing.walletAddressAddSheetTitleGap),
            Text(
              preview.auditTrailNote,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
            const SizedBox(height: AppSpacing.walletAddressAddSheetSectionGap),
            AddressPreviewPanel(
              rows: [
                ('Tên', preview.label),
                ('Mạng', preview.networkLabel),
                ('Tài sản', preview.asset),
                ('Địa chỉ', preview.maskedAddress),
                if (preview.memo != null) ('Memo', preview.memo!),
                ('Whitelist', preview.whitelistLabel),
              ],
            ),
            const SizedBox(height: AppSpacing.walletAddressFilterGap),
            AddressPrimaryActionButton(
              key: confirmButtonKey,
              enabled: true,
              label: 'Xác nhận lưu',
              semanticLabel: 'Confirm save wallet address',
              onTap: onConfirm,
            ),
          ],
        ),
      ),
    );
  }
}

class AddressPreviewPanel extends StatelessWidget {
  const AddressPreviewPanel({super.key, required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.walletAddressCardPadding,
      borderColor: AppColors.overlayStroke,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Xem trước',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.walletAddressMetaGap),
          for (final row in rows) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    row.$1,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.rowGapRegular),
                Flexible(
                  flex: 2,
                  child: Text(
                    row.$2,
                    textAlign: TextAlign.right,
                    style:
                        (row.$1 == 'Địa chỉ'
                                ? AppTextStyles.monoCode
                                : AppTextStyles.caption)
                            .copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.rowGap),
          ],
        ],
      ),
    );
  }
}

class AddressSaveFooter extends StatelessWidget {
  const AddressSaveFooter({
    super.key,
    required this.enabled,
    required this.onTap,
  });

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.walletAddressAddFooterHeight,
      padding: AppSpacing.walletAddressAddFooterPadding,
      decoration: const BoxDecoration(
        color: AppColors.navBg,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: AddressPrimaryActionButton(
        key: const Key('sc143_address_save'),
        enabled: enabled,
        semanticLabel: 'Save wallet address',
        label: 'Lưu địa chỉ',
        onTap: onTap,
      ),
    );
  }
}

class AddressSavedState extends StatelessWidget {
  const AddressSavedState({
    super.key,
    required this.label,
    required this.whitelist,
    required this.onBack,
  });

  final String label;
  final bool whitelist;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      semanticLabel: 'SC-143 AddressAddPage Success',
      child: Material(
        color: addressAddBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Thêm địa chỉ',
              subtitle: 'Sổ địa chỉ · Wallet',
              showBack: true,
              onBack: onBack,
            ),
            Expanded(
              child: Padding(
                padding: AppSpacing.walletAddressAddSuccessPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: AppSpacing.walletAddressAddSuccessIconSize,
                      height: AppSpacing.walletAddressAddSuccessIconSize,
                      decoration: BoxDecoration(
                        color: AppColors.buy10,
                        borderRadius: AppRadii.cardLargeRadius,
                        border: Border.all(
                          color: AppColors.buy20,
                          width: AppSpacing.borderWidth,
                        ),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline_rounded,
                        color: addressAddGreen,
                        size: AppSpacing.walletAddressAddSuccessIconGlyph,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.walletAddressAddSuccessTitleGap,
                    ),
                    Text(
                      'Đã lưu thành công!',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.sectionTitle,
                    ),
                    const SizedBox(
                      height: AppSpacing.walletAddressAddSuccessMessageGap,
                    ),
                    Text(
                      'Địa chỉ "$label" đã được thêm vào sổ địa chỉ.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.walletAddressAddSuccessPillGap,
                    ),
                    Container(
                      padding: AppSpacing.walletAddressAddStatusPadding,
                      decoration: BoxDecoration(
                        color: AppColors.buy10,
                        borderRadius: AppRadii.cardRadius,
                        border: Border.all(color: AppColors.buy15),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            color: addressAddGreen,
                            size: AppSpacing.iconSm,
                          ),
                          const SizedBox(width: AppSpacing.rowGap),
                          Flexible(
                            child: Text(
                              whitelist
                                  ? 'Đã thêm vào whitelist'
                                  : 'Chưa whitelist - có thể bật sau',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.micro.copyWith(
                                color: addressAddGreen,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
