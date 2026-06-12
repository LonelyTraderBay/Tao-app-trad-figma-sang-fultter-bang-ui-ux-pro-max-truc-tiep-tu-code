import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part 'client_categorization_page_part_01.dart';
part 'client_categorization_page_part_02.dart';
part 'client_categorization_page_part_03.dart';

const _clientBackground = AppColors.bg;
const _clientBorder = AppColors.borderSolid;
const _clientGreen = AppColors.buy;
const _clientPrimary = AppColors.primary;
const _clientAmber = AppColors.caution;

class ClientCategorizationPage extends ConsumerStatefulWidget {
  const ClientCategorizationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc099_client_categorization_content');
  static const optUpKey = Key('sc099_client_opt_up');
  static const disclosuresKey = Key('sc099_client_disclosures');
  static const settingsKey = Key('sc099_client_settings');
  static Key tabKey(String id) => Key('sc099_client_tab_$id');
  static Key categoryKey(String id) => Key('sc099_client_category_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ClientCategorizationPage> createState() =>
      _ClientCategorizationPageState();
}
