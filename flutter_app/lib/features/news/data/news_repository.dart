import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final newsRepositoryProvider = Provider<NewsRepository>(
  (_) => const MockNewsRepository(),
);

abstract interface class NewsRepository {
  NewsScreenSnapshot getNews({NewsArticleType? type});
}

enum NewsArticleType {
  maintenance,
  newFeature,
  promotion,
  security,
  listing,
  general,
}

extension NewsArticleTypeConfig on NewsArticleType {
  String get label => switch (this) {
    NewsArticleType.maintenance => 'Bảo trì',
    NewsArticleType.newFeature => 'Tính năng mới',
    NewsArticleType.promotion => 'Khuyến mãi',
    NewsArticleType.security => 'Bảo mật',
    NewsArticleType.listing => 'Niêm yết',
    NewsArticleType.general => 'Tổng hợp',
  };

  String get emoji => switch (this) {
    NewsArticleType.maintenance => '⚙️',
    NewsArticleType.newFeature => '✨',
    NewsArticleType.promotion => '🎉',
    NewsArticleType.security => '🔐',
    NewsArticleType.listing => '📊',
    NewsArticleType.general => '📰',
  };

  Color get color => switch (this) {
    NewsArticleType.maintenance => const Color(0xFF8B95B3),
    NewsArticleType.newFeature => const Color(0xFF3B82F6),
    NewsArticleType.promotion => const Color(0xFF10B981),
    NewsArticleType.security => const Color(0xFFEF4444),
    NewsArticleType.listing => const Color(0xFFF59E0B),
    NewsArticleType.general => const Color(0xFF8B5CF6),
  };
}

enum NewsScreenState { loading, empty, error, offline, ready }

final class NewsReferenceData {
  const NewsReferenceData({
    required this.endpoint,
    required this.filters,
    required this.lastUpdatedLabel,
  });

  final String endpoint;
  final List<NewsArticleType> filters;
  final String lastUpdatedLabel;
}

final class NewsScreenSnapshot {
  const NewsScreenSnapshot({
    required this.articles,
    required this.pinnedArticles,
    required this.normalArticles,
    required this.newsReferenceData,
    required this.screenState,
    required this.supportedStates,
  });

  final List<NewsArticle> articles;
  final List<NewsArticle> pinnedArticles;
  final List<NewsArticle> normalArticles;
  final NewsReferenceData newsReferenceData;
  final NewsScreenState screenState;
  final List<NewsScreenState> supportedStates;
}

final class NewsArticle {
  const NewsArticle({
    required this.id,
    required this.type,
    required this.title,
    required this.summary,
    required this.content,
    required this.publishedAtLabel,
    required this.isPinned,
    required this.tags,
  });

  final String id;
  final NewsArticleType type;
  final String title;
  final String summary;
  final String content;
  final String publishedAtLabel;
  final bool isPinned;
  final List<String> tags;
}

final class MockNewsRepository implements NewsRepository {
  const MockNewsRepository();

  @override
  NewsScreenSnapshot getNews({NewsArticleType? type}) {
    final filtered = type == null
        ? _articles
        : _articles.where((article) => article.type == type).toList();
    return NewsScreenSnapshot(
      articles: filtered,
      pinnedArticles: filtered.where((article) => article.isPinned).toList(),
      normalArticles: filtered.where((article) => !article.isPinned).toList(),
      newsReferenceData: const NewsReferenceData(
        endpoint: '/api/mobile/news/news',
        filters: NewsArticleType.values,
        lastUpdatedLabel: 'read-only',
      ),
      screenState: filtered.isEmpty
          ? NewsScreenState.empty
          : NewsScreenState.ready,
      supportedStates: const [
        NewsScreenState.loading,
        NewsScreenState.empty,
        NewsScreenState.error,
        NewsScreenState.offline,
      ],
    );
  }
}

const List<NewsArticle> _articles = [
  NewsArticle(
    id: 'news001',
    type: NewsArticleType.promotion,
    title: 'Phí giao dịch 0% cho BTC/USDT',
    summary: 'Miễn phí giao dịch hoàn toàn cho cặp BTC/USDT trong 7 ngày!',
    content:
        'Chào mừng sự kiện đặc biệt! Từ ngày 23/02 đến 29/02, VitTrade miễn phí 100% phí giao dịch maker và taker cho cặp BTC/USDT.\n\nĐiều kiện:\n- Áp dụng cho tất cả người dùng\n- Không giới hạn khối lượng giao dịch\n- Có hiệu lực từ 23/02 00:00 UTC+7\n\nHãy tận dụng cơ hội này.',
    publishedAtLabel: '23/2/2024',
    isPinned: true,
    tags: ['Khuyến mãi', 'BTC', 'Phí'],
  ),
  NewsArticle(
    id: 'news002',
    type: NewsArticleType.newFeature,
    title: 'Ra mắt tính năng P2P Trading',
    summary:
        'Mua bán USDT trực tiếp bằng VND với người dùng khác — An toàn, nhanh chóng!',
    content:
        'VitTrade chính thức ra mắt tính năng P2P Trading, cho phép bạn:\n\n- Mua/bán USDT trực tiếp với người dùng khác\n- Thanh toán bằng VND qua Vietcombank, Momo, ZaloPay\n- Tỷ giá cạnh tranh, không phí giao dịch\n- Bảo vệ bởi hệ thống Escrow an toàn\n\nTrải nghiệm ngay hôm nay.',
    publishedAtLabel: '22/2/2024',
    isPinned: true,
    tags: ['Tính năng mới', 'P2P'],
  ),
  NewsArticle(
    id: 'news003',
    type: NewsArticleType.listing,
    title: 'Listing mới: MATIC/USDT',
    summary: 'Polygon (MATIC) chính thức được niêm yết trên VitTrade',
    content:
        'VitTrade vui mừng thông báo niêm yết MATIC/USDT.\n\nThông tin giao dịch:\n- Cặp: MATIC/USDT\n- Thời gian mở giao dịch: 20/02/2024 10:00 UTC+7\n- Phí: Maker 0.1% / Taker 0.1%',
    publishedAtLabel: '20/2/2024',
    isPinned: false,
    tags: ['Niêm yết', 'MATIC', 'Polygon'],
  ),
  NewsArticle(
    id: 'news004',
    type: NewsArticleType.maintenance,
    title: 'Bảo trì hệ thống định kỳ',
    summary: 'Hệ thống sẽ bảo trì vào 3h sáng ngày 24/02 (dự kiến 30 phút)',
    content:
        'Thông báo bảo trì hệ thống.\n\nThời gian: 24/02/2024 03:00 - 03:30 UTC+7\n\nTrong thời gian bảo trì:\n- Không thể đăng nhập hoặc giao dịch\n- Nạp/rút tiền tạm ngưng\n- API trading không khả dụng',
    publishedAtLabel: '21/2/2024',
    isPinned: false,
    tags: ['Bảo trì', 'Hệ thống'],
  ),
  NewsArticle(
    id: 'news005',
    type: NewsArticleType.security,
    title: 'Tăng cường bảo mật tài khoản',
    summary: 'Khuyến nghị kích hoạt 2FA để bảo vệ tài khoản của bạn',
    content:
        'Bảo mật tài khoản quan trọng hơn bao giờ hết.\n\nVitTrade khuyến nghị tất cả người dùng:\n\n1. Kích hoạt xác thực 2 lớp (2FA)\n2. Sử dụng mật khẩu mạnh\n3. Không chia sẻ mật khẩu với bất kỳ ai\n4. Kiểm tra lịch sử đăng nhập thường xuyên',
    publishedAtLabel: '18/2/2024',
    isPinned: false,
    tags: ['Bảo mật', '2FA'],
  ),
];
