# FoodHome Roadmap

## Current State

V0.0 is implemented as a local Flutter prototype:

- Household shell with two demo members.
- Tonight order flow with dish, time, taste, and note inputs.
- Kitchen status transitions backed by a shared state machine.
- Family menu add/edit/favorite/block/delete operations.
- Taste preference and excluded ingredient settings.
- Cloud Functions TypeScript state machine, AI schemas, and sanitize tests.
- Firebase emulator config, rules, indexes, and V0.1 callable wrappers drafted.

## Next Work

### 1. Firebase V0.1 Core Loop

- Create a Firebase project outside the repository.
- Add environment-specific Firebase config locally only.
- Implement Anonymous Auth bootstrap.
- Smoke-test callable functions in Firebase emulator:
  - `createHousehold`
  - `joinHousehold`
  - `upsertDish`
  - `submitOrder`
  - `transitionOrderStatus`
- Replace the Flutter in-memory controller with repository/data-source layers.

### 2. Two-Device Sync Acceptance

- Two devices join the same household with a six-digit invite code.
- New order appears on the kitchen device within three seconds.
- Status changes sync within three seconds.
- Illegal status transitions are rejected by Cloud Functions.
- Direct Firestore writes for orders and events stay blocked by rules.

### 3. Notifications

- Add FCM token registration.
- Add notification records for:
  - `new_order`
  - `order_accepted`
  - `missing_ingredient`
  - `served`
- Use fixed notification templates, not raw household notes.

### 4. AI V0.2

- Add Secret Manager-backed provider configuration.
- Implement `aiParseOrder`.
- Implement `aiRecommendDishes`.
- Keep AI optional: timeout or schema failure must fall back to manual ordering.
- Extend sanitize golden tests before any real AI request is enabled.

## Not Yet In Scope

- Payment, delivery, restaurant workflows.
- Public recipe community or social feed.
- Full inventory tracking.
- Photo journal, share image generation, and cooking mode.
- External link scraping from short-video platforms.
