part of '../pages/profile_page.dart';

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({
    required this.user,
    required this.copiedReferral,
    required this.onEdit,
    required this.onCopyReferral,
  });

  final ProfileUser user;
  final bool copiedReferral;
  final VoidCallback onEdit;
  final VoidCallback onCopyReferral;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: AppSpacing.profileHeroHeight,
      padding: AppSpacing.profileHeroPadding,
      radius: VitCardRadius.lg,
      variant: VitCardVariant.hero,
      child: Column(
        children: [
          Row(
            children: [
              VitAssetAvatar(
                label: user.fullName,
                accentColor: AppColors.primary,
                size: AppSpacing.profileHeroAvatar,
                radius: AppRadii.cardRadius,
                border: true,
              ),
              const SizedBox(width: AppSpacing.profileMenuGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.control.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.profileHeroTextGap),
                    Text(
                      user.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.numericMicro.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.profileHeroEmailGap),
                    Wrap(
                      spacing: AppSpacing.profileHeroPillGap,
                      runSpacing: AppSpacing.profileHeroPillRunGap,
                      children: [
                        _HeroPill(label: user.vipLevel, color: _profileAmber),
                        _HeroPill(
                          label: 'KYC ${user.kycLevel}',
                          color: _profileGreen,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              VitIconButton(
                key: ProfilePage.editProfileKey,
                icon: Icons.person_outline_rounded,
                tooltip: 'Ch\u1EC9nh s\u1EEDa h\u1ED3 s\u01A1',
                onPressed: onEdit,
                size: VitIconButtonSize.md,
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: _HeroInfoBox(label: 'UID', value: user.id),
              ),
              const SizedBox(width: AppSpacing.profileHeroInfoGap),
              Expanded(
                child: GestureDetector(
                  key: ProfilePage.copyReferralKey,
                  onTap: onCopyReferral,
                  behavior: HitTestBehavior.opaque,
                  child: _HeroInfoBox(
                    label: 'M\u00E3 gi\u1EDBi thi\u1EC7u',
                    value: user.referralCode,
                    valueColor: AppColors.primarySoft,
                    trailing: Icon(
                      copiedReferral
                          ? Icons.check_circle_outline_rounded
                          : Icons.copy_rounded,
                      color: copiedReferral
                          ? _profileGreen
                          : AppColors.primarySoft,
                      size: AppSpacing.profileModuleIcon,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: color);
  }
}

class _HeroInfoBox extends StatelessWidget {
  const _HeroInfoBox({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.trailing,
  });

  final String label;
  final String value;
  final Color valueColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.profileHeroInfoHeight,
      child: Material(
        color: AppColors.onAccent.withValues(alpha: .08),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: BorderSide(color: AppColors.onAccent.withValues(alpha: .08)),
        ),
        child: Padding(
          padding: AppSpacing.profileHeroInfoPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.badge.copyWith(color: AppColors.text2),
              ),
              const Spacer(),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.control.copyWith(
                        color: valueColor,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(
                      width: AppSpacing.profileHeroInfoTrailingGap,
                    ),
                    trailing!,
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
