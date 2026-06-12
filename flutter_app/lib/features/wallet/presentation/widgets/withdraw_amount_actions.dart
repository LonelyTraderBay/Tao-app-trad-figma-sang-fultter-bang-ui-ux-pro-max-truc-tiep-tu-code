part of 'withdraw_form_sections.dart';

class WithdrawRecentAddresses extends StatelessWidget {
  const WithdrawRecentAddresses({
    required this.addresses,
    required this.onSelect,
    super.key,
  });

  final List<WalletRecentAddress> addresses;
  final ValueChanged<WalletRecentAddress> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(
              Icons.menu_book_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              'Lịch sử địa chỉ gần đây',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.rowGap),
        for (final address in addresses) ...[
          Semantics(
            button: true,
            label: 'Use recent withdrawal address ${address.label}',
            hint: address.address,
            child: GestureDetector(
              key: withdrawRecentAddressKey(address.label),
              onTap: () => onSelect(address),
              behavior: HitTestBehavior.opaque,
              child: VitCard(
                variant: VitCardVariant.ghost,
                borderColor: AppColors.divider,
                padding: AppSpacing.walletWithdrawRecentAddressPadding,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            address.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x1),
                          Text(
                            address.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Text(
                      address.lastUsed,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
        ],
      ],
    );
  }
}

class WithdrawAmountInput extends StatelessWidget {
  const WithdrawAmountInput({
    required this.asset,
    required this.available,
    required this.controller,
    required this.onAll,
    super.key,
  });

  final String asset;
  final double available;
  final TextEditingController controller;
  final VoidCallback onAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(child: WithdrawSectionLabel('Số lượng rút')),
            Semantics(
              button: true,
              label: 'Use full withdrawable balance',
              child: GestureDetector(
                key: withdrawAllAmountKey,
                onTap: onAll,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  'Tất cả',
                  style: AppTextStyles.micro.copyWith(
                    color: withdrawPrimary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.rowGap),
        VitCard(
          variant: VitCardVariant.inner,
          borderColor: withdrawPrimary.withValues(alpha: .25),
          padding: AppSpacing.cardPadding,
          child: Row(
            children: [
              Expanded(
                child: Semantics(
                  textField: true,
                  label: 'Withdrawal amount',
                  hint: 'Enter amount in $asset',
                  child: TextField(
                    key: withdrawAmountFieldKey,
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    style: AppTextStyles.amountSm.copyWith(
                      fontFeatures: AppTextStyles.tabularFigures,
                      fontWeight: AppTextStyles.bold,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                      hintText: '0.00',
                      hintStyle: AppTextStyles.amountSm.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.rowGap),
              Text(
                asset,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WithdrawWarning extends StatelessWidget {
  const WithdrawWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.standard,
      borderColor: withdrawAmber.withValues(alpha: .30),
      padding: AppSpacing.cardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.access_time_rounded,
            color: withdrawAmber,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Rút tiền cần xác minh 2FA. Yêu cầu rút trên \$10,000 chỉ được xem xét trong 24h.',
              style: AppTextStyles.micro.copyWith(color: withdrawAmber),
            ),
          ),
        ],
      ),
    );
  }
}

class WithdrawSupportLink extends StatelessWidget {
  const WithdrawSupportLink({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Open contextual withdrawal support',
      child: GestureDetector(
        key: withdrawSupportKey,
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: VitCard(
          variant: VitCardVariant.inner,
          borderColor: withdrawPrimary.withValues(alpha: .22),
          padding: AppSpacing.walletWithdrawSupportPadding,
          child: Row(
            children: [
              const Icon(
                Icons.support_agent_rounded,
                color: withdrawPrimary,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Cần hỗ trợ rút tiền?',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                'Mở hồ sơ',
                style: AppTextStyles.micro.copyWith(
                  color: withdrawPrimary,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              const Icon(
                Icons.chevron_right_rounded,
                color: withdrawPrimary,
                size: AppSpacing.iconSm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WithdrawNextButton extends StatelessWidget {
  const WithdrawNextButton({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Preview withdrawal',
      child: GestureDetector(
        key: withdrawNextKey,
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: VitCard(
          variant: VitCardVariant.standard,
          height: AppSpacing.inputHeight,
          borderColor: AppColors.primary,
          alignment: Alignment.center,
          child: Text(
            'Tiếp tục →',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}
