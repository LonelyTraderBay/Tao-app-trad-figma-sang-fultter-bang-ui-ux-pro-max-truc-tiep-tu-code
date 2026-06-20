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
            borderRadius: AppRadii.sheetTopLargeRadius,
            child: Padding(
              key: LaunchpadClaimReceiptPage.claimSheetKey,
              padding: AppSpacing.launchpadClaimSheetPadding(
                MediaQuery.paddingOf(context).bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    child: SizedBox(
                      width: AppSpacing.launchpadBox40,
                      height: AppSpacing.launchpadSheetHandleHeight,
                      child: const DecoratedBox(
                        decoration: ShapeDecoration(
                          color: AppColors.borderSolid,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadii.xsRadius,
                          ),
                        ),
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
                  VitHighRiskStatePanel(
                    key: LaunchpadClaimReceiptPage.claimSheetReviewStateKey,
                    state: VitHighRiskUiState.riskReview,
                    title: 'Review claim receipt',
                    message:
                        'Check reward token, chain, gas, and claim amount.',
                    contractId: 'SC-302 / ${receipt.positionId}',
                  ),
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
