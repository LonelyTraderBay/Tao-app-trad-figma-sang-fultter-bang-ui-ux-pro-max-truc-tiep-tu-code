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
      children.add(const SizedBox(height: AppSpacing.x5));
    }
    children.add(_TierTable(snapshot: snapshot));
    children.add(const SizedBox(height: AppSpacing.x5));
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Ti\u1EBFn \u0111\u1ED9 l\u00EAn h\u1EA1ng',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const Spacer(),
              _TierIcon(tier: nextTier),
            ],
          ),
          const SizedBox(height: 16),
          _ProgressLine(
            label: 'Kh\u1ED1i l\u01B0\u1EE3ng 30 ng\u00E0y',
            value:
                '${_formatUsd(snapshot.monthlyVolume)} / ${_formatUsd(nextTier.monthlyVolume)}',
            progress: volumeProgress,
            color: _vipAccent,
            helper:
                'C\u1EA7n th\u00EAm ${_formatUsd(nextTier.monthlyVolume - snapshot.monthlyVolume)} \u0111\u1EC3 \u0111\u1EA1t m\u1EE5c ti\u00EAu',
          ),
          const SizedBox(height: 17),
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
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1,
                ),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: FontWeight.w900,
                fontFeatures: AppTextStyles.tabularFigures,
                height: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 10,
            value: progress,
            color: color,
            backgroundColor: AppColors.surface3,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        Text(
          helper,
          style: AppTextStyles.micro.copyWith(
            color: helperColor,
            fontSize: 11,
            height: 1,
          ),
        ),
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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'So s\u00E1nh c\u00E1c c\u1EA5p VIP',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          const _TableHeader(),
          for (final tier in snapshot.tiers)
            _TierRow(tier: tier, active: tier.level == snapshot.currentLevel),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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

  TextStyle get _headerStyle =>
      AppTextStyles.micro.copyWith(color: _vipMuted, fontSize: 11);
}

class _TierRow extends StatelessWidget {
  const _TierRow({required this.tier, required this.active});

  final ProfileVipTier tier;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final textColor = active ? _vipAccent : AppColors.text1;
    return Container(
      key: VIPPage.tierRowKey(tier.level),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: active ? AppColors.primary08 : AppColors.transparent,
        border: const Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          _TableCell(
            flex: 28,
            child: Row(
              children: [
                _TierIcon(tier: tier),
                const SizedBox(width: AppSpacing.x3),
                Flexible(
                  child: Text(
                    tier.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: textColor,
                      fontWeight: active ? FontWeight.w900 : FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                ),
                if (active) ...[
                  const SizedBox(width: AppSpacing.x2),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: _vipAccent,
                      shape: BoxShape.circle,
                    ),
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
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 12,
              ),
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
    );
  }

  TextStyle _feeStyle(bool active) {
    return AppTextStyles.micro.copyWith(
      color: active ? _vipSuccess : AppColors.text1,
      fontSize: 12,
      fontWeight: FontWeight.w900,
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: _vipSuccess, size: 17),
              const SizedBox(width: AppSpacing.x3),
              Text(
                'Ti\u1EBFt ki\u1EC7m ph\u00ED c\u1EE7a b\u1EA1n',
                style: AppTextStyles.body.copyWith(
                  color: _vipSuccess,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: const [
              Expanded(
                child: _SavingBox(
                  label: 'Th\u00E1ng n\u00E0y',
                  value: '\$12.45',
                  sub: 'vs. Standard rate',
                ),
              ),
              SizedBox(width: AppSpacing.x4),
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
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.micro.copyWith(color: _vipMuted)),
          const SizedBox(height: AppSpacing.x3),
          Text(
            value,
            style: AppTextStyles.base.copyWith(
              color: _vipSuccess,
              fontWeight: FontWeight.w900,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            sub,
            style: AppTextStyles.micro.copyWith(
              color: _vipMuted,
              fontSize: 10,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
