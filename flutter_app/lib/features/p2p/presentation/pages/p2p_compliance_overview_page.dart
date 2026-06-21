import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

class P2PComplianceOverviewPage extends ConsumerWidget {
  const P2PComplianceOverviewPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc267_p2p_compliance_hero');
  static const checklistKey = Key('sc267_p2p_compliance_checklist');

  static Key itemKey(String id) => Key('sc267_p2p_compliance_item_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(p2pComplianceOverviewProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome +
                  AppSpacing.p2pComplianceBottomInsetVisual
            : DeviceMetrics.nativeBottomChrome +
                  AppSpacing.p2pComplianceBottomInsetNative) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-267 P2PComplianceOverviewPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
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
                    padding: AppSpacing.p2pComplianceScrollPadding(bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.none,
                      fullBleed: true,
                      gap: VitContentGap.tight,
                      children: [
                        _ComplianceHero(snapshot: snapshot),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Compliance Checklist',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ],
                        ),
                        _ComplianceChecklist(items: snapshot.items),
                        const VitCard(
                          variant: VitCardVariant.inner,
                          padding: AppSpacing.p2pComplianceCompactCardPadding,
                          child: VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Compliance checklist review',
                            message:
                                'Checklist status, route targets, incomplete requirements and next compliance action are reviewed before opening P2P flows.',
                            contractId: 'p2p-compliance-overview-review',
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
      ),
    );
  }
}

class _ComplianceHero extends StatelessWidget {
  const _ComplianceHero({required this.snapshot});

  final P2PComplianceOverviewSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PComplianceOverviewPage.heroKey,
      color: AppColors.buy,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.cardLargeRadius,
        side: BorderSide(color: AppColors.buy),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: AppColors.onAccent.withValues(alpha: .20),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.lgRadius,
              ),
              child: const SizedBox(
                width: AppSpacing.x6,
                height: AppSpacing.x6,
                child: Icon(
                  Icons.shield_outlined,
                  color: AppColors.onAccent,
                  size: AppSpacing.iconSm,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.heroTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onAccent,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    snapshot.heroSubtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.onAccent.withValues(alpha: .90),
                      fontWeight: AppTextStyles.bold,
                    ),
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

class _ComplianceChecklist extends StatelessWidget {
  const _ComplianceChecklist({required this.items});

  final List<P2PComplianceItemDraft> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PComplianceOverviewPage.checklistKey,
      radius: VitCardRadius.lg,
      padding: AppSpacing.zeroInsets,
      clip: true,
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            _ComplianceRow(item: items[index]),
            if (index != items.length - 1)
              const Divider(
                height: AppSpacing.p2pComplianceDividerHeight,
                color: AppColors.borderSolid,
              ),
          ],
        ],
      ),
    );
  }
}

class _ComplianceRow extends StatelessWidget {
  const _ComplianceRow({required this.item});

  final P2PComplianceItemDraft item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        key: P2PComplianceOverviewPage.itemKey(item.id),
        onTap: () {
          HapticFeedback.selectionClick();
          context.go(item.route);
        },
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          child: Row(
            children: [
              Material(
                color: AppColors.buy15,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.lgRadius,
                ),
                child: SizedBox(
                  width: AppSpacing.x6,
                  height: AppSpacing.x6,
                  child: Icon(
                    _iconFor(item.iconKey),
                    color: AppColors.buy,
                    size: AppSpacing.iconSm,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      item.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

IconData _iconFor(String key) {
  return switch (key) {
    'file' => Icons.description_outlined,
    'trend' => Icons.trending_up_rounded,
    'money' => Icons.attach_money_rounded,
    _ => Icons.shield_outlined,
  };
}
