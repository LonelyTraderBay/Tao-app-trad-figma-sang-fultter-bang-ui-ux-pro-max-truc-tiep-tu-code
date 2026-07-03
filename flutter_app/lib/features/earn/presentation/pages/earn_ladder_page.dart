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
      radius: VitCardRadius.large,
      density: VitDensity.compact,
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
                const SizedBox.square(
                  dimension: AppSpacing.savingsLadderHeroDot,
                  child: Material(color: AppColors.buy, shape: CircleBorder()),
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
    return Material(
      color: AppColors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: AppSpacing.earnHorizontalPaddingX4,
            child: VitTabBar(
              variant: VitTabBarVariant.underline,
              activeKey: active,
              onChanged: onChanged,
              tabs: [
                for (final tab in tabs)
                  VitTabItem(key: tab.id, label: tab.label),
              ],
            ),
          ),
          const Divider(color: AppColors.divider, height: AppSpacing.x1),
        ],
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
      gap: VitContentGap.tight,
      children: [
        VitCard(
          variant: VitCardVariant.inner,
          radius: VitCardRadius.standard,
          borderColor: AppColors.primary30,
          density: VitDensity.compact,
          child: SizedBox(
            height: VitDensity.compact.controlHeight,
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
      gap: VitContentGap.tight,
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
      radius: VitCardRadius.large,
      borderColor: selected ? color.withValues(alpha: .45) : null,
      density: VitDensity.compact,
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
              gap: VitContentGap.tight,
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
                    height: _templateLineHeight,
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
        radius: VitCardRadius.large,
        density: VitDensity.compact,
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
      gap: VitContentGap.tight,
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


class _RungTile extends StatelessWidget {
  const _RungTile({
    required this.index,
    required this.rung,
    required this.onToggleRenew,
    required this.onRemove,
  });

  final int index;
  final SavingsLadderRungDraft rung;
  final VoidCallback onToggleRenew;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(rung.colorKey);
    return VitCard(
      key: SavingsLadderPage.rungKey(rung.id),
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      density: VitDensity.compact,
      child: Row(
        children: [
          SizedBox.square(
            dimension: AppSpacing.savingsLadderRungIndexBox,
            child: Material(
              color: color.withValues(alpha: .14),
              shape: const CircleBorder(),
              child: Center(
                child: Text('$index', style: _microBold.copyWith(color: color)),
              ),
            ),
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
                        rung.product,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _captionBold.copyWith(color: AppColors.text1),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    _SmallPill(
                      label: '${rung.lockDays}D',
                      color: AppColors.warn,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    _SmallPill(
                      label: rung.autoRenew ? 'Tự gia hạn' : 'Dừng',
                      color: rung.autoRenew ? AppColors.buy : AppColors.text3,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x1,
                  children: [
                    Text(
                      _money(rung.amountUsd),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    Text(
                      '${rung.apyPct.toStringAsFixed(1)}%',
                      style: _captionBold.copyWith(color: AppColors.buy),
                    ),
                    Text(
                      '→ ${rung.maturityDate}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          VitIconButton(
            tooltip: rung.autoRenew ? 'Tắt tự gia hạn' : 'Bật tự gia hạn',
            icon: rung.autoRenew
                ? Icons.autorenew_rounded
                : Icons.block_flipped,
            onPressed: onToggleRenew,
            variant: rung.autoRenew
                ? VitIconButtonVariant.success
                : VitIconButtonVariant.transparent,
            size: VitIconButtonSize.sm,
          ),
          VitIconButton(
            tooltip: 'Xóa bậc',
            icon: Icons.delete_outline_rounded,
            onPressed: onRemove,
            variant: VitIconButtonVariant.danger,
            size: VitIconButtonSize.sm,
          ),
        ],
      ),
    );
  }
}

class _AddRungButton extends StatelessWidget {
  const _AddRungButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsLadderPage.addRungKey,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.large,
      borderColor: AppColors.primary30,
      density: VitDensity.compact,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add_rounded,
            color: AppColors.text2,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            'Thêm bậc ladder',
            style: _captionBold.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _AllocationStatus extends StatelessWidget {
  const _AllocationStatus({
    required this.amountUsd,
    required this.totalAllocated,
    required this.unallocated,
  });

  final int amountUsd;
  final double totalAllocated;
  final double unallocated;

  @override
  Widget build(BuildContext context) {
    final complete = unallocated.abs() < 1;
    final progress = amountUsd <= 0
        ? 0.0
        : (totalAllocated / amountUsd).clamp(0.0, 1.0);
    final color = complete ? AppColors.buy : AppColors.warn;
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: color.withValues(alpha: .18),
      density: VitDensity.compact,
      child: Row(
        children: [
          Expanded(
            child: Text(
              complete
                  ? 'Đã phân bổ hết'
                  : 'Chưa phân bổ: ${_money(unallocated)}',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          SizedBox(
            width: AppSpacing.savingsLadderAllocationProgressWidth,
            child: ClipRRect(
              borderRadius: AppRadii.pillRadius,
              child: LinearProgressIndicator(
                minHeight: AppSpacing.x1,
                value: progress,
                color: color,
                backgroundColor: AppColors.surface3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineTab extends StatelessWidget {
  const _TimelineTab({required this.snapshot, required this.rungs});

  final SavingsLadderSnapshot snapshot;
  final List<SavingsLadderRungDraft> rungs;

  @override
  Widget build(BuildContext context) {
    if (rungs.isEmpty) {
      return _EmptyTab(
        icon: Icons.layers_clear_outlined,
        title: 'Chưa có bậc nào',
        cta: 'Bắt đầu xây',
      );
    }

    final sorted = [...rungs]..sort((a, b) => a.lockDays.compareTo(b.lockDays));
    return VitPageContent(
      key: SavingsLadderPage.timelineKey,
      padding: VitContentPadding.none,
      fullBleed: true,
      gap: VitContentGap.tight,
      children: [
        const _SectionTitle(label: 'Lịch đáo hạn'),
        _TimelineChart(rungs: sorted),
        const _SectionTitle(label: 'Lịch trình đáo hạn'),
        VitPageContent(
          padding: VitContentPadding.none,
          fullBleed: true,
          gap: VitContentGap.tight,
          children: [for (final rung in sorted) _MaturityTile(rung: rung)],
        ),
        const _SectionTitle(label: 'Dự kiến dòng tiền'),
        _CashFlowCard(rungs: sorted),
        EarnDisclaimerBanner(
          text: snapshot.disclaimer,
          lineHeight: _disclaimerLineHeight,
        ),
      ],
    );
  }
}

class _TimelineChart extends StatelessWidget {
  const _TimelineChart({required this.rungs});

  final List<SavingsLadderRungDraft> rungs;

  @override
  Widget build(BuildContext context) {
    final maxDays = rungs.map((rung) => rung.lockDays).reduce(math.max);
    return VitCard(
      radius: VitCardRadius.large,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Hôm nay',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const Expanded(child: SizedBox.shrink()),
              Text(
                '${maxDays}D',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final rung in rungs) ...[
            _TimelineBar(rung: rung, maxDays: maxDays),
            if (rung != rungs.last) const SizedBox(height: AppSpacing.x2),
          ],
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final rung in rungs)
                _SmallPill(
                  label: rung.maturityDate,
                  color: _colorFor(rung.colorKey),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineBar extends StatelessWidget {
  const _TimelineBar({required this.rung, required this.maxDays});

  final SavingsLadderRungDraft rung;
  final int maxDays;

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(rung.colorKey);
    final widthFactor = math.max(.18, rung.lockDays / maxDays);
    return Row(
      children: [
        SizedBox(
          width: AppSpacing.savingsLadderTimelineLabelWidth,
          child: Text(
            '${rung.asset} ${rung.lockDays}D',
            textAlign: TextAlign.right,
            style: _microBold.copyWith(color: color),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Stack(
            children: [
              SizedBox(
                height: _timelineBarHeight,
                child: Material(
                  color: AppColors.surface3,
                  borderRadius: AppRadii.smRadius,
                ),
              ),
              FractionallySizedBox(
                widthFactor: widthFactor,
                child: SizedBox(
                  height: _timelineBarHeight,
                  child: Material(
                    color: color.withValues(alpha: .18),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.smRadius,
                      side: BorderSide(color: color.withValues(alpha: .3)),
                    ),
                    child: Padding(
                      padding: AppSpacing.earnHorizontalPaddingX2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${_money(rung.amountUsd)} · ${rung.apyPct.toStringAsFixed(1)}%',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: color,
                            fontWeight: AppTextStyles.bold,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MaturityTile extends StatelessWidget {
  const _MaturityTile({required this.rung});

  final SavingsLadderRungDraft rung;

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(rung.colorKey);
    final parts = rung.maturityDate.split('/');
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      density: VitDensity.compact,
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.savingsLadderMaturityBadgeWidth,
            height: _maturityBadgeHeight,
            child: Material(
              color: color.withValues(alpha: .12),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.mdRadius,
                side: BorderSide(color: color.withValues(alpha: .25)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(parts.first, style: _captionBold.copyWith(color: color)),
                  Text(
                    'T${parts[1]}',
                    style: AppTextStyles.micro.copyWith(color: color),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rung.product,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _captionBold.copyWith(color: AppColors.text1),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${_money(rung.amountUsd)} · ${rung.apyPct.toStringAsFixed(1)}% APY',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+${_money(_interestForTerm(rung))}',
                style: _captionBold.copyWith(
                  color: AppColors.buy,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              Text(
                rung.autoRenew ? 'Tự gia hạn' : 'Dừng',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CashFlowCard extends StatelessWidget {
  const _CashFlowCard({required this.rungs});

  final List<SavingsLadderRungDraft> rungs;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      borderColor: AppColors.buy20,
      density: VitDensity.compact,
      child: Column(
        children: [
          for (final rung in rungs) ...[
            _DetailRow(
              label: rung.maturityDate,
              value:
                  'Vốn ${_money(rung.amountUsd)}  +${_money(_interestForTerm(rung))}',
              color: AppColors.buy,
            ),
            if (rung != rungs.last) const Divider(color: AppColors.divider),
          ],
          const Divider(color: AppColors.divider),
          _DetailRow(
            label: 'Tổng',
            value:
                '${_money(_totalAllocated(rungs))}  +${_money(rungs.fold<double>(0, (total, rung) => total + _interestForTerm(rung)))}',
            color: AppColors.buy,
          ),
        ],
      ),
    );
  }
}

class _AnalysisTab extends StatelessWidget {
  const _AnalysisTab({
    required this.snapshot,
    required this.rungs,
    required this.amountUsd,
    required this.weightedApy,
    required this.annualInterest,
    required this.liquidityScore,
  });

  final SavingsLadderSnapshot snapshot;
  final List<SavingsLadderRungDraft> rungs;
  final int amountUsd;
  final double weightedApy;
  final double annualInterest;
  final int liquidityScore;

  @override
  Widget build(BuildContext context) {
    if (rungs.isEmpty) {
      return _EmptyTab(
        icon: Icons.bar_chart_rounded,
        title: 'Tạo ladder để xem phân tích',
        cta: 'Bắt đầu xây',
      );
    }

    final avgLockDays =
        rungs.fold<int>(0, (total, rung) => total + rung.lockDays) ~/
        rungs.length;
    return VitPageContent(
      key: SavingsLadderPage.analysisKey,
      padding: VitContentPadding.none,
      fullBleed: true,
      gap: VitContentGap.tight,
      children: [
        _MetricGrid(
          metrics: [
            _Metric(
              'APY bình quân',
              '${weightedApy.toStringAsFixed(2)}%',
              Icons.trending_up_rounded,
              AppColors.buy,
            ),
            _Metric(
              'Thanh khoản',
              '$liquidityScore/100',
              Icons.bolt_rounded,
              _liquidityColor(liquidityScore),
            ),
            _Metric(
              'Lock TB',
              '$avgLockDays ngày',
              Icons.lock_outline_rounded,
              AppColors.warn,
            ),
            _Metric(
              'Lãi dự kiến/năm',
              _money(annualInterest),
              Icons.attach_money_rounded,
              AppColors.buy,
            ),
          ],
        ),
        const _SectionTitle(label: 'Phân bổ theo tài sản'),
        _AssetBreakdown(rungs: rungs),
        const _SectionTitle(label: 'Phân bổ theo thời hạn'),
        _DurationBreakdown(rungs: rungs),
        const _SectionTitle(label: 'Đánh giá thanh khoản'),
        _LiquidityCard(score: liquidityScore, rungs: rungs),
        _OptimizationTip(
          weightedApy: weightedApy,
          liquidityScore: liquidityScore,
        ),
        EarnDisclaimerBanner(
          text: snapshot.disclaimer,
          lineHeight: _disclaimerLineHeight,
        ),
      ],
    );
  }
}

class _Metric {
  const _Metric(this.label, this.value, this.icon, this.color);

  final String label;
  final String value;
  final IconData icon;
  final Color color;
}


class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.metrics});

  final List<_Metric> metrics;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: AppSpacing.savingsLadderMetricGridColumns,
      childAspectRatio: AppSpacing.savingsLadderGridAspect,
      crossAxisSpacing: AppSpacing.x3,
      mainAxisSpacing: AppSpacing.x3,
      children: [
        for (final metric in metrics)
          VitCard(
            radius: VitCardRadius.large,
            density: VitDensity.compact,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      metric.icon,
                      color: metric.color,
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        metric.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  metric.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.base.copyWith(
                    color: metric.color,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _AssetBreakdown extends StatelessWidget {
  const _AssetBreakdown({required this.rungs});

  final List<SavingsLadderRungDraft> rungs;

  @override
  Widget build(BuildContext context) {
    final total = _totalAllocated(rungs);
    final byAsset = <String, _AssetBucket>{};
    for (final rung in rungs) {
      final current = byAsset[rung.asset] ?? _AssetBucket(rung.colorKey);
      byAsset[rung.asset] = current.add(rung);
    }
    return VitCard(
      radius: VitCardRadius.large,
      density: VitDensity.compact,
      child: Column(
        children: [
          for (final entry in byAsset.entries) ...[
            _BreakdownRow(
              label: entry.key,
              caption: '${entry.value.count} bậc',
              value: _money(entry.value.totalUsd),
              percent: total <= 0 ? 0 : entry.value.totalUsd / total,
              color: _colorFor(entry.value.colorKey),
            ),
            if (entry.key != byAsset.keys.last)
              const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _AssetBucket {
  const _AssetBucket(this.colorKey, {this.totalUsd = 0, this.count = 0});

  final String colorKey;
  final double totalUsd;
  final int count;

  _AssetBucket add(SavingsLadderRungDraft rung) {
    return _AssetBucket(
      colorKey,
      totalUsd: totalUsd + rung.amountUsd,
      count: count + 1,
    );
  }
}

class _DurationBreakdown extends StatelessWidget {
  const _DurationBreakdown({required this.rungs});

  final List<SavingsLadderRungDraft> rungs;

  @override
  Widget build(BuildContext context) {
    final total = _totalAllocated(rungs);
    return VitPageContent(
      padding: VitContentPadding.none,
      fullBleed: true,
      gap: VitContentGap.tight,
      children: [
        for (final days in [30, 60, 90]) ...[
          if (rungs.any((rung) => rung.lockDays == days))
            _DurationTile(days: days, rungs: rungs, totalUsd: total),
        ],
      ],
    );
  }
}

class _DurationTile extends StatelessWidget {
  const _DurationTile({
    required this.days,
    required this.rungs,
    required this.totalUsd,
  });

  final int days;
  final List<SavingsLadderRungDraft> rungs;
  final double totalUsd;

  @override
  Widget build(BuildContext context) {
    final dayRungs = rungs.where((rung) => rung.lockDays == days).toList();
    final amount = _totalAllocated(dayRungs);
    final pct = totalUsd <= 0 ? 0.0 : amount / totalUsd;
    final avgApy = dayRungs.isEmpty
        ? 0.0
        : dayRungs.fold<double>(0, (total, rung) => total + rung.apyPct) /
              dayRungs.length;
    final color = days <= 30
        ? AppColors.buy
        : days <= 60
        ? AppColors.primary
        : AppColors.accent;
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      density: VitDensity.compact,
      child: Row(
        children: [
          _RoundIcon(icon: Icons.schedule_rounded, color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${dayRungs.length} bậc · ${(pct * 100).toStringAsFixed(0)}%',
                  style: _captionBold.copyWith(color: AppColors.text1),
                ),
                Text(
                  '${_money(amount)} · APY TB: ${avgApy.toStringAsFixed(1)}%',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Text(
            '${avgApy.toStringAsFixed(1)}%',
            style: _captionBold.copyWith(color: AppColors.buy),
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.label,
    required this.caption,
    required this.value,
    required this.percent,
    required this.color,
  });

  final String label;
  final String caption;
  final String value;
  final double percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox.square(
              dimension: AppSpacing.savingsLadderBreakdownDot,
              child: Material(color: color, shape: const CircleBorder()),
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(label, style: _captionBold.copyWith(color: AppColors.text1)),
            const SizedBox(width: AppSpacing.x2),
            Text(caption, style: AppTextStyles.micro),
            const Expanded(child: SizedBox.shrink()),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              '${(percent * 100).toStringAsFixed(0)}%',
              style: _captionBold.copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.pillRadius,
          child: LinearProgressIndicator(
            minHeight: AppSpacing.x1,
            value: percent.clamp(0.0, 1.0),
            color: color,
            backgroundColor: AppColors.surface3,
          ),
        ),
      ],
    );
  }
}

class _LiquidityCard extends StatelessWidget {
  const _LiquidityCard({required this.score, required this.rungs});

  final int score;
  final List<SavingsLadderRungDraft> rungs;

  @override
  Widget build(BuildContext context) {
    final color = _liquidityColor(score);
    final label = score >= 70
        ? 'Cao'
        : score >= 40
        ? 'Trung bình'
        : 'Thấp';
    return VitCard(
      radius: VitCardRadius.large,
      borderColor: color.withValues(alpha: .25),
      density: VitDensity.compact,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: _liquidityRingSize,
                height: _liquidityRingSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: score / 100,
                      color: color,
                      backgroundColor: AppColors.surface3,
                      strokeWidth: 7,
                    ),
                    Text(
                      '$score',
                      style: AppTextStyles.base.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thanh khoản $label',
                      style: _captionBold.copyWith(color: AppColors.text1),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      score >= 70
                          ? 'Ladder được phân bổ tốt, đảm bảo dòng tiền liên tục và linh hoạt.'
                          : score >= 40
                          ? 'Cần thêm bậc ngắn hạn để tăng tính linh hoạt khi cần rút.'
                          : 'Hầu hết vốn bị khóa dài hạn. Cân nhắc thêm bậc 30D.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        height: _liquidityLineHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _LiquidityMini(
                  label: 'Ngắn hạn',
                  value: _money(
                    rungs
                        .where((rung) => rung.lockDays <= 30)
                        .fold<double>(
                          0,
                          (total, rung) => total + rung.amountUsd,
                        ),
                  ),
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _LiquidityMini(
                  label: 'Trung hạn',
                  value: _money(
                    rungs
                        .where((rung) => rung.lockDays == 60)
                        .fold<double>(
                          0,
                          (total, rung) => total + rung.amountUsd,
                        ),
                  ),
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _LiquidityMini(
                  label: 'Dài hạn',
                  value: _money(
                    rungs
                        .where((rung) => rung.lockDays >= 90)
                        .fold<double>(
                          0,
                          (total, rung) => total + rung.amountUsd,
                        ),
                  ),
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LiquidityMini extends StatelessWidget {
  const _LiquidityMini({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _microBold.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _OptimizationTip extends StatelessWidget {
  const _OptimizationTip({
    required this.weightedApy,
    required this.liquidityScore,
  });

  final double weightedApy;
  final int liquidityScore;

  @override
  Widget build(BuildContext context) {
    final text = weightedApy < 5
        ? 'Tăng tỷ trọng sản phẩm APY cao để cải thiện lãi suất bình quân.'
        : liquidityScore < 50
        ? 'Thêm bậc 30D để đảm bảo thanh khoản và giảm rủi ro khóa vốn quá lâu.'
        : 'Ladder hiện tại cân bằng tốt giữa lãi suất và thanh khoản. Bật auto-renew để tối ưu liên tục.';
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: AppColors.accent20,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.accent,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gợi ý tối ưu', style: _captionBold),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _disclaimerLineHeight,
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

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: selected,
      onTap: onTap,
      fullWidth: true,
      height: AppSpacing.buttonCompact,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: AppSpacing.savingsLadderSectionMarkerWidth,
          height: _sectionMarkerHeight,
          child: Material(
            color: AppColors.primary,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            label,
            style: _microBold.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}


class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .14),
      borderRadius: AppRadii.xsRadius,
      child: Padding(
        padding: AppSpacing.earnSmallPillPadding,
        child: Text(label, style: _microBold.copyWith(color: color)),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.savingsLadderRoundIcon,
      child: Material(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.mdRadius,
        child: Icon(icon, color: color, size: AppSpacing.iconSm),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.earnVerticalPaddingX1,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: _captionBold.copyWith(
                color: color ?? AppColors.text1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTab extends StatelessWidget {
  const _EmptyTab({required this.icon, required this.title, required this.cta});

  final IconData icon;
  final String title;
  final String cta;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      density: VitDensity.compact,
      child: Column(
        children: [
          Icon(icon, color: AppColors.text3, size: AppSpacing.iconLg),
          const SizedBox(height: AppSpacing.x2),
          Text(
            title,
            textAlign: TextAlign.center,
            style: _captionBold.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x2),
          VitCtaButton(fullWidth: false, onPressed: () {}, child: Text(cta)),
        ],
      ),
    );
  }
}

SavingsLadderTemplateDraft _templateById(
  SavingsLadderSnapshot snapshot,
  SavingsLadderPreset id,
) {
  return snapshot.templates.firstWhere(
    (template) => template.id == id,
    orElse: () => snapshot.templates.first,
  );
}

List<SavingsLadderRungDraft> _generateRungs(
  SavingsLadderTemplateDraft template,
  int amountUsd,
) {
  if (template.intervals.isEmpty) return const [];
  return [
    for (var i = 0; i < template.intervals.length; i++)
      SavingsLadderRungDraft(
        id: 'rung-${i + 1}',
        product: template.intervals[i].product,
        asset: template.intervals[i].asset,
        colorKey: template.intervals[i].colorKey,
        lockDays: template.intervals[i].lockDays,
        apyPct: template.intervals[i].apyPct,
        amountUsd:
            (amountUsd * template.intervals[i].allocationPct / 100 * 100)
                .round() /
            100,
        startDate: _today,
        maturityDate: _addDays(_today, template.intervals[i].lockDays + i * 30),
        autoRenew: true,
      ),
  ];
}

double _totalAllocated(List<SavingsLadderRungDraft> rungs) {
  return rungs.fold<double>(0, (total, rung) => total + rung.amountUsd);
}

double _weightedApy(List<SavingsLadderRungDraft> rungs) {
  final total = _totalAllocated(rungs);
  if (total <= 0) return 0;
  return rungs.fold<double>(
        0,
        (sum, rung) => sum + (rung.apyPct * rung.amountUsd),
      ) /
      total;
}

double _annualInterest(List<SavingsLadderRungDraft> rungs) {
  return rungs.fold<double>(
    0,
    (sum, rung) => sum + rung.amountUsd * rung.apyPct / 100,
  );
}

double _interestForTerm(SavingsLadderRungDraft rung) {
  return rung.amountUsd * rung.apyPct / 100 * rung.lockDays / 365;
}

int _liquidityScore(List<SavingsLadderRungDraft> rungs) {
  final total = _totalAllocated(rungs);
  if (rungs.isEmpty || total <= 0) return 0;
  final uniqueDays = rungs.map((rung) => rung.lockDays).toSet().length;
  final shortTermUsd = rungs
      .where((rung) => rung.lockDays <= 30)
      .fold<double>(0, (sum, rung) => sum + rung.amountUsd);
  final diversityScore = math.min(uniqueDays / 3 * 40, 40);
  final shortTermScore = math.min((shortTermUsd / total * 100) / 40 * 30, 30);
  final spreadScore = math.min(rungs.length / 6 * 30, 30);
  return (diversityScore + shortTermScore + spreadScore).round();
}

String _addDays(String from, int days) {
  final parts = from.split('/').map(int.parse).toList();
  final date = DateTime(parts[2], parts[1], parts[0]).add(Duration(days: days));
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

String _money(num value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  return '\$$buffer.${parts.last}';
}

String _compactAmount(int value) {
  if (value >= 1000) return '${value ~/ 1000}K';
  return '$value';
}

IconData _iconFor(String key) {
  return switch (key) {
    'calendar' => Icons.calendar_today_rounded,
    'bars' => Icons.bar_chart_rounded,
    'layers' => Icons.layers_rounded,
    'sliders' => Icons.tune_rounded,
    _ => Icons.savings_outlined,
  };
}

Color _toneColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.primary,
    EarnRiskLevel.high => AppColors.accent,
  };
}

Color _colorFor(String colorKey) {
  return switch (colorKey) {
    'buy' => AppColors.buy,
    'primary' => AppColors.primary,
    'warn' => AppColors.warn,
    'accent' => AppColors.accent,
    'sell' => AppColors.sell,
    _ => AppColors.text3,
  };
}

Color _liquidityColor(int score) {
  if (score >= 70) return AppColors.buy;
  if (score >= 40) return AppColors.warn;
  return AppColors.sell;
}

