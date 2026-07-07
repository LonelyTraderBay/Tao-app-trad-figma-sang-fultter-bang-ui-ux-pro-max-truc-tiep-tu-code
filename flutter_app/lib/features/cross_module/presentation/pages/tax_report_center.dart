import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/cross_module_controller_providers.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';

import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';

import 'package:vit_trade_flutter/app/theme/app_radii.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';

import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

import 'package:vit_trade_flutter/features/cross_module/presentation/widgets/cross_module_tabbed_shell.dart';

import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';

import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/cross_module_spacing_tokens.dart';

part 'tax_report_center_part_01.dart';

part 'tax_report_center_part_02.dart';

part 'tax_report_center_part_03.dart';

class TaxReportCenter extends ConsumerStatefulWidget {
  const TaxReportCenter({super.key, this.shellRenderMode});

  static const contentKey = Key('sc324_tax_report_center_content');

  static const generateButtonKey = Key('sc324_generate_tax_report');

  static const includeArenaKey = Key('sc324_include_arena_toggle');

  static Key tabKey(TaxReportTab tab) => Key('sc324_tab_${tab.name}');

  static Key formatKey(TaxExportFormat format) =>
      Key('sc324_format_${format.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TaxReportCenter> createState() => _TaxReportCenterState();
}
