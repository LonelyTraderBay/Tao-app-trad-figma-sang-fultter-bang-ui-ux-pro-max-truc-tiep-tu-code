part of 'arena_prediction_bridge_foundation_page.dart';

class _ArenaPredictionBridgeFoundationPageState
    extends ConsumerState<ArenaPredictionBridgeFoundationPage> {
  _BridgeSection _activeSection = _BridgeSection.principles;
  String? _selectedTopicId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(arenaReadModelControllerProvider)
        .getArenaPredictionBridge();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-207 ArenaPredictionBridgeFoundationPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Bridge Foundation',
            subtitle: 'Kết nối · Prediction - Arena',
            showBack: true,
            onBack: () => _close(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: ArenaPredictionBridgeFoundationPage.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: AppSpacing.arenaBottomScrollPadding(bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.compact,
                      customGap: AppSpacing.x5,
                      children: [
                        const _BridgeHero(),
                        _SectionTabs(
                          active: _activeSection,
                          onChanged: (section) {
                            HapticFeedback.selectionClick();
                            setState(() => _activeSection = section);
                          },
                        ),
                        _ActiveSection(
                          section: _activeSection,
                          snapshot: snapshot,
                          selectedTopicId: _selectedTopicId,
                          onTopicSelected: (id) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _selectedTopicId = _selectedTopicId == id
                                  ? null
                                  : id;
                            });
                          },
                          onPredictionTap: () =>
                              _go(context, AppRoutePaths.profilePredictions),
                          onArenaTap: () =>
                              _go(context, AppRoutePaths.profileArena),
                        ),
                        _DisclosureFooter(text: snapshot.footerDisclosure),
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

  void _go(BuildContext context, String route) {
    HapticFeedback.selectionClick();
    context.go(route);
  }

  void _close(BuildContext context) {
    HapticFeedback.selectionClick();
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }
}

class _BridgeHero extends StatelessWidget {
  const _BridgeHero();

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: AppColors.primary,
      padding: AppSpacing.arenaPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.link_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '09A - Arena × Predictions Bridge Foundation',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.arenaBridgeHeroLineHeight,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Nền tảng kết nối an toàn giữa Open Arena và Prediction Markets. Khóa boundary trước khi nối flow.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: AppSpacing.arenaBridgeBodyLineHeight,
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

class _SectionTabs extends StatelessWidget {
  const _SectionTabs({required this.active, required this.onChanged});

  final _BridgeSection active;
  final ValueChanged<_BridgeSection> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: ArenaPredictionBridgeFoundationPage.tabsKey,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (final config in _sectionConfigs) ...[
            _BridgeTabPill(
              config: config,
              active: config.section == active,
              onTap: () => onChanged(config.section),
            ),
            if (config != _sectionConfigs.last)
              const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _BridgeTabPill extends StatelessWidget {
  const _BridgeTabPill({
    required this.config,
    required this.active,
    required this.onTap,
  });

  final _SectionConfig config;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        key: ArenaPredictionBridgeFoundationPage.tabKey(config.id),
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: SizedBox(
          height: AppSpacing.arenaBridgeTabHeight,
          child: Material(
            color: active
                ? AppColors.primary.withValues(alpha: .14)
                : AppColors.surface2,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: active
                    ? AppColors.primary.withValues(alpha: .55)
                    : AppColors.cardBorder,
                width: active ? 1.5 : 1,
              ),
              borderRadius: AppRadii.inputRadius,
            ),
            child: Padding(
              padding: AppSpacing.arenaHorizontalPaddingX4,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    config.icon,
                    color: active ? AppColors.primary : AppColors.text2,
                    size: AppSpacing.arenaBridgeChipIcon,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    config.label,
                    style: AppTextStyles.micro.copyWith(
                      color: active ? AppColors.primary : AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiveSection extends StatelessWidget {
  const _ActiveSection({
    required this.section,
    required this.snapshot,
    required this.selectedTopicId,
    required this.onTopicSelected,
    required this.onPredictionTap,
    required this.onArenaTap,
  });

  final _BridgeSection section;
  final ArenaPredictionBridgeSnapshot snapshot;
  final String? selectedTopicId;
  final ValueChanged<String> onTopicSelected;
  final VoidCallback onPredictionTap;
  final VoidCallback onArenaTap;

  @override
  Widget build(BuildContext context) {
    return switch (section) {
      _BridgeSection.principles => _PrinciplesSection(snapshot: snapshot),
      _BridgeSection.topics => _TopicsSection(
        snapshot: snapshot,
        selectedTopicId: selectedTopicId,
        onTopicSelected: onTopicSelected,
      ),
      _BridgeSection.boundary => _BoundarySection(snapshot: snapshot),
      _BridgeSection.bridge => _BridgeComponentsSection(
        snapshot: snapshot,
        onPredictionTap: onPredictionTap,
        onArenaTap: onArenaTap,
      ),
      _BridgeSection.examples => _ExamplesSection(snapshot: snapshot),
    };
  }
}

class _PrinciplesSection extends StatelessWidget {
  const _PrinciplesSection({required this.snapshot});

  final ArenaPredictionBridgeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: '1 - Cross-Module Principles',
          accentColor: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          '6 nguyên tắc bắt buộc khi kết nối Arena - Prediction Markets. Vi phạm = reject trong code review.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: AppSpacing.arenaBridgeIntroLineHeight,
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        for (final principle in snapshot.principles) ...[
          _PrincipleCard(principle: principle),
          if (principle != snapshot.principles.last)
            const SizedBox(height: AppSpacing.x4),
        ],
        const SizedBox(height: AppSpacing.x5),
        const VitModuleSectionHeader(
          title: 'Allowed vs Not Allowed',
          accentColor: AppColors.buy,
        ),
        const SizedBox(height: AppSpacing.x4),
        _RuleBoard(
          title: 'Allowed',
          icon: Icons.check_rounded,
          color: AppColors.buy,
          items: snapshot.allowedItems,
        ),
        const SizedBox(height: AppSpacing.x4),
        _RuleBoard(
          title: 'Not Allowed',
          icon: Icons.close_rounded,
          color: AppColors.sell,
          items: snapshot.notAllowedItems,
        ),
      ],
    );
  }
}

class _PrincipleCard extends StatelessWidget {
  const _PrincipleCard({required this.principle});

  final ArenaBridgePrincipleDraft principle;

  @override
  Widget build(BuildContext context) {
    final tone = _toneColor(principle.tone);
    return VitCard(
      constraints: const BoxConstraints(
        minHeight: AppSpacing.arenaBridgePrincipleMinHeight,
      ),
      padding: AppSpacing.arenaPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ToneIcon(tone: principle.tone),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: AppSpacing.arenaBridgePrincipleNumberPadding,
                      child: Text(
                        '#${principle.number}',
                        style: AppTextStyles.micro.copyWith(
                          color: tone,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        principle.title,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          height: AppSpacing.arenaBridgeTitleLineHeight,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  principle.description,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: AppSpacing.arenaBridgeBodyLineHeight,
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

class _RuleBoard extends StatelessWidget {
  const _RuleBoard({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<ArenaBridgeRuleDraft> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: color.withValues(alpha: .25),
      padding: AppSpacing.arenaPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: AppSpacing.arenaBridgeChipIcon),
              const SizedBox(width: AppSpacing.x2),
              Text(
                title,
                style: AppTextStyles.body.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final item in items) ...[
            _RuleRow(item: item, color: color),
            if (item != items.last) const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.item, required this.color});

  final ArenaBridgeRuleDraft item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          item.allowed ? Icons.check_rounded : Icons.close_rounded,
          color: color,
          size: AppSpacing.arenaBridgeMicroIcon,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: AppSpacing.arenaBridgeMetricLineHeight,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                item.description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: AppSpacing.arenaBridgeBodyLineHeight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
