part of '../repositories/mock_trade_bots_repository.dart';

// Standalone stand-in for `getTrade()` (the core spot-trading fixture, owned
// by `features/trade`'s own mock repository). `getTradingBots()` embeds a
// `TradeScreenSnapshot` in its response for parity with other trade domain
// snapshots, but no page or test reads that field (verified via
// `trading_bots_page.dart`/its widget parts, `trading_bots_page_test.dart`,
// and `mock_trade_repository_core_test.dart`, which only assert
// `bots is TradeBotsSnapshot`) — it exists only to satisfy
// `TradeBotsSnapshot.trade`'s type. `trade_bots` must not depend back on
// `trade`'s private spot-trading fixtures (that would invert the intended
// extraction direction), so this is a small, self-contained placeholder
// rather than a call to `getTrade()`.
const TradeScreenSnapshot _botLifecycleTradeSnapshot = TradeScreenSnapshot(
  pair: TradePair(
    id: 'btcusdt',
    symbol: 'BTC/USDT',
    baseAsset: 'BTC',
    quoteAsset: 'USDT',
    price: 67543.21,
    changePct: 1.8,
    logoColorHex: 0xFFF7931A,
  ),
  pairs: [
    TradePair(
      id: 'btcusdt',
      symbol: 'BTC/USDT',
      baseAsset: 'BTC',
      quoteAsset: 'USDT',
      price: 67543.21,
      changePct: 1.8,
      logoColorHex: 0xFFF7931A,
    ),
  ],
  orderBook: TradeOrderBook(bids: [], asks: []),
  trades: [],
  orders: [],
  positions: [],
  copyProviders: [],
  botStrategies: [],
  balances: TradeBalances(usdtAvailable: 0, baseAvailable: 0),
  lastUpdatedLabel: 'realtime-refresh',
  supportedStates: [
    TradeScreenState.loading,
    TradeScreenState.empty,
    TradeScreenState.error,
    TradeScreenState.offline,
    TradeScreenState.realtimeRefresh,
  ],
);

const List<TradeBotStrategy> _botStrategies = [
  TradeBotStrategy(
    id: 'dca',
    name: 'DCA Bot',
    description: 'Dollar Cost Averaging - Mua định kỳ, giảm rủi ro biến động',
    longDescription:
        'DCA Bot tự động mua một lượng cố định theo chu kỳ thời gian, bất kể giá tăng hay giảm.',
    icon: 'calendar',
    colorHex: 0xFF3B82F6,
    risk: TradeBotRisk.low,
    avgReturn: '+8-15% / năm',
    suitableFor: 'Nhà đầu tư dài hạn, người mới',
    params: [
      TradeBotParam(
        key: 'pair',
        label: 'Cặp giao dịch',
        type: 'select',
        defaultValue: 'BTC/USDT',
        options: ['BTC/USDT', 'ETH/USDT', 'SOL/USDT', 'BNB/USDT'],
      ),
      TradeBotParam(
        key: 'amount',
        label: 'Mỗi lần mua',
        type: 'number',
        defaultValue: '50',
        unit: 'USDT',
      ),
      TradeBotParam(
        key: 'interval',
        label: 'Chu kỳ',
        type: 'select',
        defaultValue: 'Mỗi ngày',
        options: ['Mỗi giờ', 'Mỗi ngày', 'Mỗi tuần', 'Mỗi tháng'],
      ),
      TradeBotParam(
        key: 'totalBudget',
        label: 'Ngân sách tổng',
        type: 'number',
        defaultValue: '1000',
        unit: 'USDT',
      ),
    ],
  ),
  TradeBotStrategy(
    id: 'grid',
    name: 'Grid Bot',
    description: 'Lưới giá - Mua thấp bán cao tự động trong khoảng giá',
    longDescription:
        'Grid Bot đặt nhiều lệnh mua và bán trong khoảng giá xác định, tự động kiếm lời khi thị trường đi ngang.',
    icon: 'bolt',
    colorHex: 0xFFF59E0B,
    risk: TradeBotRisk.medium,
    avgReturn: '+15-40% / năm',
    suitableFor: 'Thị trường sideway, trader kinh nghiệm',
    params: [
      TradeBotParam(
        key: 'pair',
        label: 'Cặp giao dịch',
        type: 'select',
        defaultValue: 'ETH/USDT',
        options: ['BTC/USDT', 'ETH/USDT', 'SOL/USDT'],
      ),
      TradeBotParam(
        key: 'upperPrice',
        label: 'Giá trần',
        type: 'number',
        defaultValue: '4000',
        unit: 'USDT',
      ),
      TradeBotParam(
        key: 'lowerPrice',
        label: 'Giá sàn',
        type: 'number',
        defaultValue: '3000',
        unit: 'USDT',
      ),
      TradeBotParam(
        key: 'gridCount',
        label: 'Số lưới',
        type: 'number',
        defaultValue: '20',
        unit: 'lưới',
      ),
    ],
  ),
  TradeBotStrategy(
    id: 'momentum',
    name: 'Momentum Bot',
    description: 'Theo đà thị trường - Mua khi uptrend, bán khi downtrend',
    longDescription:
        'Momentum Bot sử dụng chỉ báo kỹ thuật để xác định xu hướng và tự động vào/ra lệnh.',
    icon: 'chart',
    colorHex: 0xFF10B981,
    risk: TradeBotRisk.medium,
    avgReturn: '+20-50% / năm',
    suitableFor: 'Thị trường trending, trader trung cấp',
    params: [
      TradeBotParam(
        key: 'pair',
        label: 'Cặp giao dịch',
        type: 'select',
        defaultValue: 'BTC/USDT',
        options: ['BTC/USDT', 'ETH/USDT', 'SOL/USDT'],
      ),
      TradeBotParam(
        key: 'investment',
        label: 'Vốn giao dịch',
        type: 'number',
        defaultValue: '500',
        unit: 'USDT',
      ),
      TradeBotParam(
        key: 'stopLoss',
        label: 'Stop loss',
        type: 'number',
        defaultValue: '5',
        unit: '%',
      ),
    ],
  ),
  TradeBotStrategy(
    id: 'martingale',
    name: 'Martingale Bot',
    description: 'Tăng gấp đôi khi thua - Phục hồi nhanh sau drawdown',
    longDescription:
        'Martingale tăng kích thước lệnh sau mỗi lần thua để bù đắp khi thắng. Tiềm năng lợi nhuận cao nhưng rủi ro cũng cao.',
    icon: 'target',
    colorHex: 0xFF8B5CF6,
    risk: TradeBotRisk.high,
    avgReturn: '+30-80% / năm',
    suitableFor: 'Trader chuyên nghiệp, vốn lớn',
    params: [
      TradeBotParam(
        key: 'pair',
        label: 'Cặp giao dịch',
        type: 'select',
        defaultValue: 'BTC/USDT',
        options: ['BTC/USDT', 'ETH/USDT', 'SOL/USDT'],
      ),
      TradeBotParam(
        key: 'baseOrder',
        label: 'Lệnh cơ bản',
        type: 'number',
        defaultValue: '20',
        unit: 'USDT',
      ),
      TradeBotParam(
        key: 'multiplier',
        label: 'Hệ số nhân',
        type: 'number',
        defaultValue: '2',
        unit: 'x',
      ),
    ],
  ),
];

const List<TradeBot> _activeBots = [
  TradeBot(
    id: 'bot1',
    strategyId: 'dca',
    strategyName: 'DCA Bot',
    icon: 'calendar',
    colorHex: 0xFF3B82F6,
    pair: 'BTC/USDT',
    status: TradeBotStatus.running,
    profit: 84.20,
    profitPct: 8.42,
    trades: 47,
    investment: 1000,
    startDate: '01/01/2026',
    runtime: '52 ngày',
  ),
  TradeBot(
    id: 'bot2',
    strategyId: 'grid',
    strategyName: 'Grid Bot',
    icon: 'bolt',
    colorHex: 0xFFF59E0B,
    pair: 'ETH/USDT',
    status: TradeBotStatus.running,
    profit: 127.40,
    profitPct: 25.48,
    trades: 234,
    investment: 500,
    startDate: '15/01/2026',
    runtime: '38 ngày',
  ),
  TradeBot(
    id: 'bot3',
    strategyId: 'momentum',
    strategyName: 'Momentum Bot',
    icon: 'chart',
    colorHex: 0xFF10B981,
    pair: 'SOL/USDT',
    status: TradeBotStatus.paused,
    profit: -12.30,
    profitPct: -2.46,
    trades: 18,
    investment: 500,
    startDate: '10/02/2026',
    runtime: '13 ngày',
  ),
];

const List<TradeBotTermsSection> _botTermsSections = [
  TradeBotTermsSection(
    title: '1. Chấp nhận điều khoản',
    paragraphs: [
      'Khi sử dụng dịch vụ Bot giao dịch ("Dịch vụ"), bạn đồng ý bị ràng buộc '
          'bởi các Điều khoản dịch vụ này ("Điều khoản"). Nếu không đồng ý '
          'với các Điều khoản này, bạn không được sử dụng Dịch vụ.',
      'Các Điều khoản này là thoả thuận ràng buộc pháp lý giữa bạn và Công '
          'ty. Việc sử dụng thuật toán giao dịch tự động của bạn phải tuân '
          'theo các yêu cầu quy định bổ sung mà bạn xác nhận và chấp nhận.',
    ],
  ),
  TradeBotTermsSection(
    title: '2. Không đảm bảo lợi nhuận',
    warningTitle: 'CẢNH BÁO QUAN TRỌNG:',
    warningBody:
        'Bot giao dịch KHÔNG đảm bảo lợi nhuận. Hiệu suất quá khứ không dự '
        'đoán được kết quả tương lai. Bạn có thể mất một phần hoặc toàn bộ '
        'vốn đã đầu tư.',
    paragraphs: [
      'Giao dịch tự động tiềm ẩn rủi ro đáng kể. Điều kiện thị trường, biến '
          'động, thanh khoản, lỗi kỹ thuật và các yếu tố khác có thể gây ra '
          'thua lỗ đáng kể. Bạn chỉ nên đầu tư số vốn mà bạn chấp nhận mất '
          'hoàn toàn.',
    ],
  ),
  TradeBotTermsSection(
    title: '3. Xác nhận rủi ro',
    paragraphs: ['Bạn xác nhận và chấp nhận các rủi ro sau:'],
    bullets: [
      'Rủi ro thị trường: Thị trường tiền mã hoá biến động rất mạnh.',
      'Rủi ro thanh khoản: Lệnh có thể không khớp ở mức giá mong muốn.',
      'Rủi ro trượt giá: Giá khớp lệnh có thể khác giá dự kiến.',
      'Rủi ro kỹ thuật: Lỗi hệ thống có thể gây ra hành vi ngoài dự kiến.',
    ],
  ),
  TradeBotTermsSection(
    title: '4. Trách nhiệm của người dùng',
    paragraphs: [
      'Bạn hoàn toàn chịu trách nhiệm về việc cấu hình tham số bot, theo dõi '
          'hiệu suất, duy trì đủ số dư, hiểu rõ từng chiến lược, và tuân thủ '
          'pháp luật hiện hành.',
    ],
  ),
  TradeBotTermsSection(
    title: '5. Giới hạn trách nhiệm pháp lý',
    paragraphs: [
      'Trong phạm vi tối đa pháp luật cho phép, Công ty không chịu trách '
          'nhiệm về các khoản lỗ giao dịch, dự báo không chính xác, thời '
          'gian gián đoạn dịch vụ, lỗi từ sàn giao dịch, hoặc thay đổi quy '
          'định ảnh hưởng đến khả năng giao dịch của bạn.',
    ],
  ),
  TradeBotTermsSection(
    title: '6. Thay đổi & chấm dứt dịch vụ',
    paragraphs: [
      'Chúng tôi có quyền thay đổi, tạm ngừng hoặc chấm dứt Dịch vụ bất kỳ '
          'lúc nào để tuân thủ quy định hoặc bảo vệ quyền lợi người dùng.',
    ],
  ),
  TradeBotTermsSection(
    title: '7. Giải quyết tranh chấp',
    paragraphs: [
      'Mọi tranh chấp phát sinh từ các Điều khoản này hoặc từ việc bạn sử '
          'dụng Dịch vụ sẽ được giải quyết thông qua trọng tài ràng buộc '
          'theo các quy tắc hiện hành.',
    ],
  ),
  TradeBotTermsSection(
    title: '8. Tuân thủ quy định',
    paragraphs: [
      'Bot giao dịch có thể được xếp vào nhóm sản phẩm tài chính phức tạp '
          'theo MiFID II, yêu cầu đánh giá mức độ phù hợp và tuân thủ quy '
          'định địa phương.',
    ],
  ),
  TradeBotTermsSection(
    title: '9. Sử dụng dữ liệu & quyền riêng tư',
    paragraphs: [
      'Chúng tôi thu thập và xử lý dữ liệu giao dịch, chỉ số hiệu suất bot '
          'và thông tin tài khoản để cung cấp và cải thiện Dịch vụ.',
    ],
  ),
  TradeBotTermsSection(
    title: '10. Thông tin liên hệ',
    paragraphs: [
      'Nếu có thắc mắc về các Điều khoản này, liên hệ legal@tradingplatform.com '
          'hoặc support@tradingplatform.com.',
    ],
  ),
];

const List<TradeBotRiskCategory> _botRiskCategories = [
  TradeBotRiskCategory(
    id: 'market',
    kind: TradeBotRiskKind.market,
    title: 'Rủi ro biến động thị trường',
    description:
        'Thị trường tiền mã hoá biến động cực mạnh và có thể đi ngược vị '
        'thế của bạn rất nhanh.',
    examples: [
      'Bitcoin giảm 30% chỉ trong một ngày khi xảy ra flash crash',
      'Altcoin có thể mất 50-90% giá trị trong thị trường giá xuống',
      'Tin tức có thể gây biến động giá đột ngột 10-20% chỉ trong vài phút',
    ],
    mitigation:
        'Dùng lệnh cắt lỗ, đa dạng hoá tài sản, và không bao giờ đầu tư quá '
        'số tiền bạn chấp nhận mất.',
  ),
  TradeBotRiskCategory(
    id: 'leverage',
    kind: TradeBotRiskKind.leverage,
    title: 'Rủi ro đòn bẩy & Martingale',
    description:
        'Các chiến lược tăng khối lượng vị thế (như Martingale) có thể '
        'khuếch đại thua lỗ theo cấp số nhân.',
    examples: [
      'Martingale có thể cần gấp 10 lần vốn ban đầu sau 3-4 lần thua liên tiếp',
      'Có thể bị thanh lý nếu thị trường đi ngược trước khi kịp phục hồi',
      'Thua lỗ dồn tích có thể vượt quá toàn bộ số dư tài khoản',
    ],
    mitigation:
        'Đặt giới hạn khối lượng vị thế tối đa nghiêm ngặt, dùng hệ số nhân '
        'thận trọng, và theo dõi sát mức sụt giảm vốn.',
  ),
  TradeBotRiskCategory(
    id: 'liquidity',
    kind: TradeBotRiskKind.liquidity,
    title: 'Rủi ro thanh khoản & trượt giá',
    description:
        'Thị trường thanh khoản thấp có thể không khớp lệnh của bạn ở mức '
        'giá mong muốn.',
    examples: [
      'Lệnh giới hạn có thể không khớp trong giai đoạn biến động mạnh',
      'Lệnh thị trường có thể khớp tệ hơn giá hiển thị 2-5%',
      'Lệnh khối lượng lớn có thể khiến thị trường đi ngược lại bạn',
    ],
    mitigation:
        'Giao dịch cặp có thanh khoản tốt (BTC/USDT, ETH/USDT), dùng lệnh '
        'giới hạn, và chia nhỏ lệnh lớn thành nhiều lệnh nhỏ.',
  ),
  TradeBotRiskCategory(
    id: 'technical',
    kind: TradeBotRiskKind.technical,
    title: 'Rủi ro lỗi kỹ thuật',
    description:
        'Lỗi hệ thống, sự cố mạng, hoặc sàn giao dịch gián đoạn có thể gây '
        'ra hành vi bot ngoài dự kiến.',
    examples: [
      'Lỗi API sàn giao dịch có thể khiến bot không thực thi được lệnh',
      'Độ trễ mạng có thể gây bỏ lỡ cơ hội hoặc đặt lệnh trùng',
      'Lỗi phần mềm có thể thực thi giao dịch ngoài ý muốn',
    ],
    mitigation:
        'Bật cảnh báo dừng khẩn cấp, theo dõi hoạt động bot thường xuyên, và '
        'thử nghiệm chiến lược ở chế độ demo trước.',
  ),
  TradeBotRiskCategory(
    id: 'timing',
    kind: TradeBotRiskKind.timing,
    title: 'Rủi ro thực thi & độ trễ',
    description:
        'Độ trễ giữa lúc phát tín hiệu và lúc khớp lệnh có thể làm giảm lợi '
        'nhuận.',
    examples: [
      'Kết quả kiểm thử chiến lược giả định khớp lệnh tức thì (không thực tế)',
      'Giao dịch thực tế có độ trễ 0.1-1 giây ảnh hưởng giá vào/ra lệnh',
      'Chiến lược tần suất cao nhạy cảm nhất với vấn đề độ trễ',
    ],
    mitigation:
        'Tính đến độ trễ thực thi thực tế khi kiểm thử chiến lược, tránh tối '
        'ưu hoá quá mức, và dùng VPS để kết nối ổn định.',
  ),
  TradeBotRiskCategory(
    id: 'regulatory',
    kind: TradeBotRiskKind.regulatory,
    title: 'Rủi ro pháp lý & quy định',
    description:
        'Thay đổi quy định có thể ảnh hưởng đến khả năng giao dịch hoặc '
        'truy cập tài sản của bạn.',
    examples: [
      'Giao dịch tự động có thể bị hạn chế tại một số khu vực pháp lý',
      'Yêu cầu KYC/AML có thể tạm khoá rút tiền chờ xác minh',
      'Nghĩa vụ báo cáo thuế áp dụng cho mọi giao dịch của bot',
    ],
    mitigation:
        'Đảm bảo tuân thủ pháp luật địa phương, lưu giữ hồ sơ giao dịch chi '
        'tiết, và tham khảo chuyên gia thuế.',
  ),
];

const List<TradeBotRiskWarning> _botRiskWarnings = [
  TradeBotRiskWarning(
    title: 'Không đảm bảo lợi nhuận',
    text:
        'Bot có thể liên tục thua lỗ. Một chiến lược hiệu quả khi kiểm thử '
        'lịch sử vẫn có thể thất bại khi giao dịch thực do điều kiện thị '
        'trường thay đổi.',
  ),
  TradeBotRiskWarning(
    title: 'Phí giao dịch làm tăng thua lỗ',
    text:
        'Mỗi giao dịch đều mất phí sàn (0.1-0.5%). Bot tần suất cao có thể '
        'lỗ chỉ vì phí ngay cả khi biến động giá trung tính.',
  ),
  TradeBotRiskWarning(
    title: 'Thao túng thị trường',
    text:
        'Thị trường tiền mã hoá ít được quản lý và dễ bị thao túng, giao '
        'dịch giả (wash trading), hoặc bơm-xả giá (pump-and-dump).',
  ),
  TradeBotRiskWarning(
    title: 'Thanh lý tài khoản',
    text:
        'Nếu dùng ký quỹ hoặc đòn bẩy, toàn bộ tài khoản có thể bị thanh lý '
        'nếu thị trường đi ngược trước khi lệnh cắt lỗ kích hoạt.',
  ),
  TradeBotRiskWarning(
    title: 'Không có cơ chế bồi hoàn',
    text:
        'Khác với tài chính truyền thống, giao dịch tiền mã hoá hầu như '
        'không được bảo hiểm. Tài sản đã mất không thể lấy lại qua bảo hiểm '
        'tiền gửi.',
  ),
];

const List<TradeBotSuitabilityQuestion> _botSuitabilityQuestions = [
  TradeBotSuitabilityQuestion(
    id: 'q1',
    category: TradeBotSuitabilityCategory.experience,
    question: 'Bạn đã giao dịch tiền mã hoá được bao lâu?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: 'Chưa từng giao dịch / Dưới 3 tháng',
        score: 0,
      ),
      TradeBotSuitabilityOption(id: 'b', text: '3-12 tháng', score: 1),
      TradeBotSuitabilityOption(id: 'c', text: '1-3 năm', score: 2),
      TradeBotSuitabilityOption(id: 'd', text: 'Trên 3 năm', score: 3),
    ],
  ),
  TradeBotSuitabilityQuestion(
    id: 'q2',
    category: TradeBotSuitabilityCategory.experience,
    question: 'Bạn đã từng dùng bot giao dịch hoặc giao dịch thuật toán chưa?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: 'Chưa, đây là lần đầu tiên',
        score: 0,
      ),
      TradeBotSuitabilityOption(
        id: 'b',
        text: 'Có, nhưng chỉ ở chế độ demo/thử nghiệm',
        score: 1,
      ),
      TradeBotSuitabilityOption(
        id: 'c',
        text: 'Có, với tiền thật dưới 6 tháng',
        score: 2,
      ),
      TradeBotSuitabilityOption(
        id: 'd',
        text: 'Có, thường xuyên với tiền thật trên 6 tháng',
        score: 3,
      ),
    ],
  ),
  TradeBotSuitabilityQuestion(
    id: 'q3',
    category: TradeBotSuitabilityCategory.knowledge,
    question: 'Bạn có hiểu cách hoạt động của Grid Bot không?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: 'Không, tôi không biết Grid Bot là gì',
        score: 0,
      ),
      TradeBotSuitabilityOption(
        id: 'b',
        text: 'Sơ sơ - tôi có ý niệm cơ bản',
        score: 1,
      ),
      TradeBotSuitabilityOption(
        id: 'c',
        text: 'Có - tôi hiểu khái niệm và rủi ro',
        score: 2,
      ),
      TradeBotSuitabilityOption(
        id: 'd',
        text: 'Thành thạo - tôi có thể giải thích và đã từng dùng',
        score: 3,
      ),
    ],
  ),
  TradeBotSuitabilityQuestion(
    id: 'q4',
    category: TradeBotSuitabilityCategory.knowledge,
    question:
        'Bạn có hiểu "trượt giá" (slippage) trong giao dịch nghĩa là gì không?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: 'Không, chưa từng nghe đến',
        score: 0,
      ),
      TradeBotSuitabilityOption(
        id: 'b',
        text: 'Mơ hồ - tôi có nghe thuật ngữ này nhưng chưa chắc hiểu đúng',
        score: 1,
      ),
      TradeBotSuitabilityOption(
        id: 'c',
        text:
            'Có - tôi biết đó là chênh lệch giữa giá dự kiến và giá khớp thực tế',
        score: 2,
      ),
      TradeBotSuitabilityOption(
        id: 'd',
        text: 'Thành thạo - tôi biết cách giảm thiểu trượt giá',
        score: 3,
      ),
    ],
  ),
  TradeBotSuitabilityQuestion(
    id: 'q5',
    category: TradeBotSuitabilityCategory.risk,
    question:
        'Bạn dự định phân bổ bao nhiêu phần trăm tổng tiền tiết kiệm/đầu tư '
        'của mình vào bot giao dịch?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: 'Trên 50% tổng tiền tiết kiệm',
        score: 0,
      ),
      TradeBotSuitabilityOption(
        id: 'b',
        text: '20-50% tổng tiền tiết kiệm',
        score: 1,
      ),
      TradeBotSuitabilityOption(
        id: 'c',
        text: '5-20% tổng tiền tiết kiệm',
        score: 2,
      ),
      TradeBotSuitabilityOption(
        id: 'd',
        text: 'Dưới 5% - chỉ số tiền tôi chấp nhận mất',
        score: 3,
      ),
    ],
  ),
  TradeBotSuitabilityQuestion(
    id: 'q6',
    category: TradeBotSuitabilityCategory.risk,
    question: 'Nếu bot của bạn mất 30% giá trị trong một tuần, bạn sẽ làm gì?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: 'Hoảng loạn và bán ngay lập tức',
        score: 0,
      ),
      TradeBotSuitabilityOption(
        id: 'b',
        text: 'Rất lo lắng nhưng vẫn giữ',
        score: 1,
      ),
      TradeBotSuitabilityOption(
        id: 'c',
        text: 'Chấp nhận đó là biến động bình thường và tiếp tục',
        score: 2,
      ),
      TradeBotSuitabilityOption(
        id: 'd',
        text: 'Xem đó là cơ hội mua thêm',
        score: 3,
      ),
    ],
  ),
  TradeBotSuitabilityQuestion(
    id: 'q7',
    category: TradeBotSuitabilityCategory.financial,
    question: 'Mục tiêu đầu tư chính của bạn khi dùng bot giao dịch là gì?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: 'Làm giàu nhanh / Nhân đôi tiền thật nhanh',
        score: 0,
      ),
      TradeBotSuitabilityOption(
        id: 'b',
        text: 'Có thu nhập ổn định để thay lương',
        score: 1,
      ),
      TradeBotSuitabilityOption(
        id: 'c',
        text: 'Tích luỹ tài sản dài hạn qua nhiều năm',
        score: 2,
      ),
      TradeBotSuitabilityOption(
        id: 'd',
        text: 'Thử nghiệm và học hỏi, với vốn nhỏ',
        score: 3,
      ),
    ],
  ),
  TradeBotSuitabilityQuestion(
    id: 'q8',
    category: TradeBotSuitabilityCategory.knowledge,
    question:
        'Bạn có hiểu sự khác biệt giữa chiến lược DCA, Grid và Martingale '
        'không?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: 'Không, tôi không biết chiến lược nào trong số này',
        score: 0,
      ),
      TradeBotSuitabilityOption(
        id: 'b',
        text: 'Tôi biết DCA nhưng không biết các chiến lược còn lại',
        score: 1,
      ),
      TradeBotSuitabilityOption(
        id: 'c',
        text: 'Tôi hiểu khái niệm của cả ba chiến lược',
        score: 2,
      ),
      TradeBotSuitabilityOption(
        id: 'd',
        text: 'Thành thạo - tôi biết khi nào nên dùng từng chiến lược',
        score: 3,
      ),
    ],
  ),
];

const List<TradeBotDrawdownPoint> _botRiskDrawdownPoints = [
  TradeBotDrawdownPoint(label: '00:00', value: 0),
  TradeBotDrawdownPoint(label: '04:00', value: -2.3),
  TradeBotDrawdownPoint(label: '08:00', value: -5.1),
  TradeBotDrawdownPoint(label: '12:00', value: -8.4),
  TradeBotDrawdownPoint(label: '16:00', value: -12.2),
  TradeBotDrawdownPoint(label: '20:00', value: -15.2),
  TradeBotDrawdownPoint(label: 'Hiện tại', value: -15.2),
];

const List<TradeBotExposure> _botRiskExposures = [
  TradeBotExposure(
    asset: 'BTC',
    exposure: 1250,
    percentage: 50,
    colorHex: 0xFFF7931A,
  ),
  TradeBotExposure(
    asset: 'ETH',
    exposure: 750,
    percentage: 30,
    colorHex: 0xFF627EEA,
  ),
  TradeBotExposure(
    asset: 'SOL',
    exposure: 500,
    percentage: 20,
    colorHex: 0xFF14F195,
  ),
];

const List<TradeBotVarPoint> _botRiskVarHistory = [
  TradeBotVarPoint(label: 'T2', value: 142),
  TradeBotVarPoint(label: 'T3', value: 156),
  TradeBotVarPoint(label: 'T4', value: 134),
  TradeBotVarPoint(label: 'T5', value: 167),
  TradeBotVarPoint(label: 'T6', value: 189),
  TradeBotVarPoint(label: 'T7', value: 201),
  TradeBotVarPoint(label: 'CN', value: 178),
];

const List<TradeBotSafetyControl> _botRiskSafetyControls = [
  TradeBotSafetyControl(label: 'Giới hạn sụt giảm vốn', value: '-20%'),
  TradeBotSafetyControl(label: 'Giới hạn lỗ mỗi ngày', value: '-\$500'),
  TradeBotSafetyControl(label: 'Khối lượng vị thế tối đa', value: '\$1,000'),
  TradeBotSafetyControl(label: 'Dừng khẩn cấp', value: 'Đang bật'),
];

const List<TradeBotEmergencyBot> _botEmergencyStopBots = [
  TradeBotEmergencyBot(
    id: 'bot1',
    name: 'DCA Bot #1',
    pair: 'BTC/USDT',
    profit: 84.20,
    statusLabel: 'Đang chạy',
  ),
  TradeBotEmergencyBot(
    id: 'bot2',
    name: 'Grid Bot #1',
    pair: 'ETH/USDT',
    profit: 127.40,
    statusLabel: 'Đang chạy',
  ),
  TradeBotEmergencyBot(
    id: 'bot3',
    name: 'Momentum Bot #1',
    pair: 'SOL/USDT',
    profit: -12.30,
    statusLabel: 'Đang chạy',
  ),
];

const List<TradeBotEmergencyReason> _botEmergencyStopReasons = [
  TradeBotEmergencyReason(
    id: 'crash',
    label: 'Thị trường sập / biến động cực mạnh',
    iconName: 'crash',
  ),
  TradeBotEmergencyReason(
    id: 'bug',
    label: 'Lỗi kỹ thuật / hành vi ngoài dự kiến',
    iconName: 'bug',
  ),
  TradeBotEmergencyReason(
    id: 'unauthorized',
    label: 'Phát hiện truy cập trái phép',
    iconName: 'unauthorized',
  ),
  TradeBotEmergencyReason(
    id: 'drawdown',
    label: 'Sắp chạm giới hạn sụt giảm vốn',
    iconName: 'drawdown',
  ),
  TradeBotEmergencyReason(id: 'other', label: 'Lý do khác', iconName: 'other'),
];

const List<TradeBotApiKey> _botSecurityApiKeys = [
  TradeBotApiKey(
    id: '1',
    name: 'Trading Bot Key #1',
    permissions: 'Giao dịch + Đọc',
    lastUsed: '2 giờ trước',
    created: '2026-01-15',
  ),
  TradeBotApiKey(
    id: '2',
    name: 'Analytics Key',
    permissions: 'Chỉ đọc',
    lastUsed: '1 ngày trước',
    created: '2026-02-20',
  ),
];

const List<TradeBotIpWhitelistEntry> _botSecurityIpWhitelist = [
  TradeBotIpWhitelistEntry(
    id: '1',
    ip: '192.168.1.100',
    label: 'Mạng nhà riêng',
    added: '2026-03-01',
  ),
  TradeBotIpWhitelistEntry(
    id: '2',
    ip: '203.0.113.42',
    label: 'Máy chủ VPS',
    added: '2026-03-05',
  ),
];

const List<TradeBotSecurityActivity> _botSecurityRecentActivity = [
  TradeBotSecurityActivity(
    id: '1',
    action: 'Đã tạo bot: DCA Bot #1',
    time: '2 giờ trước',
    status: TradeBotSecurityActivityStatus.success,
  ),
  TradeBotSecurityActivity(
    id: '2',
    action: 'Đã tạo API key',
    time: '1 ngày trước',
    status: TradeBotSecurityActivityStatus.success,
  ),
  TradeBotSecurityActivity(
    id: '3',
    action: 'Đăng nhập thất bại',
    time: '3 ngày trước',
    status: TradeBotSecurityActivityStatus.warning,
  ),
  TradeBotSecurityActivity(
    id: '4',
    action: 'Đã dừng bot: Grid Bot #2',
    time: '5 ngày trước',
    status: TradeBotSecurityActivityStatus.success,
  ),
];

const List<String> _botSecurityTips = [
  'Không bao giờ chia sẻ API key với bất kỳ ai',
  'Dùng key Chỉ đọc cho phân tích, key Giao dịch chỉ dành cho bot',
  'Giới hạn quyền truy cập API theo địa chỉ IP cụ thể',
  'Bật xác thực 2 lớp (2FA) cho mọi hành động liên quan đến bot',
  'Thường xuyên xem lại nhật ký hoạt động để phát hiện dấu hiệu bất thường',
];

const List<TradeBotHistoryTrade> _botHistoryTrades = [
  TradeBotHistoryTrade(
    id: 't1',
    timestamp: '2026-03-08 14:32:15',
    botName: 'DCA Bot #1',
    strategy: 'DCA',
    pair: 'BTC/USDT',
    side: TradeBotHistorySide.buy,
    qty: 0.001,
    price: 68450,
    fee: 0.034,
    pnl: 0,
    status: 'filled',
  ),
  TradeBotHistoryTrade(
    id: 't2',
    timestamp: '2026-03-08 13:15:08',
    botName: 'Grid Bot #1',
    strategy: 'Grid',
    pair: 'ETH/USDT',
    side: TradeBotHistorySide.sell,
    qty: 0.05,
    price: 3850,
    fee: 0.096,
    pnl: 12.50,
    status: 'filled',
  ),
  TradeBotHistoryTrade(
    id: 't3',
    timestamp: '2026-03-08 12:00:42',
    botName: 'Grid Bot #1',
    strategy: 'Grid',
    pair: 'ETH/USDT',
    side: TradeBotHistorySide.buy,
    qty: 0.05,
    price: 3800,
    fee: 0.095,
    pnl: 0,
    status: 'filled',
  ),
  TradeBotHistoryTrade(
    id: 't4',
    timestamp: '2026-03-08 10:45:30',
    botName: 'Momentum Bot #1',
    strategy: 'Momentum',
    pair: 'SOL/USDT',
    side: TradeBotHistorySide.buy,
    qty: 5,
    price: 142.30,
    fee: 0.356,
    pnl: 0,
    status: 'filled',
  ),
  TradeBotHistoryTrade(
    id: 't5',
    timestamp: '2026-03-08 09:20:15',
    botName: 'DCA Bot #1',
    strategy: 'DCA',
    pair: 'BTC/USDT',
    side: TradeBotHistorySide.buy,
    qty: 0.001,
    price: 68200,
    fee: 0.034,
    pnl: 0,
    status: 'filled',
  ),
  TradeBotHistoryTrade(
    id: 't6',
    timestamp: '2026-03-07 18:30:22',
    botName: 'Grid Bot #1',
    strategy: 'Grid',
    pair: 'ETH/USDT',
    side: TradeBotHistorySide.sell,
    qty: 0.05,
    price: 3820,
    fee: 0.096,
    pnl: 8.75,
    status: 'filled',
  ),
  TradeBotHistoryTrade(
    id: 't7',
    timestamp: '2026-03-07 16:15:10',
    botName: 'Momentum Bot #1',
    strategy: 'Momentum',
    pair: 'SOL/USDT',
    side: TradeBotHistorySide.sell,
    qty: 5,
    price: 138.50,
    fee: 0.346,
    pnl: -19.75,
    status: 'filled',
  ),
];

const List<TradeBotPnlPoint> _botPerformancePnlPoints = [
  TradeBotPnlPoint(date: '01/03', pnl: 12.5),
  TradeBotPnlPoint(date: '02/03', pnl: 28.3),
  TradeBotPnlPoint(date: '03/03', pnl: 45.7),
  TradeBotPnlPoint(date: '04/03', pnl: 32.1),
  TradeBotPnlPoint(date: '05/03', pnl: 58.9),
  TradeBotPnlPoint(date: '06/03', pnl: 91.2),
  TradeBotPnlPoint(date: '07/03', pnl: 127.4),
  TradeBotPnlPoint(date: '08/03', pnl: 199.3),
];

const List<TradeBotWinLossPoint> _botPerformanceWinLossPoints = [
  TradeBotWinLossPoint(week: 'Tuần 1', wins: 18, losses: 7),
  TradeBotWinLossPoint(week: 'Tuần 2', wins: 22, losses: 5),
  TradeBotWinLossPoint(week: 'Tuần 3', wins: 15, losses: 12),
  TradeBotWinLossPoint(week: 'Tuần 4', wins: 25, losses: 8),
];

const List<TradeBotStrategyPerformance> _botStrategyPerformance = [
  TradeBotStrategyPerformance(strategy: 'DCA', pnl: 84.2, colorHex: 0xFF3B82F6),
  TradeBotStrategyPerformance(
    strategy: 'Grid',
    pnl: 127.4,
    colorHex: 0xFFF59E0B,
  ),
  TradeBotStrategyPerformance(
    strategy: 'Momentum',
    pnl: -12.3,
    colorHex: 0xFF10B981,
  ),
];

const List<TradeBotDurationDistribution> _botDurationDistribution = [
  TradeBotDurationDistribution(duration: '<1h', count: 45),
  TradeBotDurationDistribution(duration: '1-6h', count: 28),
  TradeBotDurationDistribution(duration: '6-24h', count: 15),
  TradeBotDurationDistribution(duration: '>24h', count: 8),
];
