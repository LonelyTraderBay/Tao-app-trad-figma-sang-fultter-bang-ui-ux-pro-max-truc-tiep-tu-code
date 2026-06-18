part of '../pages/prediction_event_detail_page.dart';

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
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.cardRadius,
      child: Padding(
        padding: AppSpacing.predictionDetailTabsPadding,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var index = 0; index < tabs.length; index += 1) ...[
                if (index > 0)
                  const SizedBox(width: AppSpacing.predictionDetailTabsGap),
                _DetailTabButton(
                  tab: tabs[index],
                  active: activeTab == tabs[index].$1,
                  onChanged: onChanged,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailTabButton extends StatelessWidget {
  const _DetailTabButton({
    required this.tab,
    required this.active,
    required this.onChanged,
  });

  final (_DetailTab, String, Key) tab;
  final bool active;
  final ValueChanged<_DetailTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? AppColors.surface : AppColors.transparent,
      borderRadius: AppRadii.smRadius,
      child: InkWell(
        key: tab.$3,
        onTap: () => onChanged(tab.$1),
        borderRadius: AppRadii.smRadius,
        child: SizedBox(
          height: AppSpacing.predictionDetailTabHeight,
          child: Padding(
            padding: AppSpacing.predictionDetailTabPadding,
            child: Center(
              child: Text(
                tab.$2,
                style: AppTextStyles.caption.copyWith(
                  color: active ? AppColors.text1 : AppColors.text3,
                  fontWeight: active
                      ? AppTextStyles.bold
                      : AppTextStyles.normal,
                ),
              ),
            ),
          ),
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
      padding: AppSpacing.predictionDetailTabCardPadding,
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
        const SizedBox(height: AppSpacing.predictionDetailTabSectionGap),
        _InfoBox(
          icon: Icons.verified_user_outlined,
          title: 'Resolution Source',
          text: 'CoinGecko & CoinMarketCap (average)',
          color: _predictionPrimary,
        ),
        const SizedBox(height: AppSpacing.predictionDetailTabInfoGap),
        _InfoBox(
          icon: Icons.calendar_month_outlined,
          title: 'End Date',
          text: '${_formatDate(snapshot.event.endDate)} at 23:59 UTC',
          color: AppColors.warn,
        ),
        const SizedBox(height: AppSpacing.predictionDetailTabSectionGap),
        Text(
          'Market Rules',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.predictionDetailTabTitleGap),
        for (var index = 0; index < snapshot.rules.length; index += 1) ...[
          _RuleRow(index: index, text: snapshot.rules[index]),
          if (index != snapshot.rules.length - 1)
            const SizedBox(height: AppSpacing.predictionDetailRuleBottomGap),
        ],
      ],
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: AppSpacing.predictionDetailRuleNumberWidth,
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
            text,
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
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
            Icon(
              icon,
              color: AppColors.text2,
              size: AppSpacing.predictionDetailInfoIcon,
            ),
            const SizedBox(width: AppSpacing.predictionDetailInfoIconGap),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.predictionDetailInfoIconGap),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
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
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.mdRadius,
      child: Padding(
        padding: AppSpacing.predictionDetailInfoBoxPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: AppSpacing.predictionDetailInfoBoxIcon,
            ),
            const SizedBox(width: AppSpacing.predictionDetailInfoBoxGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.predictionDetailInfoBoxTextGap,
                  ),
                  Text(
                    text,
                    style: AppTextStyles.caption.copyWith(color: color),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
