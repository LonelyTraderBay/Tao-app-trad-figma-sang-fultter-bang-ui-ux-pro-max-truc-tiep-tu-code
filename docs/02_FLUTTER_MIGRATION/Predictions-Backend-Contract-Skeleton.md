# Predictions Backend Contract Skeleton

Status: skeleton only, pending signed backend contract.

This file keeps the Phase 4 Prediction Markets production path fail-closed
without inventing a remote repository. No remote implementation should be wired
from this document until the backend contract is confirmed by the API owner.

## Required Endpoint Groups

| Flow | Method | Path | Notes |
| --- | --- | --- | --- |
| Market discovery | `GET` | `/predictions/events` | Must return active/resolved events, topic/category, probability, liquidity, volume, status, and route permissions. |
| Event detail | `GET` | `/predictions/events/{id}` | Must return outcome book, resolution source, rules, probability history, liquidity, fees, limits, and position summary. |
| Order preview | `POST` | `/predictions/orders/preview` | Must validate side/outcome/amount, fee, probability impact, available wallet balance, limits, and risk before confirm. |
| Order confirm | `POST` | `/predictions/orders` | Must require preview id, idempotency key, session proof, and return immutable receipt. |
| Portfolio/positions | `GET` | `/predictions/portfolio` | Must return open/resolved positions, PnL, exposure, receipts, and cash impact separated from Arena Points. |
| Rewards/leaderboard | `GET` | `/predictions/rewards`, `/predictions/leaderboard` | Must remain trading-context only and expose PnL/positions metrics, not Arena completion metrics. |
| Activity/search/charts | `GET` | `/predictions/search`, `/predictions/activity`, `/predictions/events/{id}/charts` | Must support filters, category bridges, creator discovery context, and stable pagination. |
| Risk/tools | `GET/POST` | `/predictions/risk/*`, `/predictions/market-maker/*` | Must expose calculator inputs, maker inventory/risk, portfolio analyzer, data integrations, and audit metadata. |

## DTOs To Confirm

- Event DTOs for category/topic, status, probability, outcomes, liquidity,
  volume, resolution source, close time, and creator context.
- Position/order DTOs for wallet currency amount, side, outcome, probability,
  fee, exposure, PnL, preview id, receipt id, and idempotency key.
- Portfolio DTOs for open positions, resolved receipts, realized/unrealized
  PnL, risk exposure, and wallet cash impact.
- Chart/activity DTOs for probability history, trades, whale/activity filters,
  pagination, and immutable event context.
- Error DTO shape with stable machine codes for market closed, insufficient
  balance, invalid outcome, limit exceeded, resolution locked, risk rejected,
  timeout/offline, rate limit, locked account, and service unavailable.

## Production Guardrail

Until this contract is signed and DTO tests exist, Prediction Markets uses
`FailClosedPredictionsRepository` whenever `enableMockData == false`. The
repository throws `PredictionsBackendContractMissingException` for every read or
action, so production never falls back to mock markets, positions, PnL, or
receipt data.
