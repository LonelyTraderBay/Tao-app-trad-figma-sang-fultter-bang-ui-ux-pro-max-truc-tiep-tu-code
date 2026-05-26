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
import 'package:vit_trade_flutter/features/earn/data/earn_repository.dart';

enum _ReserveTab { overview, assets, verify }

class StakingProofOfReservesPage extends ConsumerStatefulWidget {
  const StakingProofOfReservesPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc380_info');
  static const tabsKey = Key('sc380_tabs');
  static const overviewKey = Key('sc380_overview');
  static const reserveStatusKey = Key('sc380_reserve_status');
  static const trendKey = Key('sc380_trend');
  static const auditsKey = Key('sc380_audits');
  static const assetsKey = Key('sc380_assets');
  static const verifyKey = Key('sc380_verify');
  static const verifySheetKey = Key('sc380_verify_sheet');
  static const userIdFieldKey = Key('sc380_user_id_field');
  static const balanceFieldKey = Key('sc380_balance_field');
  static const verifySubmitKey = Key('sc380_verify_submit');
  static const proofResultKey = Key('sc380_proof_result');
  static const footerKey = Key('sc380_footer');

  static Key tabKey(String id) => Key('sc380_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingProofOfReservesPage> createState() =>
      _StakingProofOfReservesPageState();
}

class _StakingProofOfReservesPageState
    extends ConsumerState<StakingProofOfReservesPage> {
  _ReserveTab _tab = _ReserveTab.overview;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingProofOfReservesRepositoryProvider)
        .getProofOfReserves();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-380 StakingProofOfReservesPage',
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
                    _ReserveTabs(
                      active: _tab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _tab = tab);
                      },
                    ),
                    if (_tab == _ReserveTab.overview)
                      _OverviewTab(snapshot: snapshot)
                    else if (_tab == _ReserveTab.assets)
                      _AssetsTab(snapshot: snapshot)
                    else
                      _VerifyTab(
                        snapshot: snapshot,
                        onVerify: () => _openVerifySheet(snapshot),
                      ),
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

  Future<void> _openVerifySheet(StakingProofOfReservesSnapshot snapshot) async {
    HapticFeedback.selectionClick();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _VerifySheet(snapshot: snapshot),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingProofOfReservesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingProofOfReservesPage.infoKey,
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

class _ReserveTabs extends StatelessWidget {
  const _ReserveTabs({required this.active, required this.onChanged});

  final _ReserveTab active;
  final ValueChanged<_ReserveTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: StakingProofOfReservesPage.tabsKey,
      decoration: const BoxDecoration(color: AppColors.surface),
      child: Row(
        children: [
          for (final tab in _ReserveTab.values)
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  key: StakingProofOfReservesPage.tabKey(tab.name),
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
                                : Colors.transparent,
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

  final StakingProofOfReservesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final overall = snapshot.overall;
    final surplus = overall.totalAssetsUsd - overall.totalLiabilitiesUsd;
    return Column(
      key: StakingProofOfReservesPage.overviewKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          key: StakingProofOfReservesPage.reserveStatusKey,
          label: 'Overall Reserve Status',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _SmallMetric(
                          label: 'Total Assets (USD)',
                          value: _formatUsd(overall.totalAssetsUsd),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x4),
                      Expanded(
                        child: _SmallMetric(
                          label: 'Reserve Ratio',
                          value: '${overall.reserveRatio.toStringAsFixed(1)}%',
                          color: AppColors.buy,
                          alignEnd: true,
                          suffix: '>= 100%',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x5),
                  Center(child: _ReserveProgress(ratio: overall.reserveRatio)),
                  const SizedBox(height: AppSpacing.x5),
                  Row(
                    children: [
                      Expanded(
                        child: _InnerMetric(
                          label: 'User Liabilities',
                          value: _formatUsd(overall.totalLiabilitiesUsd),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: _InnerMetric(
                          label: 'Surplus',
                          value: _formatUsd(surplus),
                          valueColor: AppColors.buy,
                          subtleBuy: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  Text(
                    'Last updated: ${overall.lastUpdated} - Live data',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          key: StakingProofOfReservesPage.trendKey,
          label: 'Reserve Ratio Trend (12 Months)',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                children: [
                  SizedBox(
                    height: 210,
                    child: CustomPaint(
                      painter: _ReserveTrendPainter(snapshot.history),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.trending_up_rounded,
                        color: AppColors.buy,
                        size: AppSpacing.iconSm,
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Text(
                        '+1.7% YoY',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x4),
                      Container(
                        width: AppSpacing.x1,
                        height: AppSpacing.x1,
                        decoration: const BoxDecoration(
                          color: AppColors.borderSolid,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x4),
                      Text(
                        'Always >= 100%',
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
        VitPageSection(
          key: StakingProofOfReservesPage.auditsKey,
          label: 'Third-Party Audit Reports',
          accentColor: AppColors.primarySoft,
          children: [
            for (final report in snapshot.auditReports)
              _AuditReportCard(report: report),
          ],
        ),
      ],
    );
  }
}

class _AssetsTab extends StatelessWidget {
  const _AssetsTab({required this.snapshot});

  final StakingProofOfReservesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingProofOfReservesPage.assetsKey,
      label: 'Reserve Ratio by Asset',
      accentColor: AppColors.primarySoft,
      children: [
        for (final asset in snapshot.assets) _AssetReserveCard(asset: asset),
      ],
    );
  }
}

class _VerifyTab extends StatelessWidget {
  const _VerifyTab({required this.snapshot, required this.onVerify});

  final StakingProofOfReservesSnapshot snapshot;
  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingProofOfReservesPage.verifyKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Verify Your Balance',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: AppSpacing.ctaHeight,
                        height: AppSpacing.ctaHeight,
                        decoration: BoxDecoration(
                          color: AppColors.primary12,
                          borderRadius: AppRadii.lgRadius,
                        ),
                        child: const Icon(
                          Icons.visibility_outlined,
                          color: AppColors.primarySoft,
                          size: AppSpacing.iconMd,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Merkle Tree Verification',
                              style: AppTextStyles.baseMedium,
                            ),
                            const SizedBox(height: AppSpacing.x2),
                            Text(
                              'Prove your staked balance is included in our Proof of Reserves using cryptographic Merkle tree proofs.',
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
                  const SizedBox(height: AppSpacing.x4),
                  SizedBox(
                    height: AppSpacing.ctaHeight,
                    child: FilledButton(
                      onPressed: onVerify,
                      child: const Text('Verify My Balance'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          label: 'How Verification Works',
          accentColor: AppColors.primarySoft,
          children: [
            for (final step in snapshot.verifySteps)
              _VerificationStepCard(step: step),
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
                Icons.privacy_tip_outlined,
                color: AppColors.primarySoft,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  snapshot.privacyNote,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.55,
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

class _ReserveProgress extends StatelessWidget {
  const _ReserveProgress({required this.ratio});

  final double ratio;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: _ReserveProgressPainter(ratio),
            child: const SizedBox.expand(),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSpacing.x6,
                height: AppSpacing.x6,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.buy, width: 3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.buy,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(height: AppSpacing.x3),
              Text(
                '${ratio.toStringAsFixed(1)}%',
                style: AppTextStyles.pageTitle.copyWith(
                  color: AppColors.buy,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              Text(
                'Covered',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AssetReserveCard extends StatelessWidget {
  const _AssetReserveCard({required this.asset});

  final StakingAssetReserveDraft asset;

  @override
  Widget build(BuildContext context) {
    final progress = math.min(asset.reserveRatio / 150, 1.0);
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(asset.asset, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Updated: ${asset.lastUpdated}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${asset.reserveRatio.toStringAsFixed(1)}%',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.buy,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              minHeight: AppSpacing.x2,
              value: progress,
              backgroundColor: AppColors.surface3,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.buy),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _InnerMetric(
                  label: 'On-Chain Balance',
                  value:
                      '${_formatAmount(asset.onChainBalance)} ${asset.asset}',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _InnerMetric(
                  label: 'User Liabilities',
                  value:
                      '${_formatAmount(asset.userLiabilities)} ${asset.asset}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          VitCard(
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wallet Address',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        asset.walletAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                _StatusPill(label: 'Verify', color: AppColors.primarySoft),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuditReportCard extends StatelessWidget {
  const _AuditReportCard({required this.report});

  final StakingReserveAuditReportDraft report;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(report.auditor, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      report.dateLabel,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusPill(label: report.status, color: AppColors.buy),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            report.findings,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          SizedBox(
            height: AppSpacing.buttonCompact,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.open_in_new_rounded, size: 16),
              label: const Text('Download Report (PDF)'),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerificationStepCard extends StatelessWidget {
  const _VerificationStepCard({required this.step});

  final StakingReserveVerifyStepDraft step;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.x6,
            height: AppSpacing.x6,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Text(
              step.step.toString(),
              style: AppTextStyles.caption.copyWith(
                color: Colors.white,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.title, style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  step.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.5,
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

class _VerifySheet extends StatefulWidget {
  const _VerifySheet({required this.snapshot});

  final StakingProofOfReservesSnapshot snapshot;

  @override
  State<_VerifySheet> createState() => _VerifySheetState();
}

class _VerifySheetState extends State<_VerifySheet> {
  final _userId = TextEditingController();
  final _balance = TextEditingController();
  StakingMerkleProofDraft? _proof;

  @override
  void dispose() {
    _userId.dispose();
    _balance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        key: StakingProofOfReservesPage.verifySheetKey,
        margin: const EdgeInsets.all(AppSpacing.contentPad),
        padding: const EdgeInsets.all(AppSpacing.x5),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.86,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.cardLargeRadius,
        ),
        child: SingleChildScrollView(
          child: _proof == null ? _form(context) : _proofView(context),
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _SheetTitle(title: 'Verify Your Balance'),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          variant: VitCardVariant.inner,
          borderColor: AppColors.primary20,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Text(
            widget.snapshot.verifyInfo,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.55,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        _TextInput(
          key: StakingProofOfReservesPage.userIdFieldKey,
          label: 'User ID',
          controller: _userId,
          hint: 'e.g., user_12345',
        ),
        const SizedBox(height: AppSpacing.x3),
        _TextInput(
          key: StakingProofOfReservesPage.balanceFieldKey,
          label: 'Staked Balance (ETH)',
          controller: _balance,
          hint: 'e.g., 10.5',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: AppSpacing.x4),
        SizedBox(
          height: AppSpacing.ctaHeight,
          child: FilledButton(
            key: StakingProofOfReservesPage.verifySubmitKey,
            onPressed: _verify,
            child: const Text('Verify Inclusion'),
          ),
        ),
      ],
    );
  }

  Widget _proofView(BuildContext context) {
    final proof = _proof!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _SheetTitle(title: 'Verify Your Balance'),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          key: StakingProofOfReservesPage.proofResultKey,
          variant: VitCardVariant.inner,
          borderColor: AppColors.buy20,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
                size: AppSpacing.x7,
              ),
              const SizedBox(height: AppSpacing.x3),
              Text('Verification Successful', style: AppTextStyles.baseMedium),
              const SizedBox(height: AppSpacing.x2),
              Text(
                'Your balance of ${proof.balance.toStringAsFixed(2)} ETH is included in the Proof of Reserves Merkle tree.',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Text('Merkle Proof', style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.x2),
        _HashCard(label: 'Leaf Hash', value: proof.leaf),
        const SizedBox(height: AppSpacing.x2),
        _HashCard(label: 'Merkle Root', value: proof.root),
        const SizedBox(height: AppSpacing.x2),
        VitCard(
          variant: VitCardVariant.inner,
          padding: const EdgeInsets.all(AppSpacing.x3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sibling Hashes (${proof.siblings.length})',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.x2),
              for (var i = 0; i < proof.siblings.length; i++)
                Text(
                  '${i + 1}. ${_shortHash(proof.siblings[i])}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        SizedBox(
          height: AppSpacing.ctaHeight,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ),
      ],
    );
  }

  void _verify() {
    if (_userId.text.trim().isEmpty || _balance.text.trim().isEmpty) return;
    final balance = double.tryParse(_balance.text.trim()) ?? 0;
    setState(() {
      _proof = StakingMerkleProofDraft(
        userId: _userId.text.trim(),
        balance: balance,
        leaf: '0x7a9c35cc6634c0532925a3b844bc9e7595f0beb4129dfad7890abc123',
        root:
            '0xabc123def456789012345678901234567890123456789012345678901234567890',
        siblings: const [
          '0x4df1741e6cdd9012cba8419900aa4455129dfad7890abc123',
          '0x62ab993d3d79012cba8419900aa4455129dfad7890abc123',
          '0x91cc0a18e52f012cba8419900aa4455129dfad7890abc123',
        ],
        verified: true,
      );
    });
  }
}

class _TextInput extends StatelessWidget {
  const _TextInput({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x2),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: AppTextStyles.body,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

class _HashCard extends StatelessWidget {
  const _HashCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  _shortHash(value),
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.content_copy_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppTextStyles.sectionTitle)),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded, color: AppColors.text2),
        ),
      ],
    );
  }
}

class _SmallMetric extends StatelessWidget {
  const _SmallMetric({
    required this.label,
    required this.value,
    this.color,
    this.alignEnd = false,
    this.suffix,
  });

  final String label;
  final String value;
  final Color? color;
  final bool alignEnd;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: color ?? AppColors.text1,
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

class _InnerMetric extends StatelessWidget {
  const _InnerMetric({
    required this.label,
    required this.value,
    this.valueColor,
    this.subtleBuy = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool subtleBuy;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: subtleBuy ? AppColors.buy20 : null,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: valueColor ?? AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
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
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
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
      key: StakingProofOfReservesPage.footerKey,
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

class _ReserveProgressPainter extends CustomPainter {
  const _ReserveProgressPainter(this.ratio);

  final double ratio;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2 - AppSpacing.x3;
    final stroke = AppSpacing.x4;
    final track = Paint()
      ..color = AppColors.surface3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke;
    final progress = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke;
    canvas.drawCircle(center, radius, track);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * math.min(ratio / 150, 1),
      false,
      progress,
    );
  }

  @override
  bool shouldRepaint(covariant _ReserveProgressPainter oldDelegate) {
    return oldDelegate.ratio != ratio;
  }
}

class _ReserveTrendPainter extends CustomPainter {
  const _ReserveTrendPainter(this.points);

  final List<StakingReserveHistoryPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    const left = 16.0;
    const top = 14.0;
    const right = 12.0;
    const bottom = 16.0;
    final chart = Rect.fromLTRB(
      left,
      top,
      size.width - right,
      size.height - bottom,
    );
    final gridPaint = Paint()
      ..color = AppColors.primary20
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = AppColors.text3
      ..strokeWidth = 1.2;
    final linePaint = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 3;

    for (var i = 0; i <= 4; i++) {
      final y = chart.bottom - chart.height * i / 4;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
    }
    for (var i = 0; i <= 4; i++) {
      final x = chart.left + chart.width * i / 4;
      canvas.drawLine(Offset(x, chart.top), Offset(x, chart.bottom), gridPaint);
    }
    canvas.drawLine(chart.bottomLeft, chart.bottomRight, axisPaint);
    canvas.drawLine(chart.bottomLeft, chart.topLeft, axisPaint);

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = chart.left + chart.width * i / (points.length - 1);
      final y = chart.bottom - chart.height * ((points[i].ratio - 100) / 4);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = AppColors.buy;
    for (var i = 0; i < points.length; i++) {
      final x = chart.left + chart.width * i / (points.length - 1);
      final y = chart.bottom - chart.height * ((points[i].ratio - 100) / 4);
      canvas.drawCircle(Offset(x, y), 5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ReserveTrendPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

String _tabLabel(_ReserveTab tab) {
  return switch (tab) {
    _ReserveTab.overview => 'Overview',
    _ReserveTab.assets => 'By Asset',
    _ReserveTab.verify => 'Verify',
  };
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  return '\$${buffer.toString()}.${parts.last}';
}

String _formatAmount(double value) {
  final text = value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(2);
  final parts = text.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  if (parts.length == 1) return buffer.toString();
  return '${buffer.toString()}.${parts.last}';
}

String _shortHash(String value) {
  if (value.length <= 24) return value;
  return '${value.substring(0, 20)}...${value.substring(value.length - 10)}';
}
