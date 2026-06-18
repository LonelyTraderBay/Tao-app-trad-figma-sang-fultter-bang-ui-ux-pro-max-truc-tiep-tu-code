part of 'arena_challenge_detail_page.dart';

class _SafetySnapshotCard extends StatelessWidget {
  const _SafetySnapshotCard({required this.rows, required this.onSafety});

  final List<ArenaRuleSummaryRow> rows;
  final VoidCallback onSafety;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.arenaPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.health_and_safety_outlined,
                color: AppColors.buy,
                size: AppSpacing.arenaChallengeLgIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'An toàn nhanh',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final row in rows)
            _SummaryRow(label: row.label, value: row.value),
          const SizedBox(height: AppSpacing.x3),
          _InlineAction(
            label: 'An toàn & báo cáo',
            icon: Icons.flag_outlined,
            color: AppColors.sell,
            onTap: onSafety,
          ),
        ],
      ),
    );
  }
}

class _ActionStack extends StatelessWidget {
  const _ActionStack({
    required this.onEvidence,
    required this.onReport,
    required this.onBlock,
    required this.onLeave,
  });

  final VoidCallback onEvidence;
  final VoidCallback onReport;
  final VoidCallback onBlock;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            VitCard(
              width: AppSpacing.arenaChallengeActionShareSize,
              height: AppSpacing.arenaChallengeActionShareSize,
              radius: VitCardRadius.lg,
              onTap: () => HapticFeedback.selectionClick(),
              child: const Center(
                child: Icon(Icons.share_outlined, color: AppColors.text2),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitCtaButton(
                key: ArenaChallengeDetailPage.evidenceCtaKey,
                onPressed: onEvidence,
                leading: const Icon(Icons.camera_alt_outlined),
                child: const Text('Gửi bằng chứng'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        Row(
          children: [
            Expanded(
              child: _SecondaryAction(
                label: 'Rời',
                icon: Icons.cancel_outlined,
                color: AppColors.primary,
                onTap: onLeave,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: _SecondaryAction(
                key: ArenaChallengeDetailPage.reportKey,
                label: 'Báo cáo',
                icon: Icons.flag_outlined,
                color: AppColors.sell,
                onTap: onReport,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: _SecondaryAction(
                key: ArenaChallengeDetailPage.blockKey,
                label: 'Chặn',
                icon: Icons.block_outlined,
                color: AppColors.text3,
                onTap: onBlock,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CommunityRulesLink extends StatelessWidget {
  const _CommunityRulesLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: onTap,
        icon: const Icon(
          Icons.menu_book_outlined,
          size: AppSpacing.arenaChallengeCommunityIcon,
        ),
        label: Text(
          'Quy tắc cộng đồng',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.primary,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _RowsSection extends StatelessWidget {
  const _RowsSection({
    required this.title,
    required this.accentColor,
    required this.rows,
  });

  final String title;
  final Color accentColor;
  final List<ArenaRuleSummaryRow> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VitModuleSectionHeader(title: title, accentColor: accentColor),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          padding: AppSpacing.arenaPaddingX4,
          child: Column(
            children: [
              for (final row in rows)
                _SummaryRow(label: row.label, value: row.value),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.arenaVerticalPaddingX2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSpacing.arenaChallengeSummaryLabelWidth,
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: AppSpacing.arenaChallengeSummaryLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.arenaPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBubble(icon: icon, color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.arenaChallengeBodyLineHeight,
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

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({
    required this.text,
    required this.icon,
    required this.color,
  });

  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: color.withValues(alpha: .22),
      padding: AppSpacing.arenaPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppSpacing.arenaChallengeBannerIcon),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: color,
                height: AppSpacing.arenaChallengeBannerLineHeight,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecondaryAction extends StatelessWidget {
  const _SecondaryAction({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      borderColor: color.withValues(alpha: .22),
      padding: AppSpacing.arenaVerticalPaddingX3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: AppSpacing.arenaChallengeSecondaryIcon,
          ),
          const SizedBox(width: AppSpacing.x1),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineAction extends StatelessWidget {
  const _InlineAction({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.smRadius,
        child: Padding(
          padding: AppSpacing.arenaVerticalPaddingX1,
          child: Row(
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              Icon(
                icon,
                color: color,
                size: AppSpacing.arenaChallengeInlineIcon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(
            color: color,
            fontWeight: AppTextStyles.heavy,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _LiveDot extends StatelessWidget {
  const _LiveDot();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.arenaChallengeLiveDot,
      height: AppSpacing.arenaChallengeLiveDot,
      child: const Material(color: AppColors.buy, shape: CircleBorder()),
    );
  }
}

class _SmallIcon extends StatelessWidget {
  const _SmallIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: color, size: AppSpacing.arenaChallengeMdIcon);
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.arenaChallengeIconBubble,
      height: AppSpacing.arenaChallengeIconBubble,
      child: Material(
        color: color.withValues(alpha: .12),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color.withValues(alpha: .22)),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Icon(
          icon,
          color: color,
          size: AppSpacing.arenaChallengeIconBubbleIcon,
        ),
      ),
    );
  }
}

class _InitialBadge extends StatelessWidget {
  const _InitialBadge({required this.name, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
    return SizedBox(
      width: AppSpacing.arenaChallengeInitialBadge,
      height: AppSpacing.arenaChallengeInitialBadge,
      child: Material(
        color: color.withValues(alpha: .16),
        borderRadius: AppRadii.xsRadius,
        child: Center(
          child: Text(
            initial,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.arenaChallengeInitialLineHeight,
            ),
          ),
        ),
      ),
    );
  }
}

class _ArenaFooterNotice extends StatelessWidget {
  const _ArenaFooterNotice();

  @override
  Widget build(BuildContext context) {
    return const _InfoBanner(
      text:
          'Arena Points chỉ dùng trong Open Arena, không phải tài sản tài chính. Không thỏa thuận giao dịch ngoài nền tảng.',
      icon: Icons.shield_outlined,
      color: _arenaAccent,
    );
  }
}

String _formatCompact(int value) {
  if (value >= 1000 && value % 1000 == 0) return '${value ~/ 1000}K';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return '$value';
}
