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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';

part '../widgets/withdraw_limits_page_sections.dart';
part '../widgets/withdraw_limits_page_common.dart';

const _limitsBackground = AppColors.bg;
const _limitsPanel = AppColors.surface;
const _limitsHero = AppColors.surface;
const _limitsHeroBorder = AppColors.primary20;
const _limitsBorder = AppColors.overlayStroke;
const _limitsPrimary = AppColors.primary;
const _limitsGreen = AppColors.buy;
const _limitsAmber = AppColors.caution;
const _limitsMuted = AppColors.text3;

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
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

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
                  padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _CurrentTierCard(snapshot: snapshot),
                      const SizedBox(height: 18),
                      _QuickStats(tier: snapshot.currentTier),
                      const SizedBox(height: 16),
                      const _LimitWarning(),
                      const SizedBox(height: 18),
                      const _SectionLabel(
                        label:
                            'So s\u00E1nh h\u1EA1n m\u1EE9c theo c\u1EA5p KYC',
                      ),
                      const SizedBox(height: 10),
                      for (final tier in snapshot.tiers) ...[
                        _KycTierCard(
                          tier: tier,
                          currentLevel: snapshot.currentLevel,
                        ),
                        if (tier != snapshot.tiers.last)
                          const SizedBox(height: 10),
                      ],
                      const SizedBox(height: 18),
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
