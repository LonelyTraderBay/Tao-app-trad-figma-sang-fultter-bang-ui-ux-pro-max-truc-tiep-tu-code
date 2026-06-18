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
        const SizedBox(height: AppSpacing.tradeBotRowGap),
        _InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Connect to real-time bot events:',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: AppSpacing.tradeBotRowGap),
              _CodeBlock(text: url, compact: true),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.tradeBotContentGap),
        const _SectionLabel('Event Types'),
        const SizedBox(height: AppSpacing.tradeBotRowGap),
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
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.tradeBotSmallGap),
                    Text(
                      event.event,
                      style: AppTextStyles.caption.copyWith(
                        color: _apiPrimary,
                        fontWeight: AppTextStyles.bold,
                        height: AppSpacing.tradeBotLineHeightTight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.tradeBotRowGap),
                Text(
                  event.description,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.tradeBotRowGap),
                _CodeBlock(text: event.payload),
              ],
            ),
          ),
          if (event != events.last)
            const SizedBox(height: AppSpacing.tradeBotCardGap),
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
                  height: AppSpacing.buttonCompact,
                  width: AppSpacing.tradeBotLanguageTabWidth,
                  padding: AppSpacing.tradeBotChipPadding,
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
                      height: AppSpacing.tradeBotLineHeightTight,
                    ),
                  ),
                ),
              ),
              if (example != examples.last)
                const SizedBox(width: AppSpacing.tradeBotSmallGap),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.tradeBotContentGap),
        const _SectionLabel('Quick Start'),
        const SizedBox(height: AppSpacing.tradeBotRowGap),
        _InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.menu_book_outlined,
                    color: _apiPrimary,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.tradeBotSmallGap),
                  Expanded(
                    child: Text(
                      selected.title,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        height: AppSpacing.tradeBotLineHeightTight,
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
              const SizedBox(height: AppSpacing.x4),
              _CodeBlock(text: selected.source, example: true),
            ],
          ),
        ),
      ],
    );
  }
}
