part of '../repositories/mock_market_repository.dart';

const TokenFundamentalsDraft _btcFundamentals = TokenFundamentalsDraft(
  id: 'btcusdt',
  symbol: 'BTC',
  name: 'Bitcoin',
  description:
      'Bitcoin la tien te ky thuat so phi tap trung dau tien, hoat dong tren mang luoi ngang hang khong can trung gian, su dung co che Proof of Work.',
  consensus: 'Proof of Work (SHA-256)',
  network: 'Bitcoin',
  website: 'https://bitcoin.org',
  whitepaper: 'https://bitcoin.org/bitcoin.pdf',
  github: 'https://github.com/bitcoin/bitcoin',
  twitter: 'https://x.com/bitcoin',
  telegram: '',
  circulatingSupply: 19630000,
  totalSupply: 19630000,
  maxSupply: 21000000,
  fullyDilutedValuation: 1418410000000,
  inflationRate: 1.74,
  allTimeHigh: 73750.07,
  allTimeHighDate: '2024-03-14',
  allTimeLow: 67.81,
  allTimeLowDate: '2013-07-06',
  roi1y: 125.40,
  activeAddresses24h: 987654,
  txCount24h: 543210,
  holders: 53120000,
  tvl: null,
  supplyDistribution: [
    SupplyDistributionDraft(
      label: 'Luu hanh',
      percentage: 93.5,
      color: AppAssetColors.btc,
    ),
    SupplyDistributionDraft(
      label: 'Chua dao',
      percentage: 6.5,
      color: AppAssetColors.brownChain,
    ),
  ],
  contractAddresses: [],
);

const Map<String, TokenFundamentalsDraft> _tokenFundamentals = {
  'btcusdt': _btcFundamentals,
};
