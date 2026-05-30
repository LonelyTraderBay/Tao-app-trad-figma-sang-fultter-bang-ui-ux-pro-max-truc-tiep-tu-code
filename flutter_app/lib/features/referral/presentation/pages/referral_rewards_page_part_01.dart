part of 'referral_rewards_page.dart';

class _ReferralRewardsPageState extends ConsumerState<ReferralRewardsPage> {
  ReferralRewardFilter _filter = ReferralRewardFilter.all;
  ReferralRewardSort _sort = ReferralRewardSort.date;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(referralControllerProvider)
        .getRewards(filter: _filter, sort: _sort);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-287 ReferralRewardsPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: ReferralRewardsPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _RewardHero(
                        snapshot: snapshot,
                        onExport: () => _showExportSheet(context, snapshot),
                        onDisputes: () =>
                            _showDisputeHistorySheet(context, snapshot),
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _SectionTitle(
                        title: 'Hoa hồng theo tháng',
                        trailing:
                            '+${_formatUsd(snapshot.thisMonthCommission)} tháng này',
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      _RewardChart(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      _RewardTabs(
                        filters: snapshot.filters,
                        active: snapshot.filter,
                        onChanged: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _filter = value);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _SortRail(
                        options: snapshot.sortOptions,
                        active: snapshot.sort,
                        onChanged: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _sort = value);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _RewardLedger(
                        snapshot: snapshot,
                        onReport: (record) =>
                            _showReportSheet(context, snapshot, record),
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      const _DisputeInfo(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExportSheet(
    BuildContext context,
    ReferralRewardsSnapshot snapshot,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentPad,
              AppSpacing.x5,
              AppSpacing.contentPad,
              AppSpacing.x6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Xuất báo cáo hoa hồng',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Text(
                  '${snapshot.records.length} bản ghi · ${_formatUsd(snapshot.totalCommission)} tổng',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.x4),
                Wrap(
                  spacing: AppSpacing.x3,
                  runSpacing: AppSpacing.x3,
                  children: [
                    for (final range in snapshot.exportRanges)
                      _TinyPill(label: range.label),
                  ],
                ),
                const SizedBox(height: AppSpacing.x5),
                VitCtaButton(
                  onPressed: () => Navigator.of(context).pop(),
                  leading: const Icon(Icons.download_rounded),
                  child: const Text('Tải xuống CSV'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showReportSheet(
    BuildContext context,
    ReferralRewardsSnapshot snapshot,
    ReferralRewardRecordDraft record,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentPad,
              AppSpacing.x5,
              AppSpacing.contentPad,
              AppSpacing.x6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Báo lỗi hoa hồng',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                _SheetRecord(record: record),
                const SizedBox(height: AppSpacing.x4),
                for (final type in snapshot.disputeTypes) ...[
                  _DisputeTypeRow(type: type),
                  const SizedBox(height: AppSpacing.x2),
                ],
                const SizedBox(height: AppSpacing.x4),
                VitCtaButton(
                  onPressed: () => Navigator.of(context).pop(),
                  variant: VitCtaButtonVariant.warning,
                  leading: const Icon(Icons.send_rounded),
                  child: const Text('Gửi báo lỗi'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDisputeHistorySheet(
    BuildContext context,
    ReferralRewardsSnapshot snapshot,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentPad,
              AppSpacing.x5,
              AppSpacing.contentPad,
              AppSpacing.x6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Lịch sử báo lỗi',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                for (final dispute in snapshot.disputes)
                  _DisputeHistoryCard(dispute: dispute),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RewardHero extends StatelessWidget {
  const _RewardHero({
    required this.snapshot,
    required this.onExport,
    required this.onDisputes,
  });

  final ReferralRewardsSnapshot snapshot;
  final VoidCallback onExport;
  final VoidCallback onDisputes;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ReferralRewardsPage.heroKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Tổng phần thưởng',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextMuted,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              _TierPill(snapshot: snapshot),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            _formatUsd(snapshot.totalCommission),
            style: AppTextStyles.heroNumber.copyWith(
              color: AppColors.portfolioTextDim,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'USDT · Đã cộng vào ví',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: AppColors.warn,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                '+${_formatUsd(snapshot.pendingCommission)} đang chờ xử lý',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.warn,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  icon: Icons.card_giftcard_rounded,
                  title: 'Thưởng KYC',
                  amount: snapshot.kycBonusTotal,
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(
                  icon: Icons.trending_up_rounded,
                  title: 'Hoa hồng GD',
                  amount: snapshot.tradeCommissionTotal,
                  color: AppModuleAccents.trade,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: ReferralRewardsPage.exportKey,
                  onPressed: onExport,
                  variant: VitCtaButtonVariant.secondary,
                  height: AppSpacing.inputHeight,
                  leading: const Icon(Icons.download_rounded),
                  child: const Text('Xuất báo cáo'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitCtaButton(
                  key: ReferralRewardsPage.disputeHistoryKey,
                  onPressed: onDisputes,
                  variant: VitCtaButtonVariant.ghost,
                  height: AppSpacing.inputHeight,
                  leading: const Icon(Icons.shield_outlined),
                  child: const Text('Lịch sử báo lỗi'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TierPill extends StatelessWidget {
  const _TierPill({required this.snapshot});

  final ReferralRewardsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.portfolioBtnGhost,
        border: Border.all(color: AppColors.portfolioBtnGhostBorder),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.workspace_premium_rounded,
              color: AppColors.primarySoft,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              '${snapshot.tierName} (${snapshot.tierNameEn})',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.portfolioTextDim,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.icon,
    required this.title,
    required this.amount,
    required this.color,
  });

  final IconData icon;
  final String title;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.portfolioBtnGhostBorder,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            _formatUsd(amount),
            style: AppTextStyles.body.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.trailing});

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSpacing.x1,
          height: AppSpacing.x5,
          decoration: const BoxDecoration(
            color: AppColors.buy,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
          ),
        ),
        Text(
          trailing,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}
