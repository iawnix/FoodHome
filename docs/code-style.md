# FoodHome 代码风格与工程规范

配套文件：
- 产品方案：`family-menu-app-plan.md`
- 技术方案：`foodhome-technical-plan.md`

本文只回答一件事：**代码怎么写不会烂掉**。

新人入职看这一份 30 分钟内就能上手；老人 PR review 时对着这一份勾选；出现规范冲突时以这份为准。

---

## 1. 屎山从哪来

从工程经验倒推，一个 Flutter + Cloud Functions 项目失控几乎都是这六条之一：

1. **按类型分文件夹**：`controllers/` / `models/` / `services/` 各自成堆。改一个功能要跳 5 个文件夹。
2. **跨层直连**：Widget 里 `FirebaseFirestore.instance.collection(...)`。改数据库 = 改所有 UI。
3. **抽象时机错位**：一次抽出的 `BaseController`；一个万物皆入的 `utils.dart`。
4. **magic string 遍地**：`"orders"` / `"cooking"` / `"never_again"` 硬编码。改状态 = 全项目搜。
5. **异常吞噬**：`catch (_) {}` 让 bug 沉默半年，最后无法诊断。
6. **无契约共享**：Functions 端 Zod、App 端 freezed 各写各的，schema 一改就漂。

本规范的每一条都是针对上述某一条的结构性防御，不是"最佳实践大全"。

---

## 2. 四条硬红线（违反 = block PR）

不留讨论空间。CI 或 reviewer 直接拒绝合入。

### 2.1 分层单向

依赖只能从上往下：

```
Widget → Notifier(Controller) → Repository → DataSource
```

反向 import 是 CI 报错。用自定义 lint 或 `dart_dependency_checker` 类工具做静态断言。

### 2.2 feature 隔离

`features/A` 不允许 import `features/B`。跨 feature 复用走 `core/` 或 `shared/`。CI 阻断跨 feature import。

### 2.3 契约优先

Firestore 集合 shape、Callable 输入输出、AI 输入输出——**先定 Zod schema，再写实现**。App 端 freezed 类型从 Zod 生成（或加漂移检查 CI）。PR 不带 schema 更新的功能不合入。

### 2.4 零 magic string

状态名、集合名、事件类型、错误 code、路由路径——一律 enum / const。检出即拒。lint 规则：`.dart` / `.ts` 里出现字面量字符串且被用作分支判定，报错。

---

## 3. 项目结构

### 3.1 monorepo 顶层

```
foodhome/
  app/                        # Flutter
  functions/                  # Cloud Functions (TypeScript)
  firebase/                   # rules, indexes, .firebaserc
  docs/                       # 产品/技术/风格文档
    product-plan.md
    technical-plan.md
    code-style.md
    glossary.md               # domain vocabulary
    api-contract.md
    data-model.md
  scripts/                    # doctor.sh 等
```

### 3.2 Flutter 端（feature-based）

```
app/lib/
  main.dart
  app.dart
  core/                          # 全局，跨 feature 复用
    routing/                     # go_router 路径常量集中
    theme/                       # 色板 / 字号 / 间距 tokens
    firebase/                    # Firebase 初始化 + provider
    result/                      # Result<T, AppError>
    error/                       # AppError, code 映射
    logging/                     # logger + Crashlytics 桥
    schemas/                     # 与 functions 共享类型（生成物）
    localization/                # intl
  features/
    orders/
      data/                      # 唯一碰 Firestore/Functions 的层
        orders_repository.dart
        orders_firestore_source.dart
        orders_functions_source.dart
      domain/                    # 纯数据 + 规则，不 import Flutter
        order.dart               # freezed
        order_status.dart        # enum
        order_state_machine.dart
      presentation/
        pages/
        widgets/
        controllers/             # Riverpod Notifier
    menu/                        # 同上三层
    kitchen/
    household/
    ai_assistant/
    settings/
  shared/                        # feature 之间可复用的 widget
    widgets/
      empty_state.dart
      status_chip.dart
      loading_indicator.dart
```

**为什么不是 clean architecture 的四层**：`data/domain/presentation` 三层对 Flutter 应用足够；再多层会让"改一个字段跳五个文件"。三层是"最小可分层"。

### 3.3 Cloud Functions 端

```
functions/src/
  index.ts                       # 只 re-export Callable
  config/
    env.ts                       # 环境常量
    limits.ts                    # rate limits, timeout
  domain/                        # 纯函数区，不 IO 不 log 不 firebase-admin
    order_state_machine.ts
    invite_codes.ts
    household_membership.ts
    result.ts                    # 与 App 对齐的 Result 类型
  handlers/                      # 每个 Callable 一文件
    household.ts
    dishes.ts
    orders.ts
    ai.ts
    notifications.ts
  ai/
    provider.ts                  # AiProvider interface
    prompts.ts                   # 版本化 Prompt
    sanitize.ts                  # §10.8 脱敏
    schemas.ts                   # Zod: AI 输入输出
    call_model.ts
    cache.ts
  firestore/
    refs.ts                      # 集合名常量 + typed refs
    converters.ts                # ↔ Zod
  observability/
    logger.ts
    metrics.ts
  __tests__/
    domain/                      # 纯函数测试
    handlers/                    # 集成测试（emulator）
    ai/
      sanitize.golden.test.ts    # §10.8.6
      schema.test.ts
```

**domain/ 是纯函数区**：不 import `firebase-admin`、不 IO、不查库、不 log、不抛 `HttpsError`。domain 决定"能不能"、"是什么"，handler 决定"怎么做"。CI 静态检查阻断 domain 目录里出现 firebase-admin。

---

## 4. 分层规范

每个 feature 三层的**读写允许矩阵**：

| 层 | 允许 | 禁止 |
| --- | --- | --- |
| `data/` | Firestore SDK、Callable Function、Result 返回、freezed 转换 | UI 依赖、Widget import |
| `domain/` | pure Dart、freezed、enum、纯函数规则 | Firebase 相关 import、Flutter import、IO |
| `presentation/` | Widget、Notifier、Result 分支渲染 | 直接访问 Firestore、直接 http、直接 print |

**分层不越界的物理保证**：

- `domain/` 目录下的文件不允许 import `package:cloud_firestore/*`、`package:firebase_*`、`package:flutter/*`。CI 检查。
- `presentation/` 只能 import 本 feature 的 `data/` 和 `domain/`、`core/`、`shared/`；不能跨 feature 导入。
- `data/` 只能被本 feature 的 `presentation/` 使用（通过 Repository provider）。

---

## 5. Flutter / Dart 规范

### 5.1 lints

`analysis_options.yaml`：

```yaml
include: package:very_good_analysis/analysis_options.yaml
analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
  errors:
    unawaited_futures: error
    always_declare_return_types: error
    prefer_const_constructors: error
    avoid_dynamic_calls: error
    depend_on_referenced_packages: error
linter:
  rules:
    - prefer_final_locals
    - prefer_final_in_for_each
    - avoid_positional_boolean_parameters
    - use_super_parameters
    - require_trailing_commas
```

再加自定义 lint（`custom_lint`）：

- `foodhome/feature_isolation`：`features/A` import `features/B` → error
- `foodhome/layer_boundary`：`domain/` import Flutter/Firebase → error
- `foodhome/no_magic_status`：分支里出现字符串字面量与状态比较 → error

### 5.2 命名

| 项 | 规范 | 例 |
| --- | --- | --- |
| 文件 | snake_case | `orders_repository.dart` |
| 类 / freezed | PascalCase | `Order`, `OrderStatus` |
| 变量 / 函数 | camelCase | `submitOrder`, `activeOrder` |
| 私有 | `_` 前缀 | `_MyWidget`, `_buildCard` |
| 常量 | camelCase (Dart 惯例) | `defaultServings` |
| Riverpod Provider | `<name>Provider` 结尾 | `ordersRepositoryProvider` |
| Notifier 类 | `<Name>Controller` | `ActiveOrderController` |

### 5.3 数据类：freezed 唯一路径

- 所有 domain model 用 freezed
- 禁止手写 `==` / `hashCode` / `toString` / `copyWith`
- JSON 序列化用 `json_serializable`
- 集合类型用 `List` / `Map`（非 `Iterable`），需要 immutable 时用 `IList` (fast_immutable_collections)

### 5.4 状态管理（Riverpod）

- 所有跨 Widget 状态走 Riverpod
- `StatefulWidget` 只允许放 UI-only 状态：`AnimationController`、`TextEditingController`、`FocusNode`、`ScrollController`
- Notifier 命名：`<Name>Controller extends AutoDisposeNotifier<T>`；有 side effect 的方法 return `Future<Result<T, AppError>>`
- Provider 分类：
  - `<name>RepositoryProvider`（Repository 实例）
  - `<name>StreamProvider`（Firestore stream）
  - `<name>ControllerProvider`（业务动作）
- 禁止 `.family` 除非 key 是稳定 id；否则会导致 leak

### 5.5 Widget 规范

- **StatelessWidget 优先**，能 const 就 const
- 单文件 ≤ 300 行；超过拆子 widget
- Widget 参数 ≤ 5 个；超过用 freezed 打包为 config
- 不在 `build()` 里 new Riverpod controller，用 `ref.watch` / `ref.read`
- 不在 `build()` 里 setState（永远）
- 不做业务判定：`if (order.status == 'cooking')` → 拆到 domain 层的 helper 里

### 5.6 路由（go_router）

- 所有路径集中在 `core/routing/app_routes.dart`：

```dart
abstract class AppRoutes {
  static const home = '/';
  static const orderDetail = '/orders/:id';

  static String orderDetailWith(String id) => '/orders/$id';
}
```

- 禁止手写字符串路径散布在 widget 里
- 参数类型化：deep link 参数在 `go_router` 层解析成 domain 类型再传下去

### 5.7 主题

- 色板走 §20 品牌：`core/theme/tokens.dart`
- 直接写 `Color(0xFFD9532A)` → lint 报错，必须走 `AppColors.brandPrimary`
- 字号只用 `AppTypography.body`、`AppTypography.title` 这类语义 token；禁止手写 `TextStyle(fontSize: 14)`

---

## 6. TypeScript / Cloud Functions 规范

### 6.1 tsconfig

```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "exactOptionalPropertyTypes": true,
    "isolatedModules": true,
    "moduleResolution": "node16",
    "target": "es2022"
  }
}
```

### 6.2 ESLint

`@typescript-eslint/recommended` + 自加：

- `no-explicit-any`: error
- `no-floating-promises`: error
- `explicit-function-return-type`: error（handler 层强制）
- `no-non-null-assertion`: error
- `switch-exhaustiveness-check`: error

### 6.3 命名

| 项 | 规范 |
| --- | --- |
| 文件 | snake_case（一致 Firebase 生态）或 camelCase 选一，本项目 snake_case |
| 函数 | camelCase |
| 类型 / 接口 | PascalCase，不加 `I` 前缀 |
| Zod schema | `<Name>Schema`，如 `OrderSchema` |
| 常量 | UPPER_SNAKE_CASE，如 `MAX_HOUSEHOLD_SIZE` |

### 6.4 Callable Function 规范

每个 Callable 单文件，模板：

```typescript
// handlers/orders.ts
import {onCall, HttpsError} from 'firebase-functions/v2/https'
import {SubmitOrderInput, SubmitOrderOutput} from '../ai/schemas'
import {orderStateMachine} from '../domain/order_state_machine'
import {ordersRef} from '../firestore/refs'
import {logger} from '../observability/logger'
import {toAppError} from '../domain/result'

export const submitOrder = onCall(async (request) => {
  // 1. parse
  const parsed = SubmitOrderInput.safeParse(request.data)
  if (!parsed.success) throw new HttpsError('invalid-argument', 'validation')

  // 2. authz
  const uid = request.auth?.uid
  if (!uid) throw new HttpsError('unauthenticated', 'unauthenticated')

  // 3. domain
  const result = orderStateMachine.attemptSubmit(parsed.data, {actor: uid})
  if (result.kind === 'err') throw toAppError(result.error)

  // 4. persist
  const docRef = await ordersRef.add(result.value.toFirestore())

  // 5. observe
  logger.info('order.submitted', {orderId: docRef.id})

  // 6. return
  return SubmitOrderOutput.parse({ok: true, data: {orderId: docRef.id}})
})
```

规则：

- handler 只做 **parse → authz → domain → persist → observe → return** 六步
- 业务规则在 domain 层，handler 里不写 `if`
- 输入输出都过 Zod，返回值用 Output schema `parse()` 保证 shape
- error 通过 `toAppError` 统一映射，不散布 `throw new HttpsError` 字符串

### 6.5 domain 层

- 纯函数，返回 `Result<T, DomainError>`
- 不 import `firebase-admin`、不 log、不抛
- 用 discriminated union 表达状态：

```typescript
type TransitionResult =
  | {kind: 'ok'; nextState: OrderStatus; events: OrderEvent[]}
  | {kind: 'err'; error: 'illegal_transition' | 'not_permitted'}
```

### 6.6 Zod schema

- 所有 shape 集中在 `ai/schemas.ts` 与 `firestore/refs.ts`
- 每个 schema 有对应 `type X = z.infer<typeof XSchema>`
- App 端类型漂移检测：CI 跑一次 `schemas.ts` → JSON schema → 比对 `app/lib/core/schemas/` 里的镜像，diff 非空则 fail

---

## 7. 命名词典（domain vocabulary）

统一后写入 `docs/glossary.md`。PR review 对着看，同义词一律 reject。

| 用 | 不用 | 说明 |
| --- | --- | --- |
| Order | Ticket / Request / Meal | 一次点菜请求 |
| Dish | MenuItem / Recipe | 家庭菜单里的一道菜 |
| Recipe | Instructions / Steps | 仅指 AI 生成的做菜步骤（属于 Dish 的可选字段） |
| Cook | Chef / Kitchen / Preparer | 做饭的成员（角色，不是 job） |
| Requester | Orderer / Diner / Client | 点菜的成员 |
| Household | Family / Group / Space | 家庭空间 |
| Preference | Setting / Config | 用户口味偏好 |
| Journal | Diary / Log / Note | 一次做饭的记录（照片 + 感受） |
| Reaction | Tapback / Sticker | 一键贴纸反馈 |
| Session | Trip / Run | 做饭模式的一次会话 |

上下游对齐：Firestore 集合名、Zod schema 名、freezed 类名、UI 文案词全部走这一套。

---

## 8. 错误处理

### 8.1 Result 类型（Dart）

```dart
sealed class Result<T, E> { const Result(); }
final class Ok<T, E> extends Result<T, E> {
  final T value; const Ok(this.value);
}
final class Err<T, E> extends Result<T, E> {
  final E error; const Err(this.error);
}

extension ResultExt<T, E> on Result<T, E> {
  R fold<R>({required R Function(T) ok, required R Function(E) err}) =>
    switch (this) { Ok<T, E>(:final value) => ok(value), Err<T, E>(:final error) => err(error) };
}
```

### 8.2 AppError

```dart
enum AppErrorCode {
  network, unauthorized, illegalTransition, notMember,
  notFound, validation,
  aiTimeout, aiSchemaMismatch, aiQuota, aiRefused,
  cameraDenied, storageFull,
  unknown,
}

@freezed
class AppError with _$AppError {
  const factory AppError({
    required AppErrorCode code,
    String? debugMessage,
    Map<String, dynamic>? context,
  }) = _AppError;
}
```

### 8.3 规则

- Repository / DataSource **只返回 `Result<T, AppError>`**，禁止抛
- Notifier 里显式 `switch` 处理 Result 两侧，sealed 保证穷尽
- UI 层 exhaustive 处理每个 AppErrorCode，未处理 CI 报错
- 服务端 `HttpsError.code` 与 `AppErrorCode` 一一映射，通过 `{ok, error:{code,message}}` 包裹返回
- `catch (_) {}` 空吞噬 → lint 阻断
- Fatal 错误（超预期状态）走 Crashlytics，非 fatal 走 logger

### 8.4 UI 里怎么写

```dart
result.fold(
  ok: (order) => _showOrderCard(order),
  err: (e) => switch (e.code) {
    AppErrorCode.network => _showRetry(),
    AppErrorCode.illegalTransition => _showAlreadyChanged(),
    AppErrorCode.aiTimeout => _showAiFallback(),
    // sealed enum 穷尽，漏一个 lint 报错
    _ => _showGenericError(),
  },
);
```

---

## 9. 契约管理

### 9.1 单一真相源

Zod schema 是 shape 的真相。所有类型从 Zod 派生：

- TS 端：`type Order = z.infer<typeof OrderSchema>`
- Dart 端：`Order` freezed 类，从 Zod schema 转 JSON schema 后生成（或手工镜像 + CI 漂移检测）

### 9.2 versioning

- schema 变更走 semver：新增字段（optional）= minor；删除或改类型 = major
- 每次 major 变更需要 migration script
- 客户端接收 Firestore 数据时 `SchemaVersion.mismatch` → 引导用户升级 App
- Callable 请求的 schema 版本随 App 版本；服务端 handle 至少最近 3 个 minor 版本

### 9.3 生成流程

```bash
# functions/scripts/gen-app-types.sh
npx zod-to-json-schema src/ai/schemas.ts \
  --out ../app/lib/core/schemas/generated/ \
  --format dart-freezed
```

CI 阻塞：如果 `functions/src/ai/schemas.ts` 修改了但 `app/lib/core/schemas/generated/` 没同步，fail。

---

## 10. 依赖注入（Riverpod 模式）

### 10.1 provider 分类

| 类型 | 用途 | 示例 |
| --- | --- | --- |
| `Provider` | 无状态依赖（Repository、Service） | `ordersRepositoryProvider` |
| `FutureProvider` | 一次性异步查询 | `dishRecipeProvider(dishId)` |
| `StreamProvider` | Firestore stream | `activeOrdersStreamProvider` |
| `NotifierProvider` | 有状态的业务逻辑 | `activeOrderControllerProvider` |
| `AsyncNotifierProvider` | 有状态 + 异步初始化 | `householdControllerProvider` |

### 10.2 依赖树

自顶向下：

```
UI Widget
  → ref.watch(activeOrderControllerProvider)
    → ref.read(ordersRepositoryProvider)
      → ref.read(ordersFunctionsSourceProvider)
      → ref.read(ordersFirestoreSourceProvider)
```

### 10.3 测试时 override

```dart
testWidgets('order card renders', (tester) async {
  await tester.pumpWidget(ProviderScope(
    overrides: [
      ordersRepositoryProvider.overrideWithValue(FakeOrdersRepo()),
    ],
    child: MyApp(),
  ));
});
```

### 10.4 反例

- 不在 Widget 里 new Repository / new Firebase 实例
- 不在 domain 里 access Riverpod
- 不用 `Provider.autoDispose` 之外的默认，除非明确需要长驻

---

## 11. 测试策略

**不追求覆盖率数字，追求关键路径**。

### 11.1 分层

| 层 | 测什么 | 用什么 |
| --- | --- | --- |
| domain（Dart / TS 都有） | 状态机、纯规则、Result 分支 | 单元测试，无 mock |
| Repository / DataSource | 边界翻译、错误映射 | 单元 + fake DataSource |
| Notifier / Controller | 状态转移、side effect 顺序 | 单元 + Riverpod override |
| Widget | 渲染 + tap 反应 | widget test + golden |
| E2E | 用户旅程 | integration test + Firebase emulator |
| Cloud Functions | Callable 契约、状态机 | emulator + jest |

### 11.2 必测清单

- 订单状态机每条合法边 + 每条非法边（§8.14）
- Sanitize 15 条 golden（§10.8.6）
- 邀请码过期与非成员访问
- Callable 输入输出 Zod 校验
- Result Ok/Err 两侧
- 主要卡片（订单卡、状态徽章、菜单条目）golden

### 11.3 不测

- 纯展示、无逻辑的 widget（`Text('设置')`）
- 常量、配色 token
- 布局微调
- get/set

### 11.4 覆盖率

CI 报告覆盖率但不做门槛。**有意义的路径漏测比数字漂亮更值得阻断合入**。

---

## 12. 抽象节奏

### 12.1 三次法则

不要在第一次出现时抽。第二次出现时观察是否真的形似。**第三次出现时抽**。

### 12.2 反模式

- **BaseController / BaseRepository / BaseX**：99% 的情况都是提前抽。用 mixin 或组合。
- **utils.dart / helpers.dart**：一旦出现，一年后必成万物之源。要么放对应 feature，要么放 core 里明确命名的模块。
- **AbstractFactory / Manager / Handler 加后缀**：命名说明"我不知道它是什么"。回去想清楚职责再命名。

### 12.3 违反 YAGNI 的允许

只有一个例外：**契约相关的东西可以提前抽**。因为契约变了下游全变，成本对称。所以 Zod schema、AppError enum、路由常量、状态枚举——第一次出现就应该定义在集中位置。

---

## 13. 重构信号（硬门槛）

不主观、不看心情。以下任一命中，必须重构后再提交。

| 信号 | 阈值 | 动作 |
| --- | --- | --- |
| 方法长度 | > 50 行 | 拆或提取 |
| 文件长度 | > 300 行 | 拆 |
| 函数参数 | > 4 个 | 打包 freezed / record |
| if-else 嵌套 | ≥ 3 层 | 早返回 / 状态机 |
| 一个类 public 方法 | > 8 个 | 拆两个类 |
| 相同代码块 | ≥ 3 处 | 抽公用 |
| 一个 provider 依赖 | > 5 个 | 引入门面（facade） |
| 一次 PR 改动文件 | > 20 个 | 拆两个 PR |

lint 或 pre-commit hook 阻断。

---

## 14. Git 与 CI

### 14.1 提交消息（Conventional Commits）

```
<type>(<scope>): <subject>

<body>

<footer>
```

`type`：`feat` / `fix` / `refactor` / `test` / `docs` / `chore` / `perf` / `style`
`scope`：`orders` / `menu` / `kitchen` / `ai` / `household` / `core`

例：

```
feat(orders): submit order via callable with client_request_id

- add SubmitOrderInput Zod schema
- generate freezed mirror
- wire submitOrder callable + repository + controller
- add golden for 幂等性 case
```

### 14.2 PR 规则

- 一个 PR 一件事
- PR description 三段：**意图 / 影响面 / 测试步骤**
- 涉及 schema 变更必须带 migration note
- 涉及 sanitize 白名单变更必须带隐私 owner review

### 14.3 CI 阻塞项

- lint（Dart + TS）
- 分层与 feature 隔离检查
- Zod ↔ freezed schema 漂移
- domain 层无 Firebase/Flutter import
- 单测 + widget 测试 + golden
- Callable emulator 集成测试
- Sanitize 15 条 golden
- 覆盖率 report（不阻塞）
- Conventional Commits 校验

---

## 15. 代码审查清单（PR template）

Reviewer 对着勾。缺任一项要求补，不合入。

- [ ] 命名符合 `docs/glossary.md`
- [ ] 无跨层 import（domain 不见 Firebase/Flutter；presentation 不见 Firestore SDK）
- [ ] 无跨 feature import
- [ ] 无 magic string（用 enum/const）
- [ ] Result 分支穷尽（sealed switch）
- [ ] 无 `catch (_) {}` 或空 catch
- [ ] 无手写 `==` / `hashCode`（用 freezed）
- [ ] 关键路径有测试（列出对应 test 文件）
- [ ] 涉及数据形态变更：schema 已更新，freezed 已同步
- [ ] 涉及新字段：过 sanitize 白名单审计（AI 请求相关）
- [ ] 无新增 magic 字符串路由
- [ ] Widget 单文件 ≤ 300 行
- [ ] 方法 ≤ 50 行
- [ ] Conventional Commits 消息
- [ ] PR 描述含意图 / 影响面 / 测试步骤

---

## 16. 什么时候可以违反规则

规范是防错的，不是崇拜的。以下情况明确允许绕：

- **一次性脚本、迁移**：不必分层，写在 `scripts/`
- **spike 分支**：验证可行性时允许直连、允许 magic string，但不允许合入 main
- **热修 P0**：修完再补规范，2 周内偿还技术债
- **无法预知的第三方**：如果被迫接一个不遵守契约的 API，在 adapter 层集中吸收混乱

规则不是为了折磨自己，是为了让**大部分时间**代码写得快、看得懂、改得动。

---

## 17. Onboarding：新人第一天

1. 读 `family-menu-app-plan.md` §1-3（30 分钟，产品理解）
2. 读 `foodhome-technical-plan.md` §1-5（20 分钟，架构理解）
3. 读本文 §2-4（15 分钟，规范红线）
4. `scripts/doctor.sh` 起本地环境
5. 跑一次 emulator 的 e2e 测试
6. 挑一个 `good-first-issue` label 的 PR，改改看
7. 第一次 PR reviewer 用 §15 清单对着勾一遍

---

## 18. 文档维护

本文与代码同库、同 PR 更新。以下情况必改本文：

- 新增红线或 lint 规则
- 命名词典有新增/废弃词
- CI 阻塞项调整
- 审查清单变化

**本文的每一条都应该指向一次真实的教训或结构性预防**。如果一条规则没人能说出它防的是什么，删掉它。
