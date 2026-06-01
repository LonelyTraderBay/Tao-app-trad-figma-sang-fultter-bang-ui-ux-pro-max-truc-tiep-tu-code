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
              size: 13,
            ),
            const SizedBox(width: 5),
            Text(
              '�?a ch? g?n d�y',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 11,
                height: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        for (final address in addresses) ...[
          Semantics(
            button: true,
            label: 'Use recent withdrawal address ${address.label}',
            hint: address.address,
            child: GestureDetector(
              key: withdrawRecentAddressKey(address.label),
              onTap: () => onSelect(address),
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 51,
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: withdrawPanel2,
                  borderRadius: AppRadii.inputRadius,
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            address.label,
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            address.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              fontSize: 9,
                              fontFamily: 'Roboto',
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      address.lastUsed,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 9,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 7),
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
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: withdrawPanel2,
            border: Border.all(color: withdrawPrimary.withValues(alpha: .25)),
            borderRadius: AppRadii.inputRadius,
          ),
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
                    style: AppTextStyles.body.copyWith(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w800,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                      hintText: '0.00',
                      hintStyle: AppTextStyles.body.copyWith(
                        color: AppColors.text2,
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                asset,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontSize: 13,
                  height: 1,
                ),
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
    return Container(
      constraints: const BoxConstraints(minHeight: 62),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: withdrawAmber.withValues(alpha: .10),
        border: Border.all(color: withdrawAmber.withValues(alpha: .28)),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.access_time_rounded, color: withdrawAmber, size: 14),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'Rút tiền cần xác minh 2FA. Yêu cầu rút trên \$10,000 sẽ được xem xét trong 24h.',
              style: AppTextStyles.micro.copyWith(
                color: withdrawAmber,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.45,
              ),
            ),
          ),
        ],
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
        child: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: AppRadii.inputRadius,
            boxShadow: [
              BoxShadow(
                color: withdrawPrimary.withValues(alpha: .28),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Text(
            'Tiếp tục →',
            style: AppTextStyles.baseMedium.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
