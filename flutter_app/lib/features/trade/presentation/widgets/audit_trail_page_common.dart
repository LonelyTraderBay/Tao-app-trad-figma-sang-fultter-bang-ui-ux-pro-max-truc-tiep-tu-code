part of '../pages/audit_trail_page.dart';

class _AuditEntryCard extends StatelessWidget {
  const _AuditEntryCard({required this.entry});

  final TradeAuditEntry entry;

  @override
  Widget build(BuildContext context) {
    final style = _styleForCategory(entry.category);
    return VitCard(
      constraints: const BoxConstraints(minHeight: 89),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      borderColor: _auditBorder.withValues(alpha: .76),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: style.color.withValues(alpha: .14),
              borderRadius: AppRadii.lgRadius,
            ),
            child: Icon(style.icon, color: style.color, size: 19),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        entry.action,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 12,
                          fontWeight: AppTextStyles.bold,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    _CategoryBadge(entry: entry, color: style.color),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  entry.details,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 10,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _metadata(entry),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 9,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'ID: ${entry.id}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 8,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _metadata(TradeAuditEntry entry) {
    final parts = [
      entry.timestampLabel,
      if (entry.user != null) entry.user!,
      if (entry.ipAddress != null) entry.ipAddress!,
    ];
    return parts.join('  \u2022  ');
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.entry, required this.color});

  final TradeAuditEntry entry;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        entry.categoryLabel,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _ExportActions extends StatelessWidget {
  const _ExportActions({required this.formats});

  final List<String> formats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final format in formats) ...[
          Expanded(
            child: VitCtaButton(
              key: AuditTrailPage.exportKey(format),
              onPressed: () {},
              variant: VitCtaButtonVariant.secondary,
              height: 40,
              leading: const Icon(Icons.download_rounded, size: 14),
              child: Text(
                format,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
          ),
          if (format != formats.last) const SizedBox(width: 12),
        ],
      ],
    );
  }
}

_AuditCategoryStyle _styleForCategory(TradeAuditCategory category) {
  return switch (category) {
    TradeAuditCategory.trade => const _AuditCategoryStyle(
      color: _auditGreen,
      icon: Icons.trending_up_rounded,
    ),
    TradeAuditCategory.compliance => const _AuditCategoryStyle(
      color: _auditPrimary,
      icon: Icons.description_outlined,
    ),
    TradeAuditCategory.clientAction => const _AuditCategoryStyle(
      color: _auditAmber,
      icon: Icons.person_outline_rounded,
    ),
    TradeAuditCategory.system => const _AuditCategoryStyle(
      color: AppColors.text3,
      icon: Icons.schedule_rounded,
    ),
  };
}

final class _AuditCategoryStyle {
  const _AuditCategoryStyle({required this.color, required this.icon});

  final Color color;
  final IconData icon;
}
