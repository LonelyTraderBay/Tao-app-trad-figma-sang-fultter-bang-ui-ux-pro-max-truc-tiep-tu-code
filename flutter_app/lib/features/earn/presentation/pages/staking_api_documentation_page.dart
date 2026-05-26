import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/earn/data/earn_repository.dart';

enum _ApiTab { endpoints, examples, auth }

class StakingApiDocumentationPage extends ConsumerStatefulWidget {
  const StakingApiDocumentationPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc379_info');
  static const statsKey = Key('sc379_stats');
  static const tabsKey = Key('sc379_tabs');
  static const endpointsKey = Key('sc379_endpoints');
  static const detailKey = Key('sc379_detail');
  static const examplesKey = Key('sc379_examples');
  static const authKey = Key('sc379_auth');
  static const footerKey = Key('sc379_footer');
  static const copyResponseKey = Key('sc379_copy_response');
  static const copyExampleKey = Key('sc379_copy_example');
  static const sandboxKey = Key('sc379_sandbox');

  static Key tabKey(String id) => Key('sc379_tab_$id');

  static Key endpointKey(String method, String path) =>
      Key('sc379_endpoint_${method}_$path');

  static Key languageKey(String id) => Key('sc379_language_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingApiDocumentationPage> createState() =>
      _StakingApiDocumentationPageState();
}

class _StakingApiDocumentationPageState
    extends ConsumerState<StakingApiDocumentationPage> {
  late _ApiTab _tab;
  late String _language;
  int _selectedEndpoint = 0;
  bool _responseCopied = false;
  bool _exampleCopied = false;

  @override
  void initState() {
    super.initState();
    final snapshot = ref
        .read(stakingApiDocumentationRepositoryProvider)
        .getDocumentation();
    _tab = _tabFromId(snapshot.defaultTab);
    _language = snapshot.defaultLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingApiDocumentationRepositoryProvider)
        .getDocumentation();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-379 StakingAPIDocumentationPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _InfoBanner(snapshot: snapshot),
                    _QuickStats(stats: snapshot.stats),
                    _ApiTabs(
                      active: _tab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _tab = tab);
                      },
                    ),
                    if (_tab == _ApiTab.endpoints)
                      _EndpointsTab(
                        snapshot: snapshot,
                        selectedIndex: _selectedEndpoint,
                        responseCopied: _responseCopied,
                        onSelect: (index) {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _selectedEndpoint = index;
                            _responseCopied = false;
                          });
                        },
                        onCopyResponse: () {
                          _copy(
                            snapshot.endpoints[_selectedEndpoint].responseJson,
                          );
                          setState(() => _responseCopied = true);
                        },
                      )
                    else if (_tab == _ApiTab.examples)
                      _ExamplesTab(
                        snapshot: snapshot,
                        language: _language,
                        copied: _exampleCopied,
                        onLanguageChanged: (language) {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _language = language;
                            _exampleCopied = false;
                          });
                        },
                        onCopy: (source) {
                          _copy(source);
                          setState(() => _exampleCopied = true);
                        },
                      )
                    else
                      _AuthTab(snapshot: snapshot),
                    _FooterNote(note: snapshot.footerNote),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingApiDocumentationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingApiDocumentationPage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.code_rounded,
            color: AppColors.primarySoft,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.infoTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  const _QuickStats({required this.stats});

  final List<StakingApiStatDraft> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: StakingApiDocumentationPage.statsKey,
      children: [
        for (final stat in stats) ...[
          Expanded(child: _StatCard(stat: stat)),
          if (stat != stats.last) const SizedBox(width: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final StakingApiStatDraft stat;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(stat.tone);
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: SizedBox(
        height: 66,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(_statIcon(stat.tone), color: color, size: AppSpacing.iconSm),
            const Spacer(),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                stat.value,
                style: AppTextStyles.sectionTitle.copyWith(
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              stat.label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApiTabs extends StatelessWidget {
  const _ApiTabs({required this.active, required this.onChanged});

  final _ApiTab active;
  final ValueChanged<_ApiTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: StakingApiDocumentationPage.tabsKey,
      decoration: const BoxDecoration(color: AppColors.surface),
      child: Row(
        children: [
          for (final tab in _ApiTab.values)
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  key: StakingApiDocumentationPage.tabKey(tab.name),
                  onTap: () => onChanged(tab),
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.x4),
                    child: Column(
                      children: [
                        Text(
                          _tabLabel(tab),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: active == tab
                                ? AppColors.primarySoft
                                : AppColors.text3,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          width: active == tab ? AppSpacing.buttonHero : 0,
                          height: 2,
                          decoration: BoxDecoration(
                            color: active == tab
                                ? AppColors.primarySoft
                                : Colors.transparent,
                            borderRadius: AppRadii.xsRadius,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EndpointsTab extends StatelessWidget {
  const _EndpointsTab({
    required this.snapshot,
    required this.selectedIndex,
    required this.responseCopied,
    required this.onSelect,
    required this.onCopyResponse,
  });

  final StakingApiDocumentationSnapshot snapshot;
  final int selectedIndex;
  final bool responseCopied;
  final ValueChanged<int> onSelect;
  final VoidCallback onCopyResponse;

  @override
  Widget build(BuildContext context) {
    final selected = snapshot.endpoints[selectedIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          key: StakingApiDocumentationPage.endpointsKey,
          label: 'API Endpoints',
          accentColor: AppColors.primarySoft,
          children: [
            for (var i = 0; i < snapshot.endpoints.length; i++)
              _EndpointSummaryCard(
                endpoint: snapshot.endpoints[i],
                selected: i == selectedIndex,
                onTap: () => onSelect(i),
              ),
          ],
        ),
        VitPageSection(
          key: StakingApiDocumentationPage.detailKey,
          label: 'Endpoint Detail',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      _MethodBadge(method: selected.method),
                      const SizedBox(width: AppSpacing.x2),
                      Expanded(
                        child: Text(
                          selected.path,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Text(
                    selected.description,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Text('Parameters', style: AppTextStyles.caption),
                  const SizedBox(height: AppSpacing.x2),
                  for (final param in selected.params) ...[
                    _ParameterCard(param: param),
                    if (param != selected.params.last)
                      const SizedBox(height: AppSpacing.x2),
                  ],
                  const SizedBox(height: AppSpacing.x4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Response Example',
                          style: AppTextStyles.caption,
                        ),
                      ),
                      _CopyButton(
                        key: StakingApiDocumentationPage.copyResponseKey,
                        copied: responseCopied,
                        onTap: onCopyResponse,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  _CodeBlock(text: selected.responseJson),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EndpointSummaryCard extends StatelessWidget {
  const _EndpointSummaryCard({
    required this.endpoint,
    required this.selected,
    required this.onTap,
  });

  final StakingApiEndpointDraft endpoint;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingApiDocumentationPage.endpointKey(
        endpoint.method,
        endpoint.path,
      ),
      onTap: onTap,
      borderColor: selected ? AppColors.primary : null,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _MethodBadge(method: endpoint.method),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  endpoint.path,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            endpoint.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ParameterCard extends StatelessWidget {
  const _ParameterCard({required this.param});

  final StakingApiParameterDraft param;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x1,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                param.name,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                param.type,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              if (param.required)
                const _StatusPill(label: 'required', color: AppColors.sell),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            param.description,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ExamplesTab extends StatelessWidget {
  const _ExamplesTab({
    required this.snapshot,
    required this.language,
    required this.copied,
    required this.onLanguageChanged,
    required this.onCopy,
  });

  final StakingApiDocumentationSnapshot snapshot;
  final String language;
  final bool copied;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    final selected = snapshot.codeExamples.firstWhere(
      (item) => item.language == language,
      orElse: () => snapshot.codeExamples.first,
    );
    return Column(
      key: StakingApiDocumentationPage.examplesKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            for (final example in snapshot.codeExamples)
              _LanguageButton(
                example: example,
                selected: example.language == selected.language,
                onTap: () => onLanguageChanged(example.language),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        VitPageSection(
          label: 'Code Examples',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.x3),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Create Stake Position',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        _CopyButton(
                          key: StakingApiDocumentationPage.copyExampleKey,
                          copied: copied,
                          onTap: () => onCopy(selected.source),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: AppColors.borderSolid, height: 1),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.x3),
                    child: _CodeBlock(text: selected.source, tall: true),
                  ),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          key: StakingApiDocumentationPage.sandboxKey,
          label: 'Try in Sandbox',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: AppSpacing.buttonHero,
                        height: AppSpacing.buttonHero,
                        decoration: BoxDecoration(
                          color: AppColors.warn.withValues(alpha: 0.12),
                          borderRadius: AppRadii.lgRadius,
                        ),
                        child: const Icon(
                          Icons.bolt_rounded,
                          color: AppColors.warn,
                          size: AppSpacing.iconMd,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sandbox Environment',
                              style: AppTextStyles.baseMedium,
                            ),
                            const SizedBox(height: AppSpacing.x2),
                            Text(
                              'Test your integration with fake data before going live. No real funds involved.',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  VitCard(
                    variant: VitCardVariant.inner,
                    padding: const EdgeInsets.all(AppSpacing.x3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sandbox Base URL',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                snapshot.sandboxBaseUrl,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.micro.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.content_copy_rounded,
                              color: AppColors.text3,
                              size: AppSpacing.iconSm,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  SizedBox(
                    height: AppSpacing.ctaHeight,
                    child: FilledButton(
                      onPressed: () {},
                      child: const Text('Get Sandbox API Key'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({
    required this.example,
    required this.selected,
    required this.onTap,
  });

  final StakingApiCodeExampleDraft example;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.surface2,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        key: StakingApiDocumentationPage.languageKey(example.language),
        borderRadius: AppRadii.inputRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          child: Text(
            example.label,
            style: AppTextStyles.caption.copyWith(
              color: selected ? Colors.white : AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthTab extends StatelessWidget {
  const _AuthTab({required this.snapshot});

  final StakingApiDocumentationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingApiDocumentationPage.authKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Authentication',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.key_rounded,
                        color: AppColors.primarySoft,
                        size: AppSpacing.iconMd,
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'API Key Authentication',
                              style: AppTextStyles.baseMedium,
                            ),
                            const SizedBox(height: AppSpacing.x2),
                            Text(
                              'Include your API key in the X-API-Key header with every request.',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  _CodeBlock(text: snapshot.authHeaderExample),
                  const SizedBox(height: AppSpacing.x3),
                  SizedBox(
                    height: AppSpacing.ctaHeight,
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Generate API Key in Settings ->'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          label: 'Rate Limits',
          accentColor: AppColors.primarySoft,
          children: [
            for (final tier in snapshot.rateLimits) _RateLimitCard(tier: tier),
          ],
        ),
        VitPageSection(
          label: 'Error Codes',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                children: [
                  for (final error in snapshot.errorCodes) ...[
                    _ErrorCodeRow(error: error),
                    if (error != snapshot.errorCodes.last)
                      const SizedBox(height: AppSpacing.x2),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RateLimitCard extends StatelessWidget {
  const _RateLimitCard({required this.tier});

  final StakingApiRateLimitDraft tier;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      borderColor: tier.recommended ? AppColors.primary : null,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tier.tier, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      tier.price,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              if (tier.recommended)
                const _StatusPill(
                  label: 'Recommended',
                  color: AppColors.primarySoft,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          VitCard(
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatInt(tier.requests),
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.x1),
                      child: Text(
                        'requests',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'per ${tier.window}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          if (tier.tier == 'Enterprise') ...[
            const SizedBox(height: AppSpacing.x3),
            SizedBox(
              height: AppSpacing.ctaHeight,
              child: FilledButton(
                onPressed: () {},
                child: const Text('Contact Sales'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ErrorCodeRow extends StatelessWidget {
  const _ErrorCodeRow({required this.error});

  final StakingApiErrorCodeDraft error;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatusPill(label: error.code.toString(), color: AppColors.sell),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              error.message,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodBadge extends StatelessWidget {
  const _MethodBadge({required this.method});

  final String method;

  @override
  Widget build(BuildContext context) {
    final color = method == 'POST' ? AppColors.buy : AppColors.primarySoft;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        method,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({super.key, required this.copied, required this.onTap});

  final bool copied;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: copied
          ? AppColors.buy.withValues(alpha: 0.12)
          : AppColors.surface2,
      borderRadius: AppRadii.smRadius,
      child: InkWell(
        borderRadius: AppRadii.smRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x2,
            vertical: AppSpacing.x1,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                copied
                    ? Icons.check_circle_outline_rounded
                    : Icons.content_copy_rounded,
                color: copied ? AppColors.buy : AppColors.text3,
                size: 12,
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                copied ? 'Copied' : 'Copy',
                style: AppTextStyles.micro.copyWith(
                  color: copied ? AppColors.buy : AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.text, this.tall = false});

  final String text;
  final bool tall;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.surface3,
        borderRadius: AppRadii.inputRadius,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          text,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            height: tall ? 1.65 : 1.5,
          ),
        ),
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingApiDocumentationPage.footerKey,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        note,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: 1.55,
        ),
      ),
    );
  }
}

_ApiTab _tabFromId(String id) {
  return switch (id) {
    'examples' => _ApiTab.examples,
    'auth' => _ApiTab.auth,
    _ => _ApiTab.endpoints,
  };
}

String _tabLabel(_ApiTab tab) {
  return switch (tab) {
    _ApiTab.endpoints => 'Endpoints',
    _ApiTab.examples => 'Examples',
    _ApiTab.auth => 'Auth & Limits',
  };
}

Color _toneColor(String tone) {
  return switch (tone) {
    'warn' => AppColors.warn,
    'buy' => AppColors.buy,
    _ => AppColors.primarySoft,
  };
}

IconData _statIcon(String tone) {
  return switch (tone) {
    'warn' => Icons.bolt_rounded,
    'buy' => Icons.shield_outlined,
    _ => Icons.key_rounded,
  };
}

String _formatInt(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    if (i > 0 && (raw.length - i) % 3 == 0) buffer.write(',');
    buffer.write(raw[i]);
  }
  return buffer.toString();
}
