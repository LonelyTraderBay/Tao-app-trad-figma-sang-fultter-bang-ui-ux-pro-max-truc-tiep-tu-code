part of 'profile_entities.dart';

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
