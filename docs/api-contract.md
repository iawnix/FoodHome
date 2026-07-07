# API Contract

V0.0 is local-only. V0.1 writes must go through callable Cloud Functions.

## Callable Functions

| Name | Purpose | V0.1 |
| --- | --- | --- |
| `createHousehold` | Create household and return a one-time invite code. | contract + service |
| `joinHousehold` | Join by invite code. | contract + service |
| `upsertDish` | Create or update a dish. | contract + service |
| `submitOrder` | Create an order with `client_request_id`. | contract + service |
| `transitionOrderStatus` | Apply a valid order state transition. | contract + service |
| `addOrderNote` | Add a non-status note to an order. | planned |
| `rateDish` | Store post-meal feedback. | planned |
| `aiParseOrder` | Natural language to order draft. | V0.2 |
| `aiRecommendDishes` | Recommend 3-5 dishes. | V0.2 |

## Order Status

```text
requested -> accepted -> cooking -> served
    |           |          |
    v           v          v
cancelled   cancelled   blocked
```

`blocked` can move to `accepted`, `cooking`, or `cancelled`.

V0.1 callable schemas and the pure service layer live under
`functions/src/contracts` and `functions/src/domain`. They intentionally do not
initialize Firebase Admin SDK yet; deployment wiring should be added only after
the Firebase project and emulator configuration exist outside the repository.
