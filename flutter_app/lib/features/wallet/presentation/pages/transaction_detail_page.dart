import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';

part '../widgets/transaction_detail_page_sections.dart';
part '../widgets/transaction_detail_page_common.dart';

const _detailBackground = AppColors.bg;
const _detailPanel2 = AppColors.surface2;
const _detailPrimary = AppColors.primary;
const _detailGreen = AppColors.buy;
const _detailRed = AppColors.sell;
const _detailAmber = AppColors.caution;

class TransactionDetailPage extends ConsumerWidget {
  const TransactionDetailPage({
    super.key,
    required this.transactionId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc141_transaction_detail_content');
  static const explorerKey = Key('sc141_transaction_detail_explorer');
  static const supportKey = Key('sc141_transaction_detail_support');
  static const copyTxIdKey = Key('sc141_transaction_detail_copy_txid');

  final String transactionId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(walletTransactionDetailProvider(transactionId));
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome +
                  AppSpacing.walletBottomInsetVisualChrome
            : DeviceMetrics.nativeBottomChrome +
                  AppSpacing.walletBottomInsetNativeChrome) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-141 TransactionDetailPage',
      child: Material(
        color: _detailBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Chi tiết giao dịch',
            subtitle: 'Lịch sử · Wallet',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.walletHistory),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: contentKey,
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.pageHorizontalPadding,
                    AppSpacing.rowPy,
                    AppSpacing.pageHorizontalPadding,
                    bottomInset,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    customGap: 0,
                    fullBleed: true,
                    children: [
                      snapshot.transaction == null
                          ? _MissingTransaction(
                              onBack: () =>
                                  context.go(AppRoutePaths.walletHistory),
                            )
                          : _TransactionDetailContent(
                              tx: snapshot.transaction!,
                              onCopy: (value) => _copyValue(context, value),
                              onSupport: () => context.go(
                                ContextualSupportContracts.supportRouteFor(
                                  ContextualSupportFlow.withdrawal,
                                  referenceId: snapshot.transaction!.id,
                                  sourceRoute: AppRoutePaths.walletTransaction(
                                    snapshot.transaction!.id,
                                  ),
                                  issueLabel: 'Wallet transaction support',
                                ),
                              ),
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

  Future<void> _copyValue(BuildContext context, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã sao chép'),
        duration: Duration(milliseconds: 900),
      ),
    );
  }
}
