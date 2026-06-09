part of '../pages/arm_integration_status_page.dart';

class _OperationalAlert extends StatelessWidget {
  const _OperationalAlert();

  @override
  Widget build(BuildContext context) {
    return const VitHighRiskStatePanel(
      state: VitHighRiskUiState.success,
      title: 'All Systems Operational',
      message:
          '3/3 ARM providers online. Failover ready. Average uptime: 99.5%.',
    );
  }
}

class _ArmProviderCard extends StatelessWidget {
  const _ArmProviderCard({
    required this.connection,
    required this.isTesting,
    required this.onTest,
  });

  final TradeArmConnection connection;
  final bool isTesting;
  final VoidCallback onTest;

  @override
  Widget build(BuildContext context) {
    final style = _statusStyle(connection.status);
    return VitCard(
      key: ArmIntegrationStatusPage.connectionKey(connection.id),
      padding: const EdgeInsets.all(16),
      borderColor: _armBorder.withValues(alpha: .72),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: style.color.withValues(alpha: .15),
                  borderRadius: AppRadii.cardRadius,
                ),
                alignment: Alignment.center,
                child: Icon(style.icon, color: style.color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            connection.provider,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.text1,
                              fontSize: 15,
                              fontWeight: AppTextStyles.bold,
                              height: 1,
                            ),
                          ),
                        ),
                        if (connection.isPrimary) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _armPrimary.withValues(alpha: .15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'PRIMARY',
                              style: AppTextStyles.micro.copyWith(
                                color: _armPrimary,
                                fontSize: 9,
                                fontWeight: AppTextStyles.bold,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 9),
                    Text(
                      connection.region,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: style.color.withValues(alpha: .13),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: Text(
                  style.label,
                  style: AppTextStyles.caption.copyWith(
                    color: style.color,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Uptime',
                  value: '${connection.uptime.toStringAsFixed(2)}%',
                  color: _armGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricBox(
                  label: 'Avg Latency',
                  value: '${connection.avgLatency}ms',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricBox(
                  label: 'Current',
                  value: '${connection.currentLatency}ms',
                  color: connection.currentLatency > 60
                      ? _armRed
                      : AppColors.text1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ConnectionDetails(connection: connection),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: _TestButton(
                  connectionId: connection.id,
                  isTesting: isTesting,
                  onTap: onTest,
                ),
              ),
              const SizedBox(width: 12),
              const _LogsButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.fromLTRB(9, 9, 9, 8),
      decoration: BoxDecoration(
        color: _armPanel2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: color,
              fontSize: 16,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectionDetails extends StatelessWidget {
  const _ConnectionDetails({required this.connection});

  final TradeArmConnection connection;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      decoration: BoxDecoration(
        color: _armPanel2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Column(
        children: [
          _DetailRow(
            label: 'Endpoint:',
            value: connection.endpoint,
            mono: true,
          ),
          const SizedBox(height: 10),
          _DetailRow(label: 'Last Check:', value: connection.lastCheck),
          const SizedBox(height: 10),
          _DetailRow(label: 'Cert Expiry:', value: connection.certExpiry),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.mono = false,
  });

  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
            height: 1,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 10,
              fontFamily: mono ? 'monospace' : null,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _TestButton extends StatelessWidget {
  const _TestButton({
    required this.connectionId,
    required this.isTesting,
    required this.onTap,
  });

  final String connectionId;
  final bool isTesting;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: ArmIntegrationStatusPage.testKey(connectionId),
      onPressed: isTesting ? null : onTap,
      variant: VitCtaButtonVariant.secondary,
      height: 34,
      leading: Icon(
        isTesting ? Icons.sync_rounded : Icons.bolt_rounded,
        color: isTesting ? AppColors.text3 : _armPrimary,
        size: 15,
      ),
      child: Text(
        isTesting ? 'Testing...' : 'Test Connection',
        style: AppTextStyles.caption.copyWith(
          color: isTesting ? AppColors.text3 : _armPrimary,
          fontSize: 11,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _LogsButton extends StatelessWidget {
  const _LogsButton();

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: () {},
      variant: VitCtaButtonVariant.secondary,
      fullWidth: false,
      height: 34,
      leading: const Icon(
        Icons.open_in_new_rounded,
        color: AppColors.text2,
        size: 14,
      ),
      child: Text(
        'Logs',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text2,
          fontSize: 11,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}
