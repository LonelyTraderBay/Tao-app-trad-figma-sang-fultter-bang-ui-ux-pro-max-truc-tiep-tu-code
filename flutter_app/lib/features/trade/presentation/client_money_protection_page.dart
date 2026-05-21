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
import '../data/trade_repository.dart';

const _moneyBg = Color(0xFF080C14);
const _moneySurface = Color(0xFF151A23);
const _moneySurface2 = Color(0xFF1E2535);
const _moneyBorder = Color(0xFF273142);
const _moneyBlue = Color(0xFF3B82F6);
const _moneyGreen = Color(0xFF10B981);

class ClientMoneyProtectionPage extends ConsumerStatefulWidget {
  const ClientMoneyProtectionPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc102_client_money_content');
  static Key tabKey(String id) => Key('sc102_client_money_tab_$id');
  static const cassHistoryKey = Key('sc102_cass_history');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ClientMoneyProtectionPage> createState() =>
      _ClientMoneyProtectionPageState();
}

class _ClientMoneyProtectionPageState
    extends ConsumerState<ClientMoneyProtectionPage> {
  String _tab = 'overview';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeRepositoryProvider)
        .getClientMoneyProtection();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 70
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-102 ClientMoneyProtectionPage',
      child: Material(
        color: _moneyBg,
        child: Column(
          children: [
            VitHeader(
              title: 'Client Money Protection',
              subtitle: 'CASS 7 Compliance',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: ClientMoneyProtectionPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 27, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _ProtectionNotice(),
                    const SizedBox(height: 34),
                    _BalanceCard(snapshot: snapshot),
                    const SizedBox(height: 24),
                    _Tabs(activeId: _tab, onChanged: _setTab),
                    const SizedBox(height: 26),
                    if (_tab == 'overview')
                      _Overview(snapshot: snapshot)
                    else if (_tab == 'reconciliation')
                      const _Reconciliation()
                    else
                      const _Documents(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setTab(String id) => setState(() => _tab = id);
}

class _ProtectionNotice extends StatelessWidget {
  const _ProtectionNotice();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.text1, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Funds Are Protected',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'All client money is held in segregated bank accounts and '
                  'reconciled daily per FCA CASS 7 rules.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                    height: 1.35,
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

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.snapshot});

  final TradeClientMoneyProtectionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 17),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _moneyGreen.withValues(alpha: .13),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  color: _moneyGreen,
                  size: 28,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Segregated Balance',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Text(
                      _formatUsd(snapshot.balance),
                      style: AppTextStyles.heroNumber.copyWith(
                        color: AppColors.text1,
                        fontSize: 24,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      'Fully segregated and protected',
                      style: AppTextStyles.micro.copyWith(
                        color: _moneyGreen,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Trust Account',
                  value: snapshot.trustAccount,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricBox(
                  label: 'Last Reconciled',
                  value: snapshot.lastReconciled,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      ('overview', 'Overview'),
      ('reconciliation', 'Reconciliation'),
      ('documents', 'Documents'),
    ];
    return Container(
      height: 53,
      color: _moneySurface,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: ClientMoneyProtectionPage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: activeId == tab.$1
                                ? _moneyBlue
                                : AppColors.text3,
                            fontSize: 12,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: activeId == tab.$1 ? 100 : 0,
                      height: 2,
                      color: _moneyBlue,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({required this.snapshot});

  final TradeClientMoneyProtectionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('How Your Money Is Protected'),
        const SizedBox(height: 12),
        _Card(
          padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
          child: Column(
            children: [
              for (final item in snapshot.protections) ...[
                _ProtectionItem(item: item),
                if (item != snapshot.protections.last)
                  const SizedBox(height: 22),
              ],
            ],
          ),
        ),
        const SizedBox(height: 25),
        const _SectionLabel('In Case of Insolvency'),
        const SizedBox(height: 12),
        _Card(
          padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.text1,
                    size: 14,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text1,
                          fontSize: 10,
                          fontWeight: AppTextStyles.bold,
                          height: 1.35,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Client Money Protection: ',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(text: snapshot.insolvencySummary),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Text(
                snapshot.insolvencyDetail,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProtectionItem extends StatelessWidget {
  const _ProtectionItem({required this.item});

  final TradeClientMoneyProtectionItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_outline, color: _moneyGreen, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Reconciliation extends StatelessWidget {
  const _Reconciliation();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Daily Reconciliation'),
        const SizedBox(height: 12),
        _Card(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Latest Reconciliation',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontSize: 13,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                  ),
                  const _MatchedPill(),
                ],
              ),
              const SizedBox(height: 14),
              const _ReconciliationRow(
                label: 'Client Ledger Balance',
                value: '\$45,230.50',
              ),
              const SizedBox(height: 8),
              const _ReconciliationRow(
                label: 'Bank Account Balance',
                value: '\$45,230.50',
              ),
              const SizedBox(height: 8),
              const _ReconciliationRow(
                label: 'Difference',
                value: '\$0.00',
                success: true,
              ),
              const SizedBox(height: 10),
              Text(
                'Last reconciled: Today at 09:00 UTC - Next: Tomorrow at 09:00 UTC',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 9,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 13),
        SizedBox(
          height: 44,
          child: OutlinedButton(
            key: ClientMoneyProtectionPage.cassHistoryKey,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.text1,
              side: BorderSide(color: _moneyBorder.withValues(alpha: .72)),
              backgroundColor: _moneySurface2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () =>
                context.go(AppRoutePaths.tradeCopyCassReconciliation),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.visibility_outlined, size: 16),
                const SizedBox(width: 9),
                Flexible(
                  child: Text(
                    'View Full Reconciliation History',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 13,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right_rounded, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Documents extends StatelessWidget {
  const _Documents();

  @override
  Widget build(BuildContext context) {
    const documents = [
      ('Client Money Letter', 'Your segregation agreement', _moneyBlue),
      ('CASS Compliance Report', 'Annual auditor report', _moneyGreen),
      (
        'Insolvency Protection Guide',
        'What happens to your funds',
        Color(0xFFF59E0B),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('CASS Documents'),
        const SizedBox(height: 12),
        for (final document in documents) ...[
          _Card(
            padding: const EdgeInsets.all(13),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: document.$3.withValues(alpha: .13),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    document.$1 == 'Insolvency Protection Guide'
                        ? Icons.shield_outlined
                        : Icons.description_outlined,
                    color: document.$3,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.$1,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 13,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        document.$2,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontSize: 10,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.download_rounded,
                  color: AppColors.text3,
                  size: 18,
                ),
              ],
            ),
          ),
          if (document != documents.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 9),
      decoration: BoxDecoration(
        color: _moneySurface2,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 13,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReconciliationRow extends StatelessWidget {
  const _ReconciliationRow({
    required this.label,
    required this.value,
    this.success = false,
  });

  final String label;
  final String value;
  final bool success;

  @override
  Widget build(BuildContext context) {
    final color = success ? _moneyGreen : AppColors.text1;
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
      decoration: BoxDecoration(
        color: success ? _moneyGreen.withValues(alpha: .13) : _moneySurface2,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: success ? _moneyGreen : AppColors.text3,
                fontSize: 11,
                fontWeight: success ? AppTextStyles.bold : AppTextStyles.normal,
                height: 1,
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchedPill extends StatelessWidget {
  const _MatchedPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: _moneyGreen.withValues(alpha: .13),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'MATCHED',
        style: AppTextStyles.micro.copyWith(
          color: _moneyGreen,
          fontSize: 10,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: _moneyBlue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          text,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _moneySurface,
        border: Border.all(color: _moneyBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var index = 0; index < whole.length; index += 1) {
    if (index > 0 && (whole.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(whole[index]);
  }
  return '\$${buffer.toString()}.${parts.last}';
}
