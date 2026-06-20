import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part '../widgets/withdraw_limits_page_sections.dart';
part '../widgets/withdraw_limits_page_common.dart';

const _limitsBackground = AppColors.bg;
const _limitsHeroBorder = AppColors.primary20;
const _limitsBorder = AppColors.overlayStroke;
const _limitsPrimary = AppColors.primary;
const _limitsGreen = AppColors.buy;
const _limitsAmber = AppColors.caution;
const _limitsMuted = AppColors.text3;
const _limitsNativeBottomClearance = 88.0;
const _limitsVisualBottomClearance = 112.0;
const _limitsScrollTopPad = 0.0;
const _limitsGap = 8.0;
const _limitsTinyGap = 4.0;
const _limitsInlineGap = 8.0;
const _limitsIconBox = 38.0;
const _limitsStatHeight = 50.0;
const _limitsTierHeight = 72.0;
const _limitsProgressHeight = 6.0;
const _limitsCardPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 12);
const _limitsTierPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
const _limitsCompactStatPadding = EdgeInsets.symmetric(
  horizontal: 8,
  vertical: 6,
);

double _limitsScrollBottomInset(BuildContext context, ShellRenderMode mode) {
  return (mode.usesVisualQaFrame
          ? _limitsVisualBottomClearance
          : _limitsNativeBottomClearance) +
      MediaQuery.paddingOf(context).bottom;
}

class WithdrawLimitsPage extends ConsumerWidget {
  const WithdrawLimitsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc153_withdraw_limits_content');
  static const upgradeKycKey = Key('sc153_withdraw_limits_upgrade_kyc');
  static Key tierKey(int level) => Key('sc153_withdraw_limits_tier_$level');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(walletWithdrawLimitsProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset = _limitsScrollBottomInset(context, mode);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-153 WithdrawLimitsPage',
      child: Material(
        color: _limitsBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'H\u1EA1n m\u1EE9c r\u00FAt ti\u1EC1n',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.wallet),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: WithdrawLimitsPage.contentKey,
                  padding: AppSpacing.contentInsets.copyWith(
                    top: _limitsScrollTopPad,
                    bottom: bottomInset,
                  ),
                  physics: const BouncingScrollPhysics(),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    density: VitDensity.compact,
                    fullBleed: true,
                    children: [
                      _CurrentTierCard(snapshot: snapshot),
                      _QuickStats(tier: snapshot.currentTier),
                      const VitSectionHeader(
                        title:
                            'So s\u00E1nh h\u1EA1n m\u1EE9c theo c\u1EA5p KYC',
                        variant: VitSectionHeaderVariant.accentBar,
                      ),
                      for (final tier in snapshot.tiers)
                        _KycTierCard(
                          tier: tier,
                          currentLevel: snapshot.currentLevel,
                        ),
                      const _LimitWarning(),
                      _FaqCard(faqs: snapshot.faqs),
                      VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Review withdrawal limits',
                        message:
                            'Confirm daily limit, remaining quota, KYC tier, fee policy, and next step before withdrawal.',
                        contractId:
                            'Current tier: ${snapshot.currentTier.name}',
                        density: VitDensity.compact,
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
}
