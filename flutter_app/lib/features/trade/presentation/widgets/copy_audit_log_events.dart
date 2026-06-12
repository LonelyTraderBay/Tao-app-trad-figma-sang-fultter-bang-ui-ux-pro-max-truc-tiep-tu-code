part of '../pages/copy_audit_log_page.dart';

class _AuditEventCard extends StatelessWidget {
  const _AuditEventCard({super.key, required this.event});

  final TradeCopyAuditEvent event;

  @override
  Widget build(BuildContext context) {
    final color = _eventColor(event);
    return VitCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      borderColor: AppColors.cardBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .18),
              shape: BoxShape.circle,
            ),
            child: Icon(_eventIcon(event), color: color, size: 21),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.18,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  event.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 11,
                    fontWeight: AppTextStyles.medium,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 12),
                _EventMetaRow(event: event, color: color),
                if (_hasVisibleMetadata(event)) ...[
                  const SizedBox(height: 13),
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
        const Icon(Icons.access_time_rounded, color: AppColors.text3, size: 11),
        const SizedBox(width: 5),
        Text(
          event.timestamp,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
            height: 1,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '•',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
            height: 1,
          ),
        ),
        const SizedBox(width: 8),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .18),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        _eventTypeLabel(type),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
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
        height: 29,
        width: double.infinity,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          '${metadata.oldValue} → ${metadata.newValue}',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
            height: 1,
          ),
        ),
      );
    }

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(9, 9, 9, 10),
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
          const SizedBox(height: 10),
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
            fontSize: 9,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppTextStyles.micro.copyWith(
            color: valueColor,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
            height: 1,
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
