part of 'arena_home_page.dart';

class _ArenaHomePageState extends ConsumerState<ArenaHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _templatesAnchorKey = GlobalKey();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(arenaReadModelControllerProvider).getArenaHome();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? _arenaHomeVisualNavClearance
        : _arenaHomeNativeNavClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    final hasSearch = _query.trim().length >= 2;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-184 ArenaHomePage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitTopChrome(
            type: VitTopChromeType.rootModule,
            title: 'Open Arena',
            subtitle: 'Sân chơi cộng đồng',
            showBack: true,
            onBack: _close,
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
                    key: ArenaHomePage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsetsDirectional.only(
                      bottom: scrollEndPadding,
                    ),
                    child: VitPageContent(
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: [
                        _IntroBlock(
                          controller: _searchController,
                          query: _query,
                          pendingNotifications: snapshot.pendingNotifications,
                          onChanged: (value) => setState(() => _query = value),
                          onClear: () => setState(() => _query = ''),
                          onGuide: () => _go(AppRoutePaths.arenaGuide),
                          onRewards: () =>
                              _go('${AppRoutePaths.rewards}?tab=arena'),
                          onLeaderboard: () =>
                              _go(AppRoutePaths.arenaLeaderboard),
                          onMyArena: () => _go(AppRoutePaths.profileArena),
                        ),
                        if (hasSearch)
                          _SearchResults(
                            query: _query,
                            snapshot: snapshot,
                            onMode: (id) => _go(AppRoutePaths.arenaMode(id)),
                            onRoom: (id) =>
                                _go(AppRoutePaths.arenaChallenge(id)),
                            onCreator: (id) =>
                                _go(AppRoutePaths.arenaCreator(id)),
                          )
                        else ...[
                          _HeroCard(
                            onCreate: () => _go(AppRoutePaths.arenaStudio),
                            onExplore: _scrollToTemplates,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _TemplateSection(
                                anchorKey: _templatesAnchorKey,
                                templates: snapshot.templates,
                                onTap: (_) => _go(AppRoutePaths.arenaStudio),
                              ),
                              const SizedBox(height: AppSpacing.x2),
                              _FeaturedModesSection(
                                modes: snapshot.featuredModes,
                                onViewAll: () =>
                                    _go(AppRoutePaths.arenaLeaderboard),
                                onMode: (id) =>
                                    _go(AppRoutePaths.arenaMode(id)),
                              ),
                            ],
                          ),
                          _LiveRoomsSection(
                            rooms: snapshot.liveRooms,
                            onRoom: (id) =>
                                _go(AppRoutePaths.arenaChallenge(id)),
                          ),
                          _CreatorSpotlightSection(
                            creators: snapshot.creators,
                            onCreator: (id) =>
                                _go(AppRoutePaths.arenaCreator(id)),
                          ),
                          _PredictionBridge(
                            onTap: () => _go(AppRoutePaths.marketsPredictions),
                          ),
                          _VerifiedTeaser(
                            onTap: () => _go(AppRoutePaths.arenaVerified),
                          ),
                        ],
                        _ArenaFooter(
                          onRules: () => _go(AppRoutePaths.arenaSafety),
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

  void _go(String route) {
    HapticFeedback.selectionClick();
    context.go(route);
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.home);
  }

  void _scrollToTemplates() {
    final context = _templatesAnchorKey.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }
}

class _IntroBlock extends StatelessWidget {
  const _IntroBlock({
    required this.controller,
    required this.query,
    required this.pendingNotifications,
    required this.onChanged,
    required this.onClear,
    required this.onGuide,
    required this.onRewards,
    required this.onLeaderboard,
    required this.onMyArena,
  });

  final TextEditingController controller;
  final String query;
  final int pendingNotifications;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onGuide;
  final VoidCallback onRewards;
  final VoidCallback onLeaderboard;
  final VoidCallback onMyArena;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Tạo mode chơi, mở phòng và thách đấu bằng Arena Points',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text2,
                  height: _arenaHomeIntroLineHeight,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            const VitStatusPill(
              label: 'Points only',
              status: VitStatusPillStatus.orange,
              size: VitStatusPillSize.sm,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        VitSearchBar(
          key: ArenaHomePage.searchKey,
          controller: controller,
          placeholder: 'Tìm mode, creator hoặc challenge...',
          variant: VitSearchBarVariant.compact,
          onChanged: onChanged,
          onClear: onClear,
        ),
        const SizedBox(height: AppSpacing.x2),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Row(
            children: [
              _QuickChip(
                key: ArenaHomePage.quickGuideKey,
                icon: Icons.menu_book_outlined,
                label: 'Hướng dẫn',
                onTap: onGuide,
              ),
              _QuickChip(
                key: ArenaHomePage.quickRewardsKey,
                icon: Icons.card_giftcard_rounded,
                label: 'Kiếm Points',
                onTap: onRewards,
              ),
              _QuickChip(
                key: ArenaHomePage.quickLeaderboardKey,
                icon: Icons.emoji_events_outlined,
                label: 'Leaderboard',
                onTap: onLeaderboard,
              ),
              _QuickChip(
                key: ArenaHomePage.quickMyArenaKey,
                icon: Icons.star_border_rounded,
                label: 'Sân chơi của tôi',
                count: pendingNotifications,
                onTap: onMyArena,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.count = 0,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.arenaHomeQuickChipGapPadding,
      child: VitCard(
        onTap: onTap,
        variant: VitCardVariant.inner,
        radius: VitCardRadius.standard,
        height: VitDensity.compact.controlHeight,
        padding: AppSpacing.arenaPresetChipPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppColors.text2,
              size: AppSpacing.arenaHomeQuickChipIcon,
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
                height: _arenaHomeCountBadgeLineHeight,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: AppSpacing.x2),
              _MiniCountBadge(count: count),
            ],
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.onCreate, required this.onExplore});

  final VoidCallback onCreate;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: _arenaAccent,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Open Arena',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Tạo sân chơi',
            style: AppTextStyles.sectionTitle.copyWith(
              fontWeight: AppTextStyles.heavy,
              height: _arenaHomeHeroTitleLineHeight,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Row(
            children: [
              const VitStatusPill(
                label: 'Tự đặt luật · Mời bạn bè',
                icon: Icons.auto_awesome_rounded,
                status: VitStatusPillStatus.purple,
                size: VitStatusPillSize.sm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'room riêng',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: ArenaHomePage.createChallengeKey,
                  onPressed: onCreate,
                  density: VitDensity.compact,
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.x3,
                  ),
                  leading: const Icon(Icons.auto_awesome_rounded),
                  child: const Text('Tạo challenge'),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: VitCtaButton(
                  key: ArenaHomePage.exploreModeKey,
                  onPressed: onExplore,
                  variant: VitCtaButtonVariant.secondary,
                  density: VitDensity.compact,
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.x3,
                  ),
                  leading: const Icon(Icons.search_rounded),
                  child: const Text('Khám phá mode'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TemplateSection extends StatelessWidget {
  const _TemplateSection({
    required this.anchorKey,
    required this.templates,
    required this.onTap,
  });

  final Key anchorKey;
  final List<ArenaTemplateDraft> templates;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: anchorKey,
      label: 'Templates',
      accentColor: AppColors.accent,
      density: VitDensity.compact,
      children: [
        Text(
          'Chọn template để bắt đầu tạo challenge',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        GridView.builder(
          padding: EdgeInsetsDirectional.all(AppSpacing.zero),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: templates.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: AppSpacing.arenaHomeTemplateColumns,
            crossAxisSpacing: AppSpacing.x2,
            mainAxisSpacing: AppSpacing.x2,
            mainAxisExtent: AppSpacing.arenaHomeTemplateExtent,
          ),
          itemBuilder: (context, index) {
            final template = templates[index];
            final accent = _templateColor(template.kind);
            final tags = template.tags.take(2).join(' · ');
            return VitCard(
              key: ArenaHomePage.templateKey(template.id),
              onTap: () => onTap(template.id),
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _ActionIcon(
                        icon: _templateIcon(template.kind),
                        color: accent,
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: Text(
                          template.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: AppTextStyles.bold,
                            height: _arenaHomeTemplateTitleLineHeight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    template.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: _arenaHomeTemplateDescriptionLineHeight,
                    ),
                  ),
                  if (tags.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      tags,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: accent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
