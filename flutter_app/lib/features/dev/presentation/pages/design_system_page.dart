import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/dev_tools_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
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
import 'package:vit_trade_flutter/app/theme/spacing/admin_spacing_tokens.dart';

enum _DevUiMode { live, loading, empty, error, offline }

class DesignSystemPage extends ConsumerStatefulWidget {
  const DesignSystemPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc399_design_system_content');
  static const statesKey = Key('sc399_design_system_states');
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
  _DevUiMode _uiMode = _DevUiMode.live;

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
        type: MaterialType.transparency,
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
                  padding: AdminSpacingTokens.devScrollPadding(bottomInset),
                  child: VitPageContent(
                    rhythm: VitPageRhythm.flush,
                    gap: VitContentGap.loose,
                    children: [
                      _DevStateBar(
                        key: DesignSystemPage.statesKey,
                        supportedStates: snapshot.supportedStates,
                        active: _uiMode,
                        onChanged: (mode) {
                          HapticFeedback.selectionClick();
                          setState(() => _uiMode = mode);
                        },
                      ),
                      switch (_uiMode) {
                        _DevUiMode.loading => const _DesignSystemLoading(),
                        _DevUiMode.empty => const VitEmptyState(
                          title: 'Design tokens unavailable',
                          message:
                              'Token registry is empty. Reload when the dev catalog syncs.',
                        ),
                        _DevUiMode.error => VitErrorState(
                          title: 'Design system unavailable',
                          message:
                              'Could not load token catalog. Retry when back online.',
                          onAction: () =>
                              setState(() => _uiMode = _DevUiMode.live),
                        ),
                        _DevUiMode.offline => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const VitOfflineBanner(
                              detail: 'Showing cached token reference.',
                            ),
                            const SizedBox(height: AppSpacing.x4),
                            ..._liveSections(snapshot),
                          ],
                        ),
                        _DevUiMode.live => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: _liveSections(snapshot),
                        ),
                      },
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

  List<Widget> _liveSections(DesignSystemSnapshot snapshot) {
    return [
      VitPageSection(
        label: 'Foundation',
        children: [
          VitCard(
            radius: VitCardRadius.large,
            padding: AppSpacing.zeroInsets,
            clip: true,
            child: DesignSystemHero(
              key: DesignSystemPage.heroKey,
              snapshot: snapshot,
            ),
          ),
          VitCard(
            radius: VitCardRadius.large,
            padding: AppSpacing.zeroInsets,
            clip: true,
            child: DesignSystemTokensSection(
              sectionKey: DesignSystemPage.tokensKey,
              tokens: snapshot.tokens,
            ),
          ),
          VitCard(
            radius: VitCardRadius.large,
            padding: AppSpacing.zeroInsets,
            clip: true,
            child: DesignSystemColorSection(
              sectionKey: DesignSystemPage.colorsKey,
              swatchKey: DesignSystemPage.swatchKey,
              swatches: snapshot.swatches,
            ),
          ),
        ],
      ),
      VitPageSection(
        label: 'Components',
        children: [
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
        ],
      ),
      VitPageSection(
        label: 'Playground',
        children: [
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
              setState(() => _playgroundDisabled = !_playgroundDisabled);
            },
            onToggleLoading: () {
              HapticFeedback.selectionClick();
              setState(() => _playgroundLoading = !_playgroundLoading);
            },
            onToggleFullWidth: () {
              HapticFeedback.selectionClick();
              setState(() => _playgroundFullWidth = !_playgroundFullWidth);
            },
            onTogglePrefix: () {
              HapticFeedback.selectionClick();
              setState(() => _inputPrefix = !_inputPrefix);
            },
            onToggleSuffix: () {
              HapticFeedback.selectionClick();
              setState(() => _inputSuffix = !_inputSuffix);
            },
            onErrorChanged: (value) => setState(() => _inputError = value),
          ),
        ],
      ),
      DesignSystemFooter(snapshot: snapshot),
    ];
  }
}

class _DevStateBar extends StatelessWidget {
  const _DevStateBar({
    super.key,
    required this.supportedStates,
    required this.active,
    required this.onChanged,
  });

  final Set<DevScreenState> supportedStates;
  final _DevUiMode active;
  final ValueChanged<_DevUiMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final items = <VitPresetChipItem<_DevUiMode>>[
      const VitPresetChipItem(value: _DevUiMode.live, label: 'Live'),
      if (supportedStates.contains(DevScreenState.loading))
        const VitPresetChipItem(value: _DevUiMode.loading, label: 'Loading'),
      if (supportedStates.contains(DevScreenState.empty))
        const VitPresetChipItem(value: _DevUiMode.empty, label: 'Empty'),
      if (supportedStates.contains(DevScreenState.error))
        const VitPresetChipItem(value: _DevUiMode.error, label: 'Error'),
      if (supportedStates.contains(DevScreenState.offline))
        const VitPresetChipItem(value: _DevUiMode.offline, label: 'Offline'),
    ];

    return VitPageSection(
      label: 'Screen states',
      children: [
        VitPresetChipRow<_DevUiMode>(
          items: items,
          selectedValue: active,
          onTap: onChanged,
          accentColor: AppModuleAccents.dev,
        ),
      ],
    );
  }
}

class _DesignSystemLoading extends StatelessWidget {
  const _DesignSystemLoading();

  @override
  Widget build(BuildContext context) {
    return const VitSkeletonList(rows: 6);
  }
}
