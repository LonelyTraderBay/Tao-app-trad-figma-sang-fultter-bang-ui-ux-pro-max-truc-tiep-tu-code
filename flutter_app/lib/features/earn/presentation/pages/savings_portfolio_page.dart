import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

part 'savings_portfolio_page_part_01.dart';
part 'savings_portfolio_page_part_02.dart';
part 'savings_portfolio_page_part_03.dart';

enum _PortfolioTab { overview, positions, earnings }

enum _PositionFilter { all, flexible, locked }

const double _savingsPortfolioVisualNavClearance = 112;
const double _savingsPortfolioNativeNavClearance = 88;
const double _savingsPortfolioDonutExtent = 118;
const double _savingsPortfolioSectionMarkerExtent =
    AppSpacing.iconSm + AppSpacing.x1;
const double _savingsPortfolioSecondaryButtonExtent = 36;
const double _savingsPortfolioDaysLineHeight = 1.05;
const EdgeInsetsDirectional _savingsPortfolioCardPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);

class SavingsPortfolioPage extends ConsumerStatefulWidget {
  const SavingsPortfolioPage({super.key, this.shellRenderMode});

  static const historyButtonKey = Key('sc333_history_button');
  static const positionsTabKey = Key('sc333_tab_positions');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsPortfolioPage> createState() =>
      _SavingsPortfolioPageState();
}
