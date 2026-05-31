part of '../pages/risk_management_demo_page.dart';

class _RiskTabs extends StatelessWidget {
  const _RiskTabs({required this.active, required this.onChanged});

  final _RiskTab active;
  final ValueChanged<_RiskTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (_RiskTab.oco, 'OCO Orders'),
      (_RiskTab.positions, 'Positions'),
      (_RiskTab.calculator, 'Calculator'),
    ];
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _chipBackground,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            Expanded(
              child: _TabButton(
                key: RiskManagementDemoPage.tabKey(tabs[i].$1.name),
                label: tabs[i].$2,
                active: active == tabs[i].$1,
                onTap: () => onChanged(tabs[i].$1),
              ),
            ),
            if (i < tabs.length - 1) const SizedBox(width: 4),
          ],
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? _riskPrimary : AppColors.transparent,
          borderRadius: AppRadii.smRadius,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: active ? AppColors.onAccent : AppColors.text2,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _OcoTab extends StatelessWidget {
  const _OcoTab({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Nhấn nút bên dưới để mở form đặt lệnh OCO',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        _GradientButton(
          key: RiskManagementDemoPage.ocoButtonKey,
          label: 'Mở OCO Order Form',
          icon: Icons.trending_up_rounded,
          colors: const [AppColors.buy, AppColors.buyDark],
          onTap: onOpen,
        ),
      ],
    );
  }
}

class _CalculatorTab extends StatelessWidget {
  const _CalculatorTab({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Nhấn nút bên dưới để mở calculator',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        _GradientButton(
          key: RiskManagementDemoPage.calculatorButtonKey,
          label: 'Mở Position Sizing Calculator',
          icon: Icons.calculate_rounded,
          colors: const [AppColors.accent, AppColors.accentDark],
          onTap: onOpen,
        ),
      ],
    );
  }
}

class _PositionsTab extends StatelessWidget {
  const _PositionsTab({required this.positions});

  final List<TradeRiskPosition> positions;

  @override
  Widget build(BuildContext context) {
    final total = positions.fold<double>(0, (sum, item) => sum + item.pnl);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _cardBackground,
            border: Border.all(color: AppColors.cardBorder),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Row(
            children: [
              Expanded(
                child: _MiniMetric(
                  label: 'Tổng P&L',
                  value: _formatSignedMoney(total),
                  color: total >= 0 ? AppColors.buy : AppColors.sell,
                ),
              ),
              Expanded(
                child: _MiniMetric(
                  label: 'Vị thế',
                  value: '${positions.length}',
                ),
              ),
              const Expanded(
                child: _MiniMetric(label: 'Risk mode', value: 'Active'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        for (final position in positions) ...[
          _PositionTile(position: position),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontSize: 14,
            fontFamily: 'monospace',
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _PositionTile extends StatelessWidget {
  const _PositionTile({required this.position});

  final TradeRiskPosition position;

  @override
  Widget build(BuildContext context) {
    final color = Color(position.logoColorHex);
    final pnlColor = position.pnl >= 0 ? AppColors.buy : AppColors.sell;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBackground,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          _IconTile(
            icon: position.side == TradeRiskPositionSide.long
                ? Icons.north_east_rounded
                : Icons.south_east_rounded,
            color: color,
            size: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        position.symbol,
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 14,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Text(
                      _formatSignedMoney(position.pnl),
                      style: AppTextStyles.caption.copyWith(
                        color: pnlColor,
                        fontFamily: 'monospace',
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '${position.side.name.toUpperCase()} · ${position.amount.toStringAsFixed(position.amount >= 10 ? 0 : 2)} ${position.baseAsset} · Entry ${_formatMoney(position.entryPrice)}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
