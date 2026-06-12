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
                  padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: 16,
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
                        padding: EdgeInsets.all(12),
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
                            SizedBox(height: 8),
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
                  padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: 16,
                    children: [
                      if (_submitted) ...[
                        VitCard(
                          key: ClientOptUpRequestPage.successKey,
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                color: _clientGreen,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
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
                                    const SizedBox(height: 8),
                                    Text(
                                      'Compliance review is required before any categorization change takes effect.',
                                      style: AppTextStyles.micro.copyWith(
                                        color: AppColors.text3,
                                        height: 1.35,
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
                        padding: const EdgeInsets.all(16),
                        child: VitPageSection(
                          label: 'Professional Status Criteria',
                          customGap: 10,
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
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      requirement,
                                      style: AppTextStyles.micro.copyWith(
                                        color: AppColors.text2,
                                        height: 1.35,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      VitPageSection(
                        customGap: 10,
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
                        height: 48,
                        child: const Text('Submit for Review'),
                      ),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        padding: EdgeInsets.all(12),
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
                            SizedBox(height: 8),
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
      padding: EdgeInsets.zero,
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
      padding: const EdgeInsets.all(16),
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        customGap: 16,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CategoryIcon(style: style, size: 56, iconSize: 28),
              const SizedBox(width: 13),
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
                              height: 1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 9),
                        _CurrentPill(color: style.color),
                      ],
                    ),
                    Text(
                      category.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.check_circle_outline, color: style.color, size: 21),
            ],
          ),
          VitCard(
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.fromLTRB(12, 11, 12, 10),
            child: Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  color: AppColors.text1,
                  size: 17,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: 6,
                    children: [
                      Text(
                        'Maximum Protection Active',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                      Text(
                        'You have full MiFID II retail investor protections',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
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
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.text1, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: VitPageContent(
              padding: VitContentPadding.none,
              fullBleed: true,
              customGap: 8,
              children: [
                Text(
                  'MiFID II Categorization',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                Text(
                  'Your client category determines the level of regulatory protection you receive. Retail clients have maximum protection.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                    height: 1.38,
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
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: Center(
                child: VitStatusPill(
                  key: ClientCategorizationPage.tabKey(tab.$1),
                  label: tab.$2,
                  status: activeId == tab.$1
                      ? VitStatusPillStatus.info
                      : VitStatusPillStatus.neutral,
                  size: VitStatusPillSize.md,
                  onTap: () => onChanged(tab.$1),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
