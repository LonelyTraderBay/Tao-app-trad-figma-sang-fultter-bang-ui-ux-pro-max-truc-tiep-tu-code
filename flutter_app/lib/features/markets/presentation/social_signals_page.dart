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
import '../data/market_repository.dart';

const _marketPrimary = AppColors.primary;

class SocialSignalsPage extends ConsumerStatefulWidget {
  const SocialSignalsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc025_social_signals_scroll_content');
  static const signalsTabKey = Key('sc025_tab_signals');
  static const providersTabKey = Key('sc025_tab_providers');
  static const performanceTabKey = Key('sc025_tab_performance');
  static const statusAllKey = Key('sc025_status_all');
  static const statusActiveKey = Key('sc025_status_active');
  static const statusTargetHitKey = Key('sc025_status_target_hit');
  static const statusStoppedKey = Key('sc025_status_stopped');
  static const categoryAllKey = Key('sc025_category_all');
  static const categoryScalpKey = Key('sc025_category_scalp');
  static const categorySwingKey = Key('sc025_category_swing');
  static const categoryPositionKey = Key('sc025_category_position');

  static Key signalCardKey(String id) => Key('sc025_signal_$id');
  static Key providerCardKey(String name) => Key('sc025_provider_$name');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SocialSignalsPage> createState() => _SocialSignalsPageState();
}

class _SocialSignalsPageState extends ConsumerState<SocialSignalsPage> {
  String _tab = 'signals';
  TradingSignalStatus? _statusFilter;
  TradingSignalCategory? _categoryFilter;
  String? _expandedId;

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(marketRepositoryProvider);
    final snapshot = repo.getSocialSignals(
      statusFilter: _statusFilter,
      categoryFilter: _categoryFilter,
    );
    final allSnapshot = repo.getSocialSignals();
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
      semanticLabel: 'SC-025 SocialSignalsPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Tín hiệu giao dịch',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.markets),
            ),
            _SocialSignalsTabs(
              activeTab: _tab,
              onChanged: (value) => setState(() => _tab = value),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: SocialSignalsPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 12,
                    children: [
                      const _RiskDisclaimerCard(),
                      if (_tab == 'signals') ...[
                        _StatusFilterChips(
                          statusFilter: _statusFilter,
                          statusConfigs: snapshot.statusConfigs,
                          onSelected: (value) => setState(() {
                            _statusFilter = value;
                          }),
                        ),
                        _CategoryFilterChips(
                          categoryFilter: _categoryFilter,
                          onSelected: (value) => setState(() {
                            _categoryFilter = value;
                          }),
                        ),
                        if (snapshot.signals.isEmpty)
                          const _SignalsEmptyState()
                        else
                          for (final signal in snapshot.signals)
                            _SignalCard(
                              key: SocialSignalsPage.signalCardKey(signal.id),
                              signal: signal,
                              tierConfig:
                                  snapshot.tierConfigs[signal.providerTier]!,
                              statusConfig:
                                  snapshot.statusConfigs[signal.status]!,
                              expanded: _expandedId == signal.id,
                              onTap: () => setState(() {
                                _expandedId = _expandedId == signal.id
                                    ? null
                                    : signal.id;
                              }),
                            ),
                      ] else if (_tab == 'providers') ...[
                        for (
                          var index = 0;
                          index < allSnapshot.providers.length;
                          index += 1
                        )
                          _ProviderCard(
                            key: SocialSignalsPage.providerCardKey(
                              allSnapshot.providers[index].name,
                            ),
                            rank: index + 1,
                            provider: allSnapshot.providers[index],
                            tierConfig:
                                allSnapshot.tierConfigs[allSnapshot
                                    .providers[index]
                                    .tier]!,
                          ),
                      ] else ...[
                        _PerformanceSummary(snapshot: allSnapshot),
                        _StatusBreakdown(snapshot: allSnapshot),
                        const _SectionHeader(
                          label: 'Kết quả tín hiệu',
                          accentColor: _marketPrimary,
                        ),
                        for (final signal
                            in allSnapshot.signals
                                .where(
                                  (signal) =>
                                      signal.status !=
                                      TradingSignalStatus.active,
                                )
                                .toList()
                              ..sort((a, b) => b.pnlPct.compareTo(a.pnlPct)))
                          _SignalResultRow(
                            signal: signal,
                            statusConfig:
                                allSnapshot.statusConfigs[signal.status]!,
                          ),
                      ],
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

class _SocialSignalsTabs extends StatelessWidget {
  const _SocialSignalsTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SizedBox(
        height: 54,
        child: Row(
          children: [
            _UnderlinedTab(
              key: SocialSignalsPage.signalsTabKey,
              label: 'Tín hiệu',
              value: 'signals',
              active: activeTab == 'signals',
              onChanged: onChanged,
            ),
            _UnderlinedTab(
              key: SocialSignalsPage.providersTabKey,
              label: 'Nhà cung cấp',
              value: 'providers',
              active: activeTab == 'providers',
              onChanged: onChanged,
            ),
            _UnderlinedTab(
              key: SocialSignalsPage.performanceTabKey,
              label: 'Hiệu suất',
              value: 'performance',
              active: activeTab == 'performance',
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _UnderlinedTab extends StatelessWidget {
  const _UnderlinedTab({
    super.key,
    required this.label,
    required this.value,
    required this.active,
    required this.onChanged,
  });

  final String label;
  final String value;
  final bool active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onChanged(value),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? _marketPrimary : AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 2,
              child: FractionallySizedBox(
                widthFactor: active ? 1 : 0,
                child: const ColoredBox(color: _marketPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiskDisclaimerCard extends StatelessWidget {
  const _RiskDisclaimerCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.shield_outlined, color: AppColors.warn, size: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Tín hiệu từ cộng đồng chỉ mang tính tham khảo. Không phải khuyến nghị đầu tư. Luôn tự nghiên cứu và quản lý rủi ro.',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusFilterChips extends StatelessWidget {
  const _StatusFilterChips({
    required this.statusFilter,
    required this.statusConfigs,
    required this.onSelected,
  });

  final TradingSignalStatus? statusFilter;
  final Map<TradingSignalStatus, SignalStatusConfig> statusConfigs;
  final ValueChanged<TradingSignalStatus?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChipButton(
            key: SocialSignalsPage.statusAllKey,
            label: 'Tất cả',
            active: statusFilter == null,
            color: const Color(0xFF6B7280),
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: 8),
          _FilterChipButton(
            key: SocialSignalsPage.statusActiveKey,
            label: statusConfigs[TradingSignalStatus.active]!.label,
            active: statusFilter == TradingSignalStatus.active,
            color: statusConfigs[TradingSignalStatus.active]!.color,
            onTap: () => onSelected(TradingSignalStatus.active),
          ),
          const SizedBox(width: 8),
          _FilterChipButton(
            key: SocialSignalsPage.statusTargetHitKey,
            label: statusConfigs[TradingSignalStatus.targetHit]!.label,
            active: statusFilter == TradingSignalStatus.targetHit,
            color: statusConfigs[TradingSignalStatus.targetHit]!.color,
            onTap: () => onSelected(TradingSignalStatus.targetHit),
          ),
          const SizedBox(width: 8),
          _FilterChipButton(
            key: SocialSignalsPage.statusStoppedKey,
            label: statusConfigs[TradingSignalStatus.stopped]!.label,
            active: statusFilter == TradingSignalStatus.stopped,
            color: statusConfigs[TradingSignalStatus.stopped]!.color,
            onTap: () => onSelected(TradingSignalStatus.stopped),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilterChips extends StatelessWidget {
  const _CategoryFilterChips({
    required this.categoryFilter,
    required this.onSelected,
  });

  final TradingSignalCategory? categoryFilter;
  final ValueChanged<TradingSignalCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CategoryChip(
          key: SocialSignalsPage.categoryAllKey,
          label: 'Tất cả',
          active: categoryFilter == null,
          onTap: () => onSelected(null),
        ),
        const SizedBox(width: 8),
        _CategoryChip(
          key: SocialSignalsPage.categoryScalpKey,
          label: 'Scalp',
          active: categoryFilter == TradingSignalCategory.scalp,
          onTap: () => onSelected(TradingSignalCategory.scalp),
        ),
        const SizedBox(width: 8),
        _CategoryChip(
          key: SocialSignalsPage.categorySwingKey,
          label: 'Swing',
          active: categoryFilter == TradingSignalCategory.swing,
          onTap: () => onSelected(TradingSignalCategory.swing),
        ),
        const SizedBox(width: 8),
        _CategoryChip(
          key: SocialSignalsPage.categoryPositionKey,
          label: 'Position',
          active: categoryFilter == TradingSignalCategory.position,
          onTap: () => onSelected(TradingSignalCategory.position),
        ),
      ],
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    super.key,
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: .12) : AppColors.surface2,
          border: Border.all(
            color: active ? color.withValues(alpha: .30) : Colors.transparent,
          ),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: active ? color : AppColors.text3,
            fontSize: 12,
            fontWeight: AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
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
      borderRadius: AppRadii.smRadius,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _marketPrimary.withValues(alpha: .12)
              : Colors.transparent,
          borderRadius: AppRadii.smRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: active ? _marketPrimary : AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _SignalCard extends StatelessWidget {
  const _SignalCard({
    super.key,
    required this.signal,
    required this.tierConfig,
    required this.statusConfig,
    required this.expanded,
    required this.onTap,
  });

  final TradingSignalDraft signal;
  final SignalTierConfig tierConfig;
  final SignalStatusConfig statusConfig;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final directionColor = signal.direction == TradingSignalDirection.long
        ? AppColors.buy
        : AppColors.sell;
    final directionLabel = signal.direction == TradingSignalDirection.long
        ? '▲ LONG'
        : '▼ SHORT';

    return VitCard(
      clip: true,
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      signal.providerAvatar,
                      style: const TextStyle(fontSize: 16, height: 1),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        signal.providerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    _TinyBadge(
                      label: tierConfig.label,
                      color: tierConfig.color,
                      background: tierConfig.background,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${signal.providerWinRate.toStringAsFixed(1)}% win',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 8,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      signal.timeAgo,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _TinyBadge(
                      label: directionLabel,
                      color: directionColor,
                      background: directionColor.withValues(alpha: .12),
                      horizontalPadding: 8,
                      height: 20,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        signal.pair,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _TinyBadge(
                      label: statusConfig.label,
                      color: statusConfig.color,
                      background: statusConfig.color.withValues(alpha: .12),
                      height: 18,
                      fontSize: 8,
                    ),
                    const SizedBox(width: 6),
                    _TinyBadge(
                      label: _categoryLabel(signal.category).toLowerCase(),
                      color: AppColors.text3,
                      background: AppColors.surface2,
                      height: 18,
                      fontSize: 8,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _SignalMetric(
                        label: 'Entry',
                        value: _formatPrice(signal.entry),
                      ),
                    ),
                    Expanded(
                      child: _SignalMetric(
                        label: 'Hiện tại',
                        value: _formatPrice(signal.currentPrice),
                      ),
                    ),
                    Expanded(
                      child: _SignalMetric(
                        label: 'Stop Loss',
                        value: _formatPrice(signal.stopLoss),
                        valueColor: AppColors.sell,
                      ),
                    ),
                    Expanded(
                      child: _SignalMetric(
                        label: 'PnL',
                        value: _formatPercent(signal.pnlPct),
                        valueColor: signal.pnlPct >= 0
                            ? AppColors.buy
                            : AppColors.sell,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (expanded) _ExpandedSignalDetail(signal: signal),
        ],
      ),
    );
  }
}

class _ExpandedSignalDetail extends StatelessWidget {
  const _ExpandedSignalDetail({required this.signal});

  final TradingSignalDraft signal;

  @override
  Widget build(BuildContext context) {
    final confidence = _confidenceMeta(signal.confidence);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderSolid)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mục tiêu',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              for (var index = 0; index < signal.targets.length; index += 1)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == signal.targets.length - 1 ? 0 : 8,
                    ),
                    child: Container(
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.buy10,
                        border: Border.all(color: AppColors.buy20),
                        borderRadius: AppRadii.smRadius,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'TP${index + 1}',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                          Text(
                            _formatPrice(signal.targets[index]),
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.buy,
                              fontSize: 12,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Độ tin cậy: ',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              Text(
                confidence.label,
                style: AppTextStyles.micro.copyWith(
                  color: confidence.color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: 14),
              const Icon(
                Icons.schedule_rounded,
                size: 12,
                color: AppColors.text3,
              ),
              const SizedBox(width: 4),
              Text(
                signal.expiresIn,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            signal.reasoning,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.favorite_border_rounded,
                size: 14,
                color: AppColors.text3,
              ),
              const SizedBox(width: 4),
              Text(
                '${signal.likes}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(width: 18),
              const Icon(
                Icons.content_copy_rounded,
                size: 14,
                color: AppColors.text3,
              ),
              const SizedBox(width: 4),
              Text(
                '${signal.copies} copies',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SignalMetric extends StatelessWidget {
  const _SignalMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({
    required this.label,
    required this.color,
    required this.background,
    this.height = 16,
    this.fontSize = 7,
    this.horizontalPadding = 5,
  });

  final String label;
  final Color color;
  final Color background;
  final double height;
  final double fontSize;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: fontSize,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({
    super.key,
    required this.rank,
    required this.provider,
    required this.tierConfig,
  });

  final int rank;
  final SignalProviderSummary provider;
  final SignalTierConfig tierConfig;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: rank <= 3
                      ? tierConfig.color.withValues(alpha: .15)
                      : AppColors.surface2,
                  border: Border.all(
                    color: rank <= 3 ? tierConfig.color : AppColors.borderSolid,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$rank',
                  style: AppTextStyles.micro.copyWith(
                    color: rank <= 3 ? tierConfig.color : AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(provider.avatar, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            provider.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        _TinyBadge(
                          label: tierConfig.label,
                          color: tierConfig.color,
                          background: tierConfig.background,
                          fontSize: 9,
                          height: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${_formatCompact(provider.followers.toDouble())} followers · ${provider.totalSignals} tín hiệu',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${provider.winRate.toStringAsFixed(1)}%',
                    style: AppTextStyles.base.copyWith(
                      color: provider.winRate >= 65
                          ? AppColors.buy
                          : AppColors.warn,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    'Win rate',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: AppColors.divider),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ProviderMetric(
                  label: 'Đang active',
                  value: '${provider.activeSignals}',
                  color: _marketPrimary,
                ),
              ),
              Expanded(
                child: _ProviderMetric(
                  label: 'Tổng signals',
                  value: '${provider.totalSignals}',
                ),
              ),
              Expanded(
                child: _ProviderMetric(
                  label: 'TB PnL',
                  value: _formatPercent(provider.avgPnl),
                  color: provider.avgPnl >= 0 ? AppColors.buy : AppColors.sell,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProviderMetric extends StatelessWidget {
  const _ProviderMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        Text(
          value,
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _PerformanceSummary extends StatelessWidget {
  const _PerformanceSummary({required this.snapshot});

  final MarketSocialSignalsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hiệu suất tổng hợp',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: 'Win rate',
                  value: '${snapshot.overallWinRate.toStringAsFixed(1)}%',
                  color: AppColors.warn,
                ),
              ),
              Expanded(
                child: _HeroMetric(
                  label: 'TB PnL',
                  value: _formatPercent(snapshot.avgPnl),
                  color: snapshot.avgPnl >= 0 ? AppColors.buy : AppColors.sell,
                ),
              ),
              Expanded(
                child: _HeroMetric(
                  label: 'Tổng signals',
                  value: '${snapshot.totalSignals}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(
            color: color,
            fontSize: 20,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.portfolioTextMuted,
          ),
        ),
      ],
    );
  }
}

class _StatusBreakdown extends StatelessWidget {
  const _StatusBreakdown({required this.snapshot});

  final MarketSocialSignalsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final counts = <TradingSignalStatus, int>{
      for (final status in snapshot.statusConfigs.keys)
        status: snapshot.signals
            .where((signal) => signal.status == status)
            .length,
    };

    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phân bổ trạng thái',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: AppRadii.smRadius,
            child: SizedBox(
              height: 12,
              child: Row(
                children: [
                  for (final entry in counts.entries)
                    if (entry.value > 0)
                      Expanded(
                        flex: entry.value,
                        child: ColoredBox(
                          color: snapshot.statusConfigs[entry.key]!.color,
                        ),
                      ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              for (final entry in counts.entries)
                if (entry.value > 0)
                  _LegendItem(
                    color: snapshot.statusConfigs[entry.key]!.color,
                    label:
                        '${snapshot.statusConfigs[entry.key]!.label}: ${entry.value}',
                  ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _SignalResultRow extends StatelessWidget {
  const _SignalResultRow({required this.signal, required this.statusConfig});

  final TradingSignalDraft signal;
  final SignalStatusConfig statusConfig;

  @override
  Widget build(BuildContext context) {
    final positive = signal.pnlPct >= 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        children: [
          Icon(
            positive ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: positive ? AppColors.buy : AppColors.sell,
            size: 16,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      signal.pair,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _TinyBadge(
                      label: signal.direction == TradingSignalDirection.long
                          ? 'LONG'
                          : 'SHORT',
                      color: signal.direction == TradingSignalDirection.long
                          ? AppColors.buy
                          : AppColors.sell,
                      background:
                          signal.direction == TradingSignalDirection.long
                          ? AppColors.buy10
                          : AppColors.sell10,
                      fontSize: 8,
                      height: 17,
                    ),
                  ],
                ),
                Text(
                  '${signal.providerName} · ${signal.timeAgo}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Text(
            _formatPercent(signal.pnlPct),
            style: AppTextStyles.caption.copyWith(
              color: positive ? AppColors.buy : AppColors.sell,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.accentColor});

  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _SignalsEmptyState extends StatelessWidget {
  const _SignalsEmptyState();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.track_changes_rounded,
              size: 32,
              color: AppColors.text3.withValues(alpha: .35),
            ),
            const SizedBox(height: 12),
            Text(
              'Không có tín hiệu phù hợp',
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

_ConfidenceMeta _confidenceMeta(TradingSignalConfidence confidence) {
  return switch (confidence) {
    TradingSignalConfidence.high => const _ConfidenceMeta('Cao', AppColors.buy),
    TradingSignalConfidence.medium => const _ConfidenceMeta(
      'TB',
      AppColors.warn,
    ),
    TradingSignalConfidence.low => const _ConfidenceMeta(
      'Thấp',
      AppColors.text3,
    ),
  };
}

final class _ConfidenceMeta {
  const _ConfidenceMeta(this.label, this.color);

  final String label;
  final Color color;
}

String _categoryLabel(TradingSignalCategory category) {
  return switch (category) {
    TradingSignalCategory.scalp => 'Scalp',
    TradingSignalCategory.swing => 'Swing',
    TradingSignalCategory.position => 'Position',
  };
}

String _formatPrice(double value) {
  final decimals = value >= 1
      ? 2
      : value >= 0.01
      ? 4
      : 6;
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var index = 0; index < whole.length; index += 1) {
    if (index > 0 && (whole.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(whole[index]);
  }
  return '${buffer.toString()}.${parts.last}';
}

String _formatPercent(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _formatCompact(double value) {
  final abs = value.abs();
  if (abs >= 1000000) return '${(value / 1000000).toStringAsFixed(2)}M';
  if (abs >= 1000) {
    final scaled = value / 1000;
    final fixed = scaled % 1 == 0
        ? scaled.toStringAsFixed(0)
        : scaled.toStringAsFixed(1);
    return '${fixed}K';
  }
  return value.toStringAsFixed(0);
}
