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
        child: Column(
          children: [
            VitHeader(
              title: 'Client Categorization',
              subtitle: 'MiFID II Classification',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: ClientCategorizationPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _CurrentCategoryCard(category: current),
                    const SizedBox(height: 30),
                    const _InfoNotice(),
                    const SizedBox(height: 32),
                    _Tabs(
                      activeId: _tab!,
                      onChanged: (id) => setState(() => _tab = id),
                    ),
                    const SizedBox(height: 25),
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
                    const SizedBox(height: 24),
                    const _QuickLinks(),
                  ],
                ),
              ),
            ),
          ],
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
        child: Column(
          children: [
            VitHeader(
              title: 'Client Opt-Up Request',
              subtitle: 'MiFID II Classification',
              showBack: true,
              onBack: () =>
                  context.go(AppRoutePaths.tradeCopyClientCategorization),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: ClientOptUpRequestPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_submitted) ...[
                      _Card(
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
                      const SizedBox(height: 18),
                    ],
                    _Card(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _SectionLabel('Professional Status Criteria'),
                          const SizedBox(height: 12),
                          for (final requirement
                              in professional.requirements) ...[
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
                            if (requirement != professional.requirements.last)
                              const SizedBox(height: 10),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _OptUpChecklistTile(
                      key: ClientOptUpRequestPage.criteriaKey,
                      value: _criteriaConfirmed,
                      title: 'I meet the professional client criteria',
                      subtitle:
                          'Evidence must be reviewed before status can change.',
                      onChanged: (value) =>
                          setState(() => _criteriaConfirmed = value),
                    ),
                    const SizedBox(height: 10),
                    _OptUpChecklistTile(
                      key: ClientOptUpRequestPage.waiverKey,
                      value: _waiverAcknowledged,
                      title: 'I understand protection changes',
                      subtitle:
                          'Opting up can reduce retail investor protections.',
                      onChanged: (value) =>
                          setState(() => _waiverAcknowledged = value),
                    ),
                    const SizedBox(height: 18),
                    FilledButton(
                      key: ClientOptUpRequestPage.submitKey,
                      onPressed: _canSubmit
                          ? () => setState(() => _submitted = true)
                          : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: _clientPrimary,
                        foregroundColor: AppColors.text1,
                        disabledBackgroundColor: AppColors.surface3,
                        disabledForegroundColor: AppColors.text3,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadii.inputRadius,
                        ),
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: const Text('Submit for Review'),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
    return _Card(
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
    return _Card(
      padding: const EdgeInsets.all(16),
      child: Column(
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
                    const SizedBox(height: 8),
                    Text(
                      category.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 12,
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
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 11, 12, 10),
            decoration: BoxDecoration(
              color: AppColors.transparent,
              borderRadius: AppRadii.mdRadius,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  color: AppColors.text1,
                  size: 17,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Maximum Protection Active',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 11,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'You have full MiFID II retail investor protections',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontSize: 9,
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.text1, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MiFID II Categorization',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your client category determines the level of regulatory protection you receive. Retail clients have maximum protection.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 10,
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
    return Container(
      height: 53,
      color: _clientPanel,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: ClientCategorizationPage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: activeId == tab.$1
                                ? _clientPrimary
                                : AppColors.text3,
                            fontSize: 12,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: activeId == tab.$1 ? 70 : 0,
                      height: 2,
                      color: _clientPrimary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
