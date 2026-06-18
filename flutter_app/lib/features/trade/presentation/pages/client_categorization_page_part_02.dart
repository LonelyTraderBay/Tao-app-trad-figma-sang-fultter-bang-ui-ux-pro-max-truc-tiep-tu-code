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
      customGap: AppSpacing.contentPad,
      children: [
        VitPageSection(
          label: 'Client Categories',
          customGap: AppSpacing.tradeBotCardGap,
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
          customGap: AppSpacing.tradeBotCardGap,
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
      padding: AppSpacing.tradeBotCardPadding,
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        customGap: AppSpacing.x4,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CategoryIcon(
                style: style,
                size: AppSpacing.tradeBotClientCategoryIcon,
                iconSize: AppSpacing.tradeBotClientCategoryIconGlyph,
              ),
              const SizedBox(width: AppSpacing.tradeBotCardIconGap),
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
                              height: AppSpacing.tradeBotLineHeightTight,
                            ),
                          ),
                        ),
                        if (isCurrent) ...[
                          const SizedBox(width: AppSpacing.tradeBotSmallGap),
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
                        height: AppSpacing.tradeBotLineHeightTight,
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
              const SizedBox(width: AppSpacing.tradeBotRowGap),
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
      padding: AppSpacing.tradeBotCardPadding,
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        customGap: AppSpacing.tradeBotStatusGap,
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
              const SizedBox(width: AppSpacing.tradeBotCardIconGap),
              Expanded(
                child: VitPageContent(
                  padding: VitContentPadding.none,
                  fullBleed: true,
                  customGap: AppSpacing.tradeBotSmallGap,
                  children: [
                    Text(
                      'Request Professional Client Status',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        height: AppSpacing.tradeBotLineHeightTight,
                      ),
                    ),
                    Text(
                      'If you meet the criteria, you can request to be treated as a professional client with reduced regulatory requirements.',
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
          VitCard(
            variant: VitCardVariant.inner,
            padding: AppSpacing.tradeBotCompactCardPadding,
            borderColor: _clientAmber.withValues(alpha: .24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: _clientAmber,
                  size: AppSpacing.tradeBotSectionMarkerHeight,
                ),
                const SizedBox(width: AppSpacing.tradeBotDisclosureGap),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.micro.copyWith(
                        color: _clientAmber,
                        height: AppSpacing.tradeBotLineHeightBody,
                      ),
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
            height: AppSpacing.tradeBotSheetActionHeight,
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
      customGap: AppSpacing.tradeBotCardGap,
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
      customGap: AppSpacing.tradeBotCardGap,
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
      padding: AppSpacing.tradeBotCardPadding,
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        customGap: AppSpacing.x4,
        children: [
          Row(
            children: [
              Icon(
                Icons.square_rounded,
                color: style.color,
                size: AppSpacing.tradeBotClientMarker,
              ),
              const SizedBox(width: AppSpacing.tradeBotDisclosureGap),
              Text(
                category.label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: AppSpacing.tradeBotLineHeightTight,
                ),
              ),
            ],
          ),
          VitPageContent(
            padding: VitContentPadding.none,
            fullBleed: true,
            customGap: AppSpacing.tradeBotSmallGap,
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
                      size: AppSpacing.x4,
                    ),
                    const SizedBox(width: AppSpacing.tradeBotSmallGap),
                    Expanded(
                      child: Text(
                        value,
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
      customGap: AppSpacing.tradeBotCardGap,
      children: [
        for (final entry in history)
          VitCard(
            padding: AppSpacing.tradeBotStrategyCardPadding,
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
                const SizedBox(width: AppSpacing.tradeBotCardIconGap),
                Expanded(
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: AppSpacing.tradeBotLabelGap,
                    children: [
                      Text(
                        _historyActionLabel(entry.action),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          height: AppSpacing.tradeBotLineHeightTight,
                        ),
                      ),
                      if (entry.fromCategoryId != null)
                        Text(
                          '${labelFor(entry.fromCategoryId!)} -> ${labelFor(entry.toCategoryId)}',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            height: AppSpacing.tradeBotLineHeightTight,
                          ),
                        ),
                      Text(
                        entry.reason,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height: AppSpacing.tradeBotLineHeightCaption,
                        ),
                      ),
                      Text(
                        _formatHistoryDate(entry.date),
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
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
        const SizedBox(width: AppSpacing.tradeBotCardGap),
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
