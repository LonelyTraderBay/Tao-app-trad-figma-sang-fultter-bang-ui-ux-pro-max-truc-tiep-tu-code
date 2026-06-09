part of 'p2p_claim_detail_page.dart';

class _P2PClaimDetailPageState extends ConsumerState<P2PClaimDetailPage> {
  _ClaimDetailSection _section = _ClaimDetailSection.timeline;
  late bool _notificationsEnabled;
  String? _feedback;

  @override
  void initState() {
    super.initState();
    final snapshot = ref.read(p2pClaimDetailProvider(widget.claimId));
    _notificationsEnabled = snapshot.claim.notificationsEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pClaimDetailProvider(widget.claimId));
    final claim = snapshot.claim;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-243 P2PClaimDetailPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: claim.claimCode,
            subtitle: 'Bảo hiểm · P2P',
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
            actions: [
              VitHeaderActionItem(
                type: VitHeaderActionType.notifications,
                tooltip: 'Thông báo claim P2P',
                active: _notificationsEnabled,
                onPressed: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _notificationsEnabled = !_notificationsEnabled;
                    _feedback = _notificationsEnabled
                        ? 'Đã bật thông báo claim'
                        : 'Đã tắt thông báo claim';
                  });
                },
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.contentPad,
                      AppSpacing.x4,
                      AppSpacing.contentPad,
                      bottomInset,
                    ),
                    child: VitPageContent(
                      padding: VitContentPadding.none,
                      fullBleed: true,
                      customGap: 0,
                      children: [
                        _ClaimHeroCard(claim: claim),
                        const SizedBox(height: AppSpacing.x5),
                        VitPageSection(
                          customGap: 0,
                          children: [_ClaimBenchmarksCard(snapshot: snapshot)],
                        ),
                        const SizedBox(height: AppSpacing.x5),
                        _DescriptionCard(description: claim.description),
                        const SizedBox(height: AppSpacing.x4),
                        _ClaimSectionTabs(
                          active: _section,
                          claim: claim,
                          onChanged: (section) {
                            HapticFeedback.selectionClick();
                            setState(() => _section = section);
                          },
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        _ClaimSectionBody(section: _section, claim: claim),
                        const SizedBox(height: AppSpacing.x5),
                        _NotificationsCard(
                          enabled: _notificationsEnabled,
                          onChanged: (value) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _notificationsEnabled = value;
                              _feedback = value
                                  ? 'Đã bật thông báo claim'
                                  : 'Đã tắt thông báo claim';
                            });
                          },
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        _ActionRow(
                          key: P2PClaimDetailPage.orderLinkKey,
                          icon: Icons.open_in_new_rounded,
                          title: 'Xem đơn hàng gốc',
                          onTap: () {
                            HapticFeedback.selectionClick();
                            context.go(snapshot.orderRoute);
                          },
                        ),
                        const SizedBox(height: AppSpacing.x3),
                        _ActionRow(
                          key: P2PClaimDetailPage.supportLinkKey,
                          icon: Icons.help_outline_rounded,
                          title: 'Liên hệ hỗ trợ',
                          onTap: () {
                            HapticFeedback.selectionClick();
                            context.go(snapshot.supportRoute);
                          },
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        if (_feedback != null) ...[
                          _FeedbackBanner(message: _feedback!),
                          const SizedBox(height: AppSpacing.x4),
                        ],
                        if (claim.status == P2PInsuranceClaimStatus.paid)
                          VitCtaButton(
                            key: P2PClaimDetailPage.receiptKey,
                            variant: VitCtaButtonVariant.success,
                            leading: const Icon(Icons.download_rounded),
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              setState(
                                () => _feedback =
                                    'Đã chuẩn bị biên lai ${claim.claimCode}',
                              );
                            },
                            child: const Text('Tải biên lai'),
                          ),
                        const SizedBox(height: AppSpacing.x3),
                        const VitCard(
                          variant: VitCardVariant.inner,
                          padding: EdgeInsets.all(AppSpacing.x3),
                          child: VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Claim detail review',
                            message:
                                'Claim status, covered amount, evidence, notifications, receipt action and support next step are reviewed before follow-up.',
                            contractId: 'p2p-claim-detail-review',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClaimHeroCard extends StatelessWidget {
  const _ClaimHeroCard({required this.claim});

  final P2PClaimDetailDraft claim;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PClaimDetailPage.heroKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              VitStatusPill(
                label: claim.statusLabel,
                status: _statusPill(claim.status),
                icon: _statusIcon(claim.status),
                size: VitStatusPillSize.lg,
              ),
              const Spacer(),
              VitStatusPill(
                label: claim.claimCode,
                status: VitStatusPillStatus.neutral,
                icon: Icons.content_copy_rounded,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          _ClaimProgress(status: claim.status),
          const SizedBox(height: AppSpacing.x5),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.x4),
          _InfoRow(
            label: 'Lệnh P2P',
            value: claim.orderId,
            valueColor: AppModuleAccents.p2p,
            trailing: Icons.open_in_new_rounded,
          ),
          _InfoRow(label: 'Lý do', value: claim.reason),
          _InfoRow(
            label: 'Số tiền yêu cầu',
            value: '${_formatVnd(claim.amount)} đ',
          ),
          _InfoRow(
            label: 'Tỷ lệ bảo hiểm',
            value: '${claim.coveragePct}%',
            valueColor: AppModuleAccents.p2p,
          ),
          const SizedBox(height: AppSpacing.x3),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.x3),
          if (claim.paidAmount != null)
            _InfoRow(
              label: claim.statusLabel,
              value: '${_formatVnd(claim.paidAmount!)} đ',
              valueColor: AppColors.buy,
            ),
          _InfoRow(label: 'Ngày gửi', value: claim.submittedAt),
        ],
      ),
    );
  }
}

class _ClaimProgress extends StatelessWidget {
  const _ClaimProgress({required this.status});

  final P2PInsuranceClaimStatus status;

  @override
  Widget build(BuildContext context) {
    final steps = const ['Gửi', 'Xem xét', 'Duyệt', 'Chi trả'];
    final activeIndex = switch (status) {
      P2PInsuranceClaimStatus.pending => 0,
      P2PInsuranceClaimStatus.reviewing => 1,
      P2PInsuranceClaimStatus.approved => 2,
      P2PInsuranceClaimStatus.paid => 3,
      P2PInsuranceClaimStatus.rejected => 1,
    };

    return Column(
      children: [
        Row(
          children: [
            for (var i = 0; i < steps.length; i++) ...[
              Expanded(
                child: Container(
                  height: AppSpacing.x1,
                  decoration: BoxDecoration(
                    color: i <= activeIndex
                        ? _stepColor(i)
                        : AppColors.surface3,
                    borderRadius: AppRadii.xsRadius,
                  ),
                ),
              ),
              if (i != steps.length - 1) const SizedBox(width: AppSpacing.x3),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        Row(
          children: [
            for (var i = 0; i < steps.length; i++)
              Expanded(
                child: Text(
                  steps[i],
                  textAlign: TextAlign.center,
                  style: AppTextStyles.micro.copyWith(
                    color: i <= activeIndex ? _stepColor(i) : AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.trailing,
  });

  final String label;
  final String value;
  final Color valueColor;
  final IconData? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: valueColor,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: AppSpacing.x1),
                  Icon(trailing, color: valueColor, size: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClaimBenchmarksCard extends StatelessWidget {
  const _ClaimBenchmarksCard({required this.snapshot});

  final P2PClaimDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PClaimDetailPage.benchmarksKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                color: AppColors.accent,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'So sánh với nền tảng',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'So sánh claim của bạn với 847 claims đã xử lý',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final benchmark in snapshot.benchmarks) ...[
            _BenchmarkMetricCard(benchmark: benchmark),
            if (benchmark != snapshot.benchmarks.last)
              const SizedBox(height: AppSpacing.x4),
          ],
          const SizedBox(height: AppSpacing.x4),
          _ReasonDistribution(rows: snapshot.reasonShares),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: const [
              Expanded(
                child: _MiniStatCard(
                  label: 'Tỷ lệ duyệt chung',
                  value: '78.5%',
                ),
              ),
              SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniStatCard(label: 'Xử lý nhanh nhất', value: '4h'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BenchmarkMetricCard extends StatelessWidget {
  const _BenchmarkMetricCard({required this.benchmark});

  final P2PClaimBenchmarkDraft benchmark;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(benchmark.toneKey);
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                _benchmarkIcon(benchmark.id),
                color: AppColors.text3,
                size: 15,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  benchmark.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                benchmark.comparison,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            benchmark.value,
            style: AppTextStyles.baseMedium.copyWith(
              color: benchmark.toneKey == 'primary' ? AppColors.text1 : color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          _ProgressLine(progress: benchmark.progress, color: color),
          const SizedBox(height: AppSpacing.x2),
          Text(
            benchmark.caption,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ReasonDistribution extends StatelessWidget {
  const _ReasonDistribution({required this.rows});

  final List<P2PClaimReasonShareDraft> rows;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.groups_outlined,
                color: AppColors.text3,
                size: 15,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Phân bổ lý do claim',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final row in rows) ...[
            _ReasonShareRow(row: row),
            if (row != rows.last) const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}
