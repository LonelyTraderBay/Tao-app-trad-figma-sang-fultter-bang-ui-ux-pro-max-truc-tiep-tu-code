part of '../pages/arena_points_entry_detail_page.dart';

class _AmountHero extends StatelessWidget {
  const _AmountHero({required this.entry});

  final ArenaPointsEntryDraft entry;

  @override
  Widget build(BuildContext context) {
    final positive = entry.amount > 0;
    final color = positive
        ? AppColors.buy
        : entry.amount < 0
        ? AppColors.sell
        : AppColors.text1;
    return VitCard(
      padding: AppSpacing.arenaPointsEntryHeroPadding,
      child: Column(
        children: [
          Text(
            '${positive
                ? '+'
                : entry.amount < 0
                ? '-'
                : ''}${_formatPoints(entry.amount.abs())}',
            textAlign: TextAlign.center,
            style: AppTextStyles.heroNumber.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'pts',
            style: AppTextStyles.base.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              VitStatusPill(
                label: entry.typeLabel,
                status: VitStatusPillStatus.info,
                size: VitStatusPillSize.sm,
              ),
              VitStatusPill(
                label: entry.statusLabel,
                status: _status(entry.statusKind),
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EntryDetails extends StatelessWidget {
  const _EntryDetails({required this.entry});

  final ArenaPointsEntryDraft entry;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Chi tiết',
      accentColor: AppColors.accent,
      child: VitCard(
        padding: AppSpacing.arenaPointsEntryCardPadding,
        child: Column(
          children: [
            _DetailRow(label: 'Mô tả', value: entry.note),
            _DetailRow(label: 'Mã lý do', value: entry.reasonCode),
            _DetailRow(label: 'Thời gian', value: entry.time),
            if (entry.linkedChallengeId != null)
              _LinkedRow(
                key: ArenaPointsEntryDetailPage.challengeLinkKey,
                label: 'Challenge liên quan',
                value: entry.linkedChallengeName ?? entry.linkedChallengeId!,
                onTap: () => context.go(
                  AppRoutePaths.arenaChallenge(entry.linkedChallengeId!),
                ),
              ),
            if (entry.linkedModeId != null)
              _LinkedRow(
                key: ArenaPointsEntryDetailPage.modeLinkKey,
                label: 'Mode liên quan',
                value: entry.linkedModeName ?? entry.linkedModeId!,
                onTap: () =>
                    context.go(AppRoutePaths.arenaMode(entry.linkedModeId!)),
              ),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.entry});

  final ArenaPointsEntryDraft entry;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Biến động số dư',
      accentColor: AppColors.buy,
      child: VitCard(
        padding: AppSpacing.arenaPointsEntryCardPadding,
        child: Row(
          children: [
            Expanded(
              child: _BalanceColumn(
                label: 'Trước',
                value: _formatPoints(entry.balanceBefore),
              ),
            ),
            SizedBox.square(
              dimension: AppSpacing.arenaPointsEntryBalanceArrowBox,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: entry.amount >= 0 ? AppColors.buy10 : AppColors.sell10,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.xlRadius,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: entry.amount >= 0 ? AppColors.buy : AppColors.sell,
                    size: AppSpacing.arenaPointsInlineIcon,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _BalanceColumn(
                label: 'Sau',
                value: _formatPoints(entry.balanceAfter),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReferenceCard extends StatelessWidget {
  const _ReferenceCard({
    required this.entry,
    required this.copied,
    required this.onCopy,
  });

  final ArenaPointsEntryDraft entry;
  final bool copied;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Mã tham chiếu',
      accentColor: AppColors.text3,
      child: VitCard(
        padding: AppSpacing.arenaPointsEntryCardPadding,
        child: Row(
          children: [
            Expanded(
              child: Text(
                entry.refId,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  height: _entryBodyLineRatio,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            VitCard(
              key: ArenaPointsEntryDetailPage.copyRefKey,
              variant: VitCardVariant.inner,
              radius: VitCardRadius.sm,
              onTap: onCopy,
              padding: AppSpacing.arenaPointsEntryCopyPadding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    copied ? Icons.check_rounded : Icons.copy_rounded,
                    size: AppSpacing.arenaPointsSmallIcon,
                    color: copied ? AppColors.buy : AppColors.text2,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Text(
                    copied ? 'Đã chép' : 'Sao chép',
                    style: AppTextStyles.micro.copyWith(
                      color: copied ? AppColors.buy : AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuditNotice extends StatelessWidget {
  const _AuditNotice({required this.disclaimer});

  final String disclaimer;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.arenaPointsEntryNoticePadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.accent,
            size: AppSpacing.arenaPointsInlineIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              '$disclaimer Bản ghi này được hệ thống tạo tự động và không thể chỉnh sửa.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                height: _entryNoticeLineRatio,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryActions extends StatelessWidget {
  const _EntryActions({required this.entry, required this.onSupport});

  final ArenaPointsEntryDraft entry;
  final VoidCallback onSupport;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (entry.linkedChallengeId != null)
          VitCtaButton(
            onPressed: () => context.go(
              AppRoutePaths.arenaChallenge(entry.linkedChallengeId!),
            ),
            child: const Text('Xem challenge'),
          ),
        const SizedBox(height: AppSpacing.x3),
        VitCtaButton(
          key: ArenaPointsEntryDetailPage.supportKey,
          variant: VitCtaButtonVariant.secondary,
          onPressed: onSupport,
          leading: const Icon(
            Icons.help_outline_rounded,
            size: AppSpacing.arenaPointsInlineIcon,
          ),
          child: const Text('Liên hệ hỗ trợ'),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.accentColor,
    required this.child,
  });

  final String title;
  final Color accentColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            SizedBox(
              width: AppSpacing.arenaPointsEntrySectionMarkerWidth,
              height: _entrySectionMarkerExtent,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: accentColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.xsRadius,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        child,
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.arenaPointsEntryRowPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSpacing.arenaPointsEntryDetailLabelWidth,
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: _entryBodyLineRatio,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
