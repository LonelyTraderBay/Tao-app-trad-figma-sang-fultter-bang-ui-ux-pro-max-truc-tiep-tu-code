import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/vit_wallet_detail_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part '../widgets/transaction_detail_page_sections.dart';
part '../widgets/transaction_detail_page_common.dart';

const _detailBackground = AppColors.bg;
const _detailPrimary = AppColors.primary;
const _detailGreen = AppColors.buy;
const _detailRed = AppColors.sell;

class TransactionDetailPage extends ConsumerStatefulWidget {
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
  ConsumerState<TransactionDetailPage> createState() =>
      _TransactionDetailPageState();
}

class _TransactionDetailPageState extends ConsumerState<TransactionDetailPage> {
  String? _copiedValue;

  @override
  void didUpdateWidget(covariant TransactionDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.transactionId != widget.transactionId) {
      _copiedValue = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(
      walletTransactionDetailProvider(widget.transactionId),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();

    return VitWalletDetailScaffold(
      title: 'Chi tiết giao dịch',
      subtitle: 'Lịch sử · Wallet',
      semanticLabel: 'SC-141 TransactionDetailPage',
      contentKey: TransactionDetailPage.contentKey,
      contentGap: VitContentGap.tight,
      shellRenderMode: mode,
      backgroundColor: _detailBackground,
      onBack: () => context.go(AppRoutePaths.walletHistory),
      children: [
        snapshot.transaction == null
            ? _MissingTransaction(
                onBack: () => context.go(AppRoutePaths.walletHistory),
              )
            : _TransactionDetailContent(
                tx: snapshot.transaction!,
                copiedValue: _copiedValue,
                onCopy: _copyValue,
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
    );
  }

  void _copyValue(String value) {
    setState(() => _copiedValue = value);
    unawaited(
      Clipboard.setData(ClipboardData(text: value)).catchError((Object _) {}),
    );
  }
}
