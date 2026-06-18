part of '../pages/advanced_trading_demo_page.dart';

class _PositionModeCard extends StatelessWidget {
  const _PositionModeCard({required this.activeMode, required this.onChanged});

  final String activeMode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: AppSpacing.tradeToolRiskIntroPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.settings_outlined,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.tradeToolInlineGap),
              Text(
                'Position Mode',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.text3,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.tradeToolPageTopGap),
          VitCard(
            height: AppSpacing.tradeToolRiskTabHeight,
            padding: AppSpacing.tradeToolMetricPadding,
            variant: VitCardVariant.inner,
            child: Row(
              children: [
                _ModeButton(
                  id: 'one-way',
                  label: 'One-Way Mode',
                  activeMode: activeMode,
                  onChanged: onChanged,
                ),
                _ModeButton(
                  id: 'hedge',
                  label: 'Hedge Mode',
                  activeMode: activeMode,
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.tradeToolIconGap),
          Text(
            activeMode == 'one-way'
                ? 'Chỉ được giữ Long HOẶC Short cho mỗi cặp. Đơn giản, phù hợp beginner.'
                : 'Có thể giữ đồng thời Long VÀ Short cho cùng 1 cặp. Dùng cho hedging strategy.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.id,
    required this.label,
    required this.activeMode,
    required this.onChanged,
  });

  final String id;
  final String label;
  final String activeMode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final active = activeMode == id;
    return Expanded(
      child: VitCard(
        key: AdvancedTradingDemoPage.modeKey(id),
        onTap: () => onChanged(id),
        alignment: Alignment.center,
        variant: active ? VitCardVariant.standard : VitCardVariant.ghost,
        radius: VitCardRadius.sm,
        borderColor: active ? AppColors.primary : AppColors.transparent,
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? AppColors.onAccent : AppColors.text3,
            fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _UnderlineTabs extends StatelessWidget {
  const _UnderlineTabs({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  static const _tabs = [
    ('position', 'Position Controls'),
    ('orders', 'Order Types'),
    ('analytics', 'PnL Analytics'),
  ];

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.underline,
      activeKey: activeId,
      onChanged: onChanged,
      tabs: [
        for (final tab in _tabs)
          VitTabItem(
            key: tab.$1,
            label: tab.$2,
            widgetKey: AdvancedTradingDemoPage.tabKey(tab.$1),
          ),
      ],
    );
  }
}

class _PositionTab extends StatelessWidget {
  const _PositionTab({required this.snapshot, required this.onAction});

  final TradeAdvancedTradingDemoSnapshot snapshot;
  final ValueChanged<TradeAdvancedDemoAction> onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Panel(
          padding: AppSpacing.tradeToolRiskIntroPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Position Management Features',
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.tradeToolInlineGap),
              Text(
                'Professional tools để quản lý vị thế hiệu quả',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppSpacing.tradeToolPageTopGap),
              for (final action in snapshot.positionActions) ...[
                _ActionButton(action: action, onTap: () => onAction(action)),
                if (action != snapshot.positionActions.last)
                  const SizedBox(height: AppSpacing.tradeToolInlineGap),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.tradeToolPageTopGap),
        _MockPositionCard(position: snapshot.position),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.action, required this.onTap});

  final TradeAdvancedDemoAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: AdvancedTradingDemoPage.actionKey(action.id),
      onTap: onTap,
      constraints: const BoxConstraints(minHeight: AppSpacing.ctaHeight),
      alignment: Alignment.center,
      padding: AppSpacing.tradeToolMetricRowPadding,
      variant: VitCardVariant.inner,
      borderColor: AppColors.borderSolid,
      child: Text(
        action.label,
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text1,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _MockPositionCard extends StatelessWidget {
  const _MockPositionCard({required this.position});

  final TradeAdvancedDemoPosition position;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: AppSpacing.tradeToolRiskIntroPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Mock Position (Demo)',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeToolCardGap),
          _ValueRow(
            label: 'Pair',
            value: '${position.pair} · ${position.side.toUpperCase()}',
          ),
          const SizedBox(height: AppSpacing.tradeToolInlineGap),
          _ValueRow(
            label: 'Size',
            value: '${position.currentSize.toStringAsFixed(1)} BTC',
          ),
          const SizedBox(height: AppSpacing.tradeToolInlineGap),
          _ValueRow(
            label: 'Unrealized PnL',
            value: '+\$${position.currentPnl.toStringAsFixed(2)}',
            tone: TradeAdvancedMetricTone.positive,
          ),
        ],
      ),
    );
  }
}

class _OrdersTab extends StatelessWidget {
  const _OrdersTab({required this.snapshot});

  final TradeAdvancedTradingDemoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Panel(
          padding: AppSpacing.tradeToolRiskIntroPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Loại lệnh',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.tradeToolIconGap),
              Wrap(
                spacing: AppSpacing.tradeToolInlineGap,
                runSpacing: AppSpacing.tradeToolInlineGap,
                children: [
                  for (final type in snapshot.orderTypes)
                    _ChoiceChip(label: type.label, active: type.id == 'limit'),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                'Time In Force',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.tradeToolIconGap),
              Wrap(
                spacing: AppSpacing.tradeToolInlineGap,
                runSpacing: AppSpacing.tradeToolInlineGap,
                children: [
                  for (final tif in snapshot.timeInForce)
                    _ChoiceChip(label: tif.label, active: tif.id == 'GTC'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.tradeToolPageTopGap),
        _MetricsCard(title: 'Order Summary', metrics: snapshot.orderSummary),
      ],
    );
  }
}
