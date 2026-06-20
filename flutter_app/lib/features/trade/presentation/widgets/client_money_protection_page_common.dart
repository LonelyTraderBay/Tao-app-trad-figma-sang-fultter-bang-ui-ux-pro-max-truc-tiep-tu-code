part of '../pages/client_money_protection_page.dart';

class _Reconciliation extends StatelessWidget {
  const _Reconciliation();

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Daily Reconciliation',
      density: VitDensity.compact,
      children: [
        _Card(
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
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  const _MatchedPill(),
                ],
              ),
              const SizedBox(height: AppSpacing.x2),
              const _ReconciliationRow(
                label: 'Client Ledger Balance',
                value: '\$45,230.50',
              ),
              const SizedBox(height: AppSpacing.x1),
              const _ReconciliationRow(
                label: 'Bank Account Balance',
                value: '\$45,230.50',
              ),
              const SizedBox(height: AppSpacing.x1),
              const _ReconciliationRow(
                label: 'Difference',
                value: '\$0.00',
                success: true,
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                'Last reconciled: Today at 09:00 UTC - Next: Tomorrow at 09:00 UTC',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
        VitCtaButton(
          key: ClientMoneyProtectionPage.cassHistoryKey,
          onPressed: () =>
              context.go(AppRoutePaths.tradeCopyCassReconciliation),
          variant: VitCtaButtonVariant.secondary,
          density: VitDensity.compact,
          leading: const Icon(
            Icons.visibility_outlined,
            size: AppSpacing.tradeBotCheckboxIcon,
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            size: AppSpacing.tradeBotCheckboxIcon,
          ),
          child: Text(
            'View Full Reconciliation History',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
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
      ('Client Money Letter', 'Your segregation agreement', _moneyPrimary),
      ('CASS Compliance Report', 'Annual auditor report', _moneyGreen),
      (
        'Insolvency Protection Guide',
        'What happens to your funds',
        AppColors.caution,
      ),
    ];
    return VitPageSection(
      label: 'CASS Documents',
      density: VitDensity.compact,
      children: [
        for (final document in documents)
          _Card(
            child: Row(
              children: [
                VitCard(
                  width: AppSpacing.tradeBotClientMoneyDocumentIcon,
                  height: AppSpacing.tradeBotClientMoneyDocumentIcon,
                  variant: VitCardVariant.inner,
                  alignment: Alignment.center,
                  borderColor: document.$3.withValues(alpha: .35),
                  child: Icon(
                    document.$1 == 'Insolvency Protection Guide'
                        ? Icons.shield_outlined
                        : Icons.description_outlined,
                    color: document.$3,
                    size: AppSpacing.tradeBotClientMoneyDocumentGlyph,
                  ),
                ),
                const SizedBox(width: AppSpacing.tradeBotCardIconGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.$1,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        document.$2,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.download_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.tradeBotClientMoneyDocumentGlyph,
                ),
              ],
            ),
          ),
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
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
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
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      borderColor: success ? _moneyGreen.withValues(alpha: .35) : null,
      padding: AppSpacing.tradeBotClientMoneyRowPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: success ? _moneyGreen : AppColors.text3,
                fontWeight: success ? AppTextStyles.bold : AppTextStyles.normal,
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
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
    return const VitStatusPill(
      label: 'MATCHED',
      status: VitStatusPillStatus.success,
      size: VitStatusPillSize.sm,
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: _moneyBorder.withValues(alpha: .72),
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
