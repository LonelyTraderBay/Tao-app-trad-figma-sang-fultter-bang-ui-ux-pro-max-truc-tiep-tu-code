import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

import '../widgets/trade_body_review_widgets.dart';

const _kidBackground = AppColors.bg;
const _kidBorder = AppColors.borderSolid;
const _kidPrimary = AppColors.primary;
const _kidGreen = AppColors.buy;
const _kidScrollTopGap = AppSpacing.x3;
const _kidNoticeToPreviewGap = AppSpacing.x3;
const _kidPreviewToSectionGap = AppSpacing.x4;
const _kidSectionHeaderGap = AppSpacing.x2;
const _kidSectionCardGap = AppSpacing.x2;
const _kidSectionToActionsGap = AppSpacing.x3;
const _kidStackGap = AppSpacing.x3;
const _kidPreviewPadding = EdgeInsetsDirectional.fromSTEB(
  AppSpacing.x4,
  AppSpacing.x4,
  AppSpacing.x4,
  AppSpacing.x4,
);
const _kidSectionCardPadding = EdgeInsetsDirectional.symmetric(
  horizontal: AppSpacing.x3,
  vertical: AppSpacing.x2,
);
const _kidMetricPadding = EdgeInsetsDirectional.fromSTEB(
  AppSpacing.x3,
  AppSpacing.x1,
  AppSpacing.x3,
  AppSpacing.x1,
);
const _kidPreviewIconBox = AppSpacing.searchBarCompactHeight;
const _kidPreviewIconSize = AppSpacing.iconMd;
const _kidMetricHeight = AppSpacing.searchBarCompactHeight;
const _kidSectionRowHeight = AppSpacing.buttonCompact;
const _kidSectionIconBox = AppSpacing.buttonCompact;
const _kidSectionStatusRadius = AppSpacing.x3;
const _kidSectionStatusIcon = AppSpacing.tradeBotSmallIcon;

EdgeInsets _kidScrollPadding(double bottomInset) => EdgeInsets.fromLTRB(
  AppSpacing.contentPad,
  _kidScrollTopGap,
  AppSpacing.contentPad,
  bottomInset,
);

class KIDGeneratorPage extends ConsumerWidget {
  const KIDGeneratorPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc108_kid_content');
  static const previewKey = Key('sc108_kid_preview');
  static const downloadKey = Key('sc108_kid_download');
  static Key sectionKey(String title) =>
      Key('sc108_kid_section_${title.toLowerCase().replaceAll(' ', '_')}');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getKidGenerator();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 70
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-108 KIDGeneratorPage',
      child: Material(
        color: _kidBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Key Information Document',
            subtitle: 'PRIIPs KID',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeCopyExAnteCosts),
            actions: const [
              VitHeaderActionItem(
                type: VitHeaderActionType.export,
                onPressed: null,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: KIDGeneratorPage.contentKey,
                  padding: _kidScrollPadding(bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _RegulatoryNotice(),
                      const SizedBox(height: _kidNoticeToPreviewGap),
                      _KidPreviewCard(document: snapshot.document),
                      const SizedBox(height: _kidPreviewToSectionGap),
                      const VitSectionHeader(
                        title: 'Document Sections',
                        variant: VitSectionHeaderVariant.accentBar,
                        accentColor: _kidPrimary,
                      ),
                      const SizedBox(height: _kidSectionHeaderGap),
                      for (final section in snapshot.sections) ...[
                        _KidSectionCard(section: section),
                        if (section != snapshot.sections.last)
                          const SizedBox(height: _kidSectionCardGap),
                      ],
                      const SizedBox(height: _kidSectionToActionsGap),
                      const _Actions(),
                      const SizedBox(height: _kidStackGap),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        padding: AppSpacing.cardPaddingCompact,
                        child: VitHighRiskStatePanel(
                          state: VitHighRiskUiState.riskReview,
                          title: 'KID document review required',
                          message:
                              'Risk indicator, performance scenarios, costs, holding period and download next steps are reviewed before distribution.',
                          contractId: 'kid-generator-review',
                        ),
                      ),
                      const SizedBox(height: _kidStackGap),
                      const TradeBodyReviewSection(
                        title: 'KID body review',
                        message: 'KID generator body reviewed',
                        detail:
                            'Document preview, sections, download, risk indicator, empty, and result states stay visible.',
                        primary:
                            'Regulatory notice remains above the generated document preview.',
                        secondary:
                            'Document sections stay visible before download actions.',
                        tertiary:
                            'Distribution copy remains disclosure-focused and non-promotional.',
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

class _RegulatoryNotice extends StatelessWidget {
  const _RegulatoryNotice();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.tradeBotClientMoneyNoticePadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.text1,
            size: AppSpacing.tradeBotCheckboxIcon,
          ),
          const SizedBox(width: AppSpacing.tradeBotRowGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mandatory PRIIPs Document',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.tradeBotSmallGap),
                Text(
                  'This Key Information Document must be provided before you '
                  'invest. It contains essential information in a standardized '
                  'format (max 3 pages).',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
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

class _KidPreviewCard extends StatelessWidget {
  const _KidPreviewCard({required this.document});

  final TradeKidDocument document;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: _kidPreviewPadding,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VitCard(
                width: _kidPreviewIconBox,
                height: _kidPreviewIconBox,
                variant: VitCardVariant.ghost,
                borderColor: _kidPrimary.withValues(alpha: .24),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.description_outlined,
                  color: _kidPrimary,
                  size: _kidPreviewIconSize,
                ),
              ),
              const SizedBox(width: AppSpacing.tradeBotRowGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.title,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      'Last updated: ${document.lastUpdated} • '
                      'Version ${document.version}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: _kidStackGap),
          Row(
            children: [
              Expanded(
                child: _DocumentMetric(
                  label: 'Document Type',
                  value: document.documentType,
                ),
              ),
              const SizedBox(width: AppSpacing.tradeBotRowGap),
              Expanded(
                child: _DocumentMetric(
                  label: 'Pages',
                  value: '${document.pages} / ${document.maxPages}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DocumentMetric extends StatelessWidget {
  const _DocumentMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: _kidMetricHeight,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: _kidMetricPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            style: AppTextStyles.captionSm.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _KidSectionCard extends StatelessWidget {
  const _KidSectionCard({required this.section});

  final TradeKidSection section;

  @override
  Widget build(BuildContext context) {
    return _Card(
      key: KIDGeneratorPage.sectionKey(section.title),
      padding: _kidSectionCardPadding,
      child: SizedBox(
        height: _kidSectionRowHeight,
        child: Row(
          children: [
            SizedBox(
              width: _kidSectionIconBox,
              height: _kidSectionIconBox,
              child: Icon(
                _iconFor(section.icon),
                color: _kidPrimary,
                size: AppSpacing.inputPrefixIcon,
              ),
            ),
            const SizedBox(width: AppSpacing.tradeBotSmallGap),
            Expanded(
              child: Text(
                section.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const CircleAvatar(
              radius: _kidSectionStatusRadius,
              backgroundColor: AppColors.buy10,
              child: Icon(
                Icons.check_circle_outline_rounded,
                color: _kidGreen,
                size: _kidSectionStatusIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            key: KIDGeneratorPage.previewKey,
            icon: Icons.remove_red_eye_outlined,
            label: 'Preview KID',
            filled: false,
            onPressed: () {},
          ),
        ),
        const SizedBox(width: _kidSectionCardGap),
        Expanded(
          child: _ActionButton(
            icon: Icons.download_rounded,
            label: 'Download PDF',
            filled: true,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.filled,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      height: AppSpacing.searchBarCompactHeight,
      variant: filled
          ? VitCtaButtonVariant.primary
          : VitCtaButtonVariant.secondary,
      onPressed: onPressed,
      leading: Icon(icon),
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({super.key, required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: padding,
      borderColor: _kidBorder.withValues(alpha: .72),
      child: child,
    );
  }
}

IconData _iconFor(TradeKidSectionIcon icon) {
  return switch (icon) {
    TradeKidSectionIcon.info => Icons.info_outline_rounded,
    TradeKidSectionIcon.target => Icons.adjust_rounded,
    TradeKidSectionIcon.warning => Icons.warning_amber_rounded,
    TradeKidSectionIcon.chart => Icons.bar_chart_rounded,
    TradeKidSectionIcon.costs => Icons.attach_money_rounded,
    TradeKidSectionIcon.clock => Icons.schedule_rounded,
    TradeKidSectionIcon.help => Icons.help_outline_rounded,
  };
}
