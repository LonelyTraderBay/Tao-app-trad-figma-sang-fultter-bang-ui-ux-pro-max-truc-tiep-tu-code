part of '../pages/arena_studio_page.dart';

class _PlatformFeeBanner extends StatefulWidget {
  const _PlatformFeeBanner({required this.platformFeePct});

  final int platformFeePct;

  @override
  State<_PlatformFeeBanner> createState() => _PlatformFeeBannerState();
}

class _PlatformFeeBannerState extends State<_PlatformFeeBanner> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      radius: VitCardRadius.lg,
      padding: AppSpacing.arenaStudioCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: AppSpacing.arenaStudioFeeIconBox,
                height: AppSpacing.arenaStudioFeeIconBox,
                child: const DecoratedBox(
                  decoration: ShapeDecoration(
                    color: AppColors.warn10,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.mdRadius,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.receipt_long_outlined,
                      color: _arenaAccent,
                      size: AppSpacing.iconMd,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Phí vận hành platform',
                          style: AppTextStyles.base.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        VitStatusPill(
                          label: '${widget.platformFeePct}%',
                          status: VitStatusPillStatus.orange,
                          size: VitStatusPillSize.sm,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Mọi challenge đều được trích ${widget.platformFeePct}% tổng pool để duy trì hệ thống. Phần này được hiển thị công khai cho tất cả người tham gia.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: AppSpacing.arenaStudioFeeBodyLineHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _expanded = !_expanded);
            },
            borderRadius: AppRadii.smRadius,
            child: Padding(
              padding: AppSpacing.arenaStudioFeeTogglePadding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: _arenaAccent,
                    size: AppSpacing.arenaStudioFeeInfoIcon,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Text(
                    _expanded ? 'Ẩn chi tiết phí' : 'Phí bao gồm những gì?',
                    style: AppTextStyles.micro.copyWith(
                      color: _arenaAccent,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: _arenaAccent,
                    size: AppSpacing.arenaStudioFeeChevron,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const SizedBox(height: AppSpacing.x2),
            const _FeeDetailRow(
              icon: Icons.verified_user_outlined,
              label: 'Kiểm duyệt tự động',
              value: '3%',
            ),
            const _FeeDetailRow(
              icon: Icons.lock_outline_rounded,
              label: 'Escrow & bảo mật',
              value: '3%',
            ),
            const _FeeDetailRow(
              icon: Icons.balance_outlined,
              label: 'Dispute resolution',
              value: '2%',
            ),
            const _FeeDetailRow(
              icon: Icons.dns_outlined,
              label: 'Hạ tầng & vận hành',
              value: '2%',
            ),
          ],
        ],
      ),
    );
  }
}

class _FeeDetailRow extends StatelessWidget {
  const _FeeDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.arenaStudioFeeDetailPadding,
      child: Row(
        children: [
          Icon(
            icon,
            color: _arenaAccent,
            size: AppSpacing.arenaStudioFeeDetailIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: _arenaAccent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
