import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/research/dca_backtester_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class DcaBacktesterTopTabs extends StatelessWidget {
  const DcaBacktesterTopTabs({
    super.key,
    required this.activeTab,
    required this.tabKey,
    required this.onChanged,
  });

  final DcaBacktesterTab activeTab;
  final Key Function(String tabName) tabKey;
  final ValueChanged<DcaBacktesterTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          VitTabBar(
            variant: VitTabBarVariant.underline,
            activeKey: activeTab.name,
            onChanged: (key) => onChanged(DcaBacktesterTab.values.byName(key)),
            tabs: [
              VitTabItem(
                key: DcaBacktesterTab.setup.name,
                label: 'Cài đặt',
                widgetKey: tabKey(DcaBacktesterTab.setup.name),
              ),
              VitTabItem(
                key: DcaBacktesterTab.results.name,
                label: 'Kết quả',
                widgetKey: tabKey(DcaBacktesterTab.results.name),
              ),
              VitTabItem(
                key: DcaBacktesterTab.analysis.name,
                label: 'Phân tích',
                widgetKey: tabKey(DcaBacktesterTab.analysis.name),
              ),
            ],
          ),
          const SizedBox(
            width: double.infinity,
            height: AppSpacing.dividerHairline,
            child: ColoredBox(color: AppColors.border),
          ),
        ],
      ),
    );
  }
}
