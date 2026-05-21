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
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/predictions_repository.dart';

const _predictionBlue = Color(0xFF3B82F6);

class PredictionsGlobalActivityPage extends ConsumerStatefulWidget {
  const PredictionsGlobalActivityPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc034_predictions_activity_content');
  static const allFilterKey = Key('sc034_filter_all');
  static const amount100FilterKey = Key('sc034_filter_100');
  static const amount500FilterKey = Key('sc034_filter_500');

  static Key activityKey(String id) => Key('sc034_activity_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionsGlobalActivityPage> createState() =>
      _PredictionsGlobalActivityPageState();
}

class _PredictionsGlobalActivityPageState
    extends ConsumerState<PredictionsGlobalActivityPage> {
  double _minAmount = 0;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(predictionsRepositoryProvider)
        .getGlobalActivity(minAmount: _minAmount);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-034 PredictionsGlobalActivityPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Global Activity',
              subtitle: 'Hoạt động · Prediction',
              showBack: true,
              onBack: () =>
                  context.go(AppRoutePaths.marketsPredictionEvent('pred-1')),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: PredictionsGlobalActivityPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 16,
                    children: [
                      _LiveStats(snapshot: snapshot),
                      _AmountFilters(
                        active: _minAmount,
                        onSelected: (value) => setState(() {
                          _minAmount = value;
                        }),
                      ),
                      if (snapshot.activities.isEmpty)
                        const VitEmptyState(
                          title: 'No activity found',
                          message: 'Lower the minimum amount filter',
                          icon: Icons.timeline_rounded,
                        )
                      else
                        _ActivityList(snapshot: snapshot),
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

class _LiveStats extends StatelessWidget {
  const _LiveStats({required this.snapshot});

  final PredictionGlobalActivitySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.settings_input_antenna_rounded,
                    color: AppColors.buy,
                    size: 15,
                  ),
                  Positioned(
                    right: -1,
                    top: -1,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.buy,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Text(
                'Live Feed',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Real-time market activity',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  label: 'Volume (1h)',
                  value: _formatVolume(snapshot.totalVolume),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatBox(
                  label: 'Buys',
                  value: '${snapshot.buyCount}',
                  valueColor: AppColors.buy,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatBox(
                  label: 'Sells',
                  value: '${snapshot.sellCount}',
                  valueColor: AppColors.sell,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountFilters extends StatelessWidget {
  const _AmountFilters({required this.active, required this.onSelected});

  final double active;
  final ValueChanged<double> onSelected;

  @override
  Widget build(BuildContext context) {
    const filters = [
      (label: 'All', value: 0.0),
      (label: '\$50+', value: 50.0),
      (label: '\$100+', value: 100.0),
      (label: '\$500+', value: 500.0),
      (label: '\$1K+', value: 1000.0),
    ];

    return Row(
      children: [
        const Icon(Icons.filter_alt_outlined, color: AppColors.text3, size: 13),
        const SizedBox(width: 8),
        Text(
          'Min amount:',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontSize: 11,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final filter in filters) ...[
                  _AmountChip(
                    key: _amountFilterKey(filter.value),
                    label: filter.label,
                    active: active == filter.value,
                    onTap: () => onSelected(filter.value),
                  ),
                  const SizedBox(width: 6),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({
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
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _predictionBlue.withValues(alpha: .14)
              : AppColors.surface2,
          border: Border.all(
            color: active
                ? _predictionBlue.withValues(alpha: .4)
                : Colors.transparent,
          ),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: active ? _predictionBlue : AppColors.text3,
            fontSize: 11,
            fontWeight: active ? AppTextStyles.bold : AppTextStyles.normal,
          ),
        ),
      ),
    );
  }
}

class _ActivityList extends StatelessWidget {
  const _ActivityList({required this.snapshot});

  final PredictionGlobalActivitySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < snapshot.activities.length; index += 1)
          _ActivityRow(
            key: PredictionsGlobalActivityPage.activityKey(
              snapshot.activities[index].id,
            ),
            activity: snapshot.activities[index],
            event: snapshot.eventFor(snapshot.activities[index].eventId),
            last: index == snapshot.activities.length - 1,
          ),
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    super.key,
    required this.activity,
    required this.event,
    required this.last,
  });

  final PredictionGlobalActivityDraft activity;
  final PredictionEventDraft event;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final isBuy = activity.action == PredictionGlobalActivityAction.bought;
    final sideColor = isBuy ? AppColors.buy : AppColors.sell;
    return InkWell(
      onTap: () => context.go(AppRoutePaths.marketsPredictionEvent(event.id)),
      child: Container(
        constraints: const BoxConstraints(minHeight: 78),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: last
              ? null
              : const Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFF1C2438),
                shape: BoxShape.circle,
              ),
              child: Text(
                activity.avatar,
                style: const TextStyle(fontSize: 17),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 5,
                    runSpacing: 3,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        activity.user,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        isBuy ? 'bought' : 'sold',
                        style: AppTextStyles.caption.copyWith(
                          color: sideColor,
                          fontSize: 12,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      _OutcomeBadge(
                        label: activity.outcome,
                        color: activity.outcome == 'Yes'
                            ? AppColors.buy
                            : AppColors.sell,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${_formatWhole(activity.shares)} shares @ \$${activity.price.toStringAsFixed(2)}',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontSize: 10,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 58,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatAmount(activity.amount),
                    textAlign: TextAlign.right,
                    style: AppTextStyles.caption.copyWith(
                      color: sideColor,
                      fontSize: 12,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activity.timestamp,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutcomeBadge extends StatelessWidget {
  const _OutcomeBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          height: 1,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

Key _amountFilterKey(double value) {
  if (value == 0) return PredictionsGlobalActivityPage.allFilterKey;
  if (value == 100) return PredictionsGlobalActivityPage.amount100FilterKey;
  if (value == 500) return PredictionsGlobalActivityPage.amount500FilterKey;
  return Key('sc034_filter_${value.toInt()}');
}

String _formatVolume(double value) {
  if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(0)}K';
  return '\$${value.toStringAsFixed(0)}';
}

String _formatAmount(double value) {
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(1)}K';
  return '\$${value.toStringAsFixed(0)}';
}

String _formatWhole(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i += 1) {
    final fromEnd = text.length - i;
    buffer.write(text[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}
