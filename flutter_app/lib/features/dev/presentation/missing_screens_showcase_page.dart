import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/dev_tools_repository.dart';

class MissingScreensShowcasePage extends ConsumerStatefulWidget {
  const MissingScreensShowcasePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc398_missing_screens_content');
  static const tabsKey = Key('sc398_missing_screens_tabs');
  static const newSectionKey = Key('sc398_missing_screens_new');
  static const v2SectionKey = Key('sc398_missing_screens_v2');
  static Key screenKey(String id) => Key('sc398_screen_$id');
  static Key v2PageKey(String id) => Key('sc398_v2_$id');
  static Key flowKey(String id) => Key('sc398_flow_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MissingScreensShowcasePage> createState() =>
      _MissingScreensShowcasePageState();
}

class _MissingScreensShowcasePageState
    extends ConsumerState<MissingScreensShowcasePage> {
  String _activeTab = 'new';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(missingScreensShowcaseRepositoryProvider)
        .getShowcase();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-398 MissingScreensShowcasePage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              variant: VitHeaderVariant.custom,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.contentPad,
                  AppSpacing.x4,
                  AppSpacing.contentPad,
                  AppSpacing.x3,
                ),
                child: _ShowcaseTitle(snapshot: snapshot),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: MissingScreensShowcasePage.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  gap: VitContentGap.defaultGap,
                  children: [
                    VitTabBar(
                      key: MissingScreensShowcasePage.tabsKey,
                      tabs: [
                        for (final tab in snapshot.tabs)
                          VitTabItem(key: tab.id, label: tab.label),
                      ],
                      activeKey: _activeTab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _activeTab = tab);
                      },
                      variant: VitTabBarVariant.segment,
                    ),
                    if (_activeTab == 'new')
                      _NewScreensSection(snapshot: snapshot)
                    else
                      _V2ScreensSection(snapshot: snapshot),
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

class _ShowcaseTitle extends StatelessWidget {
  const _ShowcaseTitle({required this.snapshot});

  final MissingScreensShowcaseSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _IconBadge(
          icon: Icons.layers_outlined,
          color: Colors.white,
          background: AppColors.primary,
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snapshot.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.baseMedium.copyWith(
                  fontSize: 18,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                snapshot.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NewScreensSection extends StatelessWidget {
  const _NewScreensSection({required this.snapshot});

  final MissingScreensShowcaseSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: MissingScreensShowcasePage.newSectionKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          snapshot.newScreensIntro,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final screen in snapshot.newScreens) ...[
          _NewScreenCard(screen: screen, onTap: () => context.go(screen.route)),
          if (screen != snapshot.newScreens.last)
            const SizedBox(height: AppSpacing.x4),
        ],
      ],
    );
  }
}

class _V2ScreensSection extends StatelessWidget {
  const _V2ScreensSection({required this.snapshot});

  final MissingScreensShowcaseSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: MissingScreensShowcasePage.v2SectionKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          snapshot.v2Intro,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final page in snapshot.v2Pages) ...[
          _V2PageCard(page: page, onTap: () => context.go(page.route)),
          if (page != snapshot.v2Pages.last)
            const SizedBox(height: AppSpacing.x4),
        ],
        const SizedBox(height: AppSpacing.x5),
        Text(
          'Prototype Connections (On Tap → Navigate)',
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          radius: VitCardRadius.lg,
          clip: true,
          child: Column(
            children: [
              for (final flow in snapshot.flowConnections) ...[
                _FlowRow(flow: flow, onTap: () => context.go(flow.fromRoute)),
                if (flow != snapshot.flowConnections.last) const _Divider(),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          radius: VitCardRadius.md,
          borderColor: AppColors.primary20,
          child: Text(
            'Header back buttons giữ hành vi history và các dynamic preview dùng route mẫu an toàn.',
            style: AppTextStyles.caption.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _NewScreenCard extends StatelessWidget {
  const _NewScreenCard({required this.screen, required this.onTap});

  final DevShowcaseScreenDraft screen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForId(screen.id);

    return VitCard(
      key: MissingScreensShowcasePage.screenKey(screen.id),
      padding: const EdgeInsets.all(AppSpacing.x4),
      radius: VitCardRadius.lg,
      borderColor: _borderForId(screen.id),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _IconBadge(
                icon: _iconForId(screen.id),
                color: accent,
                background: _backgroundForId(screen.id),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      screen.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      screen.route,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _PreviewPill(color: accent),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            screen.description,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final state in screen.states) _StateChip(label: state),
            ],
          ),
        ],
      ),
    );
  }
}

class _V2PageCard extends StatelessWidget {
  const _V2PageCard({required this.page, required this.onTap});

  final DevShowcaseV2PageDraft page;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForId(page.id);

    return VitCard(
      key: MissingScreensShowcasePage.v2PageKey(page.id),
      padding: const EdgeInsets.all(AppSpacing.x4),
      radius: VitCardRadius.lg,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _IconBadge(
                icon: _iconForId(page.id),
                color: accent,
                background: _backgroundForId(page.id),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      page.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      page.route,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
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
          const SizedBox(height: AppSpacing.x3),
          for (final change in page.changes) ...[
            _ChangeRow(text: change, color: accent),
            if (change != page.changes.last)
              const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _FlowRow extends StatelessWidget {
  const _FlowRow({required this.flow, required this.onTap});

  final DevShowcaseFlowDraft flow;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForId(flow.id);

    return InkWell(
      key: MissingScreensShowcasePage.flowKey(flow.id),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                  child: const SizedBox(
                    width: AppSpacing.x3,
                    height: AppSpacing.x3,
                  ),
                ),
                Container(
                  width: AppSpacing.x1,
                  height: AppSpacing.x4,
                  color: _backgroundForId(flow.id),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: accent,
                  size: AppSpacing.iconSm,
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: AppSpacing.x2,
                    children: [
                      Text(
                        flow.from,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.medium,
                          fontSize: 12,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.text3,
                        size: AppSpacing.iconSm,
                      ),
                      Text(
                        flow.to,
                        style: AppTextStyles.caption.copyWith(
                          color: accent,
                          fontWeight: AppTextStyles.medium,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    flow.trigger,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.mdRadius,
        border: Border.all(color: _borderFromColor(color)),
      ),
      child: SizedBox(
        width: AppSpacing.ctaHeight,
        height: AppSpacing.ctaHeight,
        child: Icon(icon, color: color, size: AppSpacing.iconMd),
      ),
    );
  }
}

class _PreviewPill extends StatelessWidget {
  const _PreviewPill({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _borderFromColor(color),
        borderRadius: AppRadii.inputRadius,
        border: Border.all(color: _borderFromColor(color)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.visibility_outlined,
              color: color,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              'Preview',
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StateChip extends StatelessWidget {
  const _StateChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.inputRadius,
        border: Border.all(color: AppColors.borderSolid),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _ChangeRow extends StatelessWidget {
  const _ChangeRow({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.auto_awesome_rounded, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: AppColors.divider);
  }
}

Color _accentForId(String id) {
  return switch (id) {
    'p2p_orders' || 'p2p' || 'reset_login' => AppColors.buy,
    'wallet_tx' || 'wallet' || 'order_detail' => AppColors.accent,
    'security' || 'security_activity' || 'security_orders' => AppColors.warn,
    _ => AppColors.primary,
  };
}

Color _backgroundForId(String id) {
  return switch (id) {
    'p2p_orders' || 'p2p' || 'reset_login' => AppColors.buy15,
    'wallet_tx' || 'wallet' || 'order_detail' => AppColors.accent15,
    'security' || 'security_activity' || 'security_orders' => AppColors.warn15,
    _ => AppColors.primary12,
  };
}

Color _borderForId(String id) {
  return switch (id) {
    'p2p_orders' || 'p2p' || 'reset_login' => AppColors.buy20,
    'wallet_tx' || 'wallet' || 'order_detail' => AppColors.accent20,
    'security' || 'security_activity' || 'security_orders' => AppColors.warn15,
    _ => AppColors.primary20,
  };
}

Color _borderFromColor(Color color) {
  if (color == AppColors.buy) return AppColors.buy20;
  if (color == AppColors.accent) return AppColors.accent20;
  if (color == AppColors.warn) return AppColors.warn15;
  return AppColors.primary20;
}

IconData _iconForId(String id) {
  return switch (id) {
    'reset_password' || 'otp_reset' || 'otp' => Icons.lock_outline_rounded,
    'p2p_orders' || 'p2p' => Icons.shopping_cart_outlined,
    'wallet_tx' || 'wallet' => Icons.receipt_long_outlined,
    'security' ||
    'security_activity' ||
    'security_orders' => Icons.verified_user_outlined,
    _ => Icons.layers_outlined,
  };
}
