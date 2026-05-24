import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
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

enum _InsuranceTab { overview, claims }

class P2PInsuranceFundPage extends ConsumerStatefulWidget {
  const P2PInsuranceFundPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc238_p2p_insurance_content');
  static const overviewTabKey = Key('sc238_p2p_insurance_overview_tab');
  static const claimsTabKey = Key('sc238_p2p_insurance_claims_tab');
  static const tourKey = Key('sc238_p2p_insurance_tour');
  static const tourContinueKey = Key('sc238_p2p_insurance_tour_continue');
  static const certificateKey = Key('sc238_p2p_insurance_certificate');
  static const submitClaimKey = Key('sc238_p2p_insurance_submit_claim');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PInsuranceFundPage> createState() =>
      _P2PInsuranceFundPageState();
}

class _P2PInsuranceFundPageState extends ConsumerState<P2PInsuranceFundPage> {
  _InsuranceTab _tab = _InsuranceTab.overview;
  bool _showTour = true;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pRepositoryProvider).getInsuranceFund();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return Stack(
      children: [
        VitPageLayout(
          variant: VitPageVariant.flush,
          semanticLabel: 'SC-238 P2PInsuranceFundPage',
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              children: [
                VitHeader(
                  title: 'Quỹ bảo hiểm',
                  subtitle: 'Bảo hiểm · P2P',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.p2p),
                  trailing: VitIconButton(
                    icon: Icons.help_outline_rounded,
                    tooltip: 'Hướng dẫn sử dụng',
                    size: VitIconButtonSize.md,
                    variant: VitIconButtonVariant.primary,
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      setState(() => _showTour = true);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x3,
                    AppSpacing.contentPad,
                    AppSpacing.x2,
                  ),
                  child: VitTabBar(
                    variant: VitTabBarVariant.segment,
                    activeKey: _tab.name,
                    onChanged: (key) {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _tab = key == _InsuranceTab.claims.name
                            ? _InsuranceTab.claims
                            : _InsuranceTab.overview;
                      });
                    },
                    tabs: const [
                      VitTabItem(
                        key: 'overview',
                        label: 'Tổng quan',
                        icon: Icons.shield_outlined,
                      ),
                      VitTabItem(
                        key: 'claims',
                        label: 'Yêu cầu của tôi',
                        icon: Icons.receipt_long_rounded,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      key: P2PInsuranceFundPage.contentKey,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.contentPad,
                        AppSpacing.x3,
                        AppSpacing.contentPad,
                        bottomInset,
                      ),
                      child: _tab == _InsuranceTab.overview
                          ? _OverviewContent(snapshot: snapshot)
                          : _ClaimsContent(snapshot: snapshot),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_showTour)
          _InsuranceTourOverlay(
            snapshot: snapshot,
            onClose: () {
              HapticFeedback.selectionClick();
              setState(() => _showTour = false);
            },
            onContinue: () {
              HapticFeedback.selectionClick();
              setState(() => _showTour = false);
            },
          ),
      ],
    );
  }
}

class _OverviewContent extends StatelessWidget {
  const _OverviewContent({required this.snapshot});

  final P2PInsuranceFundSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FundSummaryCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x4),
        _EligibilityCard(items: snapshot.eligibilityItems),
        const SizedBox(height: AppSpacing.x4),
        _FundHealthCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x4),
        _FundChartCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x4),
        _CoverageCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x4),
        _CoverageTierCard(tiers: snapshot.coverageTiers),
        const SizedBox(height: AppSpacing.x4),
        _NotificationCard(prefs: snapshot.notificationPrefs),
        const SizedBox(height: AppSpacing.x4),
        const _HowItWorksCard(),
        const SizedBox(height: AppSpacing.x4),
        _ClaimCalculatorCard(coveragePct: snapshot.userCoveragePct),
        const SizedBox(height: AppSpacing.x4),
        _PlatformStatsCard(snapshot: snapshot),
      ],
    );
  }
}

class _FundSummaryCard extends StatelessWidget {
  const _FundSummaryCard({required this.snapshot});

  final P2PInsuranceFundSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.health_and_safety_outlined,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Quỹ bảo hiểm P2P',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
              ),
              const VitStatusPill(
                label: 'Đang bảo vệ',
                status: VitStatusPillStatus.orange,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            '${_formatVnd(snapshot.totalFund)} đ',
            style: AppTextStyles.heroNumber.copyWith(
              color: AppModuleAccents.p2p,
              fontSize: 31,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Tổng quỹ hiện có để bảo vệ giao dịch P2P gặp sự cố.',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _MiniMetric(
                  label: 'Claim đang xử lý',
                  value: '${snapshot.activeClaims}',
                ),
              ),
              Expanded(
                child: _MiniMetric(
                  label: 'Đã đóng góp',
                  value: _formatCompactVnd(snapshot.totalContributed),
                ),
              ),
              Expanded(
                child: _MiniMetric(
                  label: 'Đã chi trả',
                  value: _formatCompactVnd(snapshot.totalPaid),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EligibilityCard extends StatelessWidget {
  const _EligibilityCard({required this.items});

  final List<P2PInsuranceEligibilityItemDraft> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(
            icon: Icons.check_circle_outline_rounded,
            title: 'Điều kiện bồi thường',
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final item in items) ...[
            _EligibilityRow(item: item),
            const SizedBox(height: AppSpacing.x2),
          ],
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x2,
            ),
            decoration: BoxDecoration(
              color: AppColors.buy15,
              borderRadius: AppRadii.mdRadius,
            ),
            child: Text(
              'Bạn đủ điều kiện gửi yêu cầu bồi thường',
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.buy,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FundHealthCard extends StatelessWidget {
  const _FundHealthCard({required this.snapshot});

  final P2PInsuranceFundSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: _CardTitle(
                  icon: Icons.favorite_border_rounded,
                  title: 'Sức khỏe quỹ',
                ),
              ),
              const VitStatusPill(
                label: 'Khỏe mạnh',
                status: VitStatusPillStatus.success,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Quỹ đủ khả năng chi trả toàn bộ claims đang xử lý',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          _TwoColumnInfo(
            label: 'Tỷ lệ thanh khoản',
            value: '${snapshot.solvencyRatio}x',
            tone: AppColors.buy,
          ),
          _TwoColumnInfo(
            label: 'Claims chưa giải quyết',
            value: '${_formatVnd(snapshot.outstandingClaimsAmount)} đ',
          ),
          _TwoColumnInfo(
            label: 'Tỷ lệ duyệt',
            value: '${snapshot.approvalRate}%',
          ),
          _TwoColumnInfo(
            label: 'Thời gian xử lý TB',
            value: '${snapshot.avgResolutionHours}h',
          ),
          _TwoColumnInfo(
            label: 'Hạn mức/30 ngày',
            value: '${_formatVnd(snapshot.maxClaimPerPeriod)} đ',
          ),
          const SizedBox(height: AppSpacing.x3),
          VitCard(
            key: P2PInsuranceFundPage.certificateKey,
            variant: VitCardVariant.inner,
            radius: VitCardRadius.sm,
            padding: const EdgeInsets.all(AppSpacing.x3),
            onTap: () => context.go(snapshot.certificateRoute),
            child: Row(
              children: [
                Container(
                  width: AppSpacing.buttonCompact,
                  height: AppSpacing.buttonCompact,
                  decoration: BoxDecoration(
                    color: AppColors.primary12,
                    borderRadius: AppRadii.mdRadius,
                  ),
                  child: const Icon(
                    Icons.verified_user_outlined,
                    color: AppModuleAccents.p2p,
                    size: AppSpacing.iconMd,
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Proof of Reserves',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        'Kiểm toán gần nhất: ${snapshot.lastAuditDate}\n${snapshot.auditorName} · Kỳ tiếp theo: ${snapshot.nextAuditDate}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.open_in_new_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FundChartCard extends StatelessWidget {
  const _FundChartCard({required this.snapshot});

  final P2PInsuranceFundSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: _CardTitle(
                  icon: Icons.trending_up_rounded,
                  title: 'Biến động quỹ',
                ),
              ),
              Text(
                '+37.6%',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Số dư quỹ bảo hiểm (triệu VND)',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: const [
              _RangeChip(label: '7 ngày'),
              SizedBox(width: AppSpacing.x2),
              _RangeChip(label: '30 ngày', active: true),
              SizedBox(width: AppSpacing.x2),
              _RangeChip(label: '90 ngày'),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          SizedBox(
            height: AppSpacing.buttonHero * 1.55,
            child: CustomPaint(
              painter: _FundTrendPainter(snapshot.chartPoints),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _LegendDot(label: 'Dòng tiền 30d', color: AppColors.buy),
              ),
              const _LegendDot(label: '+240M', color: AppColors.buy),
              const SizedBox(width: AppSpacing.x3),
              const _LegendDot(label: '-47M', color: AppModuleAccents.p2p),
            ],
          ),
        ],
      ),
    );
  }
}

class _CoverageCard extends StatelessWidget {
  const _CoverageCard({required this.snapshot});

  final P2PInsuranceFundSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Mức bảo hiểm của bạn',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
              ),
              Text(
                '${snapshot.userCoveragePct}%',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppModuleAccents.p2p,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          _TwoColumnInfo(label: 'Tier merchant', value: snapshot.tierName),
          _TwoColumnInfo(
            label: 'Đóng góp/giao dịch',
            value: snapshot.contributionRate,
          ),
          const SizedBox(height: AppSpacing.x3),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.sm,
            padding: const EdgeInsets.all(AppSpacing.x3),
            onTap: () => context.go(snapshot.contributionHistoryRoute),
            child: Row(
              children: [
                const Icon(
                  Icons.history_rounded,
                  color: AppColors.buy,
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    'Xem lịch sử đóng góp quỹ',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
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
        ],
      ),
    );
  }
}

class _CoverageTierCard extends StatelessWidget {
  const _CoverageTierCard({required this.tiers});

  final List<P2PInsuranceCoverageTierDraft> tiers;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.info_outline_rounded,
            title: 'Bảng bảo hiểm theo tier',
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final tier in tiers) _TierRow(tier: tier),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.prefs});

  final List<P2PInsuranceNotificationPrefDraft> prefs;

  @override
  Widget build(BuildContext context) {
    final enabled = prefs.where((item) => item.enabled).length;
    return VitCard(
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: _CardTitle(
                  icon: Icons.notifications_none_rounded,
                  title: 'Thông báo bảo hiểm',
                ),
              ),
              Text(
                '$enabled/${prefs.length} bật',
                style: AppTextStyles.micro.copyWith(
                  color: AppModuleAccents.p2p,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final pref in prefs) _NotificationRow(pref: pref),
        ],
      ),
    );
  }
}

class _HowItWorksCard extends StatelessWidget {
  const _HowItWorksCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _CardTitle(icon: Icons.route_rounded, title: 'Cách hoạt động'),
          SizedBox(height: AppSpacing.x3),
          _StepRow(
            index: '1',
            title: 'Đóng góp',
            subtitle: '0.1% mỗi giao dịch được trích vào quỹ bảo hiểm chung',
          ),
          _StepRow(
            index: '2',
            title: 'Claim',
            subtitle: 'Nếu bị fraud/chargeback, submit claim trong 7 ngày',
          ),
          _StepRow(
            index: '3',
            title: 'Bồi thường',
            subtitle: 'Review trong 48h, chi trả trong 72h',
          ),
        ],
      ),
    );
  }
}

class _ClaimCalculatorCard extends StatelessWidget {
  const _ClaimCalculatorCard({required this.coveragePct});

  final int coveragePct;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.calculate_outlined,
            title: 'Tính toán bồi thường',
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Nhập số tiền giao dịch (VND)',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Container(
            height: AppSpacing.inputHeight,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              border: Border.all(color: AppColors.borderSolid),
              borderRadius: AppRadii.inputRadius,
            ),
            child: Text(
              'VD: 50.000.000',
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Tỷ lệ hiện tại: $coveragePct%',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _PlatformStatsCard extends StatelessWidget {
  const _PlatformStatsCard({required this.snapshot});

  final P2PInsuranceFundSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.bar_chart_rounded,
            title: 'Thống kê nền tảng',
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: const [
              Expanded(
                child: _StatTile(
                  icon: Icons.receipt_long_rounded,
                  label: 'Tổng claims',
                  value: '847',
                ),
              ),
              SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _StatTile(
                  icon: Icons.bolt_rounded,
                  label: 'Thắng này',
                  value: '12',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: const [
              Expanded(
                child: _StatTile(
                  icon: Icons.groups_rounded,
                  label: 'Merchants',
                  value: '1.240',
                ),
              ),
              SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _StatTile(
                  icon: Icons.timer_rounded,
                  label: 'Xử lý nhanh nhất',
                  value: '4h',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _TwoColumnInfo(label: 'Tổng đã xử lý', value: '2.14B'),
          _TwoColumnInfo(label: 'Claim trung bình', value: '15.200.000 đ'),
        ],
      ),
    );
  }
}

class _ClaimsContent extends StatelessWidget {
  const _ClaimsContent({required this.snapshot});

  final P2PInsuranceFundSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCtaButton(
          key: P2PInsuranceFundPage.submitClaimKey,
          onPressed: () => HapticFeedback.selectionClick(),
          child: const Text('Gửi yêu cầu bồi thường'),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final claim in snapshot.claims) ...[
          _ClaimCard(claim: claim),
          const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _InsuranceTourOverlay extends StatelessWidget {
  const _InsuranceTourOverlay({
    required this.snapshot,
    required this.onClose,
    required this.onContinue,
  });

  final P2PInsuranceFundSnapshot snapshot;
  final VoidCallback onClose;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final height = math.min(MediaQuery.sizeOf(context).height, 956.0);
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: height,
      child: Material(
        key: P2PInsuranceFundPage.tourKey,
        color: AppColors.bg.withValues(alpha: .82),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentPad,
              AppSpacing.x7,
              AppSpacing.contentPad,
              AppSpacing.x5,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.cardBorder),
                borderRadius: AppRadii.cardLargeRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.x4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        for (var i = 0; i < 5; i++) ...[
                          Expanded(
                            child: Container(
                              height: 3,
                              decoration: BoxDecoration(
                                color: i == 0
                                    ? AppModuleAccents.p2p
                                    : AppColors.surface3,
                                borderRadius: AppRadii.xsRadius,
                              ),
                            ),
                          ),
                          if (i != 4) const SizedBox(width: AppSpacing.x2),
                        ],
                        const SizedBox(width: AppSpacing.x3),
                        VitIconButton(
                          icon: Icons.close_rounded,
                          tooltip: 'Đóng',
                          size: VitIconButtonSize.sm,
                          variant: VitIconButtonVariant.ghost,
                          onPressed: onClose,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      '1 / 5',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: AppSpacing.x7,
                        height: AppSpacing.x7,
                        decoration: BoxDecoration(
                          color: AppColors.primary12,
                          borderRadius: AppRadii.lgRadius,
                        ),
                        child: const Icon(
                          Icons.shield_outlined,
                          color: AppModuleAccents.p2p,
                          size: AppSpacing.iconLg,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x5),
                    Text(
                      'Chào mừng đến Quỹ Bảo Hiểm P2P',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    Text(
                      'Quỹ bảo hiểm P2P bảo vệ bạn khi giao dịch P2P gặp sự cố.\nMỗi giao dịch của bạn đều được trích một phần nhỏ vào quỹ để đảm bảo an toàn cho cộng đồng.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x5),
                    _TourInfoCard(
                      title: 'Dành cho bạn',
                      icon: Icons.star_border_rounded,
                      items: [
                        'Bạn đã hoàn thành 47 giao dịch — mọi GD đều được bảo vệ tự động',
                        'Với khối lượng GD cao, bảo hiểm là lớp phòng vệ quan trọng',
                        '180 ngày thành viên — cảm ơn bạn đã tin tưởng sử dụng',
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    _TourInfoCard(
                      title: 'Thông tin chung',
                      icon: Icons.check_circle_outline_rounded,
                      muted: true,
                      items: const [
                        'Quỹ được trích từ 0.1% mỗi giao dịch',
                        'Hoàn toàn tự động — không cần đăng ký',
                        'Bảo vệ cả buyer và seller',
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Row(
                      children: [
                        TextButton(
                          onPressed: onClose,
                          child: Text(
                            'Bỏ qua',
                            style: AppTextStyles.baseMedium.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x3),
                        Expanded(
                          child: VitCtaButton(
                            key: P2PInsuranceFundPage.tourContinueKey,
                            onPressed: onContinue,
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.white,
                              size: AppSpacing.iconMd,
                            ),
                            child: const Text('Tiếp tục'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TourInfoCard extends StatelessWidget {
  const _TourInfoCard({
    required this.title,
    required this.icon,
    required this.items,
    this.muted = false,
  });

  final String title;
  final IconData icon;
  final List<String> items;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: muted ? VitCardVariant.inner : VitCardVariant.standard,
      radius: VitCardRadius.sm,
      borderColor: muted ? AppColors.borderSolid : AppColors.warningBorder,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppModuleAccents.p2p, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Text(
                title,
                style: AppTextStyles.caption.copyWith(
                  color: AppModuleAccents.p2p,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final item in items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSpacing.iconMd,
                  height: AppSpacing.iconMd,
                  decoration: const BoxDecoration(
                    color: AppColors.primary12,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.trending_up_rounded,
                    color: AppModuleAccents.p2p,
                    size: AppSpacing.iconSm,
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.medium,
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

class _ClaimCard extends StatelessWidget {
  const _ClaimCard({required this.claim});

  final P2PInsuranceClaimDraft claim;

  @override
  Widget build(BuildContext context) {
    final config = _claimStatusConfig(claim.status);
    return VitCard(
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: () {
        HapticFeedback.selectionClick();
        context.go(AppRoutePaths.p2pClaim(claim.id));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  claim.claimCode,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
              ),
              VitStatusPill(
                label: config.label,
                status: config.status,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            '${claim.orderId} · ${claim.reason}',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x2),
          _TwoColumnInfo(
            label: 'Số tiền',
            value: '${_formatVnd(claim.amount)} đ',
            tone: config.color,
          ),
          if (claim.paidAmount != null)
            _TwoColumnInfo(
              label: 'Đã nhận',
              value: '${_formatVnd(claim.paidAmount!)} đ',
              tone: AppColors.buy,
            ),
        ],
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppModuleAccents.p2p, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.baseMedium.copyWith(
            color: AppColors.text1,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        Text(
          label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _EligibilityRow extends StatelessWidget {
  const _EligibilityRow({required this.item});

  final P2PInsuranceEligibilityItemDraft item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline_rounded,
          color: AppColors.buy,
          size: AppSpacing.iconSm,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            item.label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        if (item.value != null)
          Flexible(
            child: Text(
              item.value!,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: item.highlight ? AppColors.buy : AppColors.text3,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
      ],
    );
  }
}

class _TwoColumnInfo extends StatelessWidget {
  const _TwoColumnInfo({required this.label, required this.value, this.tone});

  final String label;
  final String value;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x1),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: tone ?? AppColors.text1,
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

class _RangeChip extends StatelessWidget {
  const _RangeChip({required this.label, this.active = false});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      decoration: BoxDecoration(
        color: active ? AppColors.primary12 : AppColors.surface2,
        borderRadius: AppRadii.xlRadius,
        border: Border.all(
          color: active ? AppColors.primary20 : AppColors.cardBorder,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: active ? AppModuleAccents.p2p : AppColors.text2,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSpacing.x2,
          height: AppSpacing.x2,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.x1),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _TierRow extends StatelessWidget {
  const _TierRow({required this.tier});

  final P2PInsuranceCoverageTierDraft tier;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      decoration: BoxDecoration(
        color: tier.highlight ? AppColors.primary12 : Colors.transparent,
        borderRadius: AppRadii.smRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              tier.name,
              style: AppTextStyles.caption.copyWith(
                color: tier.highlight ? AppModuleAccents.p2p : AppColors.text2,
                fontWeight: tier.highlight
                    ? AppTextStyles.bold
                    : AppTextStyles.normal,
              ),
            ),
          ),
          Text(
            '${tier.coveragePct}${tier.bonus == null ? '' : ' · ${tier.bonus}'}',
            style: AppTextStyles.caption.copyWith(
              color: tier.bonus == null ? AppColors.text1 : AppColors.buy,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.pref});

  final P2PInsuranceNotificationPrefDraft pref;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pref.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  pref.description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: pref.enabled,
            activeThumbColor: AppModuleAccents.p2p,
            activeTrackColor: AppColors.primary20,
            onChanged: (_) => HapticFeedback.selectionClick(),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.index,
    required this.title,
    required this.subtitle,
  });

  final String index;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.surface3,
            child: Text(
              index,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          Icon(icon, color: AppModuleAccents.p2p, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                Text(
                  value,
                  style: AppTextStyles.caption.copyWith(
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

class _FundTrendPainter extends CustomPainter {
  const _FundTrendPainter(this.points);

  final List<P2PInsuranceChartPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final minBalance = points.map((item) => item.balance).reduce(math.min);
    final maxBalance = points.map((item) => item.balance).reduce(math.max);
    final range = (maxBalance - minBalance).clamp(1, 1000);
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = size.width * i / (points.length - 1);
      final normalized = (points[i].balance - minBalance) / range;
      final y =
          size.height - normalized * size.height * .78 - size.height * .08;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(fillPath, Paint()..color = AppColors.buy10);
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.buy
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _FundTrendPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

final class _ClaimStatusView {
  const _ClaimStatusView(this.label, this.status, this.color);

  final String label;
  final VitStatusPillStatus status;
  final Color color;
}

_ClaimStatusView _claimStatusConfig(P2PInsuranceClaimStatus status) {
  return switch (status) {
    P2PInsuranceClaimStatus.pending => const _ClaimStatusView(
      'Chờ xử lý',
      VitStatusPillStatus.warning,
      AppColors.warn,
    ),
    P2PInsuranceClaimStatus.reviewing => const _ClaimStatusView(
      'Đang xem xét',
      VitStatusPillStatus.orange,
      AppModuleAccents.p2p,
    ),
    P2PInsuranceClaimStatus.approved => const _ClaimStatusView(
      'Đã duyệt',
      VitStatusPillStatus.success,
      AppColors.buy,
    ),
    P2PInsuranceClaimStatus.rejected => const _ClaimStatusView(
      'Từ chối',
      VitStatusPillStatus.error,
      AppColors.sell,
    ),
    P2PInsuranceClaimStatus.paid => const _ClaimStatusView(
      'Đã chi trả',
      VitStatusPillStatus.success,
      AppColors.buy,
    ),
  };
}

String _formatVnd(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    if (i > 0 && (raw.length - i) % 3 == 0) buffer.write('.');
    buffer.write(raw[i]);
  }
  return buffer.toString();
}

String _formatCompactVnd(int value) {
  if (value >= 1000000000) {
    return '${(value / 1000000000).toStringAsFixed(2)}B';
  }
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(0)}M';
  }
  return _formatVnd(value);
}
