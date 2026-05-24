import 'dart:math' as math;

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
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/dca_repository.dart';

class DCADynamicAmount extends ConsumerStatefulWidget {
  const DCADynamicAmount({super.key, this.shellRenderMode});

  static const contentKey = Key('sc175_dynamic_amount_content');
  static const applyKey = Key('sc175_apply_strategy');
  static const settingsKey = Key('sc175_dynamic_settings');

  static Key strategyKey(DcaDynamicStrategy strategy) {
    return Key('sc175_strategy_${strategy.name}');
  }

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DCADynamicAmount> createState() => _DCADynamicAmountState();
}

class _DCADynamicAmountState extends ConsumerState<DCADynamicAmount> {
  DcaDynamicStrategy _activeStrategy = DcaDynamicStrategy.volatility;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(dcaRepositoryProvider).getDynamicAmount();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final floatingBottom =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.tabBar + AppSpacing.x2
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x2) +
        MediaQuery.paddingOf(context).bottom;
    final contentBottom = floatingBottom + AppSpacing.buttonStandard;
    final activeOption = _strategyOption(snapshot.strategies, _activeStrategy);
    final adjustment = _adjustmentFor(_activeStrategy, snapshot.adjustment);

    return VitPageLayout(
      semanticLabel: 'SC-175 DCADynamicAmount',
      child: Column(
        children: [
          VitHeader(
            title: 'Dynamic Amount',
            subtitle: 'Số tiền · DCA',
            showBack: true,
            onBack: _close,
            trailing: _HeaderSettingsButton(onPressed: _showSettingsNotice),
          ),
          Expanded(
            child: Stack(
              children: [
                ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: DCADynamicAmount.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: contentBottom),
                    child: VitPageContent(
                      customGap: AppSpacing.x5,
                      children: [
                        _DynamicHero(
                          option: activeOption,
                          adjustment: adjustment,
                          onChangeStrategy: _showStrategyNotice,
                        ),
                        _StrategyStrip(
                          strategies: snapshot.strategies,
                          activeStrategy: _activeStrategy,
                          onChanged: (strategy) {
                            setState(() => _activeStrategy = strategy);
                          },
                        ),
                        _StrategyVisualization(
                          strategy: _activeStrategy,
                          option: activeOption,
                          volatilityHistory: snapshot.volatilityHistory,
                        ),
                        _AmountHistoryCard(entries: snapshot.amountHistory),
                        _RecentDetailsCard(entries: snapshot.amountHistory),
                        _ConfigSection(
                          option: activeOption,
                          items:
                              _activeStrategy == DcaDynamicStrategy.volatility
                              ? snapshot.configItems
                              : _configItemsFor(_activeStrategy),
                        ),
                        _StrategyExplainer(option: activeOption),
                        const _DynamicDisclaimer(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: AppSpacing.contentPad,
                  right: AppSpacing.contentPad,
                  bottom: floatingBottom,
                  child: _FloatingActions(
                    onSettings: _showSettingsNotice,
                    onApply: () => context.go(AppRoutePaths.dca),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.dca);
  }

  void _showSettingsNotice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dynamic amount settings ready')),
    );
  }

  void _showStrategyNotice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chọn chiến lược trong thanh bên dưới')),
    );
  }
}

class _HeaderSettingsButton extends StatelessWidget {
  const _HeaderSettingsButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: AppRadii.mdRadius,
          border: Border.all(color: AppColors.border),
        ),
        child: IconButton(
          key: DCADynamicAmount.settingsKey,
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.settings_outlined,
            color: AppColors.text1,
            size: AppSpacing.iconMd,
          ),
        ),
      ),
    );
  }
}

class _DynamicHero extends StatelessWidget {
  const _DynamicHero({
    required this.option,
    required this.adjustment,
    required this.onChangeStrategy,
  });

  final DcaDynamicStrategyOption option;
  final DcaDynamicAdjustment adjustment;
  final VoidCallback onChangeStrategy;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(option.accent);
    final statusColor = _actionColor(adjustment.action);
    final paused =
        adjustment.action == DcaDynamicAdjustmentAction.paused ||
        adjustment.action == DcaDynamicAdjustmentAction.skipped;

    return VitCard(
      variant: VitCardVariant.hero,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _TinyPill(
                      label: option.title,
                      icon: _iconFor(option.icon),
                      color: accent,
                      filled: true,
                    ),
                    GestureDetector(
                      onTap: onChangeStrategy,
                      child: const _TinyPill(
                        label: 'Đổi',
                        icon: Icons.swap_horiz_rounded,
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
              _TinyPill(
                label: _actionLabel(adjustment.action),
                icon: _actionIcon(adjustment.action),
                color: statusColor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Lần mua tiếp theo',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.portfolioTextMuted,
              height: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          if (paused)
            Row(
              children: [
                Icon(
                  _actionIcon(adjustment.action),
                  color: statusColor,
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(width: AppSpacing.x3),
                Text(
                  adjustment.action == DcaDynamicAdjustmentAction.skipped
                      ? 'Bỏ qua lần này'
                      : 'Tạm dừng',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: statusColor,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            )
          else
            Wrap(
              spacing: AppSpacing.x4,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Text(
                  _formatVnd(adjustment.adjustedAmountVnd),
                  style: AppTextStyles.heroNumber.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                if (adjustment.multiplier != 1)
                  Text(
                    _formatVnd(adjustment.originalAmountVnd),
                    style: AppTextStyles.base.copyWith(
                      color: AppColors.portfolioTextMuted,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: AppColors.portfolioTextMuted,
                    ),
                  ),
              ],
            ),
          const SizedBox(height: AppSpacing.x5),
          VitCard(
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (adjustment.multiplier != 1 && !paused) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            color: statusColor,
                            size: AppSpacing.iconSm,
                          ),
                          const SizedBox(width: AppSpacing.x2),
                          Text(
                            'Hệ số điều chỉnh',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.portfolioTextMuted,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'x${adjustment.multiplier.toStringAsFixed(2)}',
                        style: AppTextStyles.baseMedium.copyWith(
                          color: statusColor,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x3),
                ],
                Text(
                  adjustment.reason,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextDim,
                    height: 1.45,
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

class _TinyPill extends StatelessWidget {
  const _TinyPill({
    required this.label,
    required this.icon,
    required this.color,
    this.filled = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: filled ? AppColors.portfolioBtnGhost : AppColors.hoverBg,
        borderRadius: AppRadii.inputRadius,
        border: Border.all(
          color: filled ? AppColors.portfolioBtnGhostBorder : AppColors.border,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x2),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: filled ? AppColors.portfolioTextDim : color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StrategyStrip extends StatelessWidget {
  const _StrategyStrip({
    required this.strategies,
    required this.activeStrategy,
    required this.onChanged,
  });

  final List<DcaDynamicStrategyOption> strategies;
  final DcaDynamicStrategy activeStrategy;
  final ValueChanged<DcaDynamicStrategy> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CHIẾN LƯỢC',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.sectionLabel,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (final option in strategies) ...[
                _StrategyChip(
                  option: option,
                  selected: option.strategy == activeStrategy,
                  onTap: () => onChanged(option.strategy),
                ),
                const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StrategyChip extends StatelessWidget {
  const _StrategyChip({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final DcaDynamicStrategyOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(option.accent);

    return GestureDetector(
      key: DCADynamicAmount.strategyKey(option.strategy),
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? _accentSoft(option.accent) : AppColors.surface,
          borderRadius: AppRadii.inputRadius,
          border: Border.all(color: selected ? accent : AppColors.cardBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x3,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _iconFor(option.icon),
                color: selected ? accent : AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                option.title,
                style: AppTextStyles.caption.copyWith(
                  color: selected ? accent : AppColors.text2,
                  fontWeight: selected
                      ? AppTextStyles.bold
                      : AppTextStyles.medium,
                ),
              ),
              if (selected) ...[
                const SizedBox(width: AppSpacing.x2),
                Container(
                  width: AppSpacing.x2,
                  height: AppSpacing.x2,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: AppRadii.deviceRadius,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StrategyVisualization extends StatelessWidget {
  const _StrategyVisualization({
    required this.strategy,
    required this.option,
    required this.volatilityHistory,
  });

  final DcaDynamicStrategy strategy;
  final DcaDynamicStrategyOption option;
  final List<DcaVolatilitySnapshot> volatilityHistory;

  @override
  Widget build(BuildContext context) {
    if (strategy != DcaDynamicStrategy.volatility) {
      return _GenericStrategyCard(option: option);
    }

    return VitCard(
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x5,
              AppSpacing.x5,
              AppSpacing.x5,
              AppSpacing.x3,
            ),
            child: _SectionHeader(
              icon: Icons.show_chart_rounded,
              title: 'Biến động & Hệ số',
              subtitle: '30 ngày gần nhất',
              color: AppColors.accent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x3,
              0,
              AppSpacing.x3,
              AppSpacing.x2,
            ),
            child: SizedBox(
              height: AppSpacing.buttonHero * 2 + AppSpacing.x6,
              child: CustomPaint(
                painter: _VolatilityChartPainter(points: volatilityHistory),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.x5,
              0,
              AppSpacing.x5,
              AppSpacing.x4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  spacing: AppSpacing.x4,
                  children: [
                    _LegendItem(color: AppColors.accent, label: 'Volatility'),
                    _LegendItem(color: AppColors.buy, label: 'Hệ số'),
                  ],
                ),
                Wrap(
                  spacing: AppSpacing.x3,
                  children: [
                    _LegendItem(color: AppColors.sell, label: 'High'),
                    _LegendItem(color: AppColors.primary, label: 'Low'),
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

class _GenericStrategyCard extends StatelessWidget {
  const _GenericStrategyCard({required this.option});

  final DcaDynamicStrategyOption option;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(option.accent);

    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: _iconFor(option.icon),
            title: option.title,
            subtitle: option.subtitle,
            color: accent,
          ),
          const SizedBox(height: AppSpacing.x5),
          DecoratedBox(
            decoration: BoxDecoration(
              color: _accentSoft(option.accent),
              borderRadius: AppRadii.cardRadius,
              border: Border.all(color: accent.withValues(alpha: .24)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Text(
                option.description,
                style: AppTextStyles.base.copyWith(
                  color: AppColors.text2,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountHistoryCard extends StatelessWidget {
  const _AmountHistoryCard({required this.entries});

  final List<DcaAmountHistoryEntry> entries;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.x5,
              AppSpacing.x5,
              AppSpacing.x5,
              AppSpacing.x3,
            ),
            child: _SectionHeader(
              icon: Icons.bar_chart_rounded,
              title: 'Lịch sử điều chỉnh',
              subtitle: 'So sánh gốc vs thực tế',
              color: AppColors.primary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x3,
              0,
              AppSpacing.x3,
              AppSpacing.x2,
            ),
            child: SizedBox(
              height: AppSpacing.buttonHero * 2 + AppSpacing.x5,
              child: CustomPaint(
                painter: _AmountHistoryPainter(entries: entries),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.x5,
              0,
              AppSpacing.x5,
              AppSpacing.x4,
            ),
            child: Wrap(
              spacing: AppSpacing.x5,
              children: [
                _LegendItem(
                  color: AppColors.surface3,
                  label: 'Gốc',
                  block: true,
                ),
                _LegendItem(
                  color: AppColors.primary,
                  label: 'Đã điều chỉnh',
                  block: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentDetailsCard extends StatelessWidget {
  const _RecentDetailsCard({required this.entries});

  final List<DcaAmountHistoryEntry> entries;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Icons.history_rounded,
            title: 'Chi tiết gần đây',
            subtitle: '${entries.length} lần điều chỉnh',
            color: AppColors.primarySoft,
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final entry in entries.take(6)) ...[
            _HistoryRow(entry: entry),
            if (entry != entries.take(6).last)
              const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.entry});

  final DcaAmountHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final change = entry.changePercent;
    final color = change > 0
        ? AppColors.buy
        : change < 0
        ? AppColors.warn
        : AppColors.text3;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          children: [
            Container(
              width: AppSpacing.x7 - AppSpacing.x5,
              height: AppSpacing.x7 - AppSpacing.x5,
              decoration: BoxDecoration(
                color: change > 0
                    ? AppColors.buy10
                    : change < 0
                    ? AppColors.warn10
                    : AppColors.hoverBg,
                borderRadius: AppRadii.mdRadius,
              ),
              child: Icon(
                change > 0
                    ? Icons.trending_up_rounded
                    : change < 0
                    ? Icons.trending_down_rounded
                    : Icons.lock_outline_rounded,
                color: color,
                size: AppSpacing.iconMd,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.date,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            _formatVnd(entry.adjustedAmountVnd),
                            style: AppTextStyles.baseMedium.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          if (change != 0) ...[
                            const SizedBox(width: AppSpacing.x2),
                            _ChangeBadge(change: change, color: color),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    entry.reason,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      height: 1.25,
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

class _ChangeBadge extends StatelessWidget {
  const _ChangeBadge({required this.change, required this.color});

  final double change;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: change > 0
            ? AppColors.buy10
            : change < 0
            ? AppColors.warn10
            : AppColors.hoverBg,
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          '${change > 0 ? '+' : ''}${change.toStringAsFixed(0)}%',
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _ConfigSection extends StatelessWidget {
  const _ConfigSection({required this.option, required this.items});

  final DcaDynamicStrategyOption option;
  final List<DcaDynamicConfigItem> items;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(option.accent);

    return VitCard(
      clip: true,
      child: Column(
        children: [
          Container(height: AppSpacing.x1, color: accent),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.x5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(
                  icon: Icons.settings_outlined,
                  title: 'Cấu hình ${option.title}',
                  color: accent,
                  actionLabel: 'Chỉnh sửa',
                ),
                const SizedBox(height: AppSpacing.x4),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final itemWidth =
                        (constraints.maxWidth - AppSpacing.x3) / 2;
                    return Wrap(
                      spacing: AppSpacing.x3,
                      runSpacing: AppSpacing.x3,
                      children: [
                        for (final item in items)
                          SizedBox(
                            width: itemWidth,
                            child: _ConfigItemCard(item: item),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfigItemCard extends StatelessWidget {
  const _ConfigItemCard({required this.item});

  final DcaDynamicConfigItem item;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(item.accent);

    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_iconFor(item.icon), color: accent, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            item.value,
            style: AppTextStyles.baseMedium.copyWith(
              color: accent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StrategyExplainer extends StatelessWidget {
  const _StrategyExplainer({required this.option});

  final DcaDynamicStrategyOption option;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(option.accent);

    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.x7 - AppSpacing.x5,
            height: AppSpacing.x7 - AppSpacing.x5,
            decoration: BoxDecoration(
              color: _accentSoft(option.accent),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: accent,
              size: AppSpacing.iconSm,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chiến lược "${option.title}"',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  option.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.55,
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

class _DynamicDisclaimer extends StatelessWidget {
  const _DynamicDisclaimer();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary08,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.primary20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.primary,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                'Dynamic Amount tự điều chỉnh lượng mua dựa trên chiến lược bạn chọn. Bạn có thể thay đổi chiến lược hoặc quay về "Cố định" bất cứ lúc nào.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.55,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingActions extends StatelessWidget {
  const _FloatingActions({required this.onSettings, required this.onApply});

  final VoidCallback onSettings;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: AppSpacing.ctaHeight,
          height: AppSpacing.ctaHeight,
          child: VitCtaButton(
            onPressed: onSettings,
            fullWidth: false,
            padding: EdgeInsets.zero,
            child: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
              size: AppSpacing.iconMd,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: VitCtaButton(
            key: DCADynamicAmount.applyKey,
            onPressed: onApply,
            leading: const Icon(
              Icons.arrow_upward_rounded,
              color: Colors.white,
              size: AppSpacing.iconMd,
            ),
            child: const Text('Áp dụng chiến lược'),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
    this.subtitle,
    this.actionLabel,
  });

  final IconData icon;
  final String title;
  final Color color;
  final String? subtitle;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSpacing.x6,
          height: AppSpacing.x6,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .14),
            borderRadius: AppRadii.mdRadius,
          ),
          child: Icon(icon, color: color, size: AppSpacing.iconMd),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.x1),
                Text(
                  subtitle!,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ],
          ),
        ),
        if (actionLabel != null)
          Text(
            actionLabel!,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    this.block = false,
  });

  final Color color;
  final String label;
  final bool block;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: block ? AppSpacing.x3 : AppSpacing.x4,
          height: block ? AppSpacing.x3 : AppSpacing.x1,
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadii.deviceRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _VolatilityChartPainter extends CustomPainter {
  const _VolatilityChartPainter({required this.points});

  final List<DcaVolatilitySnapshot> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final chartRect = Rect.fromLTWH(
      AppSpacing.x6,
      AppSpacing.x3,
      size.width - AppSpacing.x7 - AppSpacing.x3,
      size.height - AppSpacing.x7,
    );
    final gridPaint = Paint()
      ..color = AppColors.borderSolid.withValues(alpha: .42)
      ..strokeWidth = 1;
    final labelStyle = AppTextStyles.micro.copyWith(color: AppColors.text3);

    for (var i = 0; i <= 4; i++) {
      final y = chartRect.top + chartRect.height * i / 4;
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
      _paintText(
        canvas,
        (60 - i * 15).toString(),
        Offset(AppSpacing.x2, y - AppSpacing.x3),
        labelStyle,
      );
    }
    for (var i = 0; i <= 5; i++) {
      final x = chartRect.left + chartRect.width * i / 5;
      canvas.drawLine(
        Offset(x, chartRect.top),
        Offset(x, chartRect.bottom),
        gridPaint,
      );
    }

    _drawDashedHorizontal(canvas, chartRect, 25 / 60, AppColors.sell);
    _drawDashedHorizontal(canvas, chartRect, 12 / 60, AppColors.primary);
    _drawLine(
      canvas,
      chartRect,
      points.map((point) => point.volatilityPercent / 60).toList(),
      AppColors.accent,
      fill: true,
    );
    _drawLine(
      canvas,
      chartRect,
      points.map((point) => point.multiplier / 2).toList(),
      AppColors.buy,
      dashed: true,
    );

    for (var i = 1; i < points.length; i += 2) {
      final x = chartRect.left + chartRect.width * i / (points.length - 1);
      _paintText(
        canvas,
        points[i].date,
        Offset(x - AppSpacing.x4, chartRect.bottom + AppSpacing.x3),
        labelStyle,
      );
    }
    _paintText(
      canvas,
      '2',
      Offset(chartRect.right + AppSpacing.x3, chartRect.top - AppSpacing.x2),
      labelStyle,
    );
    _paintText(
      canvas,
      '0',
      Offset(chartRect.right + AppSpacing.x3, chartRect.bottom - AppSpacing.x2),
      labelStyle,
    );
  }

  @override
  bool shouldRepaint(covariant _VolatilityChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _AmountHistoryPainter extends CustomPainter {
  const _AmountHistoryPainter({required this.entries});

  final List<DcaAmountHistoryEntry> entries;

  @override
  void paint(Canvas canvas, Size size) {
    if (entries.isEmpty) return;

    final data = entries.take(8).toList().reversed.toList();
    final chartRect = Rect.fromLTWH(
      AppSpacing.x7,
      AppSpacing.x3,
      size.width - AppSpacing.x7 - AppSpacing.x3,
      size.height - AppSpacing.x7,
    );
    final gridPaint = Paint()
      ..color = AppColors.borderSolid.withValues(alpha: .42)
      ..strokeWidth = 1;
    final labelStyle = AppTextStyles.micro.copyWith(color: AppColors.text3);
    final maxAmount = data
        .map((entry) => math.max(entry.baseAmountVnd, entry.adjustedAmountVnd))
        .reduce(math.max)
        .toDouble();

    for (var i = 0; i <= 4; i++) {
      final y = chartRect.top + chartRect.height * i / 4;
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
      final value = maxAmount * (1 - i / 4);
      _paintText(
        canvas,
        _formatVnd(value.round()),
        Offset(AppSpacing.x2, y - AppSpacing.x3),
        labelStyle,
      );
    }

    final groupWidth = chartRect.width / data.length;
    final barWidth = math.min(AppSpacing.x4, groupWidth / 4);
    for (var i = 0; i < data.length; i++) {
      final entry = data[i];
      final center = chartRect.left + groupWidth * i + groupWidth / 2;
      _drawBar(
        canvas,
        chartRect,
        center - barWidth,
        barWidth,
        entry.baseAmountVnd / maxAmount,
        AppColors.surface3,
      );
      _drawBar(
        canvas,
        chartRect,
        center + AppSpacing.x1,
        barWidth,
        entry.adjustedAmountVnd / maxAmount,
        AppColors.primary,
      );
      if (i.isOdd) {
        _paintText(
          canvas,
          entry.date.substring(0, 5),
          Offset(center - AppSpacing.x4, chartRect.bottom + AppSpacing.x3),
          labelStyle,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _AmountHistoryPainter oldDelegate) {
    return oldDelegate.entries != entries;
  }
}

void _drawLine(
  Canvas canvas,
  Rect rect,
  List<double> values,
  Color color, {
  bool dashed = false,
  bool fill = false,
}) {
  if (values.isEmpty) return;

  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final x = rect.left + rect.width * i / (values.length - 1);
    final y = rect.bottom - rect.height * values[i].clamp(0, 1);
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  if (fill) {
    final fillPath = Path.from(path)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..color = color.withValues(alpha: .10)
        ..style = PaintingStyle.fill,
    );
  }

  final paint = Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 2;
  if (!dashed) {
    canvas.drawPath(path, paint);
    return;
  }

  for (final metric in path.computeMetrics()) {
    var distance = 0.0;
    while (distance < metric.length) {
      final segment = metric.extractPath(distance, distance + AppSpacing.x3);
      canvas.drawPath(segment, paint);
      distance += AppSpacing.x4;
    }
  }
}

void _drawDashedHorizontal(
  Canvas canvas,
  Rect rect,
  double ratio,
  Color color,
) {
  final y = rect.bottom - rect.height * ratio.clamp(0, 1);
  final paint = Paint()
    ..color = color.withValues(alpha: .58)
    ..strokeWidth = 1;
  var x = rect.left;
  while (x < rect.right) {
    canvas.drawLine(Offset(x, y), Offset(x + AppSpacing.x3, y), paint);
    x += AppSpacing.x4;
  }
}

void _drawBar(
  Canvas canvas,
  Rect rect,
  double x,
  double width,
  double ratio,
  Color color,
) {
  final height = rect.height * ratio.clamp(0, 1);
  final barRect = RRect.fromRectAndCorners(
    Rect.fromLTWH(x, rect.bottom - height, width, height),
    topLeft: const Radius.circular(AppSpacing.x2),
    topRight: const Radius.circular(AppSpacing.x2),
  );
  canvas.drawRRect(barRect, Paint()..color = color);
}

void _paintText(
  Canvas canvas,
  String text,
  Offset offset,
  TextStyle style, {
  TextAlign textAlign = TextAlign.left,
}) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textAlign: textAlign,
    textDirection: TextDirection.ltr,
  )..layout();
  painter.paint(canvas, offset);
}

DcaDynamicStrategyOption _strategyOption(
  List<DcaDynamicStrategyOption> strategies,
  DcaDynamicStrategy strategy,
) {
  return strategies.firstWhere(
    (option) => option.strategy == strategy,
    orElse: () => strategies.first,
  );
}

DcaDynamicAdjustment _adjustmentFor(
  DcaDynamicStrategy strategy,
  DcaDynamicAdjustment base,
) {
  switch (strategy) {
    case DcaDynamicStrategy.fixed:
      return const DcaDynamicAdjustment(
        originalAmountVnd: 500000,
        adjustedAmountVnd: 500000,
        multiplier: 1,
        reason: 'Mua số tiền cố định mỗi kỳ',
        action: DcaDynamicAdjustmentAction.normal,
      );
    case DcaDynamicStrategy.performance:
      return const DcaDynamicAdjustment(
        originalAmountVnd: 500000,
        adjustedAmountVnd: 600000,
        multiplier: 1.2,
        reason: 'Portfolio lời +8.5% - tăng nhẹ lượng mua',
        action: DcaDynamicAdjustmentAction.increased,
      );
    case DcaDynamicStrategy.balance:
      return const DcaDynamicAdjustment(
        originalAmountVnd: 500000,
        adjustedAmountVnd: 500000,
        multiplier: 1,
        reason: 'Số dư đủ (5.2M)',
        action: DcaDynamicAdjustmentAction.normal,
      );
    case DcaDynamicStrategy.target:
      return const DcaDynamicAdjustment(
        originalAmountVnd: 200000,
        adjustedAmountVnd: 900000,
        multiplier: 4.5,
        reason: 'Cần khoảng 900K/tuần để đạt mục tiêu 50M',
        action: DcaDynamicAdjustmentAction.increased,
      );
    case DcaDynamicStrategy.volatility:
      return base;
  }
}

List<DcaDynamicConfigItem> _configItemsFor(DcaDynamicStrategy strategy) {
  switch (strategy) {
    case DcaDynamicStrategy.fixed:
      return const [
        DcaDynamicConfigItem(
          label: 'Số tiền mỗi kỳ',
          value: '500K',
          icon: DcaScheduleOptionIcon.clock,
          accent: DcaDynamicConfigAccent.neutral,
        ),
        DcaDynamicConfigItem(
          label: 'Chu kỳ',
          value: 'Tuần',
          icon: DcaScheduleOptionIcon.clock,
          accent: DcaDynamicConfigAccent.primary,
        ),
      ];
    case DcaDynamicStrategy.performance:
      return const [
        DcaDynamicConfigItem(
          label: 'Số tiền gốc',
          value: '500K',
          icon: DcaScheduleOptionIcon.clock,
          accent: DcaDynamicConfigAccent.warning,
        ),
        DcaDynamicConfigItem(
          label: 'Hệ số khi lời',
          value: 'x1.2',
          icon: DcaScheduleOptionIcon.chart,
          accent: DcaDynamicConfigAccent.success,
        ),
        DcaDynamicConfigItem(
          label: 'Hệ số khi lỗ',
          value: 'x0.8',
          icon: DcaScheduleOptionIcon.chart,
          accent: DcaDynamicConfigAccent.warning,
        ),
        DcaDynamicConfigItem(
          label: 'Dừng khi lỗ',
          value: '-20%',
          icon: DcaScheduleOptionIcon.bolt,
          accent: DcaDynamicConfigAccent.danger,
        ),
      ];
    case DcaDynamicStrategy.balance:
      return const [
        DcaDynamicConfigItem(
          label: 'Số tiền gốc',
          value: '500K',
          icon: DcaScheduleOptionIcon.clock,
          accent: DcaDynamicConfigAccent.warning,
        ),
        DcaDynamicConfigItem(
          label: 'Giữ tối thiểu',
          value: '1.0M',
          icon: DcaScheduleOptionIcon.clock,
          accent: DcaDynamicConfigAccent.neutral,
        ),
        DcaDynamicConfigItem(
          label: 'Ngưỡng giảm',
          value: '3.0M',
          icon: DcaScheduleOptionIcon.bolt,
          accent: DcaDynamicConfigAccent.warning,
        ),
        DcaDynamicConfigItem(
          label: 'Ngưỡng dừng',
          value: '500K',
          icon: DcaScheduleOptionIcon.bolt,
          accent: DcaDynamicConfigAccent.danger,
        ),
      ];
    case DcaDynamicStrategy.target:
      return const [
        DcaDynamicConfigItem(
          label: 'Mục tiêu',
          value: '50.0M',
          icon: DcaScheduleOptionIcon.chart,
          accent: DcaDynamicConfigAccent.warning,
        ),
        DcaDynamicConfigItem(
          label: 'Hạn chót',
          value: '31/12',
          icon: DcaScheduleOptionIcon.clock,
          accent: DcaDynamicConfigAccent.primary,
        ),
        DcaDynamicConfigItem(
          label: 'Min/lần',
          value: '200K',
          icon: DcaScheduleOptionIcon.bolt,
          accent: DcaDynamicConfigAccent.neutral,
        ),
        DcaDynamicConfigItem(
          label: 'Max/lần',
          value: '2.0M',
          icon: DcaScheduleOptionIcon.bolt,
          accent: DcaDynamicConfigAccent.success,
        ),
      ];
    case DcaDynamicStrategy.volatility:
      return const [];
  }
}

IconData _iconFor(DcaScheduleOptionIcon icon) {
  switch (icon) {
    case DcaScheduleOptionIcon.clock:
      return Icons.lock_outline_rounded;
    case DcaScheduleOptionIcon.trend:
      return Icons.trending_up_rounded;
    case DcaScheduleOptionIcon.bolt:
      return Icons.show_chart_rounded;
    case DcaScheduleOptionIcon.chart:
      return Icons.bar_chart_rounded;
  }
}

IconData _actionIcon(DcaDynamicAdjustmentAction action) {
  switch (action) {
    case DcaDynamicAdjustmentAction.increased:
      return Icons.trending_up_rounded;
    case DcaDynamicAdjustmentAction.decreased:
      return Icons.trending_down_rounded;
    case DcaDynamicAdjustmentAction.skipped:
    case DcaDynamicAdjustmentAction.paused:
      return Icons.pause_rounded;
    case DcaDynamicAdjustmentAction.normal:
      return Icons.lock_outline_rounded;
  }
}

String _actionLabel(DcaDynamicAdjustmentAction action) {
  switch (action) {
    case DcaDynamicAdjustmentAction.increased:
      return 'Tăng mua';
    case DcaDynamicAdjustmentAction.decreased:
      return 'Giảm mua';
    case DcaDynamicAdjustmentAction.skipped:
      return 'Bỏ qua';
    case DcaDynamicAdjustmentAction.paused:
      return 'Tạm dừng';
    case DcaDynamicAdjustmentAction.normal:
      return 'Bình thường';
  }
}

Color _actionColor(DcaDynamicAdjustmentAction action) {
  switch (action) {
    case DcaDynamicAdjustmentAction.increased:
      return AppColors.buy;
    case DcaDynamicAdjustmentAction.decreased:
      return AppColors.warn;
    case DcaDynamicAdjustmentAction.skipped:
    case DcaDynamicAdjustmentAction.paused:
      return AppColors.sell;
    case DcaDynamicAdjustmentAction.normal:
      return AppColors.text2;
  }
}

Color _accentColor(DcaDynamicConfigAccent accent) {
  switch (accent) {
    case DcaDynamicConfigAccent.primary:
      return AppColors.primary;
    case DcaDynamicConfigAccent.success:
      return AppColors.buy;
    case DcaDynamicConfigAccent.warning:
      return AppColors.warn;
    case DcaDynamicConfigAccent.danger:
      return AppColors.sell;
    case DcaDynamicConfigAccent.accent:
      return AppColors.accent;
    case DcaDynamicConfigAccent.neutral:
      return AppColors.text2;
  }
}

Color _accentSoft(DcaDynamicConfigAccent accent) {
  switch (accent) {
    case DcaDynamicConfigAccent.primary:
      return AppColors.primary12;
    case DcaDynamicConfigAccent.success:
      return AppColors.buy10;
    case DcaDynamicConfigAccent.warning:
      return AppColors.warn10;
    case DcaDynamicConfigAccent.danger:
      return AppColors.sell10;
    case DcaDynamicConfigAccent.accent:
      return AppColors.accent12;
    case DcaDynamicConfigAccent.neutral:
      return AppColors.hoverBg;
  }
}

String _formatVnd(int value) {
  final abs = value.abs();
  if (abs >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1)}M';
  }
  if (abs >= 1000) {
    return '${(value / 1000).toStringAsFixed(0)}K';
  }
  return value.toString();
}
