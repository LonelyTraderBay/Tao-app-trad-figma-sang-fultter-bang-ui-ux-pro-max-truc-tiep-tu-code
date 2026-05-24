import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/wallet_repository.dart';

const _pendingBackground = AppColors.bg;
const _pendingPanel = AppColors.surface;
const _pendingPanel2 = AppColors.surface3;
const _pendingBorder = Color(0x14FFFFFF);
const _pendingPrimary = AppColors.primary;
const _pendingGreen = Color(0xFF10B981);
const _pendingAmber = Color(0xFFF59E0B);
const _pendingRed = Color(0xFFEF4444);

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
    final snapshot = ref.watch(walletRepositoryProvider).getPendingDeposits();
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

class _SummaryBanner extends StatelessWidget {
  const _SummaryBanner({required this.pendingCount, required this.onRefresh});

  final int pendingCount;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final hasPending = pendingCount > 0;
    final color = hasPending ? _pendingAmber : _pendingGreen;
    return Container(
      height: 78,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: _pendingPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _pendingBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: AppRadii.cardRadius,
            ),
            alignment: Alignment.center,
            child: Icon(
              hasPending
                  ? Icons.access_time_rounded
                  : Icons.check_circle_outline_rounded,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasPending
                      ? '$pendingCount giao d\u1ECBch \u0111ang ch\u1EDD x\u00E1c nh\u1EADn'
                      : 'T\u1EA5t c\u1EA3 n\u1EA1p ti\u1EC1n \u0111\u00E3 ho\u00E0n t\u1EA5t',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  hasPending
                      ? 'Trang t\u1EF1 \u0111\u1ED9ng c\u1EADp nh\u1EADt m\u1ED7i 5 gi\u00E2y'
                      : 'Kh\u00F4ng c\u00F3 giao d\u1ECBch n\u00E0o \u0111ang ch\u1EDD',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            key: PendingDepositsPage.refreshKey,
            onTap: onRefresh,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.surface3,
                borderRadius: AppRadii.cardRadius,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.refresh_rounded,
                color: AppColors.text2,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.active,
    required this.pendingCount,
    required this.onChanged,
  });

  final _DepositFilter active;
  final int pendingCount;
  final ValueChanged<_DepositFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final items = [
      (_DepositFilter.all, 'T\u1EA5t c\u1EA3'),
      (_DepositFilter.pending, '\u0110ang ch\u1EDD ($pendingCount)'),
      (_DepositFilter.done, 'Ho\u00E0n t\u1EA5t'),
    ];
    return Row(
      children: [
        for (final item in items) ...[
          GestureDetector(
            key: PendingDepositsPage.filterKey(item.$1.name),
            onTap: () => onChanged(item.$1),
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 13),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active == item.$1
                    ? _pendingPrimary.withValues(alpha: .14)
                    : Colors.transparent,
                borderRadius: AppRadii.inputRadius,
                border: Border.all(
                  color: active == item.$1
                      ? _pendingPrimary.withValues(alpha: .45)
                      : Colors.transparent,
                ),
              ),
              child: Text(
                item.$2,
                style: AppTextStyles.micro.copyWith(
                  color: active == item.$1 ? _pendingPrimary : AppColors.text2,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ),
          if (item != items.last) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _DepositCard extends StatelessWidget {
  const _DepositCard({
    required this.deposit,
    required this.copied,
    required this.onCopy,
  });

  final WalletPendingDeposit deposit;
  final bool copied;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final config = _statusConfig(deposit.status);
    return Container(
      key: PendingDepositsPage.depositKey(deposit.id),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _pendingPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _pendingBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: config.color.withValues(alpha: .12),
                  borderRadius: AppRadii.cardRadius,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.south_west_rounded,
                  color: config.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'N\u1EA1p ${deposit.asset}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _DepositStatusBadge(config: config),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      deposit.createdAt,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '+${deposit.amountLabel}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Roboto',
                  height: 1,
                ),
              ),
            ],
          ),
          if (deposit.status == 'confirming' ||
              deposit.status == 'processing') ...[
            const SizedBox(height: 18),
            _ConfirmationProgress(deposit: deposit, color: config.color),
          ],
          if (deposit.status == 'credited') ...[
            const SizedBox(height: 14),
            _StatusNotice(
              color: _pendingGreen,
              icon: Icons.check_circle_outline_rounded,
              text:
                  '\u0110\u00E3 ghi nh\u1EADn v\u00E0o v\u00ED \u2014 ${deposit.confirmations}/${deposit.requiredConfirmations} x\u00E1c nh\u1EADn',
            ),
          ],
          if (deposit.status == 'failed') ...[
            const SizedBox(height: 14),
            const _StatusNotice(
              color: _pendingRed,
              icon: Icons.warning_amber_rounded,
              text:
                  'Giao d\u1ECBch th\u1EA5t b\u1EA1i \u2014 li\u00EAn h\u1EC7 h\u1ED7 tr\u1EE3 n\u1EBFu \u0111\u00E3 g\u1EEDi ti\u1EC1n',
            ),
          ],
          const SizedBox(height: 12),
          _DepositDetails(deposit: deposit, copied: copied, onCopy: onCopy),
        ],
      ),
    );
  }
}

class _DepositStatusBadge extends StatelessWidget {
  const _DepositStatusBadge({required this.config});

  final _DepositStatusConfig config;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        config.label,
        style: AppTextStyles.micro.copyWith(
          color: config.color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class _ConfirmationProgress extends StatelessWidget {
  const _ConfirmationProgress({required this.deposit, required this.color});

  final WalletPendingDeposit deposit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final dotCount = deposit.requiredConfirmations.clamp(2, 12);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'X\u00E1c nh\u1EADn blockchain',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontSize: 11,
                  height: 1,
                ),
              ),
            ),
            Text(
              '${deposit.confirmations}/${deposit.requiredConfirmations}',
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                fontFamily: 'Roboto',
                height: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 6,
            child: LinearProgressIndicator(
              value: deposit.progress.clamp(.05, 1),
              backgroundColor: AppColors.surface3,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < dotCount; i++)
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: i < deposit.confirmations ? color : AppColors.surface3,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _StatusNotice extends StatelessWidget {
  const _StatusNotice({
    required this.color,
    required this.icon,
    required this.text,
  });

  final Color color;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 34),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DepositDetails extends StatelessWidget {
  const _DepositDetails({
    required this.deposit,
    required this.copied,
    required this.onCopy,
  });

  final WalletPendingDeposit deposit;
  final bool copied;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 10),
      decoration: BoxDecoration(
        color: _pendingPanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          _DetailRow(label: 'M\u1EA1ng', value: deposit.network),
          const SizedBox(height: 9),
          _DetailRow(
            label: 'Th\u1EDDi gian d\u1EF1 ki\u1EBFn',
            value: deposit.estimatedArrival,
          ),
          const SizedBox(height: 9),
          _DetailRow(
            label: 'T\u1EEB \u0111\u1ECBa ch\u1EC9',
            value: deposit.fromAddress,
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Text(
                'TxHash',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                  height: 1,
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  deposit.txHash,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.micro.copyWith(
                    color: _pendingPrimary,
                    fontSize: 11,
                    fontFamily: 'Roboto',
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                key: PendingDepositsPage.copyKey(deposit.id),
                onTap: onCopy,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .04),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        copied
                            ? Icons.check_rounded
                            : Icons.content_copy_rounded,
                        color: copied ? _pendingGreen : AppColors.text3,
                        size: 11,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        copied ? '\u0110\u00E3 ch\u00E9p' : 'Copy',
                        style: AppTextStyles.micro.copyWith(
                          color: copied ? _pendingGreen : AppColors.text3,
                          fontSize: 10,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 11,
            fontFamily: 'Roboto',
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _EmptyDeposits extends StatelessWidget {
  const _EmptyDeposits();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _pendingPanel,
              borderRadius: AppRadii.cardRadius,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.inbox_outlined,
              color: AppColors.text3,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Kh\u00F4ng c\u00F3 giao d\u1ECBch n\u1EA1p n\u00E0o',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoNotice extends StatelessWidget {
  const _InfoNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: _pendingPrimary.withValues(alpha: .06),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _pendingPrimary.withValues(alpha: .15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _pendingPrimary,
            size: 14,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'S\u1ED1 x\u00E1c nh\u1EADn c\u1EA7n thi\u1EBFt ph\u1EE5 thu\u1ED9c v\u00E0o m\u1EA1ng blockchain. N\u1EA1p d\u01B0\u1EDBi m\u1EE9c t\u1ED1i thi\u1EC3u s\u1EBD kh\u00F4ng \u0111\u01B0\u1EE3c ghi nh\u1EADn. Li\u00EAn h\u1EC7 h\u1ED7 tr\u1EE3 n\u1EBFu giao d\u1ECBch ch\u01B0a xu\u1EA5t hi\u1EC7n sau 1 gi\u1EDD.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _DepositStatusConfig {
  const _DepositStatusConfig({required this.label, required this.color});

  final String label;
  final Color color;
}

_DepositStatusConfig _statusConfig(String status) {
  return switch (status) {
    'credited' => const _DepositStatusConfig(
      label: '\u0110\u00E3 ghi nh\u1EADn',
      color: _pendingGreen,
    ),
    'failed' => const _DepositStatusConfig(
      label: 'Th\u1EA5t b\u1EA1i',
      color: _pendingRed,
    ),
    'processing' => const _DepositStatusConfig(
      label: '\u0110ang x\u1EED l\u00FD',
      color: _pendingPrimary,
    ),
    _ => const _DepositStatusConfig(
      label: '\u0110ang x\u00E1c nh\u1EADn',
      color: _pendingAmber,
    ),
  };
}
