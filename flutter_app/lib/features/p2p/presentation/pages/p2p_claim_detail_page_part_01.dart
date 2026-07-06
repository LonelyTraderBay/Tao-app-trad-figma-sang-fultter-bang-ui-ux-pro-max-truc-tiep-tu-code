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
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pClaimVisualNavClearance + _p2pClaimVisualClearance
            : _p2pClaimNativeNavClearance + _p2pClaimNativeClearance) +
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
                    physics: const ClampingScrollPhysics(),
                    padding: AppSpacing.p2pClaimScrollPadding(scrollEndPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ClaimHeroCard(claim: claim),
                        const SizedBox(height: _p2pClaimSectionGap),
                        _ClaimBenchmarksCard(snapshot: snapshot),
                        const SizedBox(height: _p2pClaimSectionGap),
                        _DescriptionCard(description: claim.description),
                        const SizedBox(height: _p2pClaimSectionGap),
                        _ClaimSectionTabs(
                          active: _section,
                          claim: claim,
                          onChanged: (section) {
                            HapticFeedback.selectionClick();
                            setState(() => _section = section);
                          },
                        ),
                        const SizedBox(height: _p2pClaimTightGap),
                        _ClaimSectionBody(section: _section, claim: claim),
                        const SizedBox(height: _p2pClaimSectionGap),
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
                        const SizedBox(height: _p2pClaimTightGap),
                        _ActionRow(
                          key: P2PClaimDetailPage.orderLinkKey,
                          icon: Icons.open_in_new_rounded,
                          title: 'Xem đơn hàng gốc',
                          onTap: () {
                            HapticFeedback.selectionClick();
                            context.go(snapshot.orderRoute);
                          },
                        ),
                        const SizedBox(height: _p2pClaimTightGap),
                        _ActionRow(
                          key: P2PClaimDetailPage.supportLinkKey,
                          icon: Icons.help_outline_rounded,
                          title: 'Liên hệ hỗ trợ',
                          onTap: () {
                            HapticFeedback.selectionClick();
                            context.go(snapshot.supportRoute);
                          },
                        ),
                        if (_feedback != null) ...[
                          const SizedBox(height: _p2pClaimTightGap),
                          _FeedbackBanner(message: _feedback!),
                        ],
                        if (claim.status == P2PInsuranceClaimStatus.paid) ...[
                          const SizedBox(height: _p2pClaimTightGap),
                          VitCtaButton(
                            key: P2PClaimDetailPage.receiptKey,
                            variant: VitCtaButtonVariant.success,
                            density: VitDensity.compact,
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
                        ],
                        const SizedBox(height: _p2pClaimTightGap),
                        const VitHighRiskStatePanel(
                          density: VitDensity.compact,
                          state: VitHighRiskUiState.riskReview,
                          title: 'Xem lại chi tiết claim',
                          message:
                              'Trạng thái claim, số tiền bảo hiểm, bằng chứng, thông báo, biên lai và bước hỗ trợ tiếp theo được xem lại trước thao tác tiếp.',
                          contractId: 'p2p-claim-detail-review',
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
      radius: VitCardRadius.large,
      padding: AppSpacing.p2pClaimHeroPadding,
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
              const SizedBox(width: AppSpacing.x2),
              VitStatusPill(
                label: claim.claimCode,
                status: VitStatusPillStatus.neutral,
                icon: Icons.content_copy_rounded,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _ClaimProgress(status: claim.status),
          const Divider(
            height: _p2pClaimDividerExtent,
            color: AppColors.divider,
          ),
          VitInfoRow(
            label: 'Lệnh P2P',
            value: claim.orderId,
            valueColor: AppModuleAccents.p2p,
            density: VitDensity.compact,
            trailing: Icon(
              Icons.open_in_new_rounded,
              color: AppModuleAccents.p2p,
              size: AppSpacing.p2pClaimInlineIcon,
            ),
          ),
          VitInfoRow(
            label: 'Lý do',
            value: claim.reason,
            density: VitDensity.compact,
          ),
          VitInfoRow(
            label: 'Số tiền yêu cầu',
            value: '${_formatVnd(claim.amount)} đ',
            density: VitDensity.compact,
          ),
          VitInfoRow(
            label: 'Tỷ lệ bảo hiểm',
            value: '${claim.coveragePct}%',
            valueColor: AppModuleAccents.p2p,
            density: VitDensity.compact,
          ),
          const Divider(
            height: _p2pClaimDividerExtent,
            color: AppColors.divider,
          ),
          if (claim.paidAmount != null)
            VitInfoRow(
              label: claim.statusLabel,
              value: '${_formatVnd(claim.paidAmount!)} đ',
              valueColor: AppColors.buy,
              density: VitDensity.compact,
            ),
          VitInfoRow(
            label: 'Ngày gửi',
            value: claim.submittedAt,
            density: VitDensity.compact,
          ),
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
                child: ClipRRect(
                  borderRadius: AppRadii.xsRadius,
                  child: SizedBox(
                    height: _p2pClaimProgressLineExtent,
                    child: ColoredBox(
                      color: i <= activeIndex
                          ? _stepColor(i)
                          : AppColors.surface3,
                    ),
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

class _ClaimBenchmarksCard extends StatelessWidget {
  const _ClaimBenchmarksCard({required this.snapshot});

  final P2PClaimDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PClaimDetailPage.benchmarksKey,
      radius: VitCardRadius.large,
      padding: AppSpacing.p2pClaimCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VitSectionHeader(
            title: 'So sánh với nền tảng',
            icon: Icons.bar_chart_rounded,
            iconColor: AppColors.accent,
            density: VitDensity.compact,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'So sánh claim của bạn với 847 claims đã xử lý',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var i = 0; i < snapshot.benchmarks.length; i++) ...[
            if (i > 0)
              const Divider(
                height: _p2pClaimDividerExtent,
                color: AppColors.divider,
              ),
            _BenchmarkMetricRow(benchmark: snapshot.benchmarks[i]),
          ],
          const SizedBox(height: AppSpacing.x4),
          const VitSectionHeader(
            title: 'Phân bổ lý do claim',
            icon: Icons.groups_outlined,
            density: VitDensity.compact,
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final row in snapshot.reasonShares) ...[
            _ReasonShareRow(row: row),
            if (row != snapshot.reasonShares.last)
              const SizedBox(height: AppSpacing.x2),
          ],
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: const [
              Expanded(
                child: _MiniStatTile(
                  label: 'Tỷ lệ duyệt chung',
                  value: '78.5%',
                ),
              ),
              SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniStatTile(label: 'Xử lý nhanh nhất', value: '4h'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BenchmarkMetricRow extends StatelessWidget {
  const _BenchmarkMetricRow({required this.benchmark});

  final P2PClaimBenchmarkDraft benchmark;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(benchmark.toneKey);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                _benchmarkIcon(benchmark.id),
                color: AppColors.text3,
                size: AppSpacing.p2pClaimBenchmarkIcon,
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
