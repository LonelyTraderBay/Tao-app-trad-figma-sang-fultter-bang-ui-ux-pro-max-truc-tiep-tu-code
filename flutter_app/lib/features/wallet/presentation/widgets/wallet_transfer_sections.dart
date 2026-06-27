import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_asset_avatar.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_choice_pill.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_icon_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_info_row.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_input.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sheet_handle.dart';

part 'wallet_transfer_confirm_sheet.dart';
part 'wallet_transfer_wallet_cards.dart';
part 'wallet_transfer_asset_amount.dart';
part 'wallet_transfer_history_picker.dart';

const _transferPrimary = AppColors.primary;
const _transferGreen = AppColors.buy;
const _transferInlineGap = AppSpacing.rowGap;
const _transferIconBox = AppSpacing.buttonCompact;
const _transferActionIcon = AppSpacing.transferActionIcon;

String formatTransferUsd(double value) {
  return '\$${_withCommas(value.toStringAsFixed(2))}';
}

String formatTransferAssetAmount(double value) {
  final decimals = value >= 1000 ? 2 : 4;
  return _withCommas(value.toStringAsFixed(decimals));
}

String _withCommas(String value) {
  final parts = value.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final remaining = whole.length - i;
    buffer.write(whole[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  if (parts.length > 1) {
    buffer.write('.');
    buffer.write(parts[1]);
  }
  return buffer.toString();
}
