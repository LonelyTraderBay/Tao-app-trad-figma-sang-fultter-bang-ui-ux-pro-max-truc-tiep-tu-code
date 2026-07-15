import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

const withdrawBackground = AppColors.bg;
const withdrawPanel = AppColors.surface;
const withdrawPanel2 = AppColors.surface2;
const withdrawPrimary = AppColors.primary;
const withdrawGreen = AppColors.buy;
const withdrawAmber = AppColors.caution;

const withdrawContentKey = Key('sc139_withdraw_content');
const withdrawNetworkSelectorKey = Key('sc139_withdraw_network_selector');
const withdrawAddressFieldKey = Key('sc139_withdraw_address_field');
const withdrawAmountFieldKey = Key('sc139_withdraw_amount_field');
const withdrawAllAmountKey = Key('sc139_withdraw_all_amount');
const withdrawNextKey = Key('sc139_withdraw_next');
const withdrawSupportKey = Key('sc139_withdraw_support');
const withdrawCancelConfirmKey = Key('sc139_withdraw_cancel_confirm');
const withdrawConfirmWithdrawKey = Key('sc139_withdraw_confirm_withdraw');

Key withdrawNetworkKey(String id) => Key('sc139_withdraw_network_$id');
Key withdrawRecentAddressKey(String label) {
  return Key('sc139_withdraw_recent_$label');
}

String maskWithdrawAddress(String address) {
  if (address.length <= 12) return address;
  return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
}

String formatWithdrawBalance(double value) {
  return formatWithdrawNumber(value, fractionDigits: 2);
}

String formatWithdrawNetworkFee(double value) {
  return value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toString();
}

String formatWithdrawCompact(double value) {
  return value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toString();
}

String formatWithdrawNumber(double value, {required int fractionDigits}) {
  final fixed = value.toStringAsFixed(fractionDigits);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  return '${buffer.toString()}.${parts[1]}';
}

class WithdrawSectionLabel extends StatelessWidget {
  const WithdrawSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.control.copyWith(color: AppColors.text2),
    );
  }
}
