import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/trade_repository.dart';

const _apiBg = Color(0xFF080C14);
const _apiSurface = Color(0xFF151A23);
const _apiSurface2 = Color(0xFF1D2436);
const _apiBlue = Color(0xFF3B82F6);
const _apiGreen = Color(0xFF10B981);
const _apiRed = Color(0xFFEF4444);
const _apiTabBg = Color(0xFF1D2436);

class BotApiDocumentationPage extends ConsumerStatefulWidget {
  const BotApiDocumentationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc134_bot_api_documentation_content');
  static Key tabKey(String id) => Key('sc134_bot_api_tab_$id');
  static Key languageKey(String id) => Key('sc134_bot_api_language_$id');
  static Key endpointKey(String method, String path) =>
      Key('sc134_bot_api_endpoint_${method}_$path');
  static const copyKey = Key('sc134_bot_api_copy');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotApiDocumentationPage> createState() =>
      _BotApiDocumentationPageState();
}

class _BotApiDocumentationPageState
    extends ConsumerState<BotApiDocumentationPage> {
  late String _view;
  late String _language;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    final snapshot = ref.read(tradeRepositoryProvider).getBotApiDocumentation();
    _view = snapshot.defaultView;
    _language = snapshot.defaultLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeRepositoryProvider)
        .getBotApiDocumentation();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-134 BotAPIDocumentationPage',
      child: Material(
        color: _apiBg,
        child: Column(
          children: [
            VitHeader(
              title: 'API Documentation',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeBots),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: BotApiDocumentationPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _IntroCard(),
                    const SizedBox(height: 33),
                    _Tabs(
                      tabs: snapshot.tabs,
                      active: _view,
                      onChanged: (view) => setState(() => _view = view),
                    ),
                    const SizedBox(height: 18),
                    if (_view == 'endpoints')
                      _EndpointsView(endpoints: snapshot.endpoints)
                    else if (_view == 'websocket')
                      _WebSocketView(
                        url: snapshot.websocketUrl,
                        events: snapshot.websocketEvents,
                      )
                    else
                      _ExamplesView(
                        examples: snapshot.codeExamples,
                        language: _language,
                        copied: _copied,
                        onLanguageChanged: (language) {
                          setState(() {
                            _language = language;
                            _copied = false;
                          });
                        },
                        onCopy: _copy,
                      ),
                    const SizedBox(height: 18),
                    const _SectionLabel('Rate Limits'),
                    const SizedBox(height: 10),
                    _RateLimitsCard(items: snapshot.rateLimits),
                    const SizedBox(height: 18),
                    _AuthCard(header: snapshot.authenticationHeader),
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
    setState(() => _copied = true);
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      decoration: BoxDecoration(
        color: _apiBlue.withValues(alpha: .08),
        border: Border.all(color: _apiBlue.withValues(alpha: .25)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.code_rounded, color: _apiBlue, size: 25),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bot API Documentation',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontSize: 17,
                    fontWeight: AppTextStyles.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Programmatically create, manage, and monitor trading '
                  'bots using our REST API and WebSocket connections. '
                  'Available for Enterprise tier users.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
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

class _Tabs extends StatelessWidget {
  const _Tabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<TradeBotApiTab> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final widths = <String, double>{
      'endpoints': 93,
      'websocket': 96,
      'examples': 90,
    };
    return Row(
      children: [
        for (var i = 0; i < tabs.length; i++) ...[
          GestureDetector(
            key: BotApiDocumentationPage.tabKey(tabs[i].id),
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged(tabs[i].id),
            child: Container(
              width: widths[tabs[i].id] ?? 90,
              height: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active == tabs[i].id
                    ? _apiBlue.withValues(alpha: .13)
                    : _apiTabBg,
                border: Border.all(
                  color: active == tabs[i].id
                      ? _apiBlue.withValues(alpha: .42)
                      : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                tabs[i].label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: active == tabs[i].id ? _apiBlue : AppColors.text3,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
          ),
          if (i != tabs.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _EndpointsView extends StatelessWidget {
  const _EndpointsView({required this.endpoints});

  final List<TradeBotApiEndpoint> endpoints;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('REST API Endpoints'),
        const SizedBox(height: 10),
        for (final endpoint in endpoints) ...[
          _EndpointCard(endpoint: endpoint),
          if (endpoint != endpoints.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _EndpointCard extends StatelessWidget {
  const _EndpointCard({required this.endpoint});

  final TradeBotApiEndpoint endpoint;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: BotApiDocumentationPage.endpointKey(endpoint.method, endpoint.path),
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      decoration: BoxDecoration(
        color: _apiSurface,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _MethodBadge(method: endpoint.method),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  endpoint.path,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Text(
            endpoint.description,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              height: 1,
            ),
          ),
          if (endpoint.params.isNotEmpty) ...[
            const SizedBox(height: 17),
            _Parameters(params: endpoint.params),
          ],
          const SizedBox(height: 18),
          _ResponseBlock(response: endpoint.response),
        ],
      ),
    );
  }
}

class _Parameters extends StatelessWidget {
  const _Parameters({required this.params});

  final List<TradeBotApiParameter> params;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PARAMETERS:',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
        const SizedBox(height: 9),
        for (final param in params) ...[
          _ParameterRow(param: param),
          if (param != params.last) const SizedBox(height: 9),
        ],
      ],
    );
  }
}

class _ParameterRow extends StatelessWidget {
  const _ParameterRow({required this.param});

  final TradeBotApiParameter param;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          param.name,
          style: AppTextStyles.micro.copyWith(
            color: _apiBlue,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
        const SizedBox(width: 7),
        Text(
          '(${param.type})',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 11,
            height: 1.2,
          ),
        ),
        if (param.required)
          Text(
            ' *',
            style: AppTextStyles.micro.copyWith(
              color: _apiRed,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
              height: 1.2,
            ),
          ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            '- ${param.description}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _ResponseBlock extends StatelessWidget {
  const _ResponseBlock({required this.response});

  final String response;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'RESPONSE:',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 10,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
            const Spacer(),
            GestureDetector(
              key: BotApiDocumentationPage.copyKey,
              behavior: HitTestBehavior.opaque,
              onTap: () => Clipboard.setData(ClipboardData(text: response)),
              child: const Icon(
                Icons.content_copy_rounded,
                color: AppColors.text3,
                size: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        _CodeBlock(text: response),
      ],
    );
  }
}

class _WebSocketView extends StatelessWidget {
  const _WebSocketView({required this.url, required this.events});

  final String url;
  final List<TradeBotWebSocketEvent> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('WebSocket Connection'),
        const SizedBox(height: 10),
        _InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Connect to real-time bot events:',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              _CodeBlock(text: url, compact: true),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const _SectionLabel('Event Types'),
        const SizedBox(height: 10),
        for (final event in events) ...[
          _InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bolt_rounded, color: _apiBlue, size: 17),
                    const SizedBox(width: 8),
                    Text(
                      event.event,
                      style: AppTextStyles.caption.copyWith(
                        color: _apiBlue,
                        fontSize: 12,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  event.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                _CodeBlock(text: event.payload),
              ],
            ),
          ),
          if (event != events.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ExamplesView extends StatelessWidget {
  const _ExamplesView({
    required this.examples,
    required this.language,
    required this.copied,
    required this.onLanguageChanged,
    required this.onCopy,
  });

  final List<TradeBotCodeExample> examples;
  final String language;
  final bool copied;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    final selected = examples.firstWhere(
      (item) => item.language == language,
      orElse: () => examples.first,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (final example in examples) ...[
              GestureDetector(
                key: BotApiDocumentationPage.languageKey(example.language),
                behavior: HitTestBehavior.opaque,
                onTap: () => onLanguageChanged(example.language),
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected.language == example.language
                        ? _apiBlue
                        : _apiSurface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    example.label,
                    style: AppTextStyles.caption.copyWith(
                      color: selected.language == example.language
                          ? Colors.white
                          : AppColors.text1,
                      fontSize: 12,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
              if (example != examples.last) const SizedBox(width: 8),
            ],
          ],
        ),
        const SizedBox(height: 18),
        const _SectionLabel('Quick Start'),
        const SizedBox(height: 10),
        _InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.menu_book_outlined,
                    color: _apiBlue,
                    size: 17,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      selected.title,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontSize: 13,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onCopy(selected.source),
                    child: Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: copied
                            ? _apiGreen.withValues(alpha: .12)
                            : _apiSurface2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            copied
                                ? Icons.check_circle_outline_rounded
                                : Icons.content_copy_rounded,
                            color: copied ? _apiGreen : AppColors.text3,
                            size: 15,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            copied ? 'Copied!' : 'Copy',
                            style: AppTextStyles.micro.copyWith(
                              color: copied ? _apiGreen : AppColors.text3,
                              fontSize: 11,
                              fontWeight: copied
                                  ? AppTextStyles.bold
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              _CodeBlock(text: selected.source, example: true),
            ],
          ),
        ),
      ],
    );
  }
}

class _RateLimitsCard extends StatelessWidget {
  const _RateLimitsCard({required this.items});

  final List<TradeBotRateLimit> items;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      child: Column(
        children: [
          for (final item in items) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  item.value,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            if (item != items.last) const SizedBox(height: 15),
          ],
        ],
      ),
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard({required this.header});

  final String header;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: _apiSurface2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.key_rounded, color: _apiBlue, size: 18),
              const SizedBox(width: 9),
              Text(
                'Authentication',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'All API requests require an API key. Generate yours in Security '
            'Settings. Include in header:',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 9),
          _CodeBlock(text: header, compact: true, dark: true),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _apiSurface,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({
    required this.text,
    this.compact = false,
    this.example = false,
    this.dark = false,
  });

  final String text;
  final bool compact;
  final bool example;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        12,
        compact ? 11 : 13,
        12,
        compact ? 11 : 13,
      ),
      decoration: BoxDecoration(
        color: dark ? _apiSurface : _apiSurface2,
        borderRadius: BorderRadius.circular(14),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          text,
          style: AppTextStyles.micro.copyWith(
            color: compact ? _apiBlue : AppColors.text2,
            fontSize: example ? 11 : 10,
            height: example ? 1.7 : 1.58,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _MethodBadge extends StatelessWidget {
  const _MethodBadge({required this.method});

  final String method;

  @override
  Widget build(BuildContext context) {
    final color = _methodColor(method);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        method,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 12,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _apiBlue,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

Color _methodColor(String method) => switch (method) {
  'GET' => _apiGreen,
  'POST' => _apiBlue,
  'DELETE' => _apiRed,
  _ => AppColors.text2,
};
