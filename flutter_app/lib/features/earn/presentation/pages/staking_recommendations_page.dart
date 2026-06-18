import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_recommendations_common.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_recommendations_overview.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_recommendations_sheet.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_recommendations_strategy.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';

class StakingRecommendationsPage extends ConsumerStatefulWidget {
  const StakingRecommendationsPage({super.key, this.shellRenderMode});

  static const heroKey = StakingRecommendationsKeys.hero;
  static const profileKey = StakingRecommendationsKeys.profile;
  static const amountFieldKey = StakingRecommendationsKeys.amountField;
  static const strategyListKey = StakingRecommendationsKeys.strategyList;
  static const detailCtaKey = StakingRecommendationsKeys.detailCta;
  static const riskButtonKey = StakingRecommendationsKeys.riskButton;
  static const tipsKey = StakingRecommendationsKeys.tips;

  static Key strategyKey(String id) => StakingRecommendationsKeys.strategy(id);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingRecommendationsPage> createState() =>
      _StakingRecommendationsPageState();
}

class _StakingRecommendationsPageState
    extends ConsumerState<StakingRecommendationsPage> {
  String _amountText = '10000';

  double get _amount => double.tryParse(_amountText) ?? 0;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingRecommendationsRepositoryProvider)
        .getRecommendations();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-372 StakingRecommendationsPage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: AppSpacing.earnBottomInsetPadding(bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    gap: VitContentGap.defaultGap,
                    children: [
                      VitCard(
                        variant: VitCardVariant.standard,
                        radius: VitCardRadius.md,
                        padding: AppSpacing.zeroInsets,
                        child: StakingRecommendationsHeroCard(
                          snapshot: snapshot,
                        ),
                      ),
                      StakingRecommendationsProfileCard(snapshot: snapshot),
                      StakingRecommendationsAmountSimulator(
                        amountText: _amountText,
                        onAmountChanged: (value) =>
                            setState(() => _amountText = value),
                      ),
                      VitPageSection(
                        label: 'Chiến lược được Đề xuất',
                        accentColor: AppColors.primarySoft,
                        children: [
                          Column(
                            key: StakingRecommendationsKeys.strategyList,
                            children: [
                              for (final strategy in snapshot.strategies) ...[
                                StakingRecommendationsStrategyCard(
                                  key: StakingRecommendationsKeys.strategy(
                                    strategy.id,
                                  ),
                                  strategy: strategy,
                                  amount: _amount,
                                  onTap: () => _openStrategySheet(
                                    strategy,
                                    snapshot.stakingRoute,
                                  ),
                                ),
                                if (strategy != snapshot.strategies.last)
                                  const SizedBox(height: AppSpacing.x3),
                              ],
                            ],
                          ),
                        ],
                      ),
                      VitPageSection(
                        key: StakingRecommendationsKeys.tips,
                        label: 'Tips Cá nhân hóa',
                        accentColor: AppColors.primarySoft,
                        children: [
                          Column(
                            children: [
                              for (final tip in snapshot.tips) ...[
                                StakingRecommendationsTipCard(tip: tip),
                                if (tip != snapshot.tips.last)
                                  const SizedBox(height: AppSpacing.x3),
                              ],
                            ],
                          ),
                        ],
                      ),
                      StakingRecommendationsDisclaimer(
                        text: snapshot.disclaimer,
                      ),
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

  Future<void> _openStrategySheet(
    StakingStrategyDraft strategy,
    String stakingRoute,
  ) async {
    HapticFeedback.selectionClick();
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.86,
          child: DecoratedBox(
            decoration: const ShapeDecoration(
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.sheetTopRadius,
              ),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: AppSpacing.earnSheetContentPadding,
                child: StakingRecommendationsStrategyDetailSheet(
                  strategy: strategy,
                  amount: _amount,
                  stakingRoute: stakingRoute,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
