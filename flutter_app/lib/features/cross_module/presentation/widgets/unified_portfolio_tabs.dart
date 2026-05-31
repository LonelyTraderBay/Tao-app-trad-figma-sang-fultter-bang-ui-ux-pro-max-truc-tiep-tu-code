import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/entities/unified_portfolio_entities.dart';

class UnifiedPortfolioTabs extends StatelessWidget {
  const UnifiedPortfolioTabs({
    super.key,
    required this.tabs,
    required this.active,
    required this.tabKey,
    required this.onChanged,
  });

  final List<UnifiedPortfolioTabDraft> tabs;
  final UnifiedPortfolioTab active;
  final Key Function(UnifiedPortfolioTab tab) tabKey;
  final ValueChanged<UnifiedPortfolioTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
        child: Row(
          children: [
            for (final tab in tabs)
              Expanded(
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    key: tabKey(tab.tab),
                    onTap: () => onChanged(tab.tab),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.x4,
                          ),
                          child: Text(
                            tab.label,
                            style: AppTextStyles.caption.copyWith(
                              color: tab.tab == active
                                  ? AppColors.primary
                                  : AppColors.text3,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          height: 2,
                          width: tab.tab == active ? AppSpacing.buttonHero : 0,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: AppRadii.xlRadius,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
