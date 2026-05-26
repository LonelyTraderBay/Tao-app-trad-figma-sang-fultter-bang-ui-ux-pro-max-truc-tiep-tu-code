import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';

class ArenaSafetyCenterPage extends ConsumerWidget {
  const ArenaSafetyCenterPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc198_safety_content');
  static const blockedLinkKey = Key('sc198_blocked_link');
  static const reportsLinkKey = Key('sc198_reports_link');
  static const acknowledgeKey = Key('sc198_acknowledge');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(arenaRepositoryProvider).getArenaSafetyCenter();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-198 ArenaSafetyCenterPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'An toàn & Quy tắc Arena',
              subtitle: 'Trung tâm an toàn · Open Arena',
              showBack: true,
              onBack: () => _close(context),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    customGap: AppSpacing.x5,
                    children: [
                      _SafetyHero(snapshot: snapshot),
                      _SafetySection(
                        title: 'Quy tắc cộng đồng',
                        accentColor: AppColors.primary,
                        children: [
                          for (final rule in snapshot.communityRules)
                            _RuleCard(rule: rule),
                        ],
                      ),
                      _SafetySection(
                        title: 'Nội dung bị cấm',
                        accentColor: AppColors.sell,
                        children: [
                          _BannedContentCard(items: snapshot.bannedContent),
                        ],
                      ),
                      _SafetySection(
                        title: 'Cách báo cáo và chặn',
                        accentColor: AppColors.warn,
                        children: [
                          for (final action in snapshot.reportActions)
                            _RuleCard(rule: action),
                        ],
                      ),
                      _SafetySection(
                        title: 'Quy trình xử lý vi phạm',
                        accentColor: AppColors.buy,
                        children: [
                          _ViolationProcessCard(
                            items: snapshot.violationProcess,
                          ),
                        ],
                      ),
                      _SafetySection(
                        title: 'Cách chốt kết quả',
                        accentColor: AppColors.primary,
                        children: [_InfoCard(info: snapshot.resolution)],
                      ),
                      _SafetySection(
                        title: 'Không giao dịch ngoài nền tảng',
                        accentColor: AppColors.sell,
                        children: [_InfoCard(info: snapshot.offPlatform)],
                      ),
                      _SafetySection(
                        title: 'Về Arena Points',
                        accentColor: AppColors.accent,
                        children: [_InfoCard(info: snapshot.pointsDisclaimer)],
                      ),
                      _QuickLinks(links: snapshot.quickLinks),
                      VitCtaButton(
                        key: acknowledgeKey,
                        onPressed: () => _acknowledge(context),
                        child: Text(snapshot.ctaLabel),
                      ),
                      _SafetyFooter(label: snapshot.footerLabel),
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

  static void _close(BuildContext context) {
    HapticFeedback.selectionClick();
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }

  static void _acknowledge(BuildContext context) {
    HapticFeedback.mediumImpact();
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }
}

class _SafetyHero extends StatelessWidget {
  const _SafetyHero({required this.snapshot});

  final ArenaSafetyCenterSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: AppColors.buy,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          const _ToneIcon(icon: Icons.shield_outlined, color: AppColors.buy),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.bannerTitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.bannerDescription,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SafetySection extends StatelessWidget {
  const _SafetySection({
    required this.title,
    required this.accentColor,
    required this.children,
  });

  final String title;
  final Color accentColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: AppRadii.xsRadius,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final child in children) ...[
          child,
          if (child != children.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({required this.rule});

  final ArenaSafetyRuleDraft rule;

  @override
  Widget build(BuildContext context) {
    final color = _kindColor(rule.kind);
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ToneIcon(icon: _kindIcon(rule.kind), color: color),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule.title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  rule.description,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 12,
                    color: AppColors.text2,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BannedContentCard extends StatelessWidget {
  const _BannedContentCard({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final item in items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.cancel_outlined,
                  size: 15,
                  color: AppColors.sell,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.text1,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            if (item != items.last) const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _ViolationProcessCard extends StatelessWidget {
  const _ViolationProcessCard({required this.items});

  final List<ArenaSafetyProcessDraft> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          for (final item in items)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 30,
                  child: Column(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.buy10,
                          borderRadius: AppRadii.xlRadius,
                          border: Border.all(color: AppColors.buy20),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${item.step}',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.buy,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      if (item != items.last)
                        Container(width: 1, height: 28, color: AppColors.buy20),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: item == items.last ? 0 : AppSpacing.x3,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          item.description,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.info});

  final ArenaSafetyInfoDraft info;

  @override
  Widget build(BuildContext context) {
    final color = _kindColor(info.kind);
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_kindIcon(info.kind), color: color, size: 18),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.title,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      info.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.x3),
          for (final item in info.items) ...[
            _SafetyCheckRow(item: item),
            if (item != info.items.last) const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _SafetyCheckRow extends StatelessWidget {
  const _SafetyCheckRow({required this.item});

  final ArenaSafetyCheckDraft item;

  @override
  Widget build(BuildContext context) {
    final color = item.allowed ? AppColors.buy : AppColors.sell;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          item.allowed ? Icons.check_circle_outline : Icons.cancel_outlined,
          color: color,
          size: 14,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            item.text,
            style: AppTextStyles.caption.copyWith(
              color: item.allowed ? AppColors.text1 : AppColors.text2,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickLinks extends StatelessWidget {
  const _QuickLinks({required this.links});

  final List<ArenaSafetyQuickLinkDraft> links;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final link in links) ...[
          VitCard(
            key: link.route == AppRoutePaths.arenaBlocked
                ? ArenaSafetyCenterPage.blockedLinkKey
                : ArenaSafetyCenterPage.reportsLinkKey,
            onTap: () {
              HapticFeedback.selectionClick();
              context.go(link.route);
            },
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Row(
              children: [
                Icon(
                  _kindIcon(link.kind),
                  color: _kindColor(link.kind),
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(width: AppSpacing.x4),
                Expanded(
                  child: Text(
                    link.title,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.text3),
              ],
            ),
          ),
          if (link != links.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _SafetyFooter extends StatelessWidget {
  const _SafetyFooter({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.menu_book_outlined,
            color: AppColors.primary,
            size: 14,
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToneIcon extends StatelessWidget {
  const _ToneIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.mdRadius,
        border: Border.all(color: color.withValues(alpha: .18)),
      ),
      child: Icon(icon, color: color, size: AppSpacing.iconMd),
    );
  }
}

IconData _kindIcon(ArenaSafetyKind kind) {
  switch (kind) {
    case ArenaSafetyKind.respect:
      return Icons.balance_outlined;
    case ArenaSafetyKind.offPlatform:
      return Icons.block_rounded;
    case ArenaSafetyKind.civil:
      return Icons.menu_book_outlined;
    case ArenaSafetyKind.privacy:
      return Icons.shield_outlined;
    case ArenaSafetyKind.report:
      return Icons.outlined_flag_rounded;
    case ArenaSafetyKind.block:
      return Icons.do_not_disturb_on_outlined;
    case ArenaSafetyKind.process:
      return Icons.fact_check_outlined;
    case ArenaSafetyKind.resolution:
      return Icons.balance_outlined;
    case ArenaSafetyKind.points:
      return Icons.redeem_outlined;
  }
}

Color _kindColor(ArenaSafetyKind kind) {
  switch (kind) {
    case ArenaSafetyKind.respect:
    case ArenaSafetyKind.resolution:
      return AppColors.primary;
    case ArenaSafetyKind.offPlatform:
    case ArenaSafetyKind.report:
      return AppColors.sell;
    case ArenaSafetyKind.civil:
    case ArenaSafetyKind.points:
      return AppColors.accent;
    case ArenaSafetyKind.privacy:
    case ArenaSafetyKind.process:
      return AppColors.buy;
    case ArenaSafetyKind.block:
      return AppModuleAccents.arena;
  }
}
