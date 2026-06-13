part of 'token_unlocks_page.dart';

class _DilutionRow extends StatelessWidget {
  const _DilutionRow({required this.index, required this.unlock});

  final int index;
  final TokenUnlockDraft unlock;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 14,
            child: Text(
              '${index + 1}',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(width: 10),
          _TokenAvatar(unlock: unlock, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unlock.symbol,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '${unlock.daysUntil} ngày nữa',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${unlock.unlockPctCirculating.toStringAsFixed(1)}%',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                'lưu thông',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UnlockWarningCard extends StatelessWidget {
  const _UnlockWarningCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warn.withValues(alpha: .16),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lưu ý quan trọng',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Token unlock không đồng nghĩa token sẽ bị bán. Tuy nhiên, unlock lớn thường tạo áp lực bán tiềm ẩn. Dữ liệu chỉ mang tính tham khảo.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.55,
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

class _ScheduleList extends StatelessWidget {
  const _ScheduleList({required this.snapshot});

  final MarketTokenUnlocksSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final unlocks = [...snapshot.unlocks]
      ..sort((a, b) => a.daysUntil.compareTo(b.daysUntil));

    return Column(
      children: [
        for (final unlock in unlocks) ...[
          _ScheduleCard(
            unlock: unlock,
            categoryConfig: snapshot.categoryConfigs[unlock.category]!,
          ),
          if (unlock != unlocks.last) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({required this.unlock, required this.categoryConfig});

  final TokenUnlockDraft unlock;
  final UnlockCategoryConfig categoryConfig;

  @override
  Widget build(BuildContext context) {
    final supplyPct = unlock.circulatingSupply / unlock.totalSupply;

    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _TokenAvatar(unlock: unlock, size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          unlock.symbol,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _TinyBadge(
                          label: _shortVestingTypeLabel(unlock.vestingType),
                          color: categoryConfig.color,
                        ),
                      ],
                    ),
                    Text(
                      unlock.name,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatPriceUsd(unlock.currentPrice),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    '${_formatPct(unlock.priceChange7d)} 7d',
                    style: AppTextStyles.micro.copyWith(
                      color: unlock.priceChange7d >= 0
                          ? AppColors.buy
                          : AppColors.sell,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Lưu thông / Tổng cung',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                '${(supplyPct * 100).toStringAsFixed(1)}%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              value: supplyPct,
              minHeight: 6,
              backgroundColor: AppColors.surface2,
              valueColor: AlwaysStoppedAnimation<Color>(unlock.color),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Lịch mở khóa',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 8),
          for (var index = 0; index < unlock.vestingSchedule.length; index += 1)
            _VestingEventRow(
              event: unlock.vestingSchedule[index],
              color: unlock.color,
              isFirst: index == 0,
              isLast: index == unlock.vestingSchedule.length - 1,
            ),
        ],
      ),
    );
  }
}

class _VestingEventRow extends StatelessWidget {
  const _VestingEventRow({
    required this.event,
    required this.color,
    required this.isFirst,
    required this.isLast,
  });

  final TokenVestingEventDraft event;
  final Color color;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isFirst ? color : color.withValues(alpha: .12),
                  shape: BoxShape.circle,
                  border: isFirst
                      ? null
                      : Border.all(
                          color: color.withValues(alpha: .25),
                          width: 2,
                        ),
                ),
                child: Icon(
                  isFirst ? Icons.lock_open_rounded : Icons.lock_rounded,
                  size: isFirst ? 12 : 9,
                  color: isFirst ? AppColors.text1 : color,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: color.withValues(alpha: .12),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.date,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      Text(
                        '${event.pct.toStringAsFixed(1)}%',
                        style: AppTextStyles.caption.copyWith(
                          color: event.pct > 5
                              ? AppColors.sell
                              : event.pct > 2
                              ? AppColors.warn
                              : AppColors.buy,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    event.label,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TokenAvatar extends StatelessWidget {
  const _TokenAvatar({required this.unlock, required this.size});

  final TokenUnlockDraft unlock;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: unlock.color.withValues(alpha: .14),
        shape: BoxShape.circle,
      ),
      child: Text(
        unlock.symbol.substring(0, 2),
        style: AppTextStyles.caption.copyWith(
          color: unlock.color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({
    required this.label,
    required this.color,
    this.bold = false,
  });

  final String label;
  final Color color;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          height: 1.2,
          fontWeight: bold ? AppTextStyles.bold : AppTextStyles.medium,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.accentColor});

  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}
