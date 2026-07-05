part of 'arena_guide_page.dart';

class _ExampleSection extends StatelessWidget {
  const _ExampleSection({required this.examples});

  final List<ArenaGuideExampleDraft> examples;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'So sánh challenge',
      accentColor: _arenaAccent,
      children: [
        Text(
          'Challenge tốt vs cần cải thiện',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        for (final example in examples) _ExampleCard(example: example),
      ],
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({required this.example});

  final ArenaGuideExampleDraft example;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(example.tone);
    return VitCard(
      padding: AppSpacing.arenaPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  example.title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              _SmallBadge(label: example.rating, color: color),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              _MetaChip(example.template),
              _MetaChip(example.format),
              _MetaChip('${example.entryPoints} pts'),
              _MetaChip(example.resolution),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final reason in example.reasons)
            Padding(
              padding: AppSpacing.arenaGuideReasonPadding,
              child: Row(
                children: [
                  Icon(
                    example.tone == ArenaGuideTone.success
                        ? Icons.check_circle_outline
                        : Icons.warning_amber_outlined,
                    color: color,
                    size: AppSpacing.arenaGuideReasonIcon,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      reason,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                      ),
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

class _ConceptSection extends StatelessWidget {
  const _ConceptSection({required this.concepts});

  final List<ArenaGuideConceptDraft> concepts;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Thuật ngữ quan trọng',
      accentColor: _arenaAccent,
      children: [
        VitCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var index = 0; index < concepts.length; index++) ...[
                if (index > 0)
                  const Divider(
                    height: AppSpacing.dividerHairline,
                    thickness: AppSpacing.dividerHairline,
                    color: AppColors.divider,
                  ),
                Padding(
                  padding: AppSpacing.arenaPaddingX3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        concepts[index].term,
                        style: AppTextStyles.caption.copyWith(
                          color: _arenaAccent,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        concepts[index].definition,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TipsHeader extends StatelessWidget {
  const _TipsHeader({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: _arenaAccent,
      padding: AppSpacing.arenaPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline,
            color: _arenaAccent,
            size: AppSpacing.arenaGuideTipsHeaderIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$total mẹo từ Top Creator',
                  style: AppTextStyles.body.copyWith(
                    color: _arenaAccent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Những bí quyết giúp challenge nổi bật, thu hút người chơi và giảm tranh chấp.',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImpactLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Mức ảnh hưởng:',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(width: AppSpacing.x3),
        _LegendDot(label: 'Cao', color: AppColors.sell),
        const SizedBox(width: AppSpacing.x3),
        _LegendDot(label: 'Trung bình', color: AppColors.warn),
      ],
    );
  }
}

class _TipsList extends StatelessWidget {
  const _TipsList({
    required this.tips,
    required this.expandedIndex,
    required this.onToggle,
  });

  final List<ArenaGuideTipDraft> tips;
  final int? expandedIndex;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < tips.length; index++)
          Padding(
            padding: AppSpacing.arenaGuideAccordionListPadding(
              index == tips.length - 1,
            ),
            child: _AccordionCard(
              key: ArenaGuidePage.tipKey(tips[index].category),
              icon: _iconFor(tips[index].iconKey),
              title: tips[index].title,
              description: tips[index].description,
              badgeColor: tips[index].impact == ArenaGuideImpact.high
                  ? AppColors.sell
                  : AppColors.warn,
              open: expandedIndex == index,
              onTap: () => onToggle(index),
            ),
          ),
      ],
    );
  }
}

class _ShowMoreTipsButton extends StatelessWidget {
  const _ShowMoreTipsButton({required this.remaining, required this.onPressed});

  final int remaining;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: VitCtaButton(
        onPressed: onPressed,
        variant: VitCtaButtonVariant.ghost,
        fullWidth: false,
        height: AppSpacing.buttonCompact,
        leading: const Icon(
          Icons.expand_more,
          size: AppSpacing.arenaGuideShowMoreIcon,
        ),
        child: Text('Xem thêm $remaining mẹo'),
      ),
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.buy20,
      padding: AppSpacing.arenaPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: AppColors.buy,
                size: AppSpacing.arenaGuideChecklistIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Checklist trước khi đăng',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (var index = 0; index < items.length; index++)
            Padding(
              padding: AppSpacing.arenaGuideChecklistItemPadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: AppSpacing.arenaGuideChecklistBox,
                    height: AppSpacing.arenaGuideChecklistBox,
                    child: DecoratedBox(
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: AppColors.borderSolid),
                          borderRadius: AppRadii.xsRadius,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            height: _guideChecklistLineRatio,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      items[index],
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
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

class _SafetyHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: AppColors.buy,
      padding: AppSpacing.arenaPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.buy,
            size: AppSpacing.arenaGuideSafetyHeroIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'An toàn trong Arena',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Open Arena dùng Arena Points, Trust Score, Fair Play và quy trình tranh chấp minh bạch để bảo vệ cộng đồng.',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PointsOnlyBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.accent20,
      padding: AppSpacing.arenaPaddingX4,
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.arenaGuideFeatureIconBox,
            height: AppSpacing.arenaGuideFeatureIconBox,
            child: const DecoratedBox(
              decoration: ShapeDecoration(
                color: AppColors.accent12,
                shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
              ),
              child: Center(
                child: Icon(
                  Icons.info_outline,
                  color: AppColors.accent,
                  size: AppSpacing.arenaGuideFeatureGlyph,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Points only - không có rủi ro tài chính',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'Arena Points không liên quan đến crypto hay fiat.',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SafetyTipList extends StatelessWidget {
  const _SafetyTipList({required this.items});

  final List<ArenaGuideSafetyTipDraft> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < items.length; index++)
          Padding(
            padding: AppSpacing.arenaGuideSafetyTipPadding(
              index == items.length - 1,
            ),
            child: _SafetyTipCard(item: items[index]),
          ),
      ],
    );
  }
}

class _SafetyTipCard extends StatelessWidget {
  const _SafetyTipCard({required this.item});

  final ArenaGuideSafetyTipDraft item;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(item.tone);
    return VitCard(
      padding: AppSpacing.arenaPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSpacing.arenaGuideSafetyTipIconBox,
            height: AppSpacing.arenaGuideSafetyTipIconBox,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: color.withValues(alpha: .12),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.smRadius,
                ),
              ),
              child: Center(
                child: Icon(
                  _iconFor(item.iconKey),
                  color: color,
                  size: AppSpacing.arenaGuideSafetyTipGlyph,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  item.description,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
