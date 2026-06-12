part of '../pages/bot_api_documentation_page.dart';

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
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
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
                    const Icon(
                      Icons.bolt_rounded,
                      color: _apiPrimary,
                      size: 17,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      event.event,
                      style: AppTextStyles.caption.copyWith(
                        color: _apiPrimary,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  event.description,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
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
                child: VitCard(
                  variant: selected.language == example.language
                      ? VitCardVariant.inner
                      : VitCardVariant.ghost,
                  height: 36,
                  width: 86,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  borderColor: selected.language == example.language
                      ? _apiPrimary.withValues(alpha: .42)
                      : AppColors.cardBorder,
                  child: Text(
                    example.label,
                    style: AppTextStyles.caption.copyWith(
                      color: selected.language == example.language
                          ? _apiPrimary
                          : AppColors.text1,
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
                    color: _apiPrimary,
                    size: 17,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      selected.title,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
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
                            : _apiPanel2,
                        borderRadius: AppRadii.smRadius,
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
