# FoodHome 技术方案

**配套文档**：
- 产品方案：`family-menu-app-plan.md`
- 代码风格与工程规范：`foodhome-code-style.md`

三份文档分工：产品方案说"做什么"，本文说"用什么做"，风格规范说"怎么写不烂"。任何工程决策若与风格规范冲突，以风格规范为准。

## 1. 技术结论

第一版采用 **Flutter + Firebase + Cloud Functions + LLM Gateway**。

核心判断：

- 一个 Flutter App 内做两种视图：点菜视图、厨房视图。
- 客户端允许直接读 Firestore，但关键写入必须走 Cloud Functions。
- 订单状态机、邀请码、AI 调用、通知、隐私脱敏全部在服务端执行。
- AI 是增强层，不能阻断点菜主流程。
- MVP 只做“家庭空间 + 菜单 + 点菜 + 厨房同步 + AI 推荐/整理”。

第一版不做：

- 徽章系统。
- 家庭荣誉墙。
- 分享图生成。
- 外链自动抓取。
- 做饭模式。
- 图片识别。
- 复杂食材库存。

这些功能保留接口和数据余地，但不进入 V0.1 工程闭环。

## 2. 推荐技术栈

### 2.1 客户端

- Flutter stable。
- Dart。
- 状态管理：Riverpod。
- 路由：go_router。
- 数据模型：freezed + json_serializable。
- Firebase SDK：
  - firebase_core
  - firebase_auth
  - cloud_firestore
  - firebase_functions
  - firebase_messaging
  - firebase_storage
  - firebase_crashlytics
  - firebase_analytics

### 2.2 后端

- Firebase Cloud Functions v2。
- TypeScript。
- Firestore。
- Firebase Storage。
- Firebase Cloud Messaging。
- Secret Manager 保存 AI API key。
- Zod 做输入输出 schema 校验。

### 2.3 AI

- 后端封装 `AiProvider` interface。
- 第一版只依赖一个 OpenAI-compatible provider。
- 所有 AI 输出必须走 JSON schema 校验。
- 所有 AI 请求前必须经过 `sanitize(payload, purpose)`。
- Provider、模型名、温度、超时、重试策略全部服务端配置化。

### 2.4 原型认证策略

产品方案写的是手机号登录。工程上建议分两阶段：

- Alpha：Firebase Anonymous Auth + 昵称 + 家庭邀请码。
- Beta/正式：手机号登录、Apple 登录或微信登录。

原因：两人家庭内测时，手机号短信、地区支持、验证码成本和审核摩擦都不是主价值。先验证点菜闭环和同步体验，再补生产级登录。

## 3. 系统架构

```text
Flutter App
  ├─ Orderer View
  ├─ Kitchen View
  ├─ Menu View
  ├─ AI Assistant View
  └─ Settings View
        │
        ├─ Firestore read streams
        │    ├─ household scoped dishes
        │    ├─ active orders
        │    └─ order events
        │
        ├─ Callable Functions writes
        │    ├─ createHousehold
        │    ├─ joinHousehold
        │    ├─ upsertDish
        │    ├─ submitOrder
        │    ├─ transitionOrderStatus
        │    ├─ postOrderReaction
        │    ├─ aiParseOrder
        │    └─ aiRecommendDishes
        │
        └─ FCM push

Cloud Functions
  ├─ command handlers
  ├─ state machine validator
  ├─ security/domain services
  ├─ AI gateway
  ├─ notification dispatcher
  └─ scheduled maintenance

Firestore
  ├─ households
  ├─ users
  ├─ dishes
  ├─ orders
  ├─ order_items
  ├─ order_events
  ├─ preferences
  ├─ notifications
  └─ ai_request_logs
```

## 4. 仓库结构

建议从一开始建 monorepo：

```text
foodhome/
  app/
    lib/
      main.dart
      app.dart
      core/
        routing/
        theme/
        firebase/
        result/
        errors/
      features/
        auth/
        household/
        menu/
        orders/
        kitchen/
        ai_assistant/
        settings/
      shared/
        widgets/
        models/
        repositories/
    test/
    integration_test/
    pubspec.yaml

  functions/
    src/
      index.ts
      config/
      domain/
        order_state_machine.ts
        household_membership.ts
        invite_codes.ts
      functions/
        household.ts
        dishes.ts
        orders.ts
        ai.ts
        notifications.ts
      ai/
        provider.ts
        prompts.ts
        sanitize.ts
        schemas.ts
      firestore/
        refs.ts
        converters.ts
      observability/
        logger.ts
        metrics.ts
    __tests__/
      order_state_machine.test.ts
      sanitize.golden.test.ts
      ai_schema.test.ts
    package.json

  firebase/
    firestore.rules
    firestore.indexes.json
    storage.rules

  docs/
    product-plan.md
    technical-plan.md
    api-contract.md
    data-model.md

  scripts/
    doctor.sh
```

如果在当前目录继续推进，可把这个结构放到：

`/home/iaw/Codex/Project/2026-07-07/family-menu-app/foodhome/`

## 5. MVP 范围切片

### 5.1 V0.0 本地假数据原型

目标：先验证主交互，不接后端。

页面：

- 家庭首页。
- 今天想吃。
- 菜单列表。
- 厨房接单。
- 订单详情。

实现：

- Flutter 本地内存 repository。
- 固定两名用户。
- 固定 10 道菜。
- 模拟订单状态变化。

验收：

- 30 秒内能完成一次点菜。
- 厨房视图能看到新单。
- 状态文案和家庭感成立。

### 5.2 V0.1 Firebase 核心闭环

目标：真实两台手机同步。

功能：

- Anonymous Auth。
- 创建/加入家庭。
- 家庭菜单 CRUD。
- 提交订单。
- 厨房接单。
- 状态流转。
- 基础通知。

不接 AI。

验收：

- 两台设备加入同一家庭。
- 一端提交订单，另一端 3 秒内看到。
- 所有状态转移由服务端校验。
- 断网恢复后不会产生重复订单或非法状态。

### 5.3 V0.2 AI MVP

目标：AI 只服务两个高频动作。

功能：

- `aiParseOrder`：一句话转订单草稿。
- `aiRecommendDishes`：不知道吃什么时推荐 3-5 道。
- AI 失败时回退手动输入。
- AI 请求脱敏与 schema 校验。

暂不做：

- AI 菜谱步骤。
- 外链解析。
- 图片识别。

### 5.4 V0.3 体验增强

功能：

- 上菜评价。
- 一键贴纸。
- 最近吃过。
- AI 简化购物清单。

仍不建议此阶段做完整徽章系统。可以先做“成就事件”，不要做长期等级。

### 5.5 V0.4 做饭模式

做饭模式是强功能，但依赖稳定菜谱 step schema。应在订单闭环、AI schema、厨房视图稳定后再做。

功能：

- 大字体步骤。
- 本地 TTS。
- 计时器。
- 屏幕常亮。
- 中断恢复。

## 6. 数据模型落地

产品方案里的数据模型偏完整。工程第一版只建必要集合：

```text
households/{householdId}
users/{userId}
dishes/{dishId}
orders/{orderId}
order_items/{itemId}
order_events/{eventId}
preferences/{userId}
notifications/{notificationId}
ai_request_logs/{requestId}
```

延后集合：

- `ingredients`
- `ai_memory`
- `shopping_lists`
- `achievements`
- `badges`
- `order_reactions`
- `dish_sources`
- `cook_journals`
- `cooking_sessions`
- `dish_step_calibrations`

这些集合可以在 schema 文档里保留，但不要在第一版建 UI 和逻辑。

## 7. Firestore 设计

### 7.1 集合字段

`households`：

```json
{
  "name": "我们家",
  "owner_user_id": "uid",
  "member_ids": ["uid1", "uid2"],
  "invite_code_hash": "hash",
  "invite_code_expires_at": "timestamp",
  "created_at": "timestamp",
  "updated_at": "timestamp"
}
```

不保存明文邀请码；只保存 hash。创建家庭时把明文邀请码返回给创建者。

`users`：

```json
{
  "display_name": "小雨",
  "avatar_url": null,
  "household_id": "householdId",
  "role_preference": "both",
  "created_at": "timestamp",
  "updated_at": "timestamp"
}
```

`dishes`：

```json
{
  "household_id": "householdId",
  "name": "番茄鸡蛋",
  "category": "home",
  "tags": ["快手", "清淡"],
  "difficulty": "easy",
  "estimated_minutes": 15,
  "is_favorite": true,
  "is_blacklisted": false,
  "last_cooked_at": null,
  "created_by": "uid",
  "created_at": "timestamp",
  "updated_at": "timestamp"
}
```

`orders`：

```json
{
  "household_id": "householdId",
  "requester_user_id": "uid1",
  "cook_user_id": null,
  "status": "requested",
  "scheduled_time": null,
  "raw_text": "想吃番茄鸡蛋，少油",
  "note": "少油",
  "ai_summary": null,
  "created_at": "timestamp",
  "updated_at": "timestamp",
  "completed_at": null,
  "client_request_id": "uuid"
}
```

`order_events`：

```json
{
  "household_id": "householdId",
  "order_id": "orderId",
  "actor_user_id": "uid",
  "event_type": "status_changed",
  "payload": {"from": "requested", "to": "accepted"},
  "created_at": "timestamp"
}
```

### 7.2 必建索引

第一版索引：

- `orders`: `(household_id, status, updated_at desc)`
- `orders`: `(household_id, requester_user_id, created_at desc)`
- `dishes`: `(household_id, updated_at desc)`
- `dishes`: `(household_id, is_blacklisted, last_cooked_at asc)`
- `order_events`: `(order_id, created_at asc)`
- `notifications`: `(user_id, read_at, created_at desc)`

不要提前创建徽章、日记、外链导入相关索引。

## 8. 写入边界

客户端直接写 Firestore 的范围应非常窄：

- 允许读：当前用户所属 household 的菜单、订单、事件、通知。
- 允许写：仅用户自己的设备 token、局部 UI preference。
- 禁止直接写：`orders.status`、`order_events`、`households.member_ids`、`invite_code_hash`、`ai_request_logs`。

所有业务写入走 Cloud Functions：

- `createHousehold`
- `joinHousehold`
- `upsertDish`
- `submitOrder`
- `transitionOrderStatus`
- `addOrderNote`
- `rateDish`
- `aiParseOrder`
- `aiRecommendDishes`

这样才能保证：

- 状态机不被绕过。
- 邀请码不被枚举。
- 跨家庭写入不可能发生。
- 离线重放有幂等保护。

## 9. 订单状态机

第一版建议简化为 5 个状态：

```text
requested -> accepted -> cooking -> served
    |           |          |
    v           v          v
cancelled   cancelled   blocked
```

`blocked` 可转：

```text
blocked -> accepted
blocked -> cooking
blocked -> cancelled
```

暂不拆 `prepping`。备菜和下锅在家庭场景里不必第一版区分；UI 可以显示“开始做了”。

服务端函数：

```typescript
transitionOrderStatus(orderId, targetStatus, reason?)
```

校验：

- 调用者必须属于该 household。
- `requested -> accepted` 时写入 `cook_user_id`。
- `blocked` 只能由 cook 触发。
- `served` 只能由 cook 触发。
- `cancelled` 在 `served` 后禁止。
- 每次转移必须 append `order_events`。
- 使用 Firestore transaction 读取当前状态并写入新状态，避免并发覆盖。

## 10. 离线与幂等

第一版不建议支持“离线修改订单状态后自动同步”。理由：状态流转涉及对端体验，离线期间容易造成误解。

建议策略：

- 菜单浏览支持离线缓存。
- 创建订单时如果离线，进入本地草稿，不直接排队写入。
- 状态变更必须在线调用 Cloud Function。
- 每个写命令带 `client_request_id`，服务端去重。

如果后续必须支持离线写入，安全规则和 Cloud Function 都要额外设计冲突解决，不适合作为 MVP 默认能力。

## 11. AI Gateway

### 11.1 服务端模块

```text
functions/src/ai/
  provider.ts
  prompts.ts
  schemas.ts
  sanitize.ts
  call_model.ts
  cache.ts
```

接口：

```typescript
interface AiProvider {
  completeJson<T>(
    purpose: AiPurpose,
    payload: unknown,
    schema: ZodSchema<T>,
    options: AiCallOptions
  ): Promise<T>
}
```

### 11.2 第一版 AI 功能

`aiParseOrder` 输入：

```json
{
  "raw_text": "想吃番茄牛腩，少油，不要香菜，7 点前",
  "timezone": "Asia/Shanghai"
}
```

输出：

```json
{
  "dish_candidates": [{"name": "番茄牛腩", "confidence": 0.92}],
  "taste_notes": ["少油"],
  "excluded_ingredients": ["香菜"],
  "expected_time_local": "19:00",
  "needs_confirmation": ["dish_candidates"]
}
```

`aiRecommendDishes` 输入：

```json
{
  "mood": "今天累了，想吃清淡",
  "minutes_budget": 20,
  "dish_pool": [{"name": "番茄鸡蛋", "tags": ["快手"]}]
}
```

输出：

```json
{
  "candidates": [
    {
      "dish_name": "番茄鸡蛋面",
      "reason": "快、暖、失败率低",
      "estimated_minutes": 15,
      "difficulty": "easy"
    }
  ]
}
```

### 11.3 AI 失败降级

- 超时 8 秒：返回 `ai_timeout`，客户端显示手动输入。
- JSON 校验失败：服务端重试 1 次。
- 重试仍失败：返回空候选。
- 配额失败：禁用 AI 15 分钟，客户端使用常做菜随机推荐。

### 11.4 脱敏

`sanitize` 是强制入口。

测试必须覆盖：

- 不带用户姓名。
- 不带家庭名。
- 不带 uid。
- 不带手机号。
- 不带头像。
- 不带完整历史订单。
- 不带自由文本之外的备注字段。

## 12. Firebase Security Rules

规则目标：

- 用户只能读自己 household 的数据。
- 用户不能改其他 household。
- 用户不能直接改订单状态。
- 用户不能直接写事件流。

规则草案：

```javascript
function isSignedIn() {
  return request.auth != null;
}

function userDoc() {
  return get(/databases/$(database)/documents/users/$(request.auth.uid));
}

function userHouseholdId() {
  return userDoc().data.household_id;
}

function sameHousehold(householdId) {
  return isSignedIn() && userHouseholdId() == householdId;
}

match /dishes/{dishId} {
  allow read: if sameHousehold(resource.data.household_id);
  allow create, update, delete: if false; // use Cloud Functions
}

match /orders/{orderId} {
  allow read: if sameHousehold(resource.data.household_id);
  allow create, update, delete: if false; // use Cloud Functions
}

match /order_events/{eventId} {
  allow read: if sameHousehold(resource.data.household_id);
  allow write: if false;
}
```

实际实现时，Cloud Functions 用 Admin SDK 绕过规则；客户端一律通过 callable function 写业务数据。

## 13. 客户端架构

### 13.1 分层

```text
UI Widget
  -> Controller / Notifier
    -> Repository
      -> Firebase Data Source
      -> Function Data Source
```

### 13.2 Feature 模块

`household`：

- 创建家庭。
- 加入家庭。
- 邀请码。
- 成员展示。

`menu`：

- 菜单列表。
- 新增/编辑菜品。
- 收藏/黑名单。

`orders`：

- 今日点菜。
- 订单草稿。
- 订单详情。
- 历史订单。

`kitchen`：

- 待接单列表。
- 当前订单。
- 缺食材。
- 完成。

`ai_assistant`：

- AI 推荐。
- 自然语言整理。
- AI 失败降级。

`settings`：

- 昵称。
- 偏好。
- 通知。
- 数据与隐私入口。

### 13.3 UI 设计边界

第一版页面控制在 5 个底部导航或 4 个主入口：

- 今晚吃啥。
- 厨房。
- 菜单。
- 设置。

AI 不单独做复杂聊天页。AI 作为“今晚吃啥”的辅助动作出现，避免产品变成 AI 聊天壳。

## 14. 通知

第一版通知类型：

- `new_order`
- `order_accepted`
- `missing_ingredient`
- `served`

通知正文用固定模板，不直接拼用户备注：

- `小雨想吃：番茄牛腩`
- `阿哲接单了`
- `主厨说缺点食材`
- `可以开饭了`

服务端写 `notifications` 后再发 FCM。客户端启动时拉未读通知补齐。

## 15. Storage

第一版如果不做照片，可不启用 Storage。

如果要支持菜品图片：

```text
households/{householdId}/dishes/{dishId}/cover.jpg
```

规则：

- 只允许同 household 成员读。
- 上传必须走 Cloud Function 或 Storage Rules 校验路径里的 householdId。
- 限制图片大小，例如 5 MB。

分享图、成品照、日记照片全部延后。

## 16. 外链导入

不建议进入 V0.1。

原因：

- 小红书/抖音/B 站链接抓取不稳定。
- 容易引出版权和平台协议问题。
- 工程价值不如先验证家庭点菜闭环。

V0.2/V0.3 可先做“手动粘贴标题和文本”，不要做后台抓取。真正链接 adapter 单独做 spike。

## 17. 观测

第一版只采集不含自由文本的事件：

- `household.created`
- `household.joined`
- `dish.created`
- `order.submitted`
- `order.accepted`
- `order.blocked`
- `order.served`
- `ai.parse_order.started`
- `ai.parse_order.succeeded`
- `ai.parse_order.failed`
- `ai.recommend.succeeded`
- `notification.sent`

禁止属性：

- 菜名。
- 用户原话。
- 备注。
- 偏好文本。
- AI 输出文本。
- household name。
- user display name。

允许属性：

- 耗时。
- 状态。
- 错误码。
- 数量。
- 是否降级。

## 18. 测试策略

### 18.1 Functions

必须测试：

- 邀请码过期。
- 非家庭成员不能加入/读写。
- 状态机每条合法边。
- 每条非法边。
- `client_request_id` 幂等。
- `sanitize` golden case。
- AI schema 校验失败降级。

### 18.2 Flutter

必须测试：

- 订单卡片状态渲染。
- 菜单 CRUD。
- AI 结果确认页。
- 厨房接单流程。
- 空状态文案。

### 18.3 E2E

Firebase emulator 跑：

```text
createHousehold
joinHousehold
upsertDish
submitOrder
transition requested -> accepted
transition accepted -> cooking
transition cooking -> served
read order_events
```

## 19. CI 与环境

### 19.1 本地命令

```bash
scripts/doctor.sh
cd app && flutter analyze
cd app && flutter test
cd functions && npm test
firebase emulators:exec "npm test"
```

### 19.2 环境文件

不提交真实密钥。

```text
app/.env.example
functions/.env.example
firebase/.firebaserc.example
```

### 19.3 必要密钥

- Firebase project id。
- AI provider base URL。
- AI API key。
- FCM server config。

密钥只放 Firebase Secret Manager 或本机未跟踪文件。

## 20. 里程碑计划

### Week 1

- Flutter 项目骨架。
- Firebase emulator。
- Firestore rules 初版。
- 本地假数据页面。

### Week 2

- Auth。
- Household 创建/加入。
- Menu CRUD。
- Functions 测试框架。

### Week 3

- Submit order。
- Kitchen stream。
- Status transition function。
- Order events。

### Week 4

- Notifications。
- 真实两设备 smoke test。
- Crashlytics/Analytics 白名单。

### Week 5

- AI parse/recommend。
- sanitize。
- schema validation。
- AI fallback。

### Week 6

- UI polish。
- Alpha 测试。
- 成本和读写量报告。
- V0.1/V0.2 发布候选。

## 21. 技术风险与处理

### 21.1 Firestore 直接写绕过状态机

处理：业务集合禁止客户端写。所有业务写入走 Cloud Functions。

### 21.2 离线状态冲突

处理：MVP 不支持离线状态转移。只支持离线读和本地草稿。

### 21.3 AI 输出不稳定

处理：schema 校验、重试一次、失败降级。

### 21.4 隐私红线被后续功能突破

处理：sanitize golden tests + analytics whitelist tests + code review checklist。

### 21.5 国内手机号登录摩擦

处理：Alpha 用 Anonymous Auth；正式版再接手机号/微信/Apple。

### 21.6 外链导入不稳定

处理：先不进入 MVP；后续做 platform adapter spike。

## 22. 下一步

1. 把产品方案里的 V0.1 范围收紧，和本文的 MVP 切片对齐（已在第九轮完成）。
2. 阅读 `foodhome-code-style.md`，把 §2 四条硬红线与 §14 CI 阻塞项接入 `.github/workflows/`。
3. 创建 `foodhome/` 工程目录，按代码风格 §3 结构初始化。
4. 先做 Flutter 假数据原型。
5. 再接 Firebase emulator。
6. 最后接 AI。
