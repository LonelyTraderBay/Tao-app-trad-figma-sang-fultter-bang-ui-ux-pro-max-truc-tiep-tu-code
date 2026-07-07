import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
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
      padding: AppSpacing.launchpadPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Do lech phan bo',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
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
      padding: AppSpacing.launchpadBottomPaddingX2,
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.launchpadBox44,
            child: Text(
              asset.symbol,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                _DeviationBar(
                  value: asset.currentPercent,
                  maxValue: maxPercent,
                  color: asset.accent.resolve(),
                ),
                const SizedBox(height: AppSpacing.launchpadGapXs),
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
          child: SizedBox(
            width: width,
            height: AppSpacing.launchpadDotXs,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: color,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.swatchRadius,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
