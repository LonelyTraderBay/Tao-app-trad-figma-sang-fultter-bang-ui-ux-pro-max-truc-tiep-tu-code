import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/earn_custody_risk_banner.dart';

part 'savings_recommendations_page_part_01.dart';
part 'savings_recommendations_page_part_02.dart';
part 'savings_recommendations_page_part_03.dart';

class SavingsRecommendationsPage extends ConsumerStatefulWidget {
  const SavingsRecommendationsPage({super.key, this.shellRenderMode});

  static const amountFieldKey = Key('sc338_amount_field');
  static const strategyListKey = Key('sc338_strategy_list');
  static const compareButtonKey = Key('sc338_compare_button');
  static const riskButtonKey = Key('sc338_risk_button');
  static const productsButtonKey = Key('sc338_products_button');
  static const detailCtaKey = Key('sc338_strategy_detail_cta');

  static Key strategyKey(String id) => Key('sc338_strategy_$id');
  static Key amountChipKey(int amount) => Key('sc338_amount_$amount');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsRecommendationsPage> createState() =>
      _SavingsRecommendationsPageState();
}
