import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/earn/data/earn_repository.dart';

TextStyle get _captionBold =>
    AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.bold);
TextStyle get _microBold =>
    AppTextStyles.micro.copyWith(fontWeight: AppTextStyles.bold);

class SavingsSmartSuggestionsPage extends ConsumerStatefulWidget {
  const SavingsSmartSuggestionsPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc347_summary');
  static const suggestionsListKey = Key('sc347_suggestions_list');
  static const trendsListKey = Key('sc347_trends_list');
  static const signalsListKey = Key('sc347_signals_list');

  static Key filterKey(String id) => Key('sc347_filter_$id');
  static Key suggestionKey(String id) => Key('sc347_suggestion_$id');
  static Key actionKey(String id) => Key('sc347_action_$id');
  static Key helpfulKey(String id) => Key('sc347_helpful_$id');
  static Key dismissKey(String id) => Key('sc347_dismiss_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsSmartSuggestionsPage> createState() =>
      _SavingsSmartSuggestionsPageState();
}

class _SavingsSmartSuggestionsPageState
    extends ConsumerState<SavingsSmartSuggestionsPage> {
  String? _tab;
  String _filter = 'all';
  final Set<String> _dismissed = {};
  final Set<String> _helpful = {};

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(savingsSmartSuggestionsRepositoryProvider)
        .getSuggestions();
    final activeTab = _tab ?? snapshot.defaultTab;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-347 SavingsSmartSuggestionsPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _SmartSummary(snapshot: snapshot),
                    _SmartTabs(
                      tabs: snapshot.tabs,
                      active: activeTab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _tab = tab);
                      },
                    ),
                    if (activeTab == 'suggestions') ...[
                      _PriorityFilters(
                        filters: snapshot.filters,
                        active: _filter,
                        onChanged: (filter) {
                          HapticFeedback.selectionClick();
                          setState(() => _filter = filter);
                        },
                      ),
                      _SuggestionList(
                        suggestions: _filteredSuggestions(snapshot),
                        helpful: _helpful,
                        onHelpful: _markHelpful,
                        onDismiss: _dismissSuggestion,
                      ),
                      _Disclaimer(text: snapshot.disclaimer),
                    ] else if (activeTab == 'trends')
                      _TrendList(trends: snapshot.trends)
                    else
                      _SignalList(signals: snapshot.signals),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<SavingsSuggestionDraft> _filteredSuggestions(
    SavingsSmartSuggestionsSnapshot snapshot,
  ) {
    final active = snapshot.suggestions.where(
      (suggestion) => !_dismissed.contains(suggestion.id),
    );
    if (_filter == 'all') return active.toList();

    return active
        .where((suggestion) => suggestion.priority.name == _filter)
        .toList();
  }

  void _markHelpful(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_helpful.contains(id)) {
        _helpful.remove(id);
      } else {
        _helpful.add(id);
      }
    });
  }

  void _dismissSuggestion(String id) {
    HapticFeedback.selectionClick();
    setState(() => _dismissed.add(id));
  }
}

class _SmartSummary extends StatelessWidget {
  const _SmartSummary({required this.snapshot});

  final SavingsSmartSuggestionsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsSmartSuggestionsPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.warn,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  snapshot.heroLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.base.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gợi ý chưa xử lý',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    Text(
                      '${snapshot.pendingCount}',
                      style: AppTextStyles.heroNumber.copyWith(fontSize: 32),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Tiềm năng APY tăng',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  Text(
                    snapshot.potentialApyGainLabel,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.buy,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Ưu tiên cao',
                  value: '${snapshot.highPriorityCount}',
                  valueColor: AppColors.sell,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SummaryMetric(
                  label: 'Xu hướng',
                  value: '${snapshot.upTrendCount} tăng',
                  icon: Icons.trending_up_rounded,
                  valueColor: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SummaryMetric(
                  label: 'Tín hiệu',
                  value: '${snapshot.signalCount}',
                  valueColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    this.icon,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: valueColor, size: AppSpacing.iconSm),
                const SizedBox(width: AppSpacing.x1),
              ],
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _captionBold.copyWith(
                    color: valueColor,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmartTabs extends StatelessWidget {
  const _SmartTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<SavingsPreferenceTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.underline,
      activeKey: active,
      onChanged: onChanged,
      tabs: [for (final tab in tabs) VitTabItem(key: tab.id, label: tab.label)],
    );
  }
}

class _PriorityFilters extends StatelessWidget {
  const _PriorityFilters({
    required this.filters,
    required this.active,
    required this.onChanged,
  });

  final List<SavingsPreferenceTabDraft> filters;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (final filter in filters) ...[
            _FilterChip(
              key: SavingsSmartSuggestionsPage.filterKey(filter.id),
              label: filter.label,
              active: filter.id == active,
              tone: _filterTone(filter.id),
              onTap: () => onChanged(filter.id),
            ),
            if (filter != filters.last) const SizedBox(width: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    super.key,
    required this.label,
    required this.active,
    required this.tone,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? tone.withValues(alpha: .12) : AppColors.surface2,
      borderRadius: AppRadii.xlRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.xlRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: active
                  ? tone.withValues(alpha: .45)
                  : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.xlRadius,
          ),
          child: Text(
            label,
            style: _captionBold.copyWith(
              color: active ? tone : AppColors.text2,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({
    required this.suggestions,
    required this.helpful,
    required this.onHelpful,
    required this.onDismiss,
  });

  final List<SavingsSuggestionDraft> suggestions;
  final Set<String> helpful;
  final ValueChanged<String> onHelpful;
  final ValueChanged<String> onDismiss;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsSmartSuggestionsPage.suggestionsListKey,
      children: [
        for (final suggestion in suggestions) ...[
          _SuggestionCard(
            suggestion: suggestion,
            helpful: helpful.contains(suggestion.id),
            onHelpful: () => onHelpful(suggestion.id),
            onDismiss: () => onDismiss(suggestion.id),
          ),
          if (suggestion != suggestions.last)
            const SizedBox(height: AppSpacing.x4),
        ],
      ],
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({
    required this.suggestion,
    required this.helpful,
    required this.onHelpful,
    required this.onDismiss,
  });

  final SavingsSuggestionDraft suggestion;
  final bool helpful;
  final VoidCallback onHelpful;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final typeColor = _typeColor(suggestion.type);
    final priorityColor = _priorityColor(suggestion.priority);
    final confidenceColor = _confidenceColor(suggestion.confidence);

    return VitCard(
      key: SavingsSmartSuggestionsPage.suggestionKey(suggestion.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SuggestionIcon(type: suggestion.type, color: typeColor),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _MetaPill(
                          label: suggestion.typeLabel,
                          color: typeColor,
                        ),
                        _MetaPill(
                          label: suggestion.priorityLabel,
                          color: priorityColor,
                        ),
                        if (suggestion.status ==
                            SavingsSuggestionStatus.newItem)
                          const _NewDot(),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      suggestion.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: _captionBold.copyWith(color: AppColors.text1),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Icon(
                suggestion.impactPositive
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                color: suggestion.impactPositive
                    ? AppColors.buy
                    : AppColors.sell,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  suggestion.impact,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _captionBold.copyWith(
                    color: suggestion.impactPositive
                        ? AppColors.buy
                        : AppColors.sell,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _ConfidenceBar(value: suggestion.confidence, color: confidenceColor),
          const SizedBox(height: AppSpacing.x3),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  suggestion.createdAt,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              if (suggestion.actionRoute != null)
                _SmallActionButton(
                  key: SavingsSmartSuggestionsPage.actionKey(suggestion.id),
                  icon: Icons.arrow_forward_rounded,
                  color: AppColors.primary,
                  onTap: () => context.go(suggestion.actionRoute!),
                ),
              const SizedBox(width: AppSpacing.x2),
              _SmallActionButton(
                key: SavingsSmartSuggestionsPage.dismissKey(suggestion.id),
                icon: Icons.thumb_down_alt_outlined,
                color: AppColors.sell,
                onTap: onDismiss,
              ),
              const SizedBox(width: AppSpacing.x2),
              _SmallActionButton(
                key: SavingsSmartSuggestionsPage.helpfulKey(suggestion.id),
                icon: helpful
                    ? Icons.thumb_up_alt_rounded
                    : Icons.thumb_up_alt_outlined,
                color: AppColors.buy,
                onTap: onHelpful,
              ),
              const SizedBox(width: AppSpacing.x2),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConfidenceBar extends StatelessWidget {
  const _ConfidenceBar({required this.value, required this.color});

  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: AppRadii.xlRadius,
            child: LinearProgressIndicator(
              value: value / 100,
              minHeight: AppSpacing.x1,
              color: color,
              backgroundColor: AppColors.borderSolid,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          '$value%',
          style: _microBold.copyWith(
            color: color,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _SuggestionIcon extends StatelessWidget {
  const _SuggestionIcon({required this.type, required this.color});

  final SavingsSuggestionType type;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.xlRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x6,
        height: AppSpacing.x6,
        child: Icon(_typeIcon(type), color: color, size: AppSpacing.iconMd),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _NewDot extends StatelessWidget {
  const _NewDot();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: AppSpacing.x1),
      child: Icon(Icons.circle, color: AppColors.sell, size: AppSpacing.x2),
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  const _SmallActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .12),
      borderRadius: AppRadii.xlRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.xlRadius,
        child: SizedBox(
          width: AppSpacing.buttonCompact,
          height: AppSpacing.buttonCompact,
          child: Icon(icon, color: color, size: AppSpacing.iconSm),
        ),
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      borderColor: AppColors.warn15,
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendList extends StatelessWidget {
  const _TrendList({required this.trends});

  final List<SavingsApyTrendDraft> trends;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsSmartSuggestionsPage.trendsListKey,
      children: [
        for (final trend in trends) ...[
          _TrendCard(trend: trend),
          if (trend != trends.last) const SizedBox(height: AppSpacing.x4),
        ],
      ],
    );
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard({required this.trend});

  final SavingsApyTrendDraft trend;

  @override
  Widget build(BuildContext context) {
    final color = _trendColor(trend.direction);

    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _SuggestionIcon(
                type: trend.direction == SavingsApyTrendDirection.down
                    ? SavingsSuggestionType.riskAlert
                    : SavingsSuggestionType.dcaTiming,
                color: color,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trend.product, style: _captionBold),
                    Text(
                      '${trend.asset} · hiện tại ${trend.currentApyLabel}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _MetaPill(label: _trendLabel(trend.direction), color: color),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: AppSpacing.buttonHero,
            child: CustomPaint(
              painter: _TrendSparklinePainter(
                points: trend.points,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _TrendMetric(
                  label: 'Trung bình',
                  value: trend.averageApyLabel,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _TrendMetric(
                  label: 'Dự báo',
                  value: trend.predictionLabel,
                  valueColor: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendMetric extends StatelessWidget {
  const _TrendMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          Text(value, style: _captionBold.copyWith(color: valueColor)),
        ],
      ),
    );
  }
}

class _SignalList extends StatelessWidget {
  const _SignalList({required this.signals});

  final List<SavingsMarketSignalDraft> signals;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsSmartSuggestionsPage.signalsListKey,
      children: [
        for (final signal in signals) ...[
          _SignalCard(signal: signal),
          if (signal != signals.last) const SizedBox(height: AppSpacing.x4),
        ],
      ],
    );
  }
}

class _SignalCard extends StatelessWidget {
  const _SignalCard({required this.signal});

  final SavingsMarketSignalDraft signal;

  @override
  Widget build(BuildContext context) {
    final color = _signalColor(signal.type);

    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SuggestionIcon(
                type: signal.type == SavingsMarketSignalType.bearish
                    ? SavingsSuggestionType.riskAlert
                    : SavingsSuggestionType.newOpportunity,
                color: color,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(signal.title, style: _captionBold),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      signal.timestamp,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            signal.impact,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final product in signal.affectedProducts)
                _MetaPill(label: product, color: color),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendSparklinePainter extends CustomPainter {
  const _TrendSparklinePainter({required this.points, required this.color});

  final List<SavingsApyTrendPointDraft> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final minValue = points
        .map((point) => point.apy)
        .reduce((value, element) => value < element ? value : element);
    final maxValue = points
        .map((point) => point.apy)
        .reduce((value, element) => value > element ? value : element);
    final range = (maxValue - minValue).abs() < .01 ? 1 : maxValue - minValue;
    final path = Path();

    for (var i = 0; i < points.length; i++) {
      final x = size.width * (i / (points.length - 1));
      final y =
          size.height - ((points[i].apy - minValue) / range) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final grid = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    for (var i = 1; i <= 2; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrendSparklinePainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}

Color _filterTone(String id) {
  return switch (id) {
    'high' => AppColors.sell,
    'medium' => AppColors.warn,
    'low' => AppColors.primary,
    _ => AppColors.primary,
  };
}

Color _priorityColor(SavingsSuggestionPriority priority) {
  return switch (priority) {
    SavingsSuggestionPriority.high => AppColors.sell,
    SavingsSuggestionPriority.medium => AppColors.warn,
    SavingsSuggestionPriority.low => AppColors.primary,
  };
}

Color _typeColor(SavingsSuggestionType type) {
  return switch (type) {
    SavingsSuggestionType.dcaTiming => AppColors.buy,
    SavingsSuggestionType.productSwitch => AppColors.primary,
    SavingsSuggestionType.rebalance => AppColors.accent,
    SavingsSuggestionType.newOpportunity => AppColors.warn,
    SavingsSuggestionType.riskAlert => AppColors.sell,
    SavingsSuggestionType.compoundBoost => AppColors.accent,
  };
}

IconData _typeIcon(SavingsSuggestionType type) {
  return switch (type) {
    SavingsSuggestionType.dcaTiming => Icons.repeat_rounded,
    SavingsSuggestionType.productSwitch => Icons.swap_horiz_rounded,
    SavingsSuggestionType.rebalance => Icons.sync_rounded,
    SavingsSuggestionType.newOpportunity => Icons.auto_awesome_rounded,
    SavingsSuggestionType.riskAlert => Icons.warning_amber_rounded,
    SavingsSuggestionType.compoundBoost => Icons.bolt_rounded,
  };
}

Color _confidenceColor(int value) {
  if (value >= 80) return AppColors.buy;
  if (value >= 60) return AppColors.warn;
  return AppColors.sell;
}

Color _trendColor(SavingsApyTrendDirection direction) {
  return switch (direction) {
    SavingsApyTrendDirection.up => AppColors.buy,
    SavingsApyTrendDirection.down => AppColors.sell,
    SavingsApyTrendDirection.stable => AppColors.primary,
  };
}

String _trendLabel(SavingsApyTrendDirection direction) {
  return switch (direction) {
    SavingsApyTrendDirection.up => 'Tăng',
    SavingsApyTrendDirection.down => 'Giảm',
    SavingsApyTrendDirection.stable => 'Ổn định',
  };
}

Color _signalColor(SavingsMarketSignalType type) {
  return switch (type) {
    SavingsMarketSignalType.bullish => AppColors.buy,
    SavingsMarketSignalType.bearish => AppColors.sell,
    SavingsMarketSignalType.neutral => AppColors.primary,
  };
}
