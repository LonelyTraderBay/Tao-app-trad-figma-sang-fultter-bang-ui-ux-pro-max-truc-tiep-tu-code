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

const _limitsGap = AppSpacing.x3;
const _limitsTinyGap = AppSpacing.x1;
const _limitsInlineGap = AppSpacing.x3;
const _limitsIconBox = AppSpacing.buttonCompact;
const _limitsProgressHeight = AppSpacing.x2 + AppSpacing.dividerHairline;

double _limitsScrollBottomInset(BuildContext context, ShellRenderMode mode) {
  return (mode.usesVisualQaFrame
          ? AppSpacing.walletBottomInsetVisualChrome
          : AppSpacing.walletBottomInsetNativeChrome) +
      MediaQuery.paddingOf(context).bottom;
}

class WithdrawLimitsPage extends ConsumerWidget {
  const WithdrawLimitsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc153_withdraw_limits_content');
  static const currentTierKey = Key('sc153_withdraw_limits_current_tier');
  static const dailyUsageKey = Key('sc153_withdraw_limits_daily_usage');
  static const monthlyUsageKey = Key('sc153_withdraw_limits_monthly_usage');
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
        color: AppColors.bg,
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
                child: VitInsetScrollView(
                  key: WithdrawLimitsPage.contentKey,
                  bottomInset: bottomInset,
                  physics: const ClampingScrollPhysics(),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    gap: VitContentGap.tight,
                    children: [
                      _CurrentTierCard(snapshot: snapshot),
                      _QuickStats(tier: snapshot.currentTier),
                      const _LimitWarning(),
                      const VitSectionHeader(
                        title:
                            'So s\u00E1nh h\u1EA1n m\u1EE9c theo c\u1EA5p KYC',
                        icon: Icons.verified_user_outlined,
                        variant: VitSectionHeaderVariant.accentBar,
                        density: VitDensity.compact,
                      ),
                      for (final tier in snapshot.tiers)
                        _KycTierCard(
                          tier: tier,
                          currentLevel: snapshot.currentLevel,
                        ),
                      _FaqCard(faqs: snapshot.faqs),
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
