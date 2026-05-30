part of '../repositories/mock_trade_repository.dart';

const List<TradeBotTaxReportType> _botTaxReportTypes = [
  TradeBotTaxReportType(
    id: 'irs-8949',
    name: 'IRS Form 8949',
    description: 'US tax form for capital gains/losses',
    format: 'PDF',
    recommended: true,
    selectedByDefault: true,
  ),
  TradeBotTaxReportType(
    id: 'turbotax',
    name: 'TurboTax CSV',
    description: 'Import directly into TurboTax software',
    format: 'CSV',
    recommended: true,
    selectedByDefault: true,
  ),
  TradeBotTaxReportType(
    id: 'detailed-csv',
    name: 'Detailed Trade Log',
    description: 'All trades with timestamps, fees, PnL',
    format: 'CSV',
    recommended: false,
    selectedByDefault: false,
  ),
  TradeBotTaxReportType(
    id: 'summary-pdf',
    name: 'Summary Report',
    description: 'Overview of yearly gains/losses',
    format: 'PDF',
    recommended: false,
    selectedByDefault: false,
  ),
];

const TradeBotTaxBreakdown _botTaxBreakdown = TradeBotTaxBreakdown(
  shortTermLabel: 'Short-Term Gains',
  shortTermDescription: 'Held < 1 year (taxed as income)',
  longTermLabel: 'Long-Term Gains',
  longTermDescription: 'Held > 1 year (lower tax rate)',
);

const List<String> _botTaxNotes = [
  'Bot trades are taxable events (buy/sell, not just withdrawal)',
  'Trading fees can be deducted from capital gains',
  'Crypto-to-crypto trades (BTC->ETH) are taxable',
  'Consult a tax professional for accurate filing',
  'Keep reports for 7 years (IRS audit protection)',
];

const List<TradeBotApiEndpoint> _botApiEndpoints = [
  TradeBotApiEndpoint(
    method: 'GET',
    path: '/api/v1/bots',
    description: 'List all user bots',
    params: [
      TradeBotApiParameter(
        name: 'status',
        type: 'string',
        required: false,
        description: 'Filter by status (running, stopped, paused)',
      ),
      TradeBotApiParameter(
        name: 'limit',
        type: 'number',
        required: false,
        description: 'Max results (default: 20)',
      ),
    ],
    response: r'''{
  "bots": [
    {
      "id": "bot_abc123",
      "name": "DCA Bot #1",
      "strategy": "dca",
      "status": "running",
      "profit": 84.20,
      "createdAt": "2026-01-15T10:30:00Z"
    }
  ],
  "total": 3
}''',
  ),
  TradeBotApiEndpoint(
    method: 'POST',
    path: '/api/v1/bots',
    description: 'Create a new bot',
    params: [
      TradeBotApiParameter(
        name: 'name',
        type: 'string',
        required: true,
        description: 'Bot name',
      ),
      TradeBotApiParameter(
        name: 'strategy',
        type: 'string',
        required: true,
        description: 'dca | grid | momentum | martingale',
      ),
      TradeBotApiParameter(
        name: 'pair',
        type: 'string',
        required: true,
        description: 'Trading pair (e.g., BTC/USDT)',
      ),
      TradeBotApiParameter(
        name: 'config',
        type: 'object',
        required: true,
        description: 'Strategy-specific parameters',
      ),
    ],
    response: r'''{
  "bot": {
    "id": "bot_xyz789",
    "name": "My Grid Bot",
    "strategy": "grid",
    "status": "running",
    "createdAt": "2026-03-08T14:23:00Z"
  }
}''',
  ),
  TradeBotApiEndpoint(
    method: 'DELETE',
    path: '/api/v1/bots/:botId',
    description: 'Stop and delete a bot',
    params: [],
    response: r'''{
  "success": true,
  "message": "Bot stopped and deleted"
}''',
  ),
  TradeBotApiEndpoint(
    method: 'GET',
    path: '/api/v1/bots/:botId/history',
    description: 'Get bot trade history',
    params: [
      TradeBotApiParameter(
        name: 'startDate',
        type: 'string',
        required: false,
        description: 'ISO date',
      ),
      TradeBotApiParameter(
        name: 'endDate',
        type: 'string',
        required: false,
        description: 'ISO date',
      ),
      TradeBotApiParameter(
        name: 'limit',
        type: 'number',
        required: false,
        description: 'Max results',
      ),
    ],
    response: r'''{
  "trades": [
    {
      "id": "trade_123",
      "side": "buy",
      "price": 68450,
      "qty": 0.001,
      "fee": 0.034,
      "timestamp": "2026-03-08T14:32:15Z"
    }
  ],
  "total": 247
}''',
  ),
];

const List<TradeBotWebSocketEvent> _botApiWebSocketEvents = [
  TradeBotWebSocketEvent(
    event: 'bot.status',
    description: 'Bot status changed',
    payload: r'''{
  "botId": "bot_abc123",
  "status": "stopped",
  "reason": "manual_stop",
  "timestamp": "2026-03-08T15:00:00Z"
}''',
  ),
  TradeBotWebSocketEvent(
    event: 'bot.trade',
    description: 'New trade executed',
    payload: r'''{
  "botId": "bot_abc123",
  "tradeId": "trade_xyz",
  "side": "buy",
  "price": 68450,
  "qty": 0.001,
  "fee": 0.034
}''',
  ),
  TradeBotWebSocketEvent(
    event: 'bot.profit',
    description: 'Profit/loss update',
    payload: r'''{
  "botId": "bot_abc123",
  "profit": 127.40,
  "profitPercent": 12.74,
  "totalTrades": 156
}''',
  ),
];

const List<TradeBotCodeExample> _botApiCodeExamples = [
  TradeBotCodeExample(
    language: 'javascript',
    label: 'JavaScript',
    title: 'JavaScript SDK',
    source: r'''// Install SDK
npm install @tradingplatform/bot-sdk

// Import and initialize
const BotSDK = require('@tradingplatform/bot-sdk');
const logger = require('./logger');
const client = new BotSDK({
  apiKey: 'YOUR_API_KEY',
  apiSecret: 'YOUR_API_SECRET'
});

// List all bots
const bots = await client.bots.list();
logger.info('Bots loaded', { bots });

// Create a new Grid Bot
const newBot = await client.bots.create({
  name: 'My Grid Bot',
  strategy: 'grid',
  pair: 'BTC/USDT',
  config: {
    gridCount: 20,
    upperPrice: 70000,
    lowerPrice: 65000,
    investment: 1000
  }
});

// Subscribe to bot events
client.on('bot.trade', (data) => {
  logger.info('New trade', { data });
});''',
  ),
  TradeBotCodeExample(
    language: 'python',
    label: 'Python',
    title: 'Python SDK',
    source: r'''# Install SDK
pip install tradingplatform-bot-sdk

# Import and initialize
import logging
from tradingplatform import BotClient

logger = logging.getLogger('vittrade.bots')
client = BotClient(
    api_key='YOUR_API_KEY',
    api_secret='YOUR_API_SECRET'
)

# List all bots
bots = client.bots.list()
logger.info('Bots loaded: %s', bots)

# Create a new DCA Bot
new_bot = client.bots.create(
    name='My DCA Bot',
    strategy='dca',
    pair='BTC/USDT',
    config={
        'amount': 100,
        'frequency': 'weekly'
    }
)

# Subscribe to WebSocket events
@client.on('bot.trade')
def on_trade(data):
    logger.info('New trade: %s', data)''',
  ),
  TradeBotCodeExample(
    language: 'curl',
    label: 'cURL',
    title: 'cURL Commands',
    source: r'''# List all bots
curl -X GET https://api.tradingplatform.com/v1/bots \
  -H "Authorization: Bearer YOUR_API_KEY"

# Create a new bot
curl -X POST https://api.tradingplatform.com/v1/bots \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "My Grid Bot",
    "strategy": "grid",
    "pair": "BTC/USDT",
    "config": {
      "gridCount": 20,
      "upperPrice": 70000,
      "lowerPrice": 65000,
      "investment": 1000
    }
  }'

# Get bot history
curl -X GET https://api.tradingplatform.com/v1/bots/bot_abc123/history \
  -H "Authorization: Bearer YOUR_API_KEY"''',
  ),
];

const List<TradeBotRateLimit> _botApiRateLimits = [
  TradeBotRateLimit(label: 'REST API:', value: '100 requests / minute'),
  TradeBotRateLimit(label: 'WebSocket:', value: 'Unlimited subscriptions'),
  TradeBotRateLimit(label: 'Max bots (API):', value: 'Enterprise tier only'),
];

const List<TradeFuturesPosition> _futuresPositions = [
  TradeFuturesPosition(
    id: 'fp1',
    symbol: 'ETH/USDT',
    side: TradeFuturesSide.long,
    leverage: 10,
    size: .5,
    entryPrice: 3480,
    markPrice: 3521.45,
    liquidPrice: 3150,
    pnl: 20.73,
    pnlPct: 1.19,
    margin: 174,
    roe: 11.9,
  ),
  TradeFuturesPosition(
    id: 'fp2',
    symbol: 'SOL/USDT',
    side: TradeFuturesSide.short,
    leverage: 5,
    size: 10,
    entryPrice: 185,
    markPrice: 178.32,
    liquidPrice: 222,
    pnl: 66.80,
    pnlPct: 3.61,
    margin: 370,
    roe: 18.05,
  ),
];

const TradeOrderBook _orderBook = TradeOrderBook(
  bids: [
    TradeBookLevel(price: 67524.13, amount: 0.812, total: 54829),
    TradeBookLevel(price: 67518.80, amount: 1.204, total: 81308),
    TradeBookLevel(price: 67510.42, amount: 0.533, total: 35982),
  ],
  asks: [
    TradeBookLevel(price: 67545.13, amount: 0.628, total: 42416),
    TradeBookLevel(price: 67551.90, amount: 0.904, total: 61067),
    TradeBookLevel(price: 67563.44, amount: 1.118, total: 75540),
  ],
);

const List<TradeTapePrint> _trades = [
  TradeTapePrint(price: 67543.21, amount: 0.036, time: '23:29:14', isBuy: true),
  TradeTapePrint(
    price: 67541.88,
    amount: 0.082,
    time: '23:29:12',
    isBuy: false,
  ),
  TradeTapePrint(price: 67544.09, amount: 0.024, time: '23:29:09', isBuy: true),
];

const List<TradeOpenOrder> _orders = [
  TradeOpenOrder(
    id: 'ord001',
    symbol: 'BTC/USDT',
    side: TradeOrderSide.buy,
    type: TradeOrderType.limit,
    price: 67050,
    amount: .12,
    filled: .04,
    createdAt: '23/02 09:24',
  ),
  TradeOpenOrder(
    id: 'ord002',
    symbol: 'ETH/USDT',
    side: TradeOrderSide.sell,
    type: TradeOrderType.limit,
    price: 3580,
    amount: 1.4,
    filled: 0,
    createdAt: '23/02 08:11',
  ),
];

const List<TradeHistoryOrder> _historyOpenOrders = [
  TradeHistoryOrder(
    id: 'ord-open-001',
    symbol: 'BTC/USDT',
    side: TradeOrderSide.buy,
    type: TradeOrderType.limit,
    status: TradeOrderStatus.open,
    price: 65000,
    amount: .05,
    filled: 0,
    fee: 0,
    createdAt: '2024-02-21 09:32:11',
  ),
  TradeHistoryOrder(
    id: 'ord-open-002',
    symbol: 'ETH/USDT',
    side: TradeOrderSide.sell,
    type: TradeOrderType.limit,
    status: TradeOrderStatus.partial,
    price: 3650,
    amount: 1.5,
    filled: .8,
    fee: .24,
    createdAt: '2024-02-21 10:15:44',
  ),
  TradeHistoryOrder(
    id: 'ord-open-003',
    symbol: 'SOL/USDT',
    side: TradeOrderSide.buy,
    type: TradeOrderType.stop,
    status: TradeOrderStatus.open,
    price: 170,
    amount: 10,
    filled: 0,
    fee: 0,
    createdAt: '2024-02-21 11:02:33',
  ),
  TradeHistoryOrder(
    id: 'ord-open-004',
    symbol: 'BTC/USDT',
    side: TradeOrderSide.sell,
    type: TradeOrderType.market,
    status: TradeOrderStatus.open,
    price: 67500,
    amount: .02,
    filled: 0,
    fee: 0,
    createdAt: '2024-02-21 12:18:07',
  ),
];

const List<TradeHistoryOrder> _historyOrders = [
  TradeHistoryOrder(
    id: 'ord-history-001',
    symbol: 'BTC/USDT',
    side: TradeOrderSide.buy,
    type: TradeOrderType.limit,
    status: TradeOrderStatus.filled,
    price: 64220,
    amount: .08,
    filled: .08,
    fee: 3.71,
    createdAt: '2024-02-20 18:21:44',
  ),
  TradeHistoryOrder(
    id: 'ord-history-002',
    symbol: 'ETH/USDT',
    side: TradeOrderSide.sell,
    type: TradeOrderType.market,
    status: TradeOrderStatus.filled,
    price: 3588,
    amount: 1.2,
    filled: 1.2,
    fee: 2.89,
    createdAt: '2024-02-20 16:09:12',
  ),
  TradeHistoryOrder(
    id: 'ord-history-003',
    symbol: 'SOL/USDT',
    side: TradeOrderSide.buy,
    type: TradeOrderType.stop,
    status: TradeOrderStatus.cancelled,
    price: 154,
    amount: 12,
    filled: 0,
    fee: 0,
    createdAt: '2024-02-19 22:40:03',
  ),
  TradeHistoryOrder(
    id: 'ord-history-004',
    symbol: 'BTC/USDT',
    side: TradeOrderSide.sell,
    type: TradeOrderType.limit,
    status: TradeOrderStatus.filled,
    price: 67120,
    amount: .03,
    filled: .03,
    fee: 1.71,
    createdAt: '2024-02-19 14:35:10',
  ),
  TradeHistoryOrder(
    id: 'ord-history-005',
    symbol: 'ETH/USDT',
    side: TradeOrderSide.buy,
    type: TradeOrderType.limit,
    status: TradeOrderStatus.cancelled,
    price: 3400,
    amount: .9,
    filled: 0,
    fee: 0,
    createdAt: '2024-02-18 09:12:40',
  ),
];

const List<TradePosition> _positions = [
  TradePosition(
    symbol: 'BTC/USDT',
    side: TradeOrderSide.buy,
    notional: 8105.19,
    pnl: 142.44,
  ),
];
