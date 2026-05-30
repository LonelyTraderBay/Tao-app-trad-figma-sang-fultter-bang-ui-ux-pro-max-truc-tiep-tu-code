part of 'p2p_insurance_fund_page.dart';

class _ClaimCalculatorCard extends StatelessWidget {
  const _ClaimCalculatorCard({required this.coveragePct});

  final int coveragePct;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.calculate_outlined,
            title: 'Tính toán bồi thường',
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Nhập số tiền giao dịch (VND)',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Container(
            height: AppSpacing.inputHeight,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              border: Border.all(color: AppColors.borderSolid),
              borderRadius: AppRadii.inputRadius,
            ),
            child: Text(
              'VD: 50.000.000',
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Tỷ lệ hiện tại: $coveragePct%',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _PlatformStatsCard extends StatelessWidget {
  const _PlatformStatsCard({required this.snapshot});

  final P2PInsuranceFundSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.bar_chart_rounded,
            title: 'Thống kê nền tảng',
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: const [
              Expanded(
                child: _StatTile(
                  icon: Icons.receipt_long_rounded,
                  label: 'Tổng claims',
                  value: '847',
                ),
              ),
              SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _StatTile(
                  icon: Icons.bolt_rounded,
                  label: 'Thắng này',
                  value: '12',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: const [
              Expanded(
                child: _StatTile(
                  icon: Icons.groups_rounded,
                  label: 'Merchants',
                  value: '1.240',
                ),
              ),
              SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _StatTile(
                  icon: Icons.timer_rounded,
                  label: 'Xử lý nhanh nhất',
                  value: '4h',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _TwoColumnInfo(label: 'Tổng đã xử lý', value: '2.14B'),
          _TwoColumnInfo(label: 'Claim trung bình', value: '15.200.000 đ'),
        ],
      ),
    );
  }
}

class _ClaimsContent extends StatelessWidget {
  const _ClaimsContent({required this.snapshot});

  final P2PInsuranceFundSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCtaButton(
          key: P2PInsuranceFundPage.submitClaimKey,
          onPressed: () => HapticFeedback.selectionClick(),
          child: const Text('Gửi yêu cầu bồi thường'),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final claim in snapshot.claims) ...[
          _ClaimCard(claim: claim),
          const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _InsuranceTourOverlay extends StatelessWidget {
  const _InsuranceTourOverlay({
    required this.snapshot,
    required this.onClose,
    required this.onContinue,
  });

  final P2PInsuranceFundSnapshot snapshot;
  final VoidCallback onClose;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final height = math.min(MediaQuery.sizeOf(context).height, 956.0);
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: height,
      child: Material(
        key: P2PInsuranceFundPage.tourKey,
        color: AppColors.bg.withValues(alpha: .82),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentPad,
              AppSpacing.x7,
              AppSpacing.contentPad,
              AppSpacing.x5,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.cardBorder),
                borderRadius: AppRadii.cardLargeRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.x4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        for (var i = 0; i < 5; i++) ...[
                          Expanded(
                            child: Container(
                              height: 3,
                              decoration: BoxDecoration(
                                color: i == 0
                                    ? AppModuleAccents.p2p
                                    : AppColors.surface3,
                                borderRadius: AppRadii.xsRadius,
                              ),
                            ),
                          ),
                          if (i != 4) const SizedBox(width: AppSpacing.x2),
                        ],
                        const SizedBox(width: AppSpacing.x3),
                        VitIconButton(
                          icon: Icons.close_rounded,
                          tooltip: 'Đóng',
                          size: VitIconButtonSize.sm,
                          variant: VitIconButtonVariant.ghost,
                          onPressed: onClose,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      '1 / 5',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: AppSpacing.x7,
                        height: AppSpacing.x7,
                        decoration: BoxDecoration(
                          color: AppColors.primary12,
                          borderRadius: AppRadii.lgRadius,
                        ),
                        child: const Icon(
                          Icons.shield_outlined,
                          color: AppModuleAccents.p2p,
                          size: AppSpacing.iconLg,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x5),
                    Text(
                      'Chào mừng đến Quỹ Bảo Hiểm P2P',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    Text(
                      'Quỹ bảo hiểm P2P bảo vệ bạn khi giao dịch P2P gặp sự cố.\nMỗi giao dịch của bạn đều được trích một phần nhỏ vào quỹ để đảm bảo an toàn cho cộng đồng.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x5),
                    _TourInfoCard(
                      title: 'Dành cho bạn',
                      icon: Icons.star_border_rounded,
                      items: [
                        'Bạn đã hoàn thành 47 giao dịch — mọi GD đều được bảo vệ tự động',
                        'Với khối lượng GD cao, bảo hiểm là lớp phòng vệ quan trọng',
                        '180 ngày thành viên — cảm ơn bạn đã tin tưởng sử dụng',
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    _TourInfoCard(
                      title: 'Thông tin chung',
                      icon: Icons.check_circle_outline_rounded,
                      muted: true,
                      items: const [
                        'Quỹ được trích từ 0.1% mỗi giao dịch',
                        'Hoàn toàn tự động — không cần đăng ký',
                        'Bảo vệ cả buyer và seller',
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Row(
                      children: [
                        TextButton(
                          onPressed: onClose,
                          child: Text(
                            'Bỏ qua',
                            style: AppTextStyles.baseMedium.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x3),
                        Expanded(
                          child: VitCtaButton(
                            key: P2PInsuranceFundPage.tourContinueKey,
                            onPressed: onContinue,
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.onAccent,
                              size: AppSpacing.iconMd,
                            ),
                            child: const Text('Tiếp tục'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TourInfoCard extends StatelessWidget {
  const _TourInfoCard({
    required this.title,
    required this.icon,
    required this.items,
    this.muted = false,
  });

  final String title;
  final IconData icon;
  final List<String> items;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: muted ? VitCardVariant.inner : VitCardVariant.standard,
      radius: VitCardRadius.sm,
      borderColor: muted ? AppColors.borderSolid : AppColors.warningBorder,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppModuleAccents.p2p, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Text(
                title,
                style: AppTextStyles.caption.copyWith(
                  color: AppModuleAccents.p2p,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final item in items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSpacing.iconMd,
                  height: AppSpacing.iconMd,
                  decoration: const BoxDecoration(
                    color: AppColors.primary12,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.trending_up_rounded,
                    color: AppModuleAccents.p2p,
                    size: AppSpacing.iconSm,
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.medium,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            if (item != items.last) const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _ClaimCard extends StatelessWidget {
  const _ClaimCard({required this.claim});

  final P2PInsuranceClaimDraft claim;

  @override
  Widget build(BuildContext context) {
    final config = _claimStatusConfig(claim.status);
    return VitCard(
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: () {
        HapticFeedback.selectionClick();
        context.go(AppRoutePaths.p2pClaim(claim.id));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  claim.claimCode,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
              ),
              VitStatusPill(
                label: config.label,
                status: config.status,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            '${claim.orderId} · ${claim.reason}',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x2),
          _TwoColumnInfo(
            label: 'Số tiền',
            value: '${_formatVnd(claim.amount)} đ',
            tone: config.color,
          ),
          if (claim.paidAmount != null)
            _TwoColumnInfo(
              label: 'Đã nhận',
              value: '${_formatVnd(claim.paidAmount!)} đ',
              tone: AppColors.buy,
            ),
        ],
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppModuleAccents.p2p, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.baseMedium.copyWith(
            color: AppColors.text1,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        Text(
          label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _EligibilityRow extends StatelessWidget {
  const _EligibilityRow({required this.item});

  final P2PInsuranceEligibilityItemDraft item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline_rounded,
          color: AppColors.buy,
          size: AppSpacing.iconSm,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            item.label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        if (item.value != null)
          Flexible(
            child: Text(
              item.value!,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: item.highlight ? AppColors.buy : AppColors.text3,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
      ],
    );
  }
}
