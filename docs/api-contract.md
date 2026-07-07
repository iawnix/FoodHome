# API Contract

V0.0 is local-only. V0.1 writes must go through callable Cloud Functions.

## Callable Functions

| Name | Purpose | V0.1 |
| --- | --- | --- |
| `createHousehold` | Create household and return a one-time invite code. | planned |
| `joinHousehold` | Join by invite code. | planned |
| `upsertDish` | Create or update a dish. | planned |
| `submitOrder` | Create an order with `client_request_id`. | planned |
| `transitionOrderStatus` | Apply a valid order state transition. | planned |
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
