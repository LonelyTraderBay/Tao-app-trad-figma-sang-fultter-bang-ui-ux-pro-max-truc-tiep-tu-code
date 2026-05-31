import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/withdraw_common.dart';

class WithdrawBalanceCard extends StatelessWidget {
  const WithdrawBalanceCard({
    required this.asset,
    required this.value,
    super.key,
  });

  final String asset;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: withdrawPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Số dư khả dụng',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            '${formatWithdrawBalance(value)} $asset',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class WithdrawNetworkSelector extends StatelessWidget {
  const WithdrawNetworkSelector({
    required this.asset,
    required this.network,
    required this.onTap,
    super.key,
  });

  final String asset;
  final WalletWithdrawNetwork network;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const WithdrawSectionLabel('Mạng lưới'),
        const SizedBox(height: 9),
        Semantics(
          button: true,
          label:
              'Withdraw network selector ${network.name}, fee ${formatWithdrawNetworkFee(network.fee)} $asset, minimum ${formatWithdrawCompact(network.minWithdraw)}',
          child: GestureDetector(
            key: withdrawNetworkSelectorKey,
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: withdrawPanel2,
                border: Border.all(
                  color: withdrawPrimary.withValues(alpha: .34),
                ),
                borderRadius: AppRadii.inputRadius,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          network.name,
                          style: AppTextStyles.body.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Phí: ${formatWithdrawNetworkFee(network.fee)} $asset · Tối thiểu: ${formatWithdrawCompact(network.minWithdraw)}',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text2,
                            fontSize: 11,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text2,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: withdrawGreen,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                'Mạng hoạt động tốt  ·  Phí: ${formatWithdrawNetworkFee(network.fee)} $asset',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class WithdrawAddressInput extends StatelessWidget {
  const WithdrawAddressInput({
    required this.asset,
    required this.network,
    required this.controller,
    required this.onScan,
    super.key,
  });

  final String asset;
  final WalletWithdrawNetwork network;
  final TextEditingController controller;
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(child: WithdrawSectionLabel('Địa chỉ ví nhận')),
            Semantics(
              button: true,
              label: 'Scan withdrawal address QR code',
              child: GestureDetector(
                onTap: onScan,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  decoration: BoxDecoration(
                    color: withdrawPrimary.withValues(alpha: .14),
                    borderRadius: AppRadii.mdRadius,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.qr_code_scanner_rounded,
                        color: withdrawPrimary,
                        size: 13,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Quét QR',
                        style: AppTextStyles.micro.copyWith(
                          color: withdrawPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        Container(
          height: 47,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: withdrawPanel2,
            border: Border.all(color: withdrawPrimary.withValues(alpha: .25)),
            borderRadius: AppRadii.inputRadius,
          ),
          alignment: Alignment.center,
          child: Semantics(
            textField: true,
            label: 'Withdrawal destination address',
            hint: 'Enter $asset address for ${network.name}',
            child: TextField(
              key: withdrawAddressFieldKey,
              controller: controller,
              style: AppTextStyles.body.copyWith(fontSize: 14),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                hintText:
                    'Nhập địa chỉ $asset (${network.name.split(' ').first})',
                hintStyle: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

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
