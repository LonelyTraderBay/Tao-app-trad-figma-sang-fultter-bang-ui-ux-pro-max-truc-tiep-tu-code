part of '../pages/client_money_protection_page.dart';

class _ProtectionNotice extends StatelessWidget {
  const _ProtectionNotice();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.text1,
            size: AppSpacing.tradeBotClientMoneyNoticeIcon,
          ),
          const SizedBox(width: AppSpacing.tradeBotRowGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Funds Are Protected',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'All client money is held in segregated bank accounts and '
                  'reconciled daily per FCA CASS 7 rules.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
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
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VitCard(
                width: AppSpacing.tradeBotClientMoneyBalanceIcon,
                height: AppSpacing.tradeBotClientMoneyBalanceIcon,
                variant: VitCardVariant.inner,
                alignment: Alignment.center,
                borderColor: _moneyGreen.withValues(alpha: .35),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  color: _moneyGreen,
                  size: AppSpacing.tradeBotClientMoneyBalanceGlyph,
                ),
              ),
              const SizedBox(width: AppSpacing.tradeBotStatusGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Segregated Balance',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      _formatUsd(snapshot.balance),
                      style: AppTextStyles.sectionTitleSm.copyWith(
                        color: AppColors.text1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Fully segregated and protected',
                      style: AppTextStyles.micro.copyWith(color: _moneyGreen),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Trust Account',
                  value: snapshot.trustAccount,
                ),
              ),
              const SizedBox(width: AppSpacing.tradeBotRowGap),
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
    return VitSegmentedTabBar(
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.$1,
            label: tab.$2,
            widgetKey: ClientMoneyProtectionPage.tabKey(tab.$1),
          ),
      ],
      activeKey: activeId,
      onChanged: onChanged,
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
      density: VitDensity.compact,
      children: [
        VitPageSection(
          key: ClientMoneyProtectionPage.overviewSectionKey,
          label: 'How Your Money Is Protected',
          density: VitDensity.compact,
          children: [
            _Card(
              child: VitPageContent(
                padding: VitContentPadding.none,
                fullBleed: true,
                density: VitDensity.compact,
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
          density: VitDensity.compact,
          children: [
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.text1,
                        size: AppSpacing.tradeBotClientMoneyInsolvencyIcon,
                      ),
                      const SizedBox(width: AppSpacing.tradeBotDisclosureGap),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                            children: [
                              TextSpan(
                                text: 'Client Money Protection: ',
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              TextSpan(text: snapshot.insolvencySummary),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  Text(
                    snapshot.insolvencyDetail,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
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
        const Icon(
          Icons.check_circle_outline,
          color: _moneyGreen,
          size: AppSpacing.tradeToolBodyIcon,
        ),
        const SizedBox(width: AppSpacing.tradeBotCardIconGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                item.description,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
