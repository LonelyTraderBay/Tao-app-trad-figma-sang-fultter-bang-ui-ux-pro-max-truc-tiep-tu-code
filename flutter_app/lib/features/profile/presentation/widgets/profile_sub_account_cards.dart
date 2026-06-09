part of '../pages/sub_account_page.dart';

class _SubAccountCard extends StatelessWidget {
  const _SubAccountCard({
    required this.account,
    required this.isExpanded,
    required this.isBalanceHidden,
    required this.onTap,
  });

  final ProfileSubAccount account;
  final bool isExpanded;
  final bool isBalanceHidden;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final typeColor = _typeColor(account.type);
    final statusColor = _statusColor(account.status);
    final pnlColor = account.pnl30d >= 0 ? AppColors.buy : AppColors.sell;

    return VitCard(
      key: SubAccountPage.accountCardKey(account.id),
      borderColor: AppColors.cardBorder,
      child: Column(
        children: [
          Material(
            color: AppColors.transparent,
            child: InkWell(
              key: SubAccountPage.expandKey(account.id),
              onTap: onTap,
              borderRadius: AppRadii.cardRadius,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _AccountAvatar(
                      initial: account.name.isEmpty
                          ? '?'
                          : account.name.substring(0, 1),
                      color: typeColor,
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  account.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.baseMedium.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    height: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 7),
                              _SmallPill(
                                label: _typeLabel(account.type),
                                foreground: typeColor,
                                background: typeColor.withValues(alpha: .12),
                                border: typeColor.withValues(alpha: .18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 9),
                          Row(
                            children: [
                              Icon(
                                _statusIcon(account.status),
                                color: statusColor,
                                size: 12,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _statusLabel(account.status),
                                style: AppTextStyles.micro.copyWith(
                                  color: statusColor,
                                  fontWeight: AppTextStyles.bold,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  '\u00B7 ${account.lastActive}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.micro.copyWith(
                                    color: AppColors.text3,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isBalanceHidden
                              ? '\u2022\u2022\u2022\u2022'
                              : _formatUsd(account.balance),
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            height: 1,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isBalanceHidden
                              ? '\u2022\u2022'
                              : _formatSignedUsd(account.pnl30d),
                          style: AppTextStyles.micro.copyWith(
                            color: pnlColor,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isExpanded)
            _SubAccountDetails(account: account, typeColor: typeColor),
        ],
      ),
    );
  }
}
