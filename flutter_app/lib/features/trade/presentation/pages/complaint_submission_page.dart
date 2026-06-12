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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

import '../widgets/trade_body_review_widgets.dart';

part '../widgets/complaint_submission_page_sections.dart';
part '../widgets/complaint_submission_page_common.dart';

const _submissionBackground = AppColors.bg;
const _submissionPanel = AppColors.surface;
const _submissionPanel2 = AppColors.surface3;
const _submissionBorder = AppColors.borderSolid;
const _submissionPrimary = AppColors.primary;

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
        .watch(tradeReadModelControllerProvider)
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
        color: _submissionBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Submit Complaint',
            subtitle: 'FCA Regulated Process',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeCopyComplaintsHandling),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: ComplaintSubmissionPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 27, 20, scrollBottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    customGap: 14,
                    fullBleed: true,
                    children: [
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Review complaint submission',
                        message:
                            'Confirm evidence, personal details, deadlines, and next steps before submitting this regulated complaint.',
                      ),
                      _ProcessNotice(snapshot: snapshot),
                      const _SectionLabel('Complaint Details'),
                      _CategoryField(
                        value: _category,
                        categories: snapshot.categories,
                        onChanged: (value) => setState(() => _category = value),
                      ),
                      _TextInputBlock(
                        label: 'Subject *',
                        controller: _subjectController,
                        hint: 'Brief summary of your complaint',
                        maxLength: snapshot.subjectMaxLength,
                        minLength: snapshot.subjectMinLength,
                        onChanged: (_) => setState(() {}),
                      ),
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
                      const _EvidenceUploadCard(),
                      _TermsCard(
                        snapshot: snapshot,
                        accepted: _acceptTerms,
                        onChanged: (value) =>
                            setState(() => _acceptTerms = value),
                      ),
                      const TradeBodyReviewSection(
                        title: 'Complaint submission body review',
                        message: 'Complaint submission body reviewed',
                        detail:
                            'Category, subject, description, evidence, consent, submitting, and result states stay visible.',
                        primary:
                            'Process notice remains above the regulated complaint form.',
                        secondary:
                            'Evidence and terms stay visible before the sticky submit action.',
                        tertiary:
                            'Submission copy remains regulatory and non-promotional.',
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
