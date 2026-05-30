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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';

class DCAOverviewDemo extends ConsumerStatefulWidget {
  const DCAOverviewDemo({super.key, this.shellRenderMode});

  static const contentKey = Key('sc400_dca_overview_content');
  static const loadingToggleKey = Key('sc400_loading_toggle');
  static const loadingSectionKey = Key('sc400_loading_section');
  static const mobilePreviewKey = Key('sc400_mobile_preview');
  static const footerKey = Key('sc400_footer');

  static Key scenarioKey(String id) => Key('sc400_scenario_$id');
  static Key cardKey(String id) => Key('sc400_card_$id');
  static Key actionKey(String id, String action) => Key('sc400_${id}_$action');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DCAOverviewDemo> createState() => _DCAOverviewDemoState();
}

class _DCAOverviewDemoState extends ConsumerState<DCAOverviewDemo> {
  bool _showLoading = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(dcaOverviewDemoProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-400 DCAOverviewDemo',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
              trailing: _LoadingToggle(
                active: _showLoading,
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _showLoading = !_showLoading);
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: DCAOverviewDemo.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  gap: VitContentGap.loose,
                  children: [
                    if (_showLoading)
                      _DemoSection(
                        key: DCAOverviewDemo.loadingSectionKey,
                        title: 'Loading State (Skeleton Shimmer)',
                        description: 'Hiệu ứng shimmer khi data đang tải.',
                        child: _DcaOverviewCardPreview(
                          scenario: snapshot.scenarios.first,
                          isLoading: true,
                        ),
                      ),
                    for (final scenario in snapshot.scenarios)
                      _DemoSection(
                        key: DCAOverviewDemo.scenarioKey(scenario.id),
                        title: scenario.title,
                        description: scenario.description,
                        child: _DcaOverviewCardPreview(scenario: scenario),
                      ),
                    _DemoSection(
                      key: DCAOverviewDemo.mobilePreviewKey,
                      title: snapshot.mobilePreview.title,
                      description: snapshot.mobilePreview.description,
                      child: Align(
                        alignment: Alignment.center,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 360),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.borderSolid),
                              borderRadius: AppRadii.cardLargeRadius,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.x2),
                              child: _DcaOverviewCardPreview(
                                scenario: snapshot.mobilePreview,
                                compact: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _DemoFooter(snapshot: snapshot),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingToggle extends StatelessWidget {
  const _LoadingToggle({required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: DCAOverviewDemo.loadingToggleKey,
      onTap: onTap,
      borderRadius: AppRadii.xlRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: active ? AppColors.sell15 : AppColors.primary15,
          borderRadius: AppRadii.xlRadius,
          border: Border.all(
            color: active ? AppColors.sell20 : AppColors.primary20,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x2,
          ),
          child: Text(
            active ? 'Hide Loading' : 'Show Loading',
            style: AppTextStyles.caption.copyWith(
              color: active ? AppColors.sell : AppColors.primary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _DemoSection extends StatelessWidget {
  const _DemoSection({
    super.key,
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: AppTextStyles.sectionTitle.copyWith(fontSize: 18)),
        const SizedBox(height: AppSpacing.x2),
        Text(
          description,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x4),
        child,
      ],
    );
  }
}

class _DcaOverviewCardPreview extends StatefulWidget {
  const _DcaOverviewCardPreview({
    required this.scenario,
    this.isLoading = false,
    this.compact = false,
  });

  final DcaOverviewDemoScenario scenario;
  final bool isLoading;
  final bool compact;

  @override
  State<_DcaOverviewCardPreview> createState() =>
      _DcaOverviewCardPreviewState();
}

class _DcaOverviewCardPreviewState extends State<_DcaOverviewCardPreview> {
  bool _balanceHidden = false;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: DCAOverviewDemo.cardKey(widget.scenario.id),
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: EdgeInsets.all(
        widget.compact ? AppSpacing.x4 : AppSpacing.contentPad,
      ),
      child: widget.isLoading
          ? const _OverviewSkeleton()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeaderRow(
                  balanceHidden: _balanceHidden,
                  onToggle: () {
                    HapticFeedback.selectionClick();
                    setState(() => _balanceHidden = !_balanceHidden);
                  },
                ),
                const SizedBox(height: AppSpacing.x3),
                _ValueRow(
                  data: widget.scenario.data,
                  sparkline: widget.scenario.sparkline,
                  balanceHidden: _balanceHidden,
                ),
                const SizedBox(height: AppSpacing.x3),
                _ProfitRow(
                  data: widget.scenario.data,
                  balanceHidden: _balanceHidden,
                ),
                const SizedBox(height: AppSpacing.x5),
                _MetricGrid(
                  data: widget.scenario.data,
                  balanceHidden: _balanceHidden,
                ),
                const SizedBox(height: AppSpacing.x4),
                _NextExecutionRow(data: widget.scenario.data),
                if (widget.scenario.showActions) ...[
                  const SizedBox(height: AppSpacing.x4),
                  _ActionRow(scenarioId: widget.scenario.id),
                ],
              ],
            ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.balanceHidden, required this.onToggle});

  final bool balanceHidden;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Tổng danh mục DCA (VND)',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.portfolioTextDim,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: onToggle,
          icon: Icon(
            balanceHidden
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.portfolioTextMuted,
            size: 18,
          ),
        ),
      ],
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({
    required this.data,
    required this.sparkline,
    required this.balanceHidden,
  });

  final DcaOverviewDemoData data;
  final List<double> sparkline;
  final bool balanceHidden;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              balanceHidden
                  ? '••••••'
                  : '₫${_formatFullVnd(data.currentValueVnd)}',
              maxLines: 1,
              style: AppTextStyles.heroNumber.copyWith(
                fontSize: 31,
                fontWeight: FontWeight.w900,
                height: 1,
                color: AppColors.text1,
              ),
            ),
          ),
        ),
        if (sparkline.length >= 2) ...[
          const SizedBox(width: AppSpacing.x4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: AppSpacing.buttonHero + AppSpacing.x3,
                height: AppSpacing.buttonCompact + AppSpacing.x2,
                child: CustomPaint(
                  painter: _SparklinePainter(
                    values: sparkline,
                    lineColor: data.isProfit ? AppColors.buy : AppColors.sell,
                    fillColor: data.isProfit
                        ? AppColors.buy15
                        : AppColors.sell15,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                '90 ngày',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.portfolioTextMuted,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ProfitRow extends StatelessWidget {
  const _ProfitRow({required this.data, required this.balanceHidden});

  final DcaOverviewDemoData data;
  final bool balanceHidden;

  @override
  Widget build(BuildContext context) {
    final isProfit = data.isProfit;
    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: isProfit ? AppColors.buy20 : AppColors.sell20,
            borderRadius: AppRadii.smRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x1,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isProfit
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  color: isProfit ? AppColors.buy : AppColors.sell,
                  size: 14,
                ),
                const SizedBox(width: AppSpacing.x1),
                Text(
                  balanceHidden
                      ? '•••'
                      : '${isProfit ? '+' : '-'} ${_formatFullVnd(data.profitLossVnd.abs())} (${_formatPercent(data.profitLossPercent)})',
                  style: AppTextStyles.caption.copyWith(
                    color: isProfit ? AppColors.buy : AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Flexible(
          child: Text(
            'tổng lãi/lỗ',
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.data, required this.balanceHidden});

  final DcaOverviewDemoData data;
  final bool balanceHidden;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricTile(
            icon: Icons.sync_rounded,
            label: 'Kế\nhoạch',
            value: balanceHidden ? '•' : '${data.totalPlans}',
            subtitle: '${data.activePlans} đang chạy',
            accent: AppModuleAccents.trade,
            accentBg: AppColors.primary15,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _MetricTile(
            icon: Icons.trending_up_rounded,
            label: 'Đã đầu\ntư',
            value: balanceHidden
                ? '•••'
                : _formatCompactVnd(data.totalInvestedVnd),
            subtitle: balanceHidden
                ? '•••••'
                : _formatFullVnd(data.totalInvestedVnd),
            accent: AppColors.buy,
            accentBg: AppColors.buy15,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _MetricTile(
            icon: Icons.bar_chart_rounded,
            label: 'TB/plan',
            value: balanceHidden
                ? '•••'
                : _formatCompactVnd(data.averagePerPlanVnd),
            subtitle: 'VND / kế hoạch',
            accent: AppColors.accent,
            accentBg: AppColors.accent15,
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.accent,
    required this.accentBg,
  });

  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final Color accent;
  final Color accentBg;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.portfolioBtnGhost,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: accentBg,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.x2),
                    child: Icon(icon, color: accent, size: 13),
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.portfolioTextDim,
                      fontWeight: AppTextStyles.bold,
                      height: 1.15,
                    ),
                  ),
                ),
                Icon(
                  Icons.help_outline_rounded,
                  color: AppColors.portfolioTextMuted,
                  size: 13,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                maxLines: 1,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: accent,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.portfolioTextMuted,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NextExecutionRow extends StatelessWidget {
  const _NextExecutionRow({required this.data});

  final DcaOverviewDemoData data;

  @override
  Widget build(BuildContext context) {
    final hasNext = data.nextRelativeTime != null && data.nextAmountVnd != null;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.portfolioBtnGhost,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.primary15,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.x3),
                child: Icon(
                  Icons.schedule_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasNext ? 'Lần mua tiếp' : 'Không có lịch mua',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.portfolioTextMuted,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    hasNext
                        ? '${data.nextRelativeTime} · ${_formatCompactVnd(data.nextAmountVnd!)}'
                        : 'Tất cả kế hoạch đang tạm dừng',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            _StatusBadge(
              icon: Icons.play_arrow_rounded,
              count: data.activePlans,
              bg: AppColors.buy15,
              color: AppColors.buy,
            ),
            if (data.pausedPlans > 0) ...[
              const SizedBox(width: AppSpacing.x2),
              _StatusBadge(
                icon: Icons.pause_rounded,
                count: data.pausedPlans,
                bg: AppColors.warn15,
                color: AppColors.warn,
              ),
            ],
            if (data.errorPlans > 0) ...[
              const SizedBox(width: AppSpacing.x2),
              _StatusBadge(
                icon: Icons.error_outline_rounded,
                count: data.errorPlans,
                bg: AppColors.sell15,
                color: AppColors.sell,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.icon,
    required this.count,
    required this.bg,
    required this.color,
  });

  final IconData icon;
  final int count;
  final Color bg;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: bg, borderRadius: AppRadii.smRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 13),
            const SizedBox(width: AppSpacing.x1),
            Text(
              '$count',
              style: AppTextStyles.micro.copyWith(
                color: color,
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

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.scenarioId});

  final String scenarioId;

  @override
  Widget build(BuildContext context) {
    const actions = [
      _ActionSpec(
        'create',
        Icons.add_rounded,
        'Tạo mới',
        AppColors.buy,
        AppColors.buy15,
      ),
      _ActionSpec(
        'pause',
        Icons.pause_rounded,
        'Tạm dừng',
        AppColors.warn,
        AppColors.warn15,
      ),
      _ActionSpec(
        'chart',
        Icons.bar_chart_rounded,
        'Biểu đồ',
        AppColors.accent,
        AppColors.accent15,
      ),
      _ActionSpec(
        'history',
        Icons.format_list_bulleted_rounded,
        'Lịch sử',
        AppColors.text2,
        AppColors.hoverBg,
      ),
    ];
    return Row(
      children: [
        for (var i = 0; i < actions.length; i++) ...[
          Expanded(
            child: _ActionButton(scenarioId: scenarioId, spec: actions[i]),
          ),
          if (i < actions.length - 1) const SizedBox(width: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.scenarioId, required this.spec});

  final String scenarioId;
  final _ActionSpec spec;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: DCAOverviewDemo.actionKey(scenarioId, spec.id),
      onTap: HapticFeedback.selectionClick,
      borderRadius: AppRadii.cardRadius,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.portfolioBtnGhost,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x2,
            vertical: AppSpacing.x3,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: spec.bg,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.x3),
                  child: Icon(spec.icon, color: spec.color, size: 18),
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                spec.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.portfolioTextDim,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionSpec {
  const _ActionSpec(this.id, this.icon, this.label, this.color, this.bg);

  final String id;
  final IconData icon;
  final String label;
  final Color color;
  final Color bg;
}

class _OverviewSkeleton extends StatelessWidget {
  const _OverviewSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            VitSkeleton(width: 160, height: 14),
            Spacer(),
            VitSkeleton(width: 21, height: 21, borderRadius: AppRadii.xlRadius),
          ],
        ),
        SizedBox(height: AppSpacing.x5),
        VitSkeleton(
          width: null,
          height: AppSpacing.x6,
          borderRadius: AppRadii.inputRadius,
        ),
        SizedBox(height: AppSpacing.x4),
        Row(
          children: [
            VitSkeleton(
              width: 130,
              height: AppSpacing.x5,
              borderRadius: AppRadii.smRadius,
            ),
            SizedBox(width: AppSpacing.x3),
            VitSkeleton(width: 60, height: 12),
          ],
        ),
        SizedBox(height: AppSpacing.x5),
        Row(
          children: [
            Expanded(
              child: VitSkeleton(
                width: null,
                height: AppSpacing.buttonHero,
                borderRadius: AppRadii.cardRadius,
              ),
            ),
            SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitSkeleton(
                width: null,
                height: AppSpacing.buttonHero,
                borderRadius: AppRadii.cardRadius,
              ),
            ),
            SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitSkeleton(
                width: null,
                height: AppSpacing.buttonHero,
                borderRadius: AppRadii.cardRadius,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.x4),
        VitSkeleton(
          width: null,
          height: AppSpacing.x7,
          borderRadius: AppRadii.cardRadius,
        ),
        SizedBox(height: AppSpacing.x4),
        Row(
          children: [
            Expanded(
              child: VitSkeleton(
                width: null,
                height: AppSpacing.x7,
                borderRadius: AppRadii.cardRadius,
              ),
            ),
            SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitSkeleton(
                width: null,
                height: AppSpacing.x7,
                borderRadius: AppRadii.cardRadius,
              ),
            ),
            SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitSkeleton(
                width: null,
                height: AppSpacing.x7,
                borderRadius: AppRadii.cardRadius,
              ),
            ),
            SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitSkeleton(
                width: null,
                height: AppSpacing.x7,
                borderRadius: AppRadii.cardRadius,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DemoFooter extends StatelessWidget {
  const _DemoFooter({required this.snapshot});

  final DcaOverviewDemoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: DCAOverviewDemo.footerKey,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        'Component: ${snapshot.componentName} · Location: ${snapshot.componentLocation}',
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  const _SparklinePainter({
    required this.values,
    required this.lineColor,
    required this.fillColor,
  });

  final List<double> values;
  final Color lineColor;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2 || size.width <= 0 || size.height <= 0) return;
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final range = max - min == 0 ? 1 : max - min;
    final points = <Offset>[
      for (var i = 0; i < values.length; i++)
        Offset(
          (i / (values.length - 1)) * size.width,
          AppSpacing.x1 +
              (size.height - AppSpacing.x2) -
              ((values[i] - min) / range) * (size.height - AppSpacing.x2),
        ),
    ];

    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      line.lineTo(points[i].dx, points[i].dy);
    }

    final area = Path.from(line)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(area, Paint()..color = fillColor);
    canvas.drawPath(
      line,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawCircle(points.last, AppSpacing.x2, Paint()..color = lineColor);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor;
  }
}

String _formatFullVnd(int amount) {
  final sign = amount < 0 ? '-' : '';
  final digits = amount.abs().toString();
  final buffer = StringBuffer(sign);
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

String _formatCompactVnd(int amount) {
  final sign = amount < 0 ? '-' : '';
  final abs = amount.abs();
  if (abs >= 1000000000) {
    return '$sign${(abs / 1000000000).toStringAsFixed(2)}B';
  }
  return '$sign${(abs / 1000000).toStringAsFixed(2)}M';
}

String _formatPercent(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(1).replaceAll('.', ',')}%';
}
