import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
part '../widgets/launchpad_batch_claim_summary.dart';
part '../widgets/launchpad_batch_claim_selection.dart';
part '../widgets/launchpad_batch_claim_review_success.dart';

enum _BatchClaimStep { select, review, success }

class LaunchpadBatchClaimPage extends ConsumerStatefulWidget {
  const LaunchpadBatchClaimPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc304_launchpad_batch_claim_content');
  static const heroKey = Key('sc304_launchpad_batch_claim_hero');
  static const gasKey = Key('sc304_launchpad_batch_claim_gas');
  static const warningKey = Key('sc304_launchpad_batch_claim_warning');
  static const ctaKey = Key('sc304_launchpad_batch_claim_cta');
  static const reviewKey = Key('sc304_launchpad_batch_claim_review');
  static const reviewStateKey = Key('sc304_launchpad_batch_claim_review_state');
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
    final snapshot = ref.read(launchpadControllerProvider).getBatchClaim();
    _selectedIds = snapshot.positions
        .map((position) => position.positionId)
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadControllerProvider).getBatchClaim();
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
            VitAutoHideHeaderScaffold(
              bottomInset: bottomInset,
              semanticLabel: 'SC-304 LaunchpadBatchClaimPage scroll surface',
              header: VitHeader(
                title: _step == _BatchClaimStep.success
                    ? 'Hoàn tất'
                    : snapshot.title,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: SingleChildScrollView(
                key: LaunchpadBatchClaimPage.contentKey,
                physics: const BouncingScrollPhysics(),
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
                          selected: _selectedIds.contains(position.positionId),
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
                      color: AppColors.onAccent,
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
