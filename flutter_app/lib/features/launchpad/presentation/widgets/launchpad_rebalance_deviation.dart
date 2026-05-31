import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/launchpad/domain/entities/launchpad_entities.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class LaunchpadRebalanceDeviationCard extends StatelessWidget {
  const LaunchpadRebalanceDeviationCard({super.key, required this.assets});

  final List<LaunchpadRebalanceAssetDraft> assets;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Do lech phan bo',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Column(
            children: [for (final asset in assets) _DeviationRow(asset: asset)],
          ),
        ],
      ),
    );
  }
}

class _DeviationRow extends StatelessWidget {
  const _DeviationRow({required this.asset});

  final LaunchpadRebalanceAssetDraft asset;

  @override
  Widget build(BuildContext context) {
    const maxPercent = 36.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Text(
              asset.symbol,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontSize: 10,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                _DeviationBar(
                  value: asset.currentPercent,
                  maxValue: maxPercent,
                  color: asset.accent,
                ),
                const SizedBox(height: 3),
                _DeviationBar(
                  value: asset.targetPercent,
                  maxValue: maxPercent,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviationBar extends StatelessWidget {
  const _DeviationBar({
    required this.value,
    required this.maxValue,
    required this.color,
  });

  final double value;
  final double maxValue;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth * (value / maxValue).clamp(0, 1);
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: width,
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      },
    );
  }
}
