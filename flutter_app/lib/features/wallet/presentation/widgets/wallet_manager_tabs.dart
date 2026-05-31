import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
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
    return Container(
      height: 54,
      decoration: const BoxDecoration(
        color: walletManagerPanel,
        border: Border(bottom: BorderSide(color: walletManagerBorder)),
      ),
      child: Row(
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
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 7,
                      right: 7,
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        height: 2,
                        color: activeTab == tab
                            ? walletManagerPrimary
                            : AppColors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
