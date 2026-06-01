import 'package:vit_trade_flutter/features/referral/domain/entities/referral_entities.dart';
import 'package:vit_trade_flutter/features/referral/domain/repositories/referral_repository.dart';
part 'mock_referral_repository_overview_fixtures.dart';
part 'mock_referral_repository_campaign_fixtures.dart';
part 'mock_referral_repository_reward_fixtures.dart';
part 'mock_referral_repository_social_fixtures.dart';

final class MockReferralRepository implements ReferralRepository {
  const MockReferralRepository();

  @override
  ReferralHomeSnapshot getHome() {
    final stats = ReferralHomeStatsDraft(
      totalFriends: _friends.length,
      kycCompleted: _friends.where((friend) => friend.kycCompleted).length,
      activeFriends: _friends
          .where((friend) => friend.status == ReferralFriendStatus.activeTrader)
          .length,
      totalCommission: _completedRewardTotal,
      pendingCommission: _pendingRewardTotal,
      totalVolume: _friends.fold(
        0.0,
        (sum, friend) => sum + friend.totalVolume,
      ),
      thisMonthCommission: 421,
      thisMonthFriends: 2,
    );

    return ReferralHomeSnapshot(
      endpoint: '/api/mobile/referral/referral',
      actionDraft: 'read-only or local navigation action',
      title: 'Giới thiệu bạn bè',
      subtitle: 'Chương trình · Referral',
      backRoute: '/home',
      referralCode: 'VITTA-A2B3C',
      referralLink: 'https://vittrade.vn/ref/VITTA-A2B3C',
      stats: stats,
      currentTier: _tierRules[1],
      nextTier: _tierRules[2],
      campaign: _activeCampaign,
      socialProof: _socialProof,
      milestones: _milestones,
      pendingCommissions: _pendingCommissions,
      leaderboard: _leaderboard,
      detailLinks: [
        ReferralDetailLinkDraft(
          id: 'friends',
          title: 'Bạn bè đã mời (${stats.totalFriends})',
          subtitle: '${stats.kycCompleted} đã KYC',
          route: '/referral/history',
        ),
        ReferralDetailLinkDraft(
          id: 'rewards',
          title: 'Phần thưởng',
          subtitle:
              '${_formatUsd(_completedRewardTotal)} tổng tích luỹ · ${_formatUsd(_pendingRewardTotal)} đang chờ',
          route: '/referral/rewards',
        ),
        ReferralDetailLinkDraft(
          id: 'rules',
          title: 'Bảng hạng & Điều khoản',
          subtitle: 'Hạng hiện tại: Bạc (Silver)',
          route: '/referral/rules',
        ),
      ],
      howItWorks: [
        const ReferralStepDraft(
          step: 1,
          title: 'Chia sẻ link',
          description:
              'Gửi link giới thiệu cho bạn bè qua Zalo, Facebook, Telegram',
        ),
        const ReferralStepDraft(
          step: 2,
          title: 'Bạn bè đăng ký & KYC',
          description: 'Cả hai nhận thưởng 8.00 USDT',
        ),
        const ReferralStepDraft(
          step: 3,
          title: 'Bạn bè giao dịch',
          description: 'Bạn bè bắt đầu trade trên VitTrade',
        ),
        const ReferralStepDraft(
          step: 4,
          title: 'Nhận hoa hồng vĩnh viễn',
          description: '25% phí GD, real-time, không giới hạn',
        ),
      ],
      campaignHistory: _campaignHistory,
      contractNotes:
          'Referral home is a read-only referral hub. Copy/share, calculator, and navigation actions stay local until backend integration.',
      supportedStates: const {
        ReferralScreenState.loading,
        ReferralScreenState.empty,
        ReferralScreenState.error,
        ReferralScreenState.offline,
      },
    );
  }

  @override
  ReferralHistorySnapshot getHistory({
    ReferralFriendFilter filter = ReferralFriendFilter.all,
    ReferralHistorySort sort = ReferralHistorySort.date,
    String query = '',
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    final filtered = _friends
        .where((friend) => _matchesFilter(friend, filter))
        .where(
          (friend) =>
              normalizedQuery.isEmpty ||
              friend.name.toLowerCase().contains(normalizedQuery),
        )
        .toList();

    filtered.sort((a, b) {
      return switch (sort) {
        ReferralHistorySort.commission => b.totalCommission.compareTo(
          a.totalCommission,
        ),
        ReferralHistorySort.volume => b.totalVolume.compareTo(a.totalVolume),
        ReferralHistorySort.date => 0,
      };
    });

    return ReferralHistorySnapshot(
      endpoint: '/api/mobile/referral/referral-history',
      actionDraft: 'read-only or local navigation action',
      title: 'Lịch sử giới thiệu',
      subtitle: 'Lịch sử · Referral',
      backRoute: '/referral',
      searchHint: 'Tìm bạn bè...',
      stats: ReferralStatsDraft(
        totalFriends: _friends.length,
        kycCompleted: _friends.where((friend) => friend.kycCompleted).length,
        activeFriends: _friends
            .where(
              (friend) => friend.status == ReferralFriendStatus.activeTrader,
            )
            .length,
      ),
      filters: _buildFilters(),
      sortOptions: const [
        ReferralSortDraft(
          sort: ReferralHistorySort.date,
          label: 'Ngày tham gia',
        ),
        ReferralSortDraft(
          sort: ReferralHistorySort.commission,
          label: 'Hoa hồng',
        ),
        ReferralSortDraft(
          sort: ReferralHistorySort.volume,
          label: 'Khối lượng',
        ),
      ],
      friends: filtered,
      filter: filter,
      sort: sort,
      query: query,
      contractNotes:
          'Referral history is read-only; reminder actions are local notification drafts until backend wiring.',
      supportedStates: const {
        ReferralScreenState.loading,
        ReferralScreenState.empty,
        ReferralScreenState.error,
        ReferralScreenState.offline,
      },
    );
  }

  @override
  ReferralRewardsSnapshot getRewards({
    ReferralRewardFilter filter = ReferralRewardFilter.all,
    ReferralRewardSort sort = ReferralRewardSort.date,
  }) {
    final records = _rewardRecords
        .where((record) => _matchesRewardFilter(record, filter))
        .toList();

    records.sort((a, b) {
      return switch (sort) {
        ReferralRewardSort.amount => b.amount.compareTo(a.amount),
        ReferralRewardSort.date => 0,
      };
    });

    final completed = records
        .where((record) => record.status == ReferralRewardStatus.completed)
        .length;
    final pending = records
        .where((record) => record.status == ReferralRewardStatus.pending)
        .length;

    return ReferralRewardsSnapshot(
      endpoint: '/api/mobile/referral/referral-rewards',
      actionDraft: 'read-only or local navigation action',
      title: 'Phần thưởng',
      subtitle: 'Phần thưởng · Referral',
      backRoute: '/referral',
      totalCommission: _completedRewardTotal,
      pendingCommission: _pendingRewardTotal,
      kycBonusTotal: _kycBonusTotal,
      tradeCommissionTotal: _tradeCommissionTotal,
      thisMonthCommission: 421,
      tierName: 'Bạc',
      tierNameEn: 'Silver',
      chartPoints: _chartPoints,
      filters: const [
        ReferralRewardFilterDraft(
          filter: ReferralRewardFilter.all,
          label: 'Tất cả',
        ),
        ReferralRewardFilterDraft(
          filter: ReferralRewardFilter.kycBonus,
          label: 'Thưởng KYC',
        ),
        ReferralRewardFilterDraft(
          filter: ReferralRewardFilter.tradeCommission,
          label: 'Hoa hồng GD',
        ),
      ],
      sortOptions: const [
        ReferralRewardSortDraft(
          sort: ReferralRewardSort.date,
          label: 'Mới nhất',
        ),
        ReferralRewardSortDraft(
          sort: ReferralRewardSort.amount,
          label: 'Số tiền',
        ),
      ],
      records: records,
      filter: filter,
      sort: sort,
      completedCount: completed,
      pendingCount: pending,
      exportRanges: _exportRanges,
      disputeTypes: _disputeTypes,
      disputes: _disputes,
      contractNotes:
          'Referral rewards is a read-only ledger. Export and dispute reporting are local action drafts until backend integration.',
      supportedStates: const {
        ReferralScreenState.loading,
        ReferralScreenState.empty,
        ReferralScreenState.error,
        ReferralScreenState.offline,
      },
    );
  }

  @override
  ReferralRulesSnapshot getRules() {
    return ReferralRulesSnapshot(
      endpoint: '/api/mobile/referral/referral-rules',
      actionDraft: 'read-only or local navigation action',
      title: 'Quy tắc chương trình',
      subtitle: 'Quy tắc · Referral',
      backRoute: '/referral',
      tiers: _tierRules,
      rewardTypes: _rewardTypeRules,
      terms: _programTerms,
      faqs: _ruleFaqs,
      disclaimer:
          'Chương trình giới thiệu không được sử dụng cho mục đích quảng cáo sai lệch. VitTrade không cam kết lợi nhuận từ giao dịch. Thưởng giới thiệu chỉ dựa trên phí giao dịch, không liên quan đến kết quả đầu tư.',
      currentTierIndex: 1,
      contractNotes:
          'Referral rules is a read-only reference surface. Backend should return tier, reward, term, FAQ, disclaimer, and screen state data.',
      supportedStates: const {
        ReferralScreenState.loading,
        ReferralScreenState.empty,
        ReferralScreenState.error,
        ReferralScreenState.offline,
      },
    );
  }

  @override
  ReferralFriendDetailSnapshot getFriendDetail(String friendId) {
    return ReferralFriendDetailSnapshot(
      endpoint: '/api/mobile/referral/referral-friend-$friendId',
      actionDraft: 'read-only or local navigation action',
      title: 'Chi tiết bạn bè',
      subtitle: 'Bạn bè · Referral',
      backRoute: '/referral/history',
      friendId: friendId,
      found: false,
      emptyTitle: 'Không tìm thấy bạn bè',
      emptyMessage: 'ID không hợp lệ hoặc đã bị xóa',
      listRoute: '/referral/history',
      contractNotes:
          'SC-289 preserves the Flutter not-found state for friend001, where the route id does not resolve to a referral friend.',
      supportedStates: const {
        ReferralScreenState.loading,
        ReferralScreenState.empty,
        ReferralScreenState.error,
        ReferralScreenState.offline,
      },
    );
  }

  bool _matchesFilter(ReferralFriendDraft friend, ReferralFriendFilter filter) {
    return switch (filter) {
      ReferralFriendFilter.all => true,
      ReferralFriendFilter.activeTrader =>
        friend.status == ReferralFriendStatus.activeTrader,
      ReferralFriendFilter.kycDone =>
        friend.status == ReferralFriendStatus.kycDone,
      ReferralFriendFilter.pendingKyc =>
        friend.status == ReferralFriendStatus.pendingKyc,
    };
  }

  bool _matchesRewardFilter(
    ReferralRewardRecordDraft record,
    ReferralRewardFilter filter,
  ) {
    return switch (filter) {
      ReferralRewardFilter.all => true,
      ReferralRewardFilter.kycBonus =>
        record.type == ReferralRewardType.kycBonus,
      ReferralRewardFilter.tradeCommission =>
        record.type == ReferralRewardType.tradeCommission,
    };
  }
}
