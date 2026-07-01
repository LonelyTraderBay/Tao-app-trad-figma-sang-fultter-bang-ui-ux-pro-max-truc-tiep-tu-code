import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part '../widgets/p2p_kyc_requirements_page_sections.dart';
part '../widgets/p2p_kyc_requirements_page_common.dart';

const double _p2pKycVisualNavClearance = 112;
const double _p2pKycNativeNavClearance = 88;
const double _p2pKycIconBoxExtent = AppSpacing.inputHeight - AppSpacing.x2;
const double _p2pKycRequirementIconBoxExtent = AppSpacing.x6;
const double _p2pKycReadableLineHeight = 1.35;
const double _p2pKycTitleLineHeight = 1.0;
const double _p2pKycSmallIconExtent = AppSpacing.p2pHomeSmallIcon;
const double _p2pKycChecklistIconExtent = AppSpacing.p2pHomeVerifiedIcon;
const double _p2pKycDividerExtent = AppSpacing.dividerHairline;
const double _p2pKycCtaHeight = AppSpacing.ctaHeight - AppSpacing.x1;

class P2PKycRequirementsPage extends ConsumerWidget {
  const P2PKycRequirementsPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc247_p2p_kyc_requirements_hero');
  static const noticeKey = Key('sc247_p2p_kyc_requirements_notice');
  static Key tierKey(int tierId) =>
      Key('sc247_p2p_kyc_requirements_tier_$tierId');
  static Key upgradeKey(int tierId) =>
      Key('sc247_p2p_kyc_requirements_upgrade_$tierId');
  static const supportKey = Key('sc247_p2p_kyc_requirements_support');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(p2pKycRequirementsProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? _p2pKycVisualNavClearance
        : _p2pKycNativeNavClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-247 P2PKycRequirementsPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'P2P KYC Requirements',
            subtitle: 'KYC · P2P',
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: AppSpacing.p2pKycRequirementsScrollPadding(
                      scrollEndPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _KycHero(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x3),
                        _KycNotice(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x3),
                        for (final tier in snapshot.tiers) ...[
                          _KycTierCard(
                            tier: tier,
                            onUpgrade: tier.status == P2PKycTierStatus.available
                                ? () {
                                    HapticFeedback.selectionClick();
                                    context.go(
                                      snapshot.verifyRouteFor(tier.id),
                                    );
                                  }
                                : null,
                          ),
                          if (tier != snapshot.tiers.last)
                            const SizedBox(height: AppSpacing.x3),
                        ],
                        const SizedBox(height: AppSpacing.x3),
                        _KycSupportCard(snapshot: snapshot),
                        VitPageContent(
                          padding: VitContentPadding.compact,
                          density: VitDensity.compact,
                          children: const [
                            VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'KYC requirement state review',
                              message:
                                  'Current tier, locked requirements, available upgrade action, support path, and P2P limit impact remain visible before starting verification.',
                              contractId: 'SC-247',
                              density: VitDensity.compact,
                            ),
                          ],
                        ),
                      ],
                    ),
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
