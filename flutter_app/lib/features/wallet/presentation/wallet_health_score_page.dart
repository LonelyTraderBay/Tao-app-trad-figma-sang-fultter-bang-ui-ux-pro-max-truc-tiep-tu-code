import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/wallet_repository.dart';

const _healthBackground = AppColors.bg;
const _healthPanel = AppColors.surface;
const _healthBorder = Color(0x14FFFFFF);
const _healthPrimary = AppColors.primary;
const _healthGreen = Color(0xFF10B981);
const _healthAmber = Color(0xFFF59E0B);
const _healthOrange = Color(0xFFF97316);
const _healthRed = Color(0xFFEF4444);
const _healthPurple = Color(0xFF8B5CF6);

const _tabOverview = 'T\u1ED5ng quan';
const _tabSecurity = 'B\u1EA3o m\u1EADt';
const _tabDiversification = '\u0110a d\u1EA1ng h\u00F3a';

class WalletHealthScorePage extends ConsumerStatefulWidget {
  const WalletHealthScorePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc151_health_score_content');
  static Key tabKey(String label) => Key('sc151_health_score_tab_$label');
  static Key recommendationKey(String id) =>
      Key('sc151_health_score_recommendation_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<WalletHealthScorePage> createState() =>
      _WalletHealthScorePageState();
}

class _WalletHealthScorePageState extends ConsumerState<WalletHealthScorePage> {
  String _tab = _tabOverview;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(walletRepositoryProvider).getHealthScore();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-151 WalletHealthScorePage',
      child: Material(
        color: _healthBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Wallet Health',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.wallet),
            ),
            _HealthTabs(
              activeTab: _tab,
              onChanged: (tab) => setState(() => _tab = tab),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: WalletHealthScorePage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 12, 20, bottomInset),
                physics: const BouncingScrollPhysics(),
                child: _buildTab(snapshot),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(WalletHealthScoreSnapshot snapshot) {
    if (_tab == _tabSecurity) return _SecurityTab(snapshot: snapshot);
    if (_tab == _tabDiversification) {
      return _DiversificationTab(snapshot: snapshot);
    }
    return _OverviewTab(
      snapshot: snapshot,
      onRecommendationTap: _showRecommendationSheet,
    );
  }

  void _showRecommendationSheet(WalletHealthRecommendation recommendation) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _healthPanel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  recommendation.actionLabel,
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  recommendation.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _healthPrimary,
                      borderRadius: AppRadii.inputRadius,
                    ),
                    child: Text(
                      'Done',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HealthTabs extends StatelessWidget {
  const _HealthTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: const BoxDecoration(
        color: _healthPanel,
        border: Border(bottom: BorderSide(color: _healthBorder)),
      ),
      child: Row(
        children: [
          for (final tab in const [
            _tabOverview,
            _tabSecurity,
            _tabDiversification,
          ])
            Expanded(
              child: GestureDetector(
                key: WalletHealthScorePage.tabKey(tab),
                onTap: () => onChanged(tab),
                behavior: HitTestBehavior.opaque,
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        tab,
                        style: AppTextStyles.caption.copyWith(
                          color: activeTab == tab
                              ? _healthPrimary
                              : const Color(0xFF566175),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 7,
                      right: 7,
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        height: 2,
                        decoration: BoxDecoration(
                          color: activeTab == tab
                              ? _healthPrimary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    required this.snapshot,
    required this.onRecommendationTap,
  });

  final WalletHealthScoreSnapshot snapshot;
  final ValueChanged<WalletHealthRecommendation> onRecommendationTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _OverallScoreCard(snapshot: snapshot),
        const SizedBox(height: 16),
        _RadarCard(metrics: snapshot.metrics),
        const SizedBox(height: 16),
        const _SectionLabel(label: 'Chi ti\u1EBFt \u0111i\u1EC3m'),
        const SizedBox(height: 10),
        for (final metric in snapshot.metrics) ...[
          _MetricCard(metric: metric),
          if (metric != snapshot.metrics.last) const SizedBox(height: 8),
        ],
        const SizedBox(height: 16),
        _TrendCard(history: snapshot.history),
        const SizedBox(height: 16),
        const _SectionLabel(label: '\u0110\u1EC1 xu\u1EA5t \u01B0u ti\u00EAn'),
        const SizedBox(height: 10),
        for (final rec in snapshot.priorityRecommendations) ...[
          _RecommendationCard(
            recommendation: rec,
            onTap: () => onRecommendationTap(rec),
          ),
          if (rec != snapshot.priorityRecommendations.last)
            const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _OverallScoreCard extends StatelessWidget {
  const _OverallScoreCard({required this.snapshot});

  final WalletHealthScoreSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final scoreColor = _scoreColor(snapshot.overallScore);
    return Container(
      height: 292,
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 20),
      decoration: BoxDecoration(
        color: _healthPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _healthBorder),
      ),
      child: Column(
        children: [
          Text(
            'Overall Health Score',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size.square(160),
                  painter: _GaugePainter(
                    score: snapshot.overallScore,
                    color: scoreColor,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${snapshot.overallScore}',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: scoreColor,
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Roboto',
                        height: .95,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '/ 100',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            snapshot.overallStatus,
            style: AppTextStyles.caption.copyWith(
              color: scoreColor,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your wallet is ${snapshot.overallMessage}',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _RadarCard extends StatelessWidget {
  const _RadarCard({required this.metrics});

  final List<WalletHealthMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 325,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: _healthPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _healthBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Breakdown',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: CustomPaint(
              painter: _RadarPainter(metrics),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final WalletHealthMetric metric;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(metric.status);
    return Container(
      height: 60,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      decoration: BoxDecoration(
        color: _healthPanel,
        borderRadius: AppRadii.inputRadius,
        border: Border.all(color: _healthBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  metric.category,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
              Text(
                '${metric.score}',
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Roboto',
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              _StatusBadge(label: metric.status, color: color),
            ],
          ),
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 6,
              child: LinearProgressIndicator(
                value: metric.score / metric.maxScore,
                backgroundColor: _healthBackground,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard({required this.history});

  final List<WalletHealthHistoryPoint> history;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 205,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      decoration: BoxDecoration(
        color: _healthPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _healthBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Trend (6 months)',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: CustomPaint(
              painter: _TrendPainter(history),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.recommendation,
    required this.onTap,
  });

  final WalletHealthRecommendation recommendation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final impactColor = _impactColor(recommendation.impact);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _healthPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _healthBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  recommendation.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
              _StatusBadge(
                label: '${recommendation.impact} impact',
                color: impactColor,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            recommendation.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            key: WalletHealthScorePage.recommendationKey(recommendation.id),
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _healthPrimary,
                borderRadius: AppRadii.cardRadius,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    recommendation.actionLabel,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityTab extends StatelessWidget {
  const _SecurityTab({required this.snapshot});

  final WalletHealthScoreSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final metric = snapshot.metricByCategory('Security');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ScoreSummaryCard(
          icon: Icons.shield_outlined,
          iconColor: _healthPrimary,
          title: 'Security Score',
          subtitle: 'Based on 8 security factors',
          score: metric.score,
          status: 'Good',
        ),
        const SizedBox(height: 16),
        const _SectionLabel(label: 'Security Checklist'),
        const SizedBox(height: 10),
        for (final item in snapshot.securityChecklist) ...[
          _ChecklistCard(item: item),
          if (item != snapshot.securityChecklist.last)
            const SizedBox(height: 8),
        ],
        const SizedBox(height: 16),
        const _ActionRequiredCard(),
      ],
    );
  }
}

class _DiversificationTab extends StatelessWidget {
  const _DiversificationTab({required this.snapshot});

  final WalletHealthScoreSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final metric = snapshot.metricByCategory('Diversification');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ScoreSummaryCard(
          icon: Icons.track_changes_rounded,
          iconColor: _healthAmber,
          title: 'Diversification',
          subtitle: 'Portfolio balance analysis',
          score: metric.score,
          status: 'Moderate',
        ),
        const SizedBox(height: 16),
        _AssetDistributionCard(slices: snapshot.diversification),
        const SizedBox(height: 16),
        const _ConcentrationRiskCard(),
        const SizedBox(height: 16),
        const _SectionLabel(label: 'Diversification Tips'),
        const SizedBox(height: 10),
        for (final tip in const [
          'Maintain 15-25% in stablecoins for liquidity',
          'Limit single asset to max 30% of portfolio',
          'Spread across 5-10 quality assets',
          'Rebalance quarterly to maintain targets',
        ]) ...[
          _TipCard(tip: tip),
          if (tip != 'Rebalance quarterly to maintain targets')
            const SizedBox(height: 8),
        ],
        const SizedBox(height: 16),
        const _InfoCard(
          text:
              'Diversification reduces portfolio volatility. Aim for balance across asset types and risk levels.',
        ),
      ],
    );
  }
}

class _ScoreSummaryCard extends StatelessWidget {
  const _ScoreSummaryCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.score,
    required this.status,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final int score;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _healthPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _healthBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: .08),
              borderRadius: AppRadii.inputRadius,
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$score',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: iconColor,
                  fontSize: 24,
                  fontFamily: 'Roboto',
                ),
              ),
              Text(
                status,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard({required this.item});

  final WalletSecurityChecklistItem item;

  @override
  Widget build(BuildContext context) {
    final color = item.enabled ? _healthGreen : _healthRed;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _healthPanel,
        borderRadius: AppRadii.mdRadius,
        border: Border.all(color: _healthBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Icon(
              item.enabled
                  ? Icons.check_circle_outline_rounded
                  : Icons.warning_amber_rounded,
              color: color,
              size: 14,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.item,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    height: 1,
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

class _ActionRequiredCard extends StatelessWidget {
  const _ActionRequiredCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _healthRed.withValues(alpha: .06),
        borderRadius: AppRadii.mdRadius,
        border: Border.all(color: _healthRed.withValues(alpha: .15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: _healthRed, size: 14),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Action Required',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Backup your seed phrase and enable withdrawal whitelist to improve security score.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 11,
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

class _AssetDistributionCard extends StatelessWidget {
  const _AssetDistributionCard({required this.slices});

  final List<WalletDiversificationSlice> slices;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _healthPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _healthBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Asset Distribution',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: _PiePainter(slices),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              for (final slice in slices)
                SizedBox(
                  width: 156,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Color(slice.colorHex),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        slice.name,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConcentrationRiskCard extends StatelessWidget {
  const _ConcentrationRiskCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _healthAmber.withValues(alpha: .06),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _healthAmber.withValues(alpha: .15)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: _healthAmber,
                size: 16,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Concentration Risk',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '42% of your portfolio is in BTC. Consider rebalancing to reduce single-asset risk.',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontSize: 11,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const _AllocationRow(
            label: 'Recommended BTC allocation',
            value: '25-30%',
            color: _healthAmber,
          ),
          const SizedBox(height: 10),
          const _AllocationRow(
            label: 'Current BTC allocation',
            value: '42%',
            color: _healthRed,
          ),
        ],
      ),
    );
  }
}

class _AllocationRow extends StatelessWidget {
  const _AllocationRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});

  final String tip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _healthPanel,
        borderRadius: AppRadii.mdRadius,
        border: Border.all(color: _healthBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.bolt_rounded, color: _healthAmber, size: 14),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              tip,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _healthPrimary.withValues(alpha: .06),
        borderRadius: AppRadii.mdRadius,
        border: Border.all(color: _healthPrimary.withValues(alpha: .15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _healthPrimary,
            size: 14,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: _healthPrimary,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  const _GaugePainter({required this.score, required this.color});

  final int score;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;
    canvas.drawCircle(center, radius, stroke..color = _healthBackground);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * (score / 100),
      false,
      stroke
        ..color = color
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.score != score || oldDelegate.color != color;
}

class _RadarPainter extends CustomPainter {
  const _RadarPainter(this.metrics);

  final List<WalletHealthMetric> metrics;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 10);
    final radius = math.min(size.width, size.height) * .36;
    final gridPaint = Paint()
      ..color = _healthBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = Colors.white.withValues(alpha: .08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final angles = List<double>.generate(
      metrics.length,
      (index) => -math.pi / 2 + (math.pi * 2 * index / metrics.length),
    );

    for (final fraction in const [.25, .5, .75, 1.0]) {
      final path = Path();
      for (var i = 0; i < metrics.length; i++) {
        final point =
            center +
            Offset(math.cos(angles[i]), math.sin(angles[i])) *
                (radius * fraction);
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    for (var i = 0; i < metrics.length; i++) {
      final point =
          center + Offset(math.cos(angles[i]), math.sin(angles[i])) * radius;
      canvas.drawLine(center, point, axisPaint);
      _drawRadarLabel(canvas, size, metrics[i].category, point, angles[i]);
    }

    final shape = Path();
    for (var i = 0; i < metrics.length; i++) {
      final metric = metrics[i];
      final value = metric.score / metric.maxScore;
      final point =
          center +
          Offset(math.cos(angles[i]), math.sin(angles[i])) * (radius * value);
      if (i == 0) {
        shape.moveTo(point.dx, point.dy);
      } else {
        shape.lineTo(point.dx, point.dy);
      }
    }
    shape.close();
    canvas.drawPath(
      shape,
      Paint()
        ..color = _healthPurple.withValues(alpha: .42)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      shape,
      Paint()
        ..color = _healthPurple
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    for (final tick in const [25, 50, 75, 100]) {
      final offset = center + Offset(4, -radius * tick / 100);
      _drawText(
        canvas,
        '$tick',
        offset,
        AppColors.text3,
        9,
        align: TextAlign.left,
      );
    }
  }

  void _drawRadarLabel(
    Canvas canvas,
    Size size,
    String label,
    Offset point,
    double angle,
  ) {
    final labelPoint = point + Offset(math.cos(angle), math.sin(angle)) * 20;
    final align = math.cos(angle) > .3
        ? TextAlign.left
        : math.cos(angle) < -.3
        ? TextAlign.right
        : TextAlign.center;
    _drawText(canvas, label, labelPoint, AppColors.text2, 10, align: align);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) =>
      oldDelegate.metrics != metrics;
}

class _TrendPainter extends CustomPainter {
  const _TrendPainter(this.history);

  final List<WalletHealthHistoryPoint> history;

  @override
  void paint(Canvas canvas, Size size) {
    final left = 56.0;
    final right = 6.0;
    final top = 10.0;
    final bottom = 28.0;
    final chart = Rect.fromLTRB(
      left,
      top,
      size.width - right,
      size.height - bottom,
    );
    final axis = Paint()
      ..color = _healthBorder
      ..strokeWidth = 1;
    canvas.drawLine(chart.bottomLeft, chart.topLeft, axis);
    canvas.drawLine(chart.bottomLeft, chart.bottomRight, axis);

    for (final y in const [0, 50, 100]) {
      final dy = chart.bottom - (chart.height * y / 100);
      _drawText(
        canvas,
        '$y',
        Offset(chart.left - 8, dy - 6),
        AppColors.text3,
        10,
        align: TextAlign.right,
      );
    }

    final points = <Offset>[];
    for (var i = 0; i < history.length; i++) {
      final x = chart.left + chart.width * i / (history.length - 1);
      final y = chart.bottom - chart.height * history[i].score / 100;
      points.add(Offset(x, y));
      _drawText(
        canvas,
        history[i].month,
        Offset(x, chart.bottom + 12),
        AppColors.text3,
        10,
        align: TextAlign.center,
      );
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = _healthPurple
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
    for (final point in points) {
      canvas.drawCircle(point, 5, Paint()..color = _healthPurple);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) =>
      oldDelegate.history != history;
}

class _PiePainter extends CustomPainter {
  const _PiePainter(this.slices);

  final List<WalletDiversificationSlice> slices;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * .40;
    var start = -math.pi / 2;
    final total = slices.fold<int>(0, (sum, slice) => sum + slice.value);
    for (final slice in slices) {
      final sweep = math.pi * 2 * slice.value / total;
      final paint = Paint()
        ..color = Color(slice.colorHex)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 30
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        paint,
      );
      final labelAngle = start + sweep / 2;
      final labelPoint =
          center + Offset(math.cos(labelAngle), math.sin(labelAngle)) * radius;
      _drawText(
        canvas,
        '${slice.value}%',
        labelPoint,
        Colors.white,
        10,
        align: TextAlign.center,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _PiePainter oldDelegate) =>
      oldDelegate.slices != slices;
}

void _drawText(
  Canvas canvas,
  String text,
  Offset offset,
  Color color,
  double fontSize, {
  TextAlign align = TextAlign.center,
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: 'Roboto',
        height: 1,
      ),
    ),
    textAlign: align,
    textDirection: TextDirection.ltr,
    maxLines: 1,
  )..layout(maxWidth: 120);

  final dx = switch (align) {
    TextAlign.left => offset.dx,
    TextAlign.right => offset.dx - painter.width,
    _ => offset.dx - painter.width / 2,
  };
  painter.paint(canvas, Offset(dx, offset.dy));
}

Color _scoreColor(int score) {
  if (score >= 80) return _healthGreen;
  if (score >= 60) return _healthAmber;
  if (score >= 40) return _healthOrange;
  return _healthRed;
}

Color _statusColor(String status) {
  return switch (status) {
    'excellent' => _healthGreen,
    'good' => _healthPrimary,
    'warning' => _healthAmber,
    'critical' => _healthRed,
    _ => AppColors.text3,
  };
}

Color _impactColor(String impact) {
  return switch (impact) {
    'high' => _healthRed,
    'medium' => _healthAmber,
    'low' => _healthGreen,
    _ => AppColors.text3,
  };
}
