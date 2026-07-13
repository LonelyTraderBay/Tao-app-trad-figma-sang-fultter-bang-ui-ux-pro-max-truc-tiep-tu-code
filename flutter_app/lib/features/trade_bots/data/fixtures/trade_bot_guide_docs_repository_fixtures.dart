part of '../repositories/mock_trade_bots_repository.dart';

const List<TradeBotGuideStrategy> _botGuideStrategies = [
  TradeBotGuideStrategy(
    id: 'dca',
    name: 'DCA Bot (Dollar Cost Averaging)',
    iconKey: 'trending',
    colorHex: 0xFF3B82F6,
    difficulty: 'Beginner',
    description:
        'Automatically buy crypto at regular intervals regardless of price.',
    howItWorks: [
      'Set investment amount (e.g., \$100)',
      'Choose frequency (daily, weekly, monthly)',
      'Bot buys automatically on schedule',
      'Averages out market volatility',
      'Best for long-term accumulation',
    ],
    pros: [
      'Simplest strategy to understand',
      'Removes emotion from buying decisions',
      'Reduces timing risk',
      'Good for volatile markets',
    ],
    cons: [
      'No profit taking mechanism',
      'Continues buying in downtrends',
      'Requires consistent capital',
    ],
    bestFor: 'Long-term investors, beginners, volatile markets',
    example: TradeBotGuideExample(
      setup: 'Buy \$100 BTC every Monday',
      duration: '6 months',
      result: 'Average buy price: \$67,500 vs spot price: \$68,450',
      profit: '+\$127 (1.8%)',
    ),
  ),
  TradeBotGuideStrategy(
    id: 'grid',
    name: 'Grid Bot',
    iconKey: 'grid',
    colorHex: 0xFFF59E0B,
    difficulty: 'Intermediate',
    description:
        'Place buy and sell orders at multiple price levels to profit from price fluctuations.',
    howItWorks: [
      'Define price range (e.g., \$65,000 - \$70,000)',
      'Set number of grids (e.g., 20 grids)',
      'Bot places buy/sell orders at each grid level',
      'Profits from each price swing',
      'Works best in sideways markets',
    ],
    pros: [
      'Profits from volatility',
      'No need to predict direction',
      'Automated 24/7 trading',
      'High win rate (70-80%)',
    ],
    cons: [
      'Loses money in strong trends',
      'Requires sufficient capital for all grids',
      'Can miss big moves outside range',
    ],
    bestFor: 'Sideways/ranging markets, active traders, volatility lovers',
    example: TradeBotGuideExample(
      setup: '20 grids, \$65K-\$70K range, \$1,000 capital',
      duration: '1 month',
      result: '156 trades executed, 72.3% win rate',
      profit: '+\$127.40 (12.7%)',
    ),
  ),
  TradeBotGuideStrategy(
    id: 'momentum',
    name: 'Momentum Bot',
    iconKey: 'bolt',
    colorHex: 0xFF10B981,
    difficulty: 'Advanced',
    description:
        'Follow trends by buying when price rises and selling when it falls.',
    howItWorks: [
      'Monitor price movement and indicators',
      'Buy when uptrend detected (e.g., price > MA)',
      'Sell when downtrend detected',
      'Trail stop-loss to protect profits',
      'Best for trending markets',
    ],
    pros: [
      'Captures large trend movements',
      'Built-in stop-loss protection',
      'Can make big profits in trends',
      'Adapts to market conditions',
    ],
    cons: [
      'Frequent false signals in choppy markets',
      'Requires parameter tuning',
      'Can whipsaw in sideways markets',
    ],
    bestFor: 'Trending markets (bull/bear), experienced traders',
    example: TradeBotGuideExample(
      setup: 'MA crossover strategy, 3% stop-loss',
      duration: '2 months',
      result: '23 trades, 68.4% win rate',
      profit: '+\$559 (55.9%)',
    ),
  ),
  TradeBotGuideStrategy(
    id: 'martingale',
    name: 'Martingale Bot',
    iconKey: 'alert',
    colorHex: 0xFFEF4444,
    difficulty: 'Expert',
    description:
        'Double position size after each loss to recover all losses with one win.',
    howItWorks: [
      'Start with base position (e.g., \$100)',
      'If loss, double next position (\$200)',
      'If loss again, double again (\$400)',
      'One win recovers all previous losses',
      'High risk - can blow up account',
    ],
    pros: ['High win rate (78%+)', 'Recovers losses quickly', 'Simple logic'],
    cons: [
      'Catastrophic risk if many losses',
      'Requires large capital',
      'Can hit max drawdown (-30%+)',
      'Not suitable for beginners',
    ],
    bestFor: 'Experienced traders with large capital, high risk tolerance',
    example: TradeBotGuideExample(
      setup: 'Base \$100, 2x multiplier, max 5 doublings',
      duration: '1 month',
      result: '312 trades, 78.9% win rate, max DD -28.7%',
      profit: '+\$894 (89.4%) - High risk',
    ),
  ),
];

const List<TradeBotGuidePractice> _botGuideBestPractices = [
  TradeBotGuidePractice(
    id: 'small',
    title: 'Start Small',
    description: 'Begin with \$50-200 to test strategies before scaling up.',
    iconKey: 'idea',
  ),
  TradeBotGuidePractice(
    id: 'backtest',
    title: 'Backtest First',
    description:
        'Always backtest your strategy on historical data before deploying.',
    iconKey: 'chart',
  ),
  TradeBotGuidePractice(
    id: 'stop-loss',
    title: 'Set Stop-Loss',
    description: 'Use drawdown limits and emergency stops to protect capital.',
    iconKey: 'shield',
  ),
  TradeBotGuidePractice(
    id: 'monitor',
    title: 'Monitor Daily',
    description: 'Check bot performance at least once a day for anomalies.',
    iconKey: 'eye',
  ),
  TradeBotGuidePractice(
    id: 'diversify',
    title: 'Diversify',
    description:
        "Don't put all capital in one bot - spread across multiple strategies.",
    iconKey: 'target',
  ),
  TradeBotGuidePractice(
    id: 'fomo',
    title: 'Avoid FOMO',
    description: "Don't create bots during extreme market conditions.",
    iconKey: 'warning',
  ),
];

const List<TradeBotGuideMistake> _botGuideMistakes = [
  TradeBotGuideMistake(
    mistake: 'Over-optimizing parameters',
    why: 'Parameters optimized on past data may not work in future.',
    fix: 'Use simple, robust parameters. Test walk-forward validation.',
  ),
  TradeBotGuideMistake(
    mistake: 'Ignoring fees',
    why: 'High-frequency bots can lose money purely from trading fees.',
    fix: 'Calculate fee impact. Aim for profit > 2x fees per trade.',
  ),
  TradeBotGuideMistake(
    mistake: 'No risk management',
    why: 'Bots can compound losses without stop-loss limits.',
    fix: 'Set max drawdown (-20%), daily loss limits, use emergency stop.',
  ),
  TradeBotGuideMistake(
    mistake: 'Changing strategy mid-run',
    why: 'Interrupts strategy logic, can cause losses.',
    fix: 'Let bot run for full cycle (7-30 days) before adjusting.',
  ),
  TradeBotGuideMistake(
    mistake: 'Using demo results as guarantee',
    why: 'Demo has no slippage, instant fills, no network issues.',
    fix: 'Expect real results to be 10-20% worse than demo.',
  ),
];

const List<TradeBotFaqCategory> _botFaqCategories = [
  TradeBotFaqCategory(
    id: 'general',
    label: 'General',
    items: [
      TradeBotFaqItem(
        question: 'What is a trading bot?',
        answer:
            'A trading bot is an automated program that executes buy and sell orders based on predefined rules and strategies. It trades 24/7 without human intervention, following your configured parameters.',
      ),
      TradeBotFaqItem(
        question: 'Are trading bots profitable?',
        answer:
            'Profitability depends on market conditions, strategy, and parameters. Bots can be profitable but are NOT guaranteed to make money. Past performance does not predict future results. You may lose some or all of your capital.',
      ),
      TradeBotFaqItem(
        question: 'How much money do I need to start?',
        answer:
            'You can start with as little as \$50-100 for testing. For serious trading, we recommend \$500-1,000 minimum to handle market volatility and trading fees. Grid bots need more capital.',
      ),
      TradeBotFaqItem(
        question: 'Do I need coding skills?',
        answer:
            'No coding required. Our bots use a simple configuration interface. Just select strategy, set parameters, and start. Advanced users can use API for custom strategies.',
      ),
      TradeBotFaqItem(
        question: 'Can I lose more than I invest?',
        answer:
            'No. Bots only trade with your available balance. You cannot lose more than your deposited amount. However, you can lose your entire investment if the market moves against you.',
      ),
    ],
  ),
  TradeBotFaqCategory(
    id: 'safety',
    label: 'Safety',
    items: [
      TradeBotFaqItem(
        question: 'What happens if the exchange goes down?',
        answer:
            'If the exchange API fails, the bot stops executing new orders until connection is restored. Open orders remain on exchange books. Use exchanges with 99.9%+ uptime.',
      ),
      TradeBotFaqItem(
        question: 'Can hackers steal my funds?',
        answer:
            'We never have custody of your funds. They stay on the exchange. We only use API keys with trade permissions, not withdrawal permissions.',
      ),
      TradeBotFaqItem(
        question: 'How do I stop a bot in emergency?',
        answer:
            'Go to Risk Dashboard > Emergency Stop, or use the stop button on bot detail page. This immediately stops new orders and can optionally close open positions.',
      ),
      TradeBotFaqItem(
        question: 'What if I find a bug?',
        answer:
            'Use the emergency stop immediately. Report the bug to support@tradingplatform.com with screenshots and bot ID. We review verified bugs and related losses.',
      ),
      TradeBotFaqItem(
        question: 'Are my API keys stored securely?',
        answer:
            'Yes. API keys are encrypted using AES-256 and stored in secure vaults. Keys are never logged or displayed in plain text after creation.',
      ),
    ],
  ),
  TradeBotFaqCategory(
    id: 'technical',
    label: 'Technical',
    items: [
      TradeBotFaqItem(
        question: 'How accurate is backtesting?',
        answer:
            'Backtests use historical data but cannot predict future performance. Expect real results to be 10-20% worse due to slippage, fees, network delays, and partial fills.',
      ),
      TradeBotFaqItem(
        question: 'What fees apply to bot trading?',
        answer:
            'Exchange trading fees apply to every order. Our platform charges no extra fees for bot usage. High-frequency strategies can rack up fees quickly.',
      ),
      TradeBotFaqItem(
        question: 'Can I edit a running bot?',
        answer:
            'No. You must stop the bot, edit parameters, then restart. This prevents strategy corruption mid-cycle and keeps audit history clear.',
      ),
      TradeBotFaqItem(
        question: 'Why did my order not fill?',
        answer:
            'Common reasons include insufficient liquidity, fast price moves, exchange balance or limit rejection, and network latency. Check order history for the exact message.',
      ),
      TradeBotFaqItem(
        question: 'What is slippage and how do I reduce it?',
        answer:
            'Slippage is the difference between expected and actual execution price. Reduce it by trading liquid pairs, using limit orders, splitting large orders, and avoiding low-volume periods.',
      ),
    ],
  ),
  TradeBotFaqCategory(
    id: 'strategies',
    label: 'Strategies',
    items: [
      TradeBotFaqItem(
        question: 'Which bot strategy is best for beginners?',
        answer:
            'DCA is simplest and safest for beginners. It removes emotion, reduces timing risk, and works well long-term. Avoid Martingale until experienced.',
      ),
      TradeBotFaqItem(
        question: 'When should I use a Grid Bot?',
        answer:
            'Use Grid Bots in sideways or ranging markets where price bounces inside a channel. They are not recommended during strong bull or bear runs.',
      ),
      TradeBotFaqItem(
        question: 'What is the Martingale risk?',
        answer:
            'Martingale doubles position after each loss and requires exponential capital. After 5 losses, you need 32x initial capital and max drawdown can exceed -30%.',
      ),
      TradeBotFaqItem(
        question: 'How do I choose the right parameters?',
        answer:
            'Start with recommended defaults, then adjust based on backtest results, your risk tolerance, and market conditions. Avoid over-optimizing.',
      ),
      TradeBotFaqItem(
        question: 'Can I run multiple bots at once?',
        answer:
            'Yes. Free tier supports 1 bot, Pro tier supports 5 bots, and Enterprise supports unlimited bots. Diversify across strategies and pairs for lower risk.',
      ),
    ],
  ),
  TradeBotFaqCategory(
    id: 'troubleshooting',
    label: 'Troubleshooting',
    items: [
      TradeBotFaqItem(
        question: 'My bot is losing money - what should I do?',
        answer:
            'First check whether losses are within expected drawdown. If limits are exceeded, stop the bot, review backtest results, and check whether market conditions changed.',
      ),
      TradeBotFaqItem(
        question: 'Bot stopped working after I changed settings',
        answer:
            'You likely have insufficient balance for new parameters. Check wallet balance, locked funds in other bots, and min or max order sizes.',
      ),
      TradeBotFaqItem(
        question: 'Why is my Grid Bot not executing trades?',
        answer:
            'Grid Bots only trade when price crosses grid levels. If price is stable, no trades execute. Check range, grid spacing, and liquidity.',
      ),
      TradeBotFaqItem(
        question: 'How long should I run a bot before stopping?',
        answer:
            'Minimum 7 days for DCA and 30 days for Grid or Momentum. Bots need time to complete cycles and recover from temporary drawdowns.',
      ),
      TradeBotFaqItem(
        question: 'Can I transfer funds while bot is running?',
        answer:
            'Withdrawing funds may cause a bot to stop if balance drops below minimum. Depositing is safe. Keep a 20% extra buffer for volatility and fees.',
      ),
    ],
  ),
];

const TradeBotTaxSummary _botTaxSummary = TradeBotTaxSummary(
  totalTrades: 1247,
  realizedGains: 3842.50,
  realizedLosses: -1127.30,
  netGainLoss: 2715.20,
  shortTermGains: 2318.40,
  longTermGains: 396.80,
  totalFees: 287.60,
);

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
