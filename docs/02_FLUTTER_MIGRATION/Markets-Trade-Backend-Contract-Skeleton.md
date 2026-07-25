# Markets / Trade Backend Contract Skeleton

Status: skeleton only, pending signed backend contract.

This file exists to keep the Phase 4 Markets basic data and Trade basic
order/history production paths fail-closed without inventing remote
repositories. No remote implementation should be wired from this document until
the backend contract is confirmed by the API owner.

P0 scope is Markets basic + Trade basic order/history only (not futures, copy,
bots, or regulatory packs), per `ke-hoach-san-sang-production.md`.

## Required Endpoints

| Flow | Method | Path | Notes |
| --- | --- | --- | --- |
| Markets list | `GET` | `/markets` | Must return pair list with search/filter metadata and route permissions. |
| Market detail | `GET` | `/markets/{pair}` | Must return pair metadata needed for the markets detail surface. |
| Trade market screen | `GET` | `/trade/markets/{pair}` | Must return order book, recent trades, balances, limits, fees, and chart inputs for the trade screen. |
| Order preview | `POST` | `/trade/orders/preview` | Must validate side/type/amount/price, fee, slippage, min-notional, and balance before confirm. |
| Order confirm | `POST` | `/trade/orders/confirm` | Must require preview binding, session proof, idempotency, and return a receipt. |
| Order history | `GET` | `/trade/orders` | Must support pagination/filters for open and historical orders. |
| Order detail | `GET` | `/trade/orders/{id}` | Must return immutable receipt fields, fills, fees, and status. |

## DTOs To Confirm

- Markets DTOs for pair id/symbol, precision, status, and list/detail fields
  consumed by the markets hub.
- Trade market DTOs for depth, recent trades, balances, limits, fees, and
  allowed order types.
- Order preview/confirm DTOs for preview id, fee, slippage, notional, risk,
  receipt id, idempotency key, and typed validation errors.
- Order history/detail DTOs for status, fills, fees, timestamps, and immutable
  receipt identifiers.
- Error DTO shape with stable machine codes for insufficient balance, invalid
  price, min-notional, market closed, preview expired, rate limit,
  offline/timeout, locked account, and service unavailable.

## Production Guardrail

Until this contract is signed and DTO tests exist:

- Markets uses `FailClosedMarketRepository` whenever `enableMockData == false`.
- Trade uses `FailClosedTradeRepository` whenever `enableMockData == false`.

Those repositories throw `MarketBackendContractMissingException` /
`TradeBackendContractMissingException` respectively, and the presentation layer
renders a controlled error state instead of using mock data or crashing on
provider read.
