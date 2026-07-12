import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

const _kidBorder = AppColors.borderSolid;
const _kidPrimary = AppColors.primary;
const _kidGreen = AppColors.buy;
const _kidSectionCardGap = AppSpacing.x2;
const _kidStackGap = AppSpacing.x3;
const _kidPreviewPadding = WalletSpacingTokens.kidGeneratorPreviewPadding;
const _kidSectionCardPadding =
    WalletSpacingTokens.kidGeneratorSectionCardPadding;
const _kidMetricPadding = WalletSpacingTokens.kidGeneratorMetricPadding;
const _kidPreviewIconBox = AppSpacing.searchBarCompactHeight;
const _kidPreviewIconSize = AppSpacing.iconMd;
const _kidMetricHeight = AppSpacing.searchBarCompactHeight;
const _kidSectionRowHeight = AppSpacing.buttonCompact;
const _kidSectionIconBox = AppSpacing.buttonCompact;
const _kidSectionStatusRadius = AppSpacing.x3;
const _kidSectionStatusIcon = TradeSpacingTokens.tradeBotSmallIcon;

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
    return VitTradeHubScaffold(
      title: 'Key Information Document',
      subtitle: 'PRIIPs KID',
      semanticLabel: 'SC-108 KIDGeneratorPage',
      contentKey: KIDGeneratorPage.contentKey,
      shellRenderMode: shellRenderMode,
      useCopyTradingInset: true,
      onBack: () => context.go(AppRoutePaths.tradeCopyExAnteCosts),
      headerActions: [
        VitHeaderActionItem(type: VitHeaderActionType.export, onPressed: null),
      ],
      children: [
        VitTradeSection(
          title: 'Review',
          child: const VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            title: 'KID document review required',
            message:
                'Risk indicator, performance scenarios, costs, holding period and download next steps are reviewed before distribution.',
            contractId: 'kid-generator-review',
          ),
        ),
        VitTradeComplianceSection(
          title: 'KID review',
          statusPill: const VitStatusPill(
            label: 'Review required',
            status: VitStatusPillStatus.info,
            size: VitStatusPillSize.sm,
          ),
          items: [
            VitTradeComplianceItem(label: 'Regulation', value: 'PRIIPs KID'),
            VitTradeComplianceItem(
              label: 'Sections',
              value: '${snapshot.sections.length} required',
            ),
          ],
        ),
        VitTradeSection(title: 'Notice', child: const _RegulatoryNotice()),
        VitTradeSection(
          title: 'Document',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _KidPreviewCard(document: snapshot.document),
              const VitSectionHeader(
                title: 'Document Sections',
                bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                variant: VitSectionHeaderVariant.accentBar,
                accentColor: _kidPrimary,
              ),
              for (final section in snapshot.sections) ...[
                _KidSectionCard(section: section),
                if (section != snapshot.sections.last)
                  const SizedBox(height: _kidSectionCardGap),
              ],
              const _Actions(),
            ],
          ),
        ),
      ],
    );
  }
}

class _RegulatoryNotice extends StatelessWidget {
  const _RegulatoryNotice();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: TradeSpacingTokens.tradeBotClientMoneyNoticePadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.text1,
            size: TradeSpacingTokens.tradeBotCheckboxIcon,
          ),
          const SizedBox(width: TradeSpacingTokens.tradeBotRowGap),
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
                const SizedBox(height: TradeSpacingTokens.tradeBotSmallGap),
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
              // card-tile: allow-start — fixed surface, not horizontal strip tile
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
              const SizedBox(width: TradeSpacingTokens.tradeBotRowGap),
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
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
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
              const SizedBox(width: TradeSpacingTokens.tradeBotRowGap),
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
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      height: _kidMetricHeight,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
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
            style: AppTextStyles.caption.copyWith(
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
            const SizedBox(width: TradeSpacingTokens.tradeBotSmallGap),
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

  void _showComingSoon(BuildContext context, String message) {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

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
            onPressed: () =>
                _showComingSoon(context, 'Xem trước KID sẽ sớm ra mắt'),
          ),
        ),
        const SizedBox(width: _kidSectionCardGap),
        Expanded(
          child: _ActionButton(
            icon: Icons.download_rounded,
            label: 'Download PDF',
            filled: true,
            onPressed: () => _showComingSoon(context, 'Tải PDF sẽ sớm ra mắt'),
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
