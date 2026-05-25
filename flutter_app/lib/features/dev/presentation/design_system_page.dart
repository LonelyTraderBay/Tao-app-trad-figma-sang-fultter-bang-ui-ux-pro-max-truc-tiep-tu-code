import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/dev_tools_repository.dart';

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
    final snapshot = ref
        .watch(designSystemRepositoryProvider)
        .getDesignSystem();
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
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: DesignSystemPage.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  gap: VitContentGap.loose,
                  children: [
                    _Hero(snapshot: snapshot),
                    _TokensSection(tokens: snapshot.tokens),
                    _ColorSection(swatches: snapshot.swatches),
                    _CtaSection(demos: snapshot.ctaDemos),
                    _InputSection(
                      demos: snapshot.inputDemos,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      searchController: _searchController,
                      errorController: _errorController,
                    ),
                    _SectionHeaderSection(demos: snapshot.sectionDemos),
                    _PlaygroundSection(
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
                    _Footer(snapshot: snapshot),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.snapshot});

  final DesignSystemSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: DesignSystemPage.heroKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Stack(
        children: [
          Positioned(
            top: -AppSpacing.x6,
            right: -AppSpacing.x6,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.accent15,
                shape: BoxShape.circle,
              ),
              child: SizedBox(
                width: AppSpacing.buttonHero + AppSpacing.x6,
                height: AppSpacing.buttonHero + AppSpacing.x6,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snapshot.heroEyebrow.toUpperCase(),
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.primary,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                snapshot.heroTitle,
                style: AppTextStyles.sectionTitle.copyWith(fontSize: 22),
              ),
              const SizedBox(height: AppSpacing.x3),
              Text(
                snapshot.heroDescription,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TokensSection extends StatelessWidget {
  const _TokensSection({required this.tokens});

  final List<DesignTokenDraft> tokens;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: DesignSystemPage.tokensKey,
      label: 'Design Tokens',
      children: [
        VitCard(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x3,
          ),
          radius: VitCardRadius.lg,
          child: Column(
            children: [
              for (final token in tokens) ...[
                _TokenRow(token: token),
                if (token != tokens.last) const _Divider(),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ColorSection extends StatelessWidget {
  const _ColorSection({required this.swatches});

  final List<DesignSwatchDraft> swatches;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: DesignSystemPage.colorsKey,
      label: 'Color Palette',
      children: [
        Wrap(
          spacing: AppSpacing.x5,
          runSpacing: AppSpacing.x5,
          children: [
            for (final swatch in swatches)
              _Swatch(
                key: DesignSystemPage.swatchKey(swatch.id),
                swatch: swatch,
              ),
          ],
        ),
      ],
    );
  }
}

class _CtaSection extends StatelessWidget {
  const _CtaSection({required this.demos});

  final List<DesignCtaDemoDraft> demos;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: DesignSystemPage.ctaKey,
      label: 'CTAButton Component',
      children: [
        for (final demo in demos) _CtaDemo(demo: demo),
        Row(
          children: [
            Expanded(
              child: VitCtaButton(
                variant: VitCtaButtonVariant.success,
                onPressed: () {},
                child: const Text('Mua'),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitCtaButton(
                variant: VitCtaButtonVariant.danger,
                onPressed: () {},
                child: const Text('Bán'),
              ),
            ),
          ],
        ),
        VitCtaButton(
          variant: VitCtaButtonVariant.primary,
          leading: const Icon(Icons.bolt_rounded),
          onPressed: () {},
          child: const Text('Launchpad Subscribe'),
        ),
      ],
    );
  }
}

class _InputSection extends StatelessWidget {
  const _InputSection({
    required this.demos,
    required this.emailController,
    required this.passwordController,
    required this.searchController,
    required this.errorController,
  });

  final List<DesignInputDemoDraft> demos;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController searchController;
  final TextEditingController errorController;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: DesignSystemPage.inputKey,
      label: 'InputField Component',
      children: [
        for (final demo in demos)
          _InputDemo(
            demo: demo,
            controller: switch (demo.id) {
              'password' => passwordController,
              'search' => searchController,
              'error' => errorController,
              _ => emailController,
            },
          ),
        const _InputWrapperDemo(
          caption: 'InputWrapper (dropdown-like)',
          label: 'Chọn mạng',
          value: 'BEP-20 (BSC)',
          icon: Icons.shield_outlined,
        ),
        const _InputWrapperDemo(
          caption: 'InputWrapper with error',
          label: 'Chọn phương thức thanh toán',
          value: 'Chọn...',
          error: 'Vui lòng chọn phương thức thanh toán',
        ),
      ],
    );
  }
}

class _SectionHeaderSection extends StatelessWidget {
  const _SectionHeaderSection({required this.demos});

  final List<DesignSectionDemoDraft> demos;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: DesignSystemPage.sectionsKey,
      label: 'SectionHeader Component',
      children: [
        for (final demo in demos)
          VitCard(
            padding: const EdgeInsets.all(AppSpacing.x4),
            radius: VitCardRadius.lg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: AppSpacing.x1,
                      height: AppSpacing.iconMd,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: AppRadii.xsRadius,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(demo.title, style: AppTextStyles.baseMedium),
                          if (demo.subtitle != null)
                            Text(
                              demo.subtitle!,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (demo.badge != null) _PositiveBadge(label: demo.badge!),
                  ],
                ),
                const SizedBox(height: AppSpacing.x3),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: SizedBox(height: AppSpacing.x6),
                ),
              ],
            ),
          ),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          radius: VitCardRadius.lg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _AccentSample(label: 'Mua (Buy)', color: AppColors.buy),
              _AccentSample(label: 'Bán (Sell)', color: AppColors.sell),
              _AccentSample(label: 'Cảnh báo', color: AppColors.warn),
              _AccentSample(label: 'Premium', color: AppColors.accent),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlaygroundSection extends StatelessWidget {
  const _PlaygroundSection({
    required this.label,
    required this.variant,
    required this.disabled,
    required this.loading,
    required this.fullWidth,
    required this.inputPrefix,
    required this.inputSuffix,
    required this.inputError,
    required this.inputController,
    required this.labelController,
    required this.errorController,
    required this.onVariantChanged,
    required this.onLabelChanged,
    required this.onToggleDisabled,
    required this.onToggleLoading,
    required this.onToggleFullWidth,
    required this.onTogglePrefix,
    required this.onToggleSuffix,
    required this.onErrorChanged,
  });

  final String label;
  final String variant;
  final bool disabled;
  final bool loading;
  final bool fullWidth;
  final bool inputPrefix;
  final bool inputSuffix;
  final String inputError;
  final TextEditingController inputController;
  final TextEditingController labelController;
  final TextEditingController errorController;
  final ValueChanged<String> onVariantChanged;
  final ValueChanged<String> onLabelChanged;
  final VoidCallback onToggleDisabled;
  final VoidCallback onToggleLoading;
  final VoidCallback onToggleFullWidth;
  final VoidCallback onTogglePrefix;
  final VoidCallback onToggleSuffix;
  final ValueChanged<String> onErrorChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: DesignSystemPage.playgroundKey,
      label: 'Interactive Playground',
      children: [
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          radius: VitCardRadius.lg,
          borderColor: AppColors.primary20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PlaygroundTitle(
                icon: Icons.bolt_rounded,
                title: 'CTAButton Playground',
                color: AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.x4),
              VitCard(
                variant: VitCardVariant.inner,
                padding: const EdgeInsets.all(AppSpacing.x5),
                child: Center(
                  child: VitCtaButton(
                    variant: _variantFromString(variant),
                    fullWidth: fullWidth,
                    loading: loading,
                    onPressed: disabled ? null : () {},
                    child: Text(label.isEmpty ? 'Button' : label),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              _SegmentControls(
                label: 'variant',
                options: const ['primary', 'success', 'danger', 'ghost'],
                selected: variant,
                onChanged: onVariantChanged,
              ),
              const SizedBox(height: AppSpacing.x3),
              VitInput(
                controller: labelController,
                label: 'children (text)',
                onChanged: onLabelChanged,
              ),
              const SizedBox(height: AppSpacing.x3),
              Wrap(
                spacing: AppSpacing.x3,
                runSpacing: AppSpacing.x3,
                children: [
                  _ToggleChip(
                    label: 'disabled',
                    active: disabled,
                    onTap: onToggleDisabled,
                  ),
                  _ToggleChip(
                    label: 'loading',
                    active: loading,
                    onTap: onToggleLoading,
                  ),
                  _ToggleChip(
                    label: 'fullWidth',
                    active: fullWidth,
                    onTap: onToggleFullWidth,
                  ),
                ],
              ),
            ],
          ),
        ),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          radius: VitCardRadius.lg,
          borderColor: AppColors.buy20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PlaygroundTitle(
                icon: Icons.trending_up_rounded,
                title: 'InputField Playground',
                color: AppColors.buy,
              ),
              const SizedBox(height: AppSpacing.x4),
              VitCard(
                variant: VitCardVariant.inner,
                padding: const EdgeInsets.all(AppSpacing.x5),
                child: VitInput(
                  controller: inputController,
                  label: 'Email',
                  hintText: 'you@example.com',
                  prefix: inputPrefix
                      ? const Icon(Icons.mail_outline_rounded)
                      : null,
                  suffix: inputSuffix
                      ? const Icon(
                          Icons.check_circle_outline_rounded,
                          color: AppColors.buy,
                        )
                      : null,
                  errorText: inputError.isEmpty ? null : inputError,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              VitInput(
                controller: errorController,
                label: 'error',
                hintText: 'Leave empty for no error',
                onChanged: onErrorChanged,
              ),
              const SizedBox(height: AppSpacing.x3),
              Wrap(
                spacing: AppSpacing.x3,
                runSpacing: AppSpacing.x3,
                children: [
                  _ToggleChip(
                    label: 'prefix (Mail)',
                    active: inputPrefix,
                    onTap: onTogglePrefix,
                    color: AppColors.buy,
                  ),
                  _ToggleChip(
                    label: 'suffix (Check)',
                    active: inputSuffix,
                    onTap: onToggleSuffix,
                    color: AppColors.buy,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TokenRow extends StatelessWidget {
  const _TokenRow({required this.token});

  final DesignTokenDraft token;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              token.label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          Text(
            token.value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({super.key, required this.swatch});

  final DesignSwatchDraft swatch;

  @override
  Widget build(BuildContext context) {
    final color = _colorForSwatch(swatch.id);

    return SizedBox(
      width: AppSpacing.x7,
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadii.cardRadius,
              border: Border.all(color: AppColors.borderSolid),
            ),
            child: const SizedBox(
              width: AppSpacing.buttonStandard,
              height: AppSpacing.buttonStandard,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            swatch.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
          Text(
            swatch.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _CtaDemo extends StatelessWidget {
  const _CtaDemo({required this.demo});

  final DesignCtaDemoDraft demo;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: DesignSystemPage.ctaDemoKey(demo.id),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Caption('variant="${demo.variant}"'),
        const SizedBox(height: AppSpacing.x2),
        VitCtaButton(
          variant: _variantFromString(demo.variant),
          loading: demo.loading,
          onPressed: demo.disabled ? null : () {},
          leading: _leadingForCta(demo.id),
          child: Text(demo.label),
        ),
      ],
    );
  }
}

class _InputDemo extends StatelessWidget {
  const _InputDemo({required this.demo, required this.controller});

  final DesignInputDemoDraft demo;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Caption(demo.caption),
        const SizedBox(height: AppSpacing.x2),
        VitInput(
          controller: controller,
          label: demo.label.isEmpty ? null : demo.label,
          hintText: demo.placeholder,
          errorText: demo.error,
          obscureText: demo.obscure,
          prefix: demo.prefix ? _prefixForInput(demo.id) : null,
          suffix: demo.suffix ? _suffixForInput(demo.id) : null,
        ),
      ],
    );
  }
}

class _InputWrapperDemo extends StatelessWidget {
  const _InputWrapperDemo({
    required this.caption,
    required this.label,
    required this.value,
    this.icon,
    this.error,
  });

  final String caption;
  final String label;
  final String value;
  final IconData? icon;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final hasError = error != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Caption(caption),
        const SizedBox(height: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x2),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: AppRadii.inputRadius,
            border: Border.all(
              color: hasError ? AppColors.sell : AppColors.borderSolid,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x4,
              vertical: AppSpacing.x4,
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: AppColors.primary, size: AppSpacing.iconMd),
                  const SizedBox(width: AppSpacing.x3),
                ],
                Expanded(
                  child: Text(
                    value,
                    style: AppTextStyles.body.copyWith(
                      color: hasError ? AppColors.text3 : AppColors.text1,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconMd,
                ),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.x2),
          Text(
            error!,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.sell,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}

class _PlaygroundTitle extends StatelessWidget {
  const _PlaygroundTitle({
    required this.icon,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: AppSpacing.iconMd),
        const SizedBox(width: AppSpacing.x2),
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _SegmentControls extends StatelessWidget {
  const _SegmentControls({
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final String label;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Caption(label),
        const SizedBox(height: AppSpacing.x2),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            for (final option in options)
              _ChoiceChip(
                label: option,
                selected: selected == option,
                onTap: () => onChanged(option),
              ),
          ],
        ),
      ],
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? AppColors.primary12 : AppColors.surface2,
          borderRadius: AppRadii.smRadius,
          border: Border.all(
            color: selected ? AppColors.primary20 : AppColors.borderSolid,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: selected ? AppColors.primary : AppColors.text2,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ),
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    required this.label,
    required this.active,
    required this.onTap,
    this.color = AppColors.primary,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final background = color == AppColors.buy
        ? AppColors.buy15
        : AppColors.primary12;
    final border = color == AppColors.buy
        ? AppColors.buy20
        : AppColors.primary20;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: active ? background : AppColors.surface2,
          borderRadius: AppRadii.smRadius,
          border: Border.all(color: active ? border : AppColors.borderSolid),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                active
                    ? Icons.check_box_rounded
                    : Icons.check_box_outline_blank,
                color: active ? color : AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: active ? color : AppColors.text3,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Caption extends StatelessWidget {
  const _Caption(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        fontWeight: AppTextStyles.medium,
      ),
    );
  }
}

class _PositiveBadge extends StatelessWidget {
  const _PositiveBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.buy15,
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _AccentSample extends StatelessWidget {
  const _AccentSample({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x3),
      child: Row(
        children: [
          Container(
            width: AppSpacing.x1,
            height: AppSpacing.iconSm,
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadii.xsRadius,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.snapshot});

  final DesignSystemSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x5),
        child: Column(
          children: [
            Text(
              snapshot.footerTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              snapshot.footerSubtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: AppColors.divider);
  }
}

VitCtaButtonVariant _variantFromString(String variant) {
  return switch (variant) {
    'success' => VitCtaButtonVariant.success,
    'danger' => VitCtaButtonVariant.danger,
    'ghost' => VitCtaButtonVariant.ghost,
    _ => VitCtaButtonVariant.primary,
  };
}

Widget? _leadingForCta(String id) {
  return switch (id) {
    'success' => const Icon(Icons.check_circle_outline_rounded),
    'danger' => const Icon(Icons.warning_amber_rounded),
    'ghost' => const Icon(Icons.account_balance_wallet_outlined),
    _ => null,
  };
}

Widget? _prefixForInput(String id) {
  return switch (id) {
    'password' => const Icon(Icons.lock_outline_rounded),
    'search' => const Icon(Icons.search_rounded),
    _ => const Icon(Icons.mail_outline_rounded),
  };
}

Widget? _suffixForInput(String id) {
  return switch (id) {
    'password' => const Icon(Icons.visibility_outlined, color: AppColors.text3),
    _ => const Icon(Icons.check_circle_outline_rounded, color: AppColors.buy),
  };
}

Color _colorForSwatch(String id) {
  return switch (id) {
    'success' || 'buy' => AppColors.buy,
    'danger' || 'sell' => AppColors.sell,
    'warning' => AppColors.warn,
    'accent' => AppColors.accent,
    'bg' => AppColors.bg,
    'card' => AppColors.cardBg,
    'input' => AppColors.surface2,
    'border' => AppColors.borderSolid,
    'text' => AppColors.text1,
    'label' => AppColors.text2,
    'muted' => AppColors.text3,
    _ => AppColors.primary,
  };
}
