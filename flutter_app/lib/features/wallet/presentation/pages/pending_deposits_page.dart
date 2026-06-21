import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';

part '../widgets/pending_deposits_page_sections.dart';
part '../widgets/pending_deposits_page_common.dart';

const _pendingBackground = AppColors.bg;
const _pendingBorder = AppColors.overlayStroke;
const _pendingPrimary = AppColors.primary;
const _pendingGreen = AppColors.buy;
const _pendingAmber = AppColors.caution;
const _pendingRed = AppColors.sell;
const _pendingNativeBottomClearance = 88.0;
const _pendingVisualBottomClearance = 112.0;
const _pendingSummaryHeight = 76.0;
const _pendingIconBox = 34.0;
const _pendingNoticeMinHeight = 34.0;
const _pendingProgressHeight = 6.0;
const _pendingProgressDot = 7.0;
const _pendingGap = 8.0;
const _pendingTinyGap = 4.0;
const _pendingInlineGap = 8.0;
const _pendingScrollTopPad = 0.0;
const _pendingCardPadding = EdgeInsetsDirectional.symmetric(
  horizontal: 12,
  vertical: 12,
);
const _pendingDetailsPadding = EdgeInsetsDirectional.symmetric(
  horizontal: 10,
  vertical: 10,
);
const _pendingNoticePadding = EdgeInsetsDirectional.symmetric(
  horizontal: 10,
  vertical: 8,
);

double _pendingScrollBottomInset(BuildContext context, ShellRenderMode mode) {
  return (mode.usesVisualQaFrame
          ? _pendingVisualBottomClearance
          : _pendingNativeBottomClearance) +
      MediaQuery.paddingOf(context).bottom;
}

enum _DepositFilter { all, pending, done }

class PendingDepositsPage extends ConsumerStatefulWidget {
  const PendingDepositsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc152_pending_deposits_content');
  static const refreshKey = Key('sc152_pending_deposits_refresh');
  static Key filterKey(String filter) =>
      Key('sc152_pending_deposits_filter_$filter');
  static Key depositKey(String id) => Key('sc152_pending_deposit_$id');
  static Key copyKey(String id) => Key('sc152_pending_deposit_copy_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PendingDepositsPage> createState() =>
      _PendingDepositsPageState();
}

class _PendingDepositsPageState extends ConsumerState<PendingDepositsPage> {
  _DepositFilter _filter = _DepositFilter.all;
  String? _copiedId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(walletPendingDepositsProvider);
    final deposits = _filteredDeposits(snapshot.deposits);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset = _pendingScrollBottomInset(context, mode);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-152 PendingDepositsPage',
      child: Material(
        color: _pendingBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'N\u1EA1p ti\u1EC1n \u0111ang ch\u1EDD',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.wallet),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: PendingDepositsPage.contentKey,
                  padding: AppSpacing.walletPendingScrollPadding(
                    bottomInset,
                  ).copyWith(top: _pendingScrollTopPad),
                  physics: const ClampingScrollPhysics(),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    density: VitDensity.compact,
                    fullBleed: true,
                    children: [
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Review pending deposit status',
                        message:
                            'Check network, confirmations, amount, fee policy, and next step before taking wallet action.',
                        density: VitDensity.compact,
                      ),
                      _SummaryBanner(
                        pendingCount: snapshot.pendingCount,
                        onRefresh: () {},
                      ),
                      _FilterChips(
                        active: _filter,
                        pendingCount: snapshot.pendingCount,
                        onChanged: (filter) => setState(() => _filter = filter),
                      ),
                      if (deposits.isEmpty)
                        const _EmptyDeposits()
                      else
                        for (final deposit in deposits)
                          _DepositCard(
                            deposit: deposit,
                            copied: _copiedId == deposit.id,
                            onCopy: () =>
                                setState(() => _copiedId = deposit.id),
                          ),
                      const _InfoNotice(),
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

  List<WalletPendingDeposit> _filteredDeposits(
    List<WalletPendingDeposit> deposits,
  ) {
    return switch (_filter) {
      _DepositFilter.pending =>
        deposits
            .where(
              (deposit) =>
                  deposit.status == 'confirming' ||
                  deposit.status == 'processing',
            )
            .toList(growable: false),
      _DepositFilter.done =>
        deposits
            .where(
              (deposit) =>
                  deposit.status == 'credited' || deposit.status == 'failed',
            )
            .toList(growable: false),
      _DepositFilter.all => deposits,
    };
  }
}
