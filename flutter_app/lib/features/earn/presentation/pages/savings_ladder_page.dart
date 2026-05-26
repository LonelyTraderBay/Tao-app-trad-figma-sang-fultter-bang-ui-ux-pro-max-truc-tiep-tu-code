import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/earn/data/earn_repository.dart';

const _today = '09/03/2026';

TextStyle get _captionBold =>
    AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.bold);
TextStyle get _microBold =>
    AppTextStyles.micro.copyWith(fontWeight: AppTextStyles.bold);

class SavingsLadderPage extends ConsumerStatefulWidget {
  const SavingsLadderPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc351_summary');
  static const amountKey = Key('sc351_amount');
  static const templatesKey = Key('sc351_templates');
  static const rungsKey = Key('sc351_rungs');
  static const timelineKey = Key('sc351_timeline');
  static const analysisKey = Key('sc351_analysis');
  static const addRungKey = Key('sc351_add_rung');
  static const confirmKey = Key('sc351_confirm');

  static Key presetKey(SavingsLadderPreset preset) =>
      Key('sc351_preset_${preset.name}');
  static Key amountChipKey(int amount) => Key('sc351_amount_$amount');
  static Key rungKey(String id) => Key('sc351_rung_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsLadderPage> createState() => _SavingsLadderPageState();
}

class _SavingsLadderPageState extends ConsumerState<SavingsLadderPage> {
  String? _tab;
  SavingsLadderPreset? _preset;
  int? _amountUsd;
  List<SavingsLadderRungDraft>? _customRungs;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(savingsLadderRepositoryProvider).getLadder();
    final activeTab = _tab ?? snapshot.defaultTab;
    final selectedPreset = _preset ?? snapshot.defaultPreset;
    final amountUsd = _amountUsd ?? snapshot.defaultAmountUsd;
    final template = _templateById(snapshot, selectedPreset);
    final rungs = selectedPreset == SavingsLadderPreset.custom
        ? (_customRungs ?? const <SavingsLadderRungDraft>[])
        : _generateRungs(template, amountUsd);
    final totalAllocated = _totalAllocated(rungs);
    final weightedApy = _weightedApy(rungs);
    final annualInterest = _annualInterest(rungs);
    final liquidityScore = _liquidityScore(rungs);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-351 SavingsLadderPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _LadderHero(
                      snapshot: snapshot,
                      amountUsd: amountUsd,
                      annualInterest: annualInterest,
                      rungCount: rungs.length,
                      weightedApy: weightedApy,
                      liquidityScore: liquidityScore,
                    ),
                    _LadderTabs(
                      tabs: snapshot.tabs,
                      active: activeTab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _tab = tab);
                      },
                    ),
                    if (activeTab == 'builder')
                      ..._buildBuilder(
                        snapshot,
                        amountUsd,
                        selectedPreset,
                        rungs,
                        totalAllocated,
                      )
                    else if (activeTab == 'timeline')
                      _TimelineTab(snapshot: snapshot, rungs: rungs)
                    else
                      _AnalysisTab(
                        snapshot: snapshot,
                        rungs: rungs,
                        amountUsd: amountUsd,
                        weightedApy: weightedApy,
                        annualInterest: annualInterest,
                        liquidityScore: liquidityScore,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBuilder(
    SavingsLadderSnapshot snapshot,
    int amountUsd,
    SavingsLadderPreset selectedPreset,
    List<SavingsLadderRungDraft> rungs,
    double totalAllocated,
  ) {
    final unallocated = amountUsd - totalAllocated;
    return [
      const _SectionTitle(label: 'Tổng vốn (USD)'),
      _AmountSelector(
        amountUsd: amountUsd,
        quickAmounts: snapshot.quickAmounts,
        onChanged: (value) {
          HapticFeedback.selectionClick();
          setState(() => _amountUsd = value);
        },
      ),
      const _SectionTitle(label: 'Chiến lược ladder'),
      _TemplateList(
        templates: snapshot.templates,
        selected: selectedPreset,
        amountUsd: amountUsd,
        onChanged: (preset) {
          HapticFeedback.selectionClick();
          setState(() {
            _preset = preset;
            _customRungs = preset == SavingsLadderPreset.custom
                ? _generateRungs(
                    _templateById(snapshot, selectedPreset),
                    amountUsd,
                  )
                : null;
          });
        },
      ),
      _SectionTitle(label: 'Các bậc ladder (${rungs.length})'),
      _RungList(
        rungs: rungs,
        onToggleRenew: _toggleAutoRenew,
        onRemove: _removeRung,
      ),
      _AddRungButton(
        onTap: () => _addProduct(snapshot.availableProducts.first, rungs),
      ),
      _AllocationStatus(
        amountUsd: amountUsd,
        totalAllocated: totalAllocated,
        unallocated: unallocated,
      ),
      if (rungs.isNotEmpty)
        VitCtaButton(
          key: SavingsLadderPage.confirmKey,
          onPressed: () => _showConfirmSheet(snapshot, rungs, amountUsd),
          leading: const Icon(Icons.layers_rounded),
          child: Text('Xác nhận Ladder · ${rungs.length} bậc'),
        ),
      _Disclaimer(text: snapshot.disclaimer),
    ];
  }

  void _removeRung(String id) {
    final snapshot = ref.read(savingsLadderRepositoryProvider).getLadder();
    final amountUsd = _amountUsd ?? snapshot.defaultAmountUsd;
    final preset = _preset ?? snapshot.defaultPreset;
    final current = preset == SavingsLadderPreset.custom
        ? (_customRungs ?? const <SavingsLadderRungDraft>[])
        : _generateRungs(_templateById(snapshot, preset), amountUsd);
    HapticFeedback.mediumImpact();
    setState(() {
      _preset = SavingsLadderPreset.custom;
      _customRungs = current.where((rung) => rung.id != id).toList();
    });
  }

  void _toggleAutoRenew(String id) {
    final snapshot = ref.read(savingsLadderRepositoryProvider).getLadder();
    final amountUsd = _amountUsd ?? snapshot.defaultAmountUsd;
    final preset = _preset ?? snapshot.defaultPreset;
    final current = preset == SavingsLadderPreset.custom
        ? (_customRungs ?? const <SavingsLadderRungDraft>[])
        : _generateRungs(_templateById(snapshot, preset), amountUsd);
    HapticFeedback.selectionClick();
    setState(() {
      _preset = SavingsLadderPreset.custom;
      _customRungs = [
        for (final rung in current)
          if (rung.id == id)
            SavingsLadderRungDraft(
              id: rung.id,
              product: rung.product,
              asset: rung.asset,
              colorKey: rung.colorKey,
              lockDays: rung.lockDays,
              apyPct: rung.apyPct,
              amountUsd: rung.amountUsd,
              startDate: rung.startDate,
              maturityDate: rung.maturityDate,
              autoRenew: !rung.autoRenew,
            )
          else
            rung,
      ];
    });
  }

  void _addProduct(
    SavingsLadderProductDraft product,
    List<SavingsLadderRungDraft> current,
  ) {
    final amountUsd = _amountUsd ?? 10000;
    final allocated = _totalAllocated(current);
    final amount = math.max(100, amountUsd - allocated).toDouble();
    HapticFeedback.mediumImpact();
    setState(() {
      _preset = SavingsLadderPreset.custom;
      _customRungs = [
        ...current,
        SavingsLadderRungDraft(
          id: 'custom-${current.length + 1}',
          product: product.product,
          asset: product.asset,
          colorKey: product.colorKey,
          lockDays: product.lockDays,
          apyPct: product.apyPct,
          amountUsd: amount,
          startDate: _today,
          maturityDate: _addDays(_today, product.lockDays),
          autoRenew: true,
        ),
      ];
    });
  }

  void _showConfirmSheet(
    SavingsLadderSnapshot snapshot,
    List<SavingsLadderRungDraft> rungs,
    int amountUsd,
  ) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const _RoundIcon(
                        icon: Icons.layers_rounded,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: Text('Xác nhận ladder', style: _captionBold),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  _DetailRow(label: 'Tổng vốn', value: _money(amountUsd)),
                  _DetailRow(label: 'Số bậc', value: '${rungs.length}'),
                  _DetailRow(
                    label: 'APY bình quân',
                    value: '${_weightedApy(rungs).toStringAsFixed(1)}%',
                    color: AppColors.buy,
                  ),
                  _DetailRow(
                    label: 'Lãi dự kiến/năm',
                    value: '+${_money(_annualInterest(rungs))}',
                    color: AppColors.buy,
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  _Disclaimer(text: snapshot.disclaimer),
                  const SizedBox(height: AppSpacing.x4),
                  VitCtaButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Xác nhận tạo ladder'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

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
                  width: 6,
                  height: 6,
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
    return Column(
      key: SavingsLadderPage.amountKey,
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
        const SizedBox(height: AppSpacing.x3),
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
    return Column(
      key: SavingsLadderPage.templatesKey,
      children: [
        for (final template in templates) ...[
          _TemplateCard(
            template: template,
            selected: template.id == selected,
            amountUsd: amountUsd,
            onTap: () => onChanged(template.id),
          ),
          if (template != templates.last) const SizedBox(height: AppSpacing.x3),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  template.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _captionBold.copyWith(color: AppColors.text1),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  template.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
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

    return Column(
      key: SavingsLadderPage.rungsKey,
      children: [
        for (var i = 0; i < rungs.length; i++) ...[
          _RungTile(
            index: i + 1,
            rung: rungs[i],
            onToggleRenew: () => onToggleRenew(rungs[i].id),
            onRemove: () => onRemove(rungs[i].id),
          ),
          if (i != rungs.length - 1) const SizedBox(height: AppSpacing.x3),
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
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .14),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: .35)),
            ),
            alignment: Alignment.center,
            child: Text('$index', style: _microBold.copyWith(color: color)),
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
          IconButton(
            tooltip: rung.autoRenew ? 'Tắt tự gia hạn' : 'Bật tự gia hạn',
            onPressed: onToggleRenew,
            icon: Icon(
              rung.autoRenew ? Icons.autorenew_rounded : Icons.block_flipped,
              color: rung.autoRenew ? AppColors.buy : AppColors.text3,
              size: AppSpacing.iconSm,
            ),
          ),
          IconButton(
            tooltip: 'Xóa bậc',
            onPressed: onRemove,
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.sell,
              size: AppSpacing.iconSm,
            ),
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
      radius: VitCardRadius.lg,
      borderColor: AppColors.primary30,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
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
      padding: const EdgeInsets.all(AppSpacing.x3),
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
            width: 96,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 6,
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
    return Column(
      key: SavingsLadderPage.timelineKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle(label: 'Lịch đáo hạn'),
        _TimelineChart(rungs: sorted),
        const SizedBox(height: AppSpacing.x5),
        const _SectionTitle(label: 'Lịch trình đáo hạn'),
        for (final rung in sorted) ...[
          _MaturityTile(rung: rung),
          const SizedBox(height: AppSpacing.x3),
        ],
        const _SectionTitle(label: 'Dự kiến dòng tiền'),
        _CashFlowCard(rungs: sorted),
        const SizedBox(height: AppSpacing.x3),
        _Disclaimer(text: snapshot.disclaimer),
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
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Hôm nay',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const Spacer(),
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
          width: 58,
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
              Container(
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.surface3,
                  borderRadius: AppRadii.smRadius,
                ),
              ),
              FractionallySizedBox(
                widthFactor: widthFactor,
                child: Container(
                  height: 24,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .18),
                    border: Border.all(color: color.withValues(alpha: .3)),
                    borderRadius: AppRadii.smRadius,
                  ),
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
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              border: Border.all(color: color.withValues(alpha: .25)),
              borderRadius: AppRadii.mdRadius,
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
      radius: VitCardRadius.lg,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x4),
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
    return Column(
      key: SavingsLadderPage.analysisKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
        const SizedBox(height: AppSpacing.x5),
        const _SectionTitle(label: 'Phân bổ theo tài sản'),
        _AssetBreakdown(rungs: rungs),
        const SizedBox(height: AppSpacing.x5),
        const _SectionTitle(label: 'Phân bổ theo thời hạn'),
        _DurationBreakdown(rungs: rungs),
        const SizedBox(height: AppSpacing.x5),
        const _SectionTitle(label: 'Đánh giá thanh khoản'),
        _LiquidityCard(score: liquidityScore, rungs: rungs),
        const SizedBox(height: AppSpacing.x3),
        _OptimizationTip(
          weightedApy: weightedApy,
          liquidityScore: liquidityScore,
        ),
        const SizedBox(height: AppSpacing.x3),
        _Disclaimer(text: snapshot.disclaimer),
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
      crossAxisCount: 2,
      childAspectRatio: 1.72,
      crossAxisSpacing: AppSpacing.x3,
      mainAxisSpacing: AppSpacing.x3,
      children: [
        for (final metric in metrics)
          VitCard(
            radius: VitCardRadius.lg,
            padding: const EdgeInsets.all(AppSpacing.x3),
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
                const Spacer(),
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
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
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
    return Column(
      children: [
        for (final days in [30, 60, 90]) ...[
          if (rungs.any((rung) => rung.lockDays == days))
            _DurationTile(days: days, rungs: rungs, totalUsd: total),
          if (days != 90) const SizedBox(height: AppSpacing.x3),
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
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
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
            Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(label, style: _captionBold.copyWith(color: AppColors.text1)),
            const SizedBox(width: AppSpacing.x2),
            Text(caption, style: AppTextStyles.micro),
            const Spacer(),
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
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 6,
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
      radius: VitCardRadius.lg,
      borderColor: color.withValues(alpha: .25),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 66,
                height: 66,
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
                        height: 1.3,
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
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x2),
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
      padding: const EdgeInsets.all(AppSpacing.x3),
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
                    height: 1.35,
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
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary12 : Colors.transparent,
            border: Border.all(
              color: selected ? AppColors.primary30 : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: _captionBold.copyWith(
              color: selected ? AppColors.primary : AppColors.text2,
            ),
          ),
        ),
      ),
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
        Container(
          width: 4,
          height: 15,
          decoration: const BoxDecoration(
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
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
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: AppSpacing.iconSm),
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
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x1),
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

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.35,
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
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x6),
      child: Column(
        children: [
          Icon(icon, color: AppColors.text3, size: AppSpacing.iconLg),
          const SizedBox(height: AppSpacing.x3),
          Text(
            title,
            textAlign: TextAlign.center,
            style: _captionBold.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x4),
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
