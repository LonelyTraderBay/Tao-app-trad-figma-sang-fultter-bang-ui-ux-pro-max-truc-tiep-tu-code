part of '../pages/kyc_page.dart';

class _KycStatusCard extends StatelessWidget {
  const _KycStatusCard({required this.snapshot});

  final ProfileKycSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: KYCPage.statusCardKey,
      height: 81,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.buy10,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _kycGreen.withValues(alpha: .45)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _kycGreen.withValues(alpha: .2),
              borderRadius: AppRadii.cardLargeRadius,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.shield_outlined,
              color: _kycGreen,
              size: 25,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.statusTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        snapshot.statusDescription,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: _kycGreen,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.check_rounded, color: _kycGreen, size: 14),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KycLevelCard extends StatelessWidget {
  const _KycLevelCard({
    required this.level,
    required this.done,
    required this.expanded,
    required this.currentLevel,
    required this.submitting,
    required this.onTap,
    required this.onStart,
  });

  final ProfileKycLevel level;
  final bool done;
  final bool expanded;
  final int currentLevel;
  final bool submitting;
  final VoidCallback onTap;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final accent = Color(level.colorHex);
    final border = done ? accent.withValues(alpha: .44) : AppColors.borderSolid;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: _kycPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: border),
      ),
      child: ClipRRect(
        borderRadius: AppRadii.cardRadius,
        child: Column(
          children: [
            GestureDetector(
              key: KYCPage.levelKey(level.level),
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 73,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _LevelIcon(level: level.level, done: done, accent: accent),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            level.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.baseMedium.copyWith(
                              color: done ? AppColors.text1 : AppColors.text2,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (done)
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_rounded,
                                  color: _kycMuted,
                                  size: 12,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '\u0110\u00E3 ho\u00E0n th\u00E0nh',
                                  style: AppTextStyles.micro.copyWith(
                                    color: _kycMuted,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    height: 1,
                                  ),
                                ),
                              ],
                            )
                          else
                            Text(
                              'Ch\u01B0a x\u00E1c minh',
                              style: AppTextStyles.micro.copyWith(
                                color: _kycMuted,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                height: 1,
                              ),
                            ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: expanded ? .25 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.text3,
                        size: 19,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (expanded) ...[
              const Divider(height: 1, color: AppColors.divider),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: _ExpandedLevelDetails(
                  level: level,
                  done: done,
                  currentLevel: currentLevel,
                  submitting: submitting,
                  onStart: onStart,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LevelIcon extends StatelessWidget {
  const _LevelIcon({
    required this.level,
    required this.done,
    required this.accent,
  });

  final int level;
  final bool done;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: done ? accent.withValues(alpha: .13) : AppColors.transparent,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(
          color: done ? accent : AppColors.borderSolid,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: done
          ? Icon(Icons.check_circle_outline_rounded, color: accent, size: 24)
          : Text(
              '$level',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
    );
  }
}

class _ExpandedLevelDetails extends StatelessWidget {
  const _ExpandedLevelDetails({
    required this.level,
    required this.done,
    required this.currentLevel,
    required this.submitting,
    required this.onStart,
  });

  final ProfileKycLevel level;
  final bool done;
  final int currentLevel;
  final bool submitting;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final accent = Color(level.colorHex);
    final canStart = !done && level.level == currentLevel + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DetailsBlock(
          title: 'Gi\u1EDBi h\u1EA1n giao d\u1ECBch:',
          lines: level.limits,
        ),
        const SizedBox(height: 14),
        _DetailsBlock(
          title: 'T\u00EDnh n\u0103ng m\u1EDF kh\u00F3a:',
          lines: level.features,
          done: done,
        ),
        if (canStart) ...[
          const SizedBox(height: 14),
          GestureDetector(
            key: KYCPage.startKey(level.level),
            onTap: submitting ? null : onStart,
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: AppSpacing.inputHeight,
              decoration: BoxDecoration(
                borderRadius: AppRadii.cardRadius,
                gradient: LinearGradient(
                  colors: [accent, accent.withValues(alpha: .8)],
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                submitting
                    ? '\u0110ang g\u1EEDi...'
                    : 'B\u1EAFt \u0111\u1EA7u x\u00E1c minh ${level.title}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
