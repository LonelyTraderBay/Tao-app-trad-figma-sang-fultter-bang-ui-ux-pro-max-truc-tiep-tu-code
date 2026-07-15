import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
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
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

part '../../widgets/transfer/pending_deposits_page_sections.dart';
part '../../widgets/transfer/pending_deposits_page_common.dart';

const _pendingGap = AppSpacing.x2;
const _pendingTinyGap = AppSpacing.x1;
const _pendingInlineGap = AppSpacing.x2;

double _pendingScrollBottomInset(BuildContext context, ShellRenderMode mode) {
  return (mode.usesVisualQaFrame
          ? WalletSpacingTokens.walletPendingBottomInsetVisual
          : WalletSpacingTokens.walletPendingBottomInsetNative) +
      MediaQuery.paddingOf(context).bottom;
}

enum _DepositFilter { all, pending, done }

class PendingDepositsPage extends ConsumerStatefulWidget {
  const PendingDepositsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc152_pending_deposits_content');
  static const refreshKey = Key('sc152_pending_deposits_refresh');
  static const refreshFeedbackKey = Key(
    'sc152_pending_deposits_refresh_feedback',
  );
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
  String? _lastRefreshLabel;

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
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'N\u1EA1p ti\u1EC1n \u0111ang ch\u1EDD',
            subtitle: 'Theo d\u00F5i x\u00E1c nh\u1EADn \u00B7 Wallet',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.wallet),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: VitInsetScrollView(
                  key: PendingDepositsPage.contentKey,
                  bottomInset: bottomInset,
                  physics: const ClampingScrollPhysics(),
                  child: VitPageContent(
                    rhythm: VitPageRhythm.standard,
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    gap: VitContentGap.tight,
                    children: [
                      const _TrustReviewNotice(),
                      _SummaryBanner(
                        pendingCount: snapshot.pendingCount,
                        lastRefreshLabel: _lastRefreshLabel,
                        onRefresh: _refreshDeposits,
                      ),
                      _PendingDepositFilters(
                        active: _filter,
                        pendingCount: snapshot.pendingCount,
                        onChanged: (filter) => setState(() => _filter = filter),
                      ),
                      VitPageSection(
                        label: 'Danh s\u00E1ch n\u1EA1p',
                        headerIcon: Icons.pending_actions_outlined,
                        headerVariant: VitSectionHeaderVariant.plain,
                        innerGap: AppSpacing.pageRhythmStandardInnerGap,
                        children: [
                          if (deposits.isEmpty)
                            const _EmptyDeposits()
                          else
                            for (final deposit in deposits)
                              _DepositCard(
                                deposit: deposit,
                                copied: _copiedId == deposit.id,
                                onCopy: () => _copyHash(deposit),
                              ),
                        ],
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

  Future<void> _copyHash(WalletPendingDeposit deposit) async {
    setState(() => _copiedId = deposit.id);
    await Clipboard.setData(ClipboardData(text: deposit.txHash));
  }

  void _refreshDeposits() {
    setState(() => _lastRefreshLabel = 'Vừa cập nhật trạng thái nạp tiền');
  }
}
