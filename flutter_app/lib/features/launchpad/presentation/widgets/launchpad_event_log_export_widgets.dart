part of '../pages/launchpad_event_log_page.dart';

class _ExportSheet extends StatelessWidget {
  const _ExportSheet({
    required this.formats,
    required this.activeFormat,
    required this.count,
    required this.copied,
    required this.onFormatChanged,
    required this.onClose,
    required this.onCopy,
  });

  final List<LaunchpadEventLogExportFormatDraft> formats;
  final String activeFormat;
  final int count;
  final bool copied;
  final ValueChanged<String> onFormatChanged;
  final VoidCallback onClose;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      key: LaunchpadEventLogPage.exportSheetKey,
      color: AppColors.dynamicIslandBg.withValues(alpha: .72),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () {},
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.launchpadSheetMaxWidth,
            ),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadii.cardLarge),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x5,
              AppSpacing.x3,
              AppSpacing.x5,
              AppSpacing.x6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: AppSpacing.launchpadBox44,
                    height: AppSpacing.launchpadSheetHandleHeight,
                    decoration: BoxDecoration(
                      color: AppColors.borderSolid,
                      borderRadius: AppRadii.xlRadius,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Export Event Log',
                        style: AppTextStyles.base.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.extraBold,
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
                const SizedBox(height: AppSpacing.x3),
                Center(
                  child: Column(
                    children: [
                      Text(
                        '$count',
                        style: AppTextStyles.pageTitle.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.heavy,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      Text(
                        'events se duoc export',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                Text(
                  'Dinh dang',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x2),
                Row(
                  children: [
                    for (final format in formats) ...[
                      Expanded(
                        child: _ExportFormatTile(
                          key: LaunchpadEventLogPage.formatKey(format.value),
                          format: format,
                          active: activeFormat == format.value,
                          onTap: () => onFormatChanged(format.value),
                        ),
                      ),
                      if (format != formats.last)
                        const SizedBox(width: AppSpacing.x2),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.x4),
                VitCard(
                  variant: VitCardVariant.inner,
                  padding: const EdgeInsets.all(AppSpacing.x3),
                  child: Text(
                    _previewFor(activeFormat, count),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: AppSpacing.launchpadLineHeightReadable,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                VitCtaButton(
                  key: LaunchpadEventLogPage.copyButtonKey,
                  onPressed: onCopy,
                  variant: copied
                      ? VitCtaButtonVariant.success
                      : VitCtaButtonVariant.primary,
                  leading: Icon(
                    copied ? Icons.check_rounded : Icons.copy_rounded,
                    color: AppColors.onAccent,
                    size: AppSpacing.launchpadIcon2xl,
                  ),
                  child: Text(
                    copied
                        ? 'Da copy vao clipboard'
                        : 'Copy $count events (${activeFormat.toUpperCase()})',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _previewFor(String format, int count) {
    return switch (format) {
      'json' => '{"count": $count, "entries": [...]}',
      'csv' => 'timestamp,level,source,message\n23:36:08,info,Bridge,...',
      _ =>
        '=== Launchpad Event Log ===\n[23:36:08] [INFO] Bridge\n  Bridge transaction initiated',
    };
  }
}

class _ExportFormatTile extends StatelessWidget {
  const _ExportFormatTile({
    super.key,
    required this.format,
    required this.active,
    required this.onTap,
  });

  final LaunchpadEventLogExportFormatDraft format;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppModuleAccents.launchpad : AppColors.text3;
    return InkWell(
      borderRadius: AppRadii.inputRadius,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.x3,
          horizontal: AppSpacing.x2,
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.primary12 : AppColors.surface2,
          border: Border.all(
            color: active ? AppColors.primary30 : AppColors.cardBorder,
          ),
          borderRadius: AppRadii.inputRadius,
        ),
        child: Column(
          children: [
            Icon(
              _formatIcon(format.iconKey),
              color: color,
              size: AppSpacing.launchpadIcon3xl,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              format.label,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: active
                    ? AppTextStyles.extraBold
                    : AppTextStyles.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
