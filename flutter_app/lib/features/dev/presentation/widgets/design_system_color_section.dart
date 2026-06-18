import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/dev/domain/entities/dev_tools_entities.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/design_system_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';

class DesignSystemColorSection extends StatelessWidget {
  const DesignSystemColorSection({
    super.key,
    required this.sectionKey,
    required this.swatchKey,
    required this.swatches,
  });

  final Key sectionKey;
  final Key Function(String id) swatchKey;
  final List<DesignSwatchDraft> swatches;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: sectionKey,
      label: 'Color Palette',
      children: [
        Wrap(
          spacing: AppSpacing.x5,
          runSpacing: AppSpacing.x5,
          children: [
            for (final swatch in swatches)
              _Swatch(key: swatchKey(swatch.id), swatch: swatch),
          ],
        ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({super.key, required this.swatch});

  final DesignSwatchDraft swatch;

  @override
  Widget build(BuildContext context) {
    final color = designSystemColorForSwatch(swatch.id);

    return SizedBox(
      width: AppSpacing.x7,
      child: Column(
        children: [
          DecoratedBox(
            decoration: ShapeDecoration(
              color: color,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.cardRadius,
                side: BorderSide(color: AppColors.borderSolid),
              ),
            ),
            child: const SizedBox(
              width: AppSpacing.buttonStandard,
              height: AppSpacing.buttonStandard,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            swatch.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
          Text(
            swatch.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.chartLabelXs.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
