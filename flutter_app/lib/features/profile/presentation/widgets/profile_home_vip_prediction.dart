part of '../pages/profile_page.dart';

class _VipCard extends StatelessWidget {
  const _VipCard({required this.vip});

  final ProfileVipProgress vip;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: _profileBorder,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'VIP Progress',
                style: AppTextStyles.control.copyWith(color: AppColors.text2),
              ),
              const SizedBox(width: AppSpacing.profileModuleStatGap),
              Flexible(
                child: Text(
                  '${vip.label} \u2192 ${vip.nextLabel}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.badge.copyWith(color: _profileAmber),
                ),
              ),
            ],
          ),
          SizedBox(height: VitDensity.compact.verticalSpace),
          ClipRRect(
            borderRadius: AppRadii.pillRadius,
            child: LinearProgressIndicator(
              minHeight: AppSpacing.profileVipProgressHeight,
              value: vip.progress,
              color: AppColors.primary,
              backgroundColor: _profilePanel2,
            ),
          ),
          SizedBox(height: VitDensity.compact.verticalSpace),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              vip.volumeLabel,
              style: AppTextStyles.numericMicro.copyWith(color: _profileMuted),
            ),
          ),
        ],
      ),
    );
  }
}

class _PredictionCard extends StatelessWidget {
  const _PredictionCard({required this.prediction, required this.onTap});

  final ProfilePredictionBlock prediction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ProfilePage.predictionCardKey,
      onTap: onTap,
      density: VitDensity.compact,
      borderColor: _profilePurple.withValues(alpha: .38),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.adjust_rounded,
                color: _profilePurple,
                size: AppSpacing.profileModuleIcon,
              ),
              const SizedBox(width: AppSpacing.profileModuleGap),
              Expanded(
                child: Text(
                  'Prediction Portfolio',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.control.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.profileModuleGap),
              _TinyTag(label: 'Prediction Market', color: _profilePurple),
            ],
          ),
          SizedBox(height: VitDensity.compact.verticalSpace),
          Row(
            children: [
              Expanded(
                child: _ModuleStat(
                  label: 'V\u1ECB th\u1EBF',
                  value: '${prediction.positions}',
                ),
              ),
              const SizedBox(width: AppSpacing.profileModuleStatGap),
              Expanded(
                child: _ModuleStat(
                  label: 'L\u1EC7nh m\u1EDF',
                  value: '${prediction.openOrders}',
                ),
              ),
              const SizedBox(width: AppSpacing.profileModuleStatGap),
              Expanded(
                child: _ModuleStat(
                  label: 'P/L',
                  value: prediction.pnlLabel,
                  valueColor: _profileGreen,
                ),
              ),
            ],
          ),
          SizedBox(height: VitDensity.compact.verticalSpace),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Xem portfolio',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.badge.copyWith(color: _profilePurple),
                ),
              ),
              const SizedBox(width: AppSpacing.profileHeroInfoTrailingGap),
              const Icon(
                Icons.chevron_right_rounded,
                color: _profilePurple,
                size: AppSpacing.profileModuleLinkIcon,
              ),
              const SizedBox(width: AppSpacing.profileModuleEndGap),
              const Icon(
                Icons.emoji_events_outlined,
                color: _profileMuted,
                size: AppSpacing.profileModuleLinkIcon,
              ),
              const SizedBox(width: AppSpacing.profileHeroInfoTrailingGap),
              Flexible(
                child: Text(
                  'Leaderboard',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.numericMicro.copyWith(
                    color: _profileMuted,
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
