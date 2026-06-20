import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/provider_leaderboard_controls.dart';
part '../widgets/provider_leaderboard_cards.dart';
part '../widgets/provider_leaderboard_disclaimer.dart';

const _leaderPrimary = AppColors.primary;
const _leaderChip = AppColors.surface3;
const _leaderWarningBorder = AppColors.warningBorder;
const _leaderWarningText = AppColors.caution;
const double _leaderVisualScrollClearance = 108;
const double _leaderNativeScrollClearance = 72;
const double _leaderSpace = AppSpacing.x2;
const double _leaderTinySpace = AppSpacing.x1;
const double _leaderControlExtent = 44;
const double _leaderLineFlat = 1.05;
const double _leaderLineReadable = 1.24;
const double _leaderLineLoose = 1.32;

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
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _leaderVisualScrollClearance
            : _leaderNativeScrollClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-079 ProviderLeaderboardPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Leaderboard',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: ProviderLeaderboardPage.contentKey,
                  padding: EdgeInsets.only(bottom: scrollEndClearance),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    fullBleed: true,
                    children: [
                      _SurvivorshipWarning(snapshot: snapshot),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        padding: AppSpacing.providerLeaderboardReviewPadding,
                        child: VitHighRiskStatePanel(
                          state: VitHighRiskUiState.riskReview,
                          title: 'Provider leaderboard review',
                          message:
                              'Ranking, verified status, risk level, drawdown, copier limits and provider details are reviewed before copying.',
                          contractId: 'provider-leaderboard-review',
                          density: VitDensity.compact,
                        ),
                      ),
                      _SortTabs(
                        options: snapshot.sortOptions,
                        activeId: _sortId,
                        onChanged: (id) => setState(() => _sortId = id),
                      ),
                      _RiskFilters(
                        filters: snapshot.riskFilters,
                        activeId: _riskFilterId,
                        onChanged: (id) => setState(() => _riskFilterId = id),
                      ),
                      _VerifiedToggle(
                        label: snapshot.verifiedOnlyLabel,
                        checked: _verifiedOnly,
                        onChanged: (value) =>
                            setState(() => _verifiedOnly = value),
                      ),
                      Text(
                        'Hiển thị ${providers.length} providers',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height: _leaderLineFlat,
                        ),
                      ),
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
                      ],
                      _Disclaimer(text: snapshot.disclaimer),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
