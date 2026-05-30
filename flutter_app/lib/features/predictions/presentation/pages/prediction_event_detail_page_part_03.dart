part of 'prediction_event_detail_page.dart';

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: .12) : AppColors.transparent,
          border: Border.all(
            color: active
                ? color.withValues(alpha: .28)
                : AppColors.transparent,
          ),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? color : AppColors.text3,
            fontWeight: active ? AppTextStyles.bold : AppTextStyles.normal,
          ),
        ),
      ),
    );
  }
}

class _SmallToggleChip extends StatelessWidget {
  const _SmallToggleChip({
    required this.label,
    required this.color,
    required this.active,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: .12) : AppColors.surface2,
          border: Border.all(
            color: active
                ? color.withValues(alpha: .32)
                : AppColors.transparent,
          ),
          borderRadius: AppRadii.smRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: active ? color : AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({
    required this.amount,
    required this.active,
    required this.onTap,
  });

  final String amount;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        height: 31,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _predictionPrimary.withValues(alpha: .14)
              : AppColors.surface2,
          border: Border.all(
            color: active
                ? _predictionPrimary.withValues(alpha: .32)
                : AppColors.transparent,
          ),
          borderRadius: AppRadii.smRadius,
        ),
        child: Text(
          '\$$amount',
          style: AppTextStyles.micro.copyWith(
            color: active ? _predictionPrimary : AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _RiskLink extends StatelessWidget {
  const _RiskLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: PredictionEventDetailPage.riskLinkKey,
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 38,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield_outlined, color: AppColors.warn, size: 13),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                'Hiểu rủi ro trước khi giao dịch',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.warn,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const SizedBox(width: 3),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.warn,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailTabs extends StatelessWidget {
  const _DetailTabs({required this.activeTab, required this.onChanged});

  final _DetailTab activeTab;
  final ValueChanged<_DetailTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (_DetailTab.rules, 'Rules', PredictionEventDetailPage.rulesTabKey),
      (
        _DetailTab.comments,
        'Comments',
        PredictionEventDetailPage.commentsTabKey,
      ),
      (
        _DetailTab.holders,
        'Top Holders',
        PredictionEventDetailPage.holdersTabKey,
      ),
      (
        _DetailTab.activity,
        'Activity',
        PredictionEventDetailPage.activityTabKey,
      ),
    ];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final tab in tabs)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: InkWell(
                  key: tab.$3,
                  onTap: () => onChanged(tab.$1),
                  borderRadius: AppRadii.smRadius,
                  child: Container(
                    height: 34,
                    padding: const EdgeInsets.symmetric(horizontal: 11),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: activeTab == tab.$1
                          ? AppColors.surface
                          : AppColors.transparent,
                      borderRadius: AppRadii.smRadius,
                    ),
                    child: Text(
                      tab.$2,
                      style: AppTextStyles.caption.copyWith(
                        color: activeTab == tab.$1
                            ? AppColors.text1
                            : AppColors.text3,
                        fontSize: 12,
                        fontWeight: activeTab == tab.$1
                            ? AppTextStyles.bold
                            : AppTextStyles.normal,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TabCard extends StatelessWidget {
  const _TabCard({required this.snapshot, required this.activeTab});

  final PredictionEventDetailSnapshot snapshot;
  final _DetailTab activeTab;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(15),
      child: switch (activeTab) {
        _DetailTab.rules => _RulesContent(snapshot: snapshot),
        _DetailTab.comments => const _CommentsContent(),
        _DetailTab.holders => _HoldersContent(snapshot: snapshot),
        _DetailTab.activity => _ActivityContent(snapshot: snapshot),
      },
    );
  }
}

class _RulesContent extends StatelessWidget {
  const _RulesContent({required this.snapshot});

  final PredictionEventDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoBlock(
          icon: Icons.menu_book_rounded,
          title: 'Description',
          text:
              'This market will resolve to "Yes" if bitcoin reaches \$150K before July 2026 before the end date. Otherwise, it resolves to "No".',
        ),
        const SizedBox(height: 13),
        _InfoBox(
          icon: Icons.verified_user_outlined,
          title: 'Resolution Source',
          text: 'CoinGecko & CoinMarketCap (average)',
          color: _predictionPrimary,
        ),
        const SizedBox(height: 10),
        _InfoBox(
          icon: Icons.calendar_month_outlined,
          title: 'End Date',
          text: '${_formatDate(snapshot.event.endDate)} at 23:59 UTC',
          color: AppColors.warn,
        ),
        const SizedBox(height: 13),
        Text(
          'Market Rules',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: 8),
        for (var index = 0; index < snapshot.rules.length; index += 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 22,
                  child: Text(
                    '${index + 1}.',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    snapshot.rules[index],
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontSize: 11,
                      height: 1.45,
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

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.text2, size: 13),
            const SizedBox(width: 7),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontSize: 12,
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

class _CommentsContent extends StatelessWidget {
  const _CommentsContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: AppColors.warn08,
            border: Border.all(color: AppColors.warningBorder),
            borderRadius: AppRadii.mdRadius,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warn,
                size: 15,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Beware of external links. Do not share personal or financial information.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.warn,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 13),
        _CommentRow(
          name: 'MacroAlpha',
          side: 'Yes',
          text: 'Strong ETF flow and liquidity backdrop support this market.',
          likes: 18,
        ),
        _CommentRow(
          name: 'RiskDesk',
          side: 'No',
          text: 'Watch macro rates and exchange liquidity before sizing up.',
          likes: 9,
        ),
        const SizedBox(height: 10),
        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            border: Border.all(color: AppColors.borderSolid),
            borderRadius: AppRadii.mdRadius,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Add a comment...',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                'Post',
                style: AppTextStyles.caption.copyWith(
                  color: _predictionPrimary,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
