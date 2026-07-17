part of '../repositories/mock_wallet_repository.dart';

const List<WalletManagerItem> _walletManagerWallets = [
  WalletManagerItem(
    id: 'w1',
    name: 'Main Wallet',
    address: '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb',
    type: 'hot',
    balanceUsd: 45280,
    change24hPct: 3.2,
    lastActiveLabel: '23:27 18 thg 5',
    isDefault: true,
    isFavorite: true,
    groupId: 'g1',
    accentColorHex: 0xFF10B981,
    typeColorHex: 0xFFF59E0B,
    distributionColorHex: 0xFF10B981,
    assets: [
      WalletManagerAsset(symbol: 'BTC', balance: .45, valueUsd: 28500),
      WalletManagerAsset(symbol: 'ETH', balance: 5.2, valueUsd: 13000),
      WalletManagerAsset(symbol: 'USDT', balance: 3780, valueUsd: 3780),
    ],
  ),
  WalletManagerItem(
    id: 'w2',
    name: 'Trading Wallet',
    address: '0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063',
    type: 'hot',
    balanceUsd: 28900,
    change24hPct: -1.5,
    lastActiveLabel: '22:32 18 thg 5',
    isDefault: false,
    isFavorite: true,
    groupId: 'g1',
    accentColorHex: 0xFF3B82F6,
    typeColorHex: 0xFFF59E0B,
    distributionColorHex: 0xFF3B82F6,
    assets: [
      WalletManagerAsset(symbol: 'ETH', balance: 8.5, valueUsd: 21250),
      WalletManagerAsset(symbol: 'BNB', balance: 15, valueUsd: 7650),
    ],
  ),
  WalletManagerItem(
    id: 'w3',
    name: 'Cold Storage',
    address: '0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984',
    type: 'cold',
    balanceUsd: 125000,
    change24hPct: .8,
    lastActiveLabel: '23:31 11 thg 5',
    isDefault: false,
    isFavorite: false,
    groupId: 'g2',
    accentColorHex: 0xFFF59E0B,
    typeColorHex: 0xFF3B82F6,
    distributionColorHex: 0xFFF59E0B,
    assets: [
      WalletManagerAsset(symbol: 'BTC', balance: 1.5, valueUsd: 95000),
      WalletManagerAsset(symbol: 'ETH', balance: 12, valueUsd: 30000),
    ],
  ),
  WalletManagerItem(
    id: 'w4',
    name: 'Hardware Ledger',
    address: '0x514910771AF9Ca656af840dff83E8264EcF986CA',
    type: 'hardware',
    balanceUsd: 68500,
    change24hPct: 2.1,
    lastActiveLabel: '23:32 16 thg 5',
    isDefault: false,
    isFavorite: false,
    groupId: 'g2',
    accentColorHex: 0xFF8B5CF6,
    typeColorHex: 0xFF10B981,
    distributionColorHex: 0xFF8B5CF6,
    assets: [
      WalletManagerAsset(symbol: 'BTC', balance: .85, valueUsd: 53900),
      WalletManagerAsset(symbol: 'USDT', balance: 14600, valueUsd: 14600),
    ],
  ),
];

const List<WalletManagerGroup> _walletManagerGroups = [
  WalletManagerGroup(
    id: 'g1',
    name: 'Active Trading',
    colorHex: 0xFF10B981,
    walletIds: ['w1', 'w2'],
    totalValueUsd: 74180,
  ),
  WalletManagerGroup(
    id: 'g2',
    name: 'Long Term Hold',
    colorHex: 0xFF3B82F6,
    walletIds: ['w3', 'w4'],
    totalValueUsd: 193500,
  ),
];

const List<WalletGasLevel> _walletGasLevels = [
  WalletGasLevel(
    speed: 'slow',
    label: 'Slow',
    gwei: 15,
    usd: 2.10,
    timeEstimate: '~3 min',
    recommended: false,
    colorHex: 0xFF10B981,
  ),
  WalletGasLevel(
    speed: 'standard',
    label: 'Standard',
    gwei: 25,
    usd: 3.50,
    timeEstimate: '~1 min',
    recommended: true,
    colorHex: 0xFFF59E0B,
  ),
  WalletGasLevel(
    speed: 'fast',
    label: 'Fast',
    gwei: 35,
    usd: 4.90,
    timeEstimate: '~15 sec',
    recommended: false,
    colorHex: 0xFFEF4444,
  ),
];

const List<WalletGasComparison> _walletGasComparisons = [
  WalletGasComparison(type: 'Simple Transfer', gas: 21000, usd: 3.50),
  WalletGasComparison(type: 'Token Transfer', gas: 65000, usd: 10.80),
  WalletGasComparison(type: 'Swap (DEX)', gas: 180000, usd: 29.70),
  WalletGasComparison(type: 'NFT Mint', gas: 120000, usd: 19.80),
];

const List<WalletGasHistoryPoint> _walletGasHistory = [
  WalletGasHistoryPoint(time: '00:00', slow: 12, standard: 20, fast: 28),
  WalletGasHistoryPoint(time: '04:00', slow: 10, standard: 18, fast: 25),
  WalletGasHistoryPoint(time: '08:00', slow: 18, standard: 28, fast: 38),
  WalletGasHistoryPoint(time: '12:00', slow: 22, standard: 35, fast: 48),
  WalletGasHistoryPoint(time: '16:00', slow: 20, standard: 32, fast: 42),
  WalletGasHistoryPoint(time: '20:00', slow: 15, standard: 25, fast: 35),
  WalletGasHistoryPoint(time: 'Now', slow: 15, standard: 25, fast: 35),
];

const List<WalletNetworkActivityPoint> _walletNetworkActivity = [
  WalletNetworkActivityPoint(hour: '0h', txCount: 1200),
  WalletNetworkActivityPoint(hour: '4h', txCount: 800),
  WalletNetworkActivityPoint(hour: '8h', txCount: 2400),
  WalletNetworkActivityPoint(hour: '12h', txCount: 3200),
  WalletNetworkActivityPoint(hour: '16h', txCount: 2800),
  WalletNetworkActivityPoint(hour: '20h', txCount: 1800),
  WalletNetworkActivityPoint(hour: 'Now', txCount: 1500),
];

const List<WalletGasTip> _walletGasTips = [
  WalletGasTip(
    id: 't1',
    title: 'Transact During Low Activity',
    description:
        'Gas fees are lowest between 2 AM - 6 AM UTC when network activity is minimal',
    potentialSaving: 'Up to 60%',
    difficulty: 'easy',
    category: 'timing',
  ),
  WalletGasTip(
    id: 't2',
    title: 'Batch Transactions',
    description:
        'Combine multiple operations into one transaction to save on base gas fees',
    potentialSaving: '30-40%',
    difficulty: 'medium',
    category: 'optimization',
  ),
  WalletGasTip(
    id: 't3',
    title: 'Use Layer 2 Solutions',
    description:
        'Move assets to L2 networks like Arbitrum or Optimism for 90% lower fees',
    potentialSaving: 'Up to 90%',
    difficulty: 'easy',
    category: 'strategy',
  ),
  WalletGasTip(
    id: 't4',
    title: 'Set Custom Gas Limit',
    description: 'Reduce gas limit for simple transfers to avoid overpaying.',
    potentialSaving: '10-20%',
    difficulty: 'medium',
    category: 'optimization',
  ),
];

const List<WalletTokenApproval> _walletTokenApprovals = [
  WalletTokenApproval(
    id: 'a1',
    token: 'USDT',
    tokenAddress: '0xdAC17F958D2ee523a2206206994597C13D831ec7',
    spender: '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D',
    spenderName: 'Uniswap V2 Router',
    amountLabel: 'Unlimited',
    approvedAtLabel: 'thg 2 2026',
    lastUsedLabel: '11 thg 5',
    usageCount: 45,
    riskLevel: 'medium',
    verified: true,
    category: 'dex',
  ),
  WalletTokenApproval(
    id: 'a2',
    token: 'DAI',
    tokenAddress: '0x6B175474E89094C44Da98b954EedeAC495271d0F',
    spender: '0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9',
    spenderName: 'Aave Lending Pool',
    amountLabel: '50,000',
    approvedAtLabel: 'thg 3 2026',
    lastUsedLabel: '4 thg 5',
    usageCount: 12,
    riskLevel: 'low',
    verified: true,
    category: 'lending',
  ),
  WalletTokenApproval(
    id: 'a3',
    token: 'WETH',
    tokenAddress: '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2',
    spender: '0x1234567890123456789012345678901234567890',
    spenderName: 'Unknown Contract',
    amountLabel: 'Unlimited',
    approvedAtLabel: 'thg 11 2025',
    lastUsedLabel: 'Never',
    usageCount: 0,
    riskLevel: 'critical',
    verified: false,
    category: 'unknown',
  ),
  WalletTokenApproval(
    id: 'a4',
    token: 'USDC',
    tokenAddress: '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48',
    spender: '0xdef1c0ded9bec7f1a1670819833240f027b25eff',
    spenderName: '0x Exchange Proxy',
    amountLabel: '100,000',
    approvedAtLabel: 'thg 4 2026',
    lastUsedLabel: '15 thg 5',
    usageCount: 28,
    riskLevel: 'low',
    verified: true,
    category: 'dex',
  ),
  WalletTokenApproval(
    id: 'a5',
    token: 'UNI',
    tokenAddress: '0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984',
    spender: '0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45',
    spenderName: 'Uniswap V3 Router',
    amountLabel: 'Unlimited',
    approvedAtLabel: 'thg 1 2026',
    lastUsedLabel: '3 thg 4',
    usageCount: 8,
    riskLevel: 'high',
    verified: true,
    category: 'dex',
  ),
];

const List<WalletRevokedApproval> _walletRevokedApprovals = [
  WalletRevokedApproval(
    id: 'r1',
    token: 'SHIB',
    spenderName: 'Suspicious Contract',
    revokedAtLabel: '13 thg 5, 23:32',
    reason: 'Security risk detected',
  ),
  WalletRevokedApproval(
    id: 'r2',
    token: 'LINK',
    spenderName: 'Old DeFi Protocol',
    revokedAtLabel: '28 thg 4, 23:32',
    reason: 'No longer using',
  ),
];

const List<WalletHealthMetric> _walletHealthMetrics = [
  WalletHealthMetric(
    category: 'Security',
    score: 75,
    maxScore: 100,
    status: 'good',
  ),
  WalletHealthMetric(
    category: 'Diversification',
    score: 60,
    maxScore: 100,
    status: 'warning',
  ),
  WalletHealthMetric(
    category: 'Activity',
    score: 85,
    maxScore: 100,
    status: 'excellent',
  ),
  WalletHealthMetric(
    category: 'Risk Management',
    score: 70,
    maxScore: 100,
    status: 'good',
  ),
  WalletHealthMetric(
    category: 'Backup & Recovery',
    score: 45,
    maxScore: 100,
    status: 'critical',
  ),
];

const List<WalletDiversificationSlice> _walletHealthDiversification = [
  WalletDiversificationSlice(name: 'BTC', value: 42, colorHex: 0xFFF59E0B),
  WalletDiversificationSlice(name: 'ETH', value: 28, colorHex: 0xFF3B82F6),
  WalletDiversificationSlice(
    name: 'Stablecoins',
    value: 18,
    colorHex: 0xFF10B981,
  ),
  WalletDiversificationSlice(name: 'Altcoins', value: 12, colorHex: 0xFF8B5CF6),
];

const List<WalletHealthHistoryPoint> _walletHealthHistory = [
  WalletHealthHistoryPoint(month: 'Jan', score: 65),
  WalletHealthHistoryPoint(month: 'Feb', score: 68),
  WalletHealthHistoryPoint(month: 'Mar', score: 72),
  WalletHealthHistoryPoint(month: 'Apr', score: 70),
  WalletHealthHistoryPoint(month: 'May', score: 75),
  WalletHealthHistoryPoint(month: 'Jun', score: 73),
];

const List<WalletHealthRecommendation> _walletHealthRecommendations = [
  WalletHealthRecommendation(
    id: 'r1',
    title: 'Enable 2FA',
    description:
        'Two-factor authentication adds an extra security layer to your wallet',
    impact: 'high',
    category: 'security',
    actionLabel: 'Enable Now',
  ),
  WalletHealthRecommendation(
    id: 'r2',
    title: 'Backup Seed Phrase',
    description:
        'Create an encrypted backup of your seed phrase in secure storage',
    impact: 'high',
    category: 'backup',
    actionLabel: 'Backup Now',
  ),
  WalletHealthRecommendation(
    id: 'r3',
    title: 'Diversify Portfolio',
    description:
        '42% concentration in BTC. Consider rebalancing to reduce risk',
    impact: 'medium',
    category: 'diversification',
    actionLabel: 'View Plan',
  ),
  WalletHealthRecommendation(
    id: 'r4',
    title: 'Review Token Approvals',
    description: 'You have 3 unlimited approvals to unverified contracts',
    impact: 'high',
    category: 'security',
    actionLabel: 'Review',
  ),
  WalletHealthRecommendation(
    id: 'r5',
    title: 'Test Recovery Process',
    description:
        'Last recovery test was 6 months ago. Test your backup regularly',
    impact: 'medium',
    category: 'backup',
    actionLabel: 'Test Now',
  ),
];

const List<WalletSecurityChecklistItem> _walletSecurityChecklist = [
  WalletSecurityChecklistItem(
    item: '2FA Enabled',
    enabled: true,
    description: 'Google Authenticator active',
  ),
  WalletSecurityChecklistItem(
    item: 'Email Verification',
    enabled: true,
    description: 'Verified on signup',
  ),
  WalletSecurityChecklistItem(
    item: 'Biometric Lock',
    enabled: true,
    description: 'Face ID enabled',
  ),
  WalletSecurityChecklistItem(
    item: 'Seed Phrase Backup',
    enabled: false,
    description: 'Not backed up securely',
  ),
  WalletSecurityChecklistItem(
    item: 'Anti-Phishing Code',
    enabled: true,
    description: 'Set: XK89',
  ),
  WalletSecurityChecklistItem(
    item: 'Withdrawal Whitelist',
    enabled: false,
    description: 'Not configured',
  ),
  WalletSecurityChecklistItem(
    item: 'Session Timeout',
    enabled: true,
    description: '15 minutes',
  ),
  WalletSecurityChecklistItem(
    item: 'Device Authorization',
    enabled: true,
    description: '2 devices registered',
  ),
];

const List<WalletPendingDeposit> _walletPendingDeposits = [
  WalletPendingDeposit(
    id: 'pd001',
    asset: 'USDT',
    amountLabel: '5,000.00',
    network: 'TRC20',
    txHash: '0xa1b2c3d4e5f6...789abc',
    confirmations: 1,
    requiredConfirmations: 1,
    status: 'credited',
    createdAt: '11/03/2026 14:32',
    estimatedArrival: '\u0110\u00E3 xong',
    fromAddress: 'TQnK...Xyz12',
  ),
  WalletPendingDeposit(
    id: 'pd002',
    asset: 'BTC',
    amountLabel: '0.050000',
    network: 'Bitcoin',
    txHash: 'bc1q...f8a2d3',
    confirmations: 1,
    requiredConfirmations: 2,
    status: 'confirming',
    createdAt: '11/03/2026 13:15',
    estimatedArrival: '~15 ph\u00FAt',
    fromAddress: 'bc1q...sW8k',
  ),
  WalletPendingDeposit(
    id: 'pd003',
    asset: 'ETH',
    amountLabel: '1.2000',
    network: 'ERC20',
    txHash: '0x7e8f9a0b1c2d...e3f456',
    confirmations: 5,
    requiredConfirmations: 12,
    status: 'confirming',
    createdAt: '11/03/2026 12:40',
    estimatedArrival: '~7 ph\u00FAt',
    fromAddress: '0x742d...C29f',
  ),
  WalletPendingDeposit(
    id: 'pd004',
    asset: 'USDT',
    amountLabel: '200.0000',
    network: 'ERC20',
    txHash: '0xdead...beef',
    confirmations: 0,
    requiredConfirmations: 12,
    status: 'failed',
    createdAt: '10/03/2026 09:00',
    estimatedArrival: 'Th\u1EA5t b\u1EA1i',
    fromAddress: '0x123...456',
  ),
];

const List<WalletKycTier> _walletKycTiers = [
  WalletKycTier(
    level: 0,
    name: 'Ch\u01B0a x\u00E1c minh',
    dailyLimit: 0,
    monthlyLimit: 0,
    singleTxLimit: 0,
    requirements: ['\u0110\u0103ng k\u00FD t\u00E0i kho\u1EA3n'],
    features: ['Xem gi\u00E1', 'Danh s\u00E1ch theo d\u00F5i'],
    colorHex: 0xFF94A3B8,
  ),
  WalletKycTier(
    level: 1,
    name: 'C\u01A1 b\u1EA3n',
    dailyLimit: 10000,
    monthlyLimit: 50000,
    singleTxLimit: 5000,
    requirements: ['Email x\u00E1c minh', 'S\u1ED1 \u0111i\u1EC7n tho\u1EA1i'],
    features: [
      'N\u1EA1p ti\u1EC1n',
      'Giao d\u1ECBch Spot',
      'R\u00FAt ti\u1EC1n c\u01A1 b\u1EA3n',
    ],
    colorHex: 0xFF3B82F6,
  ),
  WalletKycTier(
    level: 2,
    name: 'N\u00E2ng cao',
    dailyLimit: 100000,
    monthlyLimit: 500000,
    singleTxLimit: 50000,
    requirements: ['CMND/CCCD', 'Nh\u1EADn di\u1EC7n khu\u00F4n m\u1EB7t'],
    features: ['P2P Trading', 'R\u00FAt ti\u1EC1n n\u00E2ng cao', 'API Access'],
    colorHex: 0xFF10B981,
  ),
  WalletKycTier(
    level: 3,
    name: 'VIP',
    dailyLimit: 1000000,
    monthlyLimit: 5000000,
    singleTxLimit: 500000,
    requirements: [
      'KYC Level 2',
      'Volume > \$100K/th\u00E1ng',
      'Duy\u1EC7t VIP',
    ],
    features: [
      'H\u1EA1n m\u1EE9c VIP',
      'Ph\u00ED giao d\u1ECBch gi\u1EA3m',
      'H\u1ED7 tr\u1EE3 \u01B0u ti\u00EAn',
      'OTC Trading',
    ],
    colorHex: 0xFFF59E0B,
  ),
];

const List<WalletLimitFaq> _walletLimitFaqs = [
  WalletLimitFaq(
    question: 'H\u1EA1n m\u1EE9c reset khi n\u00E0o?',
    answer:
        'H\u1EA1n m\u1EE9c ng\u00E0y reset l\u00FAc 00:00 UTC. H\u1EA1n m\u1EE9c th\u00E1ng reset ng\u00E0y 1 h\u00E0ng th\u00E1ng.',
  ),
  WalletLimitFaq(
    question: 'R\u00FAt v\u01B0\u1EE3t h\u1EA1n m\u1EE9c th\u00EC sao?',
    answer:
        'Y\u00EAu c\u1EA7u r\u00FAt s\u1EBD b\u1ECB t\u1EEB ch\u1ED1i. B\u1EA1n c\u00F3 th\u1EC3 n\u00E2ng c\u1EA5p KYC ho\u1EB7c ch\u1EDD h\u1EA1n m\u1EE9c reset.',
  ),
  WalletLimitFaq(
    question: 'Ph\u00ED r\u00FAt c\u00F3 t\u00EDnh v\u00E0o h\u1EA1n m\u1EE9c?',
    answer:
        'Kh\u00F4ng. H\u1EA1n m\u1EE9c ch\u1EC9 t\u00EDnh s\u1ED1 ti\u1EC1n th\u1EF1c r\u00FAt, kh\u00F4ng bao g\u1ED3m ph\u00ED m\u1EA1ng.',
  ),
];

const List<WalletDustTarget> _walletDustTargets = [
  WalletDustTarget(symbol: 'USDT', name: 'Tether USD', colorHex: 0xFF26A17B),
  WalletDustTarget(symbol: 'BNB', name: 'BNB', colorHex: 0xFFF3BA2F),
];
