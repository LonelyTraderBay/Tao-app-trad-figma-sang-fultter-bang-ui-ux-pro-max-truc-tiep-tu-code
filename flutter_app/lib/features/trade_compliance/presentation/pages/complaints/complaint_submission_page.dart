import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_body_review_widgets.dart';

part '../../widgets/complaints/complaint_submission_page_sections.dart';
part '../../widgets/complaints/complaint_submission_page_common.dart';

const _submissionPanel = AppColors.surface;
const _submissionPanel2 = AppColors.surface3;
const _submissionBorder = AppColors.borderSolid;
const _submissionPrimary = AppColors.primary;
const _submissionSpace = AppSpacing.x2;
const _submissionSmallSpace = AppSpacing.x1;
const _submissionCardSpace = AppSpacing.x3;
const _submissionLineTight = 1.0;
const _submissionLineShort = 1.16;
const _submissionLineBody = 1.24;
const _submissionLineHint = 1.28;
const _submissionLineReadable = 1.3;
const _submissionLineLong = 1.34;
const _submissionFooterHeight =
    TradeSpacingTokens.complaintSubmissionFooterHeight;
const _submissionCategoryHeight =
    TradeSpacingTokens.tradeBotDisputeProviderHeight;
const _submissionMultilineHeight =
    TradeSpacingTokens.complaintSubmissionMultilineHeight;
const _submissionEvidenceHeight =
    TradeSpacingTokens.complaintSubmissionEvidenceHeight;
const _submissionEvidenceIconSize = TradeSpacingTokens.tradeBotQuestionIconBox;
const _submissionCheckboxSize =
    TradeSpacingTokens.complaintSubmissionCheckboxSize;

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
        .watch(tradeRegulatoryRepositoryProvider)
        .getComplaintSubmission();
    final canSubmit = _canSubmit(snapshot);

    return VitTradeHubScaffold(
      title: 'Submit Complaint',
      subtitle: 'FCA Regulated Process',
      semanticLabel: 'SC-112 ComplaintSubmissionPage',
      contentKey: ComplaintSubmissionPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyComplaintsHandling,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: [
        VitTradeSection(
          title: 'Review',
          child: const VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            title: 'Review complaint submission',
            message:
                'Confirm evidence, personal details, deadlines, and next steps before submitting this regulated complaint.',
            density: VitDensity.compact,
          ),
        ),
        VitTradeSection(
          title: 'Complaint Details',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VitTradeComplianceHero(
                title: snapshot.processTitle,
                description: snapshot.processDescription,
                icon: Icons.info_outline_rounded,
                accentColor: AppColors.text1,
              ),
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
                onChanged: (value) => setState(() => _acceptTerms = value),
              ),
              const TradeBodyReviewSection(
                title: 'Complaint submission body review',
                message: 'Complaint submission body reviewed',
                detail:
                    'Category, subject, description, evidence, consent, submitting, and result states stay visible.',
                primary:
                    'Process notice remains above the regulated complaint form.',
                secondary:
                    'Evidence and terms stay visible before the submit action.',
                tertiary:
                    'Submission copy remains regulatory and non-promotional.',
              ),
              _SubmissionFooter(
                enabled: canSubmit,
                onSubmit: () => _submit(context, snapshot, canSubmit),
              ),
            ],
          ),
        ),
        VitTradeComplianceSection(
          title: 'Submission status',
          statusPill: const VitStatusPill(
            label: 'Regulated intake',
            status: VitStatusPillStatus.info,
            size: VitStatusPillSize.sm,
          ),
          items: [
            VitTradeComplianceItem(
              label: 'Categories',
              value: '${snapshot.categories.length} available',
            ),
            const VitTradeComplianceItem(
              label: 'Framework',
              value: 'FCA regulated intake',
            ),
          ],
        ),
      ],
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
