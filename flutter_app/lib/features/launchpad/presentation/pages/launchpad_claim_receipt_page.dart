import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part '../widgets/launchpad_claim_receipt_hero_widgets.dart';
part '../widgets/launchpad_claim_receipt_overview_widgets.dart';
part '../widgets/launchpad_claim_receipt_timeline_widgets.dart';
part '../widgets/launchpad_claim_receipt_claim_sheet_widgets.dart';
part '../widgets/launchpad_claim_receipt_misc_widgets.dart';

const double _launchpadClaimReceiptVisualNavClearance = 112;
const double _launchpadClaimReceiptNativeNavClearance = 88;

class LaunchpadClaimReceiptPage extends ConsumerStatefulWidget {
  const LaunchpadClaimReceiptPage({
    super.key,
    this.positionId = 'pos001',
    this.shellRenderMode,
  });

  static const contentKey = Key('sc302_launchpad_claim_receipt_content');
  static const tabsKey = Key('sc302_launchpad_claim_receipt_tabs');
  static const heroKey = Key('sc302_launchpad_claim_receipt_hero');
  static const heroAmountKey = Key('sc302_launchpad_claim_receipt_hero_amount');
  static const claimableKey = Key('sc302_launchpad_claim_receipt_claimable');
  static const detailsKey = Key('sc302_launchpad_claim_receipt_details');
  static const vestingPreviewKey = Key(
    'sc302_launchpad_claim_receipt_vesting_preview',
  );
  static const claimSheetKey = Key('sc302_launchpad_claim_receipt_claim_sheet');
  static const claimSheetReviewStateKey = Key(
    'sc302_launchpad_claim_receipt_claim_sheet_review_state',
  );

  static Key tabKey(String id) => Key('sc302_launchpad_claim_receipt_tab_$id');
  static Key vestingKey(String id) =>
      Key('sc302_launchpad_claim_receipt_vesting_$id');
  static Key historyKey(String id) =>
      Key('sc302_launchpad_claim_receipt_history_$id');

  final String positionId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadClaimReceiptPage> createState() =>
      _LaunchpadClaimReceiptPageState();
}

class _LaunchpadClaimReceiptPageState
    extends ConsumerState<LaunchpadClaimReceiptPage> {
  var _activeTab = _ClaimReceiptTab.overview;
  LaunchpadRewardVestingEntryDraft? _claimEntry;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(launchpadControllerProvider)
        .getClaimReceipt(widget.positionId);
    final receipt = snapshot.receipt;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? _launchpadClaimReceiptVisualNavClearance
        : _launchpadClaimReceiptNativeNavClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-302 LaunchpadClaimReceiptPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
              semanticLabel: 'SC-302 LaunchpadClaimReceiptPage scroll surface',
              header: VitHeader(
                title: snapshot.title,
                subtitle: '${receipt.projectSymbol} · Vesting & nhận thưởng',
                showBack: true,
                onBack: () =>
                    goBackOrFallback(context, fallbackPath: snapshot.backRoute),
                actions: [
                  VitHeaderActionItem(
                    type: VitHeaderActionType.notifications,
                    tooltip: 'Thông báo claim Launchpad',
                    onPressed: HapticFeedback.selectionClick,
                  ),
                ],
              ),
              child: Column(
                children: [
                  ColoredBox(
                    key: LaunchpadClaimReceiptPage.tabsKey,
                    color: AppColors.navBg,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: AppSpacing.launchpadHorizontalContentPadding,
                          child: VitTabBar(
                            tabs: const [
                              VitTabItem(key: 'overview', label: 'Tổng quan'),
                              VitTabItem(key: 'vesting', label: 'Vesting'),
                              VitTabItem(key: 'history', label: 'Lịch sử'),
                            ],
                            activeKey: _activeTab.id,
                            variant: VitTabBarVariant.underline,
                            onChanged: (id) => setState(
                              () => _activeTab = _ClaimReceiptTab.byId(id),
                            ),
                          ),
                        ),
                        const Divider(
                          height: AppSpacing.dividerHairline,
                          color: AppColors.border,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        key: LaunchpadClaimReceiptPage.contentKey,
                        physics: const ClampingScrollPhysics(),
                        padding: EdgeInsetsDirectional.only(
                          bottom: scrollEndPadding,
                        ),
                        child: VitPageContent(
                          padding: VitContentPadding.compact,
                          density: VitDensity.compact,
                          children: [
                          _RewardHero(receipt: receipt),
                          if (_activeTab == _ClaimReceiptTab.overview) ...[
                            _ClaimableBanner(
                              receipt: receipt,
                              onClaim: () => setState(
                                () => _claimEntry = receipt.vestingSchedule
                                    .firstWhere(
                                      (entry) =>
                                          entry.status ==
                                              LaunchpadVestingEntryStatus
                                                  .claimable ||
                                          entry.status ==
                                              LaunchpadVestingEntryStatus
                                                  .unlocking,
                                      orElse: () =>
                                          receipt.vestingSchedule.first,
                                    ),
                              ),
                            ),
                            _NextUnlockCard(receipt: receipt),
                            _ReceiptDetailsCard(receipt: receipt),
                            _VestingPreviewCard(
                              receipt: receipt,
                              onOpenAll: () => setState(
                                () => _activeTab = _ClaimReceiptTab.vesting,
                              ),
                            ),
                          ] else if (_activeTab == _ClaimReceiptTab.vesting)
                            _VestingTimelineCard(
                              receipt: receipt,
                              onClaim: (entry) =>
                                  setState(() => _claimEntry = entry),
                            )
                          else
                            _ClaimHistoryCard(receipt: receipt),
                          const _RiskDisclosureTile(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ),
            if (_claimEntry != null)
              _ClaimSheet(
                entry: _claimEntry!,
                receipt: receipt,
                onClose: () => setState(() => _claimEntry = null),
              ),
          ],
        ),
      ),
    );
  }
}
