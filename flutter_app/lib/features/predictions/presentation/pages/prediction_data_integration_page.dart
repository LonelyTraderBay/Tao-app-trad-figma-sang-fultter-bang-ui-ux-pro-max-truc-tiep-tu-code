import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';

const _predictionPrimary = AppColors.primary;

enum _DataIntegrationTab { sources, apiKeys, webhooks }

class PredictionDataIntegrationPage extends ConsumerStatefulWidget {
  const PredictionDataIntegrationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc043_data_integration_content');
  static const sourcesTabKey = Key('sc043_tab_sources');
  static const apiKeysTabKey = Key('sc043_tab_api_keys');
  static const webhooksTabKey = Key('sc043_tab_webhooks');
  static const addSourceKey = Key('sc043_add_source');
  static const createApiKeyKey = Key('sc043_create_api_key');
  static const addWebhookKey = Key('sc043_add_webhook');

  static Key sourceKey(String id) => Key('sc043_source_$id');

  static Key revealApiKey(String id) => Key('sc043_reveal_$id');

  static Key copyApiKey(String id) => Key('sc043_copy_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionDataIntegrationPage> createState() =>
      _PredictionDataIntegrationPageState();
}

class _PredictionDataIntegrationPageState
    extends ConsumerState<PredictionDataIntegrationPage> {
  _DataIntegrationTab _activeTab = _DataIntegrationTab.sources;
  final Set<String> _revealedKeys = <String>{};
  String? _copiedKeyId;

  void _toggleKey(String id) {
    setState(() {
      if (_revealedKeys.contains(id)) {
        _revealedKeys.remove(id);
      } else {
        _revealedKeys.add(id);
      }
    });
  }

  void _copyKey(PredictionApiKeyDraft apiKey) {
    Clipboard.setData(ClipboardData(text: apiKey.key));
    setState(() => _copiedKeyId = apiKey.id);
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(predictionsReadModelControllerProvider)
        .getDataIntegration();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-043 PredictionDataIntegrationPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Data Integration',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.marketsPredictions),
            ),
            _DataIntegrationTabBar(
              activeTab: _activeTab,
              onChanged: (tab) => setState(() => _activeTab = tab),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: PredictionDataIntegrationPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 16,
                    children: switch (_activeTab) {
                      _DataIntegrationTab.sources => [
                        _SourcesOverview(snapshot: snapshot),
                        _SourceSection(sources: snapshot.sources),
                        const _PrimaryBlueButton(
                          key: PredictionDataIntegrationPage.addSourceKey,
                          icon: Icons.add_rounded,
                          label: 'Add Data Source',
                        ),
                        const _InfoCard(
                          icon: Icons.shield_outlined,
                          message:
                              'Oracle data sources are used for automatic event resolution. All sources are verified and monitored.',
                        ),
                      ],
                      _DataIntegrationTab.apiKeys => [
                        _ApiKeysSection(
                          apiKeys: snapshot.apiKeys,
                          revealedKeys: _revealedKeys,
                          copiedKeyId: _copiedKeyId,
                          onReveal: _toggleKey,
                          onCopy: _copyKey,
                        ),
                        const _PrimaryBlueButton(
                          key: PredictionDataIntegrationPage.createApiKeyKey,
                          icon: Icons.add_rounded,
                          label: 'Create API Key',
                        ),
                        const _WarningCard(
                          message:
                              'Keep your API keys secret. Never share them or commit to version control. Revoke immediately if compromised.',
                        ),
                      ],
                      _DataIntegrationTab.webhooks => [
                        _WebhookSection(webhooks: snapshot.webhooks),
                        const _PrimaryBlueButton(
                          key: PredictionDataIntegrationPage.addWebhookKey,
                          icon: Icons.add_rounded,
                          label: 'Add Webhook',
                        ),
                        const _InfoCard(
                          icon: Icons.info_outline_rounded,
                          message:
                              'Webhooks allow you to receive real-time notifications when events occur. Configure your endpoint to handle POST requests.',
                        ),
                      ],
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DataIntegrationTabBar extends StatelessWidget {
  const _DataIntegrationTabBar({
    required this.activeTab,
    required this.onChanged,
  });

  final _DataIntegrationTab activeTab;
  final ValueChanged<_DataIntegrationTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (
        key: PredictionDataIntegrationPage.sourcesTabKey,
        tab: _DataIntegrationTab.sources,
        label: 'Nguon du lieu',
      ),
      (
        key: PredictionDataIntegrationPage.apiKeysTabKey,
        tab: _DataIntegrationTab.apiKeys,
        label: 'API Keys',
      ),
      (
        key: PredictionDataIntegrationPage.webhooksTabKey,
        tab: _DataIntegrationTab.webhooks,
        label: 'Webhooks',
      ),
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SizedBox(
        height: 54,
        child: Row(
          children: [
            for (final item in tabs)
              Expanded(
                child: InkWell(
                  key: item.key,
                  onTap: () => onChanged(item.tab),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            item.label,
                            style: AppTextStyles.caption.copyWith(
                              color: activeTab == item.tab
                                  ? _predictionPrimary
                                  : AppColors.text3,
                              fontWeight: AppTextStyles.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        height: 2,
                        width: activeTab == item.tab ? 116 : 0,
                        decoration: BoxDecoration(
                          color: _predictionPrimary,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
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

class _SourcesOverview extends StatelessWidget {
  const _SourcesOverview({required this.snapshot});

  final PredictionDataIntegrationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.buy.withValues(alpha: .1),
                  borderRadius: AppRadii.inputRadius,
                ),
                child: const Icon(
                  Icons.storage_rounded,
                  color: AppColors.buy,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Oracle Data Sources',
                      style: AppTextStyles.base.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'External data feeds for event resolution',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  label: 'Active',
                  value: '${snapshot.activeSources}',
                  color: AppColors.buy,
                ),
              ),
              Expanded(
                child: _OverviewMetric(
                  label: 'Avg Reliability',
                  value: '${snapshot.averageReliability.toStringAsFixed(1)}%',
                ),
              ),
              Expanded(
                child: _OverviewMetric(
                  label: 'Events Resolved',
                  value: '${snapshot.eventsResolved}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontSize: 17,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _SourceSection extends StatelessWidget {
  const _SourceSection({required this.sources});

  final List<PredictionDataSourceDraft> sources;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Configured Sources',
      accentColor: _predictionPrimary,
      children: [for (final source in sources) _SourceCard(source: source)],
    );
  }
}

class _SourceCard extends StatelessWidget {
  const _SourceCard({required this.source});

  final PredictionDataSourceDraft source;

  @override
  Widget build(BuildContext context) {
    final color = _sourceStatusColor(source.status);
    return VitCard(
      key: PredictionDataIntegrationPage.sourceKey(source.id),
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
                          source.name,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        _MiniStatusPill(
                          label: _sourceStatusLabel(source.status),
                          color: color,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${source.provider} - ${source.category}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.bg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.refresh_rounded,
                  color: AppColors.text3,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _CompactMetric(
                  label: 'Last Sync',
                  value: source.lastSyncLabel,
                ),
              ),
              Expanded(
                child: _CompactMetric(
                  label: 'Events',
                  value: '${source.eventsResolved}',
                ),
              ),
              Expanded(
                child: _CompactMetric(
                  label: 'Reliability',
                  value: _formatPercent(source.reliability),
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
          if (source.apiUrl != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.link_rounded,
                  color: AppColors.text3,
                  size: 12,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    source.apiUrl!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontFamily: 'monospace',
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

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

class _CompactMetric extends StatelessWidget {
  const _CompactMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
    this.trailingIcon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontSize: 12,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 5),
              Icon(trailingIcon, color: color, size: 12),
            ],
          ],
        ),
      ],
    );
  }
}

class _MiniStatusPill extends StatelessWidget {
  const _MiniStatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _NeutralChip extends StatelessWidget {
  const _NeutralChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(color: AppColors.text2),
      ),
    );
  }
}

class _InlineIconButton extends StatelessWidget {
  const _InlineIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = AppColors.text3,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: IconButton(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: color, size: 15),
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: 16),
    );
  }
}

class _PrimaryBlueButton extends StatelessWidget {
  const _PrimaryBlueButton({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _predictionPrimary,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.onAccent, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: AppColors.onAccent,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return _NoticeCard(icon: icon, color: _predictionPrimary, message: message);
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return _NoticeCard(
      icon: Icons.error_outline_rounded,
      color: AppColors.sell,
      message: message,
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({
    required this.icon,
    required this.color,
    required this.message,
  });

  final IconData icon;
  final Color color;
  final String message;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: color.withValues(alpha: .18),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _sourceStatusColor(PredictionDataSourceStatus status) {
  return switch (status) {
    PredictionDataSourceStatus.active => AppColors.buy,
    PredictionDataSourceStatus.inactive => AppColors.text3,
    PredictionDataSourceStatus.error => AppColors.sell,
  };
}

String _sourceStatusLabel(PredictionDataSourceStatus status) {
  return switch (status) {
    PredictionDataSourceStatus.active => 'ACTIVE',
    PredictionDataSourceStatus.inactive => 'INACTIVE',
    PredictionDataSourceStatus.error => 'ERROR',
  };
}

Color _apiKeyStatusColor(PredictionApiKeyStatus status) {
  return switch (status) {
    PredictionApiKeyStatus.active => AppColors.buy,
    PredictionApiKeyStatus.revoked => AppColors.sell,
  };
}

String _apiKeyStatusLabel(PredictionApiKeyStatus status) {
  return switch (status) {
    PredictionApiKeyStatus.active => 'ACTIVE',
    PredictionApiKeyStatus.revoked => 'REVOKED',
  };
}

Color _webhookStatusColor(PredictionWebhookStatus status) {
  return switch (status) {
    PredictionWebhookStatus.active => AppColors.buy,
    PredictionWebhookStatus.inactive => AppColors.text3,
  };
}

String _webhookStatusLabel(PredictionWebhookStatus status) {
  return switch (status) {
    PredictionWebhookStatus.active => 'ACTIVE',
    PredictionWebhookStatus.inactive => 'INACTIVE',
  };
}

String _formatPercent(double value) {
  if (value == value.roundToDouble()) {
    return '${value.toStringAsFixed(0)}%';
  }
  return '${value.toStringAsFixed(1)}%';
}

String _maskKey(String key) {
  final parts = key.split('_');
  if (parts.length >= 3) {
    return '${parts[0]}_${parts[1]}_${List.filled(parts[2].length, '*').join()}';
  }
  return List.filled(key.length, '*').join();
}
