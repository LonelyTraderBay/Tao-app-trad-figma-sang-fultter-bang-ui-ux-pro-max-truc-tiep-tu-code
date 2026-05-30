import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

const _leaderPrimary = AppColors.primary;
const _leaderCard = AppColors.surface;
const _leaderPanel = AppColors.surface2;
const _leaderChip = AppColors.surface3;
const _leaderWarningBackground = AppColors.warningBg;
const _leaderWarningBorder = AppColors.warningBorder;
const _leaderWarningText = AppColors.caution;

class ProviderLeaderboardPage extends ConsumerStatefulWidget {
  const ProviderLeaderboardPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc079_provider_leaderboard_content');
  static const verifiedToggleKey = Key('sc079_provider_verified_toggle');
  static Key sortKey(String id) => Key('sc079_sort_$id');
  static Key riskKey(String id) => Key('sc079_risk_$id');
  static Key providerKey(String id) => Key('sc079_provider_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ProviderLeaderboardPage> createState() =>
      _ProviderLeaderboardPageState();
}

class _ProviderLeaderboardPageState
    extends ConsumerState<ProviderLeaderboardPage> {
  late String _sortId;
  late String _riskFilterId;
  late bool _verifiedOnly;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeProviderLeaderboardProvider);
    if (!_initialized) {
      _sortId = snapshot.defaultSortId;
      _riskFilterId = snapshot.defaultRiskFilterId;
      _verifiedOnly = snapshot.defaultVerifiedOnly;
      _initialized = true;
    }

    final providers = _filteredProviders(snapshot);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 126 : 28);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-079 ProviderLeaderboardPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Leaderboard',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: ProviderLeaderboardPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SurvivorshipWarning(snapshot: snapshot),
                    const SizedBox(height: 23),
                    _SortTabs(
                      options: snapshot.sortOptions,
                      activeId: _sortId,
                      onChanged: (id) => setState(() => _sortId = id),
                    ),
                    const SizedBox(height: 25),
                    _RiskFilters(
                      filters: snapshot.riskFilters,
                      activeId: _riskFilterId,
                      onChanged: (id) => setState(() => _riskFilterId = id),
                    ),
                    const SizedBox(height: 12),
                    _VerifiedToggle(
                      label: snapshot.verifiedOnlyLabel,
                      checked: _verifiedOnly,
                      onChanged: (value) =>
                          setState(() => _verifiedOnly = value),
                    ),
                    const SizedBox(height: 27),
                    Text(
                      'Hiển thị ${providers.length} providers',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 28),
                    for (final entry in providers.indexed) ...[
                      _ProviderRankCard(
                        rank: entry.$1 + 1,
                        provider: entry.$2,
                        onOpen: () => context.go(
                          AppRoutePaths.tradeCopyProvider(
                            entry.$2.id,
                            backPath: AppRoutePaths.tradeCopyLeaderboard,
                          ),
                        ),
                      ),
                      if (entry.$2 != providers.last)
                        const SizedBox(height: 13),
                    ],
                    const SizedBox(height: 34),
                    _Disclaimer(text: snapshot.disclaimer),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TradeCopyTrader> _filteredProviders(
    TradeProviderLeaderboardSnapshot snapshot,
  ) {
    final filter = snapshot.riskFilters.firstWhere(
      (item) => item.id == _riskFilterId,
      orElse: () => snapshot.riskFilters.first,
    );
    final providers = snapshot.providers.where((provider) {
      if (filter.riskLevel != null && provider.riskLevel != filter.riskLevel) {
        return false;
      }
      if (_verifiedOnly && !_isProviderVerified(provider)) return false;
      return true;
    }).toList();

    providers.sort((a, b) {
      switch (_sortId) {
        case 'sharpe':
          return b.sharpeRatio.compareTo(a.sharpeRatio);
        case 'followers':
          return b.copiers.compareTo(a.copiers);
        case 'recent':
          return (b.totalPnlPct * .3).compareTo(a.totalPnlPct * .3);
        case 'roi':
        default:
          return b.totalPnlPct.compareTo(a.totalPnlPct);
      }
    });
    return providers;
  }
}

class _SurvivorshipWarning extends StatelessWidget {
  const _SurvivorshipWarning({required this.snapshot});

  final TradeProviderLeaderboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      decoration: BoxDecoration(
        color: _leaderWarningBackground,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _leaderWarningBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _leaderWarningText,
            size: 14,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.warningTitle,
                  style: AppTextStyles.micro.copyWith(
                    color: _leaderWarningText,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  snapshot.warningText,
                  style: AppTextStyles.micro.copyWith(
                    color: _leaderWarningText,
                    fontSize: 9,
                    fontWeight: AppTextStyles.medium,
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

class _SortTabs extends StatelessWidget {
  const _SortTabs({
    required this.options,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeProviderLeaderboardSort> options;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.inputHeight,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _leaderPanel,
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Row(
        children: [
          for (final option in options)
            Expanded(
              child: InkWell(
                key: ProviderLeaderboardPage.sortKey(option.id),
                onTap: () => onChanged(option.id),
                borderRadius: AppRadii.cardRadius,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  alignment: Alignment.center,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: option.id == activeId
                        ? _leaderPrimary
                        : AppColors.transparent,
                    borderRadius: AppRadii.cardRadius,
                  ),
                  child: Text(
                    option.label,
                    style: AppTextStyles.caption.copyWith(
                      color: option.id == activeId
                          ? AppColors.onAccent
                          : AppColors.text3,
                      fontSize: 12,
                      fontWeight: AppTextStyles.bold,
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

class _RiskFilters extends StatelessWidget {
  const _RiskFilters({
    required this.filters,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeProviderLeaderboardRiskFilter> filters;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Risk Level',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 11,
            height: 1,
          ),
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            for (final filter in filters) ...[
              _RiskChip(
                filter: filter,
                selected: filter.id == activeId,
                onTap: () => onChanged(filter.id),
              ),
              if (filter != filters.last) const SizedBox(width: 8),
            ],
          ],
        ),
      ],
    );
  }
}

class _RiskChip extends StatelessWidget {
  const _RiskChip({
    required this.filter,
    required this.selected,
    required this.onTap,
  });

  final TradeProviderLeaderboardRiskFilter filter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ProviderLeaderboardPage.riskKey(filter.id),
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 30,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          color: selected ? _leaderPrimary : _leaderChip,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(
            color: selected ? _leaderPrimary : AppColors.cardBorder,
          ),
        ),
        child: Text(
          filter.label,
          style: AppTextStyles.caption.copyWith(
            color: selected ? AppColors.onAccent : AppColors.text2,
            fontSize: 12,
            fontWeight: selected ? AppTextStyles.bold : AppTextStyles.medium,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _VerifiedToggle extends StatelessWidget {
  const _VerifiedToggle({
    required this.label,
    required this.checked,
    required this.onChanged,
  });

  final String label;
  final bool checked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ProviderLeaderboardPage.verifiedToggleKey,
      onTap: () => onChanged(!checked),
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 49,
        padding: const EdgeInsets.fromLTRB(12, 12, 13, 12),
        decoration: BoxDecoration(
          color: _leaderPanel,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              color: checked ? _leaderPrimary : AppColors.text3,
              size: 14,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
            _TogglePill(checked: checked),
          ],
        ),
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  const _TogglePill({required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: 48,
      height: 24,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: checked ? _leaderPrimary : AppColors.borderSolid,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Align(
        alignment: checked ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: AppColors.onAccent,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _ProviderRankCard extends StatelessWidget {
  const _ProviderRankCard({
    required this.rank,
    required this.provider,
    required this.onOpen,
  });

  final int rank;
  final TradeCopyTrader provider;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final redFlags = _redFlags(provider);

    return InkWell(
      key: ProviderLeaderboardPage.providerKey(provider.id),
      onTap: onOpen,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: redFlags.isEmpty ? 124 : 148,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        decoration: BoxDecoration(
          color: _leaderCard,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RankBadge(rank: rank),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProviderTitle(provider: provider),
                  const SizedBox(height: 9),
                  _MetricsRow(provider: provider),
                  const SizedBox(height: 12),
                  _FollowersLabel(count: provider.copiers),
                  if (redFlags.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        for (final flag in redFlags) _RedFlagPill(flag: flag),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Icon(
                Icons.visibility_outlined,
                color: AppColors.text3,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    final podium = rank <= 3;
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: podium ? _leaderWarningText.withValues(alpha: .12) : _leaderChip,
        shape: BoxShape.circle,
        border: podium
            ? Border.all(color: _leaderWarningText, width: 2)
            : Border.all(color: AppColors.transparent),
      ),
      child: Text(
        '#$rank',
        style: AppTextStyles.caption.copyWith(
          color: podium ? _leaderWarningText : AppColors.text2,
          fontSize: 14,
          fontWeight: AppTextStyles.bold,
          height: 1,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
    );
  }
}

class _ProviderTitle extends StatelessWidget {
  const _ProviderTitle({required this.provider});

  final TradeCopyTrader provider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            provider.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontSize: 14,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
        if (_isProviderVerified(provider)) ...[
          const SizedBox(width: 7),
          const Icon(
            Icons.check_circle_outline_rounded,
            color: _leaderPrimary,
            size: 12,
          ),
        ],
        const SizedBox(width: 7),
        _RiskBadge(riskLevel: provider.riskLevel),
      ],
    );
  }
}

class _RiskBadge extends StatelessWidget {
  const _RiskBadge({required this.riskLevel});

  final TradeCopyRiskLevel riskLevel;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(riskLevel);
    return Container(
      height: 22,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _riskLabel(riskLevel),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 11,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _MetricsRow extends StatelessWidget {
  const _MetricsRow({required this.provider});

  final TradeCopyTrader provider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricValue(
            label: 'ROI',
            value: _formatSignedPercent(provider.totalPnlPct),
            color: provider.totalPnlPct >= 0 ? AppColors.buy : AppColors.sell,
          ),
        ),
        Expanded(
          child: _MetricValue(
            label: 'Sharpe',
            value: provider.sharpeRatio.toStringAsFixed(2),
          ),
        ),
        Expanded(
          child: _MetricValue(
            label: 'Max DD',
            value: '${provider.maxDrawdown.toStringAsFixed(1)}%',
            color: AppColors.sell,
          ),
        ),
      ],
    );
  }
}

class _MetricValue extends StatelessWidget {
  const _MetricValue({
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
        const SizedBox(height: 6),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontSize: 13,
            fontWeight: AppTextStyles.bold,
            height: 1,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _FollowersLabel extends StatelessWidget {
  const _FollowersLabel({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.group_outlined, color: AppColors.text3, size: 10),
        const SizedBox(width: 4),
        Text(
          '${_formatInteger(count)} followers',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
            height: 1,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _RedFlagPill extends StatelessWidget {
  const _RedFlagPill({required this.flag});

  final String flag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.sell10,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.sell,
            size: 9,
          ),
          const SizedBox(width: 3),
          Text(
            flag,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.sell,
              fontSize: 10,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 15),
      decoration: BoxDecoration(
        color: _leaderPanel,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontSize: 9,
          height: 1.5,
        ),
      ),
    );
  }
}

bool _isProviderVerified(TradeCopyTrader provider) {
  return provider.sharpeRatio >= 2 ||
      provider.riskLevel == TradeCopyRiskLevel.low;
}

List<String> _redFlags(TradeCopyTrader provider) {
  final flags = <String>[];
  if (provider.maxDrawdown > 20) flags.add('High drawdown');
  if (provider.sharpeRatio < 1) flags.add('Low Sharpe');
  if (provider.totalPnlPct > 100 && provider.totalTrades < 50) {
    flags.add('Low sample size');
  }
  return flags;
}

Color _riskColor(TradeCopyRiskLevel riskLevel) {
  switch (riskLevel) {
    case TradeCopyRiskLevel.low:
      return AppColors.buy;
    case TradeCopyRiskLevel.medium:
      return _leaderWarningText;
    case TradeCopyRiskLevel.high:
      return AppColors.sell;
  }
}

String _riskLabel(TradeCopyRiskLevel riskLevel) {
  switch (riskLevel) {
    case TradeCopyRiskLevel.low:
      return 'LOW';
    case TradeCopyRiskLevel.medium:
      return 'MEDIUM';
    case TradeCopyRiskLevel.high:
      return 'HIGH';
  }
}

String _formatSignedPercent(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(1)}%';
}

String _formatInteger(int value) {
  final chars = value.toString().split('').reversed.toList();
  final groups = <String>[];
  for (var i = 0; i < chars.length; i += 3) {
    groups.add(chars.skip(i).take(3).toList().reversed.join());
  }
  return groups.reversed.join(',');
}
