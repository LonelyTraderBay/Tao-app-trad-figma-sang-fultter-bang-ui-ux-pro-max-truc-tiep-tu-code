part of 'profile_entities.dart';

/// One API key (permissions, IP whitelist, usage) shown on the API key
/// management screen.
final class ProfileApiKey {
  const ProfileApiKey({
    required this.id,
    required this.name,
    required this.key,
    required this.secret,
    required this.permissions,
    required this.ipWhitelist,
    required this.createdAt,
    required this.expiresAt,
    required this.lastUsed,
    required this.isActive,
    required this.requestCount,
  });

  final String id;
  final String name;
  final String key;
  final String secret;
  final List<String> permissions;
  final List<String> ipWhitelist;
  final String createdAt;
  final String? expiresAt;
  final String? lastUsed;
  final bool isActive;
  final int requestCount;

  ProfileApiKey copyWith({bool? isActive}) {
    return ProfileApiKey(
      id: id,
      name: name,
      key: key,
      secret: secret,
      permissions: permissions,
      ipWhitelist: ipWhitelist,
      createdAt: createdAt,
      expiresAt: expiresAt,
      lastUsed: lastUsed,
      isActive: isActive ?? this.isActive,
      requestCount: requestCount,
    );
  }
}

/// One selectable API scope/permission on the API key creation screen.
final class ProfileApiPermission {
  const ProfileApiPermission({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.colorHex,
    this.required = false,
  });

  final String id;
  final String label;
  final String description;
  final String iconKey;
  final int colorHex;
  final bool required;
}

/// One selectable API key expiry duration on the API key creation screen.
final class ProfileApiExpiryOption {
  const ProfileApiExpiryOption({
    required this.id,
    required this.label,
    required this.description,
  });

  final String id;
  final String label;
  final String description;
}

/// One security checklist/navigation row (e.g. 2FA) on the security
/// screen.
final class ProfileSecurityItem {
  const ProfileSecurityItem({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    this.status,
    this.statusHex,
    this.route,
    this.danger = false,
  });

  final String id;
  final String title;
  final String description;
  final String iconKey;
  final String? status;
  final int? statusHex;
  final String? route;
  final bool danger;
}

/// One logged-in device entry shown on the security screen's device list.
final class ProfileDevice {
  const ProfileDevice({
    required this.id,
    required this.name,
    required this.os,
    required this.location,
    required this.lastSeen,
    required this.isCurrent,
  });

  final String id;
  final String name;
  final String os;
  final String location;
  final String lastSeen;
  final bool isCurrent;
}

/// VIP-tier progress summary (current/next label, volume, progress
/// fraction) shown on the profile home screen.
final class ProfileVipProgress {
  const ProfileVipProgress({
    required this.label,
    required this.nextLabel,
    required this.volumeLabel,
    required this.progress,
  });

  final String label;
  final String nextLabel;
  final String volumeLabel;
  final double progress;
}

/// Prediction Markets activity summary (positions, open orders, P&L)
/// shown as a card on the profile home screen.
final class ProfilePredictionBlock {
  const ProfilePredictionBlock({
    required this.positions,
    required this.openOrders,
    required this.pnlLabel,
  });

  final int positions;
  final int openOrders;
  final String pnlLabel;
}

/// Points-only Arena activity summary (points, rooms, creator score)
/// shown as a card on the profile home screen.
final class ProfileArenaBlock {
  const ProfileArenaBlock({
    required this.pointsLabel,
    required this.rooms,
    required this.creatorScoreLabel,
  });

  final String pointsLabel;
  final int rooms;
  final String creatorScoreLabel;
}

/// One product quick-access shortcut (label/route/state) on the profile
/// home screen.
final class ProfileProductShortcut {
  const ProfileProductShortcut({
    required this.id,
    required this.label,
    required this.route,
    required this.iconKey,
    required this.stateLabel,
    required this.accentHex,
  });

  final String id;
  final String label;
  final String route;
  final String iconKey;
  final String stateLabel;
  final int accentHex;
}

/// One labeled group of [ProfileMenuItem]s on the profile home menu.
final class ProfileMenuSection {
  const ProfileMenuSection({
    required this.id,
    required this.label,
    required this.accentHex,
    required this.items,
  });

  final String id;
  final String label;
  final int accentHex;
  final List<ProfileMenuItem> items;
}

/// One navigable row (label/route/icon/optional subtitle) inside a
/// [ProfileMenuSection].
final class ProfileMenuItem {
  const ProfileMenuItem({
    required this.id,
    required this.label,
    required this.route,
    required this.iconKey,
    this.subtitle,
    this.subtitleHex,
  });

  final String id;
  final String label;
  final String route;
  final String iconKey;
  final String? subtitle;
  final int? subtitleHex;
}

/// One GOM legal/compliance document row under Profile › Pháp lý.
final class ProfileLegalItem {
  const ProfileLegalItem({
    required this.id,
    required this.label,
    required this.route,
  });

  final String id;
  final String label;
  final String route;
}

/// Accordion group of [ProfileLegalItem]s (Copy / Bot / P2P / …).
final class ProfileLegalGroup {
  const ProfileLegalGroup({
    required this.id,
    required this.label,
    required this.items,
  });

  final String id;
  final String label;
  final List<ProfileLegalItem> items;
}
