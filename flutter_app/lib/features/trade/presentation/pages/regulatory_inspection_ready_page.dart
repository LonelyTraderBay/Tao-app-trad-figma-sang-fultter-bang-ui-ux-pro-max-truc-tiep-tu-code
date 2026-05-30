import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

const _inspectionBackground = AppColors.bg;
const _inspectionPanel = AppColors.surface;
const _inspectionPanel2 = AppColors.surface2;
const _inspectionBorder = AppColors.borderSolid;
const _inspectionGreen = AppColors.buy;
const _inspectionPrimary = AppColors.primary;
const _inspectionAmber = AppColors.caution;

class RegulatoryInspectionReadyPage extends ConsumerWidget {
  const RegulatoryInspectionReadyPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc116_regulatory_inspection_content');
  static const reportKey = Key('sc116_regulatory_inspection_report');
  static const portalKey = Key('sc116_regulatory_inspection_portal');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getRegulatoryInspectionReady();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 58
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-116 RegulatoryInspectionReadyPage',
      child: Material(
        color: _inspectionBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Regulatory Compliance',
              subtitle: 'Inspection Ready Dashboard',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
              trailing: const _HeaderDownloadButton(),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ComplianceScoreCard(snapshot: snapshot),
                    const SizedBox(height: 25),
                    _QuickStats(stats: snapshot.stats),
                    const SizedBox(height: 25),
                    const _SectionLabel('Regulatory Framework Coverage'),
                    const SizedBox(height: 12),
                    for (final framework in snapshot.frameworks) ...[
                      _FrameworkCard(framework: framework),
                      if (framework != snapshot.frameworks.last)
                        const SizedBox(height: 14),
                    ],
                    const SizedBox(height: 25),
                    const _SectionLabel('Document Repository'),
                    const SizedBox(height: 12),
                    for (final document in snapshot.documents) ...[
                      _DocumentCard(document: document),
                      if (document != snapshot.documents.last)
                        const SizedBox(height: 8),
                    ],
                    const SizedBox(height: 25),
                    const _SectionLabel('Regulatory Inspector Access'),
                    const SizedBox(height: 12),
                    _InspectorPortalCard(snapshot: snapshot),
                    const SizedBox(height: 26),
                    _ReportButton(snapshot: snapshot),
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

class _HeaderDownloadButton extends StatelessWidget {
  const _HeaderDownloadButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _inspectionPanel2,
          border: Border.all(color: _inspectionBorder.withValues(alpha: .65)),
          borderRadius: AppRadii.smRadius,
        ),
        child: IconButton(
          onPressed: () {},
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.download_rounded,
            color: AppColors.text1,
            size: 19,
          ),
        ),
      ),
    );
  }
}

class _ComplianceScoreCard extends StatelessWidget {
  const _ComplianceScoreCard({required this.snapshot});

  final TradeRegulatoryInspectionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 203),
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 17),
      decoration: BoxDecoration(
        color: _inspectionPanel,
        border: Border.all(color: _inspectionBorder.withValues(alpha: .76)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _inspectionGreen.withValues(alpha: .14),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: const Icon(
                  Icons.military_tech_outlined,
                  color: _inspectionGreen,
                  size: 30,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.scoreLabel,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          fontSize: 11,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${snapshot.complianceScore}%',
                            style: AppTextStyles.heroNumber.copyWith(
                              color: _inspectionGreen,
                              fontSize: 36,
                              height: 1,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            '/ 100%',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                              fontSize: 12,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: SizedBox(
                  height: 11,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ColoredBox(color: _inspectionPanel2),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width:
                              constraints.maxWidth *
                              snapshot.complianceScore /
                              100,
                          height: 11,
                          child: const ColoredBox(color: _inspectionGreen),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 25),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 1),
                child: Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.text1,
                  size: 15,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text1,
                      fontFamily: 'Roboto',
                      fontSize: 10,
                      fontWeight: AppTextStyles.bold,
                      height: 1.25,
                    ),
                    children: [
                      TextSpan(text: '${snapshot.readyTitle} '),
                      TextSpan(text: snapshot.readyDescription),
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

class _QuickStats extends StatelessWidget {
  const _QuickStats({required this.stats});

  final List<TradeRegulatoryInspectionStat> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final stat in stats) ...[
          Expanded(child: _QuickStatCard(stat: stat)),
          if (stat != stats.last) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  const _QuickStatCard({required this.stat});

  final TradeRegulatoryInspectionStat stat;

  @override
  Widget build(BuildContext context) {
    final style = _styleForStat(stat.icon);
    return Container(
      height: 80,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
      decoration: BoxDecoration(
        color: _inspectionPanel,
        border: Border.all(color: _inspectionBorder.withValues(alpha: .76)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(style.icon, color: style.color, size: 14),
          const SizedBox(height: 14),
          Text(
            stat.value,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontSize: 17,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 8,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _FrameworkCard extends StatelessWidget {
  const _FrameworkCard({required this.framework});

  final TradeRegulatoryFramework framework;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 17),
      decoration: BoxDecoration(
        color: _inspectionPanel,
        border: Border.all(color: _inspectionBorder.withValues(alpha: .76)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  framework.name,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontSize: 14,
                    height: 1,
                  ),
                ),
              ),
              Text(
                '${framework.compliance}%',
                style: AppTextStyles.baseMedium.copyWith(
                  color: _inspectionGreen,
                  fontSize: 18,
                  height: 1,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.check_circle_outline_rounded,
                color: _inspectionGreen,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (final requirement in framework.requirements) ...[
            _RequirementRow(requirement),
            if (requirement != framework.requirements.last)
              const SizedBox(height: 9),
          ],
        ],
      ),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  const _RequirementRow(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline_rounded,
          color: _inspectionGreen,
          size: 11,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 10,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 3),
              const Icon(Icons.check_rounded, color: AppColors.text2, size: 9),
            ],
          ),
        ),
      ],
    );
  }
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({required this.document});

  final TradeRegulatoryDocument document;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.fromLTRB(12, 9, 12, 9),
      decoration: BoxDecoration(
        color: _inspectionPanel,
        border: Border.all(color: _inspectionBorder.withValues(alpha: .76)),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _inspectionGreen.withValues(alpha: .13),
              borderRadius: AppRadii.cardRadius,
            ),
            child: const Icon(
              Icons.description_outlined,
              color: _inspectionGreen,
              size: 15,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  document.countLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 9,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: _inspectionGreen.withValues(alpha: .13),
              borderRadius: AppRadii.inputRadius,
            ),
            child: Text(
              document.status,
              style: AppTextStyles.micro.copyWith(
                color: _inspectionGreen,
                fontSize: 9,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InspectorPortalCard extends StatelessWidget {
  const _InspectorPortalCard({required this.snapshot});

  final TradeRegulatoryInspectionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: _inspectionPanel,
        border: Border.all(color: _inspectionBorder.withValues(alpha: .76)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _inspectionPrimary.withValues(alpha: .13),
                  borderRadius: AppRadii.inputRadius,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: _inspectionPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.portalTitle,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontSize: 16,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      snapshot.portalDescription,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            key: RegulatoryInspectionReadyPage.portalKey,
            height: 40,
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.open_in_new_rounded, size: 15),
              label: Text(
                snapshot.portalCta,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: _inspectionPanel2,
                foregroundColor: AppColors.text1,
                side: BorderSide(
                  color: _inspectionBorder.withValues(alpha: .82),
                ),
                shape: RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportButton extends StatelessWidget {
  const _ReportButton({required this.snapshot});

  final TradeRegulatoryInspectionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: RegulatoryInspectionReadyPage.reportKey,
      height: AppSpacing.inputHeight,
      child: FilledButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.download_rounded, size: 18),
        label: Text(
          snapshot.reportCta,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.body.copyWith(
            color: AppColors.onAccent,
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: _inspectionGreen,
          foregroundColor: AppColors.onAccent,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _inspectionPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

_StatStyle _styleForStat(TradeRegulatoryInspectionStatIcon icon) {
  return switch (icon) {
    TradeRegulatoryInspectionStatIcon.documents => const _StatStyle(
      color: _inspectionPrimary,
      icon: Icons.description_outlined,
    ),
    TradeRegulatoryInspectionStatIcon.clients => const _StatStyle(
      color: _inspectionGreen,
      icon: Icons.group_outlined,
    ),
    TradeRegulatoryInspectionStatIcon.auditLogs => const _StatStyle(
      color: _inspectionAmber,
      icon: Icons.bar_chart_rounded,
    ),
    TradeRegulatoryInspectionStatIcon.retention => const _StatStyle(
      color: _inspectionPrimary,
      icon: Icons.schedule_rounded,
    ),
  };
}

final class _StatStyle {
  const _StatStyle({required this.color, required this.icon});

  final Color color;
  final IconData icon;
}
