import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';

part '../widgets/pending_deposits_page_sections.dart';
part '../widgets/pending_deposits_page_common.dart';

const _pendingBackground = AppColors.bg;
const _pendingPanel = AppColors.surface;
const _pendingPanel2 = AppColors.surface3;
const _pendingBorder = AppColors.overlayStroke;
const _pendingPrimary = AppColors.primary;
const _pendingGreen = AppColors.buy;
const _pendingAmber = AppColors.caution;
const _pendingRed = AppColors.sell;

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
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-152 PendingDepositsPage',
      child: Material(
        color: _pendingBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'N\u1EA1p ti\u1EC1n \u0111ang ch\u1EDD',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.wallet),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: PendingDepositsPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 12, 20, bottomInset),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SummaryBanner(
                      pendingCount: snapshot.pendingCount,
                      onRefresh: () {},
                    ),
                    const SizedBox(height: 16),
                    _FilterChips(
                      active: _filter,
                      pendingCount: snapshot.pendingCount,
                      onChanged: (filter) => setState(() => _filter = filter),
                    ),
                    const SizedBox(height: 16),
                    if (deposits.isEmpty)
                      const _EmptyDeposits()
                    else
                      for (final deposit in deposits) ...[
                        _DepositCard(
                          deposit: deposit,
                          copied: _copiedId == deposit.id,
                          onCopy: () => setState(() => _copiedId = deposit.id),
                        ),
                        if (deposit != deposits.last)
                          const SizedBox(height: 12),
                      ],
                    const SizedBox(height: 16),
                    const _InfoNotice(),
                  ],
                ),
              ),
            ),
          ],
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
