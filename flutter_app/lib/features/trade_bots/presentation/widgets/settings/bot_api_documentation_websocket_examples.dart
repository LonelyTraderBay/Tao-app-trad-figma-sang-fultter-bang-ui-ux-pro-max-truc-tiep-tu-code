part of '../../pages/settings/bot_api_documentation_page.dart';

class _WebSocketView extends StatelessWidget {
  const _WebSocketView({required this.url, required this.events});

  final String url;
  final List<TradeBotWebSocketEvent> events;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.compact,
      children: [
        VitPageSection(
          label: 'WebSocket Connection',
          density: VitDensity.compact,
          children: [
            _InfoCard(
              child: VitPageContent(
                rhythm: VitPageRhythm.standard,
                padding: VitContentPadding.none,
                fullBleed: true,
                density: VitDensity.compact,
                children: [
                  Text(
                    'Connect to real-time bot events:',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                  _CodeBlock(text: url, compact: true),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          label: 'Event Types',
          density: VitDensity.compact,
          children: [
            VitPageContent(
              padding: VitContentPadding.none,
              fullBleed: true,
              density: VitDensity.compact,
              children: [
                for (final event in events)
                  _InfoCard(
                    child: VitPageContent(
                      padding: VitContentPadding.none,
                      fullBleed: true,
                      density: VitDensity.compact,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.bolt_rounded,
                              color: _apiPrimary,
                              size: AppSpacing.iconSm,
                            ),
                            const SizedBox(width: AppSpacing.x2),
                            Text(
                              event.event,
                              style: AppTextStyles.caption.copyWith(
                                color: _apiPrimary,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          event.description,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                        _CodeBlock(text: event.payload),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
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
    return VitPageContent(
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.compact,
      children: [
        Row(
          children: [
            for (final example in examples) ...[
              VitCtaButton(
                key: BotApiDocumentationPage.languageKey(example.language),
                onPressed: () => onLanguageChanged(example.language),
                fullWidth: false,
                density: VitDensity.compact,
                variant: selected.language == example.language
                    ? VitCtaButtonVariant.secondary
                    : VitCtaButtonVariant.ghost,
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.x3,
                ),
                child: Text(
                  example.label,
                  style: AppTextStyles.caption.copyWith(
                    color: selected.language == example.language
                        ? _apiPrimary
                        : AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              if (example != examples.last)
                const SizedBox(width: AppSpacing.x2),
            ],
          ],
        ),
        VitPageSection(
          label: 'Quick Start',
          density: VitDensity.compact,
          children: [
            _InfoCard(
              child: VitPageContent(
                padding: VitContentPadding.none,
                fullBleed: true,
                density: VitDensity.compact,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.menu_book_outlined,
                        color: _apiPrimary,
                        size: AppSpacing.iconSm,
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Expanded(
                        child: Text(
                          selected.title,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      VitIconButton(
                        icon: copied
                            ? Icons.check_circle_outline_rounded
                            : Icons.content_copy_rounded,
                        tooltip: copied ? 'Copied source' : 'Copy source',
                        label: copied ? 'Copied!' : 'Copy',
                        size: VitIconButtonSize.sm,
                        variant: copied
                            ? VitIconButtonVariant.success
                            : VitIconButtonVariant.ghost,
                        onPressed: () => onCopy(selected.source),
                      ),
                    ],
                  ),
                  _CodeBlock(text: selected.source, example: true),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
