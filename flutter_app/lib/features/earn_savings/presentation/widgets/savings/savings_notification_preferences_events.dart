import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_notification_preferences_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class SavingsNotificationEventsTab extends StatelessWidget {
  const SavingsNotificationEventsTab({
    super.key,
    required this.alerts,
    required this.masterEnabled,
    required this.onToggle,
  });

  final List<SavingsNotificationAlertDraft> alerts;
  final bool masterEnabled;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsNotificationPreferencesKeys.eventsList,
      children: [
        for (final category in SavingsNotificationPreferenceCategory.values)
          _CategorySection(
            category: category,
            alerts: [
              for (final alert in alerts)
                if (alert.category == category) alert,
            ],
            masterEnabled: masterEnabled,
            onToggle: onToggle,
          ),
      ],
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.category,
    required this.alerts,
    required this.masterEnabled,
    required this.onToggle,
  });

  final SavingsNotificationPreferenceCategory category;
  final List<SavingsNotificationAlertDraft> alerts;
  final bool masterEnabled;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final color = savingsNotificationCategoryColor(category);
    final enabled = alerts.where((item) => item.enabled).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              savingsNotificationCategoryIcon(category),
              color: color,
              size: EarnSpacingTokens.savingsNotificationInlineIcon,
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              savingsNotificationCategoryLabel(category),
              style: savingsNotificationCaptionMedium.copyWith(
                color: AppColors.text2,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              '($enabled/${alerts.length})',
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        for (final alert in alerts) ...[
          _AlertCard(
            alert: alert,
            enabled: masterEnabled && alert.enabled,
            disabled: !masterEnabled,
            onToggle: () => onToggle(alert.id),
          ),
          if (alert != alerts.last)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
      ],
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.alert,
    required this.enabled,
    required this.disabled,
    required this.onToggle,
  });

  final SavingsNotificationAlertDraft alert;
  final bool enabled;
  final bool disabled;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final color = savingsNotificationSeverityColor(alert.severity);

    return VitCard(
      key: SavingsNotificationPreferencesKeys.alert(alert.id),
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
              child: Icon(
                savingsNotificationAlertIcon(alert.iconKey),
                color: color,
                size: EarnSpacingTokens.savingsNotificationAlertIcon,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        alert.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: savingsNotificationCaptionMedium.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    SavingsNotificationSeverityPill(severity: alert.severity),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  alert.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height:
                        EarnSpacingTokens.savingsNotificationAlertLineHeight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          SavingsNotificationTokenSwitch(
            value: enabled,
            disabled: disabled,
            onChanged: (_) => onToggle(),
          ),
        ],
      ),
    );
  }
}
