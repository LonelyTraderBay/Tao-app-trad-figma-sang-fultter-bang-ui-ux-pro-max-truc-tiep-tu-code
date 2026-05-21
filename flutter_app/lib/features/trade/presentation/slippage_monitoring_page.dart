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

const _slipBg = Color(0xFF080C14);
const _slipSurface = Color(0xFF151A23);
const _slipSurface2 = Color(0xFF1E2535);
const _slipBorder = Color(0xFF273142);
const _slipGreen = Color(0xFF10B981);
const _slipAmber = Color(0xFFF59E0B);
const _slipRed = Color(0xFFEF4444);
const _slipBlue = Color(0xFF3B82F6);

class SlippageMonitoringPage extends ConsumerStatefulWidget {
  const SlippageMonitoringPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc098_slippage_content');
  static Key tabKey(String id) => Key('sc098_slippage_tab_$id');
  static Key eventKey(String id) => Key('sc098_slippage_event_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SlippageMonitoringPage> createState() =>
      _SlippageMonitoringPageState();
}

class _SlippageMonitoringPageState
    extends ConsumerState<SlippageMonitoringPage> {
  String _tab = 'realtime';
  String? _notice;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeRepositoryProvider).getSlippageMonitoring();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 118
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-098 SlippageMonitoringPage',
      child: Material(
        color: _slipBg,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: 'Slippage Monitoring',
                  subtitle: 'Real-time Tracking · Alerts',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
                  trailing: IconButton(
                    onPressed: () =>
                        setState(() => _notice = 'Alert settings opened'),
                    icon: const Icon(Icons.settings_outlined, size: 19),
                    color: AppColors.text1,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: SlippageMonitoringPage.contentKey,
                    padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _CriticalAlert(summary: snapshot.summary),
                        const SizedBox(height: 22),
                        _StatsGrid(summary: snapshot.summary),
                        const SizedBox(height: 24),
                        _Tabs(
                          activeId: _tab,
                          summary: snapshot.summary,
                          onChanged: (id) => setState(() => _tab = id),
                        ),
                        const SizedBox(height: 26),
                        if (_tab == 'realtime')
                          _RealtimeTab(events: snapshot.events)
                        else if (_tab == 'providers')
                          _ProvidersTab(providers: snapshot.providers)
                        else if (_tab == 'history')
                          _HistoryTab(history: snapshot.history)
                        else
                          const _AlertsTab(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_notice != null)
              _NoticePanel(
                text: _notice!,
                onClose: () => setState(() => _notice = null),
              ),
          ],
        ),
      ),
    );
  }
}

class _CriticalAlert extends StatelessWidget {
  const _CriticalAlert({required this.summary});

  final TradeSlippageSummary summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.text1,
            size: 17,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${summary.critical} Critical Slippage Event Detected',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Slippage exceeded 1% threshold. Review affected trades and consider provider adjustments.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                    height: 1.4,
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

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.summary});

  final TradeSlippageSummary summary;

  @override
  Widget build(BuildContext context) {
    final cards = [
      (
        Icons.monitor_heart_outlined,
        _slipBlue,
        'Total\nEvents',
        summary.total.toString(),
        'Last 24h',
        AppColors.text3,
      ),
      (
        Icons.track_changes_outlined,
        _slipGreen,
        'Avg\nSlippage',
        '${summary.avgSlippage.toStringAsFixed(1)}\nbps',
        '0.405%',
        AppColors.text3,
      ),
      (
        Icons.trending_up_rounded,
        _slipAmber,
        'Max\nSlippage',
        '${summary.maxSlippage.toStringAsFixed(1)}\nbps',
        '1.18%',
        _slipRed,
      ),
      (
        Icons.warning_amber_rounded,
        _slipRed,
        'Critical',
        summary.critical.toString(),
        '${summary.warning} warning',
        _slipRed,
      ),
    ];

    return Row(
      children: [
        for (final card in cards) ...[
          Expanded(child: _StatCard(card: card)),
          if (card != cards.last) const SizedBox(width: 12),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.card});

  final (IconData, Color, String, String, String, Color) card;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.fromLTRB(10, 13, 10, 11),
      decoration: BoxDecoration(
        color: _slipSurface,
        border: Border.all(color: _slipBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(card.$1, color: card.$2, size: 15),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  card.$3,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 9,
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 52,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  card.$4,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontSize: 19,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                    height: 1.22,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            card.$5,
            style: AppTextStyles.micro.copyWith(
              color: card.$6,
              fontSize: 9,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({
    required this.activeId,
    required this.summary,
    required this.onChanged,
  });

  final String activeId;
  final TradeSlippageSummary summary;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ('realtime', 'Real-time (${summary.total})'),
      ('providers', 'By Provider'),
      ('history', 'History'),
      ('alerts', 'Alerts (${summary.critical + summary.warning})'),
    ];
    return Container(
      height: 53,
      color: _slipSurface,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: SlippageMonitoringPage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: activeId == tab.$1
                                ? _slipBlue
                                : AppColors.text3,
                            fontSize: 12,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: activeId == tab.$1 ? 72 : 0,
                      height: 2,
                      color: _slipBlue,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RealtimeTab extends StatelessWidget {
  const _RealtimeTab({required this.events});

  final List<TradeSlippageEvent> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Recent Slippage Events'),
        const SizedBox(height: 12),
        for (final event in events) ...[
          _SlippageEventCard(event: event),
          if (event != events.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _SlippageEventCard extends StatelessWidget {
  const _SlippageEventCard({required this.event});

  final TradeSlippageEvent event;

  @override
  Widget build(BuildContext context) {
    final style = _severityStyle(event.severity);
    return Container(
      key: SlippageMonitoringPage.eventKey(event.id),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _slipSurface,
        border: Border.all(color: _slipBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: style.color.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(style.icon, color: style.color, size: 19),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  event.instrument,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.text1,
                                    fontSize: 13,
                                    fontWeight: AppTextStyles.bold,
                                    height: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _SidePill(side: event.side),
                            ],
                          ),
                          const SizedBox(height: 9),
                          Text(
                            '${event.provider} · ${event.time}',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              fontSize: 10,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _SeverityPill(style: style),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _EventMetric(
                        label: 'Expected',
                        value: _formatPrice(event.expectedPrice),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _EventMetric(
                        label: 'Executed',
                        value: _formatPrice(event.executedPrice),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _EventMetric(
                        label: 'Slippage',
                        value: '${event.slippagePct.toStringAsFixed(3)}%',
                        color: style.color,
                        background: style.color.withValues(alpha: .13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: _slipSurface2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Cost Impact:',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Text(
                        '\$${((event.executedPrice - event.expectedPrice).abs() * event.volume).toStringAsFixed(2)}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text1,
                          fontSize: 11,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
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

class _EventMetric extends StatelessWidget {
  const _EventMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text2,
    this.background = _slipSurface2,
  });

  final String label;
  final String value;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProvidersTab extends StatelessWidget {
  const _ProvidersTab({required this.providers});

  final List<TradeSlippageProviderStats> providers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Provider Performance'),
        const SizedBox(height: 12),
        for (final provider in providers) ...[
          _Card(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        provider.provider,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 14,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${provider.avgSlippage.toStringAsFixed(1)} bps',
                      style: AppTextStyles.body.copyWith(
                        color: provider.criticalCount > 0
                            ? _slipRed
                            : _slipGreen,
                        fontSize: 16,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _EventMetric(
                        label: 'Events',
                        value: provider.eventCount.toString(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _EventMetric(
                        label: 'Max Slippage',
                        value: '${provider.maxSlippage.toStringAsFixed(1)} bps',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _EventMetric(
                        label: 'Cost Impact',
                        value: '\$${_formatInt(provider.totalImpact)}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (provider != providers.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({required this.history});

  final List<TradeSlippageHistoryPoint> history;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Slippage Trends (Last 7 Days)'),
        const SizedBox(height: 12),
        _Card(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              for (final point in history) ...[
                Row(
                  children: [
                    SizedBox(
                      width: 46,
                      child: Text(
                        point.date,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: SizedBox(
                          height: 8,
                          child: Stack(
                            children: [
                              const ColoredBox(color: _slipSurface2),
                              FractionallySizedBox(
                                widthFactor: (point.max / 120)
                                    .clamp(0, 1)
                                    .toDouble(),
                                child: const ColoredBox(color: _slipRed),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${point.max.toStringAsFixed(1)} bps',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                if (point != history.last) const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _AlertsTab extends StatelessWidget {
  const _AlertsTab();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel('Alert Configuration'),
        SizedBox(height: 12),
        _AlertSetting(
          title: 'Critical Slippage Alert',
          subtitle: 'Notify when slippage exceeds 1%',
          value: 'Current Threshold: 100 bps (1.0%)',
          enabled: true,
        ),
        SizedBox(height: 12),
        _AlertSetting(
          title: 'Warning Slippage Alert',
          subtitle: 'Notify when slippage exceeds 0.5%',
          value: 'Current Threshold: 50 bps (0.5%)',
          enabled: true,
        ),
        SizedBox(height: 12),
        _AlertSetting(
          title: 'Daily Summary Email',
          subtitle: 'Receive daily slippage report at 9:00 AM',
          value: 'Disabled',
          enabled: false,
        ),
      ],
    );
  }
}

class _AlertSetting extends StatelessWidget {
  const _AlertSetting({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.enabled,
  });

  final String title;
  final String subtitle;
  final String value;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontSize: 13,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              _SwitchVisual(enabled: enabled),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _slipSurface2,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidePill extends StatelessWidget {
  const _SidePill({required this.side});

  final String side;

  @override
  Widget build(BuildContext context) {
    final buy = side == 'buy';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: (buy ? _slipGreen : _slipRed).withValues(alpha: .14),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        side.toUpperCase(),
        style: AppTextStyles.micro.copyWith(
          color: buy ? _slipGreen : _slipRed,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _SeverityPill extends StatelessWidget {
  const _SeverityPill({required this.style});

  final _SeverityStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: .13),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        style.label,
        style: AppTextStyles.micro.copyWith(
          color: style.color,
          fontSize: 10,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _SwitchVisual extends StatelessWidget {
  const _SwitchVisual({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 24,
      decoration: BoxDecoration(
        color: enabled ? _slipBlue : _slipSurface2,
        borderRadius: BorderRadius.circular(999),
      ),
      alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.all(4),
      child: const DecoratedBox(
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: SizedBox(width: 16, height: 16),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: _slipBlue,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _slipSurface,
        border: Border.all(color: _slipBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

class _NoticePanel extends StatelessWidget {
  const _NoticePanel({required this.text, required this.onClose});

  final String text;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      right: 20,
      top: MediaQuery.paddingOf(context).top + 18,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 9, 8, 9),
          decoration: BoxDecoration(
            color: _slipSurface2,
            border: Border.all(color: _slipBorder),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: _slipGreen,
                size: 18,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded, size: 18),
                color: AppColors.text3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SeverityStyle {
  const _SeverityStyle({
    required this.color,
    required this.label,
    required this.icon,
  });

  final Color color;
  final String label;
  final IconData icon;
}

_SeverityStyle _severityStyle(String severity) {
  return switch (severity) {
    'critical' => const _SeverityStyle(
      color: _slipRed,
      label: 'Critical',
      icon: Icons.cancel_outlined,
    ),
    'warning' => const _SeverityStyle(
      color: _slipAmber,
      label: 'Warning',
      icon: Icons.warning_amber_rounded,
    ),
    _ => const _SeverityStyle(
      color: _slipGreen,
      label: 'Normal',
      icon: Icons.check_circle_outline,
    ),
  };
}

String _formatPrice(double value) {
  if (value < 1000 && value != value.roundToDouble()) {
    return '\$${value.toStringAsFixed(1)}';
  }
  return '\$${_formatInt(value)}';
}

String _formatInt(num value) {
  final text = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final indexFromEnd = text.length - i;
    buffer.write(text[i]);
    if (indexFromEnd > 1 && indexFromEnd % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}
