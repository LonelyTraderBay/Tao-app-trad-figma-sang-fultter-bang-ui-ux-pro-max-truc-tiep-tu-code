import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/market_repository.dart';

const _marketPrimary = AppColors.primary;

enum _AlertFilter { all, active, triggered }

class PriceAlertsPage extends ConsumerStatefulWidget {
  const PriceAlertsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc014_price_alerts_scroll_content');
  static const allFilterKey = Key('sc014_filter_all');
  static const activeFilterKey = Key('sc014_filter_active');
  static const triggeredFilterKey = Key('sc014_filter_triggered');
  static const addAlertKey = Key('sc014_add_alert');
  static const totalCountKey = Key('sc014_total_count');
  static const activeCountKey = Key('sc014_active_count');
  static const triggeredCountKey = Key('sc014_triggered_count');

  static Key cardKey(String id) => Key('sc014_alert_card_$id');

  static Key toggleKey(String id) => Key('sc014_toggle_$id');

  static Key deleteKey(String id) => Key('sc014_delete_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PriceAlertsPage> createState() => _PriceAlertsPageState();
}

class _PriceAlertsPageState extends ConsumerState<PriceAlertsPage> {
  _AlertFilter _filter = _AlertFilter.all;
  late List<MarketPriceAlert> _alerts;
  bool _showAddNotice = false;

  @override
  void initState() {
    super.initState();
    _alerts = [
      ...ref.read(marketRepositoryProvider).getPriceAlerts().priceAlerts,
    ];
  }

  List<MarketPriceAlert> get _filteredAlerts {
    return switch (_filter) {
      _AlertFilter.active => [
        for (final alert in _alerts)
          if (alert.isActive) alert,
      ],
      _AlertFilter.triggered => [
        for (final alert in _alerts)
          if (!alert.isActive && alert.triggeredAt != null) alert,
      ],
      _AlertFilter.all => _alerts,
    };
  }

  void _toggleAlert(String id) {
    setState(() {
      _alerts = [
        for (final alert in _alerts)
          if (alert.id == id)
            MarketPriceAlert(
              id: alert.id,
              pairId: alert.pairId,
              symbol: alert.symbol,
              condition: alert.condition,
              targetPrice: alert.targetPrice,
              currentPrice: alert.currentPrice,
              isActive: !alert.isActive,
              createdAt: alert.createdAt,
              triggeredAt: alert.triggeredAt,
            )
          else
            alert,
      ];
    });
  }

  void _deleteAlert(String id) {
    setState(() {
      _alerts = _alerts.where((alert) => alert.id != id).toList();
    });
  }

  void _showAddPlaceholder() {
    setState(() => _showAddNotice = true);
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(marketRepositoryProvider).getPriceAlerts();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 48 : 20);
    final activeCount = _alerts.where((alert) => alert.isActive).length;
    final triggeredCount = _alerts
        .where((alert) => !alert.isActive && alert.triggeredAt != null)
        .length;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-014 PriceAlertsPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Cảnh báo giá',
              subtitle: 'Cảnh báo · Markets',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.markets),
            ),
            _FilterTabs(
              activeFilter: _filter,
              onFilterSelected: (value) => setState(() => _filter = value),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: PriceAlertsPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset),
                  child: Column(
                    children: [
                      _StatsSummary(
                        total: _alerts.length,
                        active: activeCount,
                        triggered: triggeredCount,
                      ),
                      const SizedBox(height: 13),
                      if (_filteredAlerts.isEmpty)
                        const _EmptyAlertsCard()
                      else
                        for (final alert in _filteredAlerts) ...[
                          _AlertCard(
                            alert: alert,
                            pair: _findPair(snapshot.marketPairs, alert.pairId),
                            onToggle: () => _toggleAlert(alert.id),
                            onDelete: () => _deleteAlert(alert.id),
                          ),
                          if (alert != _filteredAlerts.last)
                            const SizedBox(height: 12),
                        ],
                      const SizedBox(height: 28),
                      _AddAlertButton(onTap: _showAddPlaceholder),
                      if (_showAddNotice) ...[
                        const SizedBox(height: 10),
                        const _AddAlertNotice(),
                      ],
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

class _AddAlertNotice extends StatelessWidget {
  const _AddAlertNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface3,
        borderRadius: AppRadii.mdRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Text(
        'T\u1EA1o c\u1EA3nh b\u00E1o m\u1EDBi s\u1EBD \u0111\u01B0\u1EE3c b\u1ED5 sung sau',
        style: AppTextStyles.caption.copyWith(color: AppColors.text1),
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({
    required this.activeFilter,
    required this.onFilterSelected,
  });

  final _AlertFilter activeFilter;
  final ValueChanged<_AlertFilter> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 13, 20, 13),
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: _FilterTab(
                key: PriceAlertsPage.allFilterKey,
                label: 'Tất cả',
                active: activeFilter == _AlertFilter.all,
                onTap: () => onFilterSelected(_AlertFilter.all),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 15,
              child: _FilterTab(
                key: PriceAlertsPage.activeFilterKey,
                label: 'Đang hoạt động',
                active: activeFilter == _AlertFilter.active,
                onTap: () => onFilterSelected(_AlertFilter.active),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 14,
              child: _FilterTab(
                key: PriceAlertsPage.triggeredFilterKey,
                label: 'Đã kích hoạt',
                active: activeFilter == _AlertFilter.triggered,
                onTap: () => onFilterSelected(_AlertFilter.triggered),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  const _FilterTab({
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
      borderRadius: AppRadii.cardRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _marketPrimary.withValues(alpha: .16)
              : AppColors.surface,
          border: Border.all(
            color: active
                ? _marketPrimary.withValues(alpha: .48)
                : Colors.transparent,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? _marketPrimary : AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _StatsSummary extends StatelessWidget {
  const _StatsSummary({
    required this.total,
    required this.active,
    required this.triggered,
  });

  final int total;
  final int active;
  final int triggered;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            label: 'Tổng',
            value: '$total',
            valueKey: PriceAlertsPage.totalCountKey,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatBox(
            label: 'Hoạt động',
            value: '$active',
            valueColor: AppColors.buy,
            valueKey: PriceAlertsPage.activeCountKey,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatBox(
            label: 'Đã kích hoạt',
            value: '$triggered',
            valueColor: _marketPrimary,
            valueKey: PriceAlertsPage.triggeredCountKey,
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.valueKey,
  });

  final String label;
  final String value;
  final Color valueColor;
  final Key? valueKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface3,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
              height: 1,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            value,
            key: valueKey,
            style: AppTextStyles.sectionTitle.copyWith(
              color: valueColor,
              fontSize: 22,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.alert,
    required this.pair,
    required this.onToggle,
    required this.onDelete,
  });

  final MarketPriceAlert alert;
  final MarketPair? pair;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  bool get _isAbove => alert.condition == MarketAlertCondition.above;

  bool get _isTriggered => !alert.isActive && alert.triggeredAt != null;

  @override
  Widget build(BuildContext context) {
    final progress = (alert.currentPrice / alert.targetPrice).clamp(0.0, 1.0);
    final conditionColor = _isAbove ? AppColors.buy : AppColors.sell;

    return VitCard(
      key: PriceAlertsPage.cardKey(alert.id),
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
      borderColor: _isTriggered
          ? AppColors.buy.withValues(alpha: .24)
          : AppColors.cardBorder,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _isTriggered
              ? AppColors.buy.withValues(alpha: .04)
              : Colors.transparent,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Column(
          children: [
            Row(
              children: [
                _AssetAvatar(alert: alert, pair: pair),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert.symbol,
                        style: AppTextStyles.baseMedium.copyWith(
                          fontSize: 15,
                          fontWeight: AppTextStyles.bold,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            _isAbove
                                ? Icons.trending_up_rounded
                                : Icons.trending_down_rounded,
                            color: conditionColor,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${_isAbove ? 'Trên' : 'Dưới'} ${_formatUsd(alert.targetPrice)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption.copyWith(
                                color: conditionColor,
                                fontSize: 12,
                                fontWeight: AppTextStyles.bold,
                                fontFeatures: AppTextStyles.tabularFigures,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (_isTriggered)
                  const _TriggeredPill()
                else
                  InkWell(
                    key: PriceAlertsPage.toggleKey(alert.id),
                    onTap: onToggle,
                    borderRadius: AppRadii.cardRadius,
                    child: Icon(
                      alert.isActive
                          ? Icons.toggle_on_rounded
                          : Icons.toggle_off_rounded,
                      color: alert.isActive ? AppColors.buy : AppColors.text3,
                      size: 34,
                    ),
                  ),
                const SizedBox(width: 8),
                InkWell(
                  key: PriceAlertsPage.deleteKey(alert.id),
                  onTap: onDelete,
                  borderRadius: AppRadii.smRadius,
                  child: Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.sell10,
                      borderRadius: AppRadii.smRadius,
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.sell,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Giá hiện tại',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                              fontSize: 12,
                              height: 1,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _formatUsd(alert.currentPrice),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontSize: 12,
                              fontWeight: AppTextStyles.bold,
                              fontFeatures: AppTextStyles.tabularFigures,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 9),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: SizedBox(
                          height: 7,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              const ColoredBox(color: AppColors.surface3),
                              FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: progress,
                                child: ColoredBox(
                                  color: _progressColor(alert, progress),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 17),
                SizedBox(
                  width: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Mục tiêu',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatUsd(alert.targetPrice),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: conditionColor,
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_isTriggered) ...[
              const SizedBox(height: 13),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 11),
              Row(
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.buy,
                    size: 15,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      'Kích hoạt lúc 11:30:00 17/2/2024',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 12,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AssetAvatar extends StatelessWidget {
  const _AssetAvatar({required this.alert, required this.pair});

  final MarketPriceAlert alert;
  final MarketPair? pair;

  @override
  Widget build(BuildContext context) {
    final color = pair?.logoColor ?? _marketPrimary;
    final symbol = alert.symbol.split('/').first;
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        shape: BoxShape.circle,
      ),
      child: Text(
        symbol.length <= 3 ? symbol : symbol.substring(0, 3),
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontSize: 12,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _TriggeredPill extends StatelessWidget {
  const _TriggeredPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.buy10,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Text(
        'Đã kích hoạt',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.buy,
          fontSize: 12,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _EmptyAlertsCard extends StatelessWidget {
  const _EmptyAlertsCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 18),
      child: Column(
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.text3,
            size: 34,
          ),
          const SizedBox(height: 10),
          Text(
            'Chưa có cảnh báo nào',
            style: AppTextStyles.body.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _AddAlertButton extends StatelessWidget {
  const _AddAlertButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: PriceAlertsPage.addAlertKey,
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: AppSpacing.buttonStandard,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _marketPrimary.withValues(alpha: .13),
          border: Border.all(color: _marketPrimary.withValues(alpha: .30)),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_rounded, color: _marketPrimary, size: 18),
            const SizedBox(width: 8),
            Text(
              'Tạo cảnh báo mới',
              style: AppTextStyles.body.copyWith(
                color: _marketPrimary,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

MarketPair? _findPair(List<MarketPair> pairs, String id) {
  for (final pair in pairs) {
    if (pair.id == id) return pair;
  }
  return null;
}

Color _progressColor(MarketPriceAlert alert, double progress) {
  if (alert.condition == MarketAlertCondition.above) {
    return progress >= 1 ? AppColors.buy : _marketPrimary;
  }
  return AppColors.sell;
}

String _formatUsd(double value) {
  final fractionDigits = value >= 100
      ? 2
      : value >= 1
      ? 2
      : 4;
  final fixed = value.toStringAsFixed(fractionDigits);
  final parts = fixed.split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    final remaining = integer.length - i;
    buffer.write(integer[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return '\$${buffer.toString()}.${parts.last}';
}
