part of 'p2p_merchant_apply_page.dart';

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
    final snapshot = ref.watch(p2pMerchantApplyProvider);
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
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Đăng ký Merchant',
            subtitle: 'Merchant · P2P',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.p2p),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!_submitted)
                _ProgressHeader(steps: _steps, currentStep: _step),
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
              color: AppColors.onAccent,
              size: AppSpacing.iconSm,
            )
          : Text(
              '${index + 1}',
              style: AppTextStyles.micro.copyWith(
                color: active ? AppColors.onAccent : AppColors.text3,
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
