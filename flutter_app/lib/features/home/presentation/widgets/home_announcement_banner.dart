import 'dart:async';

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/home_page.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class HomeAnnouncementBanner extends StatefulWidget {
  const HomeAnnouncementBanner({
    super.key,
    required this.announcements,
    required this.onDismiss,
  });

  final List<HomeAnnouncement> announcements;
  final ValueChanged<HomeAnnouncement> onDismiss;

  @override
  State<HomeAnnouncementBanner> createState() => _HomeAnnouncementBannerState();
}

class _HomeAnnouncementBannerState extends State<HomeAnnouncementBanner> {
  static const _autoAdvanceInterval = Duration(seconds: 5);

  int _activeIndex = 0;
  Timer? _autoAdvanceTimer;

  @override
  void initState() {
    super.initState();
    _startAutoAdvance();
  }

  @override
  void didUpdateWidget(covariant HomeAnnouncementBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.announcements.length != widget.announcements.length) {
      _activeIndex = 0;
    } else if (_activeIndex >= widget.announcements.length) {
      _activeIndex = 0;
    }
    _startAutoAdvance();
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    super.dispose();
  }

  void _startAutoAdvance() {
    _autoAdvanceTimer?.cancel();
    if (widget.announcements.length <= 1) return;

    _autoAdvanceTimer = Timer.periodic(_autoAdvanceInterval, (_) {
      if (!mounted) return;
      setState(() {
        _activeIndex = (_activeIndex + 1) % widget.announcements.length;
      });
    });
  }

  void _showNextAnnouncement() {
    if (widget.announcements.length <= 1) return;
    setState(() {
      _activeIndex = (_activeIndex + 1) % widget.announcements.length;
    });
    _startAutoAdvance();
  }

  @override
  Widget build(BuildContext context) {
    final announcement = widget.announcements[_activeIndex];
    return VitAnnouncementBanner(
      key: HomePage.announcementKey,
      message: announcement.text,
      itemCount: widget.announcements.length,
      activeIndex: _activeIndex,
      variant: VitAnnouncementBannerVariant.compact,
      showCompactDots: true,
      icon: _announcementIcon(announcement.type),
      accentColor: _announcementColor(announcement.type),
      onTap: _showNextAnnouncement,
      onDismiss: () => widget.onDismiss(announcement),
    );
  }

  IconData _announcementIcon(HomeAnnouncementType type) {
    return switch (type) {
      HomeAnnouncementType.security => Icons.shield_outlined,
      HomeAnnouncementType.risk => Icons.warning_amber_rounded,
      HomeAnnouncementType.campaign => Icons.card_giftcard_rounded,
      HomeAnnouncementType.info => Icons.campaign_rounded,
    };
  }

  Color _announcementColor(HomeAnnouncementType type) {
    return switch (type) {
      HomeAnnouncementType.security => AppColors.info,
      HomeAnnouncementType.risk => AppColors.warn,
      HomeAnnouncementType.campaign => AppColors.primary,
      HomeAnnouncementType.info => AppColors.text2,
    };
  }
}
