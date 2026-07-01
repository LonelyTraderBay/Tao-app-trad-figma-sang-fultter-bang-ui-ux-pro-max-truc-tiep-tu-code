part of '../pages/vip_page.dart';

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({super.key, required this.snapshot});

  final ProfileVipSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final nextTier = snapshot.nextTier;
    final children = <Widget>[];
    if (nextTier != null) {
      children.add(_ProgressCard(snapshot: snapshot, nextTier: nextTier));
      children.add(SizedBox(height: VitDensity.compact.pageContentGap));
    }
    children.add(_TierTable(snapshot: snapshot));
    children.add(SizedBox(height: VitDensity.compact.pageContentGap));
    children.add(const _FeeSavingsCard());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.snapshot, required this.nextTier});

  final ProfileVipSnapshot snapshot;
  final ProfileVipTier nextTier;

  @override
  Widget build(BuildContext context) {
    final volumeProgress = (snapshot.monthlyVolume / nextTier.monthlyVolume)
        .clamp(0.0, 1.0);
    final assetProgress = (snapshot.assetHold / nextTier.assetHold).clamp(
      0.0,
      1.0,
    );

    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Ti\u1EBFn \u0111\u1ED9 l\u00EAn h\u1EA1ng',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(width: AppSpacing.x3),
              _TierIcon(tier: nextTier),
            ],
          ),
          SizedBox(height: VitDensity.compact.verticalSpace),
          _ProgressLine(
            label: 'Kh\u1ED1i l\u01B0\u1EE3ng 30 ng\u00E0y',
            value:
                '${_formatUsd(snapshot.monthlyVolume)} / ${_formatUsd(nextTier.monthlyVolume)}',
            progress: volumeProgress,
            color: _vipAccent,
            helper:
                'C\u1EA7n th\u00EAm ${_formatUsd(nextTier.monthlyVolume - snapshot.monthlyVolume)} \u0111\u1EC3 \u0111\u1EA1t m\u1EE5c ti\u00EAu',
          ),
          SizedBox(height: VitDensity.compact.verticalSpace),
          _ProgressLine(
            label: 'T\u00E0i s\u1EA3n \u0111ang gi\u1EEF',
            value:
                '${_formatUsd(snapshot.assetHold)} / ${_formatUsd(nextTier.assetHold)}',
            progress: assetProgress,
            color: _vipSuccess,
            helper:
                '\u2713 \u0110i\u1EC1u ki\u1EC7n t\u00E0i s\u1EA3n \u0111\u1EA1t \u2713',
            helperColor: _vipSuccess,
          ),
        ],
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
    required this.helper,
    this.helperColor = _vipMuted,
  });

  final String label;
  final String value;
  final double progress;
  final Color color;
  final String helper;
  final Color helperColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.heavy,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        SizedBox(height: VitDensity.compact.verticalSpace),
        ClipRRect(
          borderRadius: AppRadii.pillRadius,
          child: LinearProgressIndicator(
            minHeight: AppSpacing.x3,
            value: progress,
            color: color,
            backgroundColor: AppColors.surface3,
          ),
        ),
        SizedBox(height: VitDensity.compact.verticalSpace),
        Text(helper, style: AppTextStyles.micro.copyWith(color: helperColor)),
      ],
    );
  }
}

class _TierTable extends StatelessWidget {
  const _TierTable({required this.snapshot});

  final ProfileVipSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      density: VitDensity.compact,
      child: Column(
        children: [
          Padding(
            padding: AppSpacing.profileVipTableTitlePadding,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'So s\u00E1nh c\u00E1c c\u1EA5p VIP',
                style: AppTextStyles.body.copyWith(
                  fontWeight: AppTextStyles.heavy,
                ),
              ),
            ),
          ),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          const _TableHeader(),
          for (final tier in snapshot.tiers) ...[
            const Divider(
              height: AppSpacing.dividerHairline,
              color: AppColors.divider,
            ),
            _TierRow(tier: tier, active: tier.level == snapshot.currentLevel),
          ],
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.profileVipTableHeaderPadding,
      child: Row(
        children: [
          _TableCell(
            flex: 28,
            child: Text('C\u1EA5p \u0111\u1ED9', style: _headerStyle),
          ),
          _TableCell(
            flex: 26,
            child: Text('Volume/th\u00E1ng', style: _headerStyle),
          ),
          _TableCell(flex: 22, child: Text('Maker', style: _headerStyle)),
          _TableCell(flex: 22, child: Text('Taker', style: _headerStyle)),
        ],
      ),
    );
  }

  TextStyle get _headerStyle => AppTextStyles.navLabel.copyWith(
    color: _vipMuted,
    fontWeight: AppTextStyles.normal,
  );
}

class _TierRow extends StatelessWidget {
  const _TierRow({required this.tier, required this.active});

  final ProfileVipTier tier;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final textColor = active ? _vipAccent : AppColors.text1;
    return Material(
      key: VIPPage.tierRowKey(tier.level),
      color: active ? AppColors.primary08 : AppColors.transparent,
      child: Padding(
        padding: AppSpacing.profileVipTableRowPadding,
        child: Row(
          children: [
            _TableCell(
              flex: 28,
              child: Row(
                children: [
                  _TierIcon(tier: tier),
                  const SizedBox(width: AppSpacing.profileVipTierNameGap),
                  Flexible(
                    child: Text(
                      tier.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: textColor,
                        fontWeight: active
                            ? AppTextStyles.heavy
                            : AppTextStyles.bold,
                      ),
                    ),
                  ),
                  if (active) ...[
                    const SizedBox(width: AppSpacing.profileVipActiveDotGap),
                    const SizedBox(
                      width: AppSpacing.profileVipActiveDot,
                      height: AppSpacing.profileVipActiveDot,
                      child: Material(color: _vipAccent, shape: CircleBorder()),
                    ),
                  ],
                ],
              ),
            ),
            _TableCell(
              flex: 26,
              child: Text(
                tier.monthlyVolume == 0
                    ? '-'
                    : _formatCompactUsd(tier.monthlyVolume),
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
            ),
            _TableCell(
              flex: 22,
              child: Text(_formatFee(tier.makerFee), style: _feeStyle(active)),
            ),
            _TableCell(
              flex: 22,
              child: Text(_formatFee(tier.takerFee), style: _feeStyle(active)),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _feeStyle(bool active) {
    return AppTextStyles.micro.copyWith(
      color: active ? _vipSuccess : AppColors.text1,
      fontWeight: AppTextStyles.heavy,
      fontFeatures: AppTextStyles.tabularFigures,
    );
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell({required this.flex, required this.child});

  final int flex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: flex, child: child);
  }
}

class _FeeSavingsCard extends StatelessWidget {
  const _FeeSavingsCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: _vipSuccess.withValues(alpha: .24),
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bolt_rounded,
                color: _vipSuccess,
                size: AppSpacing.profileVipSavingsIcon,
              ),
              const SizedBox(width: AppSpacing.profileVipSavingsIconGap),
              Text(
                'Ti\u1EBFt ki\u1EC7m ph\u00ED c\u1EE7a b\u1EA1n',
                style: AppTextStyles.body.copyWith(
                  color: _vipSuccess,
                  fontWeight: AppTextStyles.heavy,
                ),
              ),
            ],
          ),
          SizedBox(height: VitDensity.compact.verticalSpace),
          Row(
            children: const [
              Expanded(
                child: _SavingBox(
                  label: 'Th\u00E1ng n\u00E0y',
                  value: '\$12.45',
                  sub: 'vs. Standard rate',
                ),
              ),
              SizedBox(width: AppSpacing.profileVipSavingsBoxGap),
              Expanded(
                child: _SavingBox(
                  label: 'T\u1ED5ng t\u00EDch l\u0169y',
                  value: '\$89.30',
                  sub: 't\u1EEB 15/08/2023',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SavingBox extends StatelessWidget {
  const _SavingBox({
    required this.label,
    required this.value,
    required this.sub,
  });

  final String label;
  final String value;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.micro.copyWith(color: _vipMuted)),
          SizedBox(height: VitDensity.compact.verticalSpace),
          Text(
            value,
            style: AppTextStyles.base.copyWith(
              color: _vipSuccess,
              fontWeight: AppTextStyles.heavy,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          SizedBox(height: VitDensity.compact.verticalSpace),
          Text(sub, style: AppTextStyles.micro.copyWith(color: _vipMuted)),
        ],
      ),
    );
  }
}
