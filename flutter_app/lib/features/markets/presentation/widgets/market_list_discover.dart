import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_list_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class MarketListDiscoverMoreSection extends StatelessWidget {
  const MarketListDiscoverMoreSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel(
          title: 'Khám phá thêm',
          accentColor: marketListPredictionAccent,
        ),
        const SizedBox(height: AppSpacing.marketDiscoverLabelGap),
        VitCard(
          clip: true,
          padding: AppSpacing.zeroInsets,
          child: Column(
            children: [
              _DiscoverRow(
                icon: Icons.gps_fixed_rounded,
                title: 'Prediction Markets',
                subtitle: 'Dự đoán sự kiện · Xác suất · Vị thế',
                badge: 'Real positions',
                color: marketListPredictionAccent,
                onTap: () => context.go(AppRoutePaths.marketsPredictions),
              ),
              const Divider(
                height: AppSpacing.dividerHairline,
                thickness: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
              _DiscoverRow(
                icon: Icons.sports_esports_outlined,
                title: 'Open Arena',
                subtitle: 'Creator modes · Thách đấu · Arena Points',
                badge: 'Points only',
                color: marketListArenaAccent,
                onTap: () => context.go(AppRoutePaths.arena),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title, required this.accentColor});

  final String title;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return VitSectionHeader(
      title: title,
      variant: VitSectionHeaderVariant.accentBar,
      accentColor: accentColor,
    );
  }
}

class _DiscoverRow extends StatelessWidget {
  const _DiscoverRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: AppSpacing.marketDiscoverRowPadding,
        child: Row(
          children: [
            Material(
              color: color.withValues(alpha: 0.12),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.mdRadius,
              ),
              child: SizedBox(
                width: AppSpacing.marketDiscoverIconBox,
                height: AppSpacing.marketDiscoverIconBox,
                child: Icon(
                  icon,
                  color: color,
                  size: AppSpacing.marketDiscoverIcon,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.marketDiscoverRowGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: AppSpacing.marketDiscoverTitleBadgeGap,
                      ),
                      VitAccentPill(label: badge, accentColor: color),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.marketDiscoverSubtitleGap),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: AppSpacing.marketDiscoverChevron,
            ),
          ],
        ),
      ),
    );
  }
}
