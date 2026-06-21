import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/arena_viewport_padding.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';

part 'arena_guide_page_part_01.dart';
part 'arena_guide_page_part_02.dart';
part 'arena_guide_page_part_03.dart';

enum _GuideTab { guide, tips, safety, faq }

enum _GuideMode { create, join }

final double _guideActionExtent = VitDensity.compact.controlHeight;
const _guideAccordionBodyLineRatio =
    AppSpacing.arenaGuideAccordionBodyLineHeight;
const _guideChecklistLineRatio = AppSpacing.arenaGuideChecklistLineHeight;
const _guideSmallBadgeLineRatio = AppSpacing.arenaGuideSmallBadgeLineHeight;
const _guideStepBodyLineRatio = AppSpacing.arenaGuideStepBodyLineHeight;

class ArenaGuidePage extends ConsumerStatefulWidget {
  const ArenaGuidePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc209_arena_guide_content');
  static const modeCreateKey = Key('sc209_mode_create');
  static const modeJoinKey = Key('sc209_mode_join');
  static const ctaKey = Key('sc209_primary_cta');
  static const safetyCenterKey = Key('sc209_safety_center');
  static const supportKey = Key('sc209_support');

  static Key tabKey(String id) => Key('sc209_tab_$id');
  static Key tipKey(String id) => Key('sc209_tip_$id');
  static Key faqKey(String id) => Key('sc209_faq_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaGuidePage> createState() => _ArenaGuidePageState();
}
