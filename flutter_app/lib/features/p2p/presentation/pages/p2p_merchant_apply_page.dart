import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
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

class P2PMerchantApplyPage extends ConsumerStatefulWidget {
  const P2PMerchantApplyPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc227_p2p_merchant_apply_content');
  static const nextButtonKey = Key('sc227_p2p_merchant_apply_next');
  static const previousButtonKey = Key('sc227_p2p_merchant_apply_previous');
  static const submitButtonKey = Key('sc227_p2p_merchant_apply_submit');
  static const successCtaKey = Key('sc227_p2p_merchant_apply_success_cta');
  static const agreementKey = Key('sc227_p2p_merchant_apply_agreement');
  static const businessNameFieldKey = Key('sc227_business_name');
  static const businessDescriptionFieldKey = Key('sc227_business_description');

  static Key stepKey(int index) => Key('sc227_step_$index');

  static Key businessTypeKey(String value) => Key('sc227_business_type_$value');

  static Key documentKey(String id) => Key('sc227_document_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PMerchantApplyPage> createState() =>
      _P2PMerchantApplyPageState();
}

class _P2PMerchantApplyPageState extends ConsumerState<P2PMerchantApplyPage> {
  static const List<String> _steps = [
    'Yêu cầu',
    'Thông tin',
    'Xác minh',
    'Lịch sử',
    'Hoàn tất',
  ];

  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessDescriptionController =
      TextEditingController();

  int _step = 0;
  String _businessType = '';
  bool _agreementAccepted = false;
  bool _submitting = false;
  bool _submitted = false;
  final Set<String> _uploadedDocuments = {};

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pRepositoryProvider).getMerchantApply();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-227 P2PMerchantApplyPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Đăng ký Merchant',
              subtitle: 'Merchant · P2P',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            if (!_submitted) _ProgressHeader(steps: _steps, currentStep: _step),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: P2PMerchantApplyPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x5,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: _submitted
                      ? _SuccessState(
                          reviewSteps: snapshot.reviewSteps,
                          onBackToP2P: () => context.go(AppRoutePaths.p2p),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              child: _stepContent(snapshot),
                            ),
                            const SizedBox(height: AppSpacing.x6),
                            _NavigationButtons(
                              step: _step,
                              canProceed: _canProceed(snapshot),
                              submitting: _submitting,
                              onPrevious: _previous,
                              onNext: _next,
                              onSubmit: () => _submit(snapshot),
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

  Widget _stepContent(P2PMerchantApplySnapshot snapshot) {
    return switch (_step) {
      0 => _RequirementsStep(snapshot: snapshot),
      1 => _BusinessInfoStep(
        snapshot: snapshot,
        nameController: _businessNameController,
        descriptionController: _businessDescriptionController,
        businessType: _businessType,
        onNameChanged: () => setState(() {}),
        onDescriptionChanged: () => setState(() {}),
        onTypeChanged: (value) {
          HapticFeedback.selectionClick();
          setState(() => _businessType = value);
        },
      ),
      2 => _DocumentsStep(
        documents: snapshot.documents,
        uploadedDocuments: _uploadedDocuments,
        securityNote: snapshot.securityNote,
        onToggle: _toggleDocument,
      ),
      3 => _HistoryStep(stats: snapshot.stats),
      _ => _FinalStep(
        stats: snapshot.stats,
        businessName: _businessNameController.text.trim(),
        businessType: _businessType,
        uploadedCount: _uploadedDocuments.length,
        reviewNotice: snapshot.reviewNotice,
        agreementAccepted: _agreementAccepted,
        onToggleAgreement: () {
          HapticFeedback.selectionClick();
          setState(() => _agreementAccepted = !_agreementAccepted);
        },
      ),
    };
  }

  bool _canProceed(P2PMerchantApplySnapshot snapshot) {
    return switch (_step) {
      0 => snapshot.allRequirementsMet,
      1 =>
        _businessNameController.text.trim().isNotEmpty &&
            _businessType.isNotEmpty,
      2 =>
        snapshot.documents
            .where((document) => document.required)
            .every((document) => _uploadedDocuments.contains(document.id)),
      3 => true,
      _ => _agreementAccepted,
    };
  }

  void _next() {
    if (_step >= _steps.length - 1) return;
    HapticFeedback.selectionClick();
    setState(() => _step += 1);
  }

  void _previous() {
    if (_step <= 0) return;
    HapticFeedback.selectionClick();
    setState(() => _step -= 1);
  }

  void _toggleDocument(P2PMerchantDocumentDraft document) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_uploadedDocuments.contains(document.id)) {
        _uploadedDocuments.remove(document.id);
      } else {
        _uploadedDocuments.add(document.id);
      }
    });
  }

  Future<void> _submit(P2PMerchantApplySnapshot snapshot) async {
    if (!_canProceed(snapshot) || _submitting) return;
    HapticFeedback.lightImpact();
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 320));
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _submitted = true;
    });
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.steps, required this.currentStep});

  final List<String> steps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.contentPad,
          AppSpacing.x4,
          AppSpacing.contentPad,
          AppSpacing.x3,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < steps.length; i++)
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _StepConnector(
                            active: i > 0 && i <= currentStep,
                          ),
                        ),
                        _StepDot(index: i, activeIndex: currentStep),
                        Expanded(
                          child: _StepConnector(active: i < currentStep),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      steps[i],
                      key: P2PMerchantApplyPage.stepKey(i),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.micro.copyWith(
                        color: i <= currentStep
                            ? AppColors.text1
                            : AppColors.text3,
                        fontSize: 8,
                        fontWeight: i <= currentStep
                            ? AppTextStyles.bold
                            : AppTextStyles.normal,
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

class _StepConnector extends StatelessWidget {
  const _StepConnector({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.x2),
      decoration: BoxDecoration(
        color: active ? AppColors.buy : AppColors.surface3,
        borderRadius: AppRadii.smRadius,
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.index, required this.activeIndex});

  final int index;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final completed = index < activeIndex;
    final active = index == activeIndex;
    final color = completed
        ? AppColors.buy
        : active
        ? AppModuleAccents.p2p
        : AppColors.surface3;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: completed || active ? color : AppColors.borderSolid,
        ),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: completed
          ? const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: AppSpacing.iconSm,
            )
          : Text(
              '${index + 1}',
              style: AppTextStyles.micro.copyWith(
                color: active ? Colors.white : AppColors.text3,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
    );
  }
}

class _RequirementsStep extends StatelessWidget {
  const _RequirementsStep({required this.snapshot});

  final P2PMerchantApplySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('sc227_step_requirements'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StepIntro(
          title: 'Trở thành Merchant',
          subtitle:
              'Nâng cấp tài khoản để nhận ưu đãi độc quyền và tăng uy tín.',
        ),
        const SizedBox(height: AppSpacing.x5),
        _BenefitGrid(benefits: snapshot.benefits),
        const SizedBox(height: AppSpacing.x5),
        _RequirementChecklist(requirements: snapshot.requirements),
      ],
    );
  }
}

class _BenefitGrid extends StatelessWidget {
  const _BenefitGrid({required this.benefits});

  final List<P2PMerchantBenefitDraft> benefits;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: benefits.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.x3,
        mainAxisSpacing: AppSpacing.x3,
        mainAxisExtent: 112,
      ),
      itemBuilder: (context, index) => _BenefitCard(benefit: benefits[index]),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({required this.benefit});

  final P2PMerchantBenefitDraft benefit;

  @override
  Widget build(BuildContext context) {
    final tone = _toneColor(benefit.toneKey);
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBadge(icon: _iconFor(benefit.iconKey), color: tone),
          const Spacer(),
          Text(
            benefit.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            benefit.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _RequirementChecklist extends StatelessWidget {
  const _RequirementChecklist({required this.requirements});

  final List<P2PMerchantRequirementDraft> requirements;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Yêu cầu tối thiểu',
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final requirement in requirements) ...[
            _RequirementRow(requirement: requirement),
            if (requirement != requirements.last)
              const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  const _RequirementRow({required this.requirement});

  final P2PMerchantRequirementDraft requirement;

  @override
  Widget build(BuildContext context) {
    final color = requirement.met ? AppColors.buy : AppColors.sell;
    return Row(
      children: [
        _CircleStatusIcon(met: requirement.met),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            requirement.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: requirement.met ? AppColors.text1 : AppColors.sell,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Text(
          requirement.value,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _BusinessInfoStep extends StatelessWidget {
  const _BusinessInfoStep({
    required this.snapshot,
    required this.nameController,
    required this.descriptionController,
    required this.businessType,
    required this.onNameChanged,
    required this.onDescriptionChanged,
    required this.onTypeChanged,
  });

  final P2PMerchantApplySnapshot snapshot;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final String businessType;
  final VoidCallback onNameChanged;
  final VoidCallback onDescriptionChanged;
  final ValueChanged<String> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('sc227_step_business'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StepIntro(
          title: 'Thông tin doanh nghiệp',
          subtitle: 'Cung cấp thông tin để xác minh tài khoản Merchant.',
        ),
        const SizedBox(height: AppSpacing.x5),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VitInput(
                controller: nameController,
                fieldKey: P2PMerchantApplyPage.businessNameFieldKey,
                label: 'Tên doanh nghiệp / Tên hiển thị *',
                hintText: 'VD: CryptoTrader VN',
                textCapitalization: TextCapitalization.words,
                onChanged: (_) => onNameChanged(),
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                'Loại hình *',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: AppSpacing.x2),
              Wrap(
                spacing: AppSpacing.x2,
                runSpacing: AppSpacing.x2,
                children: [
                  for (final type in snapshot.businessTypes)
                    _ChoiceChipButton(
                      key: P2PMerchantApplyPage.businessTypeKey(type),
                      label: type,
                      selected: businessType == type,
                      onTap: () => onTypeChanged(type),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              _MultilineInput(
                controller: descriptionController,
                fieldKey: P2PMerchantApplyPage.businessDescriptionFieldKey,
                label: 'Mô tả (tùy chọn)',
                hintText: 'Giới thiệu ngắn về hoạt động giao dịch của bạn...',
                onChanged: onDescriptionChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DocumentsStep extends StatelessWidget {
  const _DocumentsStep({
    required this.documents,
    required this.uploadedDocuments,
    required this.securityNote,
    required this.onToggle,
  });

  final List<P2PMerchantDocumentDraft> documents;
  final Set<String> uploadedDocuments;
  final String securityNote;
  final ValueChanged<P2PMerchantDocumentDraft> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('sc227_step_documents'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StepIntro(
          title: 'Xác minh tài liệu',
          subtitle: 'Tải lên các tài liệu cần thiết để xác minh.',
        ),
        const SizedBox(height: AppSpacing.x5),
        for (final document in documents) ...[
          _DocumentCard(
            document: document,
            uploaded: uploadedDocuments.contains(document.id),
            onTap: () => onToggle(document),
          ),
          const SizedBox(height: AppSpacing.x3),
        ],
        _InfoBanner(
          icon: Icons.shield_outlined,
          text: securityNote,
          color: AppModuleAccents.p2p,
        ),
      ],
    );
  }
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({
    required this.document,
    required this.uploaded,
    required this.onTap,
  });

  final P2PMerchantDocumentDraft document;
  final bool uploaded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PMerchantApplyPage.documentKey(document.id),
      onTap: onTap,
      borderColor: uploaded ? AppColors.buy20 : null,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _IconBadge(
            icon: uploaded
                ? Icons.check_circle_rounded
                : _iconFor(document.iconKey),
            color: uploaded ? AppColors.buy : AppColors.text3,
            large: true,
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
                        document.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    if (document.required) ...[
                      const SizedBox(width: AppSpacing.x1),
                      Text(
                        '*',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.sell,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  uploaded ? 'Đã tải lên (Demo)' : document.subtitle,
                  style: AppTextStyles.micro.copyWith(
                    color: uploaded ? AppColors.buy : AppColors.text3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Icon(
            uploaded ? Icons.check_rounded : Icons.upload_rounded,
            color: uploaded ? AppColors.buy : AppColors.text3,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _HistoryStep extends StatelessWidget {
  const _HistoryStep({required this.stats});

  final P2PMerchantStatsDraft stats;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _MetricData(
        label: 'Tổng đơn hoàn thành',
        value: '${stats.totalTrades}',
        color: AppModuleAccents.p2p,
        icon: Icons.trending_up_rounded,
      ),
      _MetricData(
        label: 'Tỷ lệ hoàn thành',
        value: '${stats.completionRate}%',
        color: AppColors.buy,
        icon: Icons.shield_outlined,
      ),
      _MetricData(
        label: 'Thời gian phản hồi TB',
        value: stats.avgResponseTime,
        color: AppColors.warn,
        icon: Icons.access_time_rounded,
      ),
      _MetricData(
        label: 'Tuổi tài khoản',
        value: '${stats.accountAgeDays} ngày',
        color: AppColors.accent,
        icon: Icons.calendar_month_outlined,
      ),
      _MetricData(
        label: 'KL giao dịch 30 ngày',
        value: '${(stats.volume30dVnd / 1000000).toStringAsFixed(1)}M VND',
        color: AppModuleAccents.p2p,
        icon: Icons.show_chart_rounded,
      ),
      _MetricData(
        label: 'Tranh chấp',
        value: '${stats.disputes}',
        color: stats.disputes <= 2 ? AppColors.buy : AppColors.sell,
        icon: Icons.warning_amber_rounded,
      ),
    ];

    return Column(
      key: const ValueKey('sc227_step_history'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StepIntro(
          title: 'Đánh giá lịch sử',
          subtitle: 'Hệ thống tự động kiểm tra lịch sử giao dịch.',
        ),
        const SizedBox(height: AppSpacing.x5),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            children: [
              for (final row in rows) ...[
                _MetricRow(data: row),
                if (row != rows.last) const Divider(color: AppColors.divider),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        const _InfoBanner(
          icon: Icons.check_circle_rounded,
          text: 'Tất cả tiêu chí đánh giá đều đạt yêu cầu!',
          color: AppColors.buy,
        ),
      ],
    );
  }
}

class _FinalStep extends StatelessWidget {
  const _FinalStep({
    required this.stats,
    required this.businessName,
    required this.businessType,
    required this.uploadedCount,
    required this.reviewNotice,
    required this.agreementAccepted,
    required this.onToggleAgreement,
  });

  final P2PMerchantStatsDraft stats;
  final String businessName;
  final String businessType;
  final int uploadedCount;
  final String reviewNotice;
  final bool agreementAccepted;
  final VoidCallback onToggleAgreement;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _SummaryData(
        label: 'Tên',
        value: businessName.isEmpty ? '-' : businessName,
      ),
      _SummaryData(
        label: 'Loại hình',
        value: businessType.isEmpty ? '-' : businessType,
      ),
      _SummaryData(label: 'Tổng đơn', value: '${stats.totalTrades}'),
      _SummaryData(label: 'Tỷ lệ HT', value: '${stats.completionRate}%'),
      _SummaryData(label: 'KYC', value: 'Cấp ${stats.kycLevel}'),
      _SummaryData(label: 'Tài liệu', value: '$uploadedCount/3 đã tải'),
    ];

    return Column(
      key: const ValueKey('sc227_step_final'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StepIntro(
          title: 'Xác nhận & Gửi đơn',
          subtitle: 'Kiểm tra lại thông tin trước khi nộp đơn đăng ký.',
        ),
        const SizedBox(height: AppSpacing.x5),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Tóm tắt đơn đăng ký',
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x3),
              for (final row in rows) _SummaryRow(data: row),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        _AgreementCard(accepted: agreementAccepted, onTap: onToggleAgreement),
        const SizedBox(height: AppSpacing.x4),
        _InfoBanner(
          icon: Icons.warning_amber_rounded,
          text: reviewNotice,
          color: AppColors.warn,
        ),
      ],
    );
  }
}

class _SuccessState extends StatelessWidget {
  const _SuccessState({required this.reviewSteps, required this.onBackToP2P});

  final List<String> reviewSteps;
  final VoidCallback onBackToP2P;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('sc227_success'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.x5),
        const Icon(
          Icons.verified_rounded,
          color: AppColors.buy,
          size: AppSpacing.x7,
        ),
        const SizedBox(height: AppSpacing.x5),
        Text(
          'Đơn đã gửi thành công!',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(color: AppColors.text1),
        ),
        const SizedBox(height: AppSpacing.x3),
        Text(
          'Đội ngũ VitTrade sẽ xem xét trong vòng 1-3 ngày làm việc. Bạn sẽ nhận thông báo khi có kết quả.',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x5),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    color: AppColors.warn,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Trạng thái: Đang xét duyệt',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              for (var i = 0; i < reviewSteps.length; i++) ...[
                Row(
                  children: [
                    _TinyStatusDot(active: i == 0),
                    const SizedBox(width: AppSpacing.x3),
                    Text(
                      reviewSteps[i],
                      style: AppTextStyles.caption.copyWith(
                        color: i == 0 ? AppColors.buy : AppColors.text3,
                        fontWeight: i == 0
                            ? AppTextStyles.bold
                            : AppTextStyles.normal,
                      ),
                    ),
                  ],
                ),
                if (i != reviewSteps.length - 1)
                  const SizedBox(height: AppSpacing.x2),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        VitCtaButton(
          key: P2PMerchantApplyPage.successCtaKey,
          onPressed: onBackToP2P,
          child: const Text('Quay về P2P'),
        ),
      ],
    );
  }
}

class _NavigationButtons extends StatelessWidget {
  const _NavigationButtons({
    required this.step,
    required this.canProceed,
    required this.submitting,
    required this.onPrevious,
    required this.onNext,
    required this.onSubmit,
  });

  final int step;
  final bool canProceed;
  final bool submitting;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final primary = step < 4
        ? VitCtaButton(
            key: P2PMerchantApplyPage.nextButtonKey,
            onPressed: canProceed ? onNext : null,
            trailing: const Icon(Icons.arrow_forward_rounded),
            child: const Text('Tiếp tục'),
          )
        : VitCtaButton(
            key: P2PMerchantApplyPage.submitButtonKey,
            onPressed: canProceed && !submitting ? onSubmit : null,
            loading: submitting,
            variant: VitCtaButtonVariant.success,
            child: Text(submitting ? 'Đang gửi...' : 'Gửi đơn đăng ký'),
          );

    if (step == 0) return primary;

    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            key: P2PMerchantApplyPage.previousButtonKey,
            onPressed: onPrevious,
            variant: VitCtaButtonVariant.secondary,
            leading: const Icon(Icons.arrow_back_rounded),
            child: const Text('Quay lại'),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(child: primary),
      ],
    );
  }
}

class _StepIntro extends StatelessWidget {
  const _StepIntro({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTextStyles.sectionTitle.copyWith(color: AppColors.text1),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          subtitle,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}

class _ChoiceChipButton extends StatelessWidget {
  const _ChoiceChipButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary12 : AppColors.surface2,
            border: Border.all(
              color: selected ? AppColors.primary30 : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: selected ? AppColors.primarySoft : AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _MultilineInput extends StatelessWidget {
  const _MultilineInput({
    required this.controller,
    required this.fieldKey,
    required this.label,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final Key fieldKey;
  final String label;
  final String hintText;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x2),
        Container(
          constraints: const BoxConstraints(minHeight: AppSpacing.buttonHero),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x3,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            border: Border.all(color: AppColors.borderSolid, width: 1.5),
            borderRadius: AppRadii.inputRadius,
          ),
          child: TextField(
            key: fieldKey,
            controller: controller,
            minLines: 3,
            maxLines: 3,
            cursorColor: AppColors.primary,
            style: AppTextStyles.body.copyWith(fontSize: 14),
            onChanged: (_) => onChanged(),
            decoration: InputDecoration.collapsed(
              hintText: hintText,
              hintStyle: AppTextStyles.body.copyWith(
                color: AppColors.text3,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AgreementCard extends StatelessWidget {
  const _AgreementCard({required this.accepted, required this.onTap});

  final bool accepted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PMerchantApplyPage.agreementKey,
      variant: VitCardVariant.inner,
      borderColor: accepted ? AppColors.buy20 : AppColors.borderSolid,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.iconMd,
            height: AppSpacing.iconMd,
            margin: const EdgeInsets.only(top: AppSpacing.x1),
            decoration: BoxDecoration(
              color: accepted ? AppColors.buy : Colors.transparent,
              border: Border.all(
                color: accepted ? AppColors.buy : AppColors.text3,
                width: 1.5,
              ),
              borderRadius: AppRadii.smRadius,
            ),
            child: accepted
                ? const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: AppSpacing.iconSm,
                  )
                : null,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Tôi xác nhận thông tin là chính xác, đồng ý với Điều khoản Merchant và Chính sách P2P của VitTrade. Tôi hiểu rằng vi phạm có thể dẫn đến thu hồi tư cách Merchant.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        border: Border.all(color: color.withValues(alpha: .22)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  height: 1.55,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricData {
  const _MetricData({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.data});

  final _MetricData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Row(
        children: [
          _IconBadge(icon: data.icon, color: data.color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              data.label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Text(
            data.value,
            style: AppTextStyles.caption.copyWith(
              color: data.color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryData {
  const _SummaryData({required this.label, required this.value});

  final String label;
  final String value;
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.data});

  final _SummaryData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              data.value,
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.color,
    this.large = false,
  });

  final IconData icon;
  final Color color;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final size = large ? 48.0 : 32.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: large ? AppRadii.mdRadius : AppRadii.smRadius,
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        color: color,
        size: large ? AppSpacing.iconMd : AppSpacing.iconSm,
      ),
    );
  }
}

class _CircleStatusIcon extends StatelessWidget {
  const _CircleStatusIcon({required this.met});

  final bool met;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: (met ? AppColors.buy : AppColors.sell).withValues(alpha: .12),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        met ? Icons.check_circle_rounded : Icons.cancel_rounded,
        color: met ? AppColors.buy : AppColors.sell,
        size: AppSpacing.iconSm,
      ),
    );
  }
}

class _TinyStatusDot extends StatelessWidget {
  const _TinyStatusDot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.iconMd,
      height: AppSpacing.iconMd,
      decoration: BoxDecoration(
        color: active ? AppColors.buy : AppColors.surface2,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        active ? Icons.check_rounded : Icons.radio_button_checked_rounded,
        color: active ? Colors.white : AppColors.text3,
        size: AppSpacing.iconSm,
      ),
    );
  }
}

Color _toneColor(String key) {
  return switch (key) {
    'buy' => AppColors.buy,
    'accent' => AppColors.accent,
    'primary' => AppModuleAccents.p2p,
    _ => AppColors.warn,
  };
}

IconData _iconFor(String key) {
  return switch (key) {
    'award' => Icons.workspace_premium_outlined,
    'camera' => Icons.photo_camera_outlined,
    'clock' => Icons.access_time_rounded,
    'file' => Icons.description_outlined,
    'shield' => Icons.shield_outlined,
    'star' => Icons.star_border_rounded,
    'trend' => Icons.trending_up_rounded,
    'users' => Icons.groups_outlined,
    'verified' => Icons.verified_outlined,
    'warning' => Icons.warning_amber_rounded,
    'zap' => Icons.bolt_rounded,
    _ => Icons.radio_button_checked_rounded,
  };
}
