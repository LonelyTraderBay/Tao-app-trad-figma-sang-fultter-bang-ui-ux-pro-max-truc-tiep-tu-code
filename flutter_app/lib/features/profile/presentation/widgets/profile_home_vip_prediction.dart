part of '../pages/profile_page.dart';

class _VipCard extends StatelessWidget {
  const _VipCard({required this.vip});

  final ProfileVipProgress vip;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _profilePanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _profileBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'VIP Progress',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 13,
                  height: 1,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  '${vip.label} \u2192 ${vip.nextLabel}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.micro.copyWith(
                    color: _profileAmber,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: vip.progress,
              color: AppColors.primary,
              backgroundColor: _profilePanel2,
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              vip.volumeLabel,
              style: AppTextStyles.micro.copyWith(
                color: _profileMuted,
                fontSize: 10,
                height: 1,
              ),
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
    return GestureDetector(
      key: ProfilePage.predictionCardKey,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 137,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _profilePanel,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: _profilePurple.withValues(alpha: .38)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.adjust_rounded,
                  color: _profilePurple,
                  size: 15,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Prediction Portfolio',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _TinyTag(label: 'Prediction Market', color: _profilePurple),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: _ModuleStat(
                    label: 'V\u1ECB th\u1EBF',
                    value: '${prediction.positions}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ModuleStat(
                    label: 'L\u1EC7nh m\u1EDF',
                    value: '${prediction.openOrders}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ModuleStat(
                    label: 'P/L',
                    value: prediction.pnlLabel,
                    valueColor: _profileGreen,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Xem portfolio',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: _profilePurple,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: _profilePurple,
                  size: 14,
                ),
                const SizedBox(width: 20),
                const Icon(
                  Icons.emoji_events_outlined,
                  color: _profileMuted,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Leaderboard',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: _profileMuted,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
