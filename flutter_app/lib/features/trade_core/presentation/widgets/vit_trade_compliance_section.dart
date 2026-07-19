import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_info_row.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_status_pill.dart';

class VitTradeComplianceItem {
  const VitTradeComplianceItem({
    required this.label,
    required this.value,
    this.leading,
    this.trailing,
    this.valueColor,
    this.onTap,
  });

  final String label;
  final String value;
  final Widget? leading;
  final Widget? trailing;
  final Color? valueColor;
  final VoidCallback? onTap;
}

/// Home-aligned compliance section for trade L2 detail pages.
class VitTradeComplianceSection extends StatelessWidget {
  const VitTradeComplianceSection({
    super.key,
    required this.title,
    required this.items,
    this.statusPill,
    this.actionLabel,
    this.onAction,
    this.density = VitDensity.tool,
  });

  final String title;
  final List<VitTradeComplianceItem> items;
  final VitStatusPill? statusPill;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VitDensity density;

  @override
  Widget build(BuildContext context) {
    assert(items.isNotEmpty, 'Compliance section requires at least one item.');

    return VitTradeSection(
      title: title,
      actionLabel: actionLabel,
      onAction: onAction,
      headerTrailing: statusPill,
      child: VitCard(
        clip: true,
        density: density,
        radius: VitCardRadius.tight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var index = 0; index < items.length; index += 1) ...[
              VitInfoRow(
                label: items[index].label,
                value: items[index].value,
                leading: items[index].leading,
                trailing: items[index].trailing,
                valueColor: items[index].valueColor,
                density: density,
                onTap: items[index].onTap,
              ),
              if (index < items.length - 1)
                const Divider(height: 1, color: AppColors.divider),
            ],
          ],
        ),
      ),
    );
  }
}
