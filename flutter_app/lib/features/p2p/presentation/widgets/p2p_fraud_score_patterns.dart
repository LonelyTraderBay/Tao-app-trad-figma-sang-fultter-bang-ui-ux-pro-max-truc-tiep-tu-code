part of '../pages/p2p_fraud_prevention_page.dart';

class _SafetyScoreCard extends StatelessWidget {
  const _SafetyScoreCard({
    required this.score,
    required this.checkedCount,
    required this.totalCount,
  });

  final int score;
  final int checkedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final color = _scoreColor(score);

    return VitCard(
      key: P2PFraudPreventionPage.scoreKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.verified_user_outlined, color: color, size: 20),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Chỉ số an toàn',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '$score%',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: color,
                  fontSize: 28,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          ClipRRect(
            borderRadius: AppRadii.xlRadius,
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 8,
              color: color,
              backgroundColor: AppColors.surface3,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            '$checkedCount/$totalCount biện pháp bảo vệ đã áp dụng',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          if (score < 100) ...[
            const SizedBox(height: AppSpacing.x3),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.warn10,
                borderRadius: AppRadii.lgRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.x3),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.warn,
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        'Hoàn thành checklist bên dưới để tăng chỉ số an toàn',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.warn,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PatternSection extends StatelessWidget {
  const _PatternSection({
    required this.patterns,
    required this.expandedPatternId,
    required this.onToggle,
  });

  final List<P2PScamPatternDraft> patterns;
  final String? expandedPatternId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PFraudPreventionPage.patternsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(
              Icons.gpp_bad_outlined,
              color: AppColors.sell,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                'Các hình thức gian lận phổ biến',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        for (var index = 0; index < patterns.length; index++) ...[
          _PatternCard(
            pattern: patterns[index],
            expanded: expandedPatternId == patterns[index].id,
            onTap: () => onToggle(patterns[index].id),
          ),
          if (index != patterns.length - 1)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _PatternCard extends StatelessWidget {
  const _PatternCard({
    required this.pattern,
    required this.expanded,
    required this.onTap,
  });

  final P2PScamPatternDraft pattern;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(pattern.severity);

    return VitCard(
      key: P2PFraudPreventionPage.patternKey(pattern.id),
      radius: VitCardRadius.lg,
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSpacing.inputHeight,
                  height: AppSpacing.inputHeight,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .12),
                    borderRadius: AppRadii.lgRadius,
                  ),
                  child: Icon(_patternIcon(pattern.iconKey), color: color),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              pattern.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.baseMedium.copyWith(
                                fontSize: 15,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x2),
                          _SeverityBadge(severity: pattern.severity),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        pattern.description,
                        maxLines: expanded ? null : 2,
                        overflow: expanded ? null : TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                AnimatedRotation(
                  turns: expanded ? .5 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.iconSm,
                  ),
                ),
              ],
            ),
          ),
          if (expanded) _ExpandedPattern(pattern: pattern),
        ],
      ),
    );
  }
}

class _ExpandedPattern extends StatelessWidget {
  const _ExpandedPattern({required this.pattern});

  final P2PScamPatternDraft pattern;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DetailList(
              title: 'CÁCH THỨC HOẠT ĐỘNG',
              items: pattern.howItWorks,
              color: AppColors.text2,
              numbered: true,
            ),
            const SizedBox(height: AppSpacing.x4),
            _DetailList(
              title: 'DẤU HIỆU NHẬN BIẾT',
              items: pattern.redFlags,
              color: AppColors.sell,
              icon: Icons.error_outline_rounded,
            ),
            const SizedBox(height: AppSpacing.x4),
            _DetailList(
              title: 'CÁCH PHÒNG TRÁNH',
              items: pattern.prevention,
              color: AppColors.buy,
              icon: Icons.check_circle_outline_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailList extends StatelessWidget {
  const _DetailList({
    required this.title,
    required this.items,
    required this.color,
    this.numbered = false,
    this.icon,
  });

  final String title;
  final List<String> items;
  final Color color;
  final bool numbered;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        for (var index = 0; index < items.length; index++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (numbered)
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.surface2,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                )
              else
                Icon(icon, color: color, size: 13),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  items[index],
                  style: AppTextStyles.caption.copyWith(
                    color: color == AppColors.text2 ? AppColors.text2 : color,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
          if (index != items.length - 1) const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }
}
