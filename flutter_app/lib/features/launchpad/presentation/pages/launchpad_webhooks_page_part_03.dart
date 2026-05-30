part of 'launchpad_webhooks_page.dart';

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
                    _SheetTextField(
                      label: 'Ten webhook',
                      hint: 'VD: Staking Monitor',
                      controller: _labelController,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    _SheetTextField(
                      label: 'Webhook URL',
                      hint: 'https://api.example.com/webhooks',
                      controller: _urlController,
                      monospace: true,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    _SheetTextField(
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

class _SheetTextField extends StatelessWidget {
  const _SheetTextField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
    this.monospace = false,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool monospace;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        TextField(
          controller: controller,
          onChanged: onChanged,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontFamily: monospace ? 'monospace' : null,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontFamily: monospace ? 'monospace' : null,
            ),
            filled: true,
            fillColor: AppColors.surface2,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x3,
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.borderSolid),
              borderRadius: AppRadii.inputRadius,
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
              borderRadius: AppRadii.inputRadius,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChoiceGroup extends StatelessWidget {
  const _ChoiceGroup({
    required this.label,
    required this.items,
    required this.active,
    required this.colorFor,
    required this.onChanged,
  });

  final String label;
  final List<String> items;
  final String active;
  final Color Function(String value) colorFor;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final item in items) ...[
                _SelectablePill(
                  label: item,
                  color: colorFor(item),
                  active: active == item,
                  onTap: () => onChanged(item),
                ),
                const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SelectablePill extends StatelessWidget {
  const _SelectablePill({
    super.key,
    required this.label,
    required this.color,
    required this.active,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.smRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            color: active ? color.withValues(alpha: .14) : AppColors.surface2,
            border: Border.all(
              color: active
                  ? color.withValues(alpha: .34)
                  : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.smRadius,
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: active ? color : AppColors.text3,
              fontWeight: AppTextStyles.bold,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  const _SmallActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x3,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: .11),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: AppSpacing.x2),
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: color, size: 9),
              const SizedBox(width: 3),
            ],
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontSize: 9,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  const _MiniPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontSize: 9,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({
    super.key,
    required this.active,
    required this.onTap,
    this.size = 22,
  });

  final bool active;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      constraints: BoxConstraints.tightFor(width: size, height: size),
      padding: EdgeInsets.zero,
      onPressed: onTap,
      icon: Icon(
        active ? Icons.check_rounded : Icons.copy_rounded,
        color: active ? AppColors.buy : AppColors.text3,
        size: size * .55,
      ),
    );
  }
}

class _EmptySubscriptions extends StatelessWidget {
  const _EmptySubscriptions();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x6),
      child: Column(
        children: [
          const Icon(Icons.hub_outlined, color: AppColors.text3, size: 32),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Chua co webhook nao',
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Tao webhook de nhan thong bao event tu contract',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
