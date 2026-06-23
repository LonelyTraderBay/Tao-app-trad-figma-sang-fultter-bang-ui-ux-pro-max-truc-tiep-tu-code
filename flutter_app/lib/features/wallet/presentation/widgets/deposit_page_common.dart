part of '../pages/deposit_page.dart';

class _DepositInfoCard extends StatelessWidget {
  const _DepositInfoCard({required this.asset, required this.network});

  final String asset;
  final WalletDepositNetwork network;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Thời gian xử lý', network.arrivalTime),
      ('Xác nhận cần thiết', '${network.confirmations} blocks'),
      ('Phí nạp', network.fee),
      ('Nạp tối thiểu', '${_formatDeposit(network.minDeposit)} $asset'),
      ('Nạp nhỏ hơn tối thiểu', 'Không được ghi nhận'),
    ];

    return VitCard(
      padding: _depositCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Thông tin nạp tiền',
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: _depositGap),
          for (var i = 0; i < rows.length; i++) ...[
            _InfoRow(label: rows[i].$1, value: rows[i].$2),
            if (i != rows.length - 1) const SizedBox(height: _depositGap),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        const SizedBox(width: _depositInlineGap),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
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

class _RefreshButton extends StatelessWidget {
  const _RefreshButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      key: DepositPage.refreshKey,
      onTap: onTap,
      label: 'Làm mới địa chỉ nạp',
      selected: false,
      fullWidth: true,
      height: _depositRefreshHeight,
      accentColor: _depositPrimary,
      leading: const Icon(Icons.refresh_rounded),
      padding: _depositCompactPadding,
    );
  }
}

class _NetworkOption extends StatelessWidget {
  const _NetworkOption({
    required this.network,
    required this.selected,
    required this.onTap,
  });

  final WalletDepositNetwork network;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: DepositPage.networkKey(network.id),
      onTap: onTap,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.transparent,
      child: VitCard(
        variant: VitCardVariant.inner,
        padding: _depositCompactPadding,
        borderColor: selected ? _depositPrimary : AppColors.border,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    network.name,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: _depositTinyGap),
                  Text(
                    'Phí: ${network.fee} · ${network.arrivalTime} · ${network.confirmations} xác nhận',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: _depositPrimary,
                size: AppSpacing.iconSm,
              ),
          ],
        ),
      ),
    );
  }
}

String _formatDeposit(double value) {
  if (value == value.roundToDouble()) return value.toInt().toString();
  return value.toString();
}
