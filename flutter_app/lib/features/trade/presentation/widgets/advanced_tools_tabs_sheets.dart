part of '../pages/advanced_tools_demo_page.dart';

class _ToolsTabs extends StatelessWidget {
  const _ToolsTabs({required this.active, required this.onChanged});

  final _ToolsTab active;
  final ValueChanged<_ToolsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (_ToolsTab.ladder, 'Ladder'),
      (_ToolsTab.bulk, 'Bulk Ops'),
      (_ToolsTab.shortcuts, 'Shortcuts'),
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
                key: AdvancedToolsDemoPage.tabKey(tabs[i].$1.name),
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

class _ActionTab extends StatelessWidget {
  const _ActionTab({
    required this.description,
    required this.buttonKey,
    required this.label,
    required this.icon,
    required this.colors,
    required this.onOpen,
  });

  final String description;
  final Key buttonKey;
  final String label;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          description,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        _GradientButton(
          key: buttonKey,
          label: label,
          icon: icon,
          colors: colors,
          onTap: onOpen,
        ),
      ],
    );
  }
}

class _LadderSheet extends StatelessWidget {
  const _LadderSheet({required this.orders});

  final List<TradeLadderOrder> orders;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Ladder Trading',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'BTC/USDT DOM · click price level to place instant order.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          for (final offset in const [150, 100, 50, 0, -50, -100]) ...[
            _LadderLevel(price: 69000 + offset),
            const SizedBox(height: 6),
          ],
          const SizedBox(height: 8),
          for (final order in orders) ...[
            _SheetRow(
              label: '${order.side.name.toUpperCase()} ${order.id}',
              value:
                  '${order.amount.toStringAsFixed(1)} BTC @ \$${_formatMoney(order.price)}',
            ),
          ],
          const SizedBox(height: 14),
          _GradientButton(
            key: AdvancedToolsDemoPage.ladderSubmitKey,
            label: 'Place Buy Order',
            icon: Icons.check_rounded,
            colors: const [AppColors.buy, AppColors.buyDark],
            onTap: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}

class _BulkSheet extends StatelessWidget {
  const _BulkSheet({required this.orders});

  final List<TradeBulkOrder> orders;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Bulk Operations',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${orders.length} open orders selected for batch action.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          for (final order in orders) ...[
            _SheetRow(
              label: '${order.symbol} ${order.side.name.toUpperCase()}',
              value:
                  '${order.remaining.toStringAsFixed(1)} @ \$${_formatMoney(order.price)}',
            ),
          ],
          const SizedBox(height: 14),
          _GradientButton(
            key: AdvancedToolsDemoPage.bulkCancelKey,
            label: 'Cancel Selected Orders',
            icon: Icons.close_rounded,
            colors: const [AppColors.caution, AppColors.medalBronzeMuted],
            onTap: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}

class _ShortcutsSheet extends StatelessWidget {
  const _ShortcutsSheet({required this.shortcuts});

  final List<TradeShortcut> shortcuts;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Keyboard Shortcuts',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final shortcut in shortcuts) ...[
            _SheetRow(label: shortcut.keys, value: shortcut.label),
          ],
          const SizedBox(height: 14),
          _GradientButton(
            key: AdvancedToolsDemoPage.shortcutTriggerKey,
            label: 'Trigger Quick Buy',
            icon: Icons.keyboard_rounded,
            colors: const [AppColors.accent, AppColors.accentDark],
            onTap: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}

class _LadderLevel extends StatelessWidget {
  const _LadderLevel({required this.price});

  final int price;

  @override
  Widget build(BuildContext context) {
    final isAsk = price > 69000;
    final color = isAsk ? AppColors.sell : AppColors.buy;
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              isAsk ? 'SELL' : 'BUY',
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Text(
            '\$${_formatMoney(price.toDouble())}',
            style: AppTextStyles.caption.copyWith(
              fontFamily: 'monospace',
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
