part of '../../pages/tools/launchpad_rebalance_page.dart';

class LaunchpadRebalanceConfirmSheet extends StatelessWidget {
  const LaunchpadRebalanceConfirmSheet({
    super.key,
    required this.sheetKey,
    required this.confirmKey,
    required this.cancelKey,
    required this.suggestions,
    required this.totalGas,
    required this.onClose,
    this.bottomReserve = 0,
  });

  final Key sheetKey;
  final Key confirmKey;
  final Key cancelKey;
  final List<RebalanceSuggestion> suggestions;
  final double totalGas;
  final VoidCallback onClose;
  final double bottomReserve;

  @override
  Widget build(BuildContext context) {
    final executable = suggestions
        .where((item) => item.action != LaunchpadRebalanceAction.hold)
        .toList();
    return Material(
      key: sheetKey,
      color: AppColors.dynamicIslandBg.withValues(alpha: .72),
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: DeviceMetrics.width),
            child: DecoratedBox(
              decoration: const ShapeDecoration(
                color: AppColors.bg,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.sheetTopLargeRadius,
                ),
              ),
              child: Padding(
                padding: LaunchpadSpacingTokens.launchpadSheetPadding(
                  AppSpacing.x4 + bottomReserve,
                ).copyWith(top: AppSpacing.x3),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: SizedBox(
                        width: LaunchpadSpacingTokens.launchpadBox40,
                        height: AppSpacing.x1,
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                            color: AppColors.borderSolid,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadii.xsRadius,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: AppColors.buy,
                          size: LaunchpadSpacingTokens.launchpadIcon4xl,
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Text(
                          'Xac nhan Rebalance',
                          style: AppTextStyles.base.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    for (final suggestion in executable)
                      _ConfirmActionRow(suggestion: suggestion),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                    LaunchpadRebalanceSummaryRow(
                      label: 'Gas tong',
                      value: '~\$${totalGas.toStringAsFixed(2)}',
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    VitCtaButton(
                      key: confirmKey,
                      variant: VitCtaButtonVariant.success,
                      onPressed: onClose,
                      child: const Text('Xac nhan Rebalance (Mo phong)'),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    VitCtaButton(
                      key: cancelKey,
                      onPressed: onClose,
                      variant: VitCtaButtonVariant.ghost,
                      fullWidth: false,
                      height: AppSpacing.buttonCompact,
                      child: Text(
                        'Huy',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfirmActionRow extends StatelessWidget {
  const _ConfirmActionRow({required this.suggestion});

  final RebalanceSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final color = launchpadRebalanceActionColor(suggestion.action);
    return Padding(
      padding: LaunchpadSpacingTokens.launchpadBottomPaddingX2,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: .1),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadii.inputRadius,
          ),
        ),
        child: Padding(
          padding: LaunchpadSpacingTokens.launchpadPillPadding,
          child: Row(
            children: [
              Text(
                launchpadRebalanceActionLabel(suggestion.action),
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  suggestion.asset.symbol,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '\$${suggestion.suggestedValue.toStringAsFixed(2)}',
                style: AppTextStyles.micro.copyWith(
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
