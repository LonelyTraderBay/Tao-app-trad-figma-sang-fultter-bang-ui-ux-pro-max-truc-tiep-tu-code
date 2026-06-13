part of '../pages/advanced_trading_demo_page.dart';

class _PositionModeCard extends StatelessWidget {
  const _PositionModeCard({required this.activeMode, required this.onChanged});

  final String activeMode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const EdgeInsets.all(16),
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
              const SizedBox(width: 8),
              Text(
                'Position Mode',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
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
          const SizedBox(height: 14),
          VitCard(
            height: 44,
            padding: const EdgeInsets.all(4),
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
          const SizedBox(height: 10),
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
      child: InkWell(
        key: AdvancedTradingDemoPage.modeKey(id),
        onTap: () => onChanged(id),
        borderRadius: AppRadii.mdRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.transparent,
            borderRadius: AppRadii.mdRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: active ? AppColors.onAccent : AppColors.text3,
              fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
              height: 1,
            ),
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
    return VitCard(
      borderColor: AppColors.divider,
      child: Row(
        children: [
          for (final tab in _tabs)
            Expanded(
              child: InkWell(
                key: AdvancedTradingDemoPage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: activeId == tab.$1
                            ? AppColors.primary
                            : AppColors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    tab.$2,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: activeId == tab.$1
                          ? AppColors.primary
                          : AppColors.text3,
                      fontWeight: activeId == tab.$1
                          ? AppTextStyles.bold
                          : AppTextStyles.medium,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Position Management Features',
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.bold,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                'Professional tools để quản lý vị thế hiệu quả',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 14),
              for (final action in snapshot.positionActions) ...[
                _ActionButton(action: action, onTap: () => onAction(action)),
                if (action != snapshot.positionActions.last)
                  const SizedBox(height: 9),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
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
      constraints: const BoxConstraints(minHeight: 46),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      variant: VitCardVariant.inner,
      borderColor: AppColors.borderSolid,
      child: Text(
        action.label,
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text1,
          fontWeight: AppTextStyles.bold,
          height: 1.25,
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Mock Position (Demo)',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
          _ValueRow(
            label: 'Pair',
            value: '${position.pair} · ${position.side.toUpperCase()}',
          ),
          const SizedBox(height: 8),
          _ValueRow(
            label: 'Size',
            value: '${position.currentSize.toStringAsFixed(1)} BTC',
          ),
          const SizedBox(height: 8),
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
          padding: const EdgeInsets.all(16),
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
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final type in snapshot.orderTypes)
                    _ChoiceChip(label: type.label, active: type.id == 'limit'),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Time In Force',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tif in snapshot.timeInForce)
                    _ChoiceChip(label: tif.label, active: tif.id == 'GTC'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _MetricsCard(title: 'Order Summary', metrics: snapshot.orderSummary),
      ],
    );
  }
}

