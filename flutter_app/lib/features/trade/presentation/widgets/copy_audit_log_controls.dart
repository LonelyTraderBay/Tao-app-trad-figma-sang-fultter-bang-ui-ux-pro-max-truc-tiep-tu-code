part of '../pages/copy_audit_log_page.dart';

class _ComplianceNotice extends StatelessWidget {
  const _ComplianceNotice({required this.snapshot});

  final TradeCopyAuditLogSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      borderColor: _auditPrimary,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: _auditPrimary, size: 15),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.complianceTitle,
                  style: AppTextStyles.micro.copyWith(
                    color: _auditPrimary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  snapshot.complianceDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: _auditPrimary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuditSearchField extends StatelessWidget {
  const _AuditSearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSearchBar(
      controller: controller,
      fieldKey: CopyAuditLogPage.searchFieldKey,
      placeholder: 'Tìm kiếm event, pair, ID...',
      variant: VitSearchBarVariant.compact,
      onChanged: onChanged,
    );
  }
}

class _AuditFilterTabs extends StatelessWidget {
  const _AuditFilterTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeCopyAuditTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final tab in tabs) ...[
          _AuditFilterPill(
            key: CopyAuditLogPage.tabKey(tab.id),
            tab: tab,
            active: tab.id == activeId,
            onTap: () => onChanged(tab.id),
          ),
          if (tab != tabs.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _AuditFilterPill extends StatelessWidget {
  const _AuditFilterPill({
    super.key,
    required this.tab,
    required this.active,
    required this.onTap,
  });

  final TradeCopyAuditTab tab;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.lgRadius,
      child: Container(
        width: _tabWidth(tab.id),
        height: 35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? _auditPrimary.withValues(alpha: .14) : _auditChip,
          borderRadius: AppRadii.lgRadius,
          border: Border.all(
            color: active ? _auditPrimary : AppColors.transparent,
          ),
        ),
        child: Text(
          tab.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.captionSm.copyWith(
            color: active ? _auditPrimary : _auditMuted,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }

  double _tabWidth(String id) {
    return switch (id) {
      'all' => 69,
      'trade' => 73,
      'config' => 74,
      'risk' => 61,
      'system' => 82,
      _ => 68,
    };
  }
}
