import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/p2p/data/p2p_repository.dart';

enum _ClaimDetailSection { timeline, evidence, notes }

class P2PClaimDetailPage extends ConsumerStatefulWidget {
  const P2PClaimDetailPage({
    super.key,
    required this.claimId,
    this.shellRenderMode,
  });

  static const heroKey = Key('sc243_p2p_claim_hero');
  static const benchmarksKey = Key('sc243_p2p_claim_benchmarks');
  static const descriptionKey = Key('sc243_p2p_claim_description');
  static const tabsKey = Key('sc243_p2p_claim_tabs');
  static const timelineKey = Key('sc243_p2p_claim_timeline');
  static const evidenceKey = Key('sc243_p2p_claim_evidence');
  static const notesKey = Key('sc243_p2p_claim_notes');
  static const notificationsKey = Key('sc243_p2p_claim_notifications');
  static const orderLinkKey = Key('sc243_p2p_claim_order_link');
  static const supportLinkKey = Key('sc243_p2p_claim_support_link');
  static const receiptKey = Key('sc243_p2p_claim_receipt');
  static const feedbackKey = Key('sc243_p2p_claim_feedback');

  final String claimId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PClaimDetailPage> createState() => _P2PClaimDetailPageState();
}

class _P2PClaimDetailPageState extends ConsumerState<P2PClaimDetailPage> {
  _ClaimDetailSection _section = _ClaimDetailSection.timeline;
  late bool _notificationsEnabled;
  String? _feedback;

  @override
  void initState() {
    super.initState();
    final snapshot = const MockP2PRepository().getClaimDetail(widget.claimId);
    _notificationsEnabled = snapshot.claim.notificationsEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(p2pRepositoryProvider)
        .getClaimDetail(widget.claimId);
    final claim = snapshot.claim;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-243 P2PClaimDetailPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: claim.claimCode,
              subtitle: 'Bảo hiểm · P2P',
              showBack: true,
              action: VitHeaderAction.bell,
              onBack: () => context.go(snapshot.parentRoute),
              onAction: () {
                HapticFeedback.selectionClick();
                setState(() {
                  _notificationsEnabled = !_notificationsEnabled;
                  _feedback = _notificationsEnabled
                      ? 'Đã bật thông báo claim'
                      : 'Đã tắt thông báo claim';
                });
              },
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _ClaimHeroCard(claim: claim),
                      const SizedBox(height: AppSpacing.x5),
                      _ClaimBenchmarksCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      _DescriptionCard(description: claim.description),
                      const SizedBox(height: AppSpacing.x4),
                      _ClaimSectionTabs(
                        active: _section,
                        claim: claim,
                        onChanged: (section) {
                          HapticFeedback.selectionClick();
                          setState(() => _section = section);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _ClaimSectionBody(section: _section, claim: claim),
                      const SizedBox(height: AppSpacing.x5),
                      _NotificationsCard(
                        enabled: _notificationsEnabled,
                        onChanged: (value) {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _notificationsEnabled = value;
                            _feedback = value
                                ? 'Đã bật thông báo claim'
                                : 'Đã tắt thông báo claim';
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _ActionRow(
                        key: P2PClaimDetailPage.orderLinkKey,
                        icon: Icons.open_in_new_rounded,
                        title: 'Xem đơn hàng gốc',
                        onTap: () {
                          HapticFeedback.selectionClick();
                          context.go(snapshot.orderRoute);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      _ActionRow(
                        key: P2PClaimDetailPage.supportLinkKey,
                        icon: Icons.help_outline_rounded,
                        title: 'Liên hệ hỗ trợ',
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(
                            () => _feedback =
                                'Đã mở luồng hỗ trợ cho ${claim.claimCode}',
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      if (_feedback != null) ...[
                        _FeedbackBanner(message: _feedback!),
                        const SizedBox(height: AppSpacing.x4),
                      ],
                      if (claim.status == P2PInsuranceClaimStatus.paid)
                        VitCtaButton(
                          key: P2PClaimDetailPage.receiptKey,
                          variant: VitCtaButtonVariant.success,
                          leading: const Icon(Icons.download_rounded),
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            setState(
                              () => _feedback =
                                  'Đã chuẩn bị biên lai ${claim.claimCode}',
                            );
                          },
                          child: const Text('Tải biên lai'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClaimHeroCard extends StatelessWidget {
  const _ClaimHeroCard({required this.claim});

  final P2PClaimDetailDraft claim;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PClaimDetailPage.heroKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              VitStatusPill(
                label: claim.statusLabel,
                status: _statusPill(claim.status),
                icon: _statusIcon(claim.status),
                size: VitStatusPillSize.lg,
              ),
              const Spacer(),
              VitStatusPill(
                label: claim.claimCode,
                status: VitStatusPillStatus.neutral,
                icon: Icons.content_copy_rounded,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          _ClaimProgress(status: claim.status),
          const SizedBox(height: AppSpacing.x5),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.x4),
          _InfoRow(
            label: 'Lệnh P2P',
            value: claim.orderId,
            valueColor: AppModuleAccents.p2p,
            trailing: Icons.open_in_new_rounded,
          ),
          _InfoRow(label: 'Lý do', value: claim.reason),
          _InfoRow(
            label: 'Số tiền yêu cầu',
            value: '${_formatVnd(claim.amount)} đ',
          ),
          _InfoRow(
            label: 'Tỷ lệ bảo hiểm',
            value: '${claim.coveragePct}%',
            valueColor: AppModuleAccents.p2p,
          ),
          const SizedBox(height: AppSpacing.x3),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.x3),
          if (claim.paidAmount != null)
            _InfoRow(
              label: claim.statusLabel,
              value: '${_formatVnd(claim.paidAmount!)} đ',
              valueColor: AppColors.buy,
            ),
          _InfoRow(label: 'Ngày gửi', value: claim.submittedAt),
        ],
      ),
    );
  }
}

class _ClaimProgress extends StatelessWidget {
  const _ClaimProgress({required this.status});

  final P2PInsuranceClaimStatus status;

  @override
  Widget build(BuildContext context) {
    final steps = const ['Gửi', 'Xem xét', 'Duyệt', 'Chi trả'];
    final activeIndex = switch (status) {
      P2PInsuranceClaimStatus.pending => 0,
      P2PInsuranceClaimStatus.reviewing => 1,
      P2PInsuranceClaimStatus.approved => 2,
      P2PInsuranceClaimStatus.paid => 3,
      P2PInsuranceClaimStatus.rejected => 1,
    };

    return Column(
      children: [
        Row(
          children: [
            for (var i = 0; i < steps.length; i++) ...[
              Expanded(
                child: Container(
                  height: AppSpacing.x1,
                  decoration: BoxDecoration(
                    color: i <= activeIndex
                        ? _stepColor(i)
                        : AppColors.surface3,
                    borderRadius: AppRadii.xsRadius,
                  ),
                ),
              ),
              if (i != steps.length - 1) const SizedBox(width: AppSpacing.x3),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        Row(
          children: [
            for (var i = 0; i < steps.length; i++)
              Expanded(
                child: Text(
                  steps[i],
                  textAlign: TextAlign.center,
                  style: AppTextStyles.micro.copyWith(
                    color: i <= activeIndex ? _stepColor(i) : AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.trailing,
  });

  final String label;
  final String value;
  final Color valueColor;
  final IconData? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: valueColor,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: AppSpacing.x1),
                  Icon(trailing, color: valueColor, size: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClaimBenchmarksCard extends StatelessWidget {
  const _ClaimBenchmarksCard({required this.snapshot});

  final P2PClaimDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PClaimDetailPage.benchmarksKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                color: AppColors.accent,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'So sánh với nền tảng',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'So sánh claim của bạn với 847 claims đã xử lý',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final benchmark in snapshot.benchmarks) ...[
            _BenchmarkMetricCard(benchmark: benchmark),
            if (benchmark != snapshot.benchmarks.last)
              const SizedBox(height: AppSpacing.x4),
          ],
          const SizedBox(height: AppSpacing.x4),
          _ReasonDistribution(rows: snapshot.reasonShares),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: const [
              Expanded(
                child: _MiniStatCard(
                  label: 'Tỷ lệ duyệt chung',
                  value: '78.5%',
                ),
              ),
              SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniStatCard(label: 'Xử lý nhanh nhất', value: '4h'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BenchmarkMetricCard extends StatelessWidget {
  const _BenchmarkMetricCard({required this.benchmark});

  final P2PClaimBenchmarkDraft benchmark;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(benchmark.toneKey);
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                _benchmarkIcon(benchmark.id),
                color: AppColors.text3,
                size: 15,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  benchmark.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                benchmark.comparison,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            benchmark.value,
            style: AppTextStyles.baseMedium.copyWith(
              color: benchmark.toneKey == 'primary' ? AppColors.text1 : color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          _ProgressLine(progress: benchmark.progress, color: color),
          const SizedBox(height: AppSpacing.x2),
          Text(
            benchmark.caption,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ReasonDistribution extends StatelessWidget {
  const _ReasonDistribution({required this.rows});

  final List<P2PClaimReasonShareDraft> rows;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.groups_outlined,
                color: AppColors.text3,
                size: 15,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Phân bổ lý do claim',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final row in rows) ...[
            _ReasonShareRow(row: row),
            if (row != rows.last) const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _ReasonShareRow extends StatelessWidget {
  const _ReasonShareRow({required this.row});

  final P2PClaimReasonShareDraft row;

  @override
  Widget build(BuildContext context) {
    final color = row.highlight ? AppModuleAccents.p2p : AppColors.text3;
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            row.label,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: row.highlight
                  ? AppTextStyles.bold
                  : AppTextStyles.normal,
            ),
          ),
        ),
        Expanded(
          child: _ProgressLine(
            progress: row.percent / 100,
            color: row.highlight ? AppModuleAccents.p2p : AppColors.text3,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          '${row.percent}%',
          style: AppTextStyles.micro.copyWith(
            color: row.highlight ? AppModuleAccents.p2p : AppColors.text3,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final fill = progress.clamp(0.0, 1.0);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: AppSpacing.x1,
              decoration: BoxDecoration(
                color: AppColors.surface3,
                borderRadius: AppRadii.xsRadius,
              ),
            ),
            Container(
              width: constraints.maxWidth * fill,
              height: AppSpacing.x1,
              decoration: BoxDecoration(
                color: color,
                borderRadius: AppRadii.xsRadius,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
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
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  const _DescriptionCard({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PClaimDetailPage.descriptionKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MÔ TẢ',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            description,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              height: 1.55,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClaimSectionTabs extends StatelessWidget {
  const _ClaimSectionTabs({
    required this.active,
    required this.claim,
    required this.onChanged,
  });

  final _ClaimDetailSection active;
  final P2PClaimDetailDraft claim;
  final ValueChanged<_ClaimDetailSection> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      key: P2PClaimDetailPage.tabsKey,
      variant: VitTabBarVariant.segment,
      activeKey: active.name,
      onChanged: (value) => onChanged(_ClaimDetailSection.values.byName(value)),
      tabs: [
        VitTabItem(
          key: _ClaimDetailSection.timeline.name,
          label: 'Lịch sử  ${claim.timeline.length}',
        ),
        VitTabItem(
          key: _ClaimDetailSection.evidence.name,
          label: 'Bằng chứng  ${claim.evidence.length}',
        ),
        VitTabItem(
          key: _ClaimDetailSection.notes.name,
          label: 'Ghi chú  ${claim.reviewerNotes.length}',
        ),
      ],
    );
  }
}

class _ClaimSectionBody extends StatelessWidget {
  const _ClaimSectionBody({required this.section, required this.claim});

  final _ClaimDetailSection section;
  final P2PClaimDetailDraft claim;

  @override
  Widget build(BuildContext context) {
    return switch (section) {
      _ClaimDetailSection.timeline => _TimelineSection(events: claim.timeline),
      _ClaimDetailSection.evidence => _EvidenceSection(files: claim.evidence),
      _ClaimDetailSection.notes => _NotesSection(notes: claim.reviewerNotes),
    };
  }
}

class _TimelineSection extends StatelessWidget {
  const _TimelineSection({required this.events});

  final List<P2PClaimTimelineEventDraft> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PClaimDetailPage.timelineKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < events.length; i++)
          _TimelineEventRow(event: events[i], isLast: i == events.length - 1),
      ],
    );
  }
}

class _TimelineEventRow extends StatelessWidget {
  const _TimelineEventRow({required this.event, required this.isLast});

  final P2PClaimTimelineEventDraft event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = _timelineColor(event.statusKey);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: AppSpacing.x7,
          child: Column(
            children: [
              Container(
                width: AppSpacing.x7,
                height: AppSpacing.x7,
                decoration: BoxDecoration(
                  color: _statusBackground(color),
                  shape: BoxShape.circle,
                  border: Border.all(color: color),
                ),
                child: Icon(
                  _timelineIcon(event.statusKey),
                  color: color,
                  size: 15,
                ),
              ),
              if (!isLast)
                Container(
                  width: 1,
                  height: AppSpacing.x6,
                  color: AppColors.divider,
                ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: isLast ? 0 : AppSpacing.x4,
              top: AppSpacing.x1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  event.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  event.actor == null
                      ? event.timestamp
                      : '${event.timestamp} · ${event.actor}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EvidenceSection extends StatelessWidget {
  const _EvidenceSection({required this.files});

  final List<P2PClaimEvidenceDraft> files;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PClaimDetailPage.evidenceKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _UploadEvidenceCard(count: files.length),
        const SizedBox(height: AppSpacing.x3),
        for (final file in files) ...[
          _EvidenceFileCard(file: file),
          if (file != files.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _UploadEvidenceCard extends StatelessWidget {
  const _UploadEvidenceCard({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      borderColor: AppColors.borderSolid,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Container(
            width: AppSpacing.x7,
            height: AppSpacing.x7,
            decoration: BoxDecoration(
              color: AppColors.primary12,
              borderRadius: AppRadii.lgRadius,
            ),
            child: const Icon(
              Icons.upload_file_rounded,
              color: AppModuleAccents.p2p,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Tải lên bằng chứng',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Đã có $count tệp. Hỗ trợ PNG, JPG, PDF, DOC',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _EvidenceFileCard extends StatelessWidget {
  const _EvidenceFileCard({required this.file});

  final P2PClaimEvidenceDraft file;

  @override
  Widget build(BuildContext context) {
    final isImage = file.type == 'image' || file.type == 'screenshot';
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          Container(
            width: AppSpacing.x7,
            height: AppSpacing.x7,
            decoration: BoxDecoration(
              color: isImage ? AppColors.accent12 : AppColors.primary12,
              borderRadius: AppRadii.mdRadius,
            ),
            child: Icon(
              isImage ? Icons.image_outlined : Icons.description_outlined,
              color: isImage ? AppColors.accent : AppModuleAccents.p2p,
              size: AppSpacing.iconSm,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${file.size} · ${file.uploadedAt}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          const Icon(
            Icons.visibility_outlined,
            color: AppColors.text2,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _NotesSection extends StatelessWidget {
  const _NotesSection({required this.notes});

  final List<P2PClaimReviewerNoteDraft> notes;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PClaimDetailPage.notesKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final note in notes) ...[
          _ReviewerNoteCard(note: note),
          if (note != notes.last) const SizedBox(height: AppSpacing.x3),
        ],
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          variant: VitCardVariant.inner,
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            children: [
              const Icon(
                Icons.send_rounded,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Gửi tin nhắn cho reviewer...',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewerNoteCard extends StatelessWidget {
  const _ReviewerNoteCard({required this.note});

  final P2PClaimReviewerNoteDraft note;

  @override
  Widget build(BuildContext context) {
    final isSystem = note.role == 'Tự động';
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: AppSpacing.x5,
            backgroundColor: isSystem ? AppColors.buy10 : AppColors.primary12,
            child: Icon(
              isSystem ? Icons.settings_outlined : Icons.person_outline_rounded,
              color: isSystem ? AppColors.buy : AppModuleAccents.p2p,
              size: AppSpacing.iconSm,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        note.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    VitStatusPill(
                      label: note.role,
                      status: isSystem
                          ? VitStatusPillStatus.success
                          : VitStatusPillStatus.info,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  note.content,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  note.timestamp,
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

class _NotificationsCard extends StatelessWidget {
  const _NotificationsCard({required this.enabled, required this.onChanged});

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PClaimDetailPage.notificationsKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.x7,
            height: AppSpacing.x7,
            decoration: BoxDecoration(
              color: AppColors.primary12,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AppModuleAccents.p2p,
              size: AppSpacing.iconSm,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thông báo cập nhật',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  enabled
                      ? 'Đang bật, nhận push khi có thay đổi'
                      : 'Đang tắt thông báo claim này',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x3),
                const _CheckBullet(text: 'Thay đổi trạng thái claim'),
                const _CheckBullet(text: 'Ghi chú mới từ reviewer'),
                const _CheckBullet(text: 'Yêu cầu bổ sung bằng chứng'),
                const _CheckBullet(text: 'Chi trả hoàn tất'),
              ],
            ),
          ),
          Switch(
            value: enabled,
            activeThumbColor: AppColors.text1,
            activeTrackColor: AppModuleAccents.p2p,
            inactiveThumbColor: AppColors.text3,
            inactiveTrackColor: AppColors.surface3,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _CheckBullet extends StatelessWidget {
  const _CheckBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x1),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.buy,
            size: 13,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: EdgeInsets.zero,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.cardRadius,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Row(
              children: [
                Icon(icon, color: AppColors.text2, size: AppSpacing.iconSm),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.baseMedium.copyWith(
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
        ),
      ),
    );
  }
}

class _FeedbackBanner extends StatelessWidget {
  const _FeedbackBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PClaimDetailPage.feedbackKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.buy,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

VitStatusPillStatus _statusPill(P2PInsuranceClaimStatus status) {
  return switch (status) {
    P2PInsuranceClaimStatus.pending => VitStatusPillStatus.warning,
    P2PInsuranceClaimStatus.reviewing => VitStatusPillStatus.info,
    P2PInsuranceClaimStatus.approved => VitStatusPillStatus.success,
    P2PInsuranceClaimStatus.rejected => VitStatusPillStatus.error,
    P2PInsuranceClaimStatus.paid => VitStatusPillStatus.success,
  };
}

IconData _statusIcon(P2PInsuranceClaimStatus status) {
  return switch (status) {
    P2PInsuranceClaimStatus.pending => Icons.schedule_rounded,
    P2PInsuranceClaimStatus.reviewing => Icons.manage_search_rounded,
    P2PInsuranceClaimStatus.approved => Icons.check_circle_outline_rounded,
    P2PInsuranceClaimStatus.rejected => Icons.cancel_outlined,
    P2PInsuranceClaimStatus.paid => Icons.attach_money_rounded,
  };
}

Color _stepColor(int index) {
  return switch (index) {
    0 => AppColors.text3,
    1 => AppModuleAccents.p2p,
    2 => AppColors.buy,
    _ => AppColors.buy,
  };
}

Color _timelineColor(String statusKey) {
  return switch (statusKey) {
    'submitted' => AppColors.text3,
    'evidence_added' => AppColors.accent,
    'reviewing' => AppModuleAccents.p2p,
    'note_added' => AppColors.accent,
    'approved' => AppColors.buy,
    'rejected' => AppColors.sell,
    'paid' => AppColors.buy,
    _ => AppColors.text3,
  };
}

IconData _timelineIcon(String statusKey) {
  return switch (statusKey) {
    'submitted' => Icons.send_outlined,
    'evidence_added' => Icons.upload_file_rounded,
    'reviewing' => Icons.search_rounded,
    'note_added' => Icons.message_outlined,
    'approved' => Icons.check_circle_outline_rounded,
    'rejected' => Icons.cancel_outlined,
    'paid' => Icons.attach_money_rounded,
    _ => Icons.schedule_rounded,
  };
}

IconData _benchmarkIcon(String id) {
  return switch (id) {
    'amount' => Icons.attach_money_rounded,
    'resolution' => Icons.schedule_rounded,
    'coverage' => Icons.verified_user_outlined,
    _ => Icons.bar_chart_rounded,
  };
}

Color _toneColor(String toneKey) {
  return switch (toneKey) {
    'buy' => AppColors.buy,
    'warn' => AppColors.warn,
    'accent' => AppColors.accent,
    _ => AppModuleAccents.p2p,
  };
}

Color _statusBackground(Color color) {
  if (color == AppColors.buy) return AppColors.buy10;
  if (color == AppColors.sell) return AppColors.sell10;
  if (color == AppColors.accent) return AppColors.accent10;
  if (color == AppModuleAccents.p2p) return AppColors.primary12;
  return AppColors.surface2;
}

String _formatVnd(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final remaining = digits.length - i;
    buffer.write(digits[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write('.');
    }
  }
  return buffer.toString();
}
