part of 'onboarding_flow.dart';

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  OnboardingStepDraft _step = OnboardingStepDraft.welcome;
  int _moduleIndex = 0;
  String? _expandedBoundaryId;
  final Set<OnboardingUserGoalDraft> _selectedGoals = {};

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(onboardingControllerProvider).getFlow();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-397 OnboardingFlow',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: _buildHeader(snapshot),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildBody(snapshot)),
              _buildFooter(snapshot),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(OnboardingSnapshot snapshot) {
    if (_step == OnboardingStepDraft.complete) return const SizedBox.shrink();

    if (_step == OnboardingStepDraft.welcome) {
      return VitHeader(
        variant: VitHeaderVariant.custom,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: AppSpacing.onboardingHeaderWelcomePadding,
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                key: OnboardingFlow.skipButtonKey,
                onPressed: () => _skip(snapshot),
                child: Text(
                  snapshot.welcome.skipLabel,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return VitHeader(
      variant: VitHeaderVariant.custom,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: AppSpacing.onboardingHeaderProgressPadding,
          child: _ProgressHeader(
            currentIndex: snapshot.steps.indexOf(_step),
            total: snapshot.steps.length,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(OnboardingSnapshot snapshot) {
    final content = switch (_step) {
      OnboardingStepDraft.welcome => _WelcomeStep(
        key: OnboardingFlow.welcomeKey,
        welcome: snapshot.welcome,
      ),
      OnboardingStepDraft.modules => _ModulesStep(
        key: OnboardingFlow.modulesKey,
        modules: snapshot.modules,
        currentIndex: _moduleIndex,
        onSelect: (index) {
          HapticFeedback.selectionClick();
          setState(() => _moduleIndex = index);
        },
      ),
      OnboardingStepDraft.boundaries => _BoundariesStep(
        key: OnboardingFlow.boundariesKey,
        boundaries: snapshot.boundaries,
        separationRules: snapshot.separationRules,
        expandedBoundaryId: _expandedBoundaryId,
        onToggle: (id) {
          HapticFeedback.selectionClick();
          setState(() {
            _expandedBoundaryId = _expandedBoundaryId == id ? null : id;
          });
        },
      ),
      OnboardingStepDraft.trust => _TrustStep(
        key: OnboardingFlow.trustKey,
        pillars: snapshot.trustPillars,
        commitments: snapshot.commitments,
      ),
      OnboardingStepDraft.goals => _GoalsStep(
        key: OnboardingFlow.goalsKey,
        goals: snapshot.goals,
        selectedGoals: _selectedGoals,
        onToggle: (goal) {
          HapticFeedback.selectionClick();
          setState(() {
            if (_selectedGoals.contains(goal)) {
              _selectedGoals.remove(goal);
            } else {
              _selectedGoals.add(goal);
            }
          });
        },
      ),
      OnboardingStepDraft.complete => _CompleteStep(
        key: OnboardingFlow.completeKey,
        selectedGoals: _selectedGoals.toList(growable: false),
        recommendations: snapshot.recommendations,
        onOpenRoute: _openRoute,
      ),
    };

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: content,
    );
  }

  Widget _buildFooter(OnboardingSnapshot snapshot) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    return Padding(
      padding: AppSpacing.onboardingFooterPadding(bottomPadding),
      child: switch (_step) {
        OnboardingStepDraft.welcome => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VitCtaButton(
              key: OnboardingFlow.startButtonKey,
              onPressed: () => _advance(snapshot),
              child: Text(snapshot.welcome.ctaLabel),
            ),
            const SizedBox(height: AppSpacing.x3),
            Text(
              snapshot.welcome.helperText,
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
        OnboardingStepDraft.complete => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VitCtaButton(
              key: OnboardingFlow.nextButtonKey,
              onPressed: () => _finishWithPrimary(snapshot),
              trailing: const Icon(Icons.arrow_forward_rounded),
              child: const Text('Bắt đầu sử dụng'),
            ),
            TextButton(
              key: OnboardingFlow.homeButtonKey,
              onPressed: () => _openRoute(snapshot.homeRoute),
              child: Text(
                'Về trang chủ',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ),
        _ => Row(
          children: [
            _BackControl(onPressed: _goBack),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitCtaButton(
                key: OnboardingFlow.nextButtonKey,
                onPressed: () => _advance(snapshot),
                trailing:
                    _step == OnboardingStepDraft.modules &&
                        _moduleIndex < snapshot.modules.length - 1
                    ? const Icon(Icons.chevron_right_rounded)
                    : null,
                child: Text(_nextLabel(snapshot)),
              ),
            ),
          ],
        ),
      },
    );
  }

  String _nextLabel(OnboardingSnapshot snapshot) {
    if (_step == OnboardingStepDraft.modules) {
      return _moduleIndex < snapshot.modules.length - 1
          ? 'Tiếp theo'
          : 'Đã hiểu';
    }
    if (_step == OnboardingStepDraft.boundaries) return 'Đã hiểu';
    if (_step == OnboardingStepDraft.goals) {
      return _selectedGoals.isEmpty ? 'Bỏ qua' : 'Hoàn tất';
    }
    return 'Tiếp theo';
  }

  void _advance(OnboardingSnapshot snapshot) {
    HapticFeedback.selectionClick();
    if (_step == OnboardingStepDraft.modules &&
        _moduleIndex < snapshot.modules.length - 1) {
      setState(() => _moduleIndex += 1);
      return;
    }

    final currentIndex = snapshot.steps.indexOf(_step);
    if (currentIndex < snapshot.steps.length - 1) {
      setState(() => _step = snapshot.steps[currentIndex + 1]);
    }
  }

  void _goBack() {
    HapticFeedback.selectionClick();
    final snapshot = ref.read(onboardingControllerProvider).getFlow();
    final currentIndex = snapshot.steps.indexOf(_step);
    if (currentIndex > 0) {
      setState(() => _step = snapshot.steps[currentIndex - 1]);
    }
  }

  void _skip(OnboardingSnapshot snapshot) {
    HapticFeedback.selectionClick();
    context.go(snapshot.homeRoute);
  }

  void _finishWithPrimary(OnboardingSnapshot snapshot) {
    final selected = _selectedGoals.toList(growable: false);
    final recommendation = selected.isEmpty
        ? null
        : snapshot.recommendations[selected.first];
    _openRoute(recommendation?.route ?? snapshot.homeRoute);
  }

  void _openRoute(String route) {
    HapticFeedback.selectionClick();
    context.go(route);
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({super.key, required this.welcome});

  final OnboardingWelcomeDraft welcome;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.defaultPadding,
      gap: VitContentGap.defaultGap,
      children: [
        const SizedBox(height: AppSpacing.x7),
        const _HeroIcon(icon: Icons.auto_awesome_rounded),
        Column(
          children: [
            Text(
              welcome.title,
              textAlign: TextAlign.center,
              style: AppTextStyles.pageTitle,
            ),
            const SizedBox(height: AppSpacing.x3),
            Text(
              welcome.subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.base.copyWith(color: AppColors.text2),
            ),
          ],
        ),
        Column(
          children: [
            for (final feature in welcome.features) ...[
              _FeatureRow(feature: feature),
              if (feature != welcome.features.last)
                const SizedBox(height: AppSpacing.x4),
            ],
          ],
        ),
      ],
    );
  }
}

class _ModulesStep extends StatelessWidget {
  const _ModulesStep({
    super.key,
    required this.modules,
    required this.currentIndex,
    required this.onSelect,
  });

  final List<OnboardingModuleDraft> modules;
  final int currentIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final module = modules[currentIndex];
    final accent = _accentForId(module.id);

    return VitPageContent(
      padding: VitContentPadding.defaultPadding,
      gap: VitContentGap.defaultGap,
      children: [
        _StepHeading(
          title: 'Khám phá 5 modules',
          subtitle: 'Mỗi module phục vụ một nhu cầu khác nhau',
        ),
        const SizedBox(height: AppSpacing.x5),
        _HeroIcon(icon: _iconForId(module.id), color: accent),
        Column(
          children: [
            Text(
              module.name,
              textAlign: TextAlign.center,
              style: AppTextStyles.sectionTitle.copyWith(color: accent),
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              module.description,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ],
        ),
        VitCard(
          padding: AppSpacing.onboardingCardPadding,
          radius: VitCardRadius.lg,
          child: Column(
            children: [
              for (final feature in module.features) ...[
                _BulletRow(text: feature, color: accent),
                if (feature != module.features.last)
                  const SizedBox(height: AppSpacing.x3),
              ],
            ],
          ),
        ),
        VitCarouselDots(
          itemCount: modules.length,
          activeIndex: currentIndex,
          activeColor: accent,
          dotKeyBuilder: (index) =>
              OnboardingFlow.moduleDotKey(modules[index].id),
          onDotTap: onSelect,
        ),
      ],
    );
  }
}

class _BoundariesStep extends StatelessWidget {
  const _BoundariesStep({
    super.key,
    required this.boundaries,
    required this.separationRules,
    required this.expandedBoundaryId,
    required this.onToggle,
  });

  final List<OnboardingBoundaryDraft> boundaries;
  final List<String> separationRules;
  final String? expandedBoundaryId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.defaultPadding,
      gap: VitContentGap.defaultGap,
      children: [
        _StepHeading(
          title: 'Ranh giới rõ ràng',
          subtitle: 'Hiểu sự khác biệt giữa các module để sử dụng an toàn',
        ),
        for (final boundary in boundaries)
          _BoundaryCard(
            boundary: boundary,
            expanded: expandedBoundaryId == boundary.id,
            onTap: () => onToggle(boundary.id),
          ),
        VitCard(
          padding: AppSpacing.onboardingCardPadding,
          radius: VitCardRadius.md,
          borderColor: AppColors.warningBorder,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warningText,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Quy tắc tách biệt',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.warningText,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x3),
              for (final rule in separationRules) ...[
                _BulletRow(text: rule, color: AppColors.warningText),
                if (rule != separationRules.last)
                  const SizedBox(height: AppSpacing.x2),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TrustStep extends StatelessWidget {
  const _TrustStep({
    super.key,
    required this.pillars,
    required this.commitments,
  });

  final List<OnboardingTrustDraft> pillars;
  final List<String> commitments;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.defaultPadding,
      gap: VitContentGap.defaultGap,
      children: [
        _StepHeading(
          title: 'An toàn là ưu tiên số 1',
          subtitle: 'Nền tảng được xây dựng với nguyên tắc Trust-first',
        ),
        for (final pillar in pillars) _TrustCard(pillar: pillar),
        VitCard(
          padding: AppSpacing.onboardingCardPadding,
          radius: VitCardRadius.md,
          borderColor: AppColors.buy20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Cam kết của chúng tôi',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
              const SizedBox(height: AppSpacing.x3),
              for (final item in commitments) ...[
                _BulletRow(
                  text: item,
                  color: AppColors.buy,
                  icon: Icons.check_circle_outline_rounded,
                ),
                if (item != commitments.last)
                  const SizedBox(height: AppSpacing.x2),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
