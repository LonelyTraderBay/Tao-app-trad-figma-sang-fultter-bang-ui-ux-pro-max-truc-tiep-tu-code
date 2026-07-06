import 'package:flutter/material.dart';

/// Hub tile descriptor for trade product launcher.
final class VitTradeHubItem {
  const VitTradeHubItem({
    required this.id,
    required this.label,
    required this.badge,
    required this.icon,
    required this.accentColor,
    required this.onTap,
    this.tileKey,
  });

  final String id;
  final String label;
  final String badge;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;
  final Key? tileKey;
}
