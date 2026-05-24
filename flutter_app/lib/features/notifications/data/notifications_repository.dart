import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>((
  ref,
) {
  return const MockNotificationsRepository();
});

abstract interface class NotificationsRepository {
  NotificationsSnapshot getNotifications();
}

enum NotificationsScreenState { loading, empty, error, offline }

enum AppNotificationType {
  trade,
  deposit,
  withdraw,
  security,
  system,
  p2p,
  priceAlert,
  referral,
  arena,
}

final class NotificationsSnapshot {
  const NotificationsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.notifications,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final List<AppNotificationDraft> notifications;
  final String contractNotes;
  final Set<NotificationsScreenState> supportedStates;
}

final class AppNotificationDraft {
  const AppNotificationDraft({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    this.actionPath,
  });

  final String id;
  final AppNotificationType type;
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final String? actionPath;

  AppNotificationDraft copyWith({bool? isRead}) {
    return AppNotificationDraft(
      id: id,
      type: type,
      title: title,
      message: message,
      time: time,
      isRead: isRead ?? this.isRead,
      actionPath: actionPath,
    );
  }
}

final class MockNotificationsRepository implements NotificationsRepository {
  const MockNotificationsRepository();

  @override
  NotificationsSnapshot getNotifications() {
    return const NotificationsSnapshot(
      endpoint: '/api/mobile/notifications/notifications',
      actionDraft: 'PATCH /user/settings or module settings',
      title: 'Thông báo',
      subtitle: 'Thông báo · Hệ thống',
      backRoute: '/home',
      notifications: _notifications,
      contractNotes:
          'Notifications feed supports read/delete/filter local state. Backend should return notificationsReferenceData and screenState; read/delete actions become PATCH user settings or notification state.',
      supportedStates: {
        NotificationsScreenState.loading,
        NotificationsScreenState.empty,
        NotificationsScreenState.error,
        NotificationsScreenState.offline,
      },
    );
  }
}

const _notifications = [
  AppNotificationDraft(
    id: 'notif001',
    type: AppNotificationType.trade,
    title: 'Lệnh đã khớp',
    message: 'Lệnh mua 0.1 BTC @ \$67,543.21 đã được thực hiện thành công',
    time: '2 phút trước',
    isRead: false,
    actionPath: '/trade/orders',
  ),
  AppNotificationDraft(
    id: 'notif002',
    type: AppNotificationType.priceAlert,
    title: 'Cảnh báo giá',
    message: 'ETH đã vượt mức \$3,600 USDT',
    time: '15 phút trước',
    isRead: false,
    actionPath: '/pair/ethusdt',
  ),
  AppNotificationDraft(
    id: 'notif003',
    type: AppNotificationType.deposit,
    title: 'Nạp tiền thành công',
    message: '5,000 USDT đã được nạp vào tài khoản của bạn',
    time: '1 giờ trước',
    isRead: false,
    actionPath: '/wallet',
  ),
  AppNotificationDraft(
    id: 'notif004',
    type: AppNotificationType.security,
    title: 'Đăng nhập mới',
    message: 'Thiết bị mới đăng nhập từ Hồ Chí Minh, Việt Nam',
    time: '2 giờ trước',
    isRead: true,
    actionPath: '/profile/activity',
  ),
  AppNotificationDraft(
    id: 'notif005',
    type: AppNotificationType.p2p,
    title: 'P2P: Đơn hàng mới',
    message: 'CryptoKing_VN đã chấp nhận đơn P2P của bạn',
    time: '3 giờ trước',
    isRead: true,
    actionPath: '/p2p/order/p2p001',
  ),
  AppNotificationDraft(
    id: 'notif006',
    type: AppNotificationType.system,
    title: 'Bảo trì hệ thống',
    message: 'Hệ thống sẽ bảo trì vào 3h sáng ngày 24/02 (dự kiến 30 phút)',
    time: '1 ngày trước',
    isRead: true,
    actionPath: '/news',
  ),
  AppNotificationDraft(
    id: 'notif007',
    type: AppNotificationType.withdraw,
    title: 'Rút tiền đang xử lý',
    message: '1,000 USDT đang được xử lý, thời gian dự kiến 10 phút',
    time: '1 ngày trước',
    isRead: true,
    actionPath: '/wallet/history',
  ),
  AppNotificationDraft(
    id: 'notif008',
    type: AppNotificationType.referral,
    title: 'Bạn bè hoàn tất KYC',
    message:
        'Võ Thị L. đã xác minh danh tính thành công. Bạn nhận được 5.00 USDT thưởng KYC!',
    time: '2 ngày trước',
    isRead: false,
    actionPath: '/referral/rewards',
  ),
  AppNotificationDraft(
    id: 'notif009',
    type: AppNotificationType.referral,
    title: 'Hoa hồng giới thiệu',
    message:
        'Bạn nhận được +\$22.30 USDT hoa hồng từ giao dịch của Hoàng Đạt V.',
    time: '2 ngày trước',
    isRead: false,
    actionPath: '/referral/rewards',
  ),
  AppNotificationDraft(
    id: 'notif010',
    type: AppNotificationType.referral,
    title: 'Bạn bè mới đăng ký',
    message:
        'Bùi Anh K. đã đăng ký qua link giới thiệu của bạn. Nhắc họ hoàn tất KYC để nhận thưởng!',
    time: '3 ngày trước',
    isRead: true,
    actionPath: '/referral/history',
  ),
  AppNotificationDraft(
    id: 'notif011',
    type: AppNotificationType.arena,
    title: 'Challenge hoàn tất!',
    message:
        'BTC \$70K? - Tuần 8 đã kết thúc. Bạn đạt hạng #3 và nhận được 300 pts! Xem chi tiết.',
    time: '30 phút trước',
    isRead: false,
    actionPath: '/arena/challenge/ch001',
  ),
  AppNotificationDraft(
    id: 'notif012',
    type: AppNotificationType.arena,
    title: 'Có người tham gia phòng',
    message:
        'TraderX vừa tham gia "Fed Rate Predict - March 2026". Phòng còn 33 slots trống.',
    time: '1 giờ trước',
    isRead: false,
    actionPath: '/arena/challenge/room003',
  ),
  AppNotificationDraft(
    id: 'notif013',
    type: AppNotificationType.arena,
    title: 'Arena Points nhận được',
    message:
        'Bạn nhận 50 pts từ check-in hằng ngày và 120 pts từ khối lượng giao dịch. Tổng: +170 pts.',
    time: '5 giờ trước',
    isRead: true,
    actionPath: '/arena/points',
  ),
  AppNotificationDraft(
    id: 'notif014',
    type: AppNotificationType.arena,
    title: 'Challenge sắp hết hạn',
    message:
        'Altcoin Battle Royale kết thúc trong 2 giờ. Team SOL đang dẫn đầu!',
    time: '6 giờ trước',
    isRead: true,
    actionPath: '/arena/challenge/room002',
  ),
  AppNotificationDraft(
    id: 'notif015',
    type: AppNotificationType.arena,
    title: 'Mode mới được tạo',
    message:
        'CryptoMaster_VN vừa tạo mode "ETH Merge Anniversary Predict". Hãy thử ngay!',
    time: '1 ngày trước',
    isRead: true,
    actionPath: '/arena/mode/mode001',
  ),
];
