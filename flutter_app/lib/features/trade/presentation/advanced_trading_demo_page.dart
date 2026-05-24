import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/trade_repository.dart';

const _advancedGreen = Color(0xFF10B981);
const _advancedRed = Color(0xFFEF4444);
const _advancedPrimary = AppColors.primary;

class AdvancedTradingDemoPage extends ConsumerStatefulWidget {
  const AdvancedTradingDemoPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc088_advanced_trading_demo_content');
  static Key tabKey(String id) => Key('sc088_advanced_tab_$id');
  static Key modeKey(String id) => Key('sc088_position_mode_$id');
  static Key actionKey(String id) => Key('sc088_action_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AdvancedTradingDemoPage> createState() =>
      _AdvancedTradingDemoPageState();
}

class _AdvancedTradingDemoPageState
    extends ConsumerState<AdvancedTradingDemoPage> {
  String _tab = 'position';
  String _positionMode = 'one-way';
  String? _activeSheetTitle;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeRepositoryProvider)
        .getAdvancedTradingDemo();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 104 : 28);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-088 AdvancedTradingDemoPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: 'Advanced Trading',
                  subtitle: 'Position & Order Controls',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.tradeMargin),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: AdvancedTradingDemoPage.contentKey,
                    padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _PositionModeCard(
                          activeMode: _positionMode,
                          onChanged: (mode) =>
                              setState(() => _positionMode = mode),
                        ),
                        const SizedBox(height: 18),
                        _UnderlineTabs(
                          activeId: _tab,
                          onChanged: (id) => setState(() => _tab = id),
                        ),
                        const SizedBox(height: 16),
                        if (_tab == 'position')
                          _PositionTab(
                            snapshot: snapshot,
                            onAction: (action) => setState(
                              () => _activeSheetTitle = action.label,
                            ),
                          )
                        else if (_tab == 'orders')
                          _OrdersTab(snapshot: snapshot)
                        else
                          _AnalyticsTab(snapshot: snapshot),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_activeSheetTitle != null)
              _DemoSheet(
                title: _activeSheetTitle!,
                onClose: () => setState(() => _activeSheetTitle = null),
              ),
          ],
        ),
      ),
    );
  }
}

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
                  color: Colors.white,
                  fontSize: 14,
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
          Container(
            height: 44,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: AppRadii.cardRadius,
            ),
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
              fontSize: 10,
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
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: AppRadii.mdRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: active ? Colors.white : AppColors.text3,
              fontSize: 12,
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
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
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
                            : Colors.transparent,
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
                      fontSize: 11,
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
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: AppTextStyles.bold,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                'Professional tools để quản lý vị thế hiệu quả',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontSize: 12,
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
    return InkWell(
      key: AdvancedTradingDemoPage.actionKey(action.id),
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        constraints: const BoxConstraints(minHeight: 46),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          border: Border.all(color: AppColors.borderSolid),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          action.label,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontSize: 13,
            fontWeight: AppTextStyles.bold,
            height: 1.25,
          ),
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
              fontSize: 12,
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
                  fontSize: 12,
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
                  fontSize: 12,
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

class _AnalyticsTab extends StatelessWidget {
  const _AnalyticsTab({required this.snapshot});

  final TradeAdvancedTradingDemoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MetricsCard(title: 'PnL Summary', metrics: snapshot.pnlSummary),
        const SizedBox(height: 14),
        _MetricsCard(
          title: 'Performance Stats',
          metrics: snapshot.performanceMetrics,
        ),
      ],
    );
  }
}

class _MetricsCard extends StatelessWidget {
  const _MetricsCard({required this.title, required this.metrics});

  final String title;
  final List<TradeAdvancedDemoMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: Colors.white,
              fontSize: 14,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 12),
          for (final metric in metrics) ...[
            _ValueRow(
              label: metric.label,
              value: metric.value,
              tone: metric.tone,
            ),
            if (metric != metrics.last) const SizedBox(height: 9),
          ],
        ],
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.surface2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: active ? Colors.white : AppColors.text2,
          fontSize: 12,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({
    required this.label,
    required this.value,
    this.tone = TradeAdvancedMetricTone.neutral,
  });

  final String label;
  final String value;
  final TradeAdvancedMetricTone tone;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
              height: 1,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: _toneColor(tone),
            fontSize: 13,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

class _DemoSheet extends StatelessWidget {
  const _DemoSheet({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Color(0x99000000)),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              bottom:
                  DeviceMetrics.nativeBottomChrome +
                  MediaQuery.paddingOf(context).bottom +
                  24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.baseMedium.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Demo control state only. Backend execution stays in draft mode for SC-088.',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: onClose,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: const Size.fromHeight(44),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadii.inputRadius,
                          ),
                        ),
                        child: Text(
                          'Đóng',
                          style: AppTextStyles.body.copyWith(
                            color: Colors.white,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Color _toneColor(TradeAdvancedMetricTone tone) {
  return switch (tone) {
    TradeAdvancedMetricTone.positive => _advancedGreen,
    TradeAdvancedMetricTone.negative => _advancedRed,
    TradeAdvancedMetricTone.warning => AppColors.warn,
    TradeAdvancedMetricTone.accent => _advancedPrimary,
    TradeAdvancedMetricTone.neutral => AppColors.text1,
  };
}
