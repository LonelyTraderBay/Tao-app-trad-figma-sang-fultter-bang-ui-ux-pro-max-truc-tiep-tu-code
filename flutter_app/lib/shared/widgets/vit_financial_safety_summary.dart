import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_info_row.dart';

/// One label/value row rendered by [VitFinancialSafetySummary].
class VitFinancialSafetyItem {
  const VitFinancialSafetyItem({
    required this.label,
    required this.value,
    this.leading,
    this.valueColor,
  });

  final String label;
  final String value;
  final Widget? leading;
  final Color? valueColor;
}

/// Financial preview/confirm card: title, optional contract id, a list of
/// [VitFinancialSafetyItem] rows, and an optional footer note.
class VitFinancialSafetySummary extends StatelessWidget {
  const VitFinancialSafetySummary({
    super.key,
    required this.items,
    this.title = 'Safety review',
    this.contractId,
    this.footer,
    this.density = VitDensity.compact,
  });

  final List<VitFinancialSafetyItem> items;
  final String title;
  final String? contractId;
  final String? footer;
  final VitDensity density;

  @override
  Widget build(BuildContext context) {
    assert(items.isNotEmpty, 'Safety summary requires at least one item.');

    final itemLabels = items
        .map((item) => '${item.label}: ${item.value}')
        .join(', ');
    final contractLabel = contractId == null ? '' : ', Contract: $contractId';

    return Semantics(
      container: true,
      label: '$title$contractLabel. $itemLabels',
      child: VitCard(
        density: density,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.medium,
              ),
            ),
            SizedBox(height: density.verticalSpace),
            for (var index = 0; index < items.length; index += 1)
              VitInfoRow(
                label: items[index].label,
                value: items[index].value,
                leading: items[index].leading,
                valueColor: items[index].valueColor,
                density: density,
                showDivider: index < items.length - 1,
              ),
            if (footer != null) ...[
              SizedBox(height: density.verticalSpace),
              Text(
                footer!,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
