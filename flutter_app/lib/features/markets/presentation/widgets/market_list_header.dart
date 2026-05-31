import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

class MarketListHeader extends StatelessWidget {
  const MarketListHeader({super.key, required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Thị trường',
            style: AppTextStyles.pageTitle.copyWith(fontSize: 30, height: 1.15),
          ),
        ),
        _HeaderActionButton(
          icon: Icons.monitor_heart_outlined,
          tooltip: 'Tổng quan thị trường',
          onTap: () => onNavigate('/markets/overview'),
        ),
        const SizedBox(width: 8),
        _HeaderActionButton(
          icon: Icons.trending_up_rounded,
          tooltip: 'Biến động',
          onTap: () => onNavigate('/markets/movers'),
        ),
        const SizedBox(width: 8),
        _HeaderActionButton(
          icon: Icons.layers_rounded,
          tooltip: 'Ngành',
          onTap: () => onNavigate('/markets/sectors'),
        ),
      ],
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  const _HeaderActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.cardRadius,
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.surface2,
              borderRadius: AppRadii.cardRadius,
            ),
            child: Icon(icon, color: AppColors.text2, size: 17),
          ),
        ),
      ),
    );
  }
}
