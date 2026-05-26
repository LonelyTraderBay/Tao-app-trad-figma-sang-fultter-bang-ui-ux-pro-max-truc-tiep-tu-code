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
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';

const _copyPrimary = AppColors.primary;
const _copyPanel = AppColors.surface;
const _copyPanel2 = AppColors.surface2;
const _copySegmentBackground = AppColors.surface3;
const _lightBuyBackground = Color(0xFFEFFDF5);
const _lightSellBackground = Color(0xFFFFF1F1);
const _lightWarnBackground = Color(0xFFFFF7E8);

class ActiveCopiesPage extends ConsumerStatefulWidget {
  const ActiveCopiesPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc066_active_copies_scroll_content');
  static const addCopyKey = Key('sc066_add_copy');
  static const stopConfirmInputKey = Key('sc066_stop_confirm_input');
  static const stopConfirmButtonKey = Key('sc066_stop_confirm_button');

  static Key tabKey(String id) => Key('sc066_tab_$id');
  static Key copyKey(String id) => Key('sc066_copy_$id');
  static Key expandKey(String id) => Key('sc066_expand_$id');
  static Key detailsKey(String id) => Key('sc066_details_$id');
  static Key configureKey(String id) => Key('sc066_configure_$id');
  static Key stopKey(String id) => Key('sc066_stop_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ActiveCopiesPage> createState() => _ActiveCopiesPageState();
}

class _ActiveCopiesPageState extends ConsumerState<ActiveCopiesPage> {
  String _activeTab = 'all';
  String? _expandedCopyId;
  TradeActiveCopy? _pendingStopCopy;
  String _confirmText = '';
  String? _actionStatus;

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(tradeRepositoryProvider);
    final snapshot = repository.getActiveCopies();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 104 : 28);
    final copies = _filteredCopies(snapshot.copies);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-066 ActiveCopiesPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: 'Copy đang chạy',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
                  trailing: _HeaderAddButton(
                    onTap: () => context.go(AppRoutePaths.tradeCopyTrading),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: ActiveCopiesPage.contentKey,
                    padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _PortfolioOverview(snapshot: snapshot.portfolio),
                        const SizedBox(height: 26),
                        _SegmentedTabs(
                          tabs: snapshot.tabs,
                          activeTab: _activeTab,
                          onChanged: (id) => setState(() {
                            _activeTab = id;
                            _expandedCopyId = null;
                          }),
                        ),
                        const SizedBox(height: 24),
                        if (copies.isEmpty)
                          _EmptyCopiesState(
                            history: _activeTab == 'history',
                            onExplore: () =>
                                context.go(AppRoutePaths.tradeCopyTrading),
                          )
                        else
                          for (final copy in copies) ...[
                            _ActiveCopyCard(
                              key: ActiveCopiesPage.copyKey(copy.id),
                              copy: copy,
                              expanded: _expandedCopyId == copy.id,
                              onToggle: () => setState(() {
                                _expandedCopyId = _expandedCopyId == copy.id
                                    ? null
                                    : copy.id;
                              }),
                              onViewDetails: () => context.go(
                                AppRoutePaths.tradeCopyProvider(
                                  copy.providerId,
                                  backPath: AppRoutePaths.tradeCopyActive,
                                ),
                              ),
                              onConfigure: () => context.go(
                                AppRoutePaths.tradeCopyProviderConfiguration(
                                  copy.providerId,
                                  backPath: AppRoutePaths.tradeCopyActive,
                                ),
                              ),
                              onStop:
                                  copy.status ==
                                      TradeActiveCopyStatus.coolingOff
                                  ? null
                                  : () => setState(() {
                                      _pendingStopCopy = copy;
                                      _confirmText = '';
                                    }),
                            ),
                            if (copy != copies.last) const SizedBox(height: 12),
                          ],
                        if (_actionStatus != null) ...[
                          const SizedBox(height: 14),
                          _ActionStatusBanner(text: _actionStatus!),
                        ],
                        if (_hasRiskAlert(snapshot.copies)) ...[
                          const SizedBox(height: 14),
                          _RiskAlert(
                            onViewDetails: () =>
                                setState(() => _activeTab = 'active'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_pendingStopCopy != null)
              _StopCopyModal(
                copy: _pendingStopCopy!,
                confirmText: _confirmText,
                onTextChanged: (value) => setState(() => _confirmText = value),
                onCancel: () => setState(() => _pendingStopCopy = null),
                onConfirm: () {
                  final result = repository.submitCopyTradingAction(
                    TradeCopyActionRequest(
                      providerId: _pendingStopCopy!.providerId,
                      action: 'stop',
                    ),
                  );
                  setState(() {
                    _actionStatus =
                        'Yêu cầu ${result.action} ${result.providerId} đã được ghi nhận';
                    _pendingStopCopy = null;
                    _confirmText = '';
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  List<TradeActiveCopy> _filteredCopies(List<TradeActiveCopy> copies) {
    return switch (_activeTab) {
      'active' =>
        copies
            .where(
              (copy) =>
                  copy.status == TradeActiveCopyStatus.active ||
                  copy.status == TradeActiveCopyStatus.coolingOff,
            )
            .toList(),
      'paused' =>
        copies
            .where((copy) => copy.status == TradeActiveCopyStatus.paused)
            .toList(),
      'history' =>
        copies
            .where((copy) => copy.status == TradeActiveCopyStatus.stopped)
            .toList(),
      _ => copies,
    };
  }

  bool _hasRiskAlert(List<TradeActiveCopy> copies) {
    return copies.any(
      (copy) => copy.status == TradeActiveCopyStatus.active && copy.pnlPct < -5,
    );
  }
}

class _HeaderAddButton extends StatelessWidget {
  const _HeaderAddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ActiveCopiesPage.addCopyKey,
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: _copySegmentBackground,
          border: Border.all(color: AppColors.cardBorder),
          borderRadius: AppRadii.smRadius,
        ),
        child: const Icon(Icons.add_rounded, color: AppColors.text1, size: 22),
      ),
    );
  }
}

class _PortfolioOverview extends StatelessWidget {
  const _PortfolioOverview({required this.snapshot});

  final TradeActiveCopyPortfolio snapshot;

  @override
  Widget build(BuildContext context) {
    final positive = snapshot.totalPnl >= 0;
    final color = positive ? AppColors.buy : AppColors.sell;
    final bg = positive ? _lightBuyBackground : _lightSellBackground;
    final labelColor = positive ? AppColors.buy20 : const Color(0xFF991B1B);

    return Container(
      height: 194,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _copyPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tổng quan portfolio',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontSize: 16,
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
                  ),
                ),
              ),
              Text(
                '${snapshot.activeCopies} active',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              Expanded(
                child: _PortfolioMetric(
                  label: 'Vốn đầu tư',
                  value: _formatUsd(snapshot.totalCapital),
                ),
              ),
              Expanded(
                child: _PortfolioMetric(
                  label: 'Giá trị hiện tại',
                  value: _formatUsd(snapshot.totalValue),
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            height: 62,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: bg,
              border: Border.all(color: color),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              children: [
                Icon(
                  positive
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  color: color,
                  size: 17,
                ),
                const SizedBox(width: 7),
                Text(
                  'P/L tổng',
                  style: AppTextStyles.micro.copyWith(
                    color: labelColor,
                    fontSize: 11,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatSignedUsd(snapshot.totalPnl),
                      style: AppTextStyles.caption.copyWith(
                        color: color,
                        fontSize: 16,
                        fontWeight: AppTextStyles.bold,
                        height: 1.1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatPercent(snapshot.totalPnlPct),
                      style: AppTextStyles.micro.copyWith(
                        color: labelColor,
                        fontSize: 11,
                        height: 1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PortfolioMetric extends StatelessWidget {
  const _PortfolioMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 11,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            fontSize: 18,
            fontWeight: AppTextStyles.bold,
            height: 1.15,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({
    required this.tabs,
    required this.activeTab,
    required this.onChanged,
  });

  final List<TradeActiveCopiesTab> tabs;
  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _copySegmentBackground,
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: _SegmentedTabButton(
                tab: tab,
                active: activeTab == tab.id,
                onTap: () => onChanged(tab.id),
              ),
            ),
        ],
      ),
    );
  }
}

class _SegmentedTabButton extends StatelessWidget {
  const _SegmentedTabButton({
    required this.tab,
    required this.active,
    required this.onTap,
  });

  final TradeActiveCopiesTab tab;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ActiveCopiesPage.tabKey(tab.id),
      onTap: onTap,
      borderRadius: AppRadii.lgRadius,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? _copyPrimary : Colors.transparent,
          borderRadius: AppRadii.lgRadius,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            tab.label,
            style: AppTextStyles.caption.copyWith(
              color: active ? Colors.white : AppColors.text3,
              fontSize: 13,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiveCopyCard extends StatelessWidget {
  const _ActiveCopyCard({
    super.key,
    required this.copy,
    required this.expanded,
    required this.onToggle,
    required this.onViewDetails,
    required this.onConfigure,
    required this.onStop,
  });

  final TradeActiveCopy copy;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onViewDetails;
  final VoidCallback onConfigure;
  final VoidCallback? onStop;

  @override
  Widget build(BuildContext context) {
    final status = _statusStyle(copy.status);
    final positive = copy.pnl >= 0;
    final pnlColor = positive ? AppColors.buy : AppColors.sell;
    final pnlBg = positive ? _lightBuyBackground : _lightSellBackground;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _copyPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProviderAvatar(copy: copy),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            copy.providerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontSize: 15,
                              fontWeight: AppTextStyles.bold,
                              height: 1.2,
                            ),
                          ),
                        ),
                        if (copy.providerVerified) ...[
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.check_circle_rounded,
                            color: _copyPrimary,
                            size: 12,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        _StatusPill(style: status),
                        if (copy.coolingOffUntil != null) ...[
                          const SizedBox(width: 7),
                          Flexible(
                            child: Text(
                              'đến ${copy.coolingOffUntil}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                                fontSize: 10,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                key: ActiveCopiesPage.expandKey(copy.id),
                onTap: onToggle,
                borderRadius: AppRadii.cardRadius,
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text3,
                    size: 19,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MiniValueCard(
                  label: 'Vốn',
                  value: _formatUsd(copy.capital),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MiniValueCard(
                  label: 'Hiện tại',
                  value: _formatUsd(copy.currentValue),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MiniValueCard(
                  label: 'P/L',
                  value: _formatSignedUsd(copy.pnl),
                  valueColor: pnlColor,
                  background: pnlBg,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          _ReturnBar(value: copy.pnlPct),
          if (expanded) ...[
            const SizedBox(height: 16),
            _ExpandedCopyDetails(
              copy: copy,
              onViewDetails: onViewDetails,
              onConfigure: onConfigure,
              onStop: onStop,
            ),
          ],
        ],
      ),
    );
  }
}

class _ProviderAvatar extends StatelessWidget {
  const _ProviderAvatar({required this.copy});

  final TradeActiveCopy copy;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _copyPrimary.withValues(alpha: .08),
        shape: BoxShape.circle,
        border: Border.all(color: _copyPrimary, width: 2),
      ),
      child: Text(
        copy.providerAvatar,
        style: AppTextStyles.baseMedium.copyWith(
          color: _copyPrimary,
          fontSize: 17,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.style});

  final _StatusStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        style.label,
        style: AppTextStyles.micro.copyWith(
          color: style.color,
          fontSize: 11,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _MiniValueCard extends StatelessWidget {
  const _MiniValueCard({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.background = _copyPanel2,
  });

  final String label;
  final String value;
  final Color valueColor;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: valueColor,
                fontSize: 13,
                fontWeight: AppTextStyles.bold,
                height: 1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReturnBar extends StatelessWidget {
  const _ReturnBar({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final color = value >= 0 ? AppColors.buy : AppColors.sell;
    final widthFactor = (value.abs() * .05).clamp(.0, 1.0).toDouble();

    return Container(
      height: 41,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _copyPanel2,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Return',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  height: 1,
                ),
              ),
              const Spacer(),
              Text(
                _formatPercent(value),
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: widthFactor,
              backgroundColor: AppColors.borderSolid,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandedCopyDetails extends StatelessWidget {
  const _ExpandedCopyDetails({
    required this.copy,
    required this.onViewDetails,
    required this.onConfigure,
    required this.onStop,
  });

  final TradeActiveCopy copy;
  final VoidCallback onViewDetails;
  final VoidCallback onConfigure;
  final VoidCallback? onStop;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Performance (30 ngày)',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
                fontWeight: AppTextStyles.medium,
              ),
            ),
            const SizedBox(height: 8),
            _MiniPerformanceStrip(points: copy.performanceHistory),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _DetailStat(
                    label: 'Số lượng trades',
                    value: '${copy.trades}',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _DetailStat(
                    label: 'Win rate',
                    value: '${copy.winRate.toStringAsFixed(1)}%',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _DetailStat(
                    label: 'Copy mode',
                    value: _copyModeLabel(copy),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _DetailStat(
                    label: 'Stop-loss',
                    value: copy.hasCustomStopLoss
                        ? '-${copy.stopLossLevel?.toStringAsFixed(0)}%'
                        : 'Provider',
                  ),
                ),
              ],
            ),
            if (copy.recentTrades.isNotEmpty) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Trades gần đây',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontSize: 11,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  InkWell(
                    key: ActiveCopiesPage.detailsKey(copy.id),
                    onTap: onViewDetails,
                    child: Text(
                      'Xem tất cả',
                      style: AppTextStyles.micro.copyWith(
                        color: _copyPrimary,
                        fontSize: 11,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              for (final trade in copy.recentTrades.take(3)) ...[
                _RecentTradeRow(trade: trade),
                if (trade != copy.recentTrades.take(3).last)
                  const SizedBox(height: 7),
              ],
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    key: ActiveCopiesPage.configureKey(copy.id),
                    label: 'Điều chỉnh',
                    icon: Icons.settings_rounded,
                    onTap: onConfigure,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ActionButton(
                    key: ActiveCopiesPage.stopKey(copy.id),
                    label: 'Dừng copy',
                    icon: Icons.stop_rounded,
                    danger: true,
                    onTap: onStop,
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

class _MiniPerformanceStrip extends StatelessWidget {
  const _MiniPerformanceStrip({required this.points});

  final List<TradeCopyPerformancePoint> points;

  @override
  Widget build(BuildContext context) {
    final first = points.isEmpty ? 0.0 : points.first.value;
    final last = points.isEmpty ? 0.0 : points.last.value;
    final positive = last >= first;
    final color = positive ? AppColors.buy : AppColors.sell;

    return Container(
      height: 54,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _copyPanel2,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < points.length; i++) ...[
            Expanded(
              child: FractionallySizedBox(
                alignment: Alignment.bottomCenter,
                heightFactor: _barHeight(points, i),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .72),
                    borderRadius: AppRadii.xsRadius,
                  ),
                ),
              ),
            ),
            if (i < points.length - 1) const SizedBox(width: 5),
          ],
        ],
      ),
    );
  }

  double _barHeight(List<TradeCopyPerformancePoint> points, int index) {
    if (points.isEmpty) return .2;
    final min = points
        .map((point) => point.value)
        .reduce((a, b) => a < b ? a : b);
    final max = points
        .map((point) => point.value)
        .reduce((a, b) => a > b ? a : b);
    final spread = max - min;
    if (spread <= 0) return .28;
    return (.24 + ((points[index].value - min) / spread) * .76)
        .clamp(.24, 1.0)
        .toDouble();
  }
}

class _DetailStat extends StatelessWidget {
  const _DetailStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _copyPanel2,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 13,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentTradeRow extends StatelessWidget {
  const _RecentTradeRow({required this.trade});

  final TradeCopyRecentTrade trade;

  @override
  Widget build(BuildContext context) {
    final sideColor = trade.side == TradeOrderSide.buy
        ? AppColors.buy
        : AppColors.sell;

    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: _copyPanel2,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: sideColor,
              borderRadius: AppRadii.xsRadius,
            ),
            child: Text(
              trade.side == TradeOrderSide.buy ? 'BUY' : 'SELL',
              style: AppTextStyles.micro.copyWith(
                color: Colors.white,
                fontSize: 9,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              trade.pair,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontSize: 11,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ),
          Text(
            _formatSignedUsd(trade.pnl),
            style: AppTextStyles.micro.copyWith(
              color: trade.pnl >= 0 ? AppColors.buy : AppColors.sell,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.danger = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.sell : AppColors.text1;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Opacity(
        opacity: onTap == null ? .5 : 1,
        child: Container(
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: danger ? AppColors.sell10 : _copyPanel2,
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 15),
              const SizedBox(width: 7),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCopiesState extends StatelessWidget {
  const _EmptyCopiesState({required this.history, required this.onExplore});

  final bool history;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 40),
      decoration: BoxDecoration(
        color: _copyPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Icon(
            history ? Icons.history_rounded : Icons.groups_rounded,
            color: AppColors.text3,
            size: 34,
          ),
          const SizedBox(height: 12),
          Text(
            history ? 'Chưa có lịch sử copy' : 'Chưa có copy nào đang chạy',
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              fontSize: 16,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            history
                ? 'Lịch sử copy sẽ hiển thị ở đây.'
                : 'Bắt đầu copy từ trader chuyên nghiệp để tự động hóa giao dịch của bạn.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
              height: 1.45,
            ),
          ),
          if (!history) ...[
            const SizedBox(height: 18),
            InkWell(
              onTap: onExplore,
              borderRadius: AppRadii.inputRadius,
              child: Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _copyPrimary,
                  borderRadius: AppRadii.inputRadius,
                ),
                child: Text(
                  'Khám phá traders',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RiskAlert extends StatelessWidget {
  const _RiskAlert({required this.onViewDetails});

  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        border: Border.all(color: AppColors.warningBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warningText,
            size: 19,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cảnh báo rủi ro',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.warningText,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Một copy đang lỗ >5%. Xem xét dừng copy hoặc điều chỉnh stop-loss.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.warningText,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: onViewDetails,
                  child: Text(
                    'Xem chi tiết',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.warningText,
                      fontSize: 11,
                      fontWeight: AppTextStyles.bold,
                      decoration: TextDecoration.underline,
                    ),
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

class _ActionStatusBanner extends StatelessWidget {
  const _ActionStatusBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.buy10,
        border: Border.all(color: AppColors.buy20),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Text(
        text,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.buy,
          fontSize: 11,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _StopCopyModal extends StatelessWidget {
  const _StopCopyModal({
    required this.copy,
    required this.confirmText,
    required this.onTextChanged,
    required this.onCancel,
    required this.onConfirm,
  });

  final TradeActiveCopy copy;
  final String confirmText;
  final ValueChanged<String> onTextChanged;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final canConfirm = confirmText.toLowerCase() == 'stop';

    return Positioned.fill(
      child: Material(
        color: Colors.black.withValues(alpha: .54),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              24 + MediaQuery.paddingOf(context).bottom,
            ),
            decoration: const BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.sell10,
                        borderRadius: AppRadii.inputRadius,
                      ),
                      child: const Icon(
                        Icons.stop_rounded,
                        color: AppColors.sell,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dừng copy?',
                            style: AppTextStyles.baseMedium.copyWith(
                              fontSize: 16,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          Text(
                            copy.providerName,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.sell10,
                    border: Border.all(color: AppColors.sell20),
                    borderRadius: AppRadii.inputRadius,
                  ),
                  child: Text(
                    'Cảnh báo: khi dừng copy, các vị thế đang mở có thể được đóng. Hành động này cần xác nhận rõ ràng.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.sell,
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Nhập STOP để xác nhận',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  key: ActiveCopiesPage.stopConfirmInputKey,
                  onChanged: onTextChanged,
                  style: AppTextStyles.body,
                  decoration: InputDecoration(
                    hintText: 'STOP',
                    hintStyle: AppTextStyles.body.copyWith(
                      color: AppColors.text3,
                    ),
                    filled: true,
                    fillColor: AppColors.surface2,
                    border: OutlineInputBorder(
                      borderRadius: AppRadii.inputRadius,
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadii.inputRadius,
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppRadii.inputRadius,
                      borderSide: const BorderSide(color: _copyPrimary),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _SheetButton(label: 'Hủy', onTap: onCancel),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _SheetButton(
                        key: ActiveCopiesPage.stopConfirmButtonKey,
                        label: 'Dừng copy',
                        onTap: canConfirm ? onConfirm : null,
                        danger: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  const _SheetButton({
    super.key,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Opacity(
        opacity: onTap == null ? .45 : 1,
        child: Container(
          height: AppSpacing.inputHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: danger ? AppColors.sell : AppColors.surface2,
            borderRadius: AppRadii.inputRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

final class _StatusStyle {
  const _StatusStyle({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;
}

_StatusStyle _statusStyle(TradeActiveCopyStatus status) {
  return switch (status) {
    TradeActiveCopyStatus.active => const _StatusStyle(
      label: 'Đang chạy',
      color: AppColors.buy,
      background: _lightBuyBackground,
    ),
    TradeActiveCopyStatus.coolingOff => const _StatusStyle(
      label: 'Chờ kích hoạt',
      color: Color(0xFFF59E0B),
      background: _lightWarnBackground,
    ),
    TradeActiveCopyStatus.paused => const _StatusStyle(
      label: 'Tạm dừng',
      color: AppColors.text3,
      background: Color(0xFFF3F4F6),
    ),
    TradeActiveCopyStatus.stopped => const _StatusStyle(
      label: 'Đã dừng',
      color: AppColors.sell,
      background: _lightSellBackground,
    ),
  };
}

String _copyModeLabel(TradeActiveCopy copy) {
  return switch (copy.copyMode) {
    TradeActiveCopyMode.mirror => 'Mirror',
    TradeActiveCopyMode.fixed => 'Fixed ${copy.copyRatio?.toStringAsFixed(0)}%',
    TradeActiveCopyMode.smart => 'Smart',
  };
}

String _formatUsd(double value) {
  return '\$${value.toStringAsFixed(0)}';
}

String _formatSignedUsd(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign${_formatUsd(value.abs())}';
}

String _formatPercent(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign${value.abs().toStringAsFixed(2)}%';
}
