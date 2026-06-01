part of '../pages/p2p_security_center_page.dart';

class _WhitelistAction extends StatelessWidget {
  const _WhitelistAction({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: onTap,
      child: Row(
        children: [
          _IconBadge(icon: icon, color: AppModuleAccents.p2p),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  body,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

class _HeaderSettingsButton extends StatelessWidget {
  const _HeaderSettingsButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.searchBg,
          border: Border.all(color: AppColors.border),
          borderRadius: AppRadii.mdRadius,
        ),
        child: IconButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.settings_outlined,
            color: AppColors.text1,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _SecurityScoreCard extends StatelessWidget {
  const _SecurityScoreCard({required this.snapshot});

  final P2PSecurityCenterSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final progress = snapshot.score / snapshot.maxScore;

    return VitCard(
      key: P2PSecurityCenterPage.scoreKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Security Score',
                      style: AppTextStyles.sectionTitle.copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      snapshot.scoreSubtitle,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(
                label: snapshot.scoreLabel,
                color: AppColors.buy,
                prominent: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Center(
            child: SizedBox(
              width: 128,
              height: 128,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.square(
                    dimension: 118,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 7,
                      strokeCap: StrokeCap.round,
                      backgroundColor: AppColors.surface2,
                      color: AppColors.buy,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${snapshot.score}',
                        style: AppTextStyles.heroNumber.copyWith(
                          color: AppColors.buy,
                          fontSize: 32,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        '/ ${snapshot.maxScore}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.buy10,
              borderRadius: AppRadii.mdRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x3,
              ),
              child: Text(
                snapshot.scoreBody,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.45,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityFeatures extends StatelessWidget {
  const _SecurityFeatures({required this.features, required this.onOpen});

  final List<P2PSecurityFeatureDraft> features;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PSecurityCenterPage.featuresKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle('Tính năng bảo mật'),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          radius: VitCardRadius.lg,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var index = 0; index < features.length; index++) ...[
                _SecurityFeatureRow(
                  feature: features[index],
                  onTap: () => onOpen(features[index].route),
                ),
                if (index != features.length - 1)
                  const Divider(height: 1, color: AppColors.divider),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SecurityFeatureRow extends StatelessWidget {
  const _SecurityFeatureRow({required this.feature, required this.onTap});

  final P2PSecurityFeatureDraft feature;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(feature.status);

    return InkWell(
      key: P2PSecurityCenterPage.featureKey(feature.id),
      onTap: onTap,
      borderRadius: AppRadii.lgRadius,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          children: [
            _IconBadge(icon: _featureIcon(feature.iconKey), color: color),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature.label,
                    style: AppTextStyles.baseMedium.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          _statusLabel(feature.status),
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: color,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      if (feature.scoreDelta > 0) ...[
                        const SizedBox(width: AppSpacing.x2),
                        Text(
                          '+ ${feature.scoreDelta} điểm',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconMd,
            ),
          ],
        ),
      ),
    );
  }
}
