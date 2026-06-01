part of '../pages/trade_history_export_page.dart';

class _TaxNote extends StatelessWidget {
  const _TaxNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      decoration: BoxDecoration(
        color: _tradePrimary.withValues(alpha: .06),
        border: Border.all(color: _tradePrimary.withValues(alpha: .18)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(Icons.info_outline, color: _tradePrimary, size: 14),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'File xuất phục vụ mục đích lưu trữ và khai thuế. Không phải tài liệu '
              'chính thức về thuế. Tham khảo ý kiến chuyên gia thuế cho trường hợp cụ thể.',
              style: AppTextStyles.micro.copyWith(
                color: _tradePrimary,
                fontSize: 11,
                height: 1.45,
              ),
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

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, exported ? 12 : 16, 20, 14),
        child: exported
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.buy.withValues(alpha: .08),
                      borderRadius: AppRadii.inputRadius,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: AppColors.buy,
                          size: 17,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'File đã sẵn sàng tải xuống',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.buy,
                            fontWeight: AppTextStyles.medium,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _FooterButton(
                          key: TradeHistoryExportPage.newExportKey,
                          label: 'Tạo mới',
                          foreground: AppColors.text2,
                          background: AppColors.surface3,
                          borderColor: AppColors.borderSolid,
                          onTap: onNewExport,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: _FooterButton(
                          key: TradeHistoryExportPage.downloadKey,
                          label: 'Tải ${format.toUpperCase()}',
                          icon: Icons.file_download_outlined,
                          foreground: AppColors.onAccent,
                          gradient: const LinearGradient(
                            colors: [AppColors.buy, AppColors.buyDark],
                          ),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : _FooterButton(
                key: TradeHistoryExportPage.exportKey,
                label: isExporting
                    ? 'Đang tạo file...'
                    : 'Xuất ${format.toUpperCase()} ($period)',
                icon: isExporting
                    ? Icons.schedule_outlined
                    : Icons.file_download_outlined,
                foreground: isExporting ? AppColors.text3 : AppColors.onAccent,
                gradient: isExporting
                    ? null
                    : const LinearGradient(
                        colors: [_tradePrimary, _tradePrimaryDark],
                      ),
                background: isExporting ? AppColors.surface3 : null,
                onTap: isExporting ? null : onExport,
              ),
      ),
    );
  }
}

class _FooterButton extends StatelessWidget {
  const _FooterButton({
    super.key,
    required this.label,
    required this.foreground,
    this.onTap,
    this.icon,
    this.background,
    this.gradient,
    this.borderColor,
  });

  final String label;
  final Color foreground;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? background;
  final Gradient? gradient;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: AppSpacing.inputHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: gradient == null ? background : null,
          gradient: gradient,
          border: borderColor == null ? null : Border.all(color: borderColor!),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: foreground, size: 17),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  color: foreground,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
          ],
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
