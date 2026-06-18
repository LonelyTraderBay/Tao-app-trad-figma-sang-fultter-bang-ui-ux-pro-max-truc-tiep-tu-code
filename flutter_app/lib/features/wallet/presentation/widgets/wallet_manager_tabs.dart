import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_manager_common.dart';

class WalletManagerTabs extends StatelessWidget {
  const WalletManagerTabs({
    super.key,
    required this.activeTab,
    required this.onChanged,
  });

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.walletManagerTabsHeight,
      child: ColoredBox(
        color: walletManagerPanel,
        child: Stack(
          children: [
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: AppSpacing.walletManagerWalletDividerHeight,
                child: ColoredBox(color: walletManagerBorder),
              ),
            ),
            Row(
              children: [
                for (final tab in const [
                  walletManagerTabAll,
                  walletManagerTabGroups,
                  walletManagerTabActivity,
                ])
                  Expanded(
                    child: GestureDetector(
                      key: Key('sc148_multi_manager_tab_$tab'),
                      onTap: () => onChanged(tab),
                      behavior: HitTestBehavior.opaque,
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              tab,
                              style: AppTextStyles.caption.copyWith(
                                color: activeTab == tab
                                    ? walletManagerPrimary
                                    : AppColors.textDisabled,
                                fontWeight: AppTextStyles.medium,
                                height: AppSpacing.tradeBotLineHeightTight,
                              ),
                            ),
                          ),
                          Positioned(
                            left: AppSpacing.walletManagerTabIndicatorInset,
                            right: AppSpacing.walletManagerTabIndicatorInset,
                            bottom: 0,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 150),
                              opacity: activeTab == tab ? 1 : 0,
                              child: const SizedBox(
                                height:
                                    AppSpacing.walletManagerTabIndicatorHeight,
                                child: ColoredBox(color: walletManagerPrimary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
