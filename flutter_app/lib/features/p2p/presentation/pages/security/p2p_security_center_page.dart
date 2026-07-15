import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
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
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

part '../../widgets/security/p2p_security_center_score_features.dart';
part '../../widgets/security/p2p_security_center_actions_events.dart';

const double _p2pSecurityScoreBox = 108;
const double _p2pSecurityScoreTrack = 98;
const double _p2pSecurityIconBox = P2PSpacingTokens.p2pSecurityCenterIconBox;
const double _p2pSecurityDividerExtent = AppSpacing.dividerHairline;
const double _p2pSecurityNumberLine =
    P2PSpacingTokens.p2pSecurityCenterNumberLineHeight;
const double _p2pSecurityBodyLine =
    P2PSpacingTokens.p2pSecurityCenterBodyLineHeight;
const double _p2pSecurityCompactLine =
    P2PSpacingTokens.p2pSecurityCenterCompactLineHeight;
const double _p2pSecurityLabelLine =
    P2PSpacingTokens.p2pSecurityCenterLabelLineHeight;
const EdgeInsetsGeometry _p2pSecurityCompactPadding = EdgeInsetsDirectional.all(
  AppSpacing.x3,
);

class P2PSecurityCenterPage extends ConsumerWidget {
  const P2PSecurityCenterPage({super.key, this.shellRenderMode});

  static const scoreKey = Key('sc253_p2p_security_score');
  static const featuresKey = Key('sc253_p2p_security_features');
  static const quickActionsKey = Key('sc253_p2p_security_quick_actions');
  static const eventsKey = Key('sc253_p2p_security_events');
  static const viewAllKey = Key('sc253_p2p_security_view_all');

  static Key featureKey(String id) => Key('sc253_p2p_security_feature_$id');
  static Key quickActionKey(String id) =>
      Key('sc253_p2p_security_quick_action_$id');
  static Key eventKey(String id) => Key('sc253_p2p_security_event_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(p2pSecurityCenterProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? SharedSpacingTokens.bottomNavVisualClearance
        : SharedSpacingTokens.bottomNavNativeClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-253 P2PSecurityCenterPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Trung tâm bảo mật',
            subtitle: 'Bảo mật · P2P',
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
            actions: [
              VitHeaderActionItem(
                type: VitHeaderActionType.settings,
                onPressed: () {
                  HapticFeedback.selectionClick();
                  context.go(snapshot.settingsRoute);
                },
              ),
            ],
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
                    padding: EdgeInsetsDirectional.only(
                      start: AppSpacing.contentPad,
                      top: AppSpacing.x3,
                      end: AppSpacing.contentPad,
                      bottom: scrollEndPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SecurityScoreCard(snapshot: snapshot),
                        const SizedBox(
                          height: AppSpacing.pageRhythmStandardInnerGap,
                        ),
                        _SecurityFeatures(
                          features: snapshot.features,
                          onOpen: (route) {
                            HapticFeedback.selectionClick();
                            context.go(route);
                          },
                        ),
                        _QuickActions(
                          actions: snapshot.quickActions,
                          onOpen: (route) {
                            HapticFeedback.selectionClick();
                            context.go(route);
                          },
                        ),
                        const SizedBox(
                          height: AppSpacing.pageRhythmStandardSectionGap,
                        ),
                        _RecentEvents(events: snapshot.recentEvents),
                        const SizedBox(
                          height: AppSpacing.pageRhythmStandardInnerGap,
                        ),
                        VitCard(
                          key: P2PSecurityCenterPage.viewAllKey,
                          radius: VitCardRadius.large,
                          variant: VitCardVariant.inner,
                          padding: AppSpacing.zeroInsets,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            context.go(snapshot.loginHistoryRoute);
                          },
                          child: Padding(
                            padding: P2PSpacingTokens
                                .p2pSecurityCenterViewAllPadding,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Xem tất cả hoạt động',
                                  style: AppTextStyles.baseMedium.copyWith(
                                    color: AppColors.text2,
                                    fontWeight: AppTextStyles.bold,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.x1),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppColors.text3,
                                  size: AppSpacing.iconSm,
                                ),
                              ],
                            ),
                          ),
                        ),
                        VitPageContent(
                          rhythm: VitPageRhythm.standard,
                          padding: VitContentPadding.compact,
                          density: VitDensity.compact,
                          children: const [
                            VitHighRiskStatePanel(
                              density: VitDensity.compact,
                              state: VitHighRiskUiState.riskReview,
                              title: 'Security center state review',
                              message:
                                  'Security score, feature status, quick actions, recent events, settings route, and login history route stay visible before sensitive P2P security changes.',
                              contractId: 'SC-253',
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

class P2PWhitelistModePage extends ConsumerWidget {
  const P2PWhitelistModePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc404_p2p_whitelist_mode_content');
  static const devicesKey = Key('sc404_p2p_whitelist_devices');
  static const antiPhishingKey = Key('sc404_p2p_whitelist_anti_phishing');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(p2pSecurityCenterProvider);
    final trustedDevicesRoute = snapshot.features
        .firstWhere((feature) => feature.id == 'trusted_devices')
        .route;
    final antiPhishingRoute = snapshot.features
        .firstWhere((feature) => feature.id == 'anti_phishing')
        .route;
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? SharedSpacingTokens.bottomNavVisualClearance
        : SharedSpacingTokens.bottomNavNativeClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-404 P2PWhitelistModePage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Chế độ whitelist',
            subtitle: 'Bảo mật · P2P',
            showBack: true,
            onBack: () => context.go('/p2p/security/center'),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: contentKey,
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsetsDirectional.only(
                    start: AppSpacing.contentPad,
                    top: AppSpacing.x3,
                    end: AppSpacing.contentPad,
                    bottom: scrollEndPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      VitCard(
                        radius: VitCardRadius.large,
                        padding: _p2pSecurityCompactPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _IconBadge(
                              icon: Icons.shield_outlined,
                              color: AppModuleAccents.p2p,
                            ),
                            const SizedBox(
                              height: AppSpacing.pageRhythmStandardInnerGap,
                            ),
                            Text(
                              'Danh sách thiết bị tin cậy',
                              style: AppTextStyles.sectionTitle,
                            ),
                            const SizedBox(
                              height: AppSpacing.pageRhythmCompactInnerGap,
                            ),
                            Text(
                              'Chỉ thiết bị đã rà soát và phiên thanh toán được bảo vệ mới tiếp tục các thao tác P2P nhạy cảm.',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                                height: _p2pSecurityBodyLine,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardInnerGap,
                      ),
                      _WhitelistAction(
                        key: devicesKey,
                        icon: Icons.desktop_windows_rounded,
                        title: 'Rà soát thiết bị tin cậy',
                        body:
                            'Kiểm tra thiết bị gần đây trước khi bật whitelist P2P nghiêm ngặt hơn.',
                        onTap: () {
                          HapticFeedback.selectionClick();
                          context.go(trustedDevicesRoute);
                        },
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardInnerGap,
                      ),
                      _WhitelistAction(
                        key: antiPhishingKey,
                        icon: Icons.gpp_good_outlined,
                        title: 'Xác nhận mã chống phishing',
                        body:
                            'Giữ tin nhắn thanh toán và escrow dễ nhận biết trước khi đổi quy tắc whitelist.',
                        onTap: () {
                          HapticFeedback.selectionClick();
                          context.go(antiPhishingRoute);
                        },
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardSectionGap,
                      ),
                      VitCtaButton(
                        density: VitDensity.compact,
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          context.go('/p2p/security/center');
                        },
                        child: const Text('Quay lại Trung tâm bảo mật'),
                      ),
                      VitPageContent(
                        padding: VitContentPadding.compact,
                        density: VitDensity.compact,
                        children: const [
                          VitHighRiskStatePanel(
                            density: VitDensity.compact,
                            state: VitHighRiskUiState.riskReview,
                            title: 'Whitelist mode state review',
                            message:
                                'Trusted-device path, anti-phishing route, whitelist scope, and return action remain visible before enforcing stricter P2P device access.',
                            contractId: 'SC-404',
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
      ),
    );
  }
}
