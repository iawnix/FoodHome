import {randomInt, randomUUID} from "node:crypto";
import {z} from "zod";
import {
  CallableResult,
  CreateHouseholdInputSchema,
  CreateHouseholdOutput,
  fail,
  JoinHouseholdInputSchema,
  JoinHouseholdOutput,
  ok,
  SubmitOrderInputSchema,
  SubmitOrderOutput,
  TransitionOrderStatusInputSchema,
  TransitionOrderStatusOutput,
  UpsertDishInputSchema,
  UpsertDishOutput,
} from "../contracts/v0_1.js";
import {canTransitionOrder, OrderStatus} from "./order_state_machine.js";

const maxHouseholdMembers = 4;

export type OrderEventType = "order_submitted" | "status_changed";

export interface UserRecord {
  id: string;
  displayName: string;
  householdId: string | null;
  createdAt: string;
  updatedAt: string;
}

export interface HouseholdRecord {
  id: string;
  name: string;
  memberIds: string[];
  createdAt: string;
  updatedAt: string;
}

export interface DishRecord {
  id: string;
  householdId: string;
  name: string;
  category: string;
  estimatedMinutes: number;
  tags: string[];
  createdAt: string;
  updatedAt: string;
}

export interface OrderRecord {
  id: string;
  householdId: string;
  requesterId: string;
  dishId: string | null;
  dishName: string;
  status: OrderStatus;
  rawText: string | null;
  note: string | null;
  scheduledTime: string | null;
  scheduledLabel: string | null;
  clientRequestId: string;
  createdAt: string;
  updatedAt: string;
  completedAt: string | null;
}

export interface OrderEventRecord {
  id: string;
  householdId: string;
  orderId: string;
  actorId: string;
  type: OrderEventType;
  status: OrderStatus | null;
  reason: string | null;
  createdAt: string;
}

export interface FoodHomeStore {
  getUser(uid: string): Promise<UserRecord | null>;
  saveUser(user: UserRecord): Promise<void>;
  createHousehold(
    household: HouseholdRecord,
    inviteCode: string,
  ): Promise<void>;
  findHouseholdByInviteCode(
    inviteCode: string,
  ): Promise<HouseholdRecord | null>;
  getHousehold(householdId: string): Promise<HouseholdRecord | null>;
  saveHousehold(household: HouseholdRecord): Promise<void>;
  getDish(householdId: string, dishId: string): Promise<DishRecord | null>;
  saveDish(dish: DishRecord): Promise<void>;
  findOrderByClientRequest(
    householdId: string,
    clientRequestId: string,
  ): Promise<OrderRecord | null>;
  getOrder(orderId: string): Promise<OrderRecord | null>;
  saveOrder(order: OrderRecord): Promise<void>;
  appendOrderEvent(event: OrderEventRecord): Promise<void>;
}

export interface FoodHomeIdGenerator {
  household(): string;
  dish(): string;
  order(): string;
  event(): string;
}

export interface FoodHomeServiceOptions {
  store: FoodHomeStore;
  ids?: FoodHomeIdGenerator;
  inviteCode?: () => string;
  now?: () => Date;
}

interface HouseholdScope {
  user: UserRecord;
  household: HouseholdRecord;
}

const defaultIds: FoodHomeIdGenerator = {
  household: () => randomUUID(),
  dish: () => randomUUID(),
  order: () => randomUUID(),
  event: () => randomUUID(),
};

export class FoodHomeService {
  private readonly store: FoodHomeStore;
  private readonly ids: FoodHomeIdGenerator;
  private readonly inviteCode: () => string;
  private readonly now: () => Date;

  constructor(options: FoodHomeServiceOptions) {
    this.store = options.store;
    this.ids = options.ids ?? defaultIds;
    this.inviteCode =
      options.inviteCode ?? (() => randomInt(100000, 1000000).toString());
    this.now = options.now ?? (() => new Date());
  }

  async createHousehold(
    uid: string | null,
    data: unknown,
  ): Promise<CallableResult<CreateHouseholdOutput>> {
    if (uid === null) {
      return fail("unauthenticated", "Sign in before creating a household.");
    }

    const parsed = CreateHouseholdInputSchema.safeParse(data);
    if (!parsed.success) {
      return validationFailed(parsed.error);
    }

    const existingUser = await this.store.getUser(uid);
    if (existingUser !== null && existingUser.householdId !== null) {
      return fail(
        "already_in_household",
        "Leave the current household before creating a new one.",
      );
    }

    const now = this.timestamp();
    const householdId = this.ids.household();
    const inviteCode = this.inviteCode();
    const household: HouseholdRecord = {
      id: householdId,
      name: parsed.data.name,
      memberIds: [uid],
      createdAt: now,
      updatedAt: now,
    };
    const user: UserRecord = {
      id: uid,
      displayName:
        parsed.data.display_name ?? existingUser?.displayName ?? "家庭成员",
      householdId,
      createdAt: existingUser?.createdAt ?? now,
      updatedAt: now,
    };

    await this.store.createHousehold(household, inviteCode);
    await this.store.saveUser(user);

    return ok({household_id: householdId, invite_code: inviteCode});
  }

  async joinHousehold(
    uid: string | null,
    data: unknown,
  ): Promise<CallableResult<JoinHouseholdOutput>> {
    if (uid === null) {
      return fail("unauthenticated", "Sign in before joining a household.");
    }

    const parsed = JoinHouseholdInputSchema.safeParse(data);
    if (!parsed.success) {
      return validationFailed(parsed.error);
    }

    const household = await this.store.findHouseholdByInviteCode(
      parsed.data.invite_code,
    );
    if (household === null) {
      return fail("invite_not_found", "Invite code is invalid or expired.");
    }

    const existingUser = await this.store.getUser(uid);
    if (
      existingUser !== null &&
      existingUser.householdId !== null &&
      existingUser.householdId !== household.id
    ) {
      return fail(
        "already_in_household",
        "Leave the current household before joining another one.",
      );
    }

    if (
      !household.memberIds.includes(uid) &&
      household.memberIds.length >= maxHouseholdMembers
    ) {
      return fail("household_full", "This household is already full.");
    }

    const now = this.timestamp();
    const memberIds = household.memberIds.includes(uid)
      ? household.memberIds
      : [...household.memberIds, uid];
    await this.store.saveHousehold({
      ...household,
      memberIds,
      updatedAt: now,
    });
    await this.store.saveUser({
      id: uid,
      displayName:
        parsed.data.display_name ?? existingUser?.displayName ?? "家庭成员",
      householdId: household.id,
      createdAt: existingUser?.createdAt ?? now,
      updatedAt: now,
    });

    return ok({household_id: household.id});
  }

  async upsertDish(
    uid: string | null,
    data: unknown,
  ): Promise<CallableResult<UpsertDishOutput>> {
    const scope = await this.requireHousehold(uid);
    if (!scope.ok) {
      return scope;
    }

    const parsed = UpsertDishInputSchema.safeParse(data);
    if (!parsed.success) {
      return validationFailed(parsed.error);
    }

    const now = this.timestamp();
    const dishId = parsed.data.dish_id ?? this.ids.dish();
    const existing = await this.store.getDish(scope.data.household.id, dishId);
    const dish: DishRecord = {
      id: dishId,
      householdId: scope.data.household.id,
      name: parsed.data.name,
      category: parsed.data.category,
      estimatedMinutes: parsed.data.estimated_minutes,
      tags: parsed.data.tags,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    };

    await this.store.saveDish(dish);

    return ok({dish_id: dishId});
  }

  async submitOrder(
    uid: string | null,
    data: unknown,
  ): Promise<CallableResult<SubmitOrderOutput>> {
    const scope = await this.requireHousehold(uid);
    if (!scope.ok) {
      return scope;
    }

    const parsed = SubmitOrderInputSchema.safeParse(data);
    if (!parsed.success) {
      return validationFailed(parsed.error);
    }

    const existingOrder = await this.store.findOrderByClientRequest(
      scope.data.household.id,
      parsed.data.client_request_id,
    );
    if (existingOrder !== null) {
      return ok({order_id: existingOrder.id});
    }

    const dish =
      parsed.data.dish_id === undefined
        ? null
        : await this.store.getDish(
            scope.data.household.id,
            parsed.data.dish_id,
          );
    if (parsed.data.dish_id !== undefined && dish === null) {
      return fail("not_found", "Dish does not exist in this household.");
    }

    const rawText = parsed.data.raw_text ?? "";
    const noteParts = [...parsed.data.taste_notes, rawText].filter(
      (part) => part.length > 0,
    );
    const now = this.timestamp();
    const orderId = this.ids.order();
    const order: OrderRecord = {
      id: orderId,
      householdId: scope.data.household.id,
      requesterId: scope.data.user.id,
      dishId: dish?.id ?? null,
      dishName: dish?.name ?? fallbackDishName(rawText),
      status: "requested",
      rawText: rawText.length === 0 ? null : rawText,
      note: noteParts.length === 0 ? null : noteParts.join(" · "),
      scheduledTime: parsed.data.scheduled_time ?? null,
      scheduledLabel: parsed.data.scheduled_label ?? null,
      clientRequestId: parsed.data.client_request_id,
      createdAt: now,
      updatedAt: now,
      completedAt: null,
    };

    await this.store.saveOrder(order);
    await this.store.appendOrderEvent({
      id: this.ids.event(),
      householdId: scope.data.household.id,
      orderId,
      actorId: scope.data.user.id,
      type: "order_submitted",
      status: "requested",
      reason: null,
      createdAt: now,
    });

    return ok({order_id: orderId});
  }

  async transitionOrderStatus(
    uid: string | null,
    data: unknown,
  ): Promise<CallableResult<TransitionOrderStatusOutput>> {
    const scope = await this.requireHousehold(uid);
    if (!scope.ok) {
      return scope;
    }

    const parsed = TransitionOrderStatusInputSchema.safeParse(data);
    if (!parsed.success) {
      return validationFailed(parsed.error);
    }

    const order = await this.store.getOrder(parsed.data.order_id);
    if (order === null || order.householdId !== scope.data.household.id) {
      return fail("not_found", "Order does not exist in this household.");
    }

    if (!canTransitionOrder(order.status, parsed.data.target_status)) {
      return fail("illegal_transition", "Order status transition is invalid.");
    }

    const now = this.timestamp();
    const updatedOrder: OrderRecord = {
      ...order,
      status: parsed.data.target_status,
      updatedAt: now,
      completedAt: isTerminalStatus(parsed.data.target_status)
        ? now
        : order.completedAt,
    };

    await this.store.saveOrder(updatedOrder);
    await this.store.appendOrderEvent({
      id: this.ids.event(),
      householdId: scope.data.household.id,
      orderId: order.id,
      actorId: scope.data.user.id,
      type: "status_changed",
      status: parsed.data.target_status,
      reason: parsed.data.reason ?? null,
      createdAt: now,
    });

    return ok({order_id: order.id, status: parsed.data.target_status});
  }

  private async requireHousehold(
    uid: string | null,
  ): Promise<CallableResult<HouseholdScope>> {
    if (uid === null) {
      return fail("unauthenticated", "Sign in before using this action.");
    }

    const user = await this.store.getUser(uid);
    if (user === null || user.householdId === null) {
      return fail("not_found", "Join or create a household first.");
    }

    const household = await this.store.getHousehold(user.householdId);
    if (household === null) {
      return fail("not_found", "Household no longer exists.");
    }

    return ok({user, household});
  }

  private timestamp(): string {
    return this.now().toISOString();
  }
}

function validationFailed(error: z.ZodError): CallableResult<never> {
  return fail(
    "validation_failed",
    error.issues[0]?.message ?? "Request validation failed.",
  );
}

function fallbackDishName(rawText: string): string {
  if (rawText.length === 0) {
    return "临时点菜";
  }
  return rawText.length > 12 ? rawText.substring(0, 12) : rawText;
}

function isTerminalStatus(status: OrderStatus): boolean {
  return status === "served" || status === "cancelled";
}
