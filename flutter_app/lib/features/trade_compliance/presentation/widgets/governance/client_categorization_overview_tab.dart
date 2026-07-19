part of '../../pages/governance/client_categorization_page.dart';

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
      density: VitDensity.tool,
      children: [
        VitPageSection(
          label: 'Client Categories',
          density: VitDensity.tool,
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
          density: VitDensity.tool,
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
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.tool,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CategoryIcon(
                style: style,
                size: TradeSpacingTokens.tradeBotClientCategoryIcon,
                iconSize: TradeSpacingTokens.tradeBotClientCategoryIconGlyph,
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
                            size:
                                TradeSpacingTokens.tradeBotSectionMarkerHeight,
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
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.tool,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CategoryIcon(
                style: _CategoryStyle(
                  color: _clientPrimary,
                  icon: Icons.trending_up_rounded,
                ),
                size: TradeSpacingTokens.tradeBotClientCategoryIcon,
                iconSize: TradeSpacingTokens.tradeBotClientCategoryIconGlyph,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitPageContent(
                  padding: VitContentPadding.none,
                  fullBleed: true,
                  density: VitDensity.tool,
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
            density: VitDensity.tool,
            radius: VitCardRadius.tight,
            borderColor: _clientAmber.withValues(alpha: .24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: _clientAmber,
                  size: TradeSpacingTokens.tradeBotSectionMarkerHeight,
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
                        const TextSpan(
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
            density: VitDensity.tool,
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

class _MetricBox extends StatelessWidget {
  const _MetricBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
