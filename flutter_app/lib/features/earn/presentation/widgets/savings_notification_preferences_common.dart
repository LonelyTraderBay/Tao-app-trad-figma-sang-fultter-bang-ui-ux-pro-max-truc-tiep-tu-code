import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

TextStyle get savingsNotificationCaptionMedium =>
    AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.medium);
TextStyle get savingsNotificationBodyBold =>
    AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold);

final class SavingsNotificationPreferencesKeys {
  const SavingsNotificationPreferencesKeys._();

  static const summary = Key('sc345_summary');
  static const stats = Key('sc345_stats');
  static const eventsList = Key('sc345_events_list');
  static const productsList = Key('sc345_products_list');
  static const deliveryList = Key('sc345_delivery_list');
  static const masterToggle = Key('sc345_master_toggle');

  static Key alert(String id) => Key('sc345_alert_$id');
  static Key product(String id) => Key('sc345_product_$id');
  static Key channel(String id) => Key('sc345_channel_$id');
}

class SavingsNotificationSeverityPill extends StatelessWidget {
  const SavingsNotificationSeverityPill({super.key, required this.severity});

  final SavingsNotificationPreferenceSeverity severity;

  @override
  Widget build(BuildContext context) {
    final color = savingsNotificationSeverityColor(severity);
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .12),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: AppSpacing.earnSmallPillPadding,
        child: Text(
          savingsNotificationSeverityLabel(severity),
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class SavingsNotificationTokenSwitch extends StatelessWidget {
  const SavingsNotificationTokenSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.disabled = false,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: value,
      enabled: !disabled,
      child: VitCard(
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.sm,
        padding: AppSpacing.zeroInsets,
        onTap: disabled ? null : () => onChanged(!value),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: disabled ? .55 : 1,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 160),
            tween: Tween<double>(end: value ? 1 : 0),
            builder: (context, progress, _) {
              final animatedTrackColor = Color.lerp(
                AppColors.surface3,
                AppColors.buy,
                progress,
              )!;
              final animatedBorderColor = Color.lerp(
                AppColors.borderSolid,
                AppColors.buy,
                progress,
              )!;
              final animatedThumbColor = Color.lerp(
                AppColors.text3,
                AppColors.onAccent,
                progress,
              )!;
              final alignment = Alignment.lerp(
                Alignment.centerLeft,
                Alignment.centerRight,
                progress,
              )!;
              return SizedBox(
                width: AppSpacing.savingsNotificationTokenSwitchWidth,
                height: AppSpacing.savingsNotificationTokenSwitchHeight,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: animatedTrackColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.xlRadius,
                      side: BorderSide(color: animatedBorderColor),
                    ),
                  ),
                  child: Padding(
                    padding: AppSpacing.savingsNotificationTokenSwitchInset,
                    child: Align(
                      alignment: alignment,
                      child: SizedBox.square(
                        dimension:
                            AppSpacing.savingsNotificationTokenSwitchThumb,
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                            color: animatedThumbColor,
                            shape: const CircleBorder(),
                            shadows: const [
                              BoxShadow(
                                color: AppColors.overlayScrim,
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Color savingsNotificationSeverityColor(
  SavingsNotificationPreferenceSeverity severity,
) {
  switch (severity) {
    case SavingsNotificationPreferenceSeverity.critical:
      return AppColors.sell;
    case SavingsNotificationPreferenceSeverity.important:
      return AppColors.primary;
    case SavingsNotificationPreferenceSeverity.info:
      return AppColors.accent;
  }
}

String savingsNotificationSeverityLabel(
  SavingsNotificationPreferenceSeverity severity,
) {
  switch (severity) {
    case SavingsNotificationPreferenceSeverity.critical:
      return 'Quan trọng';
    case SavingsNotificationPreferenceSeverity.important:
      return 'Lưu ý';
    case SavingsNotificationPreferenceSeverity.info:
      return 'Thông tin';
  }
}

String savingsNotificationCategoryLabel(
  SavingsNotificationPreferenceCategory category,
) {
  switch (category) {
    case SavingsNotificationPreferenceCategory.product:
      return 'Sản phẩm';
    case SavingsNotificationPreferenceCategory.transaction:
      return 'Giao dịch';
    case SavingsNotificationPreferenceCategory.system:
      return 'Hệ thống';
  }
}

Color savingsNotificationCategoryColor(
  SavingsNotificationPreferenceCategory category,
) {
  switch (category) {
    case SavingsNotificationPreferenceCategory.product:
      return AppColors.primary;
    case SavingsNotificationPreferenceCategory.transaction:
      return AppColors.buy;
    case SavingsNotificationPreferenceCategory.system:
      return AppColors.accent;
  }
}

IconData savingsNotificationCategoryIcon(
  SavingsNotificationPreferenceCategory category,
) {
  switch (category) {
    case SavingsNotificationPreferenceCategory.product:
      return Icons.inventory_2_outlined;
    case SavingsNotificationPreferenceCategory.transaction:
      return Icons.arrow_downward_rounded;
    case SavingsNotificationPreferenceCategory.system:
      return Icons.shield_outlined;
  }
}

IconData savingsNotificationAlertIcon(String key) {
  switch (key) {
    case 'trending':
      return Icons.trending_up_rounded;
    case 'calendar':
      return Icons.calendar_today_rounded;
    case 'warning':
      return Icons.warning_amber_rounded;
    case 'package':
      return Icons.inventory_2_outlined;
    case 'zap':
      return Icons.bolt_rounded;
    case 'download':
      return Icons.arrow_downward_rounded;
    case 'upload':
      return Icons.arrow_upward_rounded;
    case 'piggy':
      return Icons.savings_outlined;
    case 'refresh':
      return Icons.sync_rounded;
    case 'target':
      return Icons.track_changes_rounded;
    case 'settings':
      return Icons.settings_outlined;
    case 'shield':
      return Icons.shield_outlined;
    case 'campaign':
      return Icons.campaign_outlined;
    case 'bell':
      return Icons.notifications_none_rounded;
    case 'mail':
      return Icons.mail_outline_rounded;
    case 'phone':
      return Icons.smartphone_rounded;
    case 'message':
      return Icons.message_outlined;
    default:
      return Icons.notifications_none_rounded;
  }
}

String savingsNotificationFrequencyLabel(SavingsDeliveryFrequency frequency) {
  switch (frequency) {
    case SavingsDeliveryFrequency.instant:
      return 'Ngay lập tức';
    case SavingsDeliveryFrequency.hourly:
      return 'Mỗi giờ';
    case SavingsDeliveryFrequency.daily:
      return 'Hằng ngày';
    case SavingsDeliveryFrequency.weekly:
      return 'Hằng tuần';
  }
}

String savingsNotificationFrequencyDescription(
  SavingsDeliveryFrequency frequency,
) {
  switch (frequency) {
    case SavingsDeliveryFrequency.instant:
      return 'Gửi thông báo mỗi khi sự kiện xảy ra';
    case SavingsDeliveryFrequency.hourly:
      return 'Gộp nhóm thông báo gửi 1 lần/giờ';
    case SavingsDeliveryFrequency.daily:
      return 'Tóm tắt thông báo gửi 1 lần/ngày lúc 9:00';
    case SavingsDeliveryFrequency.weekly:
      return 'Báo cáo tổng hợp gửi mỗi thứ Hai';
  }
}

Color savingsNotificationAssetColorName(String asset) {
  switch (asset) {
    case 'USDT':
      return AppColors.buy;
    case 'BTC':
      return AppColors.primary;
    case 'SOL':
      return AppColors.accent;
    default:
      return AppColors.text2;
  }
}
