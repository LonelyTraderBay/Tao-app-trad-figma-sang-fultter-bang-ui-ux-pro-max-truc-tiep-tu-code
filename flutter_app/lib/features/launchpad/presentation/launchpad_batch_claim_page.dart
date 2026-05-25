import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/launchpad_repository.dart';

enum _BatchClaimStep { select, review, success }

class LaunchpadBatchClaimPage extends ConsumerStatefulWidget {
  const LaunchpadBatchClaimPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc304_launchpad_batch_claim_content');
  static const heroKey = Key('sc304_launchpad_batch_claim_hero');
  static const gasKey = Key('sc304_launchpad_batch_claim_gas');
  static const warningKey = Key('sc304_launchpad_batch_claim_warning');
  static const ctaKey = Key('sc304_launchpad_batch_claim_cta');
  static const reviewKey = Key('sc304_launchpad_batch_claim_review');
  static const successKey = Key('sc304_launchpad_batch_claim_success');

  static Key positionKey(String id) =>
      Key('sc304_launchpad_batch_claim_position_$id');
  static Key checkboxKey(String id) =>
      Key('sc304_launchpad_batch_claim_checkbox_$id');
  static Key detailKey(String id) =>
      Key('sc304_launchpad_batch_claim_detail_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadBatchClaimPage> createState() =>
      _LaunchpadBatchClaimPageState();
}

class _LaunchpadBatchClaimPageState
    extends ConsumerState<LaunchpadBatchClaimPage> {
  var _step = _BatchClaimStep.select;
  late Set<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    final snapshot = const MockLaunchpadRepository().getBatchClaim();
    _selectedIds = snapshot.positions
        .map((position) => position.positionId)
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadRepositoryProvider).getBatchClaim();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navInset = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final footerHeight =
        _step == _BatchClaimStep.select && _selectedIds.isNotEmpty ? 92.0 : 0.0;
    final bottomInset = navInset + safeBottom + AppSpacing.x6 + footerHeight;
    final selectedPositions = snapshot.positions
        .where((position) => _selectedIds.contains(position.positionId))
        .toList();
    final selectedSummary = _summaryFor(selectedPositions);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-304 LaunchpadBatchClaimPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: _step == _BatchClaimStep.success
                      ? 'Hoàn tất'
                      : snapshot.title,
                  showBack: true,
                  onBack: () => context.go(snapshot.backRoute),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: LaunchpadBatchClaimPage.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.defaultPadding,
                      customGap: AppSpacing.x4,
                      children: [
                        if (_step == _BatchClaimStep.select) ...[
                          _BatchSummaryHero(summary: selectedSummary),
                          _GasSavingsBanner(summary: selectedSummary),
                          _SelectionHeader(
                            selected: _selectedIds.length,
                            total: snapshot.positions.length,
                            onSelectAll: () => setState(() {
                              _selectedIds = snapshot.positions
                                  .map((position) => position.positionId)
                                  .toSet();
                            }),
                            onClear: () => setState(_selectedIds.clear),
                          ),
                          for (final position in snapshot.positions)
                            _BatchPositionCard(
                              position: position,
                              selected: _selectedIds.contains(
                                position.positionId,
                              ),
                              onToggle: () => _toggle(position.positionId),
                              onDetail: () =>
                                  context.go(snapshot.claimReceiptRoute),
                            ),
                          if (selectedSummary.chains.length > 1)
                            _ChainWarning(summary: selectedSummary),
                        ] else if (_step == _BatchClaimStep.review)
                          _ReviewStep(
                            positions: selectedPositions,
                            summary: selectedSummary,
                            onBack: () =>
                                setState(() => _step = _BatchClaimStep.select),
                            onConfirm: () =>
                                setState(() => _step = _BatchClaimStep.success),
                          )
                        else
                          _SuccessStep(
                            positions: selectedPositions,
                            summary: selectedSummary,
                            onDone: () => context.go(snapshot.backRoute),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_step == _BatchClaimStep.select && _selectedIds.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: navInset + safeBottom,
                child: VitStickyFooter(
                  backgroundColor: AppColors.surface.withValues(alpha: .94),
                  child: VitCtaButton(
                    key: LaunchpadBatchClaimPage.ctaKey,
                    variant: VitCtaButtonVariant.success,
                    leading: const Icon(
                      Icons.bolt_rounded,
                      color: Colors.white,
                      size: AppSpacing.iconSm,
                    ),
                    onPressed: () =>
                        setState(() => _step = _BatchClaimStep.review),
                    child: Text(
                      'Nhận ${_selectedIds.length} vị trí - ~${_formatUsd(selectedSummary.totalClaimableUsd)}',
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _toggle(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }
}

class _BatchSummaryHero extends StatelessWidget {
  const _BatchSummaryHero({required this.summary});

  final LaunchpadBatchClaimSummaryDraft summary;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadBatchClaimPage.heroKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      borderColor: AppColors.buy.withValues(alpha: .18),
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.layers_outlined,
                color: AppColors.portfolioTextDim,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Tổng có thể nhận từ 2 vị trí',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextDim,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatUsd(summary.totalClaimableUsd),
                style: AppTextStyles.pageTitle.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.x1),
                child: Text(
                  'USD',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextMuted,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final entry in summary.totalClaimable.entries)
                _TokenPill(amount: entry.value, token: entry.key),
            ],
          ),
        ],
      ),
    );
  }
}

class _TokenPill extends StatelessWidget {
  const _TokenPill({required this.amount, required this.token});

  final double amount;
  final String token;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: AppColors.portfolioBtnGhost,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatNumber(amount),
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.x1),
          Text(
            token,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _GasSavingsBanner extends StatelessWidget {
  const _GasSavingsBanner({required this.summary});

  final LaunchpadBatchClaimSummaryDraft summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadBatchClaimPage.gasKey,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      ),
      decoration: BoxDecoration(
        color: AppColors.buy.withValues(alpha: .08),
        border: Border.all(color: AppColors.buy.withValues(alpha: .18)),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.buy15,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_gas_station_outlined,
              color: AppColors.buy,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tiết kiệm ~${summary.gasSavingsPercent}% gas',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'Batch: ${summary.estimatedGasBatch} vs Riêng lẻ: ${summary.estimatedGasIndividual} (tiết kiệm ~${_formatUsd(summary.gasSavingsUsd)})',
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

class _SelectionHeader extends StatelessWidget {
  const _SelectionHeader({
    required this.selected,
    required this.total,
    required this.onSelectAll,
    required this.onClear,
  });

  final int selected;
  final int total;
  final VoidCallback onSelectAll;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Chọn vị trí ($selected/$total)',
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        TextButton(onPressed: onSelectAll, child: const Text('Chọn tất cả')),
        Container(width: 1, height: 18, color: AppColors.divider),
        TextButton(onPressed: onClear, child: const Text('Bỏ chọn')),
      ],
    );
  }
}

class _BatchPositionCard extends StatelessWidget {
  const _BatchPositionCard({
    required this.position,
    required this.selected,
    required this.onToggle,
    required this.onDetail,
  });

  final LaunchpadBatchClaimPositionDraft position;
  final bool selected;
  final VoidCallback onToggle;
  final VoidCallback onDetail;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadBatchClaimPage.positionKey(position.positionId),
      radius: VitCardRadius.lg,
      borderColor: selected
          ? position.accent.withValues(alpha: .42)
          : AppColors.cardBorder,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: onToggle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            selected
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank_rounded,
            key: LaunchpadBatchClaimPage.checkboxKey(position.positionId),
            color: selected ? position.accent : AppColors.text3,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    _TokenAvatar(
                      label: _avatarLabel(position.projectSymbol),
                      color: position.accent,
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            position.projectName,
                            style: AppTextStyles.base.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          Text(
                            '${position.chain} · APY ${_trimDouble(position.apy)}% · ${_formatNumber(position.stakedAmount)} ${position.stakeToken} staked',
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
                const SizedBox(height: AppSpacing.x2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x3,
                    vertical: AppSpacing.x2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    borderRadius: AppRadii.lgRadius,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Có thể nhận',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  _formatNumber(position.claimableAmount),
                                  style: AppTextStyles.baseMedium.copyWith(
                                    color: AppColors.buy,
                                    fontWeight: AppTextStyles.bold,
                                    fontFeatures: AppTextStyles.tabularFigures,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.x2),
                                Text(
                                  position.rewardToken,
                                  style: AppTextStyles.micro.copyWith(
                                    color: AppColors.buy,
                                    fontWeight: AppTextStyles.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '~${_formatUsd(position.claimableUsd)} USD',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _CountBadge(count: position.vestingEntries.length),
                          TextButton(
                            key: LaunchpadBatchClaimPage.detailKey(
                              position.positionId,
                            ),
                            style: TextButton.styleFrom(
                              minimumSize: const Size(0, 30),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.x2,
                                vertical: AppSpacing.x1,
                              ),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: onDetail,
                            child: const Text('Chi tiết'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: AppSpacing.x2,
                    runSpacing: AppSpacing.x2,
                    children: [
                      for (final entry in position.vestingEntries)
                        _VestingPill(entry: entry),
                    ],
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

class _TokenAvatar extends StatelessWidget {
  const _TokenAvatar({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .18),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: AppColors.buy15,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Text(
        '$count đợt',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.buy,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _VestingPill extends StatelessWidget {
  const _VestingPill({required this.entry});

  final LaunchpadRewardVestingEntryDraft entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      decoration: BoxDecoration(
        color: AppColors.warn.withValues(alpha: .10),
        border: Border.all(color: AppColors.warn.withValues(alpha: .20)),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Text(
        '${entry.label}: ${_formatNumber(entry.amount)} ${entry.token}',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.warn,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _ChainWarning extends StatelessWidget {
  const _ChainWarning({required this.summary});

  final LaunchpadBatchClaimSummaryDraft summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadBatchClaimPage.warningKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.warn.withValues(alpha: .08),
        border: Border.all(color: AppColors.warn.withValues(alpha: .18)),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Các vị trí trên nhiều chain (${summary.chains.join(', ')}). Batch claim sẽ gửi giao dịch riêng cho mỗi chain.',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewStep extends StatelessWidget {
  const _ReviewStep({
    required this.positions,
    required this.summary,
    required this.onBack,
    required this.onConfirm,
  });

  final List<LaunchpadBatchClaimPositionDraft> positions;
  final LaunchpadBatchClaimSummaryDraft summary;
  final VoidCallback onBack;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: LaunchpadBatchClaimPage.reviewKey,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x5),
          child: Column(
            children: [
              const Icon(
                Icons.layers_outlined,
                color: AppColors.buy,
                size: AppSpacing.iconLg,
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                'Xác nhận Batch Claim',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                'Nhận phần thưởng từ ${positions.length} vị trí cùng lúc',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: AppSpacing.x5),
              for (final entry in summary.totalClaimable.entries)
                _ReviewTotalRow(token: entry.key, amount: entry.value),
              const Divider(color: AppColors.divider),
              _ReviewTotalRow(
                token: 'Tổng giá trị',
                amount: summary.totalClaimableUsd,
                usd: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Row(
          children: [
            Expanded(
              child: VitCtaButton(
                variant: VitCtaButtonVariant.ghost,
                onPressed: onBack,
                child: const Text('Quay lại'),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitCtaButton(
                variant: VitCtaButtonVariant.success,
                onPressed: onConfirm,
                child: const Text('Nhận tất cả'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReviewTotalRow extends StatelessWidget {
  const _ReviewTotalRow({
    required this.token,
    required this.amount,
    this.usd = false,
  });

  final String token;
  final double amount;
  final bool usd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              token,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          Text(
            usd ? _formatUsd(amount) : _formatNumber(amount),
            style: AppTextStyles.base.copyWith(
              color: usd ? AppColors.buy : AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessStep extends StatelessWidget {
  const _SuccessStep({
    required this.positions,
    required this.summary,
    required this.onDone,
  });

  final List<LaunchpadBatchClaimPositionDraft> positions;
  final LaunchpadBatchClaimSummaryDraft summary;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: LaunchpadBatchClaimPage.successKey,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x5),
          child: Column(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
                size: 48,
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                'Batch Claim thành công!',
                textAlign: TextAlign.center,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                'Đã nhận phần thưởng từ ${positions.length} vị trí',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                '~${_formatUsd(summary.totalClaimableUsd)}',
                style: AppTextStyles.pageTitle.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCtaButton(
          variant: VitCtaButtonVariant.success,
          onPressed: onDone,
          child: const Text('Hoàn tất'),
        ),
      ],
    );
  }
}

LaunchpadBatchClaimSummaryDraft _summaryFor(
  List<LaunchpadBatchClaimPositionDraft> positions,
) {
  final totals = <String, double>{};
  var totalUsd = 0.0;
  final chains = <String>{};
  for (final position in positions) {
    totals[position.rewardToken] =
        (totals[position.rewardToken] ?? 0) + position.claimableAmount;
    totalUsd += position.claimableUsd;
    chains.add(position.chain);
  }
  final individualGas = positions.length * .18;
  final batchGas = positions.isEmpty ? 0.0 : .18 + (positions.length - 1) * .06;
  final savings = individualGas - batchGas;
  return LaunchpadBatchClaimSummaryDraft(
    totalClaimable: totals,
    totalClaimableUsd: _round2(totalUsd),
    estimatedGasIndividual: _formatUsd(individualGas),
    estimatedGasBatch: _formatUsd(batchGas),
    gasSavingsPercent: individualGas == 0
        ? 0
        : ((savings / individualGas) * 100).round(),
    gasSavingsUsd: _round2(savings),
    chains: chains.toList(),
  );
}

String _avatarLabel(String symbol) {
  return symbol.length > 2 ? symbol.substring(0, 2) : symbol;
}

String _formatUsd(double value) {
  final formatted = _trimDouble(value);
  return '\$$formatted';
}

String _formatNumber(num value) {
  final fixed = value is int || value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
  final parts = fixed.split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    final remaining = integer.length - i;
    buffer.write(integer[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  if (parts.length > 1 && parts.last.isNotEmpty) {
    buffer.write('.');
    buffer.write(parts.last);
  }
  return buffer.toString();
}

String _trimDouble(double value) {
  if (value == value.roundToDouble()) return value.toInt().toString();
  return value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
}

double _round2(double value) => (value * 100).round() / 100;
