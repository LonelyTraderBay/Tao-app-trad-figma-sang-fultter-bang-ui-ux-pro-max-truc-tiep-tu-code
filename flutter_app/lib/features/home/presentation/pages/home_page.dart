import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/home_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'home_page_part_01.dart';
part 'home_page_part_02.dart';
part 'home_page_part_03.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc007_home_scroll_content');
  static const headerKey = Key('sc007_home_header');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}
