part of 'client_categorization_page.dart';

class _ClientCategorizationPageState
    extends ConsumerState<ClientCategorizationPage> {
  String? _tab;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getClientCategorization();
    _tab ??= snapshot.defaultTab;
    final current = snapshot.categories.firstWhere(
      (item) => item.id == snapshot.currentCategoryId,
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 118
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-099 ClientCategorizationPage',
      child: Material(
        color: _clientBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Client Categorization',
            subtitle: 'MiFID II Classification',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: ClientCategorizationPage.contentKey,
                  padding: AppSpacing.tradeBotScrollPaddingWithBottom(
                    bottomInset,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: AppSpacing.contentPad,
                    children: [
                      _CurrentCategoryCard(category: current),
                      const _InfoNotice(),
                      _Tabs(
                        activeId: _tab!,
                        onChanged: (id) => setState(() => _tab = id),
                      ),
                      if (_tab == 'overview')
                        _OverviewTab(
                          categories: snapshot.categories,
                          currentCategoryId: snapshot.currentCategoryId,
                        )
                      else if (_tab == 'protections')
                        _ProtectionsTab(categories: snapshot.categories)
                      else if (_tab == 'requirements')
                        _RequirementsTab(categories: snapshot.categories)
                      else
                        _HistoryTab(
                          categories: snapshot.categories,
                          history: snapshot.history,
                        ),
                      const VitPageSection(
                        customGap: 0,
                        children: [_QuickLinks()],
                      ),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        padding: AppSpacing.tradeBotInnerPanelPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Client classification review',
                              message:
                                  'Current category, protection changes, eligibility evidence, disclosure links and compliance next step are reviewed before status changes.',
                              contractId: 'client-categorization-review',
                            ),
                            SizedBox(height: AppSpacing.tradeBotSmallGap),
                            VitStatusPill(
                              label: 'Compliance gated',
                              status: VitStatusPillStatus.info,
                              size: VitStatusPillSize.sm,
                            ),
                          ],
                        ),
                      ),
                    ],
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

class ClientOptUpRequestPage extends ConsumerStatefulWidget {
  const ClientOptUpRequestPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc099_client_opt_up_content');
  static const criteriaKey = Key('sc099_client_opt_up_criteria');
  static const waiverKey = Key('sc099_client_opt_up_waiver');
  static const submitKey = Key('sc099_client_opt_up_submit');
  static const successKey = Key('sc099_client_opt_up_success');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ClientOptUpRequestPage> createState() =>
      _ClientOptUpRequestPageState();
}

class _ClientOptUpRequestPageState
    extends ConsumerState<ClientOptUpRequestPage> {
  bool _criteriaConfirmed = false;
  bool _waiverAcknowledged = false;
  bool _submitted = false;

  bool get _canSubmit => _criteriaConfirmed && _waiverAcknowledged;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getClientCategorization();
    final professional = snapshot.categories.firstWhere(
      (item) => item.id == 'professional',
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 118
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-099 ClientOptUpRequestPage',
      child: Material(
        color: _clientBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Client Opt-Up Request',
            subtitle: 'MiFID II Classification',
            showBack: true,
            onBack: () =>
                context.go(AppRoutePaths.tradeCopyClientCategorization),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: ClientOptUpRequestPage.contentKey,
                  padding: AppSpacing.tradeBotScrollPaddingWithBottom(
                    bottomInset,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: AppSpacing.contentPad,
                    children: [
                      if (_submitted) ...[
                        VitCard(
                          key: ClientOptUpRequestPage.successKey,
                          padding: AppSpacing.tradeBotCardPadding,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                color: _clientGreen,
                                size: 24,
                              ),
                              const SizedBox(width: AppSpacing.tradeBotCardIconGap),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Review request saved',
                                      style: AppTextStyles.base.copyWith(
                                        color: AppColors.text1,
                                        fontWeight: AppTextStyles.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: AppSpacing.tradeBotSmallGap,
                                    ),
                                    Text(
                                      'Compliance review is required before any categorization change takes effect.',
                                      style: AppTextStyles.micro.copyWith(
                                        color: AppColors.text3,
                                        height: AppSpacing.tradeBotLineHeightBody,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      VitCard(
                        padding: AppSpacing.tradeBotCardPadding,
                        child: VitPageSection(
                          label: 'Professional Status Criteria',
                          customGap: AppSpacing.tradeBotRowGap,
                          children: [
                            for (final requirement in professional.requirements)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.track_changes_outlined,
                                    color: _clientPrimary,
                                    size: 14,
                                  ),
                                  const SizedBox(
                                    width: AppSpacing.tradeBotSmallGap,
                                  ),
                                  Expanded(
                                    child: Text(
                                      requirement,
                                      style: AppTextStyles.micro.copyWith(
                                        color: AppColors.text2,
                                        height: AppSpacing.tradeBotLineHeightBody,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      VitPageSection(
                        customGap: AppSpacing.tradeBotRowGap,
                        children: [
                          _OptUpChecklistTile(
                            key: ClientOptUpRequestPage.criteriaKey,
                            value: _criteriaConfirmed,
                            title: 'I meet the professional client criteria',
                            subtitle:
                                'Evidence must be reviewed before status can change.',
                            onChanged: (value) =>
                                setState(() => _criteriaConfirmed = value),
                          ),
                          _OptUpChecklistTile(
                            key: ClientOptUpRequestPage.waiverKey,
                            value: _waiverAcknowledged,
                            title: 'I understand protection changes',
                            subtitle:
                                'Opting up can reduce retail investor protections.',
                            onChanged: (value) =>
                                setState(() => _waiverAcknowledged = value),
                          ),
                        ],
                      ),
                      VitCtaButton(
                        key: ClientOptUpRequestPage.submitKey,
                        onPressed: _canSubmit
                            ? () => setState(() => _submitted = true)
                            : null,
                        height: AppSpacing.searchBarCompactHeight,
                        child: const Text('Submit for Review'),
                      ),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        padding: AppSpacing.tradeBotInnerPanelPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Opt-up request review',
                              message:
                                  'Criteria acknowledgement, protection waiver, compliance receipt and delayed-effect next step are reviewed before any category change.',
                              contractId: 'client-opt-up-review',
                            ),
                            SizedBox(height: AppSpacing.tradeBotSmallGap),
                            VitStatusPill(
                              label: 'No instant status change',
                              status: VitStatusPillStatus.warning,
                              size: VitStatusPillSize.sm,
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _OptUpChecklistTile extends StatelessWidget {
  const _OptUpChecklistTile({
    super.key,
    required this.value,
    required this.title,
    required this.subtitle,
    required this.onChanged,
  });

  final bool value;
  final String title;
  final String subtitle;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.zeroInsets,
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: _clientPrimary,
        title: Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ),
    );
  }
}

class _CurrentCategoryCard extends StatelessWidget {
  const _CurrentCategoryCard({required this.category});

  final TradeClientCategoryInfo category;

  @override
  Widget build(BuildContext context) {
    final style = _categoryStyle(category.id);
    return VitCard(
      padding: AppSpacing.tradeBotCardPadding,
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        customGap: AppSpacing.contentPad,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CategoryIcon(
                style: style,
                size: AppSpacing.tradeBotClientCategoryHeroIcon,
                iconSize: AppSpacing.tradeBotClientCategoryHeroIconGlyph,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            category.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.base.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                              height: AppSpacing.tradeBotLineHeightTight,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.tradeBotDisclosureGap),
                        _CurrentPill(color: style.color),
                      ],
                    ),
                    Text(
                      category.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        height: AppSpacing.tradeBotLineHeightBody,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.tradeBotSmallGap),
              Icon(
                Icons.check_circle_outline,
                color: style.color,
                size: AppSpacing.tradeBotClientCurrentIcon,
              ),
            ],
          ),
          VitCard(
            variant: VitCardVariant.inner,
            padding: AppSpacing.tradeBotCompactCardPadding,
            child: Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  color: AppColors.text1,
                  size: AppSpacing.tradeBotMediumIcon,
                ),
                const SizedBox(width: AppSpacing.tradeBotRowGap),
                Expanded(
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: AppSpacing.tradeBotNarrowIconGap,
                    children: [
                      Text(
                        'Maximum Protection Active',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          height: AppSpacing.tradeBotLineHeightTight,
                        ),
                      ),
                      Text(
                        'You have full MiFID II retail investor protections',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontWeight: AppTextStyles.bold,
                          height: AppSpacing.tradeBotLineHeightTight,
                        ),
                      ),
                    ],
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

class _InfoNotice extends StatelessWidget {
  const _InfoNotice();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.tradeBotInnerPanelPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color: AppColors.text1,
            size: AppSpacing.tradeBotCheckboxIcon,
          ),
          const SizedBox(width: AppSpacing.tradeBotRowGap),
          Expanded(
            child: VitPageContent(
              padding: VitContentPadding.none,
              fullBleed: true,
              customGap: AppSpacing.tradeBotSmallGap,
              children: [
                Text(
                  'MiFID II Categorization',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.tradeBotLineHeightTight,
                  ),
                ),
                Text(
                  'Your client category determines the level of regulatory protection you receive. Retail clients have maximum protection.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.tradeBotLineHeightBody,
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

class _Tabs extends StatelessWidget {
  const _Tabs({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      ('overview', 'Overview'),
      ('protections', 'Protections'),
      ('requirements', 'Requirements'),
      ('history', 'History'),
    ];
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.tradeBotCompactPanelPadding,
      child: VitTabBar(
        tabs: [
          for (final tab in tabs)
            VitTabItem(
              key: tab.$1,
              label: tab.$2,
              widgetKey: ClientCategorizationPage.tabKey(tab.$1),
            ),
        ],
        activeKey: activeId,
        onChanged: onChanged,
        variant: VitTabBarVariant.segment,
      ),
    );
  }
}
