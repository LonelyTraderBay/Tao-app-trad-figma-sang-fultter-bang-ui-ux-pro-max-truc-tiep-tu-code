part of 'savings_ladder_page.dart';

class _LadderHero extends StatelessWidget {
  const _LadderHero({
    required this.snapshot,
    required this.amountUsd,
    required this.annualInterest,
    required this.rungCount,
    required this.weightedApy,
    required this.liquidityScore,
  });

  final SavingsLadderSnapshot snapshot;
  final int amountUsd;
  final double annualInterest;
  final int rungCount;
  final double weightedApy;
  final int liquidityScore;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsLadderPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.layers_outlined,
                color: AppColors.accent,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  snapshot.heroLabel,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng vốn phân bổ',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.portfolioTextMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _money(amountUsd),
                        style: AppTextStyles.pageTitle.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Dự kiến lãi/năm',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.portfolioTextMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    '+${_money(annualInterest)}',
                    style: AppTextStyles.base.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _HeroStat(label: 'Số bậc', value: '$rungCount'),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(
                  label: 'APY TB',
                  value: '${weightedApy.toStringAsFixed(1)}%',
                  valueColor: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(
                  label: 'Thanh khoản',
                  value: '$liquidityScore',
                  valueColor: AppColors.buy,
                  dot: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.label,
    required this.value,
    this.valueColor,
    this.dot = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    final color = valueColor ?? AppColors.text1;
    return VitCardStat(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Row(
            children: [
              if (dot) ...[
                Container(
                  width: AppSpacing.savingsLadderHeroDot,
                  height: AppSpacing.savingsLadderHeroDot,
                  decoration: const BoxDecoration(
                    color: AppColors.buy,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.x1),
              ],
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.base.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
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

class _LadderTabs extends StatelessWidget {
  const _LadderTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<SavingsPreferenceTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
        child: VitTabBar(
          variant: VitTabBarVariant.underline,
          activeKey: active,
          onChanged: onChanged,
          tabs: [
            for (final tab in tabs) VitTabItem(key: tab.id, label: tab.label),
          ],
        ),
      ),
    );
  }
}

class _AmountSelector extends StatelessWidget {
  const _AmountSelector({
    required this.amountUsd,
    required this.quickAmounts,
    required this.onChanged,
  });

  final int amountUsd;
  final List<int> quickAmounts;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      key: SavingsLadderPage.amountKey,
      padding: VitContentPadding.none,
      fullBleed: true,
      customGap: AppSpacing.x3,
      children: [
        VitCard(
          variant: VitCardVariant.inner,
          radius: VitCardRadius.md,
          borderColor: AppColors.primary30,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          child: SizedBox(
            height: AppSpacing.inputHeight,
            child: Row(
              children: [
                const Icon(
                  Icons.attach_money_rounded,
                  color: AppColors.primary,
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    '$amountUsd',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.base.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                Text(
                  'USD',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            for (final amount in quickAmounts) ...[
              Expanded(
                child: _ChoicePill(
                  key: SavingsLadderPage.amountChipKey(amount),
                  label: _compactAmount(amount),
                  selected: amountUsd == amount,
                  onTap: () => onChanged(amount),
                ),
              ),
              if (amount != quickAmounts.last)
                const SizedBox(width: AppSpacing.x2),
            ],
          ],
        ),
      ],
    );
  }
}

class _TemplateList extends StatelessWidget {
  const _TemplateList({
    required this.templates,
    required this.selected,
    required this.amountUsd,
    required this.onChanged,
  });

  final List<SavingsLadderTemplateDraft> templates;
  final SavingsLadderPreset selected;
  final int amountUsd;
  final ValueChanged<SavingsLadderPreset> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      key: SavingsLadderPage.templatesKey,
      padding: VitContentPadding.none,
      fullBleed: true,
      customGap: AppSpacing.x3,
      children: [
        for (final template in templates) ...[
          _TemplateCard(
            template: template,
            selected: template.id == selected,
            amountUsd: amountUsd,
            onTap: () => onChanged(template.id),
          ),
        ],
      ],
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.template,
    required this.selected,
    required this.amountUsd,
    required this.onTap,
  });

  final SavingsLadderTemplateDraft template;
  final bool selected;
  final int amountUsd;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(template.tone);
    final rungs = _generateRungs(template, amountUsd);
    final apy = _weightedApy(rungs);
    return VitCard(
      key: SavingsLadderPage.presetKey(template.id),
      variant: selected ? VitCardVariant.standard : VitCardVariant.inner,
      radius: VitCardRadius.lg,
      borderColor: selected ? color.withValues(alpha: .45) : null,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RoundIcon(icon: _iconFor(template.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: VitPageContent(
              padding: VitContentPadding.none,
              fullBleed: true,
              customGap: AppSpacing.x2,
              children: [
                Text(
                  template.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _captionBold.copyWith(color: AppColors.text1),
                ),
                Text(
                  template.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: AppSpacing.savingsLadderTemplateLineHeight,
                  ),
                ),
                Text(
                  '${template.intervals.length} bậc · APY TB: ${apy.toStringAsFixed(1)}%',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Icon(
            selected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_off_rounded,
            color: selected ? color : AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

class _RungList extends StatelessWidget {
  const _RungList({
    required this.rungs,
    required this.onToggleRenew,
    required this.onRemove,
  });

  final List<SavingsLadderRungDraft> rungs;
  final ValueChanged<String> onToggleRenew;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    if (rungs.isEmpty) {
      return VitCard(
        key: SavingsLadderPage.rungsKey,
        radius: VitCardRadius.lg,
        padding: const EdgeInsets.all(AppSpacing.x5),
        child: Column(
          children: [
            const Icon(
              Icons.layers_clear_outlined,
              color: AppColors.text3,
              size: AppSpacing.iconLg,
            ),
            const SizedBox(height: AppSpacing.x3),
            Text(
              'Chưa có bậc ladder',
              style: _captionBold.copyWith(color: AppColors.text2),
            ),
          ],
        ),
      );
    }

    return VitPageContent(
      key: SavingsLadderPage.rungsKey,
      padding: VitContentPadding.none,
      fullBleed: true,
      customGap: AppSpacing.x3,
      children: [
        for (var i = 0; i < rungs.length; i++) ...[
          _RungTile(
            index: i + 1,
            rung: rungs[i],
            onToggleRenew: () => onToggleRenew(rungs[i].id),
            onRemove: () => onRemove(rungs[i].id),
          ),
        ],
      ],
    );
  }
}
