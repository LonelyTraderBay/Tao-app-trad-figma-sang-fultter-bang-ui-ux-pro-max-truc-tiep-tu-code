import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Compact "configure this first" callout: an icon-badge header row (title +
/// subtitle) followed by a full-width CTA button that sends the user to the
/// missing configuration flow.
///
/// Distinct from `VitEmptyState` (large centered icon, full-page layout) and
/// `VitNextActionCard` (the whole row is tappable, no dedicated CTA button
/// below the header). Use this when a DCA sub-feature (schedule analytics,
/// rebalance dashboard, ...) has no saved configuration yet.
class DcaMissingConfigPanel extends StatelessWidget {
  const DcaMissingConfigPanel({
    super.key,
    required this.icon,
    required this.title,
    this.titleKey,
    required this.subtitle,
    required this.ctaLabel,
    required this.ctaIcon,
    this.ctaKey,
    required this.onConfigure,
  });

  /// Icon shown inside the accent-tinted circular badge.
  final IconData icon;

  /// Bold header line (typically the backend's "configuration not found"
  /// message).
  final String title;

  /// Optional key on the title [Text], preserved for widget-test lookups.
  final Key? titleKey;

  /// Caption line explaining what needs to be configured first.
  final String subtitle;

  final String ctaLabel;
  final IconData ctaIcon;

  /// Optional key on the CTA button, preserved for widget-test lookups.
  final Key? ctaKey;

  final VoidCallback onConfigure;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox.square(
                dimension: AppSpacing.buttonCompact,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: AppModuleAccents.dca.withValues(alpha: .12),
                    shape: const CircleBorder(),
                  ),
                  child: Icon(
                    icon,
                    color: AppModuleAccents.dca,
                    size: AppSpacing.iconMd,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      key: titleKey,
                      style: AppTextStyles.base.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCtaButton(
            key: ctaKey,
            onPressed: onConfigure,
            leading: Icon(ctaIcon),
            child: Text(ctaLabel),
          ),
        ],
      ),
    );
  }
}
