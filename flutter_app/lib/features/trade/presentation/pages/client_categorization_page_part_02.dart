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
 rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.compact,
      children: [
        VitPageSection(
          label: 'Client Categories',
          density: VitDensity.compact,
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
          density: VitDensity.compact,
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
      density: VitDensity.compact,
      child: VitPageContent(
 rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.compact,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CategoryIcon(
                style: style,
                size: AppSpacing.tradeBotClientCategoryIcon,
                iconSize: AppSpacing.tradeBotClientCategoryIconGlyph,
              ),
              const SizedBox(width: AppSpacing.x3),
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
                            ),
                          ),
                        ),
                        if (isCurrent) ...[
                          const SizedBox(width: AppSpacing.x2),
                          Icon(
                            Icons.check_circle_outline,
                            color: style.color,
                            size: AppSpacing.tradeBotSectionMarkerHeight,
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
              const SizedBox(width: AppSpacing.x3),
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
      density: VitDensity.compact,
      child: VitPageContent(
   rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.compact,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CategoryIcon(
                style: const _CategoryStyle(
                  color: _clientPrimary,
                  icon: Icons.trending_up_rounded,
                ),
                size: AppSpacing.tradeBotClientCategoryIcon,
                iconSize: AppSpacing.tradeBotClientCategoryIconGlyph,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitPageContent(
                  padding: VitContentPadding.none,
                  fullBleed: true,
                  density: VitDensity.compact,
                  children: [
                    Text(
                      'Request Professional Client Status',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      'If you meet the criteria, you can request to be treated as a professional client with reduced regulatory requirements.',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          VitCard(
            variant: VitCardVariant.inner,
            density: VitDensity.compact,
            borderColor: _clientAmber.withValues(alpha: .24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: _clientAmber,
                  size: AppSpacing.tradeBotSectionMarkerHeight,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.micro.copyWith(color: _clientAmber),
                      children: [
                        TextSpan(
                          text: 'Warning: ',
                          style: AppTextStyles.micro.copyWith(
                            color: _clientAmber,
                            fontWeight: AppTextStyles.bold,
                          ),
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
            density: VitDensity.compact,
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
      density: VitDensity.compact,
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
      density: VitDensity.compact,
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
      density: VitDensity.compact,
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.compact,
        children: [
          Row(
            children: [
              Icon(
                Icons.square_rounded,
                color: style.color,
                size: AppSpacing.tradeBotClientMarker,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                category.label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          for (final value in values)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  requirementMode
                      ? Icons.track_changes_outlined
                      : Icons.check_circle_outline,
                  color: requirementMode ? AppColors.text3 : style.color,
                  size: AppSpacing.x4,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    value,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
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
      density: VitDensity.compact,
      children: [
        for (final entry in history)
          VitCard(
            density: VitDensity.compact,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CategoryIcon(
                  style: const _CategoryStyle(
                    color: _clientPrimary,
                    icon: Icons.schedule_rounded,
                  ),
                  size: AppSpacing.tradeBotClientHistoryIcon,
                  iconSize: AppSpacing.tradeBotClientHistoryIconGlyph,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    density: VitDensity.compact,
                    children: [
                      Text(
                        _historyActionLabel(entry.action),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      if (entry.fromCategoryId != null)
                        Text(
                          '${labelFor(entry.fromCategoryId!)} -> ${labelFor(entry.toCategoryId)}',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      Text(
                        entry.reason,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      Text(
                        _formatHistoryDate(entry.date),
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
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
        const SizedBox(width: AppSpacing.x3),
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
