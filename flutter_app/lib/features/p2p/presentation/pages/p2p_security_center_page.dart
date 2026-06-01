import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part '../widgets/p2p_security_center_score_features.dart';
part '../widgets/p2p_security_center_actions_events.dart';

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
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-253 P2PSecurityCenterPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Security Center',
              subtitle: 'Bảo mật · P2P',
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
              trailing: _HeaderSettingsButton(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  context.go(snapshot.settingsRoute);
                },
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SecurityScoreCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
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
                      const SizedBox(height: AppSpacing.x6),
                      _RecentEvents(events: snapshot.recentEvents),
                      const SizedBox(height: AppSpacing.x3),
                      VitCard(
                        key: P2PSecurityCenterPage.viewAllKey,
                        radius: VitCardRadius.lg,
                        variant: VitCardVariant.inner,
                        padding: EdgeInsets.zero,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          context.go(snapshot.loginHistoryRoute);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.x3,
                            horizontal: AppSpacing.x4,
                          ),
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

class P2PWhitelistModePage extends ConsumerWidget {
  const P2PWhitelistModePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc253_p2p_whitelist_mode_content');
  static const devicesKey = Key('sc253_p2p_whitelist_devices');
  static const antiPhishingKey = Key('sc253_p2p_whitelist_anti_phishing');

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
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-253 P2PWhitelistModePage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Whitelist Mode',
              subtitle: 'Security Center · P2P',
              showBack: true,
              onBack: () => context.go('/p2p/security/center'),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.contentPad,
                  AppSpacing.x4,
                  AppSpacing.contentPad,
                  bottomInset,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    VitCard(
                      radius: VitCardRadius.lg,
                      padding: const EdgeInsets.all(AppSpacing.x5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _IconBadge(
                            icon: Icons.shield_outlined,
                            color: AppModuleAccents.p2p,
                          ),
                          const SizedBox(height: AppSpacing.x4),
                          Text(
                            'Trusted device whitelist',
                            style: AppTextStyles.sectionTitle,
                          ),
                          const SizedBox(height: AppSpacing.x2),
                          Text(
                            'Only reviewed devices and protected payment sessions can continue sensitive P2P actions.',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    _WhitelistAction(
                      key: devicesKey,
                      icon: Icons.desktop_windows_rounded,
                      title: 'Review trusted devices',
                      body:
                          'Check recent devices before enabling stricter P2P allow-lists.',
                      onTap: () {
                        HapticFeedback.selectionClick();
                        context.go(trustedDevicesRoute);
                      },
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    _WhitelistAction(
                      key: antiPhishingKey,
                      icon: Icons.gpp_good_outlined,
                      title: 'Confirm anti-phishing code',
                      body:
                          'Keep payment and escrow messages recognizable before changing whitelist rules.',
                      onTap: () {
                        HapticFeedback.selectionClick();
                        context.go(antiPhishingRoute);
                      },
                    ),
                    const SizedBox(height: AppSpacing.x5),
                    VitCtaButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        context.go('/p2p/security/center');
                      },
                      child: const Text('Back to Security Center'),
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
