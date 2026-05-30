import 'dart:math' as math;

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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

enum _FundTab { overview, claims, history }

class StakingInsuranceFundTransparencyPage extends ConsumerStatefulWidget {
  const StakingInsuranceFundTransparencyPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc377_info');
  static const tabsKey = Key('sc377_tabs');
  static const fundStatusKey = Key('sc377_fund_status');
  static const assetBreakdownKey = Key('sc377_asset_breakdown');
  static const contributionKey = Key('sc377_contribution');
  static const claimsKey = Key('sc377_claims');
  static const historyKey = Key('sc377_history');
  static const auditsKey = Key('sc377_audits');
  static const footerKey = Key('sc377_footer');

  static Key tabKey(String id) => Key('sc377_tab_$id');

  static Key claimKey(String id) => Key('sc377_claim_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingInsuranceFundTransparencyPage> createState() =>
      _StakingInsuranceFundTransparencyPageState();
}

class _StakingInsuranceFundTransparencyPageState
    extends ConsumerState<StakingInsuranceFundTransparencyPage> {
  _FundTab _tab = _FundTab.overview;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingInsuranceFundTransparencyRepositoryProvider)
        .getTransparency();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-377 StakingInsuranceFundTransparencyPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _InfoBanner(snapshot: snapshot),
                    _FundTabs(
                      active: _tab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _tab = tab);
                      },
                    ),
                    if (_tab == _FundTab.overview)
                      _OverviewTab(snapshot: snapshot)
                    else if (_tab == _FundTab.claims)
                      _ClaimsTab(snapshot: snapshot)
                    else
                      _HistoryTab(snapshot: snapshot),
                    _FooterNote(note: snapshot.footerNote),
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

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingInsuranceFundTransparencySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInsuranceFundTransparencyPage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.buy,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.infoTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.55,
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

class _FundTabs extends StatelessWidget {
  const _FundTabs({required this.active, required this.onChanged});

  final _FundTab active;
  final ValueChanged<_FundTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: StakingInsuranceFundTransparencyPage.tabsKey,
      decoration: const BoxDecoration(color: AppColors.surface),
      child: Row(
        children: [
          for (final tab in _FundTab.values)
            Expanded(
              child: Material(
                color: AppColors.transparent,
                child: InkWell(
                  key: StakingInsuranceFundTransparencyPage.tabKey(tab.name),
                  onTap: () => onChanged(tab),
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.x4),
                    child: Column(
                      children: [
                        Text(
                          _tabLabel(tab),
                          style: AppTextStyles.caption.copyWith(
                            color: active == tab
                                ? AppColors.primarySoft
                                : AppColors.text3,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          width: active == tab ? AppSpacing.buttonHero : 0,
                          height: 2,
                          decoration: BoxDecoration(
                            color: active == tab
                                ? AppColors.primarySoft
                                : AppColors.transparent,
                            borderRadius: AppRadii.xsRadius,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.snapshot});

  final StakingInsuranceFundTransparencySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Current Fund Status',
          accentColor: AppColors.primarySoft,
          children: [_FundStatusCard(snapshot: snapshot)],
        ),
        VitPageSection(
          key: StakingInsuranceFundTransparencyPage.assetBreakdownKey,
          label: 'Asset Breakdown',
          accentColor: AppColors.primarySoft,
          children: [_AssetBreakdownCard(assets: snapshot.assets)],
        ),
        VitPageSection(
          key: StakingInsuranceFundTransparencyPage.contributionKey,
          label: 'Fund Contribution Model',
          accentColor: AppColors.primarySoft,
          children: [_ContributionCard(snapshot: snapshot)],
        ),
      ],
    );
  }
}

class _FundStatusCard extends StatelessWidget {
  const _FundStatusCard({required this.snapshot});

  final StakingInsuranceFundTransparencySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final progress = snapshot.currentRatio / snapshot.targetRatio;
    return VitCard(
      key: StakingInsuranceFundTransparencyPage.fundStatusKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _MetricBlock(
                  label: 'Total Fund Balance',
                  value: _formatUsd(snapshot.totalBalance),
                  large: true,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _MetricBlock(
                  label: 'Reserve Ratio',
                  value: '${snapshot.currentRatio}%',
                  suffix: '/ ${snapshot.targetRatio}%',
                  valueColor: AppColors.buy,
                  alignRight: true,
                  large: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          SizedBox.square(
            dimension: 160,
            child: CustomPaint(
              painter: _ProgressRingPainter(
                progress: progress,
                color: AppColors.buy,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(progress * 100).round()}%',
                      style: AppTextStyles.heroNumber.copyWith(
                        color: AppColors.buy,
                      ),
                    ),
                    Text(
                      'of target',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _InlineStatCard(
                  label: 'Total Liabilities',
                  value: _formatUsd(snapshot.liabilities),
                  color: AppColors.primarySoft,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _InlineStatCard(
                  label: 'Surplus',
                  value: _formatUsd(snapshot.surplus),
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Last updated: ${snapshot.lastUpdated}',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _MetricBlock extends StatelessWidget {
  const _MetricBlock({
    required this.label,
    required this.value,
    this.suffix,
    this.valueColor = AppColors.text1,
    this.alignRight = false,
    this.large = false,
  });

  final String label;
  final String value;
  final String? suffix;
  final Color valueColor;
  final bool alignRight;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: alignRight ? TextAlign.right : TextAlign.left,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: (large ? AppTextStyles.sectionTitle : AppTextStyles.body)
                    .copyWith(
                      color: valueColor,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
              ),
              if (suffix != null) ...[
                const SizedBox(width: AppSpacing.x1),
                Text(
                  suffix!,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _InlineStatCard extends StatelessWidget {
  const _InlineStatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      borderColor: color.withValues(alpha: 0.16),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: _MetricBlock(label: label, value: value, valueColor: color),
    );
  }
}

class _AssetBreakdownCard extends StatelessWidget {
  const _AssetBreakdownCard({required this.assets});

  final List<StakingInsuranceFundAssetDraft> assets;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          SizedBox.square(
            dimension: 200,
            child: CustomPaint(
              painter: _PiePainter(assets: assets),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final asset in assets) ...[
            _AssetRow(asset: asset),
            if (asset != assets.last) const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _AssetRow extends StatelessWidget {
  const _AssetRow({required this.asset});

  final StakingInsuranceFundAssetDraft asset;

  @override
  Widget build(BuildContext context) {
    final color = _assetColor(asset.colorKey);
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: AppSpacing.x3,
            height: AppSpacing.x3,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              asset.asset,
              style: AppTextStyles.baseMedium.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatUsd(asset.value),
                style: AppTextStyles.caption.copyWith(
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                '${asset.percentage}%',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContributionCard extends StatelessWidget {
  const _ContributionCard({required this.snapshot});

  final StakingInsuranceFundTransparencySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.trending_up_rounded,
                color: AppColors.primarySoft,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('How the Fund Grows', style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      '${snapshot.stakingFeeContribution}% of all staking fees are automatically allocated to the insurance fund. No user funds are ever used.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _InlineStatCard(
                  label: 'Monthly Avg',
                  value: _formatUsd(snapshot.monthlyContribution),
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _InlineStatCard(
                  label: 'YTD 2026',
                  value: _formatUsd(snapshot.ytdContributions),
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _InlineStatCard(
            label: 'Total Contributed (All-time)',
            value: _formatUsd(snapshot.totalContributed),
            color: AppColors.primarySoft,
          ),
        ],
      ),
    );
  }
}

class _ClaimsTab extends StatelessWidget {
  const _ClaimsTab({required this.snapshot});

  final StakingInsuranceFundTransparencySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingInsuranceFundTransparencyPage.claimsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Claims History',
          accentColor: AppColors.primarySoft,
          children: [
            for (final claim in snapshot.claims) _ClaimCard(claim: claim),
          ],
        ),
        VitCard(
          variant: VitCardVariant.inner,
          borderColor: AppColors.primary20,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.description_outlined,
                color: AppColors.primarySoft,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Claim Processing: All claims are reviewed within 24 hours. Approved claims are paid out within 7 business days. Average approval rate: 94%.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ClaimCard extends StatelessWidget {
  const _ClaimCard({required this.claim});

  final StakingInsuranceFundClaimDraft claim;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInsuranceFundTransparencyPage.claimKey(claim.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(claim.user, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      claim.date,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const _StatusPill(label: 'Approved', color: AppColors.buy),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.md,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Reason: ${claim.reason}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.x3),
                Row(
                  children: [
                    Expanded(
                      child: _ClaimMetric(
                        label: 'Loss',
                        value: '\$${claim.loss.toStringAsFixed(2)}',
                        color: AppColors.sell,
                      ),
                    ),
                    Expanded(
                      child: _ClaimMetric(
                        label: 'Coverage',
                        value: '${claim.coverage}%',
                        color: AppColors.warn,
                      ),
                    ),
                    Expanded(
                      child: _ClaimMetric(
                        label: 'Payout',
                        value: '\$${claim.payout.toStringAsFixed(2)}',
                        color: AppColors.buy,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Processed in ${claim.processingDays} business days',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ClaimMetric extends StatelessWidget {
  const _ClaimMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({required this.snapshot});

  final StakingInsuranceFundTransparencySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          key: StakingInsuranceFundTransparencyPage.historyKey,
          label: 'Historical Performance (12 Months)',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                children: [
                  SizedBox(
                    height: 220,
                    child: CustomPaint(
                      painter: _HistoryPainter(history: snapshot.history),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Row(
                    children: const [
                      Expanded(
                        child: _InlineStatCard(
                          label: '12M Growth',
                          value: '+10.6%',
                          color: AppColors.primarySoft,
                        ),
                      ),
                      SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: _InlineStatCard(
                          label: 'Avg Ratio',
                          value: '161%',
                          color: AppColors.buy,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          key: StakingInsuranceFundTransparencyPage.auditsKey,
          label: 'Monthly Audit Reports',
          accentColor: AppColors.primarySoft,
          children: const [
            _AuditRow(month: 'March 2026'),
            _AuditRow(month: 'February 2026'),
            _AuditRow(month: 'January 2026'),
          ],
        ),
      ],
    );
  }
}

class _AuditRow extends StatelessWidget {
  const _AuditRow({required this.month});

  final String month;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          const Icon(
            Icons.description_outlined,
            color: AppColors.primarySoft,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$month Audit', style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Third-party verified',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.download_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInsuranceFundTransparencyPage.footerKey,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        note,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: 1.55,
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  const _ProgressRingPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = AppSpacing.x4.toDouble();
    final rect = Offset.zero & size;
    final ringRect = rect.deflate(stroke / 2);
    final track = Paint()
      ..color = AppColors.surface3
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final active = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(ringRect, 0, math.pi * 2, false, track);
    canvas.drawArc(
      ringRect,
      -math.pi / 2,
      math.pi * 2 * progress.clamp(0, 1),
      false,
      active,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class _PiePainter extends CustomPainter {
  const _PiePainter({required this.assets});

  final List<StakingInsuranceFundAssetDraft> assets;

  @override
  void paint(Canvas canvas, Size size) {
    final total = assets.fold<double>(0, (sum, asset) => sum + asset.value);
    if (total <= 0) return;
    final rect = Offset.zero & size;
    var start = -math.pi / 2;
    final paint = Paint()..style = PaintingStyle.fill;
    for (final asset in assets) {
      final sweep = math.pi * 2 * (asset.value / total);
      paint.color = _assetColor(asset.colorKey);
      canvas.drawArc(rect.deflate(AppSpacing.x2), start, sweep, true, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _PiePainter oldDelegate) {
    return oldDelegate.assets != assets;
  }
}

class _HistoryPainter extends CustomPainter {
  const _HistoryPainter({required this.history});

  final List<StakingInsuranceFundHistoryDraft> history;

  @override
  void paint(Canvas canvas, Size size) {
    if (history.length < 2) return;
    final area = Rect.fromLTWH(
      AppSpacing.x4,
      AppSpacing.x4,
      size.width - AppSpacing.x6,
      size.height - AppSpacing.x6,
    );
    final gridPaint = Paint()
      ..color = AppColors.borderSolid
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = area.top + area.height * i / 3;
      canvas.drawLine(Offset(area.left, y), Offset(area.right, y), gridPaint);
    }
    _drawLine(
      canvas,
      area,
      history.map((item) => item.balance).toList(),
      AppColors.primarySoft,
    );
    _drawLine(
      canvas,
      area,
      history.map((item) => item.ratio.toDouble()).toList(),
      AppColors.buy,
    );
  }

  void _drawLine(Canvas canvas, Rect area, List<double> values, Color color) {
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final range = math.max(maxValue - minValue, 1);
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = area.left + area.width * i / (values.length - 1);
      final normalized = (values[i] - minValue) / range;
      final y = area.bottom - area.height * normalized;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HistoryPainter oldDelegate) {
    return oldDelegate.history != history;
  }
}

String _tabLabel(_FundTab tab) {
  return switch (tab) {
    _FundTab.overview => 'Overview',
    _FundTab.claims => 'Claims',
    _FundTab.history => 'History',
  };
}

Color _assetColor(String colorKey) {
  return switch (colorKey) {
    'primary' => AppColors.primarySoft,
    'warning' => AppColors.warn,
    'success' => AppColors.buy,
    _ => AppColors.text3,
  };
}

String _formatUsd(double value) {
  if (value >= 1000000) {
    final formatted = value.toStringAsFixed(2);
    return '\$${_commaWhole(formatted)}';
  }
  final formatted = value.toStringAsFixed(2);
  return '\$${_commaWhole(formatted)}';
}

String _commaWhole(String fixedValue) {
  final parts = fixedValue.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(whole[i]);
  }
  return '${buffer.toString()}.${parts.last}';
}
