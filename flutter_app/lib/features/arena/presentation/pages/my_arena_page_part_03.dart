part of 'my_arena_page.dart';

class _RewardAnalyticsSection extends StatelessWidget {
  const _RewardAnalyticsSection({
    required this.history,
    required this.onViewChallenge,
  });

  final ArenaRewardHistory history;
  final VoidCallback onViewChallenge;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Phân tích phần thưởng',
          accentColor: AppColors.warn,
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.query_stats_rounded,
                    color: AppColors.warn,
                    size: 18,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Text(
                      'Phân tích phần thưởng',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              Row(
                children: [
                  Expanded(
                    child: _RewardMetric(
                      value: '${history.totalReceipts}',
                      label: 'Tổng lần nhận',
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _RewardMetric(
                      value: '+${history.averageReceiveRate}%',
                      label: 'Tỉ lệ nhận TB',
                      color: AppColors.buy,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _RewardMetric(
                      value: formatArenaPoints(history.largestReceipt),
                      label: 'Lớn nhất',
                      color: AppColors.warn,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x5),
              Text(
                'TỈ LỆ THẮNG THEO LOẠI CHIA THƯỞNG',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x3),
              for (var i = 0; i < history.distribution.length; i++) ...[
                _DistributionRow(
                  item: history.distribution[i],
                  color: _distributionColor(i),
                ),
                if (i < history.distribution.length - 1)
                  const SizedBox(height: AppSpacing.x3),
              ],
              const SizedBox(height: AppSpacing.x5),
              InkWell(
                onTap: onViewChallenge,
                borderRadius: AppRadii.smRadius,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Lịch sử nhận thưởng gần đây',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text2,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.text3,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RewardMetric extends StatelessWidget {
  const _RewardMetric({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x4,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.base.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _DistributionRow extends StatelessWidget {
  const _DistributionRow({required this.item, required this.color});

  final ArenaRewardDistribution item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ratio = item.total == 0 ? 0.0 : item.wins / item.total;
    return Row(
      children: [
        SizedBox(
          width: 112,
          child: Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              minHeight: 10,
              value: ratio,
              backgroundColor: AppColors.surface3,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        SizedBox(
          width: 30,
          child: Text(
            '${item.wins}/${item.total}',
            textAlign: TextAlign.right,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _SafetySection extends StatelessWidget {
  const _SafetySection({
    required this.onReports,
    required this.onBlocked,
    required this.onSafety,
  });

  final VoidCallback onReports;
  final VoidCallback onBlocked;
  final VoidCallback onSafety;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'An toàn & quản lý',
          accentColor: AppColors.buy,
        ),
        const SizedBox(height: AppSpacing.x3),
        _SafetyActionCard(
          key: MyArenaPage.reportsKey,
          icon: Icons.outlined_flag_rounded,
          title: 'Báo cáo của tôi',
          subtitle: 'Theo dõi tiến trình xử lý báo cáo',
          color: AppColors.sell,
          onTap: onReports,
        ),
        const SizedBox(height: AppSpacing.x3),
        _SafetyActionCard(
          key: MyArenaPage.blockedKey,
          icon: Icons.block_rounded,
          title: 'Người dùng đã chặn',
          subtitle: 'Quản lý danh sách chặn',
          color: AppColors.warn,
          onTap: onBlocked,
        ),
        const SizedBox(height: AppSpacing.x3),
        _SafetyActionCard(
          key: MyArenaPage.safetyKey,
          icon: Icons.shield_outlined,
          title: 'An toàn & quy tắc',
          subtitle: 'Quy tắc cộng đồng, cách báo cáo',
          color: AppColors.buy,
          onTap: onSafety,
        ),
      ],
    );
  }
}

class _SafetyActionCard extends StatelessWidget {
  const _SafetyActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _ActionIcon(icon: icon, color: color),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _ArenaFooter extends StatelessWidget {
  const _ArenaFooter({required this.onRules});

  final VoidCallback onRules;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: onRules,
            borderRadius: AppRadii.smRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.menu_book_outlined,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Quy t\u1EAFc c\u1ED9ng \u0111\u1ED3ng',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.primary,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.accent,
                size: 17,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Arena Points chỉ dùng trong Open Arena, không phải tài sản tài chính. Không thỏa thuận giao dịch ngoài nền tảng.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({
    required this.icon,
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          Icon(icon, color: _arenaAccent, size: 26),
          const SizedBox(height: AppSpacing.x3),
          Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          _AccentPillButton(
            icon: Icons.add_rounded,
            label: actionLabel,
            color: _arenaAccent,
            onTap: onAction,
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}

class _ArenaStatusPill extends StatelessWidget {
  const _ArenaStatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        border: Border.all(color: color.withValues(alpha: .22)),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}
