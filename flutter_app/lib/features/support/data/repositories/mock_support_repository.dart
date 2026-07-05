import 'package:vit_trade_flutter/features/support/domain/entities/support_entities.dart';
import 'package:vit_trade_flutter/features/support/domain/repositories/support_repository.dart';

final class MockSupportRepository implements SupportRepository {
  const MockSupportRepository();

  @override
  SupportHubSnapshot getSupportHub() {
    return const SupportHubSnapshot(
      endpoint: '/api/mobile/support/support',
      actionDraft: 'read-only or local navigation action',
      title: 'Hỗ trợ',
      subtitle: 'Liên hệ · Hỗ trợ',
      backRoute: '/home',
      helpRoute: '/support/help',
      announcementsRoute: '/support/announcements',
      email: 'support@vittrade.vn',
      hotline: '1900 xxxx',
      tickets: _supportTickets,
      faqItems: _supportFaqItems,
      contractNotes:
          'Support hub should return supportArticles, tickets, announcements, faqItems, contactLinks, and screenState. Ticket creation remains a local action placeholder until POST /support/tickets is defined.',
      screenState: SupportScreenState.ready,
      supportedStates: {
        SupportScreenState.loading,
        SupportScreenState.empty,
        SupportScreenState.error,
        SupportScreenState.offline,
      },
    );
  }

  @override
  HelpCenterSnapshot getHelpCenter() {
    return const HelpCenterSnapshot(
      endpoint: '/api/mobile/support/support-help',
      actionDraft: 'read-only or local navigation action',
      title: 'Trung tâm trợ giúp',
      subtitle: 'Trung tâm · Hỗ trợ',
      backRoute: '/support',
      searchHint: 'Tìm kiếm bài viết...',
      heroTitle: 'Bạn cần giúp gì?',
      heroBody: 'Tìm câu trả lời nhanh chóng từ cơ sở kiến thức của chúng tôi',
      chatRoute: '/support',
      ticketRoute: '/support',
      categories: _helpCategories,
      articles: _helpArticles,
      contractNotes:
          'Support help center should return supportArticles, tickets, announcements, screenState, and local navigation actions. Article expansion and search are client-side for the current Flutter mock.',
      screenState: SupportScreenState.ready,
      supportedStates: {
        SupportScreenState.loading,
        SupportScreenState.empty,
        SupportScreenState.error,
        SupportScreenState.offline,
      },
    );
  }

  @override
  AnnouncementsSnapshot getAnnouncements() {
    return const AnnouncementsSnapshot(
      endpoint: '/api/mobile/support/support-announcements',
      actionDraft: 'read-only or local navigation action',
      title: 'Thông báo',
      subtitle: 'Thông báo · Hỗ trợ',
      backRoute: '/support',
      filters: _announcementFilters,
      announcements: _announcements,
      contractNotes:
          'Support announcements should return supportArticles, tickets, announcements, screenState, and filter metadata. Details expand locally until announcement detail endpoints are introduced.',
      screenState: SupportScreenState.ready,
      supportedStates: {
        SupportScreenState.loading,
        SupportScreenState.empty,
        SupportScreenState.error,
        SupportScreenState.offline,
      },
    );
  }
}

const _supportTickets = [
  SupportTicketDraft(
    id: 'ticket001',
    subject: 'Rút USDT bị pending quá lâu',
    category: SupportTicketCategory.withdraw,
    status: SupportTicketStatus.inProgress,
    priority: SupportTicketPriority.high,
    description:
        'Tôi đã rút 1000 USDT từ 2 giờ trước nhưng vẫn chưa nhận được.',
    createdAt: '2024-02-23 07:30:00',
    updatedAt: '2024-02-23 08:15:00',
    messages: [
      SupportMessageDraft(
        id: 'msg001',
        sender: 'user',
        text: 'Tôi đã rút 1000 USDT từ 2 giờ trước nhưng vẫn chưa nhận được',
        time: '07:30',
      ),
      SupportMessageDraft(
        id: 'msg002',
        sender: 'support',
        text:
            'Xin chào! Chúng tôi đang kiểm tra giao dịch của bạn. Vui lòng cung cấp mã giao dịch (TxID).',
        time: '08:15',
      ),
    ],
  ),
  SupportTicketDraft(
    id: 'ticket002',
    subject: 'Không thể đăng nhập vào tài khoản',
    category: SupportTicketCategory.technical,
    status: SupportTicketStatus.resolved,
    priority: SupportTicketPriority.urgent,
    description: 'Tôi nhập đúng email/password nhưng vẫn không đăng nhập được.',
    createdAt: '2024-02-22 16:00:00',
    updatedAt: '2024-02-22 18:30:00',
    messages: [
      SupportMessageDraft(
        id: 'msg003',
        sender: 'user',
        text: 'Tôi nhập đúng email/password nhưng vẫn không đăng nhập được',
        time: '16:00',
      ),
      SupportMessageDraft(
        id: 'msg004',
        sender: 'support',
        text:
            'Vui lòng thử reset mật khẩu qua email hoặc tắt 2FA nếu bạn mất thiết bị.',
        time: '16:30',
      ),
      SupportMessageDraft(
        id: 'msg005',
        sender: 'user',
        text: 'Đã reset mật khẩu và đăng nhập được rồi. Cảm ơn!',
        time: '18:30',
      ),
    ],
  ),
];

const _supportFaqItems = [
  SupportFaqDraft(
    question: 'Làm sao để nạp tiền vào tài khoản?',
    answer:
        'Vào mục Ví, chọn Nạp tiền, chọn loại coin và mạng, sau đó copy địa chỉ ví để chuyển coin.',
  ),
  SupportFaqDraft(
    question: 'Phí giao dịch là bao nhiêu?',
    answer:
        'Phí Maker: 0.1%, phí Taker: 0.1%. VIP level càng cao thì phí càng thấp.',
  ),
  SupportFaqDraft(
    question: 'Tại sao rút tiền bị pending?',
    answer:
        'Rút tiền cần thời gian xử lý từ 5-30 phút tùy mạng. Kiểm tra TxHash để theo dõi.',
  ),
  SupportFaqDraft(
    question: 'Làm sao để xác minh KYC?',
    answer:
        'Vào Tài khoản, chọn KYC, tải lên CMND/CCCD và ảnh selfie, sau đó chờ duyệt 1-3 ngày làm việc.',
  ),
];

const _helpCategories = [
  HelpCategoryDraft(id: 'getting-started', name: 'Bắt đầu', count: 12),
  HelpCategoryDraft(id: 'trading', name: 'Giao dịch', count: 18),
  HelpCategoryDraft(id: 'deposit-withdraw', name: 'Nạp/Rút', count: 15),
  HelpCategoryDraft(id: 'security', name: 'Bảo mật', count: 10),
  HelpCategoryDraft(id: 'p2p', name: 'P2P Trading', count: 8),
  HelpCategoryDraft(id: 'kyc', name: 'Xác minh KYC', count: 6),
  HelpCategoryDraft(id: 'fees', name: 'Phí & Hạn mức', count: 7),
  HelpCategoryDraft(id: 'api', name: 'API Trading', count: 5),
];

const _helpArticles = [
  HelpArticleDraft(
    id: 'h001',
    categoryId: 'getting-started',
    title: 'Cách tạo tài khoản VitTrade',
    summary:
        'Hướng dẫn đăng ký tài khoản từ A-Z, bao gồm xác minh email và thiết lập bảo mật.',
    views: 15420,
  ),
  HelpArticleDraft(
    id: 'h002',
    categoryId: 'getting-started',
    title: 'Hướng dẫn nạp tiền lần đầu',
    summary:
        'Các bước nạp USDT, BTC, ETH vào tài khoản VitTrade một cách an toàn.',
    views: 12300,
  ),
  HelpArticleDraft(
    id: 'h003',
    categoryId: 'trading',
    title: 'Lệnh Limit vs Market là gì?',
    summary:
        'So sánh chi tiết giữa lệnh giới hạn và lệnh thị trường, khi nào nên dùng loại nào.',
    views: 23100,
  ),
  HelpArticleDraft(
    id: 'h004',
    categoryId: 'trading',
    title: 'Cách đặt Stop-Loss và Take-Profit',
    summary:
        'Hướng dẫn thiết lập cắt lỗ và chốt lời tự động để quản lý rủi ro.',
    views: 18900,
  ),
  HelpArticleDraft(
    id: 'h005',
    categoryId: 'deposit-withdraw',
    title: 'Vì sao giao dịch rút tiền bị pending?',
    summary:
        'Các nguyên nhân phổ biến khiến lệnh rút tiền chưa được xử lý và cách khắc phục.',
    views: 31200,
  ),
  HelpArticleDraft(
    id: 'h006',
    categoryId: 'security',
    title: 'Cách bật xác thực 2 lớp (2FA)',
    summary: 'Hướng dẫn cài đặt Google Authenticator để bảo vệ tài khoản.',
    views: 27800,
  ),
  HelpArticleDraft(
    id: 'h007',
    categoryId: 'p2p',
    title: 'Quy trình giao dịch P2P',
    summary: 'Hướng dẫn mua/bán USDT qua P2P từ đặt lệnh đến nhận coin.',
    views: 14500,
  ),
  HelpArticleDraft(
    id: 'h008',
    categoryId: 'fees',
    title: 'Bảng phí giao dịch VitTrade',
    summary:
        'Chi tiết phí maker/taker theo cấp VIP và cách giảm phí giao dịch.',
    views: 19400,
  ),
];

const _announcementFilters = [
  AnnouncementFilterDraft(id: 'all', label: 'Tất cả'),
  AnnouncementFilterDraft(
    id: 'promotion',
    label: 'Khuyến mãi',
    type: AnnouncementType.promotion,
  ),
  AnnouncementFilterDraft(
    id: 'new-feature',
    label: 'Tính năng',
    type: AnnouncementType.newFeature,
  ),
  AnnouncementFilterDraft(
    id: 'listing',
    label: 'Niêm yết',
    type: AnnouncementType.listing,
  ),
  AnnouncementFilterDraft(
    id: 'maintenance',
    label: 'Bảo trì',
    type: AnnouncementType.maintenance,
  ),
  AnnouncementFilterDraft(
    id: 'security',
    label: 'Bảo mật',
    type: AnnouncementType.security,
  ),
];

const _announcements = [
  AnnouncementDraft(
    id: 'news001',
    type: AnnouncementType.promotion,
    title: 'Phí giao dịch 0% cho BTC/USDT',
    summary: 'Miễn phí giao dịch hoàn toàn cho cặp BTC/USDT trong 7 ngày!',
    content:
        'Chào mừng sự kiện đặc biệt! Từ ngày 23/02 đến 29/02, VitTrade miễn phí 100% phí giao dịch maker và taker cho cặp BTC/USDT.\n\nĐiều kiện:\n- Áp dụng cho tất cả người dùng\n- Không giới hạn khối lượng giao dịch\n- Có hiệu lực từ 23/02 00:00 UTC+7',
    publishedDate: '2024-02-23',
    isPinned: true,
    tags: ['Khuyến mãi', 'BTC', 'Phí'],
  ),
  AnnouncementDraft(
    id: 'news002',
    type: AnnouncementType.newFeature,
    title: 'Ra mắt tính năng P2P Trading',
    summary:
        'Mua bán USDT trực tiếp bằng VND với người dùng khác - An toàn, nhanh chóng!',
    content:
        'VitTrade chính thức ra mắt tính năng P2P Trading, cho phép mua/bán USDT trực tiếp với người dùng khác, thanh toán bằng VND qua ngân hàng hoặc ví điện tử, và được bảo vệ bởi hệ thống escrow.\n\nCách sử dụng:\n1. Vào mục P2P\n2. Chọn quảng cáo phù hợp\n3. Thực hiện giao dịch và chuyển khoản\n4. Nhận USDT sau khi người bán xác nhận',
    publishedDate: '2024-02-22',
    isPinned: true,
    tags: ['Tính năng mới', 'P2P'],
  ),
  AnnouncementDraft(
    id: 'news003',
    type: AnnouncementType.listing,
    title: 'Listing mới: MATIC/USDT',
    summary: 'Polygon (MATIC) chính thức được niêm yết trên VitTrade',
    content:
        'VitTrade vui mừng thông báo niêm yết MATIC/USDT.\n\nThông tin giao dịch:\n- Cặp: MATIC/USDT\n- Thời gian mở giao dịch: 20/02/2024 10:00 UTC+7\n- Phí: Maker 0.1% / Taker 0.1%',
    publishedDate: '2024-02-20',
    isPinned: false,
    tags: ['Niêm yết', 'MATIC', 'Polygon'],
  ),
  AnnouncementDraft(
    id: 'news004',
    type: AnnouncementType.maintenance,
    title: 'Bảo trì hệ thống định kỳ',
    summary: 'Hệ thống sẽ bảo trì vào 3h sáng ngày 24/02 (dự kiến 30 phút)',
    content:
        'Thông báo bảo trì hệ thống.\n\nThời gian: 24/02/2024 03:00 - 03:30 UTC+7\n\nTrong thời gian bảo trì:\n- Không thể đăng nhập hoặc giao dịch\n- Nạp/rút tiền tạm ngưng\n- API trading không khả dụng',
    publishedDate: '2024-02-21',
    isPinned: false,
    tags: ['Bảo trì', 'Hệ thống'],
  ),
  AnnouncementDraft(
    id: 'news005',
    type: AnnouncementType.security,
    title: 'Tăng cường bảo mật tài khoản',
    summary: 'Khuyến nghị kích hoạt 2FA để bảo vệ tài khoản của bạn',
    content:
        'VitTrade khuyến nghị tất cả người dùng kích hoạt xác thực 2 lớp, sử dụng mật khẩu mạnh, kiểm tra lịch sử đăng nhập thường xuyên và cẩn thận với email hoặc liên kết lừa đảo.\n\nNếu phát hiện hoạt động đáng ngờ, hãy liên hệ hỗ trợ ngay.',
    publishedDate: '2024-02-18',
    isPinned: false,
    tags: ['Bảo mật', '2FA'],
  ),
];
