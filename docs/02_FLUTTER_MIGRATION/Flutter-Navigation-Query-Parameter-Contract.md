# Flutter Navigation Query Parameter Contract

This contract defines the reviewed query parameters for app routes that are
used by navigation cards, deep links, redirects, or QA scenarios.

## Trade

| Route | Key | Allowed values | Fallback |
| --- | --- | --- | --- |
| `/trade/<pairId>` | `side` | `buy`, `sell` | `buy` |
| `/trade` | `side` | `buy`, `sell` | `buy` |

The query only preselects the order side. It must not submit an order or skip
preview, validation, receipt, or risk controls.

## P2P

| Route | Key | Allowed values | Fallback |
| --- | --- | --- | --- |
| `/p2p/wallet/transfer` | `direction` | `from-main`, `to-main` | uses `type`, then `deposit` |
| `/p2p/wallet/transfer` | `type` | `deposit`, `withdraw` | `deposit` |
| `/p2p/wallet/transfer` | `asset` | `USDT`, `BTC`, `VND` | `USDT` |
| `/p2p/escrow/balance` | `asset` | `USDT`, `BTC`, `VND` | `USDT` |

`direction` takes precedence over `type` for wallet transfers. Invalid P2P
query values must fall back before the page reads its provider, so a bad deep
link cannot create an invalid transfer snapshot.

## Rewards

| Route | Key | Allowed values | Fallback |
| --- | --- | --- | --- |
| `/rewards` | `tab` | `arena` | default rewards filter |

The Arena redirect may use `/rewards?tab=arena` to preselect the Arena rewards
filter. Invalid `tab` values must render the Rewards Hub normally.
