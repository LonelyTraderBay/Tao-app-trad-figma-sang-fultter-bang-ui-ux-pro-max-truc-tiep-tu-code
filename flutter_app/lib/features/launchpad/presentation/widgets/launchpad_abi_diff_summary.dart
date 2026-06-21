part of '../pages/launchpad_abi_diff_page.dart';

class _RiskHero extends StatelessWidget {
  const _RiskHero({required this.diff});

  final LaunchpadAbiDiffResultDraft diff;

  @override
  Widget build(BuildContext context) {
    final riskColor = _riskScoreColor(diff.riskScore);
    return VitCard(
      key: LaunchpadAbiDiffPage.heroKey,
      variant: VitCardVariant.hero,
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .22),
      padding: AppSpacing.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_tree_outlined,
                color: AppColors.portfolioTextMuted,
                size: AppSpacing.launchpadIconXl,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Proxy Upgrade Detected',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.portfolioTextDim,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              _RiskScoreRing(score: diff.riskScore, color: riskColor),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Risk Score',
                      style: AppTextStyles.base.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.heavy,
                      ),
                    ),
                    Text(
                      'Trung binh - Co thay doi dang chu y',
                      style: AppTextStyles.caption.copyWith(
                        color: riskColor,
                        fontWeight: AppTextStyles.extraBold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _ImplCard(
                  label: 'OLD',
                  title: diff.oldImplLabel,
                  address: _truncateAddress(diff.oldImpl),
                  color: AppColors.sell,
                ),
              ),
              const Padding(
                padding: AppSpacing.launchpadHorizontalPaddingX3,
                child: Icon(
                  Icons.bolt_rounded,
                  color: AppColors.portfolioTextMuted,
                  size: AppSpacing.launchpadIconXl,
                ),
              ),
              Expanded(
                child: _ImplCard(
                  label: 'NEW',
                  title: diff.newImplLabel,
                  address: _truncateAddress(diff.newImpl),
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskScoreRing extends StatelessWidget {
  const _RiskScoreRing({required this.score, required this.color});

  final int score;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.launchpadBox64,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: .08),
          shape: CircleBorder(
            side: BorderSide(
              color: color,
              width: AppSpacing.launchpadBorderWidthStrong,
            ),
          ),
        ),
        child: Center(
          child: Text(
            '$score',
            style: AppTextStyles.base.copyWith(
              color: color,
              fontWeight: AppTextStyles.heavy,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImplCard extends StatelessWidget {
  const _ImplCard({
    required this.label,
    required this.title,
    required this.address,
    required this.color,
  });

  final String label;
  final String title;
  final String address;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .08),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.inputRadius,
          side: BorderSide(color: color.withValues(alpha: .18)),
        ),
      ),
      child: Padding(
        padding: AppSpacing.launchpadPaddingX3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.portfolioTextMuted,
                fontWeight: AppTextStyles.extraBold,
              ),
            ),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: color == AppColors.buy ? color : AppColors.text1,
                fontWeight: AppTextStyles.heavy,
              ),
            ),
            Text(
              address,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.portfolioTextMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryStats extends StatelessWidget {
  const _SummaryStats({
    required this.diff,
    required this.activeFilter,
    required this.onChanged,
  });

  final LaunchpadAbiDiffResultDraft diff;
  final LaunchpadAbiChangeType? activeFilter;
  final ValueChanged<LaunchpadAbiChangeType> onChanged;

  @override
  Widget build(BuildContext context) {
    final stats = [
      (LaunchpadAbiChangeType.added, diff.added),
      (LaunchpadAbiChangeType.removed, diff.removed),
      (LaunchpadAbiChangeType.modified, diff.modified),
      (LaunchpadAbiChangeType.unchanged, diff.unchanged),
    ];
    return Row(
      key: LaunchpadAbiDiffPage.statsKey,
      children: [
        for (final stat in stats) ...[
          Expanded(
            child: VitCard(
              onTap: () => onChanged(stat.$1),
              borderColor: activeFilter == stat.$1
                  ? stat.$1.color.withValues(alpha: .42)
                  : null,
              padding: AppSpacing.launchpadTierChipPadding,
              child: Column(
                key: LaunchpadAbiDiffPage.statKey(stat.$1.value),
                children: [
                  Icon(
                    stat.$1.icon,
                    color: stat.$1.color,
                    size: AppSpacing.launchpadIconXl,
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    '${stat.$2}',
                    style: AppTextStyles.base.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.heavy,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  Text(
                    stat.$1.label,
                    style: AppTextStyles.micro.copyWith(
                      color: stat.$1.color,
                      fontWeight: AppTextStyles.extraBold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (stat != stats.last) const SizedBox(width: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _UpgradeMetadata extends StatelessWidget {
  const _UpgradeMetadata({
    required this.diff,
    required this.copiedField,
    required this.onCopy,
  });

  final LaunchpadAbiDiffResultDraft diff;
  final String? copiedField;
  final void Function(String label, String value) onCopy;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _MetaRowData(
        'Contract',
        _truncateAddress(diff.contractAddress),
        diff.contractAddress,
      ),
      _MetaRowData('Chain', diff.chain, null),
      _MetaRowData('Block', '#${_formatInt(diff.upgradeBlock)}', null),
      _MetaRowData('Thoi gian', diff.upgradeTimestamp, null),
      _MetaRowData(
        'Tx Hash',
        _truncateAddress(diff.upgradeTxHash),
        diff.upgradeTxHash,
      ),
      _MetaRowData(
        'Functions',
        '${diff.totalFunctionsOld} -> ${diff.totalFunctionsNew}',
        null,
      ),
      _MetaRowData(
        'Events',
        '${diff.totalEventsOld} -> ${diff.totalEventsNew}',
        null,
      ),
    ];
    return VitCard(
      key: LaunchpadAbiDiffPage.metadataKey,
      padding: AppSpacing.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.code_rounded,
                color: AppColors.accent,
                size: AppSpacing.launchpadIconXl,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Thong tin upgrade',
                style: AppTextStyles.base.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.heavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final row in rows)
            _MetaRow(
              row: row,
              copied: copiedField == row.label,
              onCopy: row.copyValue == null
                  ? null
                  : () => onCopy(row.label, row.copyValue!),
            ),
        ],
      ),
    );
  }
}

class _MetaRowData {
  const _MetaRowData(this.label, this.value, this.copyValue);

  final String label;
  final String value;
  final String? copyValue;
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.row, required this.copied, this.onCopy});

  final _MetaRowData row;
  final bool copied;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        shape: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: AppSpacing.launchpadVerticalPaddingX2,
        child: Row(
          children: [
            Expanded(
              child: Text(
                row.label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ),
            Flexible(
              child: Text(
                row.value,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.heavy,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            if (onCopy != null) ...[
              const SizedBox(width: AppSpacing.x1),
              InkWell(
                key: LaunchpadAbiDiffPage.copyKey(row.label),
                borderRadius: AppRadii.xsRadius,
                onTap: onCopy,
                child: Icon(
                  copied ? Icons.check_rounded : Icons.copy_rounded,
                  color: copied ? AppColors.buy : AppColors.text3,
                  size: AppSpacing.launchpadIconMd,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.active,
    required this.count,
    required this.onChanged,
  });

  final bool active;
  final int count;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          key: LaunchpadAbiDiffPage.functionsOnlyKey,
          borderRadius: AppRadii.inputRadius,
          onTap: onChanged,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: active ? AppColors.primary12 : AppColors.surface2,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.inputRadius,
                side: BorderSide(
                  color: active ? AppColors.primary30 : AppColors.cardBorder,
                ),
              ),
            ),
            child: Padding(
              padding: AppSpacing.launchpadPillPadding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.code_rounded,
                    color: active
                        ? AppModuleAccents.launchpad
                        : AppColors.text3,
                    size: AppSpacing.launchpadIconMd,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Text(
                    'Functions only',
                    style: AppTextStyles.caption.copyWith(
                      color: active
                          ? AppModuleAccents.launchpad
                          : AppColors.text3,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Text(
          '$count entries',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
