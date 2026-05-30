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

const _complaintsBackground = AppColors.bg;
const _complaintsPanel = AppColors.surface;
const _complaintsPanel2 = AppColors.surface2;
const _complaintsBorder = AppColors.borderSolid;
const _complaintsPrimary = AppColors.primary;
const _complaintsGreen = AppColors.buy;
const _complaintsAmber = AppColors.caution;
const _complaintsRed = AppColors.sell;

enum _ComplaintsTab { overview, myComplaints, process }

class ComplaintsHandlingPage extends ConsumerStatefulWidget {
  const ComplaintsHandlingPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc111_complaints_content');
  static const submitKey = Key('sc111_submit_complaint');
  static Key tabKey(String tab) => Key('sc111_tab_$tab');
  static Key complaintKey(String id) => Key('sc111_complaint_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ComplaintsHandlingPage> createState() =>
      _ComplaintsHandlingPageState();
}

class _ComplaintsHandlingPageState
    extends ConsumerState<ComplaintsHandlingPage> {
  _ComplaintsTab _tab = _ComplaintsTab.overview;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getComplaintsHandling();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 70
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-111 ComplaintsHandlingPage',
      child: Material(
        color: _complaintsBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Complaints Handling',
              subtitle: 'FCA Regulated Process',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: ComplaintsHandlingPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 27, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _RightsNotice(),
                    const SizedBox(height: 36),
                    _StatsRow(snapshot: snapshot),
                    const SizedBox(height: 25),
                    const _SubmitComplaintButton(),
                    const SizedBox(height: 25),
                    _Tabs(
                      active: _tab,
                      onChanged: (tab) => setState(() => _tab = tab),
                    ),
                    const SizedBox(height: 26),
                    if (_tab == _ComplaintsTab.overview)
                      _OverviewContent(snapshot: snapshot),
                    if (_tab == _ComplaintsTab.myComplaints)
                      _MyComplaintsContent(complaints: snapshot.complaints),
                    if (_tab == _ComplaintsTab.process)
                      _ProcessContent(snapshot: snapshot),
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

class _RightsNotice extends StatelessWidget {
  const _RightsNotice();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.text1, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Rights',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You have the right to complain. We will investigate fairly '
                  'and respond within 8 weeks. If dissatisfied, you can refer '
                  'to the Financial Ombudsman Service.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                    height: 1.35,
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

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.snapshot});

  final TradeComplaintsHandlingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(label: 'Active', value: '${snapshot.activeCount}'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Resolved',
            value: '${snapshot.resolvedCount}',
            valueColor: _complaintsGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Avg. Days',
            value: '${snapshot.averageResolutionDays}',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      child: SizedBox(
        height: 46,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 10,
                height: 1,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: AppTextStyles.heroNumber.copyWith(
                color: valueColor,
                fontSize: 20,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmitComplaintButton extends StatelessWidget {
  const _SubmitComplaintButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _complaintsPrimary,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        key: ComplaintsHandlingPage.submitKey,
        borderRadius: AppRadii.inputRadius,
        onTap: () => context.go(AppRoutePaths.tradeCopyComplaintSubmission),
        child: SizedBox(
          height: 78,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 15, 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: AppSpacing.inputHeight,
                  decoration: BoxDecoration(
                    color: AppColors.onAccent.withValues(alpha: .20),
                    borderRadius: AppRadii.cardRadius,
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: AppColors.onAccent,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Submit a Complaint',
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.onAccent,
                          fontSize: 14,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "We'll respond within 8 weeks",
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.onAccent,
                          fontSize: 11,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.onAccent,
                  size: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.active, required this.onChanged});

  final _ComplaintsTab active;
  final ValueChanged<_ComplaintsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      color: _complaintsPanel,
      child: Row(
        children: [
          _TabButton(
            tab: _ComplaintsTab.overview,
            label: 'Overview',
            active: active,
            onChanged: onChanged,
          ),
          _TabButton(
            tab: _ComplaintsTab.myComplaints,
            label: 'My Complaints',
            active: active,
            onChanged: onChanged,
          ),
          _TabButton(
            tab: _ComplaintsTab.process,
            label: 'Process',
            active: active,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.tab,
    required this.label,
    required this.active,
    required this.onChanged,
  });

  final _ComplaintsTab tab;
  final String label;
  final _ComplaintsTab active;
  final ValueChanged<_ComplaintsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final isActive = active == tab;
    return Expanded(
      child: InkWell(
        key: ComplaintsHandlingPage.tabKey(tab.name),
        onTap: () => onChanged(tab),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: isActive ? _complaintsPrimary : AppColors.text3,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ),
            Container(
              width: 100,
              height: 2,
              color: isActive ? _complaintsPrimary : AppColors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewContent extends StatelessWidget {
  const _OverviewContent({required this.snapshot});

  final TradeComplaintsHandlingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Complaint Categories'),
        const SizedBox(height: 13),
        _CategoryGrid(categories: snapshot.categories),
        const SizedBox(height: 26),
        const _SectionLabel('Resolution Timeline'),
        const SizedBox(height: 10),
        _TimelineCard(timeline: snapshot.timeline),
      ],
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.categories});

  final List<TradeComplaintCategory> categories;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final category in categories)
          SizedBox(
            width: 194,
            height: 82,
            child: _Card(
              padding: const EdgeInsets.fromLTRB(13, 18, 13, 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _iconForCategory(category.icon),
                    color: _complaintsPrimary,
                    size: 17,
                  ),
                  const Spacer(),
                  Text(
                    category.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 11,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.timeline});

  final List<TradeComplaintTimelineStep> timeline;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 17),
      child: Column(
        children: [
          for (final item in timeline) ...[
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _complaintsPanel2,
                    borderRadius: AppRadii.cardRadius,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${item.step}',
                    style: AppTextStyles.caption.copyWith(
                      color: _complaintsPrimary,
                      fontSize: 13,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 12,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.time,
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
            if (item != timeline.last) const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _MyComplaintsContent extends StatelessWidget {
  const _MyComplaintsContent({required this.complaints});

  final List<TradeComplaint> complaints;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Your Complaints'),
        const SizedBox(height: 13),
        for (final complaint in complaints) ...[
          _ComplaintCard(complaint: complaint),
          if (complaint != complaints.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ComplaintCard extends StatelessWidget {
  const _ComplaintCard({required this.complaint});

  final TradeComplaint complaint;

  @override
  Widget build(BuildContext context) {
    final status = _statusPresentation(complaint.status);
    return InkWell(
      key: ComplaintsHandlingPage.complaintKey(complaint.id),
      borderRadius: AppRadii.cardRadius,
      onTap: () =>
          context.go(AppRoutePaths.tradeCopyComplaintTracking(complaint.id)),
      child: _Card(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: status.color.withValues(alpha: .11),
                borderRadius: AppRadii.inputRadius,
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                color: status.color,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        complaint.id,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 13,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                      Text(
                        status.label,
                        style: AppTextStyles.micro.copyWith(
                          color: status.color,
                          fontSize: 9,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    complaint.subject,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontSize: 11,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${complaint.category} - Submitted ${complaint.submittedDate}',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 9,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProcessContent extends StatelessWidget {
  const _ProcessContent({required this.snapshot});

  final TradeComplaintsHandlingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('How We Handle Complaints'),
        const SizedBox(height: 13),
        _Card(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              for (final step in snapshot.processSteps) ...[
                _ProcessStep(step: step),
                if (step != snapshot.processSteps.last)
                  const SizedBox(height: 13),
              ],
            ],
          ),
        ),
        const SizedBox(height: 25),
        const _SectionLabel('Financial Ombudsman Service'),
        const SizedBox(height: 13),
        _OmbudsmanCard(ombudsman: snapshot.ombudsman),
      ],
    );
  }
}

class _ProcessStep extends StatelessWidget {
  const _ProcessStep({required this.step});

  final TradeComplaintProcessStep step;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_outline_rounded,
          color: _complaintsGreen,
          size: 16,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                step.description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OmbudsmanCard extends StatelessWidget {
  const _OmbudsmanCard({required this.ombudsman});

  final TradeOmbudsmanInfo ombudsman;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            ombudsman.description,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 11,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _complaintsPanel2,
              borderRadius: AppRadii.mdRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact:',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 9,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Phone: ${ombudsman.phone}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Web: ${ombudsman.website}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () =>
                context.go(AppRoutePaths.tradeCopyOmbudsmanReferral),
            icon: const Icon(Icons.info_outline_rounded, size: 14),
            label: const Text('Learn About Ombudsman Referral'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
              foregroundColor: AppColors.text1,
              side: BorderSide(color: _complaintsBorder.withValues(alpha: .76)),
              shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
              textStyle: AppTextStyles.caption.copyWith(
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
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
            color: _complaintsPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
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

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _complaintsPanel,
        border: Border.all(color: _complaintsBorder.withValues(alpha: .76)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

IconData _iconForCategory(TradeComplaintCategoryIcon icon) {
  return switch (icon) {
    TradeComplaintCategoryIcon.trade => Icons.trending_up_rounded,
    TradeComplaintCategoryIcon.account => Icons.group_outlined,
    TradeComplaintCategoryIcon.payment => Icons.description_outlined,
    TradeComplaintCategoryIcon.service => Icons.chat_bubble_outline_rounded,
    TradeComplaintCategoryIcon.fees => Icons.bar_chart_rounded,
    TradeComplaintCategoryIcon.other => Icons.error_outline_rounded,
  };
}

({String label, Color color}) _statusPresentation(TradeComplaintStatus status) {
  return switch (status) {
    TradeComplaintStatus.submitted => (
      label: 'Submitted',
      color: _complaintsPrimary,
    ),
    TradeComplaintStatus.underReview => (
      label: 'Under Review',
      color: _complaintsAmber,
    ),
    TradeComplaintStatus.resolved => (
      label: 'Resolved',
      color: _complaintsGreen,
    ),
    TradeComplaintStatus.escalated => (
      label: 'Escalated',
      color: _complaintsRed,
    ),
  };
}
