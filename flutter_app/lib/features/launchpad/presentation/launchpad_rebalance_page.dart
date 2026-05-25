import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import '../data/launchpad_repository.dart';

class LaunchpadRebalancePage extends ConsumerStatefulWidget {
  const LaunchpadRebalancePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc312_launchpad_rebalance_content');
  static const heroKey = Key('sc312_launchpad_rebalance_hero');
  static const strategyKey = Key('sc312_launchpad_rebalance_strategies');
  static const allocationKey = Key('sc312_launchpad_rebalance_allocation');
  static const deviationKey = Key('sc312_launchpad_rebalance_deviation');
  static const suggestionsKey = Key('sc312_launchpad_rebalance_suggestions');
  static const summaryKey = Key('sc312_launchpad_rebalance_summary');
  static const warningKey = Key('sc312_launchpad_rebalance_warning');
  static const previewKey = Key('sc312_launchpad_rebalance_preview');
  static const confirmSheetKey = Key('sc312_launchpad_rebalance_confirm_sheet');
  static const confirmKey = Key('sc312_launchpad_rebalance_confirm');
  static const cancelKey = Key('sc312_launchpad_rebalance_cancel');

  static Key strategyButtonKey(String id) =>
      Key('sc312_launchpad_rebalance_strategy_$id');
  static Key suggestionKey(String id) =>
      Key('sc312_launchpad_rebalance_suggestion_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadRebalancePage> createState() =>
      _LaunchpadRebalancePageState();
}

class _LaunchpadRebalancePageState
    extends ConsumerState<LaunchpadRebalancePage> {
  late String _strategyId;
  var _showConfirm = false;

  @override
  void initState() {
    super.initState();
    _strategyId = ref
        .read(launchpadRepositoryProvider)
        .getRebalance()
        .defaultStrategyId;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadRepositoryProvider).getRebalance();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navInset = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    const footerHeight = 92.0;
    final bottomInset = navInset + safeBottom + AppSpacing.x6 + footerHeight;
    final strategy = snapshot.strategies.firstWhere(
      (item) => item.id == _strategyId,
      orElse: () => snapshot.strategies.first,
    );
    final assets = _assetsWithTargets(snapshot.assets, strategy);
    final suggestions = _suggestionsFor(assets);
    final totalValue = assets.fold<double>(
      0,
      (sum, asset) => sum + asset.currentValue,
    );
    final totalDeviation = suggestions.fold<double>(
      0,
      (sum, item) => sum + item.deviation.abs(),
    );
    final txCount = suggestions
        .where((item) => item.action != LaunchpadRebalanceAction.hold)
        .length;
    final totalGas = txCount * 1.5;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-312 LaunchpadRebalancePage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: snapshot.title,
                  showBack: true,
                  onBack: () => context.go(snapshot.backRoute),
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      key: LaunchpadRebalancePage.contentKey,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: bottomInset),
                      child: VitPageContent(
                        padding: VitContentPadding.defaultPadding,
                        customGap: AppSpacing.x4,
                        children: [
                          _PortfolioHero(
                            totalValue: totalValue,
                            assetCount: assets.length,
                            totalDeviation: totalDeviation,
                          ),
                          _StrategySection(
                            strategies: snapshot.strategies,
                            activeId: _strategyId,
                            onChanged: (id) => setState(() => _strategyId = id),
                          ),
                          _AllocationCard(assets: assets),
                          _DeviationCard(assets: assets),
                          _SuggestionsSection(suggestions: suggestions),
                          _SummaryCard(
                            txCount: txCount,
                            totalGas: totalGas,
                            strategy: strategy,
                          ),
                          const _WarningBanner(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: navInset + safeBottom,
              child: VitStickyFooter(
                backgroundColor: AppColors.surface.withValues(alpha: .94),
                child: VitCtaButton(
                  key: LaunchpadRebalancePage.previewKey,
                  onPressed: () => setState(() => _showConfirm = true),
                  child: const Text('Xem lai & Thuc hien Rebalance'),
                ),
              ),
            ),
            if (_showConfirm)
              Positioned.fill(
                child: _ConfirmSheet(
                  suggestions: suggestions,
                  totalGas: totalGas,
                  onClose: () => setState(() => _showConfirm = false),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PortfolioHero extends StatelessWidget {
  const _PortfolioHero({
    required this.totalValue,
    required this.assetCount,
    required this.totalDeviation,
  });

  final double totalValue;
  final int assetCount;
  final double totalDeviation;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadRebalancePage.heroKey,
      variant: VitCardVariant.hero,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.pie_chart_outline_rounded,
                color: AppColors.portfolioTextMuted,
                size: 15,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Portfolio Value',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.portfolioTextDim,
                  fontWeight: AppTextStyles.medium,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            '\$${_money(totalValue)}',
            style: AppTextStyles.pageTitle.copyWith(
              color: AppColors.text1,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            '$assetCount assets - Deviation: ${totalDeviation.toStringAsFixed(1)}%',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _StrategySection extends StatelessWidget {
  const _StrategySection({
    required this.strategies,
    required this.activeId,
    required this.onChanged,
  });

  final List<LaunchpadRebalanceStrategyDraft> strategies;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadRebalancePage.strategyKey,
      child: VitPageSection(
        label: 'Chien luoc',
        accentColor: AppColors.accent,
        children: [
          Row(
            children: [
              for (final strategy in strategies) ...[
                Expanded(
                  child: _StrategyCard(
                    strategy: strategy,
                    active: activeId == strategy.id,
                    onTap: () => onChanged(strategy.id),
                  ),
                ),
                if (strategy != strategies.last)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    required this.strategy,
    required this.active,
    required this.onTap,
  });

  final LaunchpadRebalanceStrategyDraft strategy;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadRebalancePage.strategyButtonKey(strategy.id),
      variant: active ? VitCardVariant.standard : VitCardVariant.inner,
      borderColor: active
          ? strategy.accent.withValues(alpha: .38)
          : AppColors.cardBorder,
      padding: const EdgeInsets.all(AppSpacing.x3),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: strategy.accent.withValues(alpha: .14),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Icon(
              Icons.shield_outlined,
              color: strategy.accent,
              size: 15,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            strategy.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: active ? strategy.accent : AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            strategy.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _AllocationCard extends StatelessWidget {
  const _AllocationCard({required this.assets});

  final List<LaunchpadRebalanceAssetDraft> assets;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadRebalancePage.allocationKey,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hien tai vs Muc tieu',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _DonutBlock(
                  label: 'Hien tai',
                  values: [for (final asset in assets) asset.currentPercent],
                  colors: [for (final asset in assets) asset.accent],
                ),
              ),
              const Icon(Icons.sync_rounded, color: AppColors.text3, size: 18),
              Expanded(
                child: _DonutBlock(
                  label: 'Muc tieu',
                  values: [for (final asset in assets) asset.targetPercent],
                  colors: [for (final asset in assets) asset.accent],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.x3,
            runSpacing: AppSpacing.x2,
            children: [
              for (final asset in assets)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: asset.accent,
                        borderRadius: AppRadii.xsRadius,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Text(
                      asset.symbol,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutBlock extends StatelessWidget {
  const _DonutBlock({
    required this.label,
    required this.values,
    required this.colors,
  });

  final String label;
  final List<double> values;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 9,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        SizedBox(
          width: 104,
          height: 104,
          child: CustomPaint(
            painter: _DonutPainter(values: values, colors: colors),
          ),
        ),
      ],
    );
  }
}

class _DeviationCard extends StatelessWidget {
  const _DeviationCard({required this.assets});

  final List<LaunchpadRebalanceAssetDraft> assets;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadRebalancePage.deviationKey,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Do lech phan bo',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Column(
            children: [for (final asset in assets) _DeviationRow(asset: asset)],
          ),
        ],
      ),
    );
  }
}

class _DeviationRow extends StatelessWidget {
  const _DeviationRow({required this.asset});

  final LaunchpadRebalanceAssetDraft asset;

  @override
  Widget build(BuildContext context) {
    const maxPercent = 36.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Text(
              asset.symbol,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontSize: 10,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                _DeviationBar(
                  value: asset.currentPercent,
                  maxValue: maxPercent,
                  color: asset.accent,
                ),
                const SizedBox(height: 3),
                _DeviationBar(
                  value: asset.targetPercent,
                  maxValue: maxPercent,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviationBar extends StatelessWidget {
  const _DeviationBar({
    required this.value,
    required this.maxValue,
    required this.color,
  });

  final double value;
  final double maxValue;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth * (value / maxValue).clamp(0, 1);
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: width,
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      },
    );
  }
}

class _SuggestionsSection extends StatelessWidget {
  const _SuggestionsSection({required this.suggestions});

  final List<_RebalanceSuggestion> suggestions;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadRebalancePage.suggestionsKey,
      child: VitPageSection(
        label: 'De xuat rebalance',
        accentColor: AppColors.warn,
        children: [
          for (final suggestion in suggestions)
            _SuggestionCard(suggestion: suggestion),
        ],
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({required this.suggestion});

  final _RebalanceSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final color = _actionColor(suggestion.action);
    return VitCard(
      key: LaunchpadRebalancePage.suggestionKey(suggestion.asset.id),
      clip: true,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 3, color: color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.x3),
                child: Row(
                  children: [
                    _AssetBadge(asset: suggestion.asset),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: AppSpacing.x2,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                suggestion.asset.symbol,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                  fontSize: 12,
                                ),
                              ),
                              _ActionPill(
                                action: suggestion.action,
                                color: color,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.x1),
                          Text(
                            '${suggestion.currentPercent.toStringAsFixed(1)}% -> ${suggestion.targetPercent.toStringAsFixed(1)}%   ${suggestion.deviation > 0 ? '-' : '+'}${suggestion.deviation.abs().toStringAsFixed(1)}%',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (suggestion.action != LaunchpadRebalanceAction.hold)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${suggestion.suggestedValue.toStringAsFixed(0)}',
                            style: AppTextStyles.caption.copyWith(
                              color: color,
                              fontWeight: AppTextStyles.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${_amount(suggestion.suggestedAmount)} ${suggestion.asset.symbol}',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
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

class _AssetBadge extends StatelessWidget {
  const _AssetBadge({required this.asset});

  final LaunchpadRebalanceAssetDraft asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: asset.accent.withValues(alpha: .14),
        borderRadius: AppRadii.mdRadius,
      ),
      alignment: Alignment.center,
      child: Text(
        asset.symbol.substring(0, math.min(2, asset.symbol.length)),
        style: AppTextStyles.micro.copyWith(
          color: asset.accent,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({required this.action, required this.color});

  final LaunchpadRebalanceAction action;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_actionIcon(action), color: color, size: 9),
            const SizedBox(width: 3),
            Text(
              _actionLabel(action),
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontSize: 9,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.txCount,
    required this.totalGas,
    required this.strategy,
  });

  final int txCount;
  final double totalGas;
  final LaunchpadRebalanceStrategyDraft strategy;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadRebalancePage.summaryKey,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.primary,
                size: 14,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Tom tat rebalance',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          _SummaryRow(
            label: 'So giao dich can thuc hien',
            value: '$txCount tx',
          ),
          _SummaryRow(
            label: 'Gas uoc tinh',
            value: '~\$${totalGas.toStringAsFixed(2)}',
          ),
          _SummaryRow(label: 'Chien luoc', value: strategy.name),
          _SummaryRow(
            label: 'Muc rui ro',
            value: _riskLabel(strategy.riskLevel),
            color: strategy.accent,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                ),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.micro.copyWith(
                color: color ?? AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadRebalancePage.warningKey,
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.warn08,
        border: Border.all(color: AppColors.warn15),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: 15,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Day la de xuat tu dong dua tren ty le muc tieu. Gia token co the thay doi giua luc xem va luc thuc hien. Luon kiem tra lai truoc khi giao dich.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmSheet extends StatelessWidget {
  const _ConfirmSheet({
    required this.suggestions,
    required this.totalGas,
    required this.onClose,
  });

  final List<_RebalanceSuggestion> suggestions;
  final double totalGas;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final executable = suggestions
        .where((item) => item.action != LaunchpadRebalanceAction.hold)
        .toList();
    return Material(
      key: LaunchpadRebalancePage.confirmSheetKey,
      color: Colors.black.withValues(alpha: .72),
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: DeviceMetrics.width),
            decoration: const BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadii.cardLarge),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.contentPad,
                AppSpacing.x3,
                AppSpacing.contentPad,
                AppSpacing.x6,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.borderSolid,
                        borderRadius: AppRadii.xsRadius,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppColors.buy,
                        size: 21,
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Text(
                        'Xac nhan Rebalance',
                        style: AppTextStyles.base.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  for (final suggestion in executable)
                    _ConfirmActionRow(suggestion: suggestion),
                  const SizedBox(height: AppSpacing.x3),
                  _SummaryRow(
                    label: 'Gas tong',
                    value: '~\$${totalGas.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  VitCtaButton(
                    key: LaunchpadRebalancePage.confirmKey,
                    variant: VitCtaButtonVariant.success,
                    onPressed: onClose,
                    child: const Text('Xac nhan Rebalance (Mo phong)'),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  TextButton(
                    key: LaunchpadRebalancePage.cancelKey,
                    onPressed: onClose,
                    child: Text(
                      'Huy',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfirmActionRow extends StatelessWidget {
  const _ConfirmActionRow({required this.suggestion});

  final _RebalanceSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final color = _actionColor(suggestion.action);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.x2),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        children: [
          Text(
            _actionLabel(suggestion.action),
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              suggestion.asset.symbol,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Text(
            '\$${suggestion.suggestedValue.toStringAsFixed(2)}',
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({required this.values, required this.colors});

  final List<double> values;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.butt;
    final total = values.fold<double>(0, (sum, value) => sum + value);
    var start = -math.pi / 2;
    for (var i = 0; i < values.length; i++) {
      final sweep = total == 0 ? 0.0 : values[i] / total * math.pi * 2;
      paint.color = colors[i % colors.length];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 13),
        start,
        sweep,
        false,
        paint,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) => true;
}

final class _RebalanceSuggestion {
  const _RebalanceSuggestion({
    required this.asset,
    required this.action,
    required this.currentPercent,
    required this.targetPercent,
    required this.deviation,
    required this.suggestedAmount,
    required this.suggestedValue,
  });

  final LaunchpadRebalanceAssetDraft asset;
  final LaunchpadRebalanceAction action;
  final double currentPercent;
  final double targetPercent;
  final double deviation;
  final double suggestedAmount;
  final double suggestedValue;
}

List<LaunchpadRebalanceAssetDraft> _assetsWithTargets(
  List<LaunchpadRebalanceAssetDraft> assets,
  LaunchpadRebalanceStrategyDraft strategy,
) {
  final otherTarget = _targetPercentFor(strategy, 'Other');
  return [
    for (final asset in assets)
      asset.copyWith(
        targetPercent:
            _targetPercentFor(strategy, asset.symbol) ??
            otherTarget ??
            asset.targetPercent,
      ),
  ];
}

double? _targetPercentFor(
  LaunchpadRebalanceStrategyDraft strategy,
  String symbol,
) {
  for (final target in strategy.targets) {
    if (target.symbol == symbol) {
      return target.percent;
    }
  }
  return null;
}

List<_RebalanceSuggestion> _suggestionsFor(
  List<LaunchpadRebalanceAssetDraft> assets,
) {
  final totalValue = assets.fold<double>(
    0,
    (sum, asset) => sum + asset.currentValue,
  );
  final suggestions = [
    for (final asset in assets) _suggestionFor(asset, totalValue),
  ];
  suggestions.sort((a, b) => b.deviation.abs().compareTo(a.deviation.abs()));
  return suggestions;
}

_RebalanceSuggestion _suggestionFor(
  LaunchpadRebalanceAssetDraft asset,
  double totalValue,
) {
  final deviation = asset.currentPercent - asset.targetPercent;
  final targetValue = totalValue * asset.targetPercent / 100;
  final diffValue = asset.currentValue - targetValue;
  final action = deviation.abs() < 1
      ? LaunchpadRebalanceAction.hold
      : deviation > 0
      ? LaunchpadRebalanceAction.sell
      : LaunchpadRebalanceAction.buy;
  return _RebalanceSuggestion(
    asset: asset,
    action: action,
    currentPercent: asset.currentPercent,
    targetPercent: asset.targetPercent,
    deviation: deviation,
    suggestedAmount: (diffValue / asset.price).abs(),
    suggestedValue: diffValue.abs(),
  );
}

Color _actionColor(LaunchpadRebalanceAction action) {
  return switch (action) {
    LaunchpadRebalanceAction.buy => AppColors.buy,
    LaunchpadRebalanceAction.sell => AppColors.sell,
    LaunchpadRebalanceAction.hold => AppColors.text3,
  };
}

IconData _actionIcon(LaunchpadRebalanceAction action) {
  return switch (action) {
    LaunchpadRebalanceAction.buy => Icons.arrow_upward_rounded,
    LaunchpadRebalanceAction.sell => Icons.arrow_downward_rounded,
    LaunchpadRebalanceAction.hold => Icons.remove_rounded,
  };
}

String _actionLabel(LaunchpadRebalanceAction action) {
  return switch (action) {
    LaunchpadRebalanceAction.buy => 'Mua',
    LaunchpadRebalanceAction.sell => 'Ban',
    LaunchpadRebalanceAction.hold => 'Giu',
  };
}

String _riskLabel(LaunchpadRebalanceRisk risk) {
  return switch (risk) {
    LaunchpadRebalanceRisk.conservative => 'conservative',
    LaunchpadRebalanceRisk.moderate => 'moderate',
    LaunchpadRebalanceRisk.aggressive => 'aggressive',
  };
}

String _money(double value) {
  final whole = value.toStringAsFixed(2);
  final parts = whole.split('.');
  final chars = parts.first.split('').reversed.toList();
  final buffer = StringBuffer();
  for (var i = 0; i < chars.length; i++) {
    if (i > 0 && i % 3 == 0) buffer.write(',');
    buffer.write(chars[i]);
  }
  return '${buffer.toString().split('').reversed.join()}.${parts.last}';
}

String _amount(double value) {
  if (value < 1) return value.toStringAsFixed(4);
  return value.toStringAsFixed(2);
}
