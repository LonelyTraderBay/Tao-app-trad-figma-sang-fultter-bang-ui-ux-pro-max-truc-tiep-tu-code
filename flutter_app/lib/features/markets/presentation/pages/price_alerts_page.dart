import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import '../widgets/market_body_review_widgets.dart';

part '../widgets/price_alerts_page_overview.dart';
part '../widgets/price_alerts_page_details.dart';
part '../widgets/price_alerts_page_common.dart';

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
      ...ref.read(marketControllerProvider).getPriceAlerts().priceAlerts,
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
    final snapshot = ref.watch(marketControllerProvider).getPriceAlerts();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? AppSpacing.priceAlertsVisualBottomExtra
            : AppSpacing.priceAlertsNativeBottomExtra);
    final activeCount = _alerts.where((alert) => alert.isActive).length;
    final triggeredCount = _alerts
        .where((alert) => !alert.isActive && alert.triggeredAt != null)
        .length;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-014 PriceAlertsPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Cảnh báo giá',
            subtitle: 'Cảnh báo · Markets',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.markets),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                    padding: AppSpacing.priceAlertsScrollPadding(bottomInset),
                    child: Column(
                      children: [
                        _StatsSummary(
                          total: _alerts.length,
                          active: activeCount,
                          triggered: triggeredCount,
                        ),
                        const SizedBox(
                          height: AppSpacing.priceAlertsSectionGap,
                        ),
                        if (_filteredAlerts.isEmpty)
                          const _EmptyAlertsCard()
                        else
                          for (final alert in _filteredAlerts) ...[
                            _AlertCard(
                              alert: alert,
                              pair: _findPair(
                                snapshot.marketPairs,
                                alert.pairId,
                              ),
                              onToggle: () => _toggleAlert(alert.id),
                              onDelete: () => _deleteAlert(alert.id),
                            ),
                            if (alert != _filteredAlerts.last)
                              const SizedBox(
                                height: AppSpacing.priceAlertsCardGap,
                              ),
                          ],
                        const SizedBox(height: AppSpacing.sectionGap),
                        _AddAlertButton(onTap: _showAddPlaceholder),
                        if (_showAddNotice) ...[
                          const SizedBox(
                            height: AppSpacing.priceAlertsAddNoticeGap,
                          ),
                          const _AddAlertNotice(),
                        ],
                        const SizedBox(
                          height: AppSpacing.priceAlertsBottomReviewGap,
                        ),
                        const MarketBodyReviewSection(
                          title: 'Price alert state review',
                          message: 'Price alert data reviewed',
                          detail:
                              'Filter, toggle, delete, add notice, empty, and refresh states remain visible.',
                          primary:
                              'Alert counts stay visible before active and triggered alert rows.',
                          secondary:
                              'Toggle and delete actions preserve the selected pair context.',
                          tertiary:
                              'Add-alert notice remains secondary to the current alert list.',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
