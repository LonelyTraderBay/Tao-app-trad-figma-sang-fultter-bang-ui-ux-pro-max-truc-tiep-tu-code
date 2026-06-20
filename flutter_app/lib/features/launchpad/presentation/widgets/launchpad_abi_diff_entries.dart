part of '../pages/launchpad_abi_diff_page.dart';

class _AbiEntryCard extends StatelessWidget {
  const _AbiEntryCard({
    required this.entry,
    required this.expanded,
    required this.onToggle,
  });

  final LaunchpadAbiDiffEntryDraft entry;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final change = entry.changeType;
    final risk = entry.riskLevel;
    return VitCard(
      key: LaunchpadAbiDiffPage.entryKey(entry.name),
      padding: AppSpacing.zeroInsets,
      clip: true,
      borderColor: change.color.withValues(alpha: .30),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: AppSpacing.launchpadVerticalMarkerWidth,
              child: ColoredBox(color: change.color),
            ),
          ),
          Column(
            children: [
              InkWell(
                key: LaunchpadAbiDiffPage.expandKey(entry.name),
                onTap: onToggle,
                child: Padding(
                  padding: AppSpacing.launchpadPaddingX3,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ChangeIcon(change: change),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    entry.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.base.copyWith(
                                      color: AppColors.text1,
                                      fontWeight: AppTextStyles.heavy,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.x2),
                                _SmallBadge(
                                  label: entry.type,
                                  color: AppColors.text3,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.x2),
                            Wrap(
                              spacing: AppSpacing.x1,
                              runSpacing: AppSpacing.x1,
                              children: [
                                _SmallBadge(
                                  label: change.label.toUpperCase(),
                                  color: change.color,
                                ),
                                if (risk != LaunchpadAbiRiskLevel.none)
                                  _SmallBadge(
                                    label: risk.label,
                                    color: risk.color,
                                    icon: risk.icon,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        expanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: AppColors.text3,
                        size: AppSpacing.launchpadIcon2xl,
                      ),
                    ],
                  ),
                ),
              ),
              if (expanded) _AbiEntryDetails(entry: entry),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChangeIcon extends StatelessWidget {
  const _ChangeIcon({required this.change});

  final LaunchpadAbiChangeType change;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.launchpadBox30,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: change.color.withValues(alpha: .14),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
        ),
        child: Icon(
          change.icon,
          color: change.color,
          size: AppSpacing.launchpadIconXl,
        ),
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .14),
        shape: RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: AppSpacing.launchpadMiniChipPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: color, size: AppSpacing.launchpadIconXxs),
                  const SizedBox(width: AppSpacing.launchpadGapXxs),
                ],
                Text(
                  label,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.heavy,
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

class _AbiEntryDetails extends StatelessWidget {
  const _AbiEntryDetails({required this.entry});

  final LaunchpadAbiDiffEntryDraft entry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: const ShapeDecoration(
          shape: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: Padding(
          padding: AppSpacing.launchpadPaddingX4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (entry.oldSignature != null)
                _SignatureBlock(
                  label: 'Old signature',
                  value: entry.oldSignature!,
                  color: entry.changeType == LaunchpadAbiChangeType.removed
                      ? AppColors.sell
                      : AppColors.text2,
                ),
              if (entry.newSignature != null)
                _SignatureBlock(
                  label: 'New signature',
                  value: entry.newSignature!,
                  color: entry.changeType == LaunchpadAbiChangeType.added
                      ? AppColors.buy
                      : AppColors.text1,
                ),
              if (entry.oldVisibility != null || entry.newVisibility != null)
                _DetailLine(
                  label: 'Visibility',
                  value: _compareText(entry.oldVisibility, entry.newVisibility),
                ),
              if (entry.oldStateMutability != null ||
                  entry.newStateMutability != null)
                _DetailLine(
                  label: 'State mutability',
                  value: _compareText(
                    entry.oldStateMutability,
                    entry.newStateMutability,
                  ),
                ),
              if (entry.riskNote != null)
                Padding(
                  padding: AppSpacing.launchpadTopPaddingX2,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: entry.riskLevel.color.withValues(alpha: .08),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadii.inputRadius,
                        side: BorderSide(
                          color: entry.riskLevel.color.withValues(alpha: .18),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: AppSpacing.launchpadPaddingX3,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            entry.riskLevel.icon,
                            color: entry.riskLevel.color,
                            size: AppSpacing.launchpadIconMd,
                          ),
                          const SizedBox(width: AppSpacing.x2),
                          Expanded(
                            child: Text(
                              entry.riskNote!,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                                height: AppSpacing.launchpadLineHeightDense,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignatureBlock extends StatelessWidget {
  const _SignatureBlock({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.launchpadTopPaddingX2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          SizedBox(
            width: double.infinity,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: AppColors.surface2,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.inputRadius,
                ),
              ),
              child: Padding(
                padding: AppSpacing.launchpadPaddingX2,
                child: Text(
                  value,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.extraBold,
                    height: AppSpacing.launchpadLineHeightDense,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.launchpadTopPaddingX2,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.extraBold,
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskWarning extends StatelessWidget {
  const _RiskWarning();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: LaunchpadAbiDiffPage.warningKey,
      decoration: ShapeDecoration(
        color: AppColors.warn08,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.inputRadius,
          side: const BorderSide(color: AppColors.warn15),
        ),
      ),
      child: Padding(
        padding: AppSpacing.launchpadPaddingX3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: AppSpacing.launchpadIconXl,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                'Day la so sanh ABI tu dong. Can kiem tra source code thuc te de hieu day du anh huong cua cac thay doi.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: AppSpacing.launchpadLineHeightReadable,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
