import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/arena_state_cards.dart';

class ArenaReportCasePage extends ConsumerStatefulWidget {
  const ArenaReportCasePage({
    super.key,
    required this.caseId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc202_report_content');
  static const emptyKey = Key('sc202_report_empty');
  static const relatedChallengeKey = Key('sc202_related_challenge');
  static const myReportsKey = Key('sc202_my_reports');
  static const primaryCtaKey = Key('sc202_primary_cta');

  static Key relatedReportKey(String id) => Key('sc202_related_report_$id');

  final String caseId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaReportCasePage> createState() =>
      _ArenaReportCasePageState();
}

class _ArenaReportCasePageState extends ConsumerState<ArenaReportCasePage> {
  bool _appealSubmitted = false;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(
      arenaReportCaseControllerProvider(widget.caseId),
    );
    final snapshot = controller.state.snapshot;
    final reviewState = controller.reviewState(
      appealSubmitted: _appealSubmitted,
    );
    final relatedReports = controller.relatedReportsExcludingCurrent();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-202 ArenaReportCasePage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Chi tiết báo cáo',
              subtitle: 'An toàn · Open Arena',
              showBack: true,
              onBack: () => _close(context),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: ArenaReportCasePage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: snapshot.reportCase == null
                      ? VitPageContent(
                          key: ArenaReportCasePage.emptyKey,
                          padding: VitContentPadding.none,
                          children: [
                            VitEmptyState(
                              icon: Icons.warning_amber_rounded,
                              title: snapshot.emptyTitle,
                              message: snapshot.emptySubtitle,
                            ),
                          ],
                        )
                      : VitPageContent(
                          padding: VitContentPadding.compact,
                          customGap: AppSpacing.x5,
                          children: [
                            ArenaReportReviewStateCard(state: reviewState),
                            _CaseSummaryCard(reportCase: snapshot.reportCase!),
                            _ReportReasonCard(reportCase: snapshot.reportCase!),
                            _TimelineCard(reportCase: snapshot.reportCase!),
                            if (snapshot.reportCase!.actionTaken != null)
                              _ActionTakenCard(
                                reportCase: snapshot.reportCase!,
                              ),
                            if (snapshot.reportCase!.actionTaken == null &&
                                snapshot.reportCase!.systemNote != null)
                              _SystemNoteCard(
                                note: snapshot.reportCase!.systemNote!,
                              ),
                            if (snapshot.reportCase!.relatedChallengeId != null)
                              _LinkedActionRow(
                                key: ArenaReportCasePage.relatedChallengeKey,
                                icon: Icons.emoji_events_outlined,
                                title: 'Xem challenge liên quan',
                                accentColor: AppColors.accent,
                                onTap: () => _openChallenge(
                                  context,
                                  snapshot.reportCase!,
                                ),
                              ),
                            if (snapshot.reportCase!.status ==
                                ArenaReportCaseStatus.actionTaken)
                              _AppealNotice(
                                state: reviewState,
                                onAppeal: _markAppealSubmitted,
                              ),
                            _LinkedActionRow(
                              key: ArenaReportCasePage.myReportsKey,
                              icon: Icons.flag_outlined,
                              title: 'Xem tất cả báo cáo',
                              accentColor: AppColors.text3,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                context.go(AppRoutePaths.arenaMyReports);
                              },
                            ),
                            _RelatedReports(reports: relatedReports),
                            _DisclaimerCard(disclaimer: snapshot.disclaimer),
                            VitCtaButton(
                              key: ArenaReportCasePage.primaryCtaKey,
                              onPressed: () => _handlePrimaryCta(
                                context,
                                snapshot.reportCase!,
                              ),
                              child: Text(
                                _primaryCtaLabel(snapshot.reportCase!),
                              ),
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

  void _markAppealSubmitted() {
    HapticFeedback.mediumImpact();
    setState(() => _appealSubmitted = true);
  }

  static void _openChallenge(
    BuildContext context,
    ArenaReportCaseDraft reportCase,
  ) {
    final challengeId = reportCase.relatedChallengeId;
    if (challengeId == null) return;
    HapticFeedback.selectionClick();
    context.go(AppRoutePaths.arenaChallenge(challengeId));
  }

  void _handlePrimaryCta(
    BuildContext context,
    ArenaReportCaseDraft reportCase,
  ) {
    HapticFeedback.mediumImpact();
    if (reportCase.status == ArenaReportCaseStatus.actionTaken &&
        reportCase.relatedChallengeId != null) {
      _openChallenge(context, reportCase);
      return;
    }
    if (reportCase.status == ArenaReportCaseStatus.appealOpen) {
      setState(() => _appealSubmitted = true);
      return;
    }
    _close(context);
  }

  static void _close(BuildContext context) {
    HapticFeedback.selectionClick();
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }
}

class _CaseSummaryCard extends StatelessWidget {
  const _CaseSummaryCard({required this.reportCase});

  final ArenaReportCaseDraft reportCase;

  @override
  Widget build(BuildContext context) {
    final accentColor = _targetColor(reportCase.targetType);
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '#${reportCase.id.toUpperCase()}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              _ReportStatusPill(status: reportCase.status),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _ToneIcon(
                icon: _targetIcon(reportCase.targetType),
                color: accentColor,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reportCase.targetName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${_targetLabel(reportCase.targetType)} · Báo cáo lúc ${reportCase.createdAt}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
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

class _ReportReasonCard extends StatelessWidget {
  const _ReportReasonCard({required this.reportCase});

  final ArenaReportCaseDraft reportCase;

  @override
  Widget build(BuildContext context) {
    return _SectionBlock(
      title: 'Lý do báo cáo',
      accentColor: AppColors.sell,
      child: VitCard(
        padding: const EdgeInsets.all(AppSpacing.x4),
        borderColor: AppColors.sell20,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.flag_outlined, color: AppColors.sell, size: 18),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                reportCase.reason,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.reportCase});

  final ArenaReportCaseDraft reportCase;

  @override
  Widget build(BuildContext context) {
    return _SectionBlock(
      title: 'Tiến trình xử lý',
      accentColor: AppColors.buy,
      child: VitCard(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          children: [
            for (var index = 0; index < reportCase.timeline.length; index++)
              _TimelineRow(
                step: reportCase.timeline[index],
                isLast: index == reportCase.timeline.length - 1,
              ),
          ],
        ),
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.step, required this.isLast});

  final ArenaReportTimelineStepDraft step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final dotColor = step.done ? AppColors.buy : AppColors.surface2;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          child: Column(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: AppSpacing.x1),
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                  border: step.done
                      ? null
                      : Border.all(color: AppColors.borderSolid, width: 2),
                ),
              ),
              if (!isLast)
                Container(
                  width: 1,
                  height: 28,
                  color: step.done ? AppColors.buy20 : AppColors.divider,
                ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.x3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.label,
                  style: AppTextStyles.body.copyWith(
                    color: step.done ? AppColors.text1 : AppColors.text3,
                    fontWeight: step.done
                        ? AppTextStyles.medium
                        : AppTextStyles.normal,
                    height: 1.35,
                  ),
                ),
                if (step.date.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    step.date,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionTakenCard extends StatelessWidget {
  const _ActionTakenCard({required this.reportCase});

  final ArenaReportCaseDraft reportCase;

  @override
  Widget build(BuildContext context) {
    return _SectionBlock(
      title: 'Hành động đã thực hiện',
      accentColor: AppColors.warn,
      child: VitCard(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ToneIcon(icon: Icons.shield_outlined, color: AppColors.buy),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hành động đã thực hiện',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        reportCase.actionTaken!,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (reportCase.systemNote != null) ...[
              const SizedBox(height: AppSpacing.x3),
              _SystemNotePanel(note: reportCase.systemNote!),
            ],
          ],
        ),
      ),
    );
  }
}

class _SystemNoteCard extends StatelessWidget {
  const _SystemNoteCard({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return _SectionBlock(
      title: 'Ghi chú hệ thống',
      accentColor: AppColors.text3,
      child: VitCard(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: _SystemNotePanel(note: note),
      ),
    );
  }
}

class _SystemNotePanel extends StatelessWidget {
  const _SystemNotePanel({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline, color: AppColors.text3, size: 14),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                note,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppealNotice extends StatelessWidget {
  const _AppealNotice({required this.state, required this.onAppeal});

  final ArenaReportReviewState state;
  final VoidCallback onAppeal;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      borderColor: AppColors.warningBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ToneIcon(icon: Icons.balance_outlined, color: AppColors.warn),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      !state.canAppeal
                          ? 'Khiếu nại đã ghi nhận'
                          : 'Bạn có thể khiếu nại',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Nếu cho rằng kết luận chưa chính xác, bạn có thể mở khiếu nại trong 7 ngày kể từ ngày kết luận.',
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
          const SizedBox(height: AppSpacing.x3),
          if (!state.canAppeal)
            const VitStatusPill(
              label: 'Đã gửi yêu cầu xem xét',
              status: VitStatusPillStatus.warning,
              size: VitStatusPillSize.md,
            )
          else
            VitCtaButton(
              onPressed: onAppeal,
              variant: VitCtaButtonVariant.ghost,
              fullWidth: false,
              height: 36,
              child: const Text('Mở khiếu nại'),
            ),
        ],
      ),
    );
  }
}

class _LinkedActionRow extends StatelessWidget {
  const _LinkedActionRow({
    super.key,
    required this.icon,
    required this.title,
    required this.accentColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Icon(icon, color: accentColor, size: 18),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.body.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.text3, size: 18),
        ],
      ),
    );
  }
}

class _RelatedReports extends StatelessWidget {
  const _RelatedReports({required this.reports});

  final List<ArenaReportCaseDraft> reports;

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        for (final report in reports)
          Padding(
            padding: EdgeInsets.only(
              bottom: report == reports.last ? 0 : AppSpacing.x2,
            ),
            child: VitCard(
              key: ArenaReportCasePage.relatedReportKey(report.id),
              onTap: () {
                HapticFeedback.selectionClick();
                context.go(AppRoutePaths.arenaReportCase(report.id));
              },
              padding: const EdgeInsets.all(AppSpacing.x3),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${report.targetName} - ${report.reason}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.medium,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          report.createdAt,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  _ReportStatusPill(
                    status: report.status,
                    size: VitStatusPillSize.sm,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard({required this.disclaimer});

  final String disclaimer;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.accent, size: 16),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              disclaimer,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({
    required this.title,
    required this.accentColor,
    required this.child,
  });

  final String title;
  final Color accentColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: AppRadii.xsRadius,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        child,
      ],
    );
  }
}

class _ToneIcon extends StatelessWidget {
  const _ToneIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.22)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class _ReportStatusPill extends StatelessWidget {
  const _ReportStatusPill({
    required this.status,
    this.size = VitStatusPillSize.md,
  });

  final ArenaReportCaseStatus status;
  final VitStatusPillSize size;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: _statusLabel(status),
      status: _statusKind(status),
      icon: _statusIcon(status),
      size: size,
    );
  }
}

String _primaryCtaLabel(ArenaReportCaseDraft reportCase) {
  return switch (reportCase.status) {
    ArenaReportCaseStatus.submitted ||
    ArenaReportCaseStatus.underReview ||
    ArenaReportCaseStatus.closed => 'Đóng',
    ArenaReportCaseStatus.actionTaken =>
      reportCase.relatedChallengeId == null ? 'Đóng' : 'Xem challenge',
    ArenaReportCaseStatus.appealOpen => 'Mở khiếu nại',
  };
}

String _statusLabel(ArenaReportCaseStatus status) {
  return switch (status) {
    ArenaReportCaseStatus.submitted => 'Đã gửi',
    ArenaReportCaseStatus.underReview => 'Đang xem xét',
    ArenaReportCaseStatus.actionTaken => 'Đã xử lý',
    ArenaReportCaseStatus.closed => 'Đã đóng',
    ArenaReportCaseStatus.appealOpen => 'Đang khiếu nại',
  };
}

VitStatusPillStatus _statusKind(ArenaReportCaseStatus status) {
  return switch (status) {
    ArenaReportCaseStatus.submitted => VitStatusPillStatus.info,
    ArenaReportCaseStatus.underReview => VitStatusPillStatus.warning,
    ArenaReportCaseStatus.actionTaken => VitStatusPillStatus.success,
    ArenaReportCaseStatus.closed => VitStatusPillStatus.neutral,
    ArenaReportCaseStatus.appealOpen => VitStatusPillStatus.error,
  };
}

IconData _statusIcon(ArenaReportCaseStatus status) {
  return switch (status) {
    ArenaReportCaseStatus.submitted => Icons.description_outlined,
    ArenaReportCaseStatus.underReview => Icons.schedule_outlined,
    ArenaReportCaseStatus.actionTaken => Icons.check_circle_outline,
    ArenaReportCaseStatus.closed => Icons.lock_outline,
    ArenaReportCaseStatus.appealOpen => Icons.warning_amber_rounded,
  };
}

IconData _targetIcon(ArenaReportTargetType targetType) {
  return switch (targetType) {
    ArenaReportTargetType.challenge => Icons.emoji_events_outlined,
    ArenaReportTargetType.mode => Icons.description_outlined,
    ArenaReportTargetType.user => Icons.person_outline,
  };
}

Color _targetColor(ArenaReportTargetType targetType) {
  return switch (targetType) {
    ArenaReportTargetType.challenge => AppColors.warn,
    ArenaReportTargetType.mode => AppColors.accent,
    ArenaReportTargetType.user => AppColors.sell,
  };
}

String _targetLabel(ArenaReportTargetType targetType) {
  return switch (targetType) {
    ArenaReportTargetType.challenge => 'Challenge',
    ArenaReportTargetType.mode => 'Mode',
    ArenaReportTargetType.user => 'Người dùng',
  };
}
