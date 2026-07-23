import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/utils/data_masking.dart';
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
const _pendingFilterHeight = AppSpacing.buttonCompact;

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
    final snapshotAsync = ref.watch(walletPendingDepositsProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset = _pendingScrollBottomInset(context, mode);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Nạp tiền đang chờ xác nhận',
      semanticIdentifier: 'SC-152',
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
                child: RefreshIndicator(
                  color: AppColors.primary,
                  backgroundColor: AppColors.surface2,
                  onRefresh: _refreshDeposits,
                  child: VitInsetScrollView(
                    key: PendingDepositsPage.contentKey,
                    bottomInset: bottomInset,
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: ClampingScrollPhysics(),
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      gap: VitContentGap.tight,
                      children: [
                        ...snapshotAsync.when(
                          loading: () => const [VitSkeletonList()],
                          error: (error, stackTrace) => [
                            VitErrorState(
                              title:
                                  'Kh\u00F4ng t\u1EA3i \u0111\u01B0\u1EE3c n\u1EA1p ti\u1EC1n \u0111ang ch\u1EDD',
                              message:
                                  'Vui l\u00F2ng ki\u1EC3m tra k\u1EBFt n\u1ED1i v\u00E0 th\u1EED l\u1EA1i.',
                              actionLabel: 'Th\u1EED l\u1EA1i',
                              onAction: () =>
                                  ref.invalidate(walletPendingDepositsProvider),
                            ),
                          ],
                          data: (snapshot) {
                            final deposits = _filteredDeposits(
                              snapshot.deposits,
                            );
                            return [
                              const _TrustReviewNotice(),
                              _SummaryBanner(
                                pendingCount: snapshot.pendingCount,
                                onRefresh: _refreshDeposits,
                              ),
                              _PendingDepositFilters(
                                active: _filter,
                                pendingCount: snapshot.pendingCount,
                                onChanged: (filter) =>
                                    setState(() => _filter = filter),
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
                            ];
                          },
                        ),
                      ],
                    ),
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

  Future<void> _refreshDeposits() async {
    try {
      ref.invalidate(walletPendingDepositsProvider);
      await ref.read(walletPendingDepositsProvider.future);
    } catch (_) {
      // AsyncValue.error sẽ render VitErrorState; vẫn báo người dùng.
    }
    if (!mounted) return;
    await showVitNoticeSheet(
      context: context,
      title: 'Đã làm mới',
      message:
          'Trạng thái nạp tiền đang chờ đã được cập nhật. Kiểm tra lại số xác nhận và mạng trước khi thao tác ví.',
    );
  }
}
