import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

part 'savings_ladder_page_part_01.dart';
part 'savings_ladder_page_part_02.dart';
part 'savings_ladder_page_part_03.dart';
part 'savings_ladder_page_part_04.dart';

const _today = '09/03/2026';
const _visualNavClearance = 90.0;
const _nativeNavClearance = 72.0;
const _visualScrollExtra = 28.0;
const _nativeScrollExtra = 20.0;
const _templateLineHeight = 1.18;
const _timelineBarHeight = 20.0;
const _maturityBadgeHeight = 44.0;
const _liquidityRingSize = 56.0;
const _liquidityLineHeight = 1.22;
const _sectionMarkerHeight = 12.0;
const _disclaimerLineHeight = 1.22;

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
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _visualNavClearance + _visualScrollExtra
            : _nativeNavClearance + _nativeScrollExtra) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-351 SavingsLadderPage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsetsDirectional.only(bottom: scrollEndPadding),
                  child: VitPageContent(
                    density: VitDensity.compact,
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
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        density: VitDensity.compact,
                        title: 'Savings ladder confirmation review',
                        message:
                            'Capital allocation, rung schedule, APY estimate, liquidity score, auto-renew flags, confirmation sheet, success state, and risk disclaimer are reviewed before a ladder is created.',
                        contractId: 'SC-351',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
    showVitBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return SafeArea(
          child: Material(
            color: AppColors.surface,
            borderRadius: AppRadii.sheetTopLargeRadius,
            child: Padding(
              padding: AppSpacing.earnPaddingX5,
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
