import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

class P2PLimitTrackerPage extends ConsumerStatefulWidget {
  const P2PLimitTrackerPage({super.key, this.shellRenderMode});

  static const periodTabsKey = Key('sc265_p2p_limit_period_tabs');
  static const usageHeroKey = Key('sc265_p2p_limit_usage_hero');
  static const progressKey = Key('sc265_p2p_limit_progress');
  static const historyKey = Key('sc265_p2p_limit_history');

  static Key periodKey(String period) => Key('sc265_p2p_limit_period_$period');

  static Key dayKey(String date) => Key('sc265_p2p_limit_day_$date');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PLimitTrackerPage> createState() =>
      _P2PLimitTrackerPageState();
}

class _P2PLimitTrackerPageState extends ConsumerState<P2PLimitTrackerPage> {
  String _period = 'daily';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pLimitTrackerProvider);
    final usage = snapshot.usageFor(_period);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-265 P2PLimitTrackerPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.contentPad,
                      AppSpacing.x4,
                      AppSpacing.contentPad,
                      bottomInset,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _PeriodTabs(
                          usages: snapshot.usages,
                          selectedPeriod: _period,
                          onChanged: (period) {
                            HapticFeedback.selectionClick();
                            setState(() => _period = period);
                          },
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        _UsageHero(usage: usage),
                        const SizedBox(height: AppSpacing.x5),
                        _LimitBreakdownList(items: snapshot.breakdown),
                        const SizedBox(height: AppSpacing.x3),
                        const VitCard(
                          variant: VitCardVariant.inner,
                          padding: EdgeInsets.all(AppSpacing.x3),
                          child: VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'P2P limit review',
                            message:
                                'Selected period, used volume, remaining limit, history breakdown and next limit-management step are reviewed before more P2P activity.',
                            contractId: 'p2p-limit-tracker-review',
                          ),
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

class _PeriodTabs extends StatelessWidget {
  const _PeriodTabs({
    required this.usages,
    required this.selectedPeriod,
    required this.onChanged,
  });

  final List<P2PLimitUsageDraft> usages;
  final String selectedPeriod;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: P2PLimitTrackerPage.periodTabsKey,
      children: [
        for (var index = 0; index < usages.length; index++) ...[
          Expanded(
            child: _PeriodTab(
              usage: usages[index],
              selected: selectedPeriod == usages[index].period,
              onTap: () => onChanged(usages[index].period),
            ),
          ),
          if (index != usages.length - 1) const SizedBox(width: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _PeriodTab extends StatelessWidget {
  const _PeriodTab({
    required this.usage,
    required this.selected,
    required this.onTap,
  });

  final P2PLimitUsageDraft usage;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PLimitTrackerPage.periodKey(usage.period),
      color: selected ? AppModuleAccents.p2p : AppColors.surface2,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.buttonCompact,
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x2),
          child: Text(
            usage.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: selected ? AppColors.onAccent : AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _UsageHero extends StatelessWidget {
  const _UsageHero({required this.usage});

  final P2PLimitUsageDraft usage;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: P2PLimitTrackerPage.usageHeroKey,
      padding: const EdgeInsets.all(AppSpacing.x5),
      decoration: BoxDecoration(
        color: AppModuleAccents.p2p,
        borderRadius: AppRadii.cardLargeRadius,
        border: Border.all(color: AppModuleAccents.p2p),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Đã dùng',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.onAccent.withValues(alpha: .82),
              fontWeight: AppTextStyles.medium,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            '${_formatComma(usage.used, 0)} VND',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.heroNumber.copyWith(
              color: AppColors.onAccent,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: ColoredBox(
              color: AppColors.onAccent.withValues(alpha: .24),
              child: SizedBox(
                key: P2PLimitTrackerPage.progressKey,
                height: AppSpacing.x3,
                child: FractionallySizedBox(
                  widthFactor: usage.percentage / 100,
                  alignment: Alignment.centerLeft,
                  child: const ColoredBox(color: AppColors.onAccent),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            '${usage.percentage}% / ${_formatComma(usage.limit, 0)} VND',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.onAccent.withValues(alpha: .90),
              fontWeight: AppTextStyles.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _LimitBreakdownList extends StatelessWidget {
  const _LimitBreakdownList({required this.items});

  final List<P2PLimitBreakdownDraft> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PLimitTrackerPage.historyKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Lịch sử gần đây',
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        for (var index = 0; index < items.length; index++) ...[
          _DayBreakdownCard(item: items[index]),
          if (index != items.length - 1) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _DayBreakdownCard extends StatelessWidget {
  const _DayBreakdownCard({required this.item});

  final P2PLimitBreakdownDraft item;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PLimitTrackerPage.dayKey(item.date),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.text3,
                size: 12,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  item.date,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                'Tổng: ${_formatMillions(item.total)}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _TradeSideBox(
                  label: 'MUA',
                  value: _formatMillions(item.buy),
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _TradeSideBox(
                  label: 'BÁN',
                  value: _formatMillions(item.sell),
                  color: AppColors.sell,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TradeSideBox extends StatelessWidget {
  const _TradeSideBox({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatMillions(double value) {
  return '${(value / 1000000).round()}M';
}

String _formatComma(double value, int decimals) {
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  if (decimals == 0) return buffer.toString();
  return '$buffer.${parts.last}';
}
