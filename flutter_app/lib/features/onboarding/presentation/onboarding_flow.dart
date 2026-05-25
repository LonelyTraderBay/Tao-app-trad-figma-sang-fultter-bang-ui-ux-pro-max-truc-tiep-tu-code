import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/onboarding_repository.dart';

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  static const welcomeKey = Key('sc397_onboarding_welcome');
  static const modulesKey = Key('sc397_onboarding_modules');
  static const boundariesKey = Key('sc397_onboarding_boundaries');
  static const trustKey = Key('sc397_onboarding_trust');
  static const goalsKey = Key('sc397_onboarding_goals');
  static const completeKey = Key('sc397_onboarding_complete');
  static const startButtonKey = Key('sc397_onboarding_start');
  static const skipButtonKey = Key('sc397_onboarding_skip');
  static const nextButtonKey = Key('sc397_onboarding_next');
  static const backButtonKey = Key('sc397_onboarding_back');
  static const homeButtonKey = Key('sc397_onboarding_home');
  static Key featureKey(String id) => Key('sc397_feature_$id');
  static Key moduleDotKey(String id) => Key('sc397_module_dot_$id');
  static Key boundaryKey(String id) => Key('sc397_boundary_$id');
  static Key goalKey(OnboardingUserGoalDraft id) => Key('sc397_goal_$id');

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  OnboardingStepDraft _step = OnboardingStepDraft.welcome;
  int _moduleIndex = 0;
  String? _expandedBoundaryId;
  final Set<OnboardingUserGoalDraft> _selectedGoals = {};

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(onboardingRepositoryProvider).getFlow();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-397 OnboardingFlow',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            _buildHeader(snapshot),
            Expanded(child: _buildBody(snapshot)),
            _buildFooter(snapshot),
          ],
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
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentPad,
              AppSpacing.x3,
              AppSpacing.contentPad,
              AppSpacing.x2,
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                key: OnboardingFlow.skipButtonKey,
                onPressed: () => _skip(snapshot),
                child: Text(
                  snapshot.welcome.skipLabel,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 13,
                  ),
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
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.contentPad,
            AppSpacing.x4,
            AppSpacing.contentPad,
            AppSpacing.x3,
          ),
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
      padding: EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        AppSpacing.x5 + bottomPadding,
      ),
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
    final snapshot = ref.read(onboardingRepositoryProvider).getFlow();
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
      padding: VitContentPadding.relaxed,
      gap: VitContentGap.relaxed,
      children: [
        const SizedBox(height: AppSpacing.x7),
        const _HeroIcon(icon: Icons.auto_awesome_rounded),
        Column(
          children: [
            Text(
              welcome.title,
              textAlign: TextAlign.center,
              style: AppTextStyles.pageTitle.copyWith(fontSize: 28),
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
      padding: VitContentPadding.relaxed,
      gap: VitContentGap.relaxed,
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
          padding: const EdgeInsets.all(AppSpacing.x4),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < modules.length; i++) ...[
              _ModuleDot(
                key: OnboardingFlow.moduleDotKey(modules[i].id),
                active: i == currentIndex,
                color: accent,
                onTap: () => onSelect(i),
              ),
              if (i < modules.length - 1) const SizedBox(width: AppSpacing.x2),
            ],
          ],
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
      padding: VitContentPadding.relaxed,
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
          padding: const EdgeInsets.all(AppSpacing.x4),
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
      padding: VitContentPadding.relaxed,
      gap: VitContentGap.defaultGap,
      children: [
        _StepHeading(
          title: 'An toàn là ưu tiên số 1',
          subtitle: 'Nền tảng được xây dựng với nguyên tắc Trust-first',
        ),
        for (final pillar in pillars) _TrustCard(pillar: pillar),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
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

class _GoalsStep extends StatelessWidget {
  const _GoalsStep({
    super.key,
    required this.goals,
    required this.selectedGoals,
    required this.onToggle,
  });

  final List<OnboardingGoalDraft> goals;
  final Set<OnboardingUserGoalDraft> selectedGoals;
  final ValueChanged<OnboardingUserGoalDraft> onToggle;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.relaxed,
      gap: VitContentGap.defaultGap,
      children: [
        _StepHeading(
          title: 'Bạn muốn làm gì?',
          subtitle: 'Chọn một hoặc nhiều mục tiêu để cá nhân hóa trải nghiệm',
        ),
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.x3,
          crossAxisSpacing: AppSpacing.x3,
          childAspectRatio: 1.08,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            for (final goal in goals)
              _GoalTile(
                key: OnboardingFlow.goalKey(goal.id),
                goal: goal,
                selected: selectedGoals.contains(goal.id),
                onTap: () => onToggle(goal.id),
              ),
          ],
        ),
        Text(
          selectedGoals.isEmpty
              ? 'Bạn có thể bỏ qua bước này'
              : 'Đã chọn ${selectedGoals.length} mục tiêu',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _CompleteStep extends StatelessWidget {
  const _CompleteStep({
    super.key,
    required this.selectedGoals,
    required this.recommendations,
    required this.onOpenRoute,
  });

  final List<OnboardingUserGoalDraft> selectedGoals;
  final Map<OnboardingUserGoalDraft, OnboardingRecommendationDraft>
  recommendations;
  final ValueChanged<String> onOpenRoute;

  @override
  Widget build(BuildContext context) {
    final visibleRecommendations = selectedGoals
        .map((goal) => recommendations[goal])
        .whereType<OnboardingRecommendationDraft>()
        .take(3)
        .toList(growable: false);

    return VitPageContent(
      padding: VitContentPadding.relaxed,
      gap: VitContentGap.relaxed,
      children: [
        const SizedBox(height: AppSpacing.x5),
        const _HeroIcon(
          icon: Icons.check_circle_outline_rounded,
          success: true,
        ),
        Column(
          children: [
            Text(
              'Sẵn sàng!',
              textAlign: TextAlign.center,
              style: AppTextStyles.pageTitle.copyWith(fontSize: 28),
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              selectedGoals.isEmpty
                  ? 'Bạn đã sẵn sàng khám phá toàn bộ nền tảng'
                  : 'Trải nghiệm đã được cá nhân hóa theo mục tiêu của bạn',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ],
        ),
        if (visibleRecommendations.isNotEmpty) ...[
          VitPageSection(
            label: 'Đề xuất cho bạn',
            children: [
              for (final recommendation in visibleRecommendations)
                _RecommendationCard(
                  recommendation: recommendation,
                  onTap: () => onOpenRoute(recommendation.route),
                ),
            ],
          ),
        ],
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          radius: VitCardRadius.md,
          borderColor: AppColors.primary20,
          child: Text.rich(
            TextSpan(
              text:
                  'Bạn có thể thiết lập bảo mật nâng cao (2FA, biometrics) bất kỳ lúc nào trong ',
              children: [
                TextSpan(
                  text: 'Cài đặt bảo mật',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
                const TextSpan(text: '.'),
              ],
            ),
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.currentIndex, required this.total});

  final int currentIndex;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = (currentIndex + 1) / total;

    return Column(
      children: [
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: LinearProgressIndicator(
            minHeight: AppSpacing.x2,
            value: progress,
            color: AppColors.primary,
            backgroundColor: AppColors.divider,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Row(
          children: [
            Text(
              'Bước ${currentIndex + 1}/$total',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const Spacer(),
            Text(
              '${(progress * 100).round()}%',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepHeading extends StatelessWidget {
  const _StepHeading({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 24),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}

class _HeroIcon extends StatelessWidget {
  const _HeroIcon({
    required this.icon,
    this.color = AppColors.primary,
    this.success = false,
  });

  final IconData icon;
  final Color color;
  final bool success;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: AppSpacing.buttonHero,
        height: AppSpacing.buttonHero,
        decoration: BoxDecoration(
          color: success ? AppColors.buy : null,
          gradient: success ? null : AppGradients.navCenter,
          borderRadius: AppRadii.cardLargeRadius,
          border: Border.all(color: success ? AppColors.buy20 : color),
          boxShadow: [
            BoxShadow(
              color: success ? AppColors.buy20 : AppColors.primary30,
              blurRadius: AppSpacing.x5,
              offset: const Offset(0, AppSpacing.x3),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: AppSpacing.iconLg + AppSpacing.x2,
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.feature});

  final OnboardingFeatureDraft feature;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForId(feature.id);
    return Row(
      key: OnboardingFlow.featureKey(feature.id),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SmallIconBadge(
          icon: _iconForId(feature.id),
          color: accent,
          background: _backgroundForId(feature.id),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                feature.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
              Text(
                feature.description,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SmallIconBadge extends StatelessWidget {
  const _SmallIconBadge({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.buttonCompact + AppSpacing.x3,
      height: AppSpacing.buttonCompact + AppSpacing.x3,
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: AppSpacing.iconMd),
    );
  }
}

class _ModuleDot extends StatelessWidget {
  const _ModuleDot({
    super.key,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.xsRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: active ? AppSpacing.x5 : AppSpacing.x3,
        height: AppSpacing.x3,
        decoration: BoxDecoration(
          color: active ? color : AppColors.divider,
          borderRadius: AppRadii.xsRadius,
        ),
      ),
    );
  }
}

class _BoundaryCard extends StatelessWidget {
  const _BoundaryCard({
    required this.boundary,
    required this.expanded,
    required this.onTap,
  });

  final OnboardingBoundaryDraft boundary;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForId(boundary.id);

    return VitCard(
      key: OnboardingFlow.boundaryKey(boundary.id),
      padding: const EdgeInsets.all(AppSpacing.x4),
      radius: VitCardRadius.md,
      borderColor: expanded ? accent : AppColors.cardBorder,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _SmallIconBadge(
                icon: _iconForId(boundary.id),
                color: accent,
                background: _backgroundForId(boundary.id),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(boundary.title, style: AppTextStyles.baseMedium),
                    Text(
                      boundary.nature,
                      style: AppTextStyles.micro.copyWith(
                        color: accent,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            boundary.subtitle,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          if (expanded)
            Column(
              children: [
                for (final example in boundary.examples) ...[
                  _BulletRow(
                    text: example,
                    color: accent,
                    icon: Icons.check_rounded,
                  ),
                  if (example != boundary.examples.last)
                    const SizedBox(height: AppSpacing.x2),
                ],
              ],
            )
          else
            Text(
              'Chạm để xem chi tiết',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
        ],
      ),
    );
  }
}

class _TrustCard extends StatelessWidget {
  const _TrustCard({required this.pillar});

  final OnboardingTrustDraft pillar;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForId(pillar.id);

    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      radius: VitCardRadius.md,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SmallIconBadge(
            icon: _iconForId(pillar.id),
            color: accent,
            background: _backgroundForId(pillar.id),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pillar.title, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  pillar.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
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

class _GoalTile extends StatelessWidget {
  const _GoalTile({
    super.key,
    required this.goal,
    required this.selected,
    required this.onTap,
  });

  final OnboardingGoalDraft goal;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForGoal(goal.id);

    return VitCard(
      variant: selected ? VitCardVariant.inner : VitCardVariant.standard,
      padding: const EdgeInsets.all(AppSpacing.x3),
      borderColor: selected ? accent : AppColors.cardBorder,
      onTap: onTap,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SmallIconBadge(
                icon: _iconForGoal(goal.id),
                color: accent,
                background: _backgroundForGoal(goal.id),
              ),
              const SizedBox(height: AppSpacing.x3),
              Text(
                goal.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
              Text(
                goal.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              if (goal.disclosure != null) ...[
                const SizedBox(height: AppSpacing.x2),
                _DisclosurePill(text: goal.disclosure!, color: accent),
              ],
            ],
          ),
          if (selected)
            Positioned(
              top: 0,
              right: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(AppSpacing.x1),
                  child: Icon(
                    Icons.check_rounded,
                    size: AppSpacing.iconSm,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DisclosurePill extends StatelessWidget {
  const _DisclosurePill({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.warn10,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          text,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.medium,
            fontSize: 9,
          ),
        ),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.recommendation,
    required this.onTap,
  });

  final OnboardingRecommendationDraft recommendation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      radius: VitCardRadius.md,
      borderColor: AppColors.primary20,
      onTap: onTap,
      child: Row(
        children: [
          const _SmallIconBadge(
            icon: Icons.arrow_outward_rounded,
            color: AppColors.primary,
            background: AppColors.primary12,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recommendation.title, style: AppTextStyles.baseMedium),
                Text(
                  recommendation.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_rounded,
            size: AppSpacing.iconMd,
            color: AppColors.text3,
          ),
        ],
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({
    required this.text,
    required this.color,
    this.icon = Icons.circle,
  });

  final String text;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: icon == Icons.circle ? 7 : 14),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _BackControl extends StatelessWidget {
  const _BackControl({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: OnboardingFlow.backButtonKey,
      width: AppSpacing.ctaHeight,
      height: AppSpacing.ctaHeight,
      child: Material(
        color: AppColors.surface2,
        borderRadius: AppRadii.inputRadius,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppRadii.inputRadius,
          child: const Icon(
            Icons.chevron_left_rounded,
            color: AppColors.text2,
            size: AppSpacing.iconLg,
          ),
        ),
      ),
    );
  }
}

Color _accentForId(String id) {
  return switch (id) {
    'security' || 'wallet' || 'safety' => AppColors.buy,
    'smart' || 'prediction' || 'transparency' => AppColors.accent,
    'arena' || 'points' || 'no_dark_patterns' || 'p2p' => AppColors.warn,
    'value' || 'trading' => AppModuleAccents.trade,
    _ => AppColors.primary,
  };
}

Color _backgroundForId(String id) {
  return switch (id) {
    'security' || 'wallet' || 'safety' => AppColors.buy15,
    'smart' || 'prediction' || 'transparency' => AppColors.accent15,
    'arena' || 'points' || 'no_dark_patterns' || 'p2p' => AppColors.warn15,
    _ => AppColors.primary12,
  };
}

IconData _iconForId(String id) {
  return switch (id) {
    'security' || 'safety' => Icons.shield_outlined,
    'smart' => Icons.bolt_rounded,
    'wallet' => Icons.account_balance_wallet_outlined,
    'p2p' => Icons.groups_2_outlined,
    'prediction' => Icons.query_stats_rounded,
    'arena' || 'points' => Icons.emoji_events_outlined,
    'value' || 'trading' => Icons.trending_up_rounded,
    'transparency' => Icons.visibility_outlined,
    'no_dark_patterns' => Icons.report_problem_outlined,
    _ => Icons.lock_outline_rounded,
  };
}

Color _accentForGoal(OnboardingUserGoalDraft goal) {
  return switch (goal) {
    OnboardingUserGoalDraft.saveRegularly => AppColors.buy,
    OnboardingUserGoalDraft.predictEvents => AppColors.accent,
    OnboardingUserGoalDraft.arenaChallenges => AppModuleAccents.arena,
    OnboardingUserGoalDraft.p2pExchange => AppModuleAccents.p2p,
    _ => AppColors.primary,
  };
}

Color _backgroundForGoal(OnboardingUserGoalDraft goal) {
  return switch (goal) {
    OnboardingUserGoalDraft.saveRegularly => AppColors.buy15,
    OnboardingUserGoalDraft.predictEvents => AppColors.accent15,
    OnboardingUserGoalDraft.arenaChallenges ||
    OnboardingUserGoalDraft.p2pExchange => AppColors.warn15,
    _ => AppColors.primary12,
  };
}

IconData _iconForGoal(OnboardingUserGoalDraft goal) {
  return switch (goal) {
    OnboardingUserGoalDraft.tradeCrypto => Icons.trending_up_rounded,
    OnboardingUserGoalDraft.saveRegularly => Icons.repeat_rounded,
    OnboardingUserGoalDraft.p2pExchange => Icons.groups_2_outlined,
    OnboardingUserGoalDraft.predictEvents => Icons.query_stats_rounded,
    OnboardingUserGoalDraft.arenaChallenges => Icons.emoji_events_outlined,
    OnboardingUserGoalDraft.earnRewards => Icons.card_giftcard_rounded,
  };
}
