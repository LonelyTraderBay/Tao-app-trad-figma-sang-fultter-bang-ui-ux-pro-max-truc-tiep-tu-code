part of '../pages/advanced_tools_demo_page.dart';

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      borderColor: _toolsPrimary.withValues(alpha: .30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconTile(
            icon: Icons.bolt_rounded,
            color: _toolsPrimary,
            size: AppSpacing.tradeToolIconTileSm,
          ),
          const SizedBox(width: AppSpacing.tradeToolCardGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phase 3: Advanced Trading Tools',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  '3 công cụ nâng cao cho pro traders: trade nhanh hơn với ladder, quản lý nhiều lệnh cùng lúc, và shortcuts để tăng tốc 3x.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature, required this.onTap});

  final TradeAdvancedToolFeature feature;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(feature.colorHex);
    return InkWell(
      key: AdvancedToolsDemoPage.featureKey(feature.id),
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: _Panel(
        padding: AppSpacing.tradeToolRiskIntroPadding,
        child: Row(
          children: [
            _IconTile(
              icon: _iconFor(feature.id),
              color: color,
              size: AppSpacing.tradeToolIconTileMd,
            ),
            const SizedBox(width: AppSpacing.tradeToolCardGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature.title,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    feature.description,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.tradeToolInlineGap),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String id) {
    return switch (id) {
      'bulk' => Icons.check_box_rounded,
      'shortcuts' => Icons.keyboard_rounded,
      _ => Icons.track_changes_rounded,
    };
  }
}

class _SpeedCard extends StatelessWidget {
  const _SpeedCard();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      borderColor: AppColors.buy.withValues(alpha: .30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.trending_up_rounded, color: AppColors.buy, size: 18),
          const SizedBox(width: AppSpacing.tradeToolIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trading Speed: 3x Faster',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Pro traders sử dụng Phase 3 tools đặt lệnh trung bình 3-5 giây thay vì 10-15 giây. Master shortcuts để trade nhanh như market makers.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitsCard extends StatelessWidget {
  const _BenefitsCard();

  static const _items = [
    (
      Icons.flash_on_rounded,
      'Ladder: 1-click orders',
      'Không cần nhập giá, click trực tiếp trên DOM',
    ),
    (
      Icons.inventory_2_rounded,
      'Bulk: Manage 100+ orders',
      'Select all -> Cancel/Modify hàng loạt',
    ),
    (
      Icons.keyboard_rounded,
      'Shortcuts: Muscle memory',
      'F1/F2 để buy/sell, ESC panic close',
    ),
    (
      Icons.track_changes_rounded,
      'Precision + Speed',
      'Vừa nhanh vừa chính xác, như pro traders',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Advanced Tools Benefits',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeToolCardGap),
          for (final item in _items) ...[
            _BenefitItem(icon: item.$1, title: item.$2, description: item.$3),
            if (item != _items.last)
              const SizedBox(height: AppSpacing.tradeToolCardGap),
          ],
        ],
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  const _BenefitItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _toolsPrimary, size: 18),
        const SizedBox(width: AppSpacing.tradeToolIconGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
              const SizedBox(height: AppSpacing.tradeToolMicroGap),
              Text(
                description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.items});

  final List<TradeRiskStatusItem> items;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Phase 3 Progress',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeToolCardGap),
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
                _StatusPill(complete: item.complete),
              ],
            ),
            if (item != items.last)
              const SizedBox(height: AppSpacing.tradeToolInlineGap),
          ],
        ],
      ),
    );
  }
}
