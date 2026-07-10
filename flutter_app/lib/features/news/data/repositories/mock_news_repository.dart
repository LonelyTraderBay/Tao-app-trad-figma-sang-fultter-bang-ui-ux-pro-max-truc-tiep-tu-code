import 'package:vit_trade_flutter/features/news/domain/entities/news_entities.dart';
import 'package:vit_trade_flutter/features/news/domain/repositories/news_repository.dart';

final class MockNewsRepository implements NewsRepository {
  const MockNewsRepository({
    this.simulateError = false,
    this.loadDelay = const Duration(milliseconds: 300),
  });

  final bool simulateError;
  final Duration loadDelay;

  @override
  Future<NewsScreenSnapshot> getNews() async {
    await Future<void>.delayed(loadDelay);
    if (simulateError) {
      throw StateError('news_fetch_failed');
    }
    return NewsScreenSnapshot(
      articles: _articles,
      pinnedArticles: _articles.where((article) => article.isPinned).toList(),
      normalArticles: _articles.where((article) => !article.isPinned).toList(),
      newsReferenceData: const NewsReferenceData(
        endpoint: '/api/mobile/news/news',
        filters: NewsArticleType.values,
        lastUpdatedLabel: 'read-only',
      ),
      screenState: _articles.isEmpty
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
