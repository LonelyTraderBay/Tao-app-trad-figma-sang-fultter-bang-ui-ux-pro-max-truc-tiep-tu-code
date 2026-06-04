part of '../pages/audit_trail_page.dart';

class _ComplianceNotice extends StatelessWidget {
  const _ComplianceNotice({required this.snapshot});

  final TradeAuditTrailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(
            Icons.description_outlined,
            color: AppColors.text1,
            size: 16,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snapshot.noticeTitle,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 11,
                  fontWeight: AppTextStyles.bold,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                snapshot.noticeDescription,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontSize: 10,
                  fontWeight: AppTextStyles.bold,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final List<TradeAuditStat> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final stat in stats) ...[
          Expanded(child: _StatCard(stat: stat)),
          if (stat != stats.last) const SizedBox(width: 13),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final TradeAuditStat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      padding: const EdgeInsets.fromLTRB(12, 15, 12, 11),
      decoration: BoxDecoration(
        color: _auditPanel,
        border: Border.all(color: _auditBorder.withValues(alpha: .76)),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            stat.value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: stat.emphasized ? _auditGreen : AppColors.text1,
              fontSize: 21,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchAndFilter extends StatelessWidget {
  const _SearchAndFilter({required this.placeholder, required this.onChanged});

  final String placeholder;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 39,
            child: TextField(
              key: AuditTrailPage.searchKey,
              onChanged: onChanged,
              cursorColor: _auditPrimary,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontFamily: 'Roboto',
                fontSize: 12,
                height: 1.2,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.fromLTRB(0, 11, 12, 11),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.text3,
                  size: 18,
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 39,
                  minHeight: 39,
                ),
                hintText: placeholder,
                hintStyle: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1.2,
                ),
                filled: true,
                fillColor: _auditPanel2,
                border: OutlineInputBorder(
                  borderRadius: AppRadii.lgRadius,
                  borderSide: BorderSide(
                    color: _auditBorder.withValues(alpha: .82),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadii.lgRadius,
                  borderSide: BorderSide(
                    color: _auditBorder.withValues(alpha: .82),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadii.lgRadius,
                  borderSide: const BorderSide(color: _auditPrimary),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 9),
        SizedBox(
          width: 39,
          height: 39,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _auditPanel2,
              border: Border.all(color: _auditBorder.withValues(alpha: .82)),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.filter_alt_outlined,
                color: AppColors.text3,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AuditTabs extends StatelessWidget {
  const _AuditTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeAuditTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      color: _auditTabsBackground,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: AuditTrailPage.tabKey(tab.id),
                onTap: () => onChanged(tab.id),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: tab.id == activeId
                                ? _auditPrimary
                                : AppColors.text3,
                            fontSize: tab.id == 'client' ? 11 : 12,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: tab.id == activeId ? 70 : 0,
                      height: 2,
                      color: tab.id == activeId
                          ? _auditPrimary
                          : AppColors.transparent,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _auditPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}
