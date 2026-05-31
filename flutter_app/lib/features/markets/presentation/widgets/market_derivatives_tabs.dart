import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_derivatives_common.dart';

class MarketDerivativesTabs extends StatelessWidget {
  const MarketDerivativesTabs({
    super.key,
    required this.activeTab,
    required this.onChanged,
  });

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SizedBox(
        height: 54,
        child: Row(
          children: [
            _UnderlinedTab(
              key: MarketDerivativesKeys.overviewTab,
              label: 'Tổng quan',
              value: 'overview',
              active: activeTab == 'overview',
              onChanged: onChanged,
            ),
            _UnderlinedTab(
              key: MarketDerivativesKeys.perpetualTab,
              label: 'Perpetual',
              value: 'perpetual',
              active: activeTab == 'perpetual',
              onChanged: onChanged,
            ),
            _UnderlinedTab(
              key: MarketDerivativesKeys.liquidationTab,
              label: 'Thanh lý',
              value: 'liquidation',
              active: activeTab == 'liquidation',
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _UnderlinedTab extends StatelessWidget {
  const _UnderlinedTab({
    super.key,
    required this.label,
    required this.value,
    required this.active,
    required this.onChanged,
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
                    color: active ? marketDerivativesPrimary : AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 2,
              child: FractionallySizedBox(
                widthFactor: active ? 1 : 0,
                child: const ColoredBox(color: marketDerivativesPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
