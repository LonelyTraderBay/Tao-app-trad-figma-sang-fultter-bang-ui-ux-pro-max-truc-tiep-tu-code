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

class StakingCustodyPage extends ConsumerStatefulWidget {
  const StakingCustodyPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc375_custody_hero');
  static const custodianKey = Key('sc375_custodian_card');
  static const segregationKey = Key('sc375_segregation_card');
  static const hotColdKey = Key('sc375_hot_cold_card');
  static const reconciliationKey = Key('sc375_reconciliation_card');
  static const transparencyKey = Key('sc375_transparency_card');
  static const auditTrailButtonKey = Key('sc375_audit_trail_button');
  static const feedbackKey = Key('sc375_feedback');
  static const footerKey = Key('sc375_footer');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingCustodyPage> createState() => _StakingCustodyPageState();
}

class _StakingCustodyPageState extends ConsumerState<StakingCustodyPage> {
  String? _feedback;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(stakingCustodyRepositoryProvider).getCustody();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-375 StakingCustodyPage',
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
                    _HeroCard(snapshot: snapshot),
                    if (_feedback != null) _FeedbackNote(text: _feedback!),
                    _CustodianSection(custodian: snapshot.custodian),
                    _SegregationSection(snapshot: snapshot),
                    _HotColdSection(snapshot: snapshot),
                    _ReconciliationSection(
                      snapshot: snapshot,
                      onAuditTrail: _openAuditTrail,
                    ),
                    _TransparencySection(snapshot: snapshot),
                    _FooterNote(text: snapshot.footerNote),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAuditTrail() {
    HapticFeedback.selectionClick();
    setState(() => _feedback = 'Opening full custody audit trail');
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.snapshot});

  final StakingCustodySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingCustodyPage.heroKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            color: AppColors.buy,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.heroTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.heroBody,
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

class _FeedbackNote extends StatelessWidget {
  const _FeedbackNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingCustodyPage.feedbackKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.primarySoft,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustodianSection extends StatelessWidget {
  const _CustodianSection({required this.custodian});

  final StakingCustodianDraft custodian;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Third-Party Custodian',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          key: StakingCustodyPage.custodianKey,
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _LargeIconBox(
                    icon: Icons.local_fire_department_rounded,
                    color: AppColors.primarySoft,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(custodian.name, style: AppTextStyles.sectionTitle),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          custodian.type,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        Wrap(
                          spacing: AppSpacing.x2,
                          runSpacing: AppSpacing.x2,
                          children: const [
                            _SmallPill(
                              label: 'Regulated',
                              color: AppColors.buy,
                            ),
                            _SmallPill(
                              label: 'Insured',
                              color: AppColors.primarySoft,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.95,
                crossAxisSpacing: AppSpacing.x3,
                mainAxisSpacing: AppSpacing.x3,
                children: [
                  _MetricTile(label: 'Founded', value: custodian.founded),
                  _MetricTile(
                    label: 'Headquarters',
                    value: custodian.headquarters,
                  ),
                  _MetricTile(label: 'Clients', value: custodian.clients),
                  _MetricTile(label: 'AUM Transferred', value: custodian.aum),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              VitCard(
                variant: VitCardVariant.inner,
                borderColor: AppColors.buy20,
                padding: const EdgeInsets.all(AppSpacing.x3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      color: AppColors.buy,
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Insurance Coverage',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x2),
                          Text(
                            custodian.insurance,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                'Licenses & Certifications',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.x2),
              Wrap(
                spacing: AppSpacing.x2,
                runSpacing: AppSpacing.x2,
                children: [
                  for (final license in custodian.licenses)
                    _SmallPill(label: license, color: AppColors.text1),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SegregationSection extends StatelessWidget {
  const _SegregationSection({required this.snapshot});

  final StakingCustodySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Fund Segregation',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          key: StakingCustodyPage.segregationKey,
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                snapshot.segregationBody,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text2,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              Center(
                child: _PieChart(
                  allocations: snapshot.segregation,
                  size: 190,
                  donut: false,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              Column(
                children: [
                  for (final item in snapshot.segregationLegend) ...[
                    _LegendRow(item: item),
                    if (item != snapshot.segregationLegend.last)
                      const SizedBox(height: AppSpacing.x2),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HotColdSection extends StatelessWidget {
  const _HotColdSection({required this.snapshot});

  final StakingCustodySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Hot vs Cold Wallet Distribution',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          key: StakingCustodyPage.hotColdKey,
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                snapshot.hotColdBody,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text2,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              Center(
                child: _PieChart(
                  allocations: snapshot.hotCold,
                  size: 170,
                  donut: true,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(
                    child: _StorageTile(
                      icon: Icons.lock_outline_rounded,
                      title: 'Cold Storage',
                      description:
                          'Offline, air-gapped, multi-signature hardware wallets',
                      color: AppColors.buy,
                    ),
                  ),
                  SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _StorageTile(
                      icon: Icons.sync_alt_rounded,
                      title: 'Hot Wallet',
                      description:
                          'Online for withdrawals, secured with MPC technology',
                      color: AppColors.warn,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReconciliationSection extends StatelessWidget {
  const _ReconciliationSection({
    required this.snapshot,
    required this.onAuditTrail,
  });

  final StakingCustodySnapshot snapshot;
  final VoidCallback onAuditTrail;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Daily Reconciliation Audit Trail',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          key: StakingCustodyPage.reconciliationKey,
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                snapshot.reconciliationBody,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text2,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              for (final log in snapshot.reconciliationLogs) ...[
                _ReconciliationLogCard(log: log),
                if (log != snapshot.reconciliationLogs.last)
                  const SizedBox(height: AppSpacing.x2),
              ],
              const SizedBox(height: AppSpacing.x3),
              _ActionButton(
                key: StakingCustodyPage.auditTrailButtonKey,
                label: 'View Full Audit Trail',
                onTap: onAuditTrail,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TransparencySection extends StatelessWidget {
  const _TransparencySection({required this.snapshot});

  final StakingCustodySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Transparency Commitment',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          key: StakingCustodyPage.transparencyKey,
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.visibility_outlined,
                color: AppColors.primarySoft,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Real-time On-Chain Verification',
                      style: AppTextStyles.baseMedium,
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      snapshot.transparencyBody,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    for (final address in snapshot.transparencyAddresses) ...[
                      _AddressRow(address: address),
                      if (address != snapshot.transparencyAddresses.last)
                        const SizedBox(height: AppSpacing.x2),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(height: 1.25),
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.item});

  final StakingCustodyLegendDraft item;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(item.tone);
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_iconFor(item.iconKey), color: color, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  item.description,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1.4,
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

class _StorageTile extends StatelessWidget {
  const _StorageTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: color.withValues(alpha: 0.18),
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            description,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReconciliationLogCard extends StatelessWidget {
  const _ReconciliationLogCard({required this.log});

  final StakingReconciliationLogDraft log;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  log.dateLabel,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const _MatchStatus(),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _ReconciliationMetric(
                  label: 'On-chain',
                  value: _formatUsd(log.onChainUsd),
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _ReconciliationMetric(
                  label: 'Custodian',
                  value: _formatUsd(log.custodyUsd),
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _ReconciliationMetric(
                  label: 'Discrepancy',
                  value: _formatUsd(log.discrepancyUsd),
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReconciliationMetric extends StatelessWidget {
  const _ReconciliationMetric({
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
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _MatchStatus extends StatelessWidget {
  const _MatchStatus();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.buy,
            shape: BoxShape.circle,
          ),
          child: SizedBox(width: 6, height: 6),
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          'Matched',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _AddressRow extends StatelessWidget {
  const _AddressRow({required this.address});

  final StakingTransparencyAddressDraft address;

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
                  address.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  address.address,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            'View ->',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.primarySoft,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface3,
      borderRadius: AppRadii.lgRadius,
      child: InkWell(
        borderRadius: AppRadii.lgRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x3,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _LargeIconBox extends StatelessWidget {
  const _LargeIconBox({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.32), width: 1.5),
        borderRadius: AppRadii.xlRadius,
      ),
      child: SizedBox(
        width: 64,
        height: 64,
        child: Icon(icon, color: color, size: 34),
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
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
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingCustodyPage.footerKey,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: 1.5,
        ),
      ),
    );
  }
}

class _PieChart extends StatelessWidget {
  const _PieChart({
    required this.allocations,
    required this.size,
    required this.donut,
  });

  final List<StakingCustodyAllocationDraft> allocations;
  final double size;
  final bool donut;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PieChartPainter(allocations: allocations, donut: donut),
        child: Center(
          child: donut
              ? DecoratedBox(
                  decoration: const BoxDecoration(
                    color: AppColors.cardBg,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox(width: size * 0.48, height: size * 0.48),
                )
              : null,
        ),
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  const _PieChartPainter({required this.allocations, required this.donut});

  final List<StakingCustodyAllocationDraft> allocations;
  final bool donut;

  @override
  void paint(Canvas canvas, Size size) {
    final total = allocations.fold<int>(0, (sum, item) => sum + item.value);
    final rect = Offset.zero & size;
    var start = -math.pi / 2;
    final paint = Paint()..style = PaintingStyle.fill;

    for (final allocation in allocations) {
      final sweep = (allocation.value / total) * math.pi * 2;
      paint.color = _toneColor(allocation.tone);
      canvas.drawArc(rect.deflate(8), start, sweep, true, paint);
      start += sweep;
    }

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.borderSolid;
    canvas.drawCircle(
      size.center(Offset.zero),
      size.shortestSide / 2 - 8,
      stroke,
    );

    if (donut) {
      final holePaint = Paint()
        ..style = PaintingStyle.fill
        ..color = AppColors.cardBg;
      canvas.drawCircle(
        size.center(Offset.zero),
        size.shortestSide * 0.24,
        holePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) {
    return oldDelegate.allocations != allocations || oldDelegate.donut != donut;
  }
}

IconData _iconFor(String iconKey) {
  return switch (iconKey) {
    'building' => Icons.account_balance_outlined,
    'lock' => Icons.lock_outline_rounded,
    'shield' => Icons.shield_outlined,
    _ => Icons.circle_outlined,
  };
}

Color _toneColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.warn,
    EarnRiskLevel.high => AppColors.accent,
  };
}

String _formatUsd(double amount) {
  if (amount >= 1000000000) {
    return '\$${(amount / 1000000000).toStringAsFixed(2)}B';
  }
  if (amount >= 1000000) {
    return '\$${(amount / 1000000).toStringAsFixed(2)}M';
  }
  if (amount == 0) return '\$0.00';
  return '\$${amount.toStringAsFixed(2)}';
}
