import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

const _submissionBg = Color(0xFF080C14);
const _submissionSurface = Color(0xFF151A23);
const _submissionSurface2 = Color(0xFF20263A);
const _submissionBorder = Color(0xFF273142);
const _submissionBlue = Color(0xFF3B82F6);

class ComplaintSubmissionPage extends ConsumerStatefulWidget {
  const ComplaintSubmissionPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc112_complaint_submission_content');
  static const categoryKey = Key('sc112_complaint_category');
  static const subjectKey = Key('sc112_complaint_subject');
  static const descriptionKey = Key('sc112_complaint_description');
  static const acceptKey = Key('sc112_complaint_accept_terms');
  static const submitKey = Key('sc112_complaint_submit');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ComplaintSubmissionPage> createState() =>
      _ComplaintSubmissionPageState();
}

class _ComplaintSubmissionPageState
    extends ConsumerState<ComplaintSubmissionPage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _category;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeRepositoryProvider)
        .getComplaintSubmission();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final footerBottom = bottomChrome + MediaQuery.paddingOf(context).bottom;
    final scrollBottomInset = mode.usesVisualQaFrame ? 32.0 : 24.0;
    final canSubmit = _canSubmit(snapshot);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-112 ComplaintSubmissionPage',
      child: Material(
        color: _submissionBg,
        child: Column(
          children: [
            VitHeader(
              title: 'Submit Complaint',
              subtitle: 'FCA Regulated Process',
              showBack: true,
              onBack: () =>
                  context.go(AppRoutePaths.tradeCopyComplaintsHandling),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: ComplaintSubmissionPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 27, 20, scrollBottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ProcessNotice(snapshot: snapshot),
                    const SizedBox(height: 36),
                    const _SectionLabel('Complaint Details'),
                    const SizedBox(height: 15),
                    _CategoryField(
                      value: _category,
                      categories: snapshot.categories,
                      onChanged: (value) => setState(() => _category = value),
                    ),
                    const SizedBox(height: 19),
                    _TextInputBlock(
                      label: 'Subject *',
                      controller: _subjectController,
                      hint: 'Brief summary of your complaint',
                      maxLength: snapshot.subjectMaxLength,
                      minLength: snapshot.subjectMinLength,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    _TextInputBlock(
                      label: 'Description *',
                      controller: _descriptionController,
                      hint:
                          'Please provide full details of your complaint, including dates, amounts, and any relevant information',
                      maxLength: snapshot.descriptionMaxLength,
                      minLength: snapshot.descriptionMinLength,
                      multiline: true,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 18),
                    const _EvidenceUploadCard(),
                    const SizedBox(height: 25),
                    _TermsCard(
                      snapshot: snapshot,
                      accepted: _acceptTerms,
                      onChanged: (value) =>
                          setState(() => _acceptTerms = value),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: footerBottom),
              child: _SubmissionFooter(
                enabled: canSubmit,
                onSubmit: () => _submit(context, snapshot, canSubmit),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canSubmit(TradeComplaintSubmissionSnapshot snapshot) {
    return _category != null &&
        _subjectController.text.length > snapshot.subjectMinLength &&
        _descriptionController.text.length > snapshot.descriptionMinLength &&
        _acceptTerms;
  }

  void _submit(
    BuildContext context,
    TradeComplaintSubmissionSnapshot snapshot,
    bool canSubmit,
  ) {
    if (!canSubmit) return;
    context.go(
      AppRoutePaths.tradeCopyComplaintTracking(
        snapshot.confirmationComplaintId,
      ),
    );
  }
}

class _ProcessNotice extends StatelessWidget {
  const _ProcessNotice({required this.snapshot});

  final TradeComplaintSubmissionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 10, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.text1,
            size: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.processTitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.processDescription,
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

class _CategoryField extends StatelessWidget {
  const _CategoryField({
    required this.value,
    required this.categories,
    required this.onChanged,
  });

  final String? value;
  final List<String> categories;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Category *'),
        const SizedBox(height: 9),
        PopupMenuButton<String>(
          color: _submissionSurface,
          elevation: 8,
          onSelected: onChanged,
          padding: EdgeInsets.zero,
          position: PopupMenuPosition.under,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          itemBuilder: (_) => [
            for (final category in categories)
              PopupMenuItem(
                value: category,
                child: Text(
                  category,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    height: 1.2,
                  ),
                ),
              ),
          ],
          child: Container(
            key: ComplaintSubmissionPage.categoryKey,
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: _submissionSurface2,
              border: Border.all(
                color: _submissionBorder.withValues(alpha: .76),
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? 'Select category',
                    style: AppTextStyles.base.copyWith(
                      color: AppColors.text1,
                      fontSize: 16,
                      height: 1,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text1,
                  size: 21,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TextInputBlock extends StatelessWidget {
  const _TextInputBlock({
    required this.label,
    required this.controller,
    required this.hint,
    required this.maxLength,
    required this.minLength,
    required this.onChanged,
    this.multiline = false,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLength;
  final int minLength;
  final ValueChanged<String> onChanged;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    final height = multiline ? 169.0 : 48.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 9),
        SizedBox(
          height: height,
          child: TextField(
            key: multiline
                ? ComplaintSubmissionPage.descriptionKey
                : ComplaintSubmissionPage.subjectKey,
            controller: controller,
            onChanged: onChanged,
            maxLength: maxLength,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            maxLines: multiline ? null : 1,
            expands: multiline,
            textAlignVertical: multiline
                ? TextAlignVertical.top
                : TextAlignVertical.center,
            style: AppTextStyles.base.copyWith(
              color: AppColors.text1,
              fontSize: multiline ? 16 : 14,
              height: multiline ? 1.35 : 1,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: hint,
              hintMaxLines: multiline ? 3 : 1,
              hintStyle: AppTextStyles.base.copyWith(
                color: AppColors.text3,
                fontSize: 16,
                fontWeight: AppTextStyles.bold,
                height: multiline ? 1.4 : 1,
              ),
              filled: true,
              fillColor: _submissionSurface2,
              contentPadding: multiline
                  ? const EdgeInsets.fromLTRB(12, 15, 12, 12)
                  : const EdgeInsets.symmetric(horizontal: 12),
              enabledBorder: _inputBorder,
              focusedBorder: _inputBorder,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '${controller.text.length}/$maxLength characters (min $minLength)',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 9,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _EvidenceUploadCard extends StatelessWidget {
  const _EvidenceUploadCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: SizedBox(
        height: 139,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _submissionSurface2,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.upload_rounded,
                color: AppColors.text3,
                size: 22,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Upload Evidence (Optional)',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Screenshots, emails, or other supporting documents',
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 10,
                height: 1,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 17),
              decoration: BoxDecoration(
                color: _submissionSurface2,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(
                'Choose Files',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TermsCard extends StatelessWidget {
  const _TermsCard({
    required this.snapshot,
    required this.accepted,
    required this.onChanged,
  });

  final TradeComplaintSubmissionSnapshot snapshot;
  final bool accepted;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
      child: InkWell(
        key: ComplaintSubmissionPage.acceptKey,
        onTap: () => onChanged(!accepted),
        borderRadius: AppRadii.cardRadius,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Checkbox(
                value: accepted,
                onChanged: (value) => onChanged(value ?? false),
                visualDensity: VisualDensity.compact,
                side: const BorderSide(color: AppColors.text3),
                activeColor: _submissionBlue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.termsIntro,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 11,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 5),
                  for (final term in snapshot.terms)
                    Text(
                      '- $term',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 10,
                        height: 1.5,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmissionFooter extends StatelessWidget {
  const _SubmissionFooter({required this.enabled, required this.onSubmit});

  final bool enabled;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 67,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 3),
      decoration: BoxDecoration(
        color: _submissionBg.withValues(alpha: .94),
        border: Border(
          top: BorderSide(color: _submissionBorder.withValues(alpha: .35)),
        ),
      ),
      child: SizedBox(
        height: 48,
        child: FilledButton(
          key: ComplaintSubmissionPage.submitKey,
          style: FilledButton.styleFrom(
            backgroundColor: enabled ? _submissionBlue : _submissionSurface2,
            foregroundColor: enabled ? Colors.white : AppColors.text3,
            disabledBackgroundColor: _submissionSurface2,
            disabledForegroundColor: AppColors.text3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: enabled ? onSubmit : null,
          child: Opacity(
            opacity: enabled ? 1 : .52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                const SizedBox(width: 9),
                Text(
                  'Submit Complaint',
                  style: AppTextStyles.caption.copyWith(
                    color: enabled ? Colors.white : AppColors.text3,
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
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
      style: AppTextStyles.caption.copyWith(
        color: AppColors.text2,
        fontSize: 11,
        height: 1,
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _submissionBlue,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          text,
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
        color: _submissionSurface,
        border: Border.all(color: _submissionBorder.withValues(alpha: .76)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

final OutlineInputBorder _inputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(18),
  borderSide: BorderSide(color: _submissionBorder.withValues(alpha: .76)),
);
