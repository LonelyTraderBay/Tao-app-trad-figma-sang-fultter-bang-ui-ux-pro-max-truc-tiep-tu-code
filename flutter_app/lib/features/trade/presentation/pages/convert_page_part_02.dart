part of 'convert_page.dart';

class _SwapButton extends StatelessWidget {
  const _SwapButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ConvertPage.swapKey,
      onTap: onTap,
      borderRadius: AppRadii.lgRadius,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: _tradePrimary.withValues(alpha: .45)),
          borderRadius: AppRadii.cardRadius,
          boxShadow: [
            BoxShadow(
              color: AppColors.dynamicIslandBg.withValues(alpha: .30),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(
          Icons.swap_vert_rounded,
          color: _tradePrimary,
          size: 25,
        ),
      ),
    );
  }
}

class _ToolRow extends StatelessWidget {
  const _ToolRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: Row(
        children: const [
          Expanded(
            child: _ToolChip(
              id: 'chart',
              label: 'Chart',
              icon: Icons.bar_chart_rounded,
            ),
          ),
          SizedBox(width: 7),
          Expanded(
            child: _ToolChip(
              id: 'depth',
              label: 'Depth',
              icon: Icons.layers_outlined,
            ),
          ),
          SizedBox(width: 7),
          Expanded(
            child: _ToolChip(
              id: 'info',
              label: 'Info',
              icon: Icons.info_outline_rounded,
            ),
          ),
          SizedBox(width: 7),
          Expanded(
            child: _ToolChip(
              id: 'alert',
              label: 'Alert',
              icon: Icons.notifications_none_rounded,
              badge: true,
            ),
          ),
          SizedBox(width: 7),
          _SettingsChip(),
        ],
      ),
    );
  }
}

class _ToolChip extends StatelessWidget {
  const _ToolChip({
    required this.id,
    required this.label,
    required this.icon,
    this.badge = false,
  });

  final String id;
  final String label;
  final IconData icon;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ConvertPage.toolKey(id),
      onTap: () {},
      borderRadius: AppRadii.lgRadius,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _disabledPrimary,
              border: Border.all(color: _tradePrimary.withValues(alpha: .14)),
              borderRadius: AppRadii.lgRadius,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 13, color: AppColors.text3),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 12,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (badge)
            Positioned(
              top: -3,
              right: 5,
              child: Container(
                width: 16,
                height: 16,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.sell,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '1',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.onAccent,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SettingsChip extends StatelessWidget {
  const _SettingsChip();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ConvertPage.toolKey('settings'),
      onTap: () {},
      borderRadius: AppRadii.lgRadius,
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _disabledPrimary,
          border: Border.all(color: _tradePrimary.withValues(alpha: .14)),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.settings_outlined,
          color: AppColors.text3,
          size: 15,
        ),
      ),
    );
  }
}

class _PairMiniCard extends StatelessWidget {
  const _PairMiniCard({required this.fromSymbol, required this.toSymbol});

  final String fromSymbol;
  final String toSymbol;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _panelBackground,
        border: Border.all(color: AppColors.onAccent.withValues(alpha: .06)),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        children: [
          Text(
            '$fromSymbol/$toSymbol · 24h',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.show_chart_rounded, color: AppColors.buy, size: 15),
          const Spacer(),
          SizedBox(
            width: 72,
            height: 31,
            child: CustomPaint(painter: _SparklinePainter()),
          ),
          const SizedBox(width: 8),
          Text(
            '+0.62%',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.successAccentBright
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path();
    for (var i = 0; i < 28; i++) {
      final x = size.width * i / 27;
      final wave = math.sin(i * 1.45) * .33 + math.sin(i * 3.2) * .18;
      final y = size.height * (.50 - wave);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SlippageCard extends StatelessWidget {
  const _SlippageCard({
    required this.options,
    required this.active,
    required this.onChanged,
  });

  final List<double> options;
  final double active;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
      decoration: BoxDecoration(
        color: _panelBackground,
        border: Border.all(color: AppColors.onAccent.withValues(alpha: .06)),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.text3,
                size: 15,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Slippage tolerance',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Tùy chỉnh',
                style: AppTextStyles.micro.copyWith(
                  color: _tradePrimary,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (final option in options) ...[
                _SlippageChip(
                  key: ConvertPage.slippageKey(option.toString()),
                  label: '${option.toStringAsFixed(option % 1 == 0 ? 0 : 1)}%',
                  active: option == active,
                  onTap: () => onChanged(option),
                ),
                const SizedBox(width: 9),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _SlippageChip extends StatelessWidget {
  const _SlippageChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? _tradePrimary : _chipBackground,
          gradient: active
              ? const LinearGradient(colors: [_tradePrimary, _tradePrimaryDark])
              : null,
          border: Border.all(
            color: active
                ? _tradePrimary
                : _tradePrimary.withValues(alpha: .16),
          ),
          borderRadius: AppRadii.cardRadius,
          boxShadow: active
              ? [
                  BoxShadow(
                    color: _tradePrimary.withValues(alpha: .35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: active ? AppColors.onAccent : AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.enabled,
    required this.receipt,
    required this.onPressed,
  });

  final bool enabled;
  final TradeConvertReceipt? receipt;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final label = receipt == null
        ? (enabled ? 'Chuyển đổi ngay' : 'Nhập số lượng')
        : 'Đã gửi ${receipt!.convertId}';
    return InkWell(
      key: ConvertPage.submitKey,
      onTap: enabled ? onPressed : null,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: AppSpacing.inputHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? _tradePrimary : AppColors.surface3,
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: enabled
                ? AppColors.onAccent
                : AppColors.text3.withValues(alpha: .32),
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Giao dịch gần đây',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              fontSize: 16,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Icon(Icons.download_rounded, color: AppColors.text3, size: 13),
        const SizedBox(width: 4),
        Text(
          'Xuất',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(width: 12),
        Text(
          'Xem tất cả',
          style: AppTextStyles.micro.copyWith(
            color: _tradePrimary,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(width: 2),
        const Icon(Icons.chevron_right_rounded, color: _tradePrimary, size: 16),
      ],
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.records});

  final List<TradeConvertHistoryRecord> records;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _panelBackground,
        border: Border.all(color: AppColors.onAccent.withValues(alpha: .07)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          for (var i = 0; i < records.length; i++)
            ConvertHistoryRow(
              record: records[i],
              showDivider: i != records.length - 1,
            ),
        ],
      ),
    );
  }
}
