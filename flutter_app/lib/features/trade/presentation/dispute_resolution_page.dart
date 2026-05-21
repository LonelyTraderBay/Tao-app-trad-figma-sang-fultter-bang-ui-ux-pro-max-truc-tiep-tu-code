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
import '../data/trade_repository.dart';

const _disputeBlue = Color(0xFF3B82F6);
const _disputeField = Color(0xFF1D2332);
const _disputeFieldBorder = Color(0xFF30394D);
const _disputeFooter = Color(0xFF121720);
const _disputeDangerBg = Color(0x221F2937);

class DisputeResolutionPage extends ConsumerStatefulWidget {
  const DisputeResolutionPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc082_dispute_resolution_content');
  static const submitKey = Key('sc082_submit_complaint');
  static const providerKey = Key('sc082_provider_dropdown');
  static const subjectKey = Key('sc082_subject');
  static const descriptionKey = Key('sc082_description');
  static const uploadKey = Key('sc082_upload_evidence');

  static Key complaintTypeKey(String id) => Key('sc082_complaint_type_$id');
  static Key tabKey(String id) => Key('sc082_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DisputeResolutionPage> createState() =>
      _DisputeResolutionPageState();
}

class _DisputeResolutionPageState extends ConsumerState<DisputeResolutionPage> {
  late final TextEditingController _subjectController;
  late final TextEditingController _descriptionController;
  String _activeTabId = 'file';
  String? _selectedType;
  String? _selectedProviderId;
  bool _evidenceAttached = false;
  TradeDisputeSubmissionResult? _lastResult;

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController()
      ..addListener(() => setState(() {}));
    _descriptionController = TextEditingController()
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    return _selectedType != null &&
        _selectedProviderId != null &&
        _subjectController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeRepositoryProvider).getDisputeResolution();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final activeBottomInset = mode.usesVisualQaFrame
        ? DeviceMetrics.nativeBottomChrome + 18
        : DeviceMetrics.nativeBottomChrome +
              MediaQuery.paddingOf(context).bottom +
              18;
    final footerBottomOffset = mode.usesVisualQaFrame
        ? DeviceMetrics.height > 956
              ? DeviceMetrics.height - 956
              : DeviceMetrics.nativeBottomChrome + 17
        : activeBottomInset;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-082 DisputeResolutionPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: 'Dispute Resolution',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
                ),
                if (_activeTabId != 'file')
                  _DisputeTabs(
                    tabs: snapshot.tabs,
                    activeId: _activeTabId,
                    onChanged: (id) => setState(() => _activeTabId = id),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    key: DisputeResolutionPage.contentKey,
                    padding: EdgeInsets.fromLTRB(
                      20,
                      _activeTabId == 'file' ? 13 : 18,
                      20,
                      _activeTabId == 'file' ? 24 : activeBottomInset + 20,
                    ),
                    child: _activeTabId == 'file'
                        ? _FileComplaintTab(
                            snapshot: snapshot,
                            selectedType: _selectedType,
                            selectedProviderId: _selectedProviderId,
                            subjectController: _subjectController,
                            descriptionController: _descriptionController,
                            evidenceAttached: _evidenceAttached,
                            onTypeChanged: (value) =>
                                setState(() => _selectedType = value),
                            onProviderChanged: (value) =>
                                setState(() => _selectedProviderId = value),
                            onUpload: () =>
                                setState(() => _evidenceAttached = true),
                          )
                        : _CasesTab(
                            activeTabId: _activeTabId,
                            snapshot: snapshot,
                            lastResult: _lastResult,
                          ),
                  ),
                ),
              ],
            ),
            if (_activeTabId == 'file')
              Positioned(
                left: 0,
                right: 0,
                bottom: footerBottomOffset,
                child: VitStickyFooter(
                  backgroundColor: _disputeFooter,
                  child: _SubmitButton(
                    enabled: _canSubmit,
                    onPressed: _handleSubmit,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (!_canSubmit) return;

    final result = ref
        .read(tradeRepositoryProvider)
        .submitDisputeComplaint(
          TradeDisputeComplaintDraft(
            complaintType: _selectedType!,
            providerId: _selectedProviderId!,
            subject: _subjectController.text.trim(),
            description: _descriptionController.text.trim(),
            evidenceNames: _evidenceAttached
                ? const ['slippage-proof.png']
                : const [],
          ),
        );

    setState(() {
      _lastResult = result;
      _selectedType = null;
      _selectedProviderId = null;
      _subjectController.clear();
      _descriptionController.clear();
      _evidenceAttached = false;
      _activeTabId = 'active';
    });
  }
}

class _FileComplaintTab extends StatelessWidget {
  const _FileComplaintTab({
    required this.snapshot,
    required this.selectedType,
    required this.selectedProviderId,
    required this.subjectController,
    required this.descriptionController,
    required this.evidenceAttached,
    required this.onTypeChanged,
    required this.onProviderChanged,
    required this.onUpload,
  });

  final TradeDisputeResolutionSnapshot snapshot;
  final String? selectedType;
  final String? selectedProviderId;
  final TextEditingController subjectController;
  final TextEditingController descriptionController;
  final bool evidenceAttached;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String?> onProviderChanged;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    final uploadTopGap = DeviceMetrics.height > 956 ? 82.0 : 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _NoticeCard(title: snapshot.noticeTitle, body: snapshot.noticeBody),
        const SizedBox(height: 26),
        const _SectionLabel('Complaint Type'),
        const SizedBox(height: 9),
        for (final type in snapshot.complaintTypes) ...[
          _ComplaintTypeCard(
            option: type,
            selected: selectedType == type.value,
            onPressed: () => onTypeChanged(type.value),
          ),
          if (type != snapshot.complaintTypes.last) const SizedBox(height: 10),
        ],
        const SizedBox(height: 25),
        const _SectionLabel('Provider'),
        const SizedBox(height: 10),
        _ProviderSelect(
          providers: snapshot.providers,
          selectedProviderId: selectedProviderId,
          onChanged: onProviderChanged,
        ),
        const SizedBox(height: 25),
        const _SectionLabel('Details'),
        const SizedBox(height: 9),
        _FieldLabel('Subject'),
        const SizedBox(height: 7),
        _TextFieldShell(
          key: DisputeResolutionPage.subjectKey,
          controller: subjectController,
          hint: 'Brief summary of the issue',
        ),
        const SizedBox(height: 15),
        _FieldLabel('Description'),
        const SizedBox(height: 7),
        _TextFieldShell(
          key: DisputeResolutionPage.descriptionKey,
          controller: descriptionController,
          hint:
              'Describe the issue in detail. Include dates, trade IDs, amounts, etc.',
          minLines: 3,
          maxLines: 5,
        ),
        SizedBox(height: uploadTopGap),
        _UploadEvidenceButton(attached: evidenceAttached, onPressed: onUpload),
      ],
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 74),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      decoration: BoxDecoration(
        color: _disputeBlue.withValues(alpha: .08),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _disputeBlue, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: _disputeBlue, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.micro.copyWith(
                    color: _disputeBlue,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: AppTextStyles.micro.copyWith(
                    color: _disputeBlue,
                    fontSize: 10.5,
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

class _ComplaintTypeCard extends StatelessWidget {
  const _ComplaintTypeCard({
    required this.option,
    required this.selected,
    required this.onPressed,
  });

  final TradeComplaintTypeOption option;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: DisputeResolutionPage.complaintTypeKey(option.value),
      onTap: onPressed,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 62,
        padding: const EdgeInsets.fromLTRB(14, 11, 14, 9),
        decoration: BoxDecoration(
          color: selected ? _disputeBlue.withValues(alpha: .13) : _disputeField,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(
            color: selected ? _disputeBlue : _disputeFieldBorder,
            width: selected ? 2 : 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              option.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: selected ? _disputeBlue : AppColors.text1,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              option.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: selected ? _disputeBlue : AppColors.text3,
                fontSize: 10,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProviderSelect extends StatelessWidget {
  const _ProviderSelect({
    required this.providers,
    required this.selectedProviderId,
    required this.onChanged,
  });

  final List<TradeDisputeProviderOption> providers;
  final String? selectedProviderId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: DisputeResolutionPage.providerKey,
      height: 46,
      padding: const EdgeInsets.only(left: 16, right: 10),
      decoration: BoxDecoration(
        color: _disputeField,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _disputeFieldBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedProviderId,
          dropdownColor: _disputeField,
          borderRadius: AppRadii.cardRadius,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.text3,
            size: 22,
          ),
          hint: Text(
            'Select provider...',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 13,
              height: 1,
            ),
          ),
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontSize: 13,
            height: 1,
          ),
          items: [
            for (final provider in providers)
              DropdownMenuItem<String>(
                value: provider.id,
                child: Text(provider.name),
              ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _TextFieldShell extends StatelessWidget {
  const _TextFieldShell({
    super.key,
    required this.controller,
    required this.hint,
    this.minLines = 1,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hint;
  final int minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      cursorColor: _disputeBlue,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.text1,
        fontSize: 13,
        height: 1.2,
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        hintStyle: AppTextStyles.caption.copyWith(
          color: AppColors.text3,
          fontSize: 13,
          fontWeight: AppTextStyles.bold,
          height: 1.2,
        ),
        filled: true,
        fillColor: _disputeField,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.cardRadius,
          borderSide: const BorderSide(color: _disputeFieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.cardRadius,
          borderSide: const BorderSide(color: _disputeBlue, width: 1.5),
        ),
      ),
    );
  }
}

class _UploadEvidenceButton extends StatelessWidget {
  const _UploadEvidenceButton({
    required this.attached,
    required this.onPressed,
  });

  final bool attached;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: DisputeResolutionPage.uploadKey,
      onTap: onPressed,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _disputeField,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(
            color: attached ? AppColors.buy : _disputeFieldBorder,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              attached
                  ? Icons.check_circle_outline_rounded
                  : Icons.upload_rounded,
              color: attached ? AppColors.buy : AppColors.text3,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              attached ? 'Evidence attached' : 'Upload Evidence (Optional)',
              style: AppTextStyles.caption.copyWith(
                color: attached ? AppColors.buy : AppColors.text3,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.enabled, required this.onPressed});

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: DisputeResolutionPage.submitKey,
      onTap: enabled ? onPressed : null,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? _disputeBlue : const Color(0xFF1A1F2A),
          borderRadius: AppRadii.inputRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.send_outlined,
              color: enabled ? Colors.white : AppColors.text3,
              size: 17,
            ),
            const SizedBox(width: 9),
            Text(
              'Submit Complaint',
              style: AppTextStyles.body.copyWith(
                color: enabled ? Colors.white : AppColors.text3,
                fontSize: 14,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DisputeTabs extends StatelessWidget {
  const _DisputeTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeDisputeTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      color: _disputeFooter,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: DisputeResolutionPage.tabKey(tab.id),
                onTap: () => onChanged(tab.id),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                tab.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.caption.copyWith(
                                  color: tab.id == activeId
                                      ? _disputeBlue
                                      : AppColors.text3,
                                  fontSize: 12,
                                  fontWeight: AppTextStyles.bold,
                                  height: 1,
                                ),
                              ),
                            ),
                            if (tab.badgeCount != null) ...[
                              const SizedBox(width: 5),
                              _TabBadge(tab.badgeCount!),
                            ],
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: tab.id == activeId ? 70 : 0,
                      height: 2,
                      color: _disputeBlue,
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

class _TabBadge extends StatelessWidget {
  const _TabBadge(this.count);

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: _disputeBlue,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$count',
        style: AppTextStyles.micro.copyWith(
          color: Colors.white,
          fontSize: 10,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _CasesTab extends StatelessWidget {
  const _CasesTab({
    required this.activeTabId,
    required this.snapshot,
    required this.lastResult,
  });

  final String activeTabId;
  final TradeDisputeResolutionSnapshot snapshot;
  final TradeDisputeSubmissionResult? lastResult;

  @override
  Widget build(BuildContext context) {
    final cases = activeTabId == 'history'
        ? snapshot.resolvedCases
        : snapshot.activeCases;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (lastResult != null && activeTabId == 'active') ...[
          _ResultBanner(result: lastResult!),
          const SizedBox(height: 12),
        ],
        if (cases.isEmpty)
          _EmptyCases(history: activeTabId == 'history')
        else
          for (final disputeCase in cases) ...[
            _DisputeCaseCard(disputeCase: disputeCase),
            if (disputeCase != cases.last) const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _ResultBanner extends StatelessWidget {
  const _ResultBanner({required this.result});

  final TradeDisputeSubmissionResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.buy10,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.buy20),
      ),
      child: Text(
        '${result.message}: ${result.caseId}',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.buy,
          fontSize: 12,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _DisputeCaseCard extends StatelessWidget {
  const _DisputeCaseCard({required this.disputeCase});

  final TradeDisputeCase disputeCase;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(disputeCase.status);
    final resolved = disputeCase.status == 'resolved';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (resolved)
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.buy,
                  size: 15,
                )
              else
                _StatusPill(
                  label: _statusLabel(disputeCase.status),
                  color: statusColor,
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  resolved
                      ? _outcomeLabel(disputeCase.outcome)
                      : 'Case #${disputeCase.id}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: resolved ? AppColors.buy : AppColors.text3,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            disputeCase.subject,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 13,
              fontWeight: AppTextStyles.bold,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Provider: ${disputeCase.providerName}',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            disputeCase.description,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 10,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          if (!resolved)
            _CaseTimeline(disputeCase: disputeCase)
          else
            _RefundPanel(disputeCase: disputeCase),
          if (!resolved) ...[
            const SizedBox(height: 12),
            Container(
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _disputeDangerBg,
                borderRadius: AppRadii.smRadius,
              ),
              child: Text(
                'Escalate to Senior Support',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.sell,
                  fontSize: 11,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
          ],
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
      height: 20,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _CaseTimeline extends StatelessWidget {
  const _CaseTimeline({required this.disputeCase});

  final TradeDisputeCase disputeCase;

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('submitted', 'Complaint submitted'),
      ('under_review', 'Under review by support team'),
      ('provider_response', 'Awaiting provider response'),
      ('resolved', 'Resolution'),
    ];
    return Column(
      children: [
        for (final step in steps) ...[
          _TimelineRow(
            done: _stepDone(step.$1, disputeCase.status),
            label: step.$2,
            date: step.$1 == 'submitted'
                ? disputeCase.submittedDate
                : step.$1 == disputeCase.status
                ? disputeCase.updatedDate
                : '',
          ),
          if (step != steps.last) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.done,
    required this.label,
    required this.date,
  });

  final bool done;
  final String label;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          done ? Icons.check_circle_outline_rounded : Icons.schedule_rounded,
          color: done ? AppColors.buy : AppColors.text3,
          size: 14,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: done ? AppColors.text1 : AppColors.text3,
                  fontSize: 10,
                  fontWeight: done ? AppTextStyles.bold : AppTextStyles.normal,
                  height: 1.2,
                ),
              ),
              if (date.isNotEmpty)
                Text(
                  date,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 9,
                    height: 1.2,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RefundPanel extends StatelessWidget {
  const _RefundPanel({required this.disputeCase});

  final TradeDisputeCase disputeCase;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.buy10,
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        '\$5 refund issued to your account',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.buy,
          fontSize: 10,
          height: 1.3,
        ),
      ),
    );
  }
}

class _EmptyCases extends StatelessWidget {
  const _EmptyCases({required this.history});

  final bool history;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(
            history
                ? Icons.description_outlined
                : Icons.check_circle_outline_rounded,
            color: AppColors.text3,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            history ? 'No resolved cases yet' : 'No active cases',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text2,
          fontSize: 12,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text2,
        fontSize: 11,
        height: 1,
      ),
    );
  }
}

Color _statusColor(String status) {
  switch (status) {
    case 'under_review':
      return _disputeBlue;
    case 'provider_response':
      return AppColors.warn;
    case 'resolved':
      return AppColors.buy;
    case 'escalated':
      return AppColors.sell;
    default:
      return AppColors.text3;
  }
}

String _statusLabel(String status) {
  switch (status) {
    case 'under_review':
      return 'Under Review';
    case 'provider_response':
      return 'Provider Responded';
    case 'resolved':
      return 'Resolved';
    case 'escalated':
      return 'Escalated';
    default:
      return 'Submitted';
  }
}

String _outcomeLabel(String? outcome) {
  switch (outcome) {
    case 'refund':
      return 'Refund Issued';
    case 'warning':
      return 'Provider Warned';
    case 'suspension':
      return 'Provider Suspended';
    case 'no_action':
      return 'No Action Required';
    default:
      return 'Pending';
  }
}

bool _stepDone(String step, String status) {
  const order = ['submitted', 'under_review', 'provider_response', 'resolved'];
  return order.indexOf(step) <= order.indexOf(status);
}
