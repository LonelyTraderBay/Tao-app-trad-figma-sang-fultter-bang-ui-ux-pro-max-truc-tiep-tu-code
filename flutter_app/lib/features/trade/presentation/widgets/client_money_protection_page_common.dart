part of '../pages/client_money_protection_page.dart';

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
              backgroundColor: _moneyPanel2,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
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
      ('Client Money Letter', 'Your segregation agreement', _moneyPrimary),
      ('CASS Compliance Report', 'Annual auditor report', _moneyGreen),
      (
        'Insolvency Protection Guide',
        'What happens to your funds',
        AppColors.caution,
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
                    borderRadius: AppRadii.inputRadius,
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
        color: _moneyPanel2,
        borderRadius: AppRadii.inputRadius,
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
        color: success ? _moneyGreen.withValues(alpha: .13) : _moneyPanel2,
        borderRadius: AppRadii.smRadius,
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
            color: _moneyPrimary,
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
        color: _moneyPanel,
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
