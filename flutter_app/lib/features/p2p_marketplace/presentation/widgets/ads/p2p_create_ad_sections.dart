import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/controllers/p2p_controller.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/widgets/ads/p2p_create_ad_preview_badge.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part 'p2p_create_ad_preview_confirm.dart';
part 'p2p_create_ad_choice_chips.dart';

final class P2PCreateAdUiKeys {
  static const priceFieldKey = Key('sc226_price_field');
  static const marginFieldKey = Key('sc226_margin_field');
  static const totalFieldKey = Key('sc226_total_field');
  static const minFieldKey = Key('sc226_min_field');
  static const maxFieldKey = Key('sc226_max_field');
  static const publishButtonKey = Key('sc226_publish');
  static const confirmPublishKey = Key('sc226_confirm_publish');

  static Key adTypeKey(P2PTradeType type) => Key('sc226_type_${type.name}');
  static Key assetKey(String asset) => Key('sc226_asset_$asset');
  static Key currencyKey(String currency) => Key('sc226_currency_$currency');
  static Key priceTypeKey(String type) => Key('sc226_price_type_$type');
  static Key paymentKey(String payment) => Key('sc226_payment_$payment');
  static Key paymentWindowKey(int minutes) => Key('sc226_window_$minutes');
}

class P2PCreateAdFloatingPriceBlock extends StatelessWidget {
  const P2PCreateAdFloatingPriceBlock({
    super.key,
    required this.controller,
    required this.preview,
    required this.onChanged,
  });

  final TextEditingController controller;
  final P2PCreateAdPreview preview;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return P2PCreateAdInputBlock(
      label: 'Biên độ giá (%) *',
      hint:
          'Giá = Thị trường x (1 + biên độ%). Giá hiện tại: ${preview.priceLabel}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitInput(
            controller: controller,
            fieldKey: P2PCreateAdUiKeys.marginFieldKey,
            hintText: '0.00',
            keyboardType: TextInputType.number,
            prefix: const Text('±', style: AppTextStyles.caption),
            suffix: const Text('%', style: AppTextStyles.caption),
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            children: [
              for (final value in const [-1, -0.5, 0, .5, 1, 2])
                VitChoicePill(
                  label: '${value >= 0 ? '+' : ''}$value%',
                  selected: controller.text == value.toString(),
                  padding: P2PSpacingTokens.p2pMerchantCommerceWideChipPadding,
                  onTap: () {
                    controller.text = value.toString();
                    onChanged();
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class P2PCreateAdPaymentsBlock extends StatelessWidget {
  const P2PCreateAdPaymentsBlock({
    super.key,
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return P2PCreateAdInputBlock(
      label: 'Phương thức thanh toán *',
      hint: 'Đã chọn ${selected.length}/5',
      child: Wrap(
        spacing: AppSpacing.x2,
        runSpacing: AppSpacing.x2,
        children: [
          for (final payment in options)
            _PaymentChip(
              key: P2PCreateAdUiKeys.paymentKey(payment),
              label: payment,
              selected: selected.contains(payment),
              onTap: () => onToggle(payment),
            ),
        ],
      ),
    );
  }
}

class P2PCreateAdPaymentWindowBlock extends StatelessWidget {
  const P2PCreateAdPaymentWindowBlock({
    super.key,
    required this.values,
    required this.selected,
    required this.onSelected,
  });

  final List<int> values;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return P2PCreateAdInputBlock(
      label: 'Thời gian thanh toán',
      child: Row(
        children: [
          for (final value in values) ...[
            Expanded(
              child: VitChoicePill(
                key: P2PCreateAdUiKeys.paymentWindowKey(value),
                label: '$value phút',
                selected: selected == value,
                padding: P2PSpacingTokens.p2pMerchantCommerceWideChipPadding,
                onTap: () => onSelected(value),
              ),
            ),
            if (value != values.last) const SizedBox(width: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class P2PCreateAdRequirementCard extends StatelessWidget {
  const P2PCreateAdRequirementCard({
    super.key,
    required this.requireKyc,
    required this.requiredKycLevel,
    required this.minTradesController,
    required this.minDaysController,
    required this.onKycChanged,
    required this.onLevelChanged,
  });

  final bool requireKyc;
  final String requiredKycLevel;
  final TextEditingController minTradesController;
  final TextEditingController minDaysController;
  final ValueChanged<bool> onKycChanged;
  final ValueChanged<String> onLevelChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pMerchantCommerceCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Yêu cầu đối tác',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                'Tuỳ chọn',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Yêu cầu KYC',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              Switch(
                value: requireKyc,
                activeThumbColor: AppColors.primarySoft,
                activeTrackColor: AppColors.primary20,
                onChanged: onKycChanged,
              ),
            ],
          ),
          if (requireKyc) ...[
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Wrap(
              spacing: AppSpacing.x2,
              children: [
                for (final level in const ['1', '2', '3'])
                  VitChoicePill(
                    label: 'Cấp $level',
                    selected: requiredKycLevel == level,
                    padding:
                        P2PSpacingTokens.p2pMerchantCommerceWideChipPadding,
                    onTap: () => onLevelChanged(level),
                  ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitInput(
            controller: minTradesController,
            label: 'Số đơn tối thiểu',
            hintText: '0',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitInput(
            controller: minDaysController,
            label: 'Số ngày tối thiểu',
            hintText: '0',
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}

class P2PCreateAdMultilineBlock extends StatelessWidget {
  const P2PCreateAdMultilineBlock({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.hint,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return P2PCreateAdInputBlock(
      label: label,
      hint: hint,
      // card-tile: allow-start — fixed surface, not horizontal strip tile
      child: VitCard(
        constraints: const BoxConstraints(
          minHeight: P2PSpacingTokens.p2pMerchantCommerceTextAreaMinHeight,
        ),
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.standard,
        borderColor: AppColors.borderSolid,
        background: const ColoredBox(color: AppColors.surface2),
        padding: P2PSpacingTokens.p2pMerchantCommerceTextAreaPadding,
        clip: true,
        child: TextField(
          controller: controller,
          maxLines: 3,
          cursorColor: AppColors.primary,
          style: AppTextStyles.body.copyWith(
            height: P2PSpacingTokens.p2pMerchantCommerceBodyLineHeight,
          ),
          decoration: InputDecoration.collapsed(
            hintText: hintText,
            hintStyle: AppTextStyles.body.copyWith(
              color: AppColors.text3,
              height: P2PSpacingTokens.p2pMerchantCommerceBodyLineHeight,
            ),
          ),
        ),
      ),
    );
  }
}

class P2PCreateAdWarningCard extends StatelessWidget {
  const P2PCreateAdWarningCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      borderColor: AppColors.warningBorder,
      background: const ColoredBox(color: AppColors.warn10),
      padding: P2PSpacingTokens.p2pMerchantCommerceCompactPadding,
      clip: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                height: P2PSpacingTokens.p2pMerchantCommerceWarningLineHeight,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
