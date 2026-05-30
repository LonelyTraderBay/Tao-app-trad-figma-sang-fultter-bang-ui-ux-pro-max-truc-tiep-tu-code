import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/widgets/p2p_notice_widgets.dart';

class P2PWalletPage extends ConsumerStatefulWidget {
  const P2PWalletPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc264_p2p_wallet_hero');
  static const privacyKey = Key('sc264_p2p_wallet_privacy');
  static const transferFromMainKey = Key('sc264_p2p_wallet_from_main');
  static const transferToMainKey = Key('sc264_p2p_wallet_to_main');
  static const infoKey = Key('sc264_p2p_wallet_info');
  static const balancesKey = Key('sc264_p2p_wallet_balances');
  static const transactionsKey = Key('sc264_p2p_wallet_transactions');
  static const historyActionKey = Key('sc264_p2p_wallet_history_action');

  static Key balanceKey(String asset) => Key('sc264_p2p_wallet_balance_$asset');

  static Key depositKey(String asset) => Key('sc264_p2p_wallet_deposit_$asset');

  static Key withdrawKey(String asset) =>
      Key('sc264_p2p_wallet_withdraw_$asset');

  static Key escrowKey(String asset) => Key('sc264_p2p_wallet_escrow_$asset');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PWalletPage> createState() => _P2PWalletPageState();
}

class _P2PWalletPageState extends ConsumerState<P2PWalletPage> {
  bool _balanceVisible = true;
  String? _expandedAsset;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pWalletProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-264 P2PWalletPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
              trailing: _HeaderHistoryButton(
                onTap: () => context.go(snapshot.historyRoute),
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _WalletHero(
                        snapshot: snapshot,
                        balanceVisible: _balanceVisible,
                        onPrivacyToggle: () {
                          HapticFeedback.selectionClick();
                          setState(() => _balanceVisible = !_balanceVisible);
                        },
                        onTransferFromMain: () => context.go(
                          '${snapshot.transferRoute}?direction=from-main',
                        ),
                        onTransferToMain: () => context.go(
                          '${snapshot.transferRoute}?direction=to-main',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _WalletInfoBanner(text: snapshot.infoNote),
                      const SizedBox(height: AppSpacing.x5),
                      _BalanceSection(
                        snapshot: snapshot,
                        expandedAsset: _expandedAsset,
                        onToggle: (asset) {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _expandedAsset = _expandedAsset == asset
                                ? null
                                : asset;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.x6),
                      _RecentTransactions(snapshot: snapshot),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderHistoryButton extends StatelessWidget {
  const _HeaderHistoryButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PWalletPage.historyActionKey,
      color: AppColors.surface2,
      borderRadius: AppRadii.mdRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: const SizedBox(
          width: AppSpacing.inputHeight,
          height: AppSpacing.inputHeight,
          child: Icon(
            Icons.history_rounded,
            color: AppColors.text1,
            size: AppSpacing.iconMd,
          ),
        ),
      ),
    );
  }
}

class _WalletHero extends StatelessWidget {
  const _WalletHero({
    required this.snapshot,
    required this.balanceVisible,
    required this.onPrivacyToggle,
    required this.onTransferFromMain,
    required this.onTransferToMain,
  });

  final P2PWalletSnapshot snapshot;
  final bool balanceVisible;
  final VoidCallback onPrivacyToggle;
  final VoidCallback onTransferFromMain;
  final VoidCallback onTransferToMain;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: P2PWalletPage.heroKey,
      padding: const EdgeInsets.all(AppSpacing.x5),
      decoration: BoxDecoration(
        color: AppModuleAccents.p2p,
        borderRadius: AppRadii.cardLargeRadius,
        border: Border.all(color: AppModuleAccents.p2p),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng tài sản P2P',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.onAccent.withValues(alpha: .82),
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      balanceVisible
                          ? '\$${_formatComma(snapshot.totalUsdValue, 2)}'
                          : snapshot.privacyMask,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.heroNumber.copyWith(
                        color: AppColors.onAccent,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Material(
                key: P2PWalletPage.privacyKey,
                color: AppColors.onAccent.withValues(alpha: .18),
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onPrivacyToggle,
                  customBorder: const CircleBorder(),
                  child: SizedBox(
                    width: AppSpacing.inputHeight,
                    height: AppSpacing.inputHeight,
                    child: Icon(
                      balanceVisible
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      color: AppColors.onAccent,
                      size: AppSpacing.iconSm,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _HeroActionButton(
                  key: P2PWalletPage.transferFromMainKey,
                  label: 'Chuyển từ Main',
                  icon: Icons.south_west_rounded,
                  onTap: onTransferFromMain,
                  filled: false,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroActionButton(
                  key: P2PWalletPage.transferToMainKey,
                  label: 'Chuyển về Main',
                  icon: Icons.north_east_rounded,
                  onTap: onTransferToMain,
                  filled: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroActionButton extends StatelessWidget {
  const _HeroActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    required this.filled,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled
          ? AppColors.onAccent
          : AppColors.onAccent.withValues(alpha: .18),
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          constraints: const BoxConstraints(minHeight: AppSpacing.inputHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x2),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: filled ? AppModuleAccents.p2p : AppColors.onAccent,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: filled ? AppModuleAccents.p2p : AppColors.onAccent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WalletInfoBanner extends StatelessWidget {
  const _WalletInfoBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return P2PNoticeCard(
      key: P2PWalletPage.infoKey,
      icon: Icons.info_outline_rounded,
      message: text,
      borderColor: AppModuleAccents.p2p.withValues(alpha: .28),
      padding: const EdgeInsets.all(AppSpacing.x3),
      iconSize: 16,
      messageStyle: AppTextStyles.caption.copyWith(
        color: AppColors.text2,
        fontSize: 12,
      ),
    );
  }
}

class _BalanceSection extends StatelessWidget {
  const _BalanceSection({
    required this.snapshot,
    required this.expandedAsset,
    required this.onToggle,
  });

  final P2PWalletSnapshot snapshot;
  final String? expandedAsset;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PWalletPage.balancesKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Tài sản',
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        for (var index = 0; index < snapshot.balances.length; index++) ...[
          _BalanceCard(
            snapshot: snapshot,
            balance: snapshot.balances[index],
            expanded: expandedAsset == snapshot.balances[index].asset,
            onToggle: () => onToggle(snapshot.balances[index].asset),
          ),
          if (index != snapshot.balances.length - 1)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.snapshot,
    required this.balance,
    required this.expanded,
    required this.onToggle,
  });

  final P2PWalletSnapshot snapshot;
  final P2PWalletBalanceDraft balance;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PWalletPage.balanceKey(balance.asset),
      radius: VitCardRadius.lg,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: AppRadii.cardLargeRadius,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Row(
                children: [
                  _AssetMark(symbol: balance.asset),
                  const SizedBox(width: AppSpacing.x4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              balance.asset,
                              style: AppTextStyles.baseMedium.copyWith(
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.x2),
                            Flexible(
                              child: Text(
                                '≈ \$${_formatComma(balance.usdValue, 2)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          _formatAssetTotal(balance),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.sectionTitle.copyWith(
                            fontWeight: AppTextStyles.bold,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  AnimatedRotation(
                    turns: expanded ? .5 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.text3,
                      size: AppSpacing.iconMd,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            const Divider(height: 1, color: AppColors.borderSolid),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                children: [
                  _BalanceBreakdown(balance: balance),
                  const SizedBox(height: AppSpacing.x4),
                  Row(
                    children: [
                      Expanded(
                        child: _InlineActionButton(
                          key: P2PWalletPage.depositKey(balance.asset),
                          label: 'Chuyển vào',
                          icon: Icons.add_rounded,
                          color: AppColors.buy,
                          onTap: () => context.go(
                            '${snapshot.transferRoute}?asset=${balance.asset}&type=deposit',
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: _InlineActionButton(
                          key: P2PWalletPage.withdrawKey(balance.asset),
                          label: 'Chuyển ra',
                          icon: Icons.remove_rounded,
                          color: AppModuleAccents.p2p,
                          onTap: () => context.go(
                            '${snapshot.transferRoute}?asset=${balance.asset}&type=withdraw',
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (balance.inEscrow > 0) ...[
                    const SizedBox(height: AppSpacing.x3),
                    _EscrowDetailButton(
                      asset: balance.asset,
                      onTap: () => context.go(
                        '${snapshot.escrowBalanceRoute}?asset=${balance.asset}',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AssetMark extends StatelessWidget {
  const _AssetMark({required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _assetColor(symbol).withValues(alpha: .14),
        borderRadius: AppRadii.lgRadius,
      ),
      child: SizedBox(
        width: AppSpacing.inputHeight,
        height: AppSpacing.inputHeight,
        child: Icon(
          _assetIcon(symbol),
          color: _assetColor(symbol),
          size: AppSpacing.iconMd,
        ),
      ),
    );
  }
}

class _BalanceBreakdown extends StatelessWidget {
  const _BalanceBreakdown({required this.balance});

  final P2PWalletBalanceDraft balance;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _BreakdownItem(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Khả dụng',
            value: _formatBalancePart(balance.available, balance.asset),
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _BreakdownItem(
            icon: Icons.lock_outline_rounded,
            label: 'Escrow',
            value: _formatBalancePart(balance.inEscrow, balance.asset),
            color: AppModuleAccents.p2p,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _BreakdownItem(
            icon: Icons.shield_outlined,
            label: 'Locked',
            value: _formatBalancePart(balance.locked, balance.asset),
            color: AppColors.text2,
          ),
        ),
      ],
    );
  }
}

class _BreakdownItem extends StatelessWidget {
  const _BreakdownItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.text3, size: 11),
            const SizedBox(width: AppSpacing.x1),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _InlineActionButton extends StatelessWidget {
  const _InlineActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .13),
      borderRadius: AppRadii.mdRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Container(
          height: AppSpacing.inputHeight,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: AppSpacing.x1),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EscrowDetailButton extends StatelessWidget {
  const _EscrowDetailButton({required this.asset, required this.onTap});

  final String asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PWalletPage.escrowKey(asset),
      color: AppColors.surface2,
      borderRadius: AppRadii.mdRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Container(
          height: AppSpacing.inputHeight,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.description_outlined,
                color: AppColors.text2,
                size: 14,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Xem chi tiết Escrow',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentTransactions extends StatelessWidget {
  const _RecentTransactions({required this.snapshot});

  final P2PWalletSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PWalletPage.transactionsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Giao dịch gần đây',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () => context.go(snapshot.historyRoute),
              style: TextButton.styleFrom(
                foregroundColor: AppModuleAccents.p2p,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x2),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Xem tất cả'),
                  SizedBox(width: AppSpacing.x1),
                  Icon(Icons.chevron_right_rounded, size: 15),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        VitCard(
          radius: VitCardRadius.lg,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (
                var index = 0;
                index < snapshot.transactions.length;
                index++
              ) ...[
                _TransactionRow(tx: snapshot.transactions[index]),
                if (index != snapshot.transactions.length - 1)
                  const Divider(height: 1, color: AppColors.borderSolid),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.tx});

  final P2PWalletTransactionDraft tx;

  @override
  Widget build(BuildContext context) {
    final color = _transactionColor(tx.type);
    final positive = _transactionIsPositive(tx.type);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: color.withValues(alpha: .14),
              borderRadius: AppRadii.lgRadius,
            ),
            child: SizedBox(
              width: AppSpacing.inputHeight,
              height: AppSpacing.inputHeight,
              child: Icon(_transactionIcon(tx.type), color: color, size: 20),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _transactionLabel(tx.type),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: AppColors.text3,
                      size: 11,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Flexible(
                      child: Text(
                        tx.orderId == null
                            ? tx.time
                            : '${tx.time}  ·  ${tx.orderId}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 142),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${positive ? '+' : '-'}${_formatTransactionAmount(tx.amount, tx.asset)} ${tx.asset}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  _statusLabel(tx.status),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: _statusColor(tx.status),
                    fontSize: 12,
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

IconData _assetIcon(String asset) {
  return switch (asset) {
    'BTC' => Icons.currency_bitcoin_rounded,
    'VND' => Icons.price_change_rounded,
    _ => Icons.attach_money_rounded,
  };
}

Color _assetColor(String asset) {
  return switch (asset) {
    'BTC' => AppColors.text1,
    'VND' => AppColors.text2,
    _ => AppColors.buy,
  };
}

IconData _transactionIcon(String type) {
  return switch (type) {
    'deposit' || 'transfer_in' => Icons.south_west_rounded,
    'withdraw' || 'transfer_out' => Icons.north_east_rounded,
    'escrow_lock' => Icons.lock_outline_rounded,
    'escrow_release' => Icons.shield_outlined,
    _ => Icons.attach_money_rounded,
  };
}

Color _transactionColor(String type) {
  return switch (type) {
    'deposit' || 'transfer_in' || 'escrow_release' => AppColors.buy,
    'withdraw' || 'transfer_out' => AppColors.sell,
    'escrow_lock' => AppModuleAccents.p2p,
    _ => AppColors.text2,
  };
}

bool _transactionIsPositive(String type) {
  return type == 'deposit' || type == 'transfer_in' || type == 'escrow_release';
}

String _transactionLabel(String type) {
  return switch (type) {
    'deposit' => 'Nạp tiền',
    'withdraw' => 'Rút tiền',
    'transfer_in' => 'Chuyển vào từ Main Wallet',
    'transfer_out' => 'Chuyển ra Main Wallet',
    'escrow_lock' => 'Khóa Escrow',
    'escrow_release' => 'Giải phóng Escrow',
    _ => 'Giao dịch',
  };
}

String _statusLabel(String status) {
  return switch (status) {
    'completed' => 'Hoàn thành',
    'pending' => 'Đang xử lý',
    'failed' => 'Thất bại',
    _ => status,
  };
}

Color _statusColor(String status) {
  return switch (status) {
    'completed' => AppColors.buy,
    'pending' => AppModuleAccents.p2p,
    'failed' => AppColors.sell,
    _ => AppColors.text3,
  };
}

String _formatAssetTotal(P2PWalletBalanceDraft balance) {
  if (balance.asset == 'VND') return _formatVnd(balance.total);
  return _formatComma(balance.total, balance.asset == 'BTC' ? 8 : 2);
}

String _formatBalancePart(double value, String asset) {
  if (asset == 'VND') return _formatVnd(value);
  return _formatComma(value, asset == 'BTC' ? 8 : 2);
}

String _formatTransactionAmount(double value, String asset) {
  return _formatComma(value, asset == 'BTC' ? 8 : 2);
}

String _formatVnd(double value) {
  final digits = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

String _formatComma(double value, int decimals) {
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  if (decimals == 0) return buffer.toString();
  return '$buffer.${parts.last}';
}
