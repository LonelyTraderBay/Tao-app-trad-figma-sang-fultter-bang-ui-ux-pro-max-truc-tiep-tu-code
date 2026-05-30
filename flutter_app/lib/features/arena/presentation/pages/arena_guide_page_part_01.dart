part of 'arena_guide_page.dart';

class _ArenaGuidePageState extends ConsumerState<ArenaGuidePage> {
  _GuideTab _tab = _GuideTab.guide;
  _GuideMode _mode = _GuideMode.create;
  int? _expandedTip;
  int? _expandedFaq;
  bool _showAllTips = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(arenaReadModelControllerProvider)
        .getArenaGuide();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-209 ArenaGuidePage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Hướng dẫn Arena',
              subtitle: 'Hướng dẫn - Open Arena',
              showBack: true,
              onBack: () => _close(context),
            ),
            _GuideTabs(active: _tab, onChanged: _setTab),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: ArenaGuidePage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    customGap: AppSpacing.x5,
                    children: _tabChildren(context, snapshot),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _tabChildren(BuildContext context, ArenaGuideSnapshot snapshot) {
    return switch (_tab) {
      _GuideTab.guide => [
        _GuideHero(snapshot: snapshot),
        _ModeSwitch(mode: _mode, onChanged: _setMode),
        _StepsTimeline(
          steps: _mode == _GuideMode.create
              ? snapshot.createSteps
              : snapshot.joinSteps,
        ),
        _StartCard(mode: _mode, onPressed: () => _openPrimary(context)),
        if (_mode == _GuideMode.create)
          _ExampleSection(examples: snapshot.examples),
        _ConceptSection(concepts: snapshot.keyConcepts),
      ],
      _GuideTab.tips => [
        _TipsHeader(total: snapshot.proTips.length),
        _ImpactLegend(),
        _TipsList(
          tips: _showAllTips
              ? snapshot.proTips
              : snapshot.proTips.take(5).toList(),
          expandedIndex: _expandedTip,
          onToggle: _toggleTip,
        ),
        if (!_showAllTips && snapshot.proTips.length > 5)
          _ShowMoreTipsButton(
            remaining: snapshot.proTips.length - 5,
            onPressed: () {
              HapticFeedback.selectionClick();
              setState(() => _showAllTips = true);
            },
          ),
        _ChecklistCard(items: snapshot.checklist),
        VitCtaButton(
          onPressed: () => context.go(AppRoutePaths.arenaStudio),
          leading: const Icon(Icons.auto_awesome, size: 16),
          child: const Text('Áp dụng ngay - Tạo Challenge'),
        ),
      ],
      _GuideTab.safety => [
        _SafetyHero(),
        _PointsOnlyBanner(),
        _SafetyTipList(items: snapshot.safetyTips),
        _SafetyCenterCard(
          onPressed: () => context.go(AppRoutePaths.arenaSafety),
        ),
      ],
      _GuideTab.faq => [
        _FaqHeader(total: snapshot.faqs.length),
        _FaqList(
          items: snapshot.faqs,
          expandedIndex: _expandedFaq,
          onToggle: _toggleFaq,
        ),
        _SupportCard(onPressed: () => context.go('/support')),
      ],
    };
  }

  void _setTab(_GuideTab tab) {
    HapticFeedback.selectionClick();
    setState(() => _tab = tab);
  }

  void _setMode(_GuideMode mode) {
    HapticFeedback.selectionClick();
    setState(() => _mode = mode);
  }

  void _toggleTip(int index) {
    HapticFeedback.selectionClick();
    setState(() => _expandedTip = _expandedTip == index ? null : index);
  }

  void _toggleFaq(int index) {
    HapticFeedback.selectionClick();
    setState(() => _expandedFaq = _expandedFaq == index ? null : index);
  }

  void _openPrimary(BuildContext context) {
    HapticFeedback.mediumImpact();
    context.go(
      _mode == _GuideMode.create
          ? AppRoutePaths.arenaStudio
          : AppRoutePaths.arena,
    );
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

class _GuideTabs extends StatelessWidget {
  const _GuideTabs({required this.active, required this.onChanged});

  final _GuideTab active;
  final ValueChanged<_GuideTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
        child: VitTabBar(
          variant: VitTabBarVariant.underline,
          activeKey: active.name,
          onChanged: (key) =>
              onChanged(_GuideTab.values.firstWhere((tab) => tab.name == key)),
          tabs: [
            VitTabItem(
              key: _GuideTab.guide.name,
              label: 'Hướng dẫn',
              icon: Icons.menu_book_outlined,
            ),
            VitTabItem(
              key: _GuideTab.tips.name,
              label: 'Mẹo hay',
              icon: Icons.lightbulb_outline,
            ),
            VitTabItem(
              key: _GuideTab.safety.name,
              label: 'An toàn',
              icon: Icons.shield_outlined,
            ),
            VitTabItem(
              key: _GuideTab.faq.name,
              label: 'FAQ',
              icon: Icons.help_outline,
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideHero extends StatelessWidget {
  const _GuideHero({required this.snapshot});

  final ArenaGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: AppModuleAccents.arena,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.menu_book_outlined,
                color: AppModuleAccents.arena,
                size: 17,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'HƯỚNG DẪN NHANH',
                style: AppTextStyles.micro.copyWith(
                  color: AppModuleAccents.arena,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            snapshot.heroTitle,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            snapshot.heroSubtitle,
            style: AppTextStyles.body.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch({required this.mode, required this.onChanged});

  final _GuideMode mode;
  final ValueChanged<_GuideMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x1),
      child: Row(
        children: [
          Expanded(
            child: _ModeButton(
              key: ArenaGuidePage.modeCreateKey,
              label: 'Tạo Challenge',
              icon: Icons.auto_awesome,
              active: mode == _GuideMode.create,
              onPressed: () => onChanged(_GuideMode.create),
            ),
          ),
          Expanded(
            child: _ModeButton(
              key: ArenaGuidePage.modeJoinKey,
              label: 'Tham gia',
              icon: Icons.play_arrow_outlined,
              active: mode == _GuideMode.join,
              onPressed: () => onChanged(_GuideMode.join),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    super.key,
    required this.label,
    required this.icon,
    required this.active,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? AppColors.primary : AppColors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadii.inputRadius,
        child: SizedBox(
          height: AppSpacing.ctaHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: active ? AppColors.onAccent : AppColors.text3,
              ),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? AppColors.onAccent : AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepsTimeline extends StatelessWidget {
  const _StepsTimeline({required this.steps});

  final List<ArenaGuideStepDraft> steps;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 18,
          top: 26,
          bottom: 26,
          child: Container(width: 2, color: AppColors.divider),
        ),
        Column(
          children: [
            for (var index = 0; index < steps.length; index++)
              Padding(
                padding: EdgeInsets.only(
                  bottom: index == steps.length - 1 ? 0 : AppSpacing.x3,
                ),
                child: _StepRow(step: steps[index]),
              ),
          ],
        ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step});

  final ArenaGuideStepDraft step;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(step.tone);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .12),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(_iconFor(step.iconKey), color: color, size: 17),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x1,
                  children: [
                    _SmallBadge(label: 'Bước ${step.step}', color: color),
                    Text(
                      step.title,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  step.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                _TipPill(text: step.tip, color: color),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StartCard extends StatelessWidget {
  const _StartCard({required this.mode, required this.onPressed});

  final _GuideMode mode;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final creating = mode == _GuideMode.create;
    return VitCard(
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary12,
                  borderRadius: AppRadii.mdRadius,
                ),
                child: const Icon(
                  Icons.bolt_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sẵn sàng bắt đầu!',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      creating
                          ? 'Tạo challenge đầu tiên của bạn'
                          : 'Khám phá challenge đang mở',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCtaButton(
            key: ArenaGuidePage.ctaKey,
            onPressed: onPressed,
            child: Text(creating ? 'Tạo challenge ngay' : 'Khám phá challenge'),
          ),
        ],
      ),
    );
  }
}
