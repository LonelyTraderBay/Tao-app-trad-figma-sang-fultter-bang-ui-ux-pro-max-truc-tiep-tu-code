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

enum _InstitutionalBatchTab { pending, executed }

class StakingInstitutionalPage extends ConsumerStatefulWidget {
  const StakingInstitutionalPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc368_info_banner');
  static const statsKey = Key('sc368_stats');
  static const createButtonKey = Key('sc368_create_batch');
  static const createSheetKey = Key('sc368_create_sheet');
  static const tabsKey = Key('sc368_tabs');
  static const signersKey = Key('sc368_signers');
  static const featuresKey = Key('sc368_features');
  static const complianceKey = Key('sc368_compliance');

  static Key tabKey(String id) => Key('sc368_tab_$id');

  static Key batchKey(String id) => Key('sc368_batch_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingInstitutionalPage> createState() =>
      _StakingInstitutionalPageState();
}

class _StakingInstitutionalPageState
    extends ConsumerState<StakingInstitutionalPage> {
  _InstitutionalBatchTab _tab = _InstitutionalBatchTab.pending;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingInstitutionalRepositoryProvider)
        .getInstitutional();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;
    final batches = _tab == _InstitutionalBatchTab.pending
        ? snapshot.pendingBatches
        : snapshot.executedBatches;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-368 StakingInstitutionalPage',
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
                    _StatsCard(snapshot: snapshot),
                    VitCtaButton(
                      key: StakingInstitutionalPage.createButtonKey,
                      onPressed: () => _showCreateBatch(snapshot),
                      child: const Text('Create Batch Operation'),
                    ),
                    _BatchTabs(
                      active: _tab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _tab = tab);
                      },
                    ),
                    VitPageSection(
                      label: _tab == _InstitutionalBatchTab.pending
                          ? 'Pending Approvals'
                          : 'Executed Batches',
                      accentColor: AppColors.primarySoft,
                      children: [
                        for (final batch in batches)
                          _BatchOperationCard(batch: batch),
                      ],
                    ),
                    _AuthorizedSigners(snapshot: snapshot),
                    _EnterpriseFeatures(snapshot: snapshot),
                    _ComplianceNote(snapshot: snapshot),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCreateBatch(StakingInstitutionalSnapshot snapshot) async {
    HapticFeedback.selectionClick();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _SheetFrame(child: _CreateBatchSheet(snapshot: snapshot)),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingInstitutionalSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInstitutionalPage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.apartment_rounded,
            color: AppColors.primarySoft,
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

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.snapshot});

  final StakingInstitutionalSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInstitutionalPage.statsKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          for (var i = 0; i < snapshot.stats.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.x3),
            Expanded(child: _StatTile(stat: snapshot.stats[i])),
          ],
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.stat});

  final StakingInstitutionalStatDraft stat;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(stat.tone);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x3,
      ),
      decoration: BoxDecoration(
        color: _toneFillColor(stat.tone),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Icon(_infoIcon(stat.icon), color: color, size: AppSpacing.iconSm),
          const SizedBox(height: AppSpacing.x2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              stat.value,
              style: AppTextStyles.sectionTitle.copyWith(
                color: stat.tone == 'success' ? AppColors.buy : AppColors.text1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _BatchTabs extends StatelessWidget {
  const _BatchTabs({required this.active, required this.onChanged});

  final _InstitutionalBatchTab active;
  final ValueChanged<_InstitutionalBatchTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: StakingInstitutionalPage.tabsKey,
      decoration: const BoxDecoration(color: AppColors.surface),
      child: Row(
        children: [
          for (final tab in _InstitutionalBatchTab.values)
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  key: StakingInstitutionalPage.tabKey(tab.name),
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

class _BatchOperationCard extends StatelessWidget {
  const _BatchOperationCard({required this.batch});

  final StakingInstitutionalBatchDraft batch;

  @override
  Widget build(BuildContext context) {
    final progress = batch.approvals / batch.requiredApprovals;
    return VitCard(
      key: StakingInstitutionalPage.batchKey(batch.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Batch ${_batchTypeLabel(batch.type)}',
                      style: AppTextStyles.baseMedium,
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${batch.operations} operations - ${_formatAmount(batch.totalAmount)} ETH',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusPill(status: batch.status),
            ],
          ),
          if (batch.status != StakingInstitutionalBatchStatus.executed) ...[
            const SizedBox(height: AppSpacing.x4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Approvals',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
                Text(
                  '${batch.approvals}/${batch.requiredApprovals}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x2),
            ClipRRect(
              borderRadius: AppRadii.xsRadius,
              child: LinearProgressIndicator(
                minHeight: AppSpacing.x2,
                value: progress,
                backgroundColor: AppColors.surface3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  batch.status == StakingInstitutionalBatchStatus.approved
                      ? AppColors.buy
                      : AppColors.warn,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.x3),
          const Divider(height: 1, color: AppColors.borderSolid),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x1),
              Expanded(
                child: Text(
                  batch.created,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              if (batch.status == StakingInstitutionalBatchStatus.pending)
                _InlineAction(label: 'Approve', color: AppColors.primary)
              else if (batch.status == StakingInstitutionalBatchStatus.approved)
                _InlineAction(label: 'Execute', color: AppColors.buy),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final StakingInstitutionalBatchStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      StakingInstitutionalBatchStatus.pending => AppColors.warn,
      StakingInstitutionalBatchStatus.approved => AppColors.primarySoft,
      StakingInstitutionalBatchStatus.executed => AppColors.buy,
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: switch (status) {
          StakingInstitutionalBatchStatus.pending => AppColors.warn15,
          StakingInstitutionalBatchStatus.approved => AppColors.primary15,
          StakingInstitutionalBatchStatus.executed => AppColors.buy15,
        },
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        _statusLabel(status),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _InlineAction extends StatelessWidget {
  const _InlineAction({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadii.lgRadius,
      child: InkWell(
        onTap: HapticFeedback.selectionClick,
        borderRadius: AppRadii.lgRadius,
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadii.lgRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: Colors.white,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthorizedSigners extends StatelessWidget {
  const _AuthorizedSigners({required this.snapshot});

  final StakingInstitutionalSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingInstitutionalPage.signersKey,
      label: 'Authorized Signers',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            children: [
              for (var i = 0; i < snapshot.signers.length; i++) ...[
                if (i > 0) const Divider(color: AppColors.borderSolid),
                _SignerRow(signer: snapshot.signers[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SignerRow extends StatelessWidget {
  const _SignerRow({required this.signer});

  final StakingInstitutionalSignerDraft signer;

  @override
  Widget build(BuildContext context) {
    final approved = signer.status == StakingInstitutionalSignerStatus.approved;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x1),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(signer.name, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${signer.role} - ${signer.address}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Icon(
            approved
                ? Icons.check_circle_outline_rounded
                : Icons.schedule_rounded,
            color: approved ? AppColors.buy : AppColors.warn,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _EnterpriseFeatures extends StatelessWidget {
  const _EnterpriseFeatures({required this.snapshot});

  final StakingInstitutionalSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingInstitutionalPage.featuresKey,
      label: 'Enterprise Features',
      accentColor: AppColors.primarySoft,
      children: [
        GridView.builder(
          itemCount: snapshot.features.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.x3,
            mainAxisSpacing: AppSpacing.x3,
            childAspectRatio: 1.55,
          ),
          itemBuilder: (context, index) =>
              _FeatureCard(feature: snapshot.features[index]),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature});

  final StakingInstitutionalFeatureDraft feature;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _infoIcon(feature.icon),
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
          const Spacer(),
          Text(
            feature.title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            feature.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ComplianceNote extends StatelessWidget {
  const _ComplianceNote({required this.snapshot});

  final StakingInstitutionalSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInstitutionalPage.complianceKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.verified_user_rounded,
            color: AppColors.primarySoft,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.complianceTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.complianceBody,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.contentPad),
        padding: const EdgeInsets.all(AppSpacing.x5),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.88,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.cardLargeRadius,
        ),
        child: child,
      ),
    );
  }
}

class _CreateBatchSheet extends StatelessWidget {
  const _CreateBatchSheet({required this.snapshot});

  final StakingInstitutionalSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: StakingInstitutionalPage.createSheetKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Create Batch Operation',
                  style: AppTextStyles.sectionTitle,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded, color: AppColors.text2),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          _FieldGroup(
            label: 'Operation Type',
            child: _StaticField(
              value: snapshot.operationTypes.first,
              trailing: Icons.expand_more_rounded,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          _FieldGroup(
            label: 'Upload CSV File',
            child: CustomPaint(
              painter: _DashedBorderPainter(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.x4),
                child: Column(
                  children: [
                    const Icon(
                      Icons.description_outlined,
                      color: AppColors.text3,
                      size: AppSpacing.iconLg,
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      'Drop CSV or click to upload',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      snapshot.csvFormatNote,
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
          VitCtaButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Submit for Approval'),
          ),
        ],
      ),
    );
  }
}

class _FieldGroup extends StatelessWidget {
  const _FieldGroup({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x3),
        child,
      ],
    );
  }
}

class _StaticField extends StatelessWidget {
  const _StaticField({required this.value, required this.trailing});

  final String value;
  final IconData trailing;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x4,
      ),
      child: Row(
        children: [
          Expanded(child: Text(value, style: AppTextStyles.body)),
          Icon(trailing, color: AppColors.text2, size: AppSpacing.iconSm),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 6.0;
    const dashSpace = 5.0;
    final paint = Paint()
      ..color = AppColors.borderSolid
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(AppRadii.lg),
    );
    final path = Path()..addRRect(rect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

String _tabLabel(_InstitutionalBatchTab tab) {
  return switch (tab) {
    _InstitutionalBatchTab.pending => 'Pending',
    _InstitutionalBatchTab.executed => 'Executed',
  };
}

String _batchTypeLabel(StakingInstitutionalBatchType type) {
  return switch (type) {
    StakingInstitutionalBatchType.stake => 'Stake',
    StakingInstitutionalBatchType.unstake => 'Unstake',
    StakingInstitutionalBatchType.claim => 'Claim',
  };
}

String _statusLabel(StakingInstitutionalBatchStatus status) {
  return switch (status) {
    StakingInstitutionalBatchStatus.pending => 'Pending',
    StakingInstitutionalBatchStatus.approved => 'Approved',
    StakingInstitutionalBatchStatus.executed => 'Executed',
  };
}

String _formatAmount(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(1);
}

Color _toneColor(String tone) {
  return switch (tone) {
    'primary' => AppColors.primarySoft,
    'success' => AppColors.buy,
    _ => AppColors.text3,
  };
}

Color _toneFillColor(String tone) {
  return switch (tone) {
    'primary' => AppColors.primary15,
    'success' => AppColors.buy15,
    _ => AppColors.surface2,
  };
}

IconData _infoIcon(String icon) {
  return switch (icon) {
    'building' => Icons.apartment_rounded,
    'users' => Icons.group_rounded,
    'shield' => Icons.shield_outlined,
    'file' => Icons.description_outlined,
    _ => Icons.verified_user_rounded,
  };
}
