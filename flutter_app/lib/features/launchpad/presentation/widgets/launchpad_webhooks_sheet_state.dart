part of '../pages/launchpad_webhooks_page.dart';

class _CreateWebhookSheetState extends State<_CreateWebhookSheet> {
  final _labelController = TextEditingController();
  final _urlController = TextEditingController();
  final _contractController = TextEditingController();
  final Set<String> _selectedEvents = {};
  var _chain = 'BSC';
  var _retryPolicy = LaunchpadWebhookRetryPolicy.exponential;

  @override
  void dispose() {
    _labelController.dispose();
    _urlController.dispose();
    _contractController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _labelController.text.trim().isNotEmpty &&
      _urlController.text.trim().isNotEmpty &&
      _contractController.text.trim().isNotEmpty &&
      _selectedEvents.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: LaunchpadWebhooksPage.createSheetKey,
      color: AppColors.dynamicIslandBg.withValues(alpha: .72),
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: DeviceMetrics.width),
            decoration: const BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadii.cardLarge),
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.contentPad,
                  AppSpacing.x3,
                  AppSpacing.contentPad,
                  AppSpacing.x6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: AppColors.borderSolid,
                          borderRadius: AppRadii.xsRadius,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Tao Webhook moi',
                            style: AppTextStyles.base.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          key: LaunchpadWebhooksPage.createCloseKey,
                          onPressed: widget.onClose,
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    _SheetInputField(
                      label: 'Ten webhook',
                      hint: 'VD: Staking Monitor',
                      controller: _labelController,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    _SheetInputField(
                      label: 'Webhook URL',
                      hint: 'https://api.example.com/webhooks',
                      controller: _urlController,
                      monospace: true,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    _SheetInputField(
                      label: 'Contract Address',
                      hint: '0x...',
                      controller: _contractController,
                      monospace: true,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    _ChoiceGroup(
                      label: 'Chain',
                      items: const ['BSC', 'Ethereum', 'Polygon', 'Arbitrum'],
                      active: _chain,
                      colorFor: _chainColor,
                      onChanged: (value) => setState(() => _chain = value),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      'Events (${_selectedEvents.length})',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x2,
                      children: [
                        for (final event in widget.eventTypes)
                          _SelectablePill(
                            key: LaunchpadWebhooksPage.eventKey(event.type),
                            label: event.label,
                            color: event.accent,
                            active: _selectedEvents.contains(event.type),
                            onTap: () => setState(() {
                              if (!_selectedEvents.add(event.type)) {
                                _selectedEvents.remove(event.type);
                              }
                            }),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    _ChoiceGroup(
                      label: 'Retry Policy',
                      items: const ['none', 'linear', 'exponential'],
                      active: _retryLabel(_retryPolicy),
                      colorFor: (_) => AppColors.primary,
                      onChanged: (value) => setState(() {
                        _retryPolicy = switch (value) {
                          'none' => LaunchpadWebhookRetryPolicy.none,
                          'linear' => LaunchpadWebhookRetryPolicy.linear,
                          _ => LaunchpadWebhookRetryPolicy.exponential,
                        };
                      }),
                    ),
                    const SizedBox(height: AppSpacing.x5),
                    VitCtaButton(
                      key: LaunchpadWebhooksPage.createSubmitKey,
                      onPressed: _canSubmit ? _submit : null,
                      child: const Text('Tao Webhook'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    final now = DateTime.now().millisecondsSinceEpoch;
    widget.onCreate(
      LaunchpadWebhookSubscriptionDraft(
        id: 'wh_new_$now',
        label: _labelController.text.trim(),
        contractAddress: _contractController.text.trim(),
        chain: _chain,
        accent: _chainColor(_chain),
        eventTypes: _selectedEvents.toList(),
        webhookUrl: _urlController.text.trim(),
        status: LaunchpadWebhookStatus.pending,
        createdAt: 'Hom nay',
        triggerCount: 0,
        errorCount: 0,
        filters: const [],
        retryPolicy: _retryPolicy,
        maxRetries: _retryPolicy == LaunchpadWebhookRetryPolicy.none ? 0 : 3,
      ),
    );
  }
}
