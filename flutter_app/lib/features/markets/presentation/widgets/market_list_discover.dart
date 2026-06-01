import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
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
        const SizedBox(height: 8),
        VitCard(
          clip: true,
          padding: EdgeInsets.zero,
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
              const Divider(height: 1, thickness: 1, color: AppColors.divider),
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
    return Row(
      children: [
        Container(
          width: 4,
          height: 17,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          title,
          style: AppTextStyles.body.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            height: 1.1,
          ),
        ),
      ],
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: AppRadii.mdRadius,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
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
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.10),
                          borderRadius: AppRadii.xsRadius,
                        ),
                        child: Text(
                          badge,
                          style: AppTextStyles.micro.copyWith(
                            color: color,
                            fontSize: 8,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
