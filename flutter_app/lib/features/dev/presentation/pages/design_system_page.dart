import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/dev_tools_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/design_system_color_section.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/design_system_cta_section.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/design_system_footer.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/design_system_hero.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/design_system_input_section.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/design_system_playground.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/design_system_section_header_section.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/design_system_tokens_section.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class DesignSystemPage extends ConsumerStatefulWidget {
  const DesignSystemPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc399_design_system_content');
  static const heroKey = Key('sc399_design_system_hero');
  static const tokensKey = Key('sc399_design_system_tokens');
  static const colorsKey = Key('sc399_design_system_colors');
  static const ctaKey = Key('sc399_design_system_cta');
  static const inputKey = Key('sc399_design_system_input');
  static const sectionsKey = Key('sc399_design_system_sections');
  static const playgroundKey = Key('sc399_design_system_playground');
  static Key swatchKey(String id) => Key('sc399_swatch_$id');
  static Key ctaDemoKey(String id) => Key('sc399_cta_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DesignSystemPage> createState() => _DesignSystemPageState();
}

class _DesignSystemPageState extends ConsumerState<DesignSystemPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController(text: 'password');
  final _searchController = TextEditingController();
  final _errorController = TextEditingController(text: 'abc');
  final _playgroundInputController = TextEditingController();
  final _playgroundLabelController = TextEditingController(text: 'Mua BTC');
  final _playgroundErrorController = TextEditingController();

  String _playgroundVariant = 'primary';
  String _playgroundLabel = 'Mua BTC';
  bool _playgroundDisabled = false;
  bool _playgroundLoading = false;
  bool _playgroundFullWidth = true;
  bool _inputPrefix = true;
  bool _inputSuffix = false;
  String _inputError = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _searchController.dispose();
    _errorController.dispose();
    _playgroundInputController.dispose();
    _playgroundLabelController.dispose();
    _playgroundErrorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(designSystemControllerProvider).snapshot();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-399 DesignSystemPage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: DesignSystemPage.contentKey,
                  physics: const ClampingScrollPhysics(),
                  padding: AppSpacing.devScrollPadding(bottomInset),
                  child: VitPageContent(
                    gap: VitContentGap.loose,
                    children: [
                      VitCard(
                        radius: VitCardRadius.lg,
                        padding: AppSpacing.zeroInsets,
                        clip: true,
                        child: DesignSystemHero(
                          key: DesignSystemPage.heroKey,
                          snapshot: snapshot,
                        ),
                      ),
                      VitCard(
                        radius: VitCardRadius.lg,
                        padding: AppSpacing.zeroInsets,
                        clip: true,
                        child: DesignSystemTokensSection(
                          sectionKey: DesignSystemPage.tokensKey,
                          tokens: snapshot.tokens,
                        ),
                      ),
                      VitCard(
                        radius: VitCardRadius.lg,
                        padding: AppSpacing.zeroInsets,
                        clip: true,
                        child: DesignSystemColorSection(
                          sectionKey: DesignSystemPage.colorsKey,
                          swatchKey: DesignSystemPage.swatchKey,
                          swatches: snapshot.swatches,
                        ),
                      ),
                      DesignSystemCtaSection(
                        sectionKey: DesignSystemPage.ctaKey,
                        ctaDemoKey: DesignSystemPage.ctaDemoKey,
                        demos: snapshot.ctaDemos,
                      ),
                      DesignSystemInputSection(
                        sectionKey: DesignSystemPage.inputKey,
                        demos: snapshot.inputDemos,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        searchController: _searchController,
                        errorController: _errorController,
                      ),
                      DesignSystemSectionHeaderSection(
                        sectionKey: DesignSystemPage.sectionsKey,
                        demos: snapshot.sectionDemos,
                      ),
                      DesignSystemPlayground(
                        sectionKey: DesignSystemPage.playgroundKey,
                        label: _playgroundLabel,
                        variant: _playgroundVariant,
                        disabled: _playgroundDisabled,
                        loading: _playgroundLoading,
                        fullWidth: _playgroundFullWidth,
                        inputPrefix: _inputPrefix,
                        inputSuffix: _inputSuffix,
                        inputError: _inputError,
                        inputController: _playgroundInputController,
                        labelController: _playgroundLabelController,
                        errorController: _playgroundErrorController,
                        onVariantChanged: (variant) {
                          HapticFeedback.selectionClick();
                          setState(() => _playgroundVariant = variant);
                        },
                        onLabelChanged: (label) {
                          setState(() => _playgroundLabel = label);
                        },
                        onToggleDisabled: () {
                          HapticFeedback.selectionClick();
                          setState(
                            () => _playgroundDisabled = !_playgroundDisabled,
                          );
                        },
                        onToggleLoading: () {
                          HapticFeedback.selectionClick();
                          setState(
                            () => _playgroundLoading = !_playgroundLoading,
                          );
                        },
                        onToggleFullWidth: () {
                          HapticFeedback.selectionClick();
                          setState(
                            () => _playgroundFullWidth = !_playgroundFullWidth,
                          );
                        },
                        onTogglePrefix: () {
                          HapticFeedback.selectionClick();
                          setState(() => _inputPrefix = !_inputPrefix);
                        },
                        onToggleSuffix: () {
                          HapticFeedback.selectionClick();
                          setState(() => _inputSuffix = !_inputSuffix);
                        },
                        onErrorChanged: (value) =>
                            setState(() => _inputError = value),
                      ),
                      DesignSystemFooter(snapshot: snapshot),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
