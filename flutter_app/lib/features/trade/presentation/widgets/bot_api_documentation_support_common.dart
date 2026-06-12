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
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.key_rounded, color: _apiPrimary, size: 18),
              const SizedBox(width: 9),
              Text(
                'Authentication',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
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
    return VitCard(padding: const EdgeInsets.all(16), child: child);
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
      padding: EdgeInsets.fromLTRB(
        12,
        compact ? 11 : 13,
        12,
        compact ? 11 : 13,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          text,
          style: AppTextStyles.micro.copyWith(
            color: compact ? _apiPrimary : AppColors.text2,
            height: example ? 1.7 : 1.58,
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 4,
          height: 15,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _apiPrimary,
              borderRadius: AppRadii.smRadius,
            ),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}
