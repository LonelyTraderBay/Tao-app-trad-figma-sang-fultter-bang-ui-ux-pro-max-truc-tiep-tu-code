part of '../pages/launchpad_claim_receipt_page.dart';

class _ClaimSheet extends StatelessWidget {
  const _ClaimSheet({
    required this.entry,
    required this.receipt,
    required this.onClose,
  });

  final LaunchpadRewardVestingEntryDraft entry;
  final LaunchpadRewardClaimReceiptDraft receipt;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: AppColors.dynamicIslandBg.withValues(alpha: .72),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadii.cardLarge),
            ),
            child: Padding(
              key: LaunchpadClaimReceiptPage.claimSheetKey,
              padding: EdgeInsets.fromLTRB(
                AppSpacing.contentPad,
                AppSpacing.x4,
                AppSpacing.contentPad,
                AppSpacing.x5 + MediaQuery.paddingOf(context).bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    child: Container(
                      width: AppSpacing.launchpadBox40,
                      height: AppSpacing.launchpadSheetHandleHeight,
                      decoration: BoxDecoration(
                        color: AppColors.borderSolid,
                        borderRadius: AppRadii.xsRadius,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Nhận phần thưởng',
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: onClose,
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Text(
                    '${_formatNumber(entry.amount)} ${entry.token}',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.pageTitle.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    '~${_formatUsd(entry.amount * receipt.rewardTokenPrice)} USD',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  _DetailLine(row: _DetailRow('Đợt', entry.label)),
                  _DetailLine(row: _DetailRow('Chain', receipt.chain)),
                  _DetailLine(row: const _DetailRow('Gas ước tính', r'~$0.15')),
                  const SizedBox(height: AppSpacing.x4),
                  VitCtaButton(
                    onPressed: onClose,
                    variant: VitCtaButtonVariant.success,
                    child: Text(
                      'Xác nhận nhận ${_formatNumber(entry.amount)} ${entry.token}',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
