import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/earn_repository.dart';

class StakingMultiChainPage extends ConsumerWidget {
  const StakingMultiChainPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc367_info_banner');
  static const totalStatsKey = Key('sc367_total_stats');
  static const allocationKey = Key('sc367_allocation_chart');
  static const positionsKey = Key('sc367_positions');
  static const quickActionsKey = Key('sc367_quick_actions');
  static const apyComparisonKey = Key('sc367_apy_comparison');
  static const benefitsKey = Key('sc367_benefits');
  static const technicalNoteKey = Key('sc367_technical_note');

  static Key chainKey(StakingChainId id) => Key('sc367_chain_${id.name}');

  static Key manageKey(StakingChainId id) => Key('sc367_manage_${id.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(stakingMultiChainRepositoryProvider)
        .getMultiChain();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-367 StakingMultiChainPage',
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
                    _TotalStats(snapshot: snapshot),
                    _AllocationCard(snapshot: snapshot),
                    _PositionsSection(snapshot: snapshot),
                    _QuickActions(snapshot: snapshot),
                    _ApyComparison(snapshot: snapshot),
                    _Benefits(snapshot: snapshot),
                    _TechnicalNote(snapshot: snapshot),
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

  final StakingMultiChainSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingMultiChainPage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.accent30,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.public_rounded,
            color: AppColors.accent,
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
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalStats extends StatelessWidget {
  const _TotalStats({required this.snapshot});

  final StakingMultiChainSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingMultiChainPage.totalStatsKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Portfolio Value',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _formatUsd(snapshot.totalValue, decimals: 0),
                    style: AppTextStyles.heroNumber.copyWith(fontSize: 30),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              const _GainPill(label: '+12.4%'),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _MiniMetric(
                  label: '24h Rewards',
                  value: '+\$${snapshot.totalRewards24h.toStringAsFixed(2)}',
                  valueColor: AppColors.buy,
                ),
              ),
              Expanded(
                child: _MiniMetric(
                  label: 'Avg APY',
                  value: '${snapshot.avgApy}%',
                ),
              ),
              Expanded(
                child: _MiniMetric(
                  label: 'Active Chains',
                  value: '${snapshot.activeChains}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

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
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _GainPill extends StatelessWidget {
  const _GainPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: const BoxDecoration(
        color: AppColors.buy15,
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.buy,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _AllocationCard extends StatelessWidget {
  const _AllocationCard({required this.snapshot});

  final StakingMultiChainSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingMultiChainPage.allocationKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Chain Allocation', style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: 170,
            child: CustomPaint(
              painter: _DonutPainter(
                positions: snapshot.positions,
                totalValue: snapshot.totalValue,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Wrap(
            spacing: AppSpacing.x5,
            runSpacing: AppSpacing.x2,
            children: [
              for (final position in snapshot.positions)
                _LegendItem(
                  position: position,
                  share: position.value / snapshot.totalValue * 100,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.position, required this.share});

  final StakingChainPositionDraft position;
  final double share;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSpacing.x3,
            height: AppSpacing.x3,
            decoration: BoxDecoration(
              color: _chainColor(position.chainId),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              '${position.chain} ${share.toStringAsFixed(1)}%',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({required this.positions, required this.totalValue});

  final List<StakingChainPositionDraft> positions;
  final double totalValue;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - AppSpacing.x5;
    final strokeWidth = AppSpacing.x5;
    var start = -math.pi / 2;

    for (final position in positions) {
      final sweep = (position.value / totalValue) * math.pi * 2;
      final paint = Paint()
        ..color = _chainColor(position.chainId)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep - 0.035,
        false,
        paint,
      );
      start += sweep;
    }

    canvas.drawCircle(
      center,
      radius - strokeWidth / 2,
      Paint()
        ..color = AppColors.bg
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.positions != positions ||
        oldDelegate.totalValue != totalValue;
  }
}

class _PositionsSection extends StatelessWidget {
  const _PositionsSection({required this.snapshot});

  final StakingMultiChainSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingMultiChainPage.positionsKey,
      label: 'Positions by Chain',
      accentColor: AppColors.primarySoft,
      children: [
        for (final position in snapshot.positions)
          _ChainPositionCard(
            position: position,
            dashboardRoute: snapshot.dashboardRoute,
          ),
      ],
    );
  }
}

class _ChainPositionCard extends StatelessWidget {
  const _ChainPositionCard({
    required this.position,
    required this.dashboardRoute,
  });

  final StakingChainPositionDraft position;
  final String dashboardRoute;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingMultiChainPage.chainKey(position.chainId),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppSpacing.ctaHeight,
                height: AppSpacing.ctaHeight,
                decoration: BoxDecoration(
                  color: _chainTint(position.chainId),
                  borderRadius: AppRadii.xlRadius,
                ),
                child: Icon(
                  _chainIcon(position.chainId),
                  color: AppColors.text1,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(position.chain, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${_formatAmount(position.staked)} ${position.asset}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatUsd(position.value, decimals: 0),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  _ApyPill(value: '${position.apy}% APY'),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCtaButton(
            key: StakingMultiChainPage.manageKey(position.chainId),
            variant: VitCtaButtonVariant.secondary,
            height: AppSpacing.buttonCompact,
            trailing: const Icon(Icons.arrow_forward_rounded),
            onPressed: () {
              HapticFeedback.selectionClick();
              context.go(dashboardRoute);
            },
            child: const Text('Manage Position'),
          ),
        ],
      ),
    );
  }
}

class _ApyPill extends StatelessWidget {
  const _ApyPill({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: const BoxDecoration(
        color: AppColors.buy15,
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        value,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.buy,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.snapshot});

  final StakingMultiChainSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingMultiChainPage.quickActionsKey,
      label: 'Quick Actions',
      accentColor: AppColors.primarySoft,
      children: [
        Row(
          children: [
            for (var i = 0; i < snapshot.quickActions.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.x4),
              Expanded(child: _ActionCard(action: snapshot.quickActions[i])),
            ],
          ],
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.action});

  final StakingMultiChainInfoDraft action;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _infoIcon(action.icon),
            color: action.icon == 'globe' ? AppColors.accent : AppColors.buy,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            action.title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            action.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ApyComparison extends StatelessWidget {
  const _ApyComparison({required this.snapshot});

  final StakingMultiChainSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final sorted = snapshot.positions.toList()
      ..sort((a, b) => b.apy.compareTo(a.apy));

    return VitCard(
      key: StakingMultiChainPage.apyComparisonKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('APY Comparison', style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.x4),
          for (final position in sorted) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    position.chain,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                Text(
                  '${position.apy}%',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x1),
            ClipRRect(
              borderRadius: AppRadii.smRadius,
              child: LinearProgressIndicator(
                minHeight: AppSpacing.x2,
                value: position.apy / 12.5,
                backgroundColor: AppColors.surface3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _chainColor(position.chainId),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _Benefits extends StatelessWidget {
  const _Benefits({required this.snapshot});

  final StakingMultiChainSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingMultiChainPage.benefitsKey,
      label: 'Why Multi-Chain?',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < snapshot.benefits.length; i++) ...[
                if (i > 0) const Divider(color: AppColors.borderSolid),
                Text(
                  snapshot.benefits[i].title,
                  style: AppTextStyles.baseMedium,
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.benefits[i].description,
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

class _TechnicalNote extends StatelessWidget {
  const _TechnicalNote({required this.snapshot});

  final StakingMultiChainSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingMultiChainPage.technicalNoteKey,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              snapshot.technicalNote,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

Color _chainColor(StakingChainId id) {
  return switch (id) {
    StakingChainId.ethereum => AppColors.primarySoft,
    StakingChainId.polygon => AppColors.accent,
    StakingChainId.avalanche => AppColors.sell,
    StakingChainId.cosmos => AppColors.text3,
    StakingChainId.solana => AppColors.buy,
  };
}

Color _chainTint(StakingChainId id) {
  return switch (id) {
    StakingChainId.ethereum => AppColors.primary15,
    StakingChainId.polygon => AppColors.accent15,
    StakingChainId.avalanche => AppColors.sell15,
    StakingChainId.cosmos => AppColors.surface3,
    StakingChainId.solana => AppColors.buy15,
  };
}

IconData _chainIcon(StakingChainId id) {
  return switch (id) {
    StakingChainId.ethereum => Icons.diamond_outlined,
    StakingChainId.polygon => Icons.change_history_rounded,
    StakingChainId.avalanche => Icons.terrain_rounded,
    StakingChainId.cosmos => Icons.hub_outlined,
    StakingChainId.solana => Icons.radio_button_checked_rounded,
  };
}

IconData _infoIcon(String icon) {
  return switch (icon) {
    'trend' => Icons.trending_up_rounded,
    'globe' => Icons.public_rounded,
    'shield' => Icons.shield_outlined,
    'cost' => Icons.local_gas_station_outlined,
    _ => Icons.public_rounded,
  };
}

String _formatUsd(double value, {int decimals = 2}) {
  final parts = value.toStringAsFixed(decimals).split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(whole[i]);
  }
  if (decimals == 0) return '\$${buffer.toString()}';
  return '\$${buffer.toString()}.${parts.last}';
}

String _formatAmount(double value) {
  if (value >= 1000) {
    final whole = value.round().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < whole.length; i++) {
      if (i > 0 && (whole.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(whole[i]);
    }
    return buffer.toString();
  }
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(1);
}
