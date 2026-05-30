import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/controllers/p2p_controller.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

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
            prefix: Text('±', style: AppTextStyles.caption),
            suffix: Text('%', style: AppTextStyles.caption),
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: AppSpacing.x2),
          Wrap(
            spacing: AppSpacing.x2,
            children: [
              for (final value in const [-1, -0.5, 0, .5, 1, 2])
                _ChoiceChipButton(
                  label: '${value >= 0 ? '+' : ''}$value%',
                  selected: controller.text == value.toString(),
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
              child: _ChoiceChipButton(
                key: P2PCreateAdUiKeys.paymentWindowKey(value),
                label: '$value phút',
                selected: selected == value,
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
      padding: const EdgeInsets.all(AppSpacing.x4),
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
          const SizedBox(height: AppSpacing.x4),
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
            const SizedBox(height: AppSpacing.x2),
            Wrap(
              spacing: AppSpacing.x2,
              children: [
                for (final level in const ['1', '2', '3'])
                  _ChoiceChipButton(
                    label: 'Cấp $level',
                    selected: requiredKycLevel == level,
                    onTap: () => onLevelChanged(level),
                  ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.x3),
          VitInput(
            controller: minTradesController,
            label: 'Số đơn tối thiểu',
            hintText: '0',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.x3),
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
      child: Container(
        constraints: const BoxConstraints(
          minHeight: AppSpacing.buttonHero + AppSpacing.x6,
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          border: Border.all(color: AppColors.borderSolid, width: 1.5),
          borderRadius: AppRadii.inputRadius,
        ),
        child: TextField(
          controller: controller,
          maxLines: 3,
          cursorColor: AppColors.primary,
          style: AppTextStyles.body.copyWith(fontSize: 14, height: 1.45),
          decoration: InputDecoration.collapsed(
            hintText: hintText,
            hintStyle: AppTextStyles.body.copyWith(
              color: AppColors.text3,
              fontSize: 14,
              height: 1.45,
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.warn10,
        border: Border.all(color: AppColors.warningBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
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
                  height: 1.55,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class P2PCreateAdLivePreviewCard extends StatelessWidget {
  const P2PCreateAdLivePreviewCard({
    super.key,
    required this.expanded,
    required this.onTap,
    required this.preview,
  });

  final bool expanded;
  final VoidCallback onTap;
  final P2PCreateAdPreview preview;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: AppRadii.inputRadius,
            child: Row(
              children: [
                const Icon(
                  Icons.radio_button_checked_rounded,
                  color: AppColors.buy,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    'Live Preview',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                _PreviewBadge(label: preview.canPublish ? '100%' : '0%'),
                const SizedBox(width: AppSpacing.x2),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconMd,
                ),
              ],
            ),
          ),
          if (expanded) ...[
            const SizedBox(height: AppSpacing.x4),
            P2PCreateAdConfirmRow(
              label: preview.typeLabel,
              value: preview.totalAmountLabel,
            ),
            P2PCreateAdConfirmRow(label: 'Giá', value: preview.priceLabel),
            P2PCreateAdConfirmRow(
              label: 'Thanh toán',
              value: preview.paymentSummary,
            ),
            P2PCreateAdConfirmRow(label: 'Limit', value: preview.limitSummary),
            P2PCreateAdConfirmRow(label: 'Fee', value: preview.feeReviewLabel),
          ],
        ],
      ),
    );
  }
}

class P2PCreateAdConfirmRow extends StatelessWidget {
  const P2PCreateAdConfirmRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 76,
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class P2PCreateAdInputBlock extends StatelessWidget {
  const P2PCreateAdInputBlock({
    super.key,
    required this.label,
    required this.child,
    this.hint,
  });

  final String label;
  final Widget child;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.x2),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        child,
        if (hint != null) ...[
          const SizedBox(height: AppSpacing.x2),
          Text(
            hint!,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ],
    );
  }
}

class _PaymentChip extends StatelessWidget {
  const _PaymentChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary12 : AppColors.surface2,
            border: Border.all(
              color: selected ? AppColors.primary30 : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primarySoft,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x1),
              ],
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: selected ? AppColors.primarySoft : AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoiceChipButton extends StatelessWidget {
  const _ChoiceChipButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary12 : AppColors.surface2,
            border: Border.all(
              color: selected ? AppColors.primary30 : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: selected ? AppColors.primarySoft : AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewBadge extends StatelessWidget {
  const _PreviewBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.buy10,
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.buy),
        ),
      ),
    );
  }
}
