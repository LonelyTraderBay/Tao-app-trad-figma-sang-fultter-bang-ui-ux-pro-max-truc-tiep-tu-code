import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/home_controller_providers.dart';
import 'package:vit_trade_flutter/app/providers/notifications_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header_action_button.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'home_page_part_01.dart';
part 'home_page_part_02.dart';
part 'home_page_part_03.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc007_home_scroll_content');
  static const headerKey = Key('sc007_home_header');
  static const announcementKey = Key('sc007_home_announcement');
  static const nextActionKey = Key('sc007_home_next_action');
  static const marketTickerKey = Key('sc007_home_market_ticker');
  static const productsSectionKey = Key('sc007_home_products_section');
  static const recentProductsKey = Key('sc007_home_recent_products');
  static const recentProductsSectionKey = Key(
    'sc007_home_recent_products_section',
  );
  static const moreProductsSheetKey = Key('sc007_home_more_products_sheet');

  static Key recentProductKey(String id) => Key('sc007_home_recent_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

enum HomeDensityVariant { compact, comfortable }

enum HomeSurfaceOrder { productsBeforeRecent, recentBeforeProducts }

const double _framedScrollClearance = AppSpacing.buttonStandard + AppSpacing.x7;
const double _nativeScrollClearance = AppSpacing.buttonStandard + AppSpacing.x5;
const double _heroActionExtent = AppSpacing.buttonCompact + AppSpacing.x2;
const double _assetAvatarExtent = AppSpacing.iconMd + AppSpacing.x1;
const double _recentProductExtent = AppSpacing.buttonStandard + AppSpacing.x6;
const double _recentProductWidth = AppSpacing.x7 * 2 + AppSpacing.x5;
const double _trendCardExtent =
    AppSpacing.buttonStandard + AppSpacing.x7 + AppSpacing.x5;
const double _trendCardWidth =
    AppSpacing.x7 * 2 + AppSpacing.x6 + AppSpacing.x1;
