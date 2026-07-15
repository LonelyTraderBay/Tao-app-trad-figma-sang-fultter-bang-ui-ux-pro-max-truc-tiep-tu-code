import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings/savings_notification_preferences_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class SavingsNotificationProductsTab extends StatelessWidget {
  const SavingsNotificationProductsTab({super.key, required this.products});

  final List<SavingsProductNotificationDraft> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsNotificationPreferencesKeys.productsList,
      children: [
        _InfoCard(
          icon: Icons.info_outline_rounded,
          text:
              'Tùy chỉnh thông báo cho từng sản phẩm đang ký. Chỉ áp dụng cho sản phẩm bạn đang có vị thế hoạt động.',
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final product in products) ...[
          _ProductCard(product: product),
          if (product != products.last)
            const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final SavingsProductNotificationDraft product;

  @override
  Widget build(BuildContext context) {
    final color = savingsNotificationAssetColorName(product.asset);

    return VitCard(
      key: SavingsNotificationPreferencesKeys.product(product.id),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox.square(
                dimension: EarnSpacingTokens.savingsNotificationIconBox,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: color.withValues(alpha: .14),
                    shape: const CircleBorder(),
                  ),
                  child: Center(
                    child: Text(
                      product.asset,
                      style: AppTextStyles.micro.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      style: savingsNotificationCaptionMedium.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                    Text(
                      '${product.enabledCount}/${product.totalCount} thông báo đang bật',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                product.typeLabel == 'Linh hoạt'
                    ? Icons.lock_open_rounded
                    : Icons.lock_outline_rounded,
                color: product.typeLabel == 'Linh hoạt'
                    ? AppColors.buy
                    : AppColors.primary,
                size: EarnSpacingTokens.savingsNotificationInlineIcon,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final label in product.alertLabels)
                SavingsNotificationSmallChip(label: label, color: color),
            ],
          ),
        ],
      ),
    );
  }
}

class SavingsNotificationDeliveryTab extends StatelessWidget {
  const SavingsNotificationDeliveryTab({
    super.key,
    required this.channels,
    required this.digestFrequency,
    required this.quietHours,
    required this.onToggle,
  });

  final List<SavingsDeliveryChannelDraft> channels;
  final SavingsDeliveryFrequency digestFrequency;
  final SavingsQuietHoursDraft quietHours;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsNotificationPreferencesKeys.deliveryList,
      children: [
        VitPageSection(
          label: 'Kênh nhận thông báo',
          accentColor: AppColors.primary,
          children: [
            for (final channel in channels)
              _ChannelCard(channel: channel, onToggle: onToggle),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitPageSection(
          label: 'Tần suất gửi',
          accentColor: AppColors.primary,
          children: [
            _ActionSettingCard(
              icon: Icons.schedule_rounded,
              title: savingsNotificationFrequencyLabel(digestFrequency),
              subtitle: savingsNotificationFrequencyDescription(
                digestFrequency,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitPageSection(
          label: 'Giờ im lặng',
          accentColor: AppColors.accent,
          children: [
            _ActionSettingCard(
              icon: Icons.dark_mode_outlined,
              title: quietHours.enabled
                  ? '${quietHours.startHour}:00 - ${quietHours.endHour}:00'
                  : 'Chưa bật',
              subtitle: quietHours.enabled
                  ? 'Tạm dừng thông báo, ngoại trừ cảnh báo quan trọng'
                  : 'Bật để tạm dừng thông báo vào ban đêm',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCtaButton(
          onPressed: () => HapticFeedback.lightImpact(),
          child: const Text('Lưu tất cả cài đặt'),
        ),
      ],
    );
  }
}

class _ChannelCard extends StatelessWidget {
  const _ChannelCard({required this.channel, required this.onToggle});

  final SavingsDeliveryChannelDraft channel;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final color = channel.enabled ? AppColors.buy : AppColors.text3;

    return VitCard(
      key: SavingsNotificationPreferencesKeys.channel(channel.id),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        children: [
          SizedBox.square(
            dimension: EarnSpacingTokens.savingsNotificationIconBox,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: color.withValues(alpha: .14),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.mdRadius,
                ),
              ),
              child: Center(
                child: Icon(
                  savingsNotificationAlertIcon(channel.iconKey),
                  color: color,
                  size: EarnSpacingTokens.savingsNotificationAlertIcon,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  channel.label,
                  style: savingsNotificationCaptionMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
                Text(
                  channel.detail,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          SavingsNotificationTokenSwitch(
            value: channel.enabled,
            disabled: channel.locked,
            onChanged: (_) => onToggle(channel.id),
          ),
        ],
      ),
    );
  }
}

class _ActionSettingCard extends StatelessWidget {
  const _ActionSettingCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: EarnSpacingTokens.savingsNotificationActionIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: savingsNotificationCaptionMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.text3),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      borderColor: AppColors.primary20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: EarnSpacingTokens.savingsNotificationInlineIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class SavingsNotificationSmallChip extends StatelessWidget {
  const SavingsNotificationSmallChip({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .12),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnSmallPillPadding,
        child: Text(label, style: AppTextStyles.micro.copyWith(color: color)),
      ),
    );
  }
}
