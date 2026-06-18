part of 'launchpad_bridge_compare_page.dart';

class _HopChip extends StatelessWidget {
  const _HopChip({required this.label, required this.subtitle});

  final String label;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: AppSpacing.launchpadInlinePillPadding,
        child: Column(
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            Text(
              subtitle,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsRow extends StatelessWidget {
  const _DetailsRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: AppSpacing.launchpadVerticalPaddingX2,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                value,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: AppSpacing.launchpadDividerHeight,
          color: AppColors.divider,
        ),
      ],
    );
  }
}

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
        padding: AppSpacing.launchpadPaddingX4,
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
                accent: route.accent,
                size: AppSpacing.launchpadIcon7xl,
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
          const SizedBox(height: AppSpacing.x3),
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
                  padding: AppSpacing.launchpadConfirmSheetPadding,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: AppSpacing.launchpadBox40,
                        height: AppSpacing.launchpadSheetHandleHeight,
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                            color: AppColors.borderSolid,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadii.inputRadius,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x4),
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
                          IconButton(
                            onPressed: onClose,
                            icon: const Icon(
                              Icons.close_rounded,
                              color: AppColors.text2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      _ProviderBadge(
                        label: route.providerIcon,
                        accent: route.accent,
                        size: AppSpacing.launchpadBox56,
                      ),
                      const SizedBox(height: AppSpacing.x3),
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
                      const SizedBox(height: AppSpacing.x4),
                      VitCard(
                        variant: VitCardVariant.inner,
                        radius: VitCardRadius.lg,
                        padding: AppSpacing.launchpadPaddingX4,
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
                      const SizedBox(height: AppSpacing.x3),
                      _DetailsRow(
                        label: 'Price impact',
                        value: '${_trimDouble(route.priceImpact)}%',
                      ),
                      _DetailsRow(label: 'Tổng phí', value: route.totalFeeUsd),
                      _DetailsRow(
                        label: 'Security',
                        value: '${route.securityScore}/100',
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      DecoratedBox(
                        decoration: const ShapeDecoration(
                          color: AppColors.primary08,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadii.mdRadius,
                            side: BorderSide(color: AppColors.primary12),
                          ),
                        ),
                        child: Padding(
                          padding: AppSpacing.launchpadPaddingX3,
                          child: Text(
                            'Đây là chế độ mô phỏng. Kết quả thực tế có thể khác theo điều kiện thị trường.',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x4),
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

IconData _sortIcon(String iconKey) {
  return switch (iconKey) {
    'trending' => Icons.trending_up_rounded,
    'fuel' => Icons.local_gas_station_outlined,
    'clock' => Icons.schedule_rounded,
    'shield' => Icons.shield_outlined,
    _ => Icons.star_border_rounded,
  };
}

String _chainLabel(String chain) {
  if (chain == 'Ethereum') return 'ET';
  if (chain == 'Polygon') return 'PG';
  return chain.length > 2 ? chain.substring(0, 2).toUpperCase() : chain;
}

String _formatNumber(num value) {
  final fixed = value is int || value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
  final parts = fixed.split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    final remaining = integer.length - i;
    buffer.write(integer[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  if (parts.length > 1 && parts.last.isNotEmpty) {
    buffer.write('.');
    buffer.write(parts.last);
  }
  return buffer.toString();
}

String _trimDouble(double value) {
  if (value == value.roundToDouble()) return value.toInt().toString();
  return value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
}
