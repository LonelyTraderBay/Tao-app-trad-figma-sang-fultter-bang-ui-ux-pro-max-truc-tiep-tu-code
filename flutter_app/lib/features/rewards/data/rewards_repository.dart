import 'package:flutter_riverpod/flutter_riverpod.dart';

final rewardsRepositoryProvider = Provider<RewardsRepository>((ref) {
  return const MockRewardsRepository();
});

abstract interface class RewardsRepository {
  RewardsHubSnapshot getHub();
}

enum RewardsScreenState { loading, empty, error, offline }

enum RewardTaskStatus { active, completed, claimed }

enum RewardAccentKind {
  daily,
  weekly,
  flash,
  learn,
  achievement,
  arena,
  p2p,
  referral,
  neutral,
}

final class RewardsHubSnapshot {
  const RewardsHubSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.referralRoute,
    required this.leaderboardRoute,
    required this.summary,
    required this.categories,
    required this.checkIns,
    required this.filters,
    required this.tasks,
    required this.bonusRows,
    required this.leaderboard,
    required this.disclaimer,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final String referralRoute;
  final String leaderboardRoute;
  final RewardSummaryDraft summary;
  final List<RewardCategoryDraft> categories;
  final List<RewardCheckInDraft> checkIns;
  final List<String> filters;
  final List<RewardTaskDraft> tasks;
  final List<RewardBonusDraft> bonusRows;
  final List<RewardLeaderboardDraft> leaderboard;
  final String disclaimer;
  final String contractNotes;
  final Set<RewardsScreenState> supportedStates;
}

final class RewardSummaryDraft {
  const RewardSummaryDraft({
    required this.usdtClaimed,
    required this.currentPoints,
    required this.lockedPoints,
    required this.rank,
    required this.topPercent,
    required this.claimedCount,
    required this.pendingCount,
    required this.pendingUsdt,
    required this.pendingPoints,
    required this.expiringCount,
    required this.completionLabel,
    required this.tierLabel,
  });

  final String usdtClaimed;
  final int currentPoints;
  final int lockedPoints;
  final int rank;
  final int topPercent;
  final int claimedCount;
  final int pendingCount;
  final String pendingUsdt;
  final int pendingPoints;
  final int expiringCount;
  final String completionLabel;
  final String tierLabel;
}

final class RewardCategoryDraft {
  const RewardCategoryDraft({
    required this.id,
    required this.label,
    required this.done,
    required this.total,
    required this.pending,
    required this.kind,
  });

  final String id;
  final String label;
  final int done;
  final int total;
  final int pending;
  final RewardAccentKind kind;
}

final class RewardCheckInDraft {
  const RewardCheckInDraft({
    required this.day,
    required this.label,
    required this.reward,
    required this.claimed,
    required this.today,
  });

  final int day;
  final String label;
  final String reward;
  final bool claimed;
  final bool today;
}

final class RewardTaskDraft {
  const RewardTaskDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.filter,
    required this.status,
    required this.progress,
    required this.rewardLabel,
    required this.kind,
  });

  final String id;
  final String title;
  final String subtitle;
  final String filter;
  final RewardTaskStatus status;
  final double progress;
  final String rewardLabel;
  final RewardAccentKind kind;
}

final class RewardBonusDraft {
  const RewardBonusDraft({
    required this.title,
    required this.subtitle,
    required this.rewardLabel,
    required this.kind,
  });

  final String title;
  final String subtitle;
  final String rewardLabel;
  final RewardAccentKind kind;
}

final class RewardLeaderboardDraft {
  const RewardLeaderboardDraft({
    required this.rank,
    required this.name,
    required this.pointsLabel,
  });

  final int rank;
  final String name;
  final String pointsLabel;
}

final class MockRewardsRepository implements RewardsRepository {
  const MockRewardsRepository();

  @override
  RewardsHubSnapshot getHub() {
    return const RewardsHubSnapshot(
      endpoint: '/api/mobile/rewards/rewards',
      actionDraft: 'read-only or local navigation action',
      title: 'Trung tâm Phần thưởng',
      subtitle: 'Phần thưởng · Rewards',
      backRoute: '/home',
      referralRoute: '/referral',
      leaderboardRoute: '/arena/leaderboard',
      summary: RewardSummaryDraft(
        usdtClaimed: '35.0',
        currentPoints: 2220,
        lockedPoints: 450,
        rank: 142,
        topPercent: 5,
        claimedCount: 5,
        pendingCount: 3,
        pendingUsdt: '5.5',
        pendingPoints: 130,
        expiringCount: 8,
        completionLabel: '5/24 · 21%',
        tierLabel: 'Bạc',
      ),
      categories: [
        RewardCategoryDraft(
          id: 'daily',
          label: 'Hằng ngày',
          done: 2,
          total: 5,
          pending: 2,
          kind: RewardAccentKind.daily,
        ),
        RewardCategoryDraft(
          id: 'weekly',
          label: 'Hằng tuần',
          done: 0,
          total: 5,
          pending: 0,
          kind: RewardAccentKind.weekly,
        ),
        RewardCategoryDraft(
          id: 'flash',
          label: 'Flash',
          done: 0,
          total: 3,
          pending: 0,
          kind: RewardAccentKind.flash,
        ),
        RewardCategoryDraft(
          id: 'learn',
          label: 'Học',
          done: 1,
          total: 4,
          pending: 1,
          kind: RewardAccentKind.learn,
        ),
        RewardCategoryDraft(
          id: 'achievement',
          label: 'Thành tựu',
          done: 4,
          total: 4,
          pending: 0,
          kind: RewardAccentKind.achievement,
        ),
        RewardCategoryDraft(
          id: 'arena',
          label: 'Arena',
          done: 1,
          total: 3,
          pending: 0,
          kind: RewardAccentKind.arena,
        ),
      ],
      checkIns: [
        RewardCheckInDraft(
          day: 1,
          label: 'N1',
          reward: '+10',
          claimed: true,
          today: false,
        ),
        RewardCheckInDraft(
          day: 2,
          label: 'N2',
          reward: '+15',
          claimed: true,
          today: false,
        ),
        RewardCheckInDraft(
          day: 3,
          label: 'N3',
          reward: '+20',
          claimed: true,
          today: false,
        ),
        RewardCheckInDraft(
          day: 4,
          label: 'N4',
          reward: '+25',
          claimed: true,
          today: false,
        ),
        RewardCheckInDraft(
          day: 5,
          label: 'Hôm nay',
          reward: '+30',
          claimed: false,
          today: true,
        ),
        RewardCheckInDraft(
          day: 6,
          label: 'N6',
          reward: '+40',
          claimed: false,
          today: false,
        ),
        RewardCheckInDraft(
          day: 7,
          label: 'N7',
          reward: '+100',
          claimed: false,
          today: false,
        ),
      ],
      filters: ['Tất cả', 'Flash', 'Học', 'Hằng ngày', 'P2P', 'Arena'],
      tasks: [
        RewardTaskDraft(
          id: 'task-volume',
          title: 'Volume tuần \$10K',
          subtitle: 'Đạt khối lượng giao dịch \$10,000 trong tuần',
          filter: 'Hằng ngày',
          status: RewardTaskStatus.active,
          progress: .58,
          rewardLabel: '+5 USDT · +50 pts',
          kind: RewardAccentKind.daily,
        ),
        RewardTaskDraft(
          id: 'task-limit',
          title: 'Giao dịch 10 cặp khác nhau',
          subtitle: 'Giao dịch ít nhất 10 cặp coin khác nhau',
          filter: 'Hằng ngày',
          status: RewardTaskStatus.active,
          progress: .68,
          rewardLabel: '+2 USDT · +100 pts',
          kind: RewardAccentKind.daily,
        ),
        RewardTaskDraft(
          id: 'task-referral',
          title: 'Mời bạn bè',
          subtitle: 'Mời 3 bạn bè đăng ký VitTrade tuần này',
          filter: 'Tất cả',
          status: RewardTaskStatus.active,
          progress: .33,
          rewardLabel: '+15 USDT · +100 pts',
          kind: RewardAccentKind.referral,
        ),
        RewardTaskDraft(
          id: 'task-streak',
          title: 'Streak 7 ngày',
          subtitle: 'Đăng nhập 7 ngày liên tiếp để nhận bonus',
          filter: 'Hằng ngày',
          status: RewardTaskStatus.active,
          progress: .71,
          rewardLabel: '+5 USDT · +100 pts',
          kind: RewardAccentKind.daily,
        ),
        RewardTaskDraft(
          id: 'task-spot',
          title: 'Giao dịch 5 lệnh Spot',
          subtitle: 'Hoàn thành 5 lệnh giao dịch Spot trong ngày',
          filter: 'Hằng ngày',
          status: RewardTaskStatus.active,
          progress: .40,
          rewardLabel: '+1 USDT · +50 pts',
          kind: RewardAccentKind.daily,
        ),
        RewardTaskDraft(
          id: 'task-flash-muc',
          title: 'Flash: Mua BTC hôm nay',
          subtitle: 'Mua tối thiểu 0.01 BTC trong 4 giờ tới',
          filter: 'Flash',
          status: RewardTaskStatus.active,
          progress: 0,
          rewardLabel: '+3 USDT · +100 pts',
          kind: RewardAccentKind.flash,
        ),
        RewardTaskDraft(
          id: 'task-flash-p2p',
          title: 'Flash 3 lệnh P2P liên tiếp',
          subtitle: 'Hoàn thành 3 lệnh P2P trong 6 giờ',
          filter: 'Flash',
          status: RewardTaskStatus.active,
          progress: .33,
          rewardLabel: '+12 USDT · +200 pts',
          kind: RewardAccentKind.flash,
        ),
        RewardTaskDraft(
          id: 'task-flash-volume',
          title: 'Flash: Volume 50K nhanh',
          subtitle: 'Đạt \$50,000 volume trong 8 giờ tới',
          filter: 'Flash',
          status: RewardTaskStatus.active,
          progress: .82,
          rewardLabel: '+8 USDT · +150 pts',
          kind: RewardAccentKind.flash,
        ),
        RewardTaskDraft(
          id: 'task-checkin',
          title: 'Đăng nhập hằng ngày',
          subtitle: 'Đăng nhập mỗi ngày để nhận thưởng đều',
          filter: 'Hằng ngày',
          status: RewardTaskStatus.completed,
          progress: 1,
          rewardLabel: '+0.5 USDT · +30 pts',
          kind: RewardAccentKind.daily,
        ),
        RewardTaskDraft(
          id: 'task-p2p',
          title: 'Giao dịch P2P',
          subtitle: 'Hoàn thành 1 giao dịch P2P trong ngày',
          filter: 'P2P',
          status: RewardTaskStatus.completed,
          progress: 1,
          rewardLabel: '+1 USDT · +40 pts',
          kind: RewardAccentKind.p2p,
        ),
        RewardTaskDraft(
          id: 'task-quiz',
          title: 'Quiz: Blockchain cơ bản',
          subtitle: 'Trả lời đúng 5 câu hỏi về blockchain',
          filter: 'Học',
          status: RewardTaskStatus.completed,
          progress: 1,
          rewardLabel: '+2 USDT · +50 pts',
          kind: RewardAccentKind.learn,
        ),
        RewardTaskDraft(
          id: 'task-wallet',
          title: 'Giữ \$500 trong Wallet',
          subtitle: 'Duy trì tối thiểu \$500 trong 7 ngày',
          filter: 'Tất cả',
          status: RewardTaskStatus.active,
          progress: .75,
          rewardLabel: '+10 USDT · +200 pts',
          kind: RewardAccentKind.neutral,
        ),
        RewardTaskDraft(
          id: 'task-mode',
          title: 'Tạo mode mới',
          subtitle: 'Tạo 1 mode mới và có ít nhất 4 người clone',
          filter: 'Arena',
          status: RewardTaskStatus.active,
          progress: .40,
          rewardLabel: '+200 pts',
          kind: RewardAccentKind.arena,
        ),
        RewardTaskDraft(
          id: 'task-thang3',
          title: 'Thắng 3 challenge',
          subtitle: 'Thắng 3 challenge bất kỳ',
          filter: 'Arena',
          status: RewardTaskStatus.active,
          progress: .67,
          rewardLabel: '+300 pts',
          kind: RewardAccentKind.arena,
        ),
        RewardTaskDraft(
          id: 'task-defi',
          title: 'Bài học DeFi là gì?',
          subtitle: 'Xem video 3 phút và trả lời quiz',
          filter: 'Học',
          status: RewardTaskStatus.active,
          progress: .50,
          rewardLabel: '+1.5 USDT · +50 pts',
          kind: RewardAccentKind.learn,
        ),
        RewardTaskDraft(
          id: 'task-an-toan',
          title: 'Quiz: An toàn P2P',
          subtitle: 'Hoàn thành bài kiểm tra an toàn P2P',
          filter: 'Học',
          status: RewardTaskStatus.active,
          progress: .60,
          rewardLabel: '+1.5 USDT · +50 pts',
          kind: RewardAccentKind.learn,
        ),
        RewardTaskDraft(
          id: 'task-risk',
          title: 'Bài học: Staking & Yield',
          subtitle: 'Tìm hiểu cách đánh giá rủi ro staking',
          filter: 'Học',
          status: RewardTaskStatus.active,
          progress: .50,
          rewardLabel: '+1.5 USDT · +50 pts',
          kind: RewardAccentKind.learn,
        ),
        RewardTaskDraft(
          id: 'task-share',
          title: 'Chia sẻ kết quả giao dịch',
          subtitle: 'Share 1 kết quả giao dịch lên mạng xã hội',
          filter: 'Tất cả',
          status: RewardTaskStatus.active,
          progress: .67,
          rewardLabel: '+1.5 USDT · +25 pts',
          kind: RewardAccentKind.neutral,
        ),
        RewardTaskDraft(
          id: 'task-danh-gia',
          title: 'Đánh giá người bán P2P',
          subtitle: 'Để lại đánh giá cho 3 người bán P2P',
          filter: 'P2P',
          status: RewardTaskStatus.active,
          progress: .67,
          rewardLabel: '+1.5 USDT · +35 pts',
          kind: RewardAccentKind.p2p,
        ),
        RewardTaskDraft(
          id: 'task-first',
          title: 'Giao dịch đầu tiên',
          subtitle: 'Thực hiện giao dịch đầu tiên trên VitTrade',
          filter: 'Tất cả',
          status: RewardTaskStatus.claimed,
          progress: 1,
          rewardLabel: 'Đã nhận',
          kind: RewardAccentKind.achievement,
        ),
        RewardTaskDraft(
          id: 'task-deposit',
          title: 'Nạp tiền lần đầu',
          subtitle: 'Nạp tối thiểu \$100 lần đầu tiên',
          filter: 'Tất cả',
          status: RewardTaskStatus.claimed,
          progress: 1,
          rewardLabel: 'Đã nhận',
          kind: RewardAccentKind.achievement,
        ),
        RewardTaskDraft(
          id: 'task-2fa',
          title: 'Bật 2FA',
          subtitle: 'Kích hoạt xác thực 2 lớp cho tài khoản',
          filter: 'Tất cả',
          status: RewardTaskStatus.claimed,
          progress: 1,
          rewardLabel: 'Đã nhận',
          kind: RewardAccentKind.achievement,
        ),
        RewardTaskDraft(
          id: 'task-kyc',
          title: 'KYC Level 2',
          subtitle: 'Hoàn tất xác minh danh tính cấp 2',
          filter: 'Tất cả',
          status: RewardTaskStatus.claimed,
          progress: 1,
          rewardLabel: 'Đã nhận',
          kind: RewardAccentKind.achievement,
        ),
        RewardTaskDraft(
          id: 'task-join',
          title: 'Tham gia challenge',
          subtitle: 'Tham gia ít nhất 1 challenge trong tuần',
          filter: 'Arena',
          status: RewardTaskStatus.claimed,
          progress: 1,
          rewardLabel: 'Đã nhận',
          kind: RewardAccentKind.arena,
        ),
      ],
      bonusRows: [
        RewardBonusDraft(
          title: 'Vòng quay may mắn',
          subtitle: '1 lượt quay miễn phí hôm nay',
          rewardLabel: '1 lượt',
          kind: RewardAccentKind.achievement,
        ),
        RewardBonusDraft(
          title: 'Mystery Box',
          subtitle: 'Mở hộp khi hoàn thành 5 nhiệm vụ',
          rewardLabel: 'Có thể mở',
          kind: RewardAccentKind.flash,
        ),
        RewardBonusDraft(
          title: 'Combo multiplier',
          subtitle: 'Hoàn thành nhiệm vụ liên tiếp để tăng thưởng',
          rewardLabel: 'x1.5',
          kind: RewardAccentKind.arena,
        ),
      ],
      leaderboard: [
        RewardLeaderboardDraft(
          rank: 1,
          name: 'CryptoWhale',
          pointsLabel: '15.9K',
        ),
        RewardLeaderboardDraft(
          rank: 2,
          name: 'PredictorPro',
          pointsLabel: '15.1K',
        ),
        RewardLeaderboardDraft(
          rank: 3,
          name: 'ArenaKing',
          pointsLabel: '12.8K',
        ),
      ],
      disclaimer:
          'Phần thưởng USDT và Arena Points được tính dựa trên hoạt động thực tế. Arena Points không phải tài sản tài chính, ví giao dịch hoặc PnL.',
      contractNotes:
          'Rewards Hub is read-only for reference data. Claim, referral, leaderboard, and redeem buttons remain local navigation or local state until backend confirms action APIs.',
      supportedStates: {
        RewardsScreenState.loading,
        RewardsScreenState.empty,
        RewardsScreenState.error,
        RewardsScreenState.offline,
      },
    );
  }
}
