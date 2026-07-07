part of '../pages/safety_education_page.dart';

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.snapshot});

  final TradeSafetyEducationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: _safetyPrimary,
      child: Row(
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          const VitCard(
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.large,
            width: AppSpacing.tradeBotClientCategoryIcon,
            height: AppSpacing.tradeBotClientCategoryIcon,
            alignment: Alignment.center,
            borderColor: _safetyPrimary,
            child: Icon(
              Icons.shield_outlined,
              color: AppColors.onAccent,
              size: AppSpacing.tradeBotHeroIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.tradeBotStatusGap),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.heroTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: _safetyPrimary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.heroDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: _safetyPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SafetyTabs extends StatelessWidget {
  const _SafetyTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeSafetyTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedTabBar(
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.id,
            label: tab.label,
            widgetKey: SafetyEducationPage.tabKey(tab.id),
          ),
      ],
      activeKey: activeId,
      onChanged: onChanged,
    );
  }
}

class _ScamsTab extends StatelessWidget {
  const _ScamsTab({
    required this.scams,
    required this.expandedId,
    required this.onToggle,
  });

  final List<TradeSafetyScamType> scams;
  final String? expandedId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(rhythm: VitPageRhythm.standard, 
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.compact,
      children: [
        Text(
          '${scams.length} loại scam phổ biến trong copy trading. Tap để xem chi tiết.',
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        for (final scam in scams)
          _ScamCard(
            scam: scam,
            expanded: expandedId == scam.id,
            onTap: () => onToggle(scam.id),
          ),
      ],
    );
  }
}

class _ScamCard extends StatelessWidget {
  const _ScamCard({
    required this.scam,
    required this.expanded,
    required this.onTap,
  });

  final TradeSafetyScamType scam;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.cardBorder,
      density: VitDensity.compact,
      child: Column(
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            key: SafetyEducationPage.scamKey(scam.id),
            onTap: onTap,
            variant: VitCardVariant.ghost,
            constraints: const BoxConstraints(
              minHeight: AppSpacing.tradeBotControlTall,
            ),
            density: VitDensity.compact,
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.sell,
                  size: AppSpacing.tradeBotActionIcon,
                ),
                const SizedBox(width: AppSpacing.tradeBotRowGap),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scam.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        scam.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.tradeBotDisclosureGap),
                AnimatedRotation(
                  turns: expanded ? .5 : 0,
                  duration: const Duration(milliseconds: 120),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.tradeBotMediumIcon,
                  ),
                ),
              ],
            ),
          ),
          if (expanded)
            _ScamExpandedContent(
              examples: scam.examples,
              howToAvoid: scam.howToAvoid,
            ),
        ],
      ),
    );
  }
}

class _ScamExpandedContent extends StatelessWidget {
  const _ScamExpandedContent({
    required this.examples,
    required this.howToAvoid,
  });

  final List<String> examples;
  final List<String> howToAvoid;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      width: double.infinity,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ExpandedList(
            title: 'Ví dụ:',
            items: examples,
            color: AppColors.text3,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _ExpandedList(
            title: 'Cách tránh:',
            items: howToAvoid,
            color: AppColors.buy,
            bullet: '✓',
          ),
        ],
      ),
    );
  }
}

class _ExpandedList extends StatelessWidget {
  const _ExpandedList({
    required this.title,
    required this.items,
    required this.color,
    this.bullet = '•',
  });

  final String title;
  final List<String> items;
  final Color color;
  final String bullet;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        for (final item in items) ...[
          Text(
            '$bullet $item',
            style: AppTextStyles.micro.copyWith(color: color),
          ),
          if (item != items.last) const SizedBox(height: AppSpacing.x1),
        ],
      ],
    );
  }
}

class _RedFlagsTab extends StatelessWidget {
  const _RedFlagsTab({required this.flags});

  final List<TradeSafetyRedFlag> flags;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(rhythm: VitPageRhythm.standard, 
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.compact,
      children: [
        Text(
          'Checklist để đánh giá provider trước khi copy. Nếu có ≥2 red flags nghiêm trọng, KHÔNG nên copy.',
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        for (final severity in ['critical', 'warning', 'caution'])
          _SeveritySection(
            title: _severityTitle(severity),
            color: _severityColor(severity),
            flags: flags.where((flag) => flag.severity == severity).toList(),
          ),
      ],
    );
  }
}
