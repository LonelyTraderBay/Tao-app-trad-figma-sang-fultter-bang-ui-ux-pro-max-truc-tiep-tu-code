import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part 'active_copies_page_part_01.dart';
part 'active_copies_page_part_02.dart';
part 'active_copies_page_part_03.dart';

const _copyPrimary = AppColors.primary;
const _copyPanel = AppColors.surface;
const _copyPanel2 = AppColors.surface2;
const _copySegmentBackground = AppColors.surface3;
const _lightBuyBackground = AppColors.surfaceSuccessLight;
const _lightSellBackground = AppColors.surfaceDangerLight;
const _lightWarnBackground = AppColors.surfaceWarningLight;

class ActiveCopiesPage extends ConsumerStatefulWidget {
  const ActiveCopiesPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc066_active_copies_scroll_content');
  static const addCopyKey = Key('sc066_add_copy');
  static const stopConfirmInputKey = Key('sc066_stop_confirm_input');
  static const stopConfirmButtonKey = Key('sc066_stop_confirm_button');

  static Key tabKey(String id) => Key('sc066_tab_$id');
  static Key copyKey(String id) => Key('sc066_copy_$id');
  static Key expandKey(String id) => Key('sc066_expand_$id');
  static Key detailsKey(String id) => Key('sc066_details_$id');
  static Key configureKey(String id) => Key('sc066_configure_$id');
  static Key stopKey(String id) => Key('sc066_stop_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ActiveCopiesPage> createState() => _ActiveCopiesPageState();
}

class _ActiveCopiesPageState extends ConsumerState<ActiveCopiesPage> {
  String _activeTab = 'all';
  String? _expandedCopyId;
  TradeActiveCopy? _pendingStopCopy;
  String _confirmText = '';
  String? _actionStatus;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(tradeActiveCopiesControllerProvider);
    final snapshot = controller.state.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 104 : 28);
    final copies = _filteredCopies(snapshot.copies);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-066 ActiveCopiesPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: 'Copy đang chạy',
                showBack: true,
                onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
                actions: [
                  VitHeaderActionItem(
                    key: ActiveCopiesPage.addCopyKey,
                    type: VitHeaderActionType.add,
                    onPressed: () => context.go(AppRoutePaths.tradeCopyTrading),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      key: ActiveCopiesPage.contentKey,
                      padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _PortfolioOverview(snapshot: snapshot.portfolio),
                          const SizedBox(height: 26),
                          _SegmentedTabs(
                            tabs: snapshot.tabs,
                            activeTab: _activeTab,
                            onChanged: (id) => setState(() {
                              _activeTab = id;
                              _expandedCopyId = null;
                            }),
                          ),
                          const SizedBox(height: 24),
                          if (copies.isEmpty)
                            _EmptyCopiesState(
                              history: _activeTab == 'history',
                              onExplore: () =>
                                  context.go(AppRoutePaths.tradeCopyTrading),
                            )
                          else
                            for (final copy in copies) ...[
                              _ActiveCopyCard(
                                key: ActiveCopiesPage.copyKey(copy.id),
                                copy: copy,
                                expanded: _expandedCopyId == copy.id,
                                onToggle: () => setState(() {
                                  _expandedCopyId = _expandedCopyId == copy.id
                                      ? null
                                      : copy.id;
                                }),
                                onViewDetails: () => context.go(
                                  AppRoutePaths.tradeCopyProvider(
                                    copy.providerId,
                                    backPath: AppRoutePaths.tradeCopyActive,
                                  ),
                                ),
                                onConfigure: () => context.go(
                                  AppRoutePaths.tradeCopyProviderConfiguration(
                                    copy.providerId,
                                    backPath: AppRoutePaths.tradeCopyActive,
                                  ),
                                ),
                                onStop:
                                    copy.status ==
                                        TradeActiveCopyStatus.coolingOff
                                    ? null
                                    : () => setState(() {
                                        _pendingStopCopy = copy;
                                        _confirmText = '';
                                      }),
                              ),
                              if (copy != copies.last)
                                const SizedBox(height: 12),
                            ],
                          if (_actionStatus != null) ...[
                            const SizedBox(height: 14),
                            _ActionStatusBanner(text: _actionStatus!),
                          ],
                          if (controller.hasRiskAlert(snapshot.copies)) ...[
                            const SizedBox(height: 14),
                            _RiskAlert(
                              onViewDetails: () =>
                                  setState(() => _activeTab = 'active'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_pendingStopCopy != null)
              _StopCopyModal(
                copy: _pendingStopCopy!,
                confirmText: _confirmText,
                onTextChanged: (value) => setState(() => _confirmText = value),
                onCancel: () => setState(() => _pendingStopCopy = null),
                onConfirm: () {
                  final result = controller.submitCopyAction(
                    providerId: _pendingStopCopy!.providerId,
                    action: 'stop',
                  );
                  setState(() {
                    _actionStatus =
                        'Yêu cầu ${result.action} ${result.providerId} đã được ghi nhận';
                    _pendingStopCopy = null;
                    _confirmText = '';
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  List<TradeActiveCopy> _filteredCopies(List<TradeActiveCopy> copies) {
    return switch (_activeTab) {
      'active' =>
        copies
            .where(
              (copy) =>
                  copy.status == TradeActiveCopyStatus.active ||
                  copy.status == TradeActiveCopyStatus.coolingOff,
            )
            .toList(),
      'paused' =>
        copies
            .where((copy) => copy.status == TradeActiveCopyStatus.paused)
            .toList(),
      'history' =>
        copies
            .where((copy) => copy.status == TradeActiveCopyStatus.stopped)
            .toList(),
      _ => copies,
    };
  }
}
