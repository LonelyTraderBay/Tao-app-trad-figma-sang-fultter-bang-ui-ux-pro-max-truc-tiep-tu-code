part of '../pages/copy_audit_log_page.dart';

class _AuditEventCard extends StatelessWidget {
  const _AuditEventCard({super.key, required this.event});

  final TradeCopyAuditEvent event;

  @override
  Widget build(BuildContext context) {
    final color = _eventColor(event);
    return VitCard(
      padding: AppSpacing.cardPadding,
      borderColor: AppColors.cardBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.lg,
            width: AppSpacing.walletAddressIconSize,
            height: AppSpacing.walletAddressIconSize,
            alignment: Alignment.center,
            borderColor: color,
            child: Icon(
              _eventIcon(event),
              color: color,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.medium,
                    height: AppSpacing.copyAuditEventTitleLineHeight,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  event.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.medium,
                    height: AppSpacing.copyAuditEventDescriptionLineHeight,
                  ),
                ),
                const SizedBox(height: AppSpacing.cardGap),
                _EventMetaRow(event: event, color: color),
                if (_hasVisibleMetadata(event)) ...[
                  const SizedBox(height: AppSpacing.x4),
                  _EventMetadataPanel(event: event),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventMetaRow extends StatelessWidget {
  const _EventMetaRow({required this.event, required this.color});

  final TradeCopyAuditEvent event;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.access_time_rounded,
          color: AppColors.text3,
          size: AppSpacing.rowGapRegular,
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          event.timestamp,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: AppSpacing.copyAuditMetaLineHeight,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Text(
          '•',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: AppSpacing.copyAuditMetaLineHeight,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        _TypeBadge(type: event.type, color: color),
      ],
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type, required this.color});

  final TradeCopyAuditEventType type;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: _eventTypeLabel(type), accentColor: color);
  }
}

class _EventMetadataPanel extends StatelessWidget {
  const _EventMetadataPanel({required this.event});

  final TradeCopyAuditEvent event;

  @override
  Widget build(BuildContext context) {
    final metadata = event.metadata!;
    if (event.type == TradeCopyAuditEventType.config) {
      return VitCard(
        variant: VitCardVariant.inner,
        radius: VitCardRadius.sm,
        height: AppSpacing.copyAuditMetadataConfigHeight,
        width: double.infinity,
        alignment: Alignment.centerLeft,
        padding: AppSpacing.copyAuditMetadataConfigPadding,
        child: Text(
          '${metadata.oldValue} → ${metadata.newValue}',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: AppSpacing.copyAuditMetaLineHeight,
          ),
        ),
      );
    }

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      width: double.infinity,
      padding: AppSpacing.copyAuditMetadataPanelPadding,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _MetadataValue(
                  label: 'Provider Price',
                  value: _formatUsd(metadata.providerPrice ?? 0),
                ),
              ),
              Expanded(
                child: _MetadataValue(
                  label: 'Your Price',
                  value: _formatUsd(metadata.yourPrice ?? 0),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.walletAssetPillGap),
          Row(
            children: [
              Expanded(
                child: _MetadataValue(
                  label: 'Slippage',
                  value: '${(metadata.slippagePct ?? 0).toStringAsFixed(2)}%',
                  valueColor: _auditAmber,
                ),
              ),
              if (metadata.pnl != null)
                Expanded(
                  child: _MetadataValue(
                    label: 'P/L',
                    value: _formatSignedUsd(metadata.pnl!),
                    valueColor: metadata.pnl! >= 0
                        ? AppColors.buy
                        : AppColors.sell,
                  ),
                )
              else
                const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetadataValue extends StatelessWidget {
  const _MetadataValue({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: AppSpacing.copyAuditMetaLineHeight,
          ),
        ),
        const SizedBox(height: AppSpacing.formFieldLabelGap),
        Text(
          value,
          style: AppTextStyles.numericMicro.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _EmptyAuditState extends StatelessWidget {
  const _EmptyAuditState({required this.searching});

  final bool searching;

  @override
  Widget build(BuildContext context) {
    return VitEmptyState(
      key: CopyAuditLogPage.emptyStateKey,
      title: searching ? 'Không tìm thấy event phù hợp' : 'Chưa có event nào',
      icon: Icons.description_outlined,
    );
  }
}
