part of '../pages/safety_education_page.dart';

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.snapshot});

  final TradeSafetyEducationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 94,
      padding: const EdgeInsets.all(16),
      borderColor: _safetyPrimary,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: _safetyPrimary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: AppColors.onAccent,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
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
                    fontSize: 15,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.heroDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: _safetyPrimary,
                    fontSize: 11,
                    height: 1.45,
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
    return Container(
      height: 54,
      color: _safetyTabs,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: SafetyEducationPage.tabKey(tab.id),
                onTap: () => onChanged(tab.id),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.label,
                          textAlign: TextAlign.center,
                          maxLines: tab.id == 'scams' ? 2 : 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: tab.id == activeId
                                ? _safetyPrimary
                                : AppColors.text3,
                            fontSize: 12,
                            fontWeight: AppTextStyles.bold,
                            height: 1.12,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: tab.id == activeId ? 70 : 0,
                      height: 2,
                      color: _safetyPrimary,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${scams.length} loại scam phổ biến trong copy trading. Tap để xem chi tiết.',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 13),
        for (final scam in scams) ...[
          _ScamCard(
            scam: scam,
            expanded: expandedId == scam.id,
            onTap: () => onToggle(scam.id),
          ),
          if (scam != scams.last) const SizedBox(height: 13),
        ],
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
      child: Column(
        children: [
          InkWell(
            key: SafetyEducationPage.scamKey(scam.id),
            onTap: onTap,
            borderRadius: AppRadii.cardRadius,
            child: SizedBox(
              height: 68,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(17, 12, 14, 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.sell,
                      size: 20,
                    ),
                    const SizedBox(width: 11),
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
                              fontSize: 13,
                              fontWeight: AppTextStyles.bold,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            scam.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              fontSize: 10,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 9),
                    AnimatedRotation(
                      turns: expanded ? .5 : 0,
                      duration: const Duration(milliseconds: 120),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.text3,
                        size: 17,
                      ),
                    ),
                  ],
                ),
              ),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ExpandedList(
            title: 'Ví dụ:',
            items: examples,
            color: AppColors.text3,
          ),
          const SizedBox(height: 14),
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
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        for (final item in items) ...[
          Text(
            '$bullet $item',
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontSize: 10,
              height: 1.4,
            ),
          ),
          if (item != items.last) const SizedBox(height: 4),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Checklist để đánh giá provider trước khi copy. Nếu có ≥2 red flags nghiêm trọng, KHÔNG nên copy.',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 14),
        for (final severity in ['critical', 'warning', 'caution']) ...[
          _SeveritySection(
            title: _severityTitle(severity),
            color: _severityColor(severity),
            flags: flags.where((flag) => flag.severity == severity).toList(),
          ),
          if (severity != 'caution') const SizedBox(height: 14),
        ],
      ],
    );
  }
}
