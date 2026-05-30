import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

const _tradePrimary = AppColors.primary;
const _cardBackground = AppColors.surface2;
const _chipBackground = AppColors.surface2;
const _futuresColor = AppColors.caution;
const _marginColor = AppColors.accent;

class PositionDashboardPage extends ConsumerStatefulWidget {
  const PositionDashboardPage({super.key, this.shellRenderMode});

  static Key tabKey(String id) => Key('sc053_tab_$id');
  static Key sortKey(String id) => Key('sc053_sort_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PositionDashboardPage> createState() =>
      _PositionDashboardPageState();
}

class _PositionDashboardPageState extends ConsumerState<PositionDashboardPage> {
  String _activeTab = 'all';
  String _sortBy = 'pnl';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getTradePositions();
    final positions = _visiblePositions(snapshot.positions);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-053 PositionDashboardPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Vị thế đang mở',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.trade),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: bottomChrome + 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SummaryCard(positions: snapshot.positions),
                    _TypeTabs(
                      active: _activeTab,
                      positions: snapshot.positions,
                      onChanged: (tab) => setState(() => _activeTab = tab),
                    ),
                    _SortChips(
                      active: _sortBy,
                      onChanged: (sort) => setState(() => _sortBy = sort),
                    ),
                    const SizedBox(height: 14),
                    if (positions.isEmpty)
                      const _EmptyPositions()
                    else
                      for (final position in positions) ...[
                        _PositionTile(position: position),
                        const SizedBox(height: 16),
                      ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TradeDashboardPosition> _visiblePositions(
    List<TradeDashboardPosition> source,
  ) {
    final filtered = _activeTab == 'all'
        ? source
        : source.where((position) => position.type.name == _activeTab);
    final sorted = filtered.toList(growable: false);
    sorted.sort((a, b) {
      if (_sortBy == 'pnlPct') return b.pnlPct.abs().compareTo(a.pnlPct.abs());
      if (_sortBy == 'size') return b.notional.compareTo(a.notional);
      return b.pnl.abs().compareTo(a.pnl.abs());
    });
    return sorted;
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.positions});

  final List<TradeDashboardPosition> positions;

  @override
  Widget build(BuildContext context) {
    final totalPnl = positions.fold<double>(0, (sum, item) => sum + item.pnl);
    final totalValue = positions.fold<double>(
      0,
      (sum, item) => sum + item.notional,
    );
    final totalMargin = positions.fold<double>(
      0,
      (sum, item) => sum + (item.margin ?? 0),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      child: Container(
        height: 72,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        decoration: BoxDecoration(
          color: _cardBackground,
          border: Border.all(color: AppColors.cardBorder),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          children: [
            Expanded(
              child: _SummaryMetric(
                label: 'Tổng P/L',
                value: _formatSignedMoney(totalPnl),
                color: totalPnl >= 0 ? AppColors.buy : AppColors.sell,
                large: true,
              ),
            ),
            Expanded(
              child: _SummaryMetric(
                label: 'Tổng giá trị',
                value: _formatCompactMoney(totalValue),
              ),
            ),
            Expanded(
              child: _SummaryMetric(
                label: 'Ký quỹ đang dùng',
                value: '\$${_formatMoney(totalMargin)}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
    this.large = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontSize: large ? 18 : 13,
            fontFamily: 'monospace',
            fontWeight: AppTextStyles.bold,
            height: 1,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _TypeTabs extends StatelessWidget {
  const _TypeTabs({
    required this.active,
    required this.positions,
    required this.onChanged,
  });

  final String active;
  final List<TradeDashboardPosition> positions;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ('all', 'Tất cả (${positions.length})'),
      ('spot', 'Spot (${_count(TradePositionType.spot)})'),
      ('futures', 'Futures (${_count(TradePositionType.futures)})'),
      ('margin', 'Margin (${_count(TradePositionType.margin)})'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            Expanded(
              child: _PillButton(
                key: PositionDashboardPage.tabKey(tabs[i].$1),
                label: tabs[i].$2,
                active: active == tabs[i].$1,
                onTap: () => onChanged(tabs[i].$1),
              ),
            ),
            if (i < tabs.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  int _count(TradePositionType type) {
    return positions.where((position) => position.type == type).length;
  }
}

class _SortChips extends StatelessWidget {
  const _SortChips({required this.active, required this.onChanged});

  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final sorts = const [
      ('pnl', 'P/L'),
      ('pnlPct', '%P/L'),
      ('size', 'Kích thước'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        children: [
          Text(
            'SẮP XẾP',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(width: 10),
          for (final sort in sorts) ...[
            _SortChip(
              key: PositionDashboardPage.sortKey(sort.$1),
              label: sort.$2,
              active: active == sort.$1,
              onTap: () => onChanged(sort.$1),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
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
      borderRadius: AppRadii.lgRadius,
      child: Container(
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _tradePrimary.withValues(alpha: .16)
              : _chipBackground,
          border: Border.all(
            color: active ? _tradePrimary : AppColors.transparent,
          ),
          borderRadius: AppRadii.lgRadius,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: active ? _tradePrimary : AppColors.text3,
            fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
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
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _tradePrimary.withValues(alpha: .16)
              : _chipBackground,
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: active ? _tradePrimary : AppColors.text3,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _PositionTile extends StatelessWidget {
  const _PositionTile({required this.position});

  final TradeDashboardPosition position;

  @override
  Widget build(BuildContext context) {
    final isProfit = position.pnl >= 0;
    final pnlColor = isProfit ? AppColors.buy : AppColors.sell;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 19),
      decoration: BoxDecoration(
        color: _cardBackground,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _TypeBadge(type: position.type),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  position.symbol,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontSize: 15,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
              _SideBadge(position: position),
              const SizedBox(width: 8),
              Text(
                _formatSignedMoney(position.pnl),
                style: AppTextStyles.caption.copyWith(
                  color: pnlColor,
                  fontSize: 14,
                  fontFamily: 'monospace',
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: _PositionMetric(
                  label: 'KL',
                  value: _formatAmount(position.size),
                ),
              ),
              Expanded(
                child: _PositionMetric(
                  label: 'Giá vào',
                  value: _formatMoney(position.entryPrice),
                ),
              ),
              Expanded(
                child: _PositionMetric(
                  label: 'Giá hiện tại',
                  value: _formatMoney(position.currentPrice),
                ),
              ),
              Expanded(
                child: _PositionMetric(
                  label: '%P/L',
                  value: _formatSignedPct(position.pnlPct),
                  valueColor: pnlColor,
                  alignRight: true,
                ),
              ),
            ],
          ),
          if (position.takeProfit != null || position.stopLoss != null) ...[
            const SizedBox(height: 11),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                if (position.takeProfit != null)
                  _RiskChip(
                    icon: Icons.my_location_rounded,
                    label: 'TP ${_formatMoney(position.takeProfit!)}',
                    color: AppColors.buy,
                  ),
                if (position.stopLoss != null)
                  _RiskChip(
                    icon: Icons.shield_outlined,
                    label: 'SL ${_formatMoney(position.stopLoss!)}',
                    color: AppColors.sell,
                  ),
                if (position.liquidPrice != null)
                  _RiskChip(
                    icon: Icons.warning_amber_rounded,
                    label: 'Liq ${_formatMoney(position.liquidPrice!)}',
                    color: AppColors.warn,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final TradePositionType type;

  @override
  Widget build(BuildContext context) {
    final color = switch (type) {
      TradePositionType.spot => _tradePrimary,
      TradePositionType.futures => _futuresColor,
      TradePositionType.margin => _marginColor,
    };
    final label = switch (type) {
      TradePositionType.spot => 'Spot',
      TradePositionType.futures => 'Futures',
      TradePositionType.margin => 'Margin',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _SideBadge extends StatelessWidget {
  const _SideBadge({required this.position});

  final TradeDashboardPosition position;

  @override
  Widget build(BuildContext context) {
    final isLong = position.side == TradePositionSide.long;
    final color = isLong ? AppColors.buy : AppColors.sell;
    final leverage = position.leverage == null ? '' : ' ${position.leverage}x';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        '${isLong ? 'LONG' : 'SHORT'}$leverage',
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _PositionMetric extends StatelessWidget {
  const _PositionMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.alignRight = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: valueColor,
            fontSize: 12,
            fontFamily: 'monospace',
            fontWeight: AppTextStyles.bold,
            height: 1,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _RiskChip extends StatelessWidget {
  const _RiskChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .07),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 10),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontSize: 10,
              fontFamily: 'monospace',
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPositions extends StatelessWidget {
  const _EmptyPositions();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: Column(
        children: [
          const Icon(
            Icons.bar_chart_rounded,
            color: AppColors.borderSolid,
            size: 44,
          ),
          const SizedBox(height: 12),
          Text(
            'Không có vị thế nào',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

String _formatSignedMoney(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign\$${_formatMoney(value.abs())}';
}

String _formatSignedPct(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign${value.abs().toStringAsFixed(2)}%';
}

String _formatCompactMoney(double value) {
  if (value.abs() >= 1000) {
    return '\$${(value / 1000).toStringAsFixed(1)}K';
  }
  return '\$${_formatMoney(value)}';
}

String _formatMoney(double value) {
  final raw = value.toStringAsFixed(2);
  final parts = raw.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '$buffer.${parts.last}';
}

String _formatAmount(double value) {
  if (value >= 1) return value.toStringAsFixed(4);
  return value.toStringAsFixed(6);
}
