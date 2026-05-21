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

const _venueBg = Color(0xFF080C14);
const _venueSurface = Color(0xFF151A23);
const _venueSurface2 = Color(0xFF1E2535);
const _venueBorder = Color(0xFF273142);
const _venueGreen = Color(0xFF10B981);
const _venueAmber = Color(0xFFF59E0B);
const _venueBlue = Color(0xFF3B82F6);

class ExecutionVenueAnalysisPage extends ConsumerStatefulWidget {
  const ExecutionVenueAnalysisPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc097_execution_venue_content');
  static Key tabKey(String id) => Key('sc097_execution_venue_tab_$id');
  static Key sortKey(String id) => Key('sc097_execution_venue_sort_$id');
  static Key venueKey(String venue) => Key('sc097_execution_venue_$venue');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ExecutionVenueAnalysisPage> createState() =>
      _ExecutionVenueAnalysisPageState();
}

class _ExecutionVenueAnalysisPageState
    extends ConsumerState<ExecutionVenueAnalysisPage> {
  String _tab = 'comparison';
  String _sort = 'volume';
  String? _notice;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeRepositoryProvider)
        .getExecutionVenueAnalysis();
    final venues = _sorted(snapshot.venues);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 118
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-097 ExecutionVenueAnalysisPage',
      child: Material(
        color: _venueBg,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: 'Execution Venue Analysis',
                  subtitle: 'Detailed Comparison',
                  showBack: true,
                  onBack: () =>
                      context.go(AppRoutePaths.tradeCopyBestExecutionReports),
                  trailing: IconButton(
                    onPressed: () =>
                        setState(() => _notice = 'Analysis export queued'),
                    icon: const Icon(Icons.download_rounded, size: 19),
                    color: AppColors.text1,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: ExecutionVenueAnalysisPage.contentKey,
                    padding: EdgeInsets.fromLTRB(20, 13, 20, bottomInset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SummaryGrid(summary: snapshot.summary),
                        const SizedBox(height: 25),
                        _SortSelector(
                          activeId: _sort,
                          onChanged: (id) => setState(() => _sort = id),
                        ),
                        const SizedBox(height: 25),
                        _Tabs(
                          activeId: _tab,
                          onChanged: (id) => setState(() => _tab = id),
                        ),
                        const SizedBox(height: 26),
                        if (_tab == 'comparison')
                          _ComparisonTab(venues: venues)
                        else if (_tab == 'costs')
                          _CostsTab(venues: venues)
                        else if (_tab == 'speed')
                          _SpeedTab(venues: venues)
                        else
                          _TrendsTab(trends: snapshot.costTrends),
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

  List<TradeExecutionVenueAnalysisMetric> _sorted(
    List<TradeExecutionVenueAnalysisMetric> venues,
  ) {
    final sorted = [...venues];
    switch (_sort) {
      case 'cost':
        sorted.sort((a, b) => a.totalCost.compareTo(b.totalCost));
      case 'speed':
        sorted.sort((a, b) => a.avgFillTime.compareTo(b.avgFillTime));
      case 'fill-rate':
        sorted.sort((a, b) => b.fillRate.compareTo(a.fillRate));
      default:
        sorted.sort((a, b) => b.volume.compareTo(a.volume));
    }
    return sorted;
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.summary});

  final TradeExecutionVenueAnalysisSummary summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'Total Venues',
            value: summary.totalVenues.toString(),
            subtitle: 'Active integrations',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'Avg Total Cost',
            value: '${summary.avgTotalCost.toStringAsFixed(2)} bps',
            subtitle: '-5% vs last quarter',
            subtitleColor: _venueGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'Avg Fill Time',
            value: '${summary.avgFillTime.toStringAsFixed(2)}s',
            subtitle: '-12% vs last quarter',
            subtitleColor: _venueGreen,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.subtitle,
    this.subtitleColor = AppColors.text3,
  });

  final String label;
  final String value;
  final String subtitle;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.fromLTRB(12, 13, 12, 12),
      decoration: BoxDecoration(
        color: _venueSurface,
        border: Border.all(color: _venueBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
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
          const SizedBox(height: 17),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontSize: 20,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: subtitleColor,
              fontSize: 9,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _SortSelector extends StatelessWidget {
  const _SortSelector({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const options = [
      ('volume', 'Volume'),
      ('cost', 'Lowest\nCost'),
      ('speed', 'Fastest'),
      ('fill-rate', 'Best Fill\nRate'),
    ];
    return Row(
      children: [
        const Icon(Icons.filter_alt_outlined, color: AppColors.text3, size: 17),
        const SizedBox(width: 8),
        SizedBox(
          width: 42,
          child: Text(
            'Sort\nby:',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1.15,
            ),
          ),
        ),
        const SizedBox(width: 6),
        for (final option in options) ...[
          Expanded(
            child: InkWell(
              key: ExecutionVenueAnalysisPage.sortKey(option.$1),
              onTap: () => onChanged(option.$1),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: activeId == option.$1 ? _venueBlue : _venueSurface2,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  option.$2,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: activeId == option.$1
                        ? Colors.white
                        : AppColors.text2,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1.15,
                  ),
                ),
              ),
            ),
          ),
          if (option != options.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      ('comparison', 'Comparison'),
      ('costs', 'Costs'),
      ('speed', 'Speed'),
      ('trends', 'Trends'),
    ];
    return Container(
      height: 52,
      color: _venueSurface,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: ExecutionVenueAnalysisPage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.$2,
                          style: AppTextStyles.caption.copyWith(
                            color: activeId == tab.$1
                                ? _venueBlue
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
                      color: _venueBlue,
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

class _ComparisonTab extends StatelessWidget {
  const _ComparisonTab({required this.venues});

  final List<TradeExecutionVenueAnalysisMetric> venues;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Venue Comparison'),
        const SizedBox(height: 12),
        for (var index = 0; index < venues.length; index++) ...[
          _VenueCard(venue: venues[index], rank: index + 1),
          if (index != venues.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _VenueCard extends StatelessWidget {
  const _VenueCard({required this.venue, required this.rank});

  final TradeExecutionVenueAnalysisMetric venue;
  final int rank;

  @override
  Widget build(BuildContext context) {
    final isWinner = rank == 1;
    return Container(
      key: ExecutionVenueAnalysisPage.venueKey(venue.venue),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _venueSurface,
        border: Border.all(color: _venueBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isWinner
                      ? _venueAmber.withValues(alpha: .15)
                      : _venueSurface2,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '#$rank',
                  style: AppTextStyles.caption.copyWith(
                    color: isWinner ? _venueAmber : AppColors.text2,
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      venue.venue,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontSize: 14,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_formatInt(venue.volume)} orders • ${_formatUsd(venue.value)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 10,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              if (isWinner)
                const Icon(
                  Icons.workspace_premium_outlined,
                  color: _venueAmber,
                  size: 16,
                ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Total Cost',
                  value: '${venue.totalCost.toStringAsFixed(2)} bps',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  label: 'Fill Time',
                  value: '${_formatSpeed(venue.avgFillTime)}s',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  label: 'Fill Rate',
                  value: '${venue.fillRate.toStringAsFixed(1)}%',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  label: 'Liquidity',
                  value: '\$${venue.liquidity}M',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 7),
      decoration: BoxDecoration(
        color: _venueSurface2,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 13,
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

class _CostsTab extends StatelessWidget {
  const _CostsTab({required this.venues});

  final List<TradeExecutionVenueAnalysisMetric> venues;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Cost Breakdown'),
        const SizedBox(height: 12),
        for (final venue in venues) ...[
          _CostCard(venue: venue),
          if (venue != venues.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _CostCard extends StatelessWidget {
  const _CostCard({required this.venue});

  final TradeExecutionVenueAnalysisMetric venue;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            venue.venue,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 14,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 12),
          _ProgressMetric(
            label: 'Trading Fee',
            value: '${venue.avgFee.toStringAsFixed(2)}%',
            factor: venue.avgFee / .12,
            color: _venueBlue,
          ),
          const SizedBox(height: 10),
          _ProgressMetric(
            label: 'Spread Cost',
            value: '${venue.avgSpread.toStringAsFixed(1)} bps',
            factor: venue.avgSpread / 3.2,
            color: _venueGreen,
          ),
          const SizedBox(height: 10),
          _ProgressMetric(
            label: 'Market Impact',
            value: '${venue.marketImpact.toStringAsFixed(1)} bps',
            factor: venue.marketImpact / 1.6,
            color: _venueAmber,
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: _venueBorder),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total Cost',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '${venue.totalCost.toStringAsFixed(2)} bps',
                style: AppTextStyles.caption.copyWith(
                  color: _venueBlue,
                  fontSize: 14,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpeedTab extends StatelessWidget {
  const _SpeedTab({required this.venues});

  final List<TradeExecutionVenueAnalysisMetric> venues;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Speed Metrics'),
        const SizedBox(height: 12),
        for (final venue in venues) ...[
          _Card(
            padding: const EdgeInsets.all(13),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        venue.venue,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 13,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.bolt_rounded,
                      color: venue.avgFillTime < .4 ? _venueGreen : _venueAmber,
                      size: 15,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_formatSpeed(venue.avgFillTime)}s',
                      style: AppTextStyles.caption.copyWith(
                        color: venue.avgFillTime < .4
                            ? _venueGreen
                            : _venueAmber,
                        fontSize: 14,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                Row(
                  children: [
                    Expanded(
                      child: _MetricBox(
                        label: 'Latency',
                        value: '${venue.avgLatency}ms',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MetricBox(
                        label: 'Reliability',
                        value: '${venue.reliability.toStringAsFixed(2)}%',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (venue != venues.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _TrendsTab extends StatelessWidget {
  const _TrendsTab({required this.trends});

  final List<TradeExecutionVenueCostTrend> trends;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Cost Trends (Last 3 Months)'),
        const SizedBox(height: 12),
        _Card(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              for (final trend in trends) ...[
                Row(
                  children: [
                    SizedBox(
                      width: 44,
                      child: Text(
                        trend.month,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          fontSize: 11,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _TrendBar(
                        value: trend.binance,
                        color: _venueAmber,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${trend.binance.toStringAsFixed(2)} bps',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                if (trend != trends.last) const SizedBox(height: 12),
              ],
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _venueGreen.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Overall costs trending down 5% over last 3 months',
                  style: AppTextStyles.caption.copyWith(
                    color: _venueGreen,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrendBar extends StatelessWidget {
  const _TrendBar({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 8,
        child: Stack(
          children: [
            const ColoredBox(color: _venueSurface2),
            FractionallySizedBox(
              widthFactor: (value / 5).clamp(0, 1).toDouble(),
              child: ColoredBox(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  const _ProgressMetric({
    required this.label,
    required this.value,
    required this.factor,
    required this.color,
  });

  final String label;
  final String value;
  final double factor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                ),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 11,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 6,
            child: Stack(
              children: [
                const ColoredBox(color: _venueSurface2),
                FractionallySizedBox(
                  widthFactor: factor.clamp(0, 1).toDouble(),
                  child: ColoredBox(color: color),
                ),
              ],
            ),
          ),
        ),
      ],
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
            color: _venueBlue,
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
        color: _venueSurface,
        border: Border.all(color: _venueBorder.withValues(alpha: .72)),
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
            color: _venueSurface2,
            border: Border.all(color: _venueBorder),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: _venueGreen,
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

String _formatSpeed(double value) {
  if (value == .3 || value == .4 || value == .5) {
    return value.toStringAsFixed(1);
  }
  return value.toStringAsFixed(2);
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

String _formatUsd(double value) {
  return '\$${_formatInt(value)}.00';
}
