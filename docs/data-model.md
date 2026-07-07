# Data Model

## Required Collections

| Collection | Scope | Notes |
| --- | --- | --- |
| `households` | household | Stores member ids and invite code hash only. |
| `users` | user | Stores display name and household id. |
| `dishes` | household | Family menu items. |
| `orders` | household | One meal request. |
| `order_events` | order | Append-only status and note events. |
| `preferences` | user | Taste preferences and excluded ingredients. |
| `notifications` | user | FCM-backed notification records. |
| `ai_request_logs` | request | Metadata only, no raw household history. |

## Delayed Collections

`ingredients`, `shopping_lists`, `achievements`, `badges`,
`order_reactions`, `dish_sources`, `cook_journals`, `cooking_sessions`, and
`dish_step_calibrations` are reserved for later versions.
