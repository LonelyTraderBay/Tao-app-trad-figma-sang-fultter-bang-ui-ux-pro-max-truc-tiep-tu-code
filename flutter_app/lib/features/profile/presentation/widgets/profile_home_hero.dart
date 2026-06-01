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
    return Container(
      height: 216,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _profileHero,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppColors.portfolioBorder),
        gradient: const RadialGradient(
          center: Alignment(.85, -.9),
          radius: 1.15,
          colors: [AppColors.primary12, _profileHero],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: AppRadii.cardRadius,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _profilePurple.withValues(alpha: .45),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  user.fullName.characters.first,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.onAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontSize: 13,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
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
              GestureDetector(
                key: ProfilePage.editProfileKey,
                onTap: onEdit,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.onAccent.withValues(alpha: .11),
                    borderRadius: AppRadii.lgRadius,
                    border: Border.all(
                      color: AppColors.onAccent.withValues(alpha: .12),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.text2,
                    size: 21,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: _HeroInfoBox(label: 'UID', value: user.id),
              ),
              const SizedBox(width: 12),
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
                      size: 15,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        borderRadius: AppRadii.smRadius,
        border: Border.all(color: color.withValues(alpha: .28)),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
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
    return Container(
      height: 66,
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.onAccent.withValues(alpha: .08),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.onAccent.withValues(alpha: .08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: valueColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    height: 1,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 6), trailing!],
            ],
          ),
        ],
      ),
    );
  }
}
