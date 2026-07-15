part of '../../pages/bridge/launchpad_bridge_compare_page.dart';

class _RiskDisclosure extends StatelessWidget {
  const _RiskDisclosure();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: LaunchpadBridgeComparePage.riskKey,
      decoration: const ShapeDecoration(
        color: AppColors.warn08,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.lgRadius,
          side: BorderSide(color: AppColors.warningBorder),
        ),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.launchpadPaddingX4,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                'Lưu ý rủi ro đầu tư',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.warn,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconSm,
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedRouteFooter extends StatelessWidget {
  const _SelectedRouteFooter({
    required this.route,
    required this.outputToken,
    required this.onConfirm,
  });

  final LaunchpadBridgeRouteOptionDraft route;
  final String outputToken;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return VitStickyFooter(
      key: LaunchpadBridgeComparePage.footerKey,
      backgroundColor: AppColors.surface.withValues(alpha: .94),
      child: Column(
        children: [
          Row(
            children: [
              _ProviderBadge(
                label: route.providerIcon,
                accent: route.accent.resolve(),
                size: LaunchpadSpacingTokens.launchpadIcon7xl,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      route.provider,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      '${_formatNumber(route.outputAmount)} $outputToken · ${route.totalFeeUsd} fee · ${route.estimatedTime}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCtaButton(
            onPressed: onConfirm,
            child: const Text('Chọn route này'),
          ),
        ],
      ),
    );
  }
}

class _RouteConfirmOverlay extends StatelessWidget {
  const _RouteConfirmOverlay({
    required this.route,
    required this.comparison,
    required this.onClose,
    required this.onExecute,
  });

  final LaunchpadBridgeRouteOptionDraft route;
  final LaunchpadBridgeComparisonDraft comparison;
  final VoidCallback onClose;
  final VoidCallback onExecute;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: AppColors.dynamicIslandBg.withValues(alpha: .74),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            key: LaunchpadBridgeComparePage.confirmKey,
            constraints: const BoxConstraints(maxHeight: 620),
            child: SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: const ShapeDecoration(
                  color: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.sheetTopLargeRadius,
                  ),
                ),
                child: Padding(
                  padding: LaunchpadSpacingTokens.launchpadConfirmSheetPadding,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: LaunchpadSpacingTokens.launchpadBox40,
                        height: AppSpacing.x1,
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                            color: AppColors.borderSolid,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadii.inputRadius,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardSectionGap,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Xác nhận route',
                              style: AppTextStyles.sectionTitle.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                          VitIconButton(
                            onPressed: onClose,
                            icon: Icons.close_rounded,
                            tooltip: 'Dong xac nhan route',
                            variant: VitIconButtonVariant.transparent,
                            size: VitIconButtonSize.md,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardInnerGap,
                      ),
                      _ProviderBadge(
                        label: route.providerIcon,
                        accent: route.accent.resolve(),
                        size: LaunchpadSpacingTokens.launchpadBox56,
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardInnerGap,
                      ),
                      Text(
                        route.provider,
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        '${route.hops} hops · ${route.estimatedTime}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardSectionGap,
                      ),
                      VitCard(
                        variant: VitCardVariant.inner,
                        radius: VitCardRadius.large,
                        padding: LaunchpadSpacingTokens.launchpadPaddingX4,
                        child: Row(
                          children: [
                            Expanded(
                              child: _ConfirmAmount(
                                label: 'Bạn gửi',
                                value: _formatNumber(comparison.inputAmount),
                                token: comparison.inputToken,
                                chain: comparison.sourceChain,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.text3,
                              size: AppSpacing.iconSm,
                            ),
                            Expanded(
                              child: _ConfirmAmount(
                                label: 'Nhận',
                                value: _formatNumber(route.outputAmount),
                                token: comparison.outputToken,
                                chain: comparison.targetChain,
                                color: AppColors.buy,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardInnerGap,
                      ),
                      _DetailsRow(
                        label: 'Price impact',
                        value: '${_trimDouble(route.priceImpact)}%',
                      ),
                      _DetailsRow(label: 'Tổng phí', value: route.totalFeeUsd),
                      _DetailsRow(
                        label: 'Security',
                        value: '${route.securityScore}/100',
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardSectionGap,
                      ),
                      VitHighRiskStatePanel(
                        key: LaunchpadBridgeComparePage.confirmStateKey,
                        state: VitHighRiskUiState.riskReview,
                        title: 'Review bridge route',
                        message:
                            'Review output, fee, speed, security, and chain.',
                        contractId: 'SC-305 / ${route.provider}',
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardSectionGap,
                      ),
                      VitCtaButton(
                        onPressed: onExecute,
                        child: Text('Xác nhận Bridge qua ${route.provider}'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfirmAmount extends StatelessWidget {
  const _ConfirmAmount({
    required this.label,
    required this.value,
    required this.token,
    required this.chain,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final String token;
  final String chain;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        Text(
          '$token · $chain',
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}
