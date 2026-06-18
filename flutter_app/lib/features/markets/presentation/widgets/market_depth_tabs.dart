import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_depth_common.dart';

class MarketDepthTabs extends StatelessWidget {
  const MarketDepthTabs({
    required this.activeTab,
    required this.onChanged,
    super.key,
  });

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: SizedBox(
        height: AppSpacing.marketDepthTabsHeight,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  _UnderlinedTab(
                    key: marketDepthChartTabKey,
                    label: 'Depth Chart',
                    value: 'depth',
                    active: activeTab == 'depth',
                    onChanged: onChanged,
                  ),
                  _UnderlinedTab(
                    key: marketDepthOrderBookTabKey,
                    label: 'Order Book',
                    value: 'orderBook',
                    active: activeTab == 'orderBook',
                    onChanged: onChanged,
                  ),
                  _UnderlinedTab(
                    key: marketDepthWhaleAlertTabKey,
                    label: 'Whale Alert',
                    value: 'whale',
                    active: activeTab == 'whale',
                    onChanged: onChanged,
                  ),
                ],
              ),
            ),
            const Divider(
              height: AppSpacing.dividerHairline,
              color: AppColors.divider,
            ),
          ],
        ),
      ),
    );
  }
}

class _UnderlinedTab extends StatelessWidget {
  const _UnderlinedTab({
    required this.label,
    required this.value,
    required this.active,
    required this.onChanged,
    super.key,
  });

  final String label;
  final String value;
  final bool active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onChanged(value),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? marketDepthPrimary : AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                    height: AppSpacing.marketLineHeightTight,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: AppSpacing.marketDepthTabIndicatorHeight,
              child: FractionallySizedBox(
                widthFactor: active ? 1 : 0,
                child: const ColoredBox(color: marketDepthPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
