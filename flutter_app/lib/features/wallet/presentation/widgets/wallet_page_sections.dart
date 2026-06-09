import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_search_bar.dart';

part 'wallet_page_balance_sections.dart';
part 'wallet_page_dca_tool_sections.dart';
part 'wallet_page_asset_sections.dart';
part 'wallet_page_allocation_sections.dart';

const _walletPanel = AppColors.surface;
const _walletPanel2 = AppColors.surface2;
const _walletPrimary = AppColors.primary;
const _walletGreen = AppColors.buy;
const _walletRed = AppColors.sell;
const _walletAmber = AppColors.caution;
const _walletPurple = AppColors.accent;
