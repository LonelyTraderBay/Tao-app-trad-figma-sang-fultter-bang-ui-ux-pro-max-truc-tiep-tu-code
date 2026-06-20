part of '../pages/bot_api_documentation_page.dart';

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
                    ),
                  ),
                ),
                Text(
                  item.value,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            if (item != items.last) const SizedBox(height: AppSpacing.x3),
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
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.compact,
        children: [
          Row(
            children: [
              const Icon(
                Icons.key_rounded,
                color: _apiPrimary,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                'Authentication',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          Text(
            'All API requests require an API key. Generate yours in Security '
            'Settings. Include in header:',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
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
    return VitCard(density: VitDensity.compact, child: child);
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
    return VitCard(
      variant: dark ? VitCardVariant.standard : VitCardVariant.inner,
      width: double.infinity,
      padding: compact
          ? AppSpacing.tradeBotCodeBlockCompactPadding
          : AppSpacing.tradeBotCodeBlockPadding,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          text,
          style: AppTextStyles.micro.copyWith(
            color: compact ? _apiPrimary : AppColors.text2,
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
    return VitStatusPill(
      label: method,
      status: switch (method) {
        'GET' => VitStatusPillStatus.success,
        'POST' => VitStatusPillStatus.info,
        _ => VitStatusPillStatus.warning,
      },
      size: VitStatusPillSize.sm,
    );
  }
}
