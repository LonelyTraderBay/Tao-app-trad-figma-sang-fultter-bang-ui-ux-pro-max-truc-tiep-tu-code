import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class PredictionsPortfolioArenaBridgeCard extends StatelessWidget {
  const PredictionsPortfolioArenaBridgeCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitDiscoveryActionCard(
      title: 'Khám phá Arena cùng chủ đề',
      badgeLabel: 'Arena Points',
      subtitle: 'Social points-only · Không liên quan ví hay vị thế Prediction',
      actionLabel:
          'Prediction positions and P/L stay separate from Arena Points.',
      icon: Icons.sports_esports_rounded,
      accentColor: AppColors.warn,
      borderColor: AppColors.warningBorder,
      badgeStatus: VitStatusPillStatus.warning,
      variant: VitDiscoveryActionCardVariant.compact,
      background: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.warn15, AppColors.warn10],
      ),
      onTap: onTap,
    );
  }
}
