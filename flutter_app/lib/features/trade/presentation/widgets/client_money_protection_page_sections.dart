part of '../pages/client_money_protection_page.dart';

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
              VitCard(
                width: 56,
                height: 56,
                variant: VitCardVariant.inner,
                alignment: Alignment.center,
                borderColor: _moneyGreen.withValues(alpha: .35),
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
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Text(
                      _formatUsd(snapshot.balance),
                      style: AppTextStyles.heroNumber.copyWith(
                        color: AppColors.text1,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      'Fully segregated and protected',
                      style: AppTextStyles.micro.copyWith(
                        color: _moneyGreen,
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
    return VitCard(
      height: 53,
      variant: VitCardVariant.inner,
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
                                ? _moneyPrimary
                                : AppColors.text3,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: activeId == tab.$1 ? 100 : 0,
                      height: 2,
                      color: _moneyPrimary,
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
    return VitPageContent(
      padding: VitContentPadding.none,
      fullBleed: true,
      customGap: 12,
      children: [
        VitPageSection(
          label: 'How Your Money Is Protected',
          children: [
            _Card(
              padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
              child: VitPageContent(
                padding: VitContentPadding.none,
                fullBleed: true,
                customGap: 22,
                children: [
                  for (final item in snapshot.protections)
                    _ProtectionItem(item: item),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          label: 'In Case of Insolvency',
          children: [
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
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
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
