part of '../pages/trade_history_export_page.dart';

class _TaxNote extends StatelessWidget {
  const _TaxNote();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      borderColor: _tradePrimary.withValues(alpha: .18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color: _tradePrimary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'File xuất phục vụ mục đích lưu trữ và khai thuế. Không phải tài liệu '
              'chính thức về thuế. Tham khảo ý kiến chuyên gia thuế cho trường hợp cụ thể.',
              style: AppTextStyles.navLabel.copyWith(color: _tradePrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportFooter extends StatelessWidget {
  const _ExportFooter({
    required this.format,
    required this.period,
    required this.isExporting,
    required this.result,
    required this.onExport,
    required this.onNewExport,
  });

  final String format;
  final String period;
  final bool isExporting;
  final TradeExportResult? result;
  final VoidCallback onExport;
  final VoidCallback onNewExport;

  @override
  Widget build(BuildContext context) {
    final exported = result != null;

    return Material(
      color: AppColors.surface2,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x2,
        ),
        child: exported
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // card-tile: allow-start — fixed surface, not horizontal strip tile
                  VitCard(
                    variant: VitCardVariant.inner,
                    height: VitDensity.compact.controlHeight,
                    alignment: Alignment.center,
                    borderColor: AppColors.buy.withValues(alpha: .2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: AppColors.buy,
                          size: AppSpacing.iconSm,
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Flexible(
                          child: Text(
                            'File đã sẵn sàng tải xuống',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.buy,
                              fontWeight: AppTextStyles.medium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  Row(
                    children: [
                      Expanded(
                        child: VitCtaButton(
                          key: TradeHistoryExportPage.newExportKey,
                          variant: VitCtaButtonVariant.secondary,
                          onPressed: onNewExport,
                          child: const Text('Tạo mới'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Expanded(
                        flex: TradeSpacingTokens.tradeToolFooterButtonFlex,
                        child: VitCtaButton(
                          key: TradeHistoryExportPage.downloadKey,
                          variant: VitCtaButtonVariant.success,
                          onPressed: () {},
                          leading: const Icon(Icons.file_download_outlined),
                          child: Text('Tải ${format.toUpperCase()}'),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : VitCtaButton(
                key: TradeHistoryExportPage.exportKey,
                variant: VitCtaButtonVariant.primary,
                loading: isExporting,
                onPressed: isExporting ? null : onExport,
                leading: Icon(
                  isExporting
                      ? Icons.schedule_outlined
                      : Icons.file_download_outlined,
                ),
                child: Text(
                  isExporting
                      ? 'Đang tạo file...'
                      : 'Xuất ${format.toUpperCase()} ($period)',
                ),
              ),
      ),
    );
  }
}

String _formatInteger(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) buffer.write(',');
    buffer.write(text[i]);
  }
  return buffer.toString();
}

String _formatCompact(double value) {
  if (value >= 1000000) {
    return '\$${(value / 1000000).toStringAsFixed(2)}M';
  }
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(1)}K';
  return _formatMoney(value);
}

String _formatMoney(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  return '\$${_formatInteger(int.parse(parts[0]))}.${parts[1]}';
}
