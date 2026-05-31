import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/dca_backtester_common.dart';

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
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _TopTab(
            label: 'Cài đặt',
            tab: DcaBacktesterTab.setup,
            active: activeTab == DcaBacktesterTab.setup,
            tabKey: tabKey,
            onChanged: onChanged,
          ),
          _TopTab(
            label: 'Kết quả',
            tab: DcaBacktesterTab.results,
            active: activeTab == DcaBacktesterTab.results,
            tabKey: tabKey,
            onChanged: onChanged,
          ),
          _TopTab(
            label: 'Phân tích',
            tab: DcaBacktesterTab.analysis,
            active: activeTab == DcaBacktesterTab.analysis,
            tabKey: tabKey,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _TopTab extends StatelessWidget {
  const _TopTab({
    required this.label,
    required this.tab,
    required this.active,
    required this.tabKey,
    required this.onChanged,
  });

  final String label;
  final DcaBacktesterTab tab;
  final bool active;
  final Key Function(String tabName) tabKey;
  final ValueChanged<DcaBacktesterTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        key: tabKey(tab.name),
        onTap: () => onChanged(tab),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: active ? AppColors.primary : AppColors.text3,
                  fontWeight: active
                      ? AppTextStyles.bold
                      : AppTextStyles.medium,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: AppSpacing.x1,
              width: double.infinity,
              color: active ? AppColors.primary : AppColors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
