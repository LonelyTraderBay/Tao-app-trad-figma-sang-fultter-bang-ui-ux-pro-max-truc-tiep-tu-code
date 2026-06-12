part of 'client_categorization_page.dart';

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    required this.categories,
    required this.currentCategoryId,
  });

  final List<TradeClientCategoryInfo> categories;
  final String currentCategoryId;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.none,
      fullBleed: true,
      customGap: 16,
      children: [
        VitPageSection(
          label: 'Client Categories',
          customGap: 12,
          children: [
            for (final category in categories)
              _CategoryCard(
                category: category,
                isCurrent: category.id == currentCategoryId,
              ),
          ],
        ),
        const VitPageSection(
          label: 'Want Professional Status?',
          customGap: 12,
          children: [_OptUpCard()],
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, required this.isCurrent});

  final TradeClientCategoryInfo category;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final style = _categoryStyle(category.id);
    return VitCard(
      key: ClientCategorizationPage.categoryKey(category.id),
      padding: const EdgeInsets.all(16),
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        customGap: 13,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CategoryIcon(style: style, size: 48, iconSize: 23),
              const SizedBox(width: 12),
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
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                              height: 1,
                            ),
                          ),
                        ),
                        if (isCurrent) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.check_circle_outline,
                            color: style.color,
                            size: 15,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      category.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Protections',
                  value: '${category.protections.length} active',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricBox(
                  label: 'Requirements',
                  value: '${category.requirements.length} criteria',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OptUpCard extends StatelessWidget {
  const _OptUpCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        customGap: 14,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CategoryIcon(
                style: const _CategoryStyle(
                  color: _clientPrimary,
                  icon: Icons.trending_up_rounded,
                ),
                size: 48,
                iconSize: 23,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: VitPageContent(
                  padding: VitContentPadding.none,
                  fullBleed: true,
                  customGap: 8,
                  children: [
                    Text(
                      'Request Professional Client Status',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                    Text(
                      'If you meet the criteria, you can request to be treated as a professional client with reduced regulatory requirements.',
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
          VitCard(
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            borderColor: _clientAmber.withValues(alpha: .24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: _clientAmber,
                  size: 15,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.micro.copyWith(
                        color: _clientAmber,
                        height: 1.3,
                      ),
                      children: const [
                        TextSpan(
                          text: 'Warning: ',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text:
                              'Opting up means you waive certain investor protections. This cannot be reversed easily.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          VitCtaButton(
            key: ClientCategorizationPage.optUpKey,
            height: 44,
            leading: const Icon(Icons.description_outlined),
            trailing: const Icon(Icons.chevron_right_rounded),
            onPressed: () =>
                context.go(AppRoutePaths.tradeCopyClientOptUpRequest),
            child: const Text('Start Opt-Up Application'),
          ),
        ],
      ),
    );
  }
}

class _ProtectionsTab extends StatelessWidget {
  const _ProtectionsTab({required this.categories});

  final List<TradeClientCategoryInfo> categories;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Protection Comparison',
      customGap: 12,
      children: [
        for (final category in categories)
          _ListCard(category: category, values: category.protections),
      ],
    );
  }
}

class _RequirementsTab extends StatelessWidget {
  const _RequirementsTab({required this.categories});

  final List<TradeClientCategoryInfo> categories;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Qualification Requirements',
      customGap: 12,
      children: [
        for (final category in categories)
          _ListCard(
            category: category,
            values: category.requirements,
            requirementMode: true,
          ),
      ],
    );
  }
}

class _ListCard extends StatelessWidget {
  const _ListCard({
    required this.category,
    required this.values,
    this.requirementMode = false,
  });

  final TradeClientCategoryInfo category;
  final List<String> values;
  final bool requirementMode;

  @override
  Widget build(BuildContext context) {
    final style = _categoryStyle(category.id);
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        customGap: 13,
        children: [
          Row(
            children: [
              SizedBox.square(
                dimension: 12,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: style.color,
                    borderRadius: AppRadii.xsRadius,
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Text(
                category.label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          VitPageContent(
            padding: VitContentPadding.none,
            fullBleed: true,
            customGap: 8,
            children: [
              for (final value in values)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      requirementMode
                          ? Icons.track_changes_outlined
                          : Icons.check_circle_outline,
                      color: requirementMode ? AppColors.text3 : style.color,
                      size: 13,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        value,
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
        ],
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({required this.categories, required this.history});

  final List<TradeClientCategoryInfo> categories;
  final List<TradeClientCategoryHistory> history;

  @override
  Widget build(BuildContext context) {
    String labelFor(String id) =>
        categories.firstWhere((item) => item.id == id).label;
    return VitPageSection(
      label: 'Category History',
      customGap: 12,
      children: [
        for (final entry in history)
          VitCard(
            padding: const EdgeInsets.all(13),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CategoryIcon(
                  style: const _CategoryStyle(
                    color: _clientPrimary,
                    icon: Icons.schedule_rounded,
                  ),
                  size: 40,
                  iconSize: 19,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: 7,
                    children: [
                      Text(
                        _historyActionLabel(entry.action),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                      if (entry.fromCategoryId != null)
                        Text(
                          '${labelFor(entry.fromCategoryId!)} -> ${labelFor(entry.toCategoryId)}',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            height: 1,
                          ),
                        ),
                      Text(
                        entry.reason,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        _formatHistoryDate(entry.date),
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
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
    );
  }
}

class _QuickLinks extends StatelessWidget {
  const _QuickLinks();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickLinkButton(
            key: ClientCategorizationPage.disclosuresKey,
            icon: Icons.description_outlined,
            iconColor: _clientPrimary,
            label: 'Disclosures',
            onTap: () =>
                context.go(AppRoutePaths.tradeCopyRegulatoryDisclosures),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickLinkButton(
            key: ClientCategorizationPage.settingsKey,
            icon: Icons.settings_outlined,
            iconColor: _clientGreen,
            label: 'Settings',
            onTap: () => context.go(AppRoutePaths.settingsSecurity),
          ),
        ),
      ],
    );
  }
}
