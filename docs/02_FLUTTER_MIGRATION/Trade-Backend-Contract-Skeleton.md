# Trade Backend Contract Skeleton

Status: skeleton only, pending signed backend contract.

This file keeps the Phase 4 Trade production path fail-closed without inventing
a remote repository. No remote implementation should be wired from this document
until the backend contract is confirmed by the API owner.

## Required Endpoint Groups

| Flow | Method | Path | Notes |
| --- | --- | --- | --- |
| Spot trade screen | `GET` | `/trade/markets/{pair}` | Must return pair metadata, order book, recent trades, balances, limits, fees, and chart data. |
| Order preview | `POST` | `/trade/orders/preview` | Must validate side/type/amount/price, fee, slippage, min-notional, and balance before confirm. |
| Order submit | `POST` | `/trade/orders` | Must require preview id, idempotency key, session proof, and return receipt. |
| Order actions | `POST` | `/trade/orders/{id}/actions` | Must support cancel/amend where allowed and return typed failure reasons. |
| History/receipts | `GET` | `/trade/orders`, `/trade/orders/{id}` | Must support pagination, filters, status, fees, fills, and immutable receipt data. |
| Futures/margin | `GET/POST` | `/trade/futures/*`, `/trade/margin/*` | Must include leverage limits, liquidation/risk preview, funding, maintenance margin, and confirm gates. |
| Copy trading | `GET/POST` | `/trade/copy/*` | Must separate provider discovery, suitability, configuration preview, confirm, audit, and dispute flows. |
| Bots | `GET/POST` | `/trade/bots/*` | Must separate bot read models, create/optimize/backtest actions, emergency stop, security settings, and audit exports. |
| Regulatory/reporting | `GET/POST` | `/trade/regulatory/*` | Must expose costs, RIY/KID, best execution, ARM status, complaints, and inspection artifacts. |

## DTOs To Confirm

- Market DTOs for pair, precision, depth, candles, recent trades, balances,
  order types, and route-level permissions.
- Order preview/confirm DTOs for fee, slippage, notional, risk, preview id,
  receipt id, idempotency, and typed validation errors.
- Futures/margin DTOs for leverage brackets, liquidation preview, funding,
  maintenance margin, risk warnings, and confirm copy.
- Copy/bot DTOs for suitability, provider governance, allocation/risk limits,
  audit logs, emergency stop, and dispute evidence.
- Error DTO shape with stable machine codes for insufficient balance, invalid
  price, min-notional, market closed, risk rejected, leverage limit exceeded,
  rate limit, timeout/offline, locked account, and service unavailable.

## Production Guardrail

Until this contract is signed and DTO tests exist, Trade uses
`FailClosedTradeRepository` whenever `enableMockData == false`. The repository
throws `TradeBackendContractMissingException` for every read or action, so
production never falls back to mock trading data or side-effect behavior.
