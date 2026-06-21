part of '../pages/unified_search_page.dart';

class _SearchBand extends StatelessWidget {
  const _SearchBand({
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: AppSpacing.discoverySearchBandPadding,
          child: VitSearchBar(
            key: UnifiedSearchPage.searchKey,
            controller: controller,
            placeholder: hint,
            autofocus: true,
            variant: VitSearchBarVariant.defaultSearch,
            onChanged: (_) => onChanged(),
          ),
        ),
        const Divider(
          height: AppSpacing.dividerHairline,
          thickness: AppSpacing.dividerHairline,
          color: AppColors.divider,
        ),
      ],
    );
  }
}

class _NoQueryState extends StatelessWidget {
  const _NoQueryState({required this.snapshot, required this.onQuerySelected});

  final UnifiedSearchSnapshot snapshot;
  final ValueChanged<String> onQuerySelected;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      gap: VitContentGap.tight,
      children: [
        VitPageSection(
          label: 'Trending',
          accentColor: AppModuleAccents.predictions,
          children: [
            Wrap(
              key: UnifiedSearchPage.trendingKey,
              spacing: AppSpacing.x3,
              runSpacing: AppSpacing.x3,
              children: [
                for (final query in snapshot.trendingQueries)
                  _TrendingChip(
                    query: query,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      onQuerySelected(query.label);
                    },
                  ),
              ],
            ),
          ],
        ),
        VitPageSection(
          label: 'Khám phá theo module',
          accentColor: AppModuleAccents.discovery,
          children: [
            for (final module in snapshot.modules) _ModuleCard(module: module),
          ],
        ),
      ],
    );
  }
}

class _TrendingChip extends StatelessWidget {
  const _TrendingChip({required this.query, required this.onTap});

  final DiscoveryTrendingQueryDraft query;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: UnifiedSearchPage.trendingQueryKey(query.label),
      onTap: onTap,
      borderRadius: AppRadii.lgRadius,
      child: SizedBox(
        height: AppSpacing.buttonCompact,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: AppColors.surface2,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AppColors.borderSolid),
              borderRadius: AppRadii.lgRadius,
            ),
          ),
          child: Padding(
            padding: AppSpacing.discoveryChipHorizontalPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _iconForKey(query.iconKey),
                  color: _accentForKey(query.iconKey),
                  size: 13,
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  query.label,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.module});

  final DiscoveryModuleDraft module;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForModule(module.kind);
    return VitCard(
      key: UnifiedSearchPage.moduleKey(module.id),
      onTap: () {
        HapticFeedback.selectionClick();
        context.go(module.route);
      },
      padding: AppSpacing.discoveryCardPadding,
      borderColor: accent.withValues(alpha: .12),
      child: Row(
        children: [
          _AccentIcon(icon: _iconForKey(module.iconKey), color: accent),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  module.title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  module.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          const Icon(
            Icons.arrow_forward_rounded,
            color: AppColors.text3,
            size: 16,
          ),
        ],
      ),
    );
  }
}
