import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/p2p_repository.dart';

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
    final snapshot = ref.watch(p2pRepositoryProvider).getSecurityCenter();
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

class _HeaderSettingsButton extends StatelessWidget {
  const _HeaderSettingsButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.searchBg,
          border: Border.all(color: AppColors.border),
          borderRadius: AppRadii.mdRadius,
        ),
        child: IconButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.settings_outlined,
            color: AppColors.text1,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _SecurityScoreCard extends StatelessWidget {
  const _SecurityScoreCard({required this.snapshot});

  final P2PSecurityCenterSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final progress = snapshot.score / snapshot.maxScore;

    return VitCard(
      key: P2PSecurityCenterPage.scoreKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Security Score',
                      style: AppTextStyles.sectionTitle.copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      snapshot.scoreSubtitle,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(
                label: snapshot.scoreLabel,
                color: AppColors.buy,
                prominent: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Center(
            child: SizedBox(
              width: 128,
              height: 128,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.square(
                    dimension: 118,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 7,
                      strokeCap: StrokeCap.round,
                      backgroundColor: AppColors.surface2,
                      color: AppColors.buy,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${snapshot.score}',
                        style: AppTextStyles.heroNumber.copyWith(
                          color: AppColors.buy,
                          fontSize: 32,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        '/ ${snapshot.maxScore}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.buy10,
              borderRadius: AppRadii.mdRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x3,
              ),
              child: Text(
                snapshot.scoreBody,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.45,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityFeatures extends StatelessWidget {
  const _SecurityFeatures({required this.features, required this.onOpen});

  final List<P2PSecurityFeatureDraft> features;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PSecurityCenterPage.featuresKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle('Tính năng bảo mật'),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          radius: VitCardRadius.lg,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var index = 0; index < features.length; index++) ...[
                _SecurityFeatureRow(
                  feature: features[index],
                  onTap: () => onOpen(features[index].route),
                ),
                if (index != features.length - 1)
                  const Divider(height: 1, color: AppColors.divider),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SecurityFeatureRow extends StatelessWidget {
  const _SecurityFeatureRow({required this.feature, required this.onTap});

  final P2PSecurityFeatureDraft feature;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(feature.status);

    return InkWell(
      key: P2PSecurityCenterPage.featureKey(feature.id),
      onTap: onTap,
      borderRadius: AppRadii.lgRadius,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          children: [
            _IconBadge(icon: _featureIcon(feature.iconKey), color: color),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature.label,
                    style: AppTextStyles.baseMedium.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          _statusLabel(feature.status),
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: color,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      if (feature.scoreDelta > 0) ...[
                        const SizedBox(width: AppSpacing.x2),
                        Text(
                          '+ ${feature.scoreDelta} điểm',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconMd,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.actions, required this.onOpen});

  final List<P2PSecurityQuickActionDraft> actions;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PSecurityCenterPage.quickActionsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle('Thao tác nhanh'),
        const SizedBox(height: AppSpacing.x4),
        GridView.builder(
          itemCount: actions.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.x3,
            mainAxisSpacing: AppSpacing.x3,
            childAspectRatio: 1.66,
          ),
          itemBuilder: (context, index) {
            final action = actions[index];
            return _QuickActionCard(
              action: action,
              onTap: () => onOpen(action.route),
            );
          },
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.action, required this.onTap});

  final P2PSecurityQuickActionDraft action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _actionColor(action.colorKey);

    return VitCard(
      key: P2PSecurityCenterPage.quickActionKey(action.id),
      radius: VitCardRadius.lg,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.borderSolid,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _IconBadge(icon: _quickActionIcon(action.iconKey), color: color),
          Text(
            action.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentEvents extends StatelessWidget {
  const _RecentEvents({required this.events});

  final List<P2PSecurityEventDraft> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PSecurityCenterPage.eventsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle('Hoạt động gần đây'),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          radius: VitCardRadius.lg,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var index = 0; index < events.length; index++) ...[
                _SecurityEventRow(event: events[index]),
                if (index != events.length - 1)
                  const Divider(height: 1, color: AppColors.divider),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SecurityEventRow extends StatelessWidget {
  const _SecurityEventRow({required this.event});

  final P2PSecurityEventDraft event;

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(event.severity);

    return Padding(
      key: P2PSecurityCenterPage.eventKey(event.id),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBadge(icon: _eventIcon(event.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.label,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  event.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: AppColors.text3,
                      size: 11,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Text(
                      event.time,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.baseMedium.copyWith(fontWeight: AppTextStyles.bold),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Icon(icon, color: color, size: AppSpacing.iconMd),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
    this.prominent = false,
  });

  final String label;
  final Color color;
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: prominent ? .14 : .1),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

Color _statusColor(P2PSecurityStatus status) {
  return switch (status) {
    P2PSecurityStatus.enabled => AppColors.buy,
    P2PSecurityStatus.warning => AppColors.warn,
    P2PSecurityStatus.disabled => AppColors.text3,
  };
}

String _statusLabel(P2PSecurityStatus status) {
  return switch (status) {
    P2PSecurityStatus.enabled => 'Đã bật',
    P2PSecurityStatus.warning => 'Cần xem lại',
    P2PSecurityStatus.disabled => 'Chưa bật',
  };
}

Color _severityColor(P2PSecurityEventSeverity severity) {
  return switch (severity) {
    P2PSecurityEventSeverity.info => AppColors.buy,
    P2PSecurityEventSeverity.warning => AppColors.warn,
    P2PSecurityEventSeverity.critical => AppColors.sell,
  };
}

Color _actionColor(String colorKey) {
  return switch (colorKey) {
    'success' => AppColors.buy,
    'warning' => AppColors.warn,
    'danger' => AppColors.sell,
    'p2p' => AppModuleAccents.p2p,
    _ => AppColors.primary,
  };
}

IconData _featureIcon(String key) {
  return switch (key) {
    'phone' => Icons.phone_iphone_rounded,
    'anti_phishing' => Icons.gpp_good_outlined,
    'devices' => Icons.desktop_windows_rounded,
    'whitelist' => Icons.shield_outlined,
    'biometric' => Icons.fingerprint_rounded,
    _ => Icons.security_rounded,
  };
}

IconData _quickActionIcon(String key) {
  return switch (key) {
    'password' => Icons.key_rounded,
    'history' => Icons.history_rounded,
    'devices' => Icons.desktop_windows_rounded,
    'alert' => Icons.warning_amber_rounded,
    _ => Icons.security_rounded,
  };
}

IconData _eventIcon(String key) {
  return switch (key) {
    'success' => Icons.check_circle_outline_rounded,
    'device' => Icons.desktop_windows_rounded,
    'failed' => Icons.cancel_outlined,
    _ => Icons.info_outline_rounded,
  };
}
