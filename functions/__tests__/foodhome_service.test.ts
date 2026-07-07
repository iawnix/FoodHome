import {describe, expect, it} from "vitest";
import {
  DishRecord,
  FoodHomeIdGenerator,
  FoodHomeService,
  FoodHomeStore,
  HouseholdRecord,
  OrderEventRecord,
  OrderRecord,
  UserRecord,
} from "../src/index.js";

class InMemoryFoodHomeStore implements FoodHomeStore {
  private readonly users = new Map<string, UserRecord>();
  private readonly households = new Map<string, HouseholdRecord>();
  private readonly inviteIndex = new Map<string, string>();
  private readonly dishes = new Map<string, DishRecord>();
  private readonly orders = new Map<string, OrderRecord>();
  private readonly events: OrderEventRecord[] = [];

  get orderCount(): number {
    return this.orders.size;
  }

  get eventCount(): number {
    return this.events.length;
  }

  async getUser(uid: string): Promise<UserRecord | null> {
    return this.users.get(uid) ?? null;
  }

  async saveUser(user: UserRecord): Promise<void> {
    this.users.set(user.id, user);
  }

  async createHousehold(
    household: HouseholdRecord,
    inviteCode: string,
  ): Promise<void> {
    this.households.set(household.id, household);
    this.inviteIndex.set(inviteCode, household.id);
  }

  async findHouseholdByInviteCode(
    inviteCode: string,
  ): Promise<HouseholdRecord | null> {
    const householdId = this.inviteIndex.get(inviteCode);
    if (householdId === undefined) {
      return null;
    }
    return this.households.get(householdId) ?? null;
  }

  async getHousehold(
    householdId: string,
  ): Promise<HouseholdRecord | null> {
    return this.households.get(householdId) ?? null;
  }

  async saveHousehold(household: HouseholdRecord): Promise<void> {
    this.households.set(household.id, household);
  }

  async getDish(
    householdId: string,
    dishId: string,
  ): Promise<DishRecord | null> {
    const dish = this.dishes.get(dishId);
    if (dish === undefined || dish.householdId !== householdId) {
      return null;
    }
    return dish;
  }

  async saveDish(dish: DishRecord): Promise<void> {
    this.dishes.set(dish.id, dish);
  }

  async findOrderByClientRequest(
    householdId: string,
    clientRequestId: string,
  ): Promise<OrderRecord | null> {
    for (const order of this.orders.values()) {
      if (
        order.householdId === householdId &&
        order.clientRequestId === clientRequestId
      ) {
        return order;
      }
    }
    return null;
  }

  async createOrder(
    order: OrderRecord,
    event: OrderEventRecord,
  ): Promise<OrderRecord> {
    const existingOrder = await this.findOrderByClientRequest(
      order.householdId,
      order.clientRequestId,
    );
    if (existingOrder !== null) {
      return existingOrder;
    }
    await this.saveOrder(order);
    await this.appendOrderEvent(event);
    return order;
  }

  async getOrder(orderId: string): Promise<OrderRecord | null> {
    return this.orders.get(orderId) ?? null;
  }

  async saveOrder(order: OrderRecord): Promise<void> {
    this.orders.set(order.id, order);
  }

  async appendOrderEvent(event: OrderEventRecord): Promise<void> {
    this.events.push(event);
  }
}

describe("FoodHomeService", () => {
  it("creates a household and joins another user by invite code", async () => {
    const {service, store} = createService();

    const created = await service.createHousehold("u_owner", {
      name: "我们家",
      display_name: "阿哲",
    });
    expect(created).toEqual({
      ok: true,
      data: {household_id: "household_1", invite_code: "425816"},
    });

    const joined = await service.joinHousehold("u_guest", {
      invite_code: "425816",
      display_name: "小雨",
    });
    expect(joined).toEqual({
      ok: true,
      data: {household_id: "household_1"},
    });

    const household = await store.getHousehold("household_1");
    expect(household?.memberIds).toEqual(["u_owner", "u_guest"]);
  });

  it("upserts a dish and deduplicates submitOrder by client request id", async () => {
    const {service, store} = createService();
    await service.createHousehold("u_owner", {name: "我们家"});

    const dish = await service.upsertDish("u_owner", {
      name: "番茄牛腩",
      category: "home",
      estimated_minutes: 60,
      tags: ["周末"],
    });
    expect(dish).toEqual({ok: true, data: {dish_id: "dish_1"}});

    const firstOrder = await service.submitOrder("u_owner", {
      client_request_id: "request-001",
      dish_id: "dish_1",
      taste_notes: ["少油"],
      scheduled_label: "今晚 19:00 前",
    });
    const duplicateOrder = await service.submitOrder("u_owner", {
      client_request_id: "request-001",
      dish_id: "dish_1",
    });

    expect(firstOrder).toEqual({ok: true, data: {order_id: "order_1"}});
    expect(duplicateOrder).toEqual(firstOrder);
    expect(store.orderCount).toBe(1);
    expect(store.eventCount).toBe(1);
  });

  it("rejects illegal order status transitions", async () => {
    const {service, store} = createService();
    await service.createHousehold("u_owner", {name: "我们家"});
    const order = await service.submitOrder("u_owner", {
      client_request_id: "request-002",
      raw_text: "想吃番茄鸡蛋",
    });
    expect(order).toEqual({ok: true, data: {order_id: "order_1"}});

    const rejected = await service.transitionOrderStatus("u_owner", {
      order_id: "order_1",
      target_status: "served",
    });
    expect(rejected).toEqual({
      ok: false,
      error: {
        code: "illegal_transition",
        message: "Order status transition is invalid.",
      },
    });

    const accepted = await service.transitionOrderStatus("u_owner", {
      order_id: "order_1",
      target_status: "accepted",
    });
    expect(accepted).toEqual({
      ok: true,
      data: {order_id: "order_1", status: "accepted"},
    });
    expect((await store.getOrder("order_1"))?.status).toBe("accepted");
  });
});

function createService(): {
  service: FoodHomeService;
  store: InMemoryFoodHomeStore;
} {
  const store = new InMemoryFoodHomeStore();
  const counters = {
    household: 0,
    dish: 0,
    order: 0,
    event: 0,
  };
  const ids: FoodHomeIdGenerator = {
    household: () => nextId(counters, "household"),
    dish: () => nextId(counters, "dish"),
    order: () => nextId(counters, "order"),
    event: () => nextId(counters, "event"),
  };
  return {
    store,
    service: new FoodHomeService({
      store,
      ids,
      inviteCode: () => "425816",
      now: () => new Date("2026-07-07T12:00:00.000Z"),
    }),
  };
}

function nextId(
  counters: Record<keyof FoodHomeIdGenerator, number>,
  prefix: keyof FoodHomeIdGenerator,
): string {
  counters[prefix] += 1;
  return `${prefix}_${counters[prefix]}`;
}
