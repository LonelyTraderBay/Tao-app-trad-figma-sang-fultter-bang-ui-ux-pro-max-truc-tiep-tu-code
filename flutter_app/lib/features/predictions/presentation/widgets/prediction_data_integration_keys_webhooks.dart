part of '../pages/prediction_data_integration_page.dart';

class _ApiKeysSection extends StatelessWidget {
  const _ApiKeysSection({
    required this.apiKeys,
    required this.revealedKeys,
    required this.copiedKeyId,
    required this.onReveal,
    required this.onCopy,
  });

  final List<PredictionApiKeyDraft> apiKeys;
  final Set<String> revealedKeys;
  final String? copiedKeyId;
  final ValueChanged<String> onReveal;
  final ValueChanged<PredictionApiKeyDraft> onCopy;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Your API Keys',
      accentColor: _predictionPrimary,
      children: [
        for (final apiKey in apiKeys)
          _ApiKeyCard(
            apiKey: apiKey,
            revealed: revealedKeys.contains(apiKey.id),
            copied: copiedKeyId == apiKey.id,
            onReveal: () => onReveal(apiKey.id),
            onCopy: () => onCopy(apiKey),
          ),
      ],
    );
  }
}

class _ApiKeyCard extends StatelessWidget {
  const _ApiKeyCard({
    required this.apiKey,
    required this.revealed,
    required this.copied,
    required this.onReveal,
    required this.onCopy,
  });

  final PredictionApiKeyDraft apiKey;
  final bool revealed;
  final bool copied;
  final VoidCallback onReveal;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          apiKey.name,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        _MiniStatusPill(
                          label: _apiKeyStatusLabel(apiKey.status),
                          color: _apiKeyStatusColor(apiKey.status),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      apiKey.createdAtLabel,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              _IconBubble(
                icon: Icons.delete_outline_rounded,
                color: AppColors.sell,
                background: AppColors.sell10,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            constraints: const BoxConstraints(minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.bg,
              border: Border.all(color: AppColors.border),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.vpn_key_outlined,
                  color: AppColors.text3,
                  size: 15,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    revealed ? apiKey.key : _maskKey(apiKey.key),
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text1,
                      fontFamily: 'monospace',
                      fontSize: 11,
                    ),
                  ),
                ),
                _InlineIconButton(
                  key: PredictionDataIntegrationPage.revealApiKey(apiKey.id),
                  icon: revealed
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  onTap: onReveal,
                ),
                _InlineIconButton(
                  key: PredictionDataIntegrationPage.copyApiKey(apiKey.id),
                  icon: copied
                      ? Icons.check_circle_outline_rounded
                      : Icons.copy_rounded,
                  color: copied ? AppColors.buy : AppColors.text3,
                  onTap: onCopy,
                ),
              ],
            ),
          ),
          const SizedBox(height: 13),
          Text(
            'Permissions',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 7),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final permission in apiKey.permissions)
                _NeutralChip(label: permission),
            ],
          ),
          if (apiKey.lastUsedLabel != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  color: AppColors.text3,
                  size: 12,
                ),
                const SizedBox(width: 6),
                Text(
                  apiKey.lastUsedLabel!,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _WebhookSection extends StatelessWidget {
  const _WebhookSection({required this.webhooks});

  final List<PredictionWebhookDraft> webhooks;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Webhook Endpoints',
      accentColor: _predictionPrimary,
      children: [
        for (final webhook in webhooks) _WebhookCard(webhook: webhook),
      ],
    );
  }
}

class _WebhookCard extends StatelessWidget {
  const _WebhookCard({required this.webhook});

  final PredictionWebhookDraft webhook;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Icon(
                          Icons.hub_outlined,
                          color: AppColors.text3,
                          size: 15,
                        ),
                        _MiniStatusPill(
                          label: _webhookStatusLabel(webhook.status),
                          color: _webhookStatusColor(webhook.status),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      webhook.url,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text1,
                        fontFamily: 'monospace',
                        height: 1.45,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _IconBubble(
                icon: Icons.delete_outline_rounded,
                color: AppColors.sell,
                background: AppColors.sell10,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Events',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 7),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final event in webhook.events) _NeutralChip(label: event),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _CompactMetric(
                  label: 'Success Rate',
                  value: _formatPercent(webhook.successRate),
                  color: AppColors.buy,
                  trailingIcon: webhook.successRate >= 95
                      ? Icons.check_circle_outline_rounded
                      : null,
                ),
              ),
              Expanded(
                child: _CompactMetric(
                  label: 'Last Triggered',
                  value: webhook.lastTriggeredLabel ?? 'Never',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
