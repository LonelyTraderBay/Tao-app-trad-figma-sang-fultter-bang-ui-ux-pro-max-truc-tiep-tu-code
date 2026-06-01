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
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';

part '../widgets/arena_safety_center_page_sections.dart';
part '../widgets/arena_safety_center_page_common.dart';

class ArenaSafetyCenterPage extends ConsumerWidget {
  const ArenaSafetyCenterPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc198_safety_content');
  static const blockedLinkKey = Key('sc198_blocked_link');
  static const reportsLinkKey = Key('sc198_reports_link');
  static const acknowledgeKey = Key('sc198_acknowledge');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(arenaReadModelControllerProvider)
        .getArenaSafetyCenter();
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
