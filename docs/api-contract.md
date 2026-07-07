# API Contract

V0.0 is local-only. V0.1 writes must go through callable Cloud Functions.

## Callable Functions

| Name | Purpose | V0.1 |
| --- | --- | --- |
| `createHousehold` | Create household and return a one-time invite code. | callable wired |
| `joinHousehold` | Join by invite code. | callable wired |
| `upsertDish` | Create or update a dish. | callable wired |
| `submitOrder` | Create an order with `client_request_id`. | callable wired |
| `transitionOrderStatus` | Apply a valid order state transition. | callable wired |
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
`functions/src/contracts` and `functions/src/domain`. Firebase callable wrappers
and the Firestore adapter live under `functions/src/firebase`. Real Firebase
project selection stays local through `.firebaserc` and is not committed.
