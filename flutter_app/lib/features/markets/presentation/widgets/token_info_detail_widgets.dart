part of '../pages/token_info_page.dart';

class _OnchainTab extends StatelessWidget {
  const _OnchainTab({required this.snapshot});

  final MarketTokenInfoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final f = snapshot.fundamentals;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.bolt_rounded,
                    color: AppColors.buy,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Hoat dong mang luoi (24h)',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _MiniStat(
                      label: 'Dia chi hoat dong',
                      value: _formatCompact(f.activeAddresses24h.toDouble()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MiniStat(
                      label: 'Giao dich',
                      value: _formatCompact(f.txCount24h.toDouble()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _MiniStat(
                      label: 'Tong holders',
                      value: _formatCompact(f.holders.toDouble()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MiniStat(
                      label: 'TVL',
                      value: f.tvl == null
                          ? 'N/A'
                          : _formatCompact(f.tvl!, prefix: r'$'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const _SectionHeader(
          label: 'Thong tin mang luoi',
          accentColor: _marketPrimary,
        ),
        _InfoCard(
          rows: [
            _InfoRowData(
              icon: Icons.public_rounded,
              iconColor: _marketPrimary,
              label: 'Mang luoi',
              value: f.network,
            ),
            _InfoRowData(
              icon: Icons.shield_rounded,
              iconColor: AppColors.accent,
              label: 'Dong thuan',
              value: f.consensus,
            ),
            const _InfoRowData(
              icon: Icons.info_outline_rounded,
              iconColor: AppColors.warn,
              label: 'Hop dong token',
              value: 'Blockchain goc',
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              fontSize: 20,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectTab extends StatelessWidget {
  const _ProjectTab({required this.snapshot});

  final MarketTokenInfoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final f = snapshot.fundamentals;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.article_outlined,
                    color: _marketPrimary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Gioi thieu',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(f.description, style: AppTextStyles.body),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const _SectionHeader(label: 'Lien ket', accentColor: _marketPrimary),
        _ProjectLinks(fundamentals: f),
        const SizedBox(height: 14),
        const _SectionHeader(
          label: 'Chi so quan trong',
          accentColor: AppColors.buy,
        ),
        _InfoCard(
          rows: [
            _InfoRowData(
              icon: Icons.bar_chart_rounded,
              iconColor: _marketPrimary,
              label: 'Von hoa',
              value: _formatCompact(snapshot.pair.marketCap, prefix: r'$'),
            ),
            _InfoRowData(
              icon: Icons.layers_rounded,
              iconColor: AppColors.accent,
              label: 'FDV',
              value: _formatCompact(f.fullyDilutedValuation, prefix: r'$'),
            ),
            _InfoRowData(
              icon: Icons.token_rounded,
              iconColor: AppColors.warn,
              label: 'Cung luu hanh',
              value: '${_formatCompact(f.circulatingSupply)} ${f.symbol}',
            ),
          ],
        ),
      ],
    );
  }
}

class _ProjectLinks extends StatelessWidget {
  const _ProjectLinks({required this.fundamentals});

  final TokenFundamentalsDraft fundamentals;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LinkRow(
          icon: Icons.public_rounded,
          label: 'Website',
          value: fundamentals.website,
        ),
        const SizedBox(height: 8),
        _LinkRow(
          icon: Icons.description_outlined,
          label: 'Whitepaper',
          value: fundamentals.whitepaper,
        ),
        const SizedBox(height: 8),
        _LinkRow(
          icon: Icons.code_rounded,
          label: 'GitHub',
          value: fundamentals.github,
        ),
        const SizedBox(height: 8),
        _LinkRow(
          icon: Icons.alternate_email_rounded,
          label: 'Twitter',
          value: fundamentals.twitter,
        ),
      ],
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: _marketPrimary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.open_in_new_rounded,
            color: AppColors.text3,
            size: 15,
          ),
        ],
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.warn08,
        border: Border.all(color: AppColors.warningBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.warn,
              size: 14,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Thong tin mang tinh tham khao, khong phai loi khuyen dau tu. Hay tu nghien cuu truoc khi dua ra quyet dinh.',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.warn,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatPrice(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final raw = parts[0];
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i += 1) {
    if (i > 0 && (raw.length - i) % 3 == 0) buffer.write(',');
    buffer.write(raw[i]);
  }
  return '${buffer.toString()}.${parts[1]}';
}

String _formatCompact(double value, {String prefix = ''}) {
  final abs = value.abs();
  if (abs >= 1000000000) {
    return '$prefix${_formatNumber(value / 1000000000)}B';
  }
  if (abs >= 1000000) {
    return '$prefix${_formatNumber(value / 1000000)}M';
  }
  if (abs >= 1000) {
    return '$prefix${_formatNumber(value / 1000)}K';
  }
  return '$prefix${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2)}';
}

String _formatNumber(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final raw = parts[0];
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i += 1) {
    if (i > 0 && (raw.length - i) % 3 == 0) buffer.write(',');
    buffer.write(raw[i]);
  }
  return '${buffer.toString()}.${parts[1]}';
}
