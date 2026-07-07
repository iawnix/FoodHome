import {createHash} from "node:crypto";
import {
  DocumentData,
  DocumentSnapshot,
  Firestore,
  Timestamp,
} from "firebase-admin/firestore";
import {
  DishRecord,
  FoodHomeStore,
  HouseholdRecord,
  OrderEventRecord,
  OrderEventType,
  OrderRecord,
  UserRecord,
} from "../domain/foodhome_service.js";
import {OrderStatus, orderStatuses} from "../domain/order_state_machine.js";
import {getDefaultFirestore} from "./admin.js";

const collections = {
  users: "users",
  households: "households",
  householdInvites: "household_invites",
  dishes: "dishes",
  orders: "orders",
  orderRequests: "order_requests",
  orderEvents: "order_events",
} as const;

export class FirestoreFoodHomeStore implements FoodHomeStore {
  private readonly db: Firestore;

  constructor(db: Firestore = getDefaultFirestore()) {
    this.db = db;
  }

  async getUser(uid: string): Promise<UserRecord | null> {
    return fromUserSnapshot(
      await this.db.collection(collections.users).doc(uid).get(),
    );
  }

  async saveUser(user: UserRecord): Promise<void> {
    await this.db
      .collection(collections.users)
      .doc(user.id)
      .set(toFirestoreUserData(user), {merge: true});
  }

  async createHousehold(
    household: HouseholdRecord,
    inviteCode: string,
  ): Promise<void> {
    const inviteHash = hashInviteCode(inviteCode);
    const batch = this.db.batch();
    batch.set(
      this.db.collection(collections.households).doc(household.id),
      {
        ...toFirestoreHouseholdData(household),
        invite_code_hash: inviteHash,
      },
    );
    batch.set(this.db.collection(collections.householdInvites).doc(inviteHash), {
      household_id: household.id,
      created_at: toTimestamp(household.createdAt),
    });
    await batch.commit();
  }

  async findHouseholdByInviteCode(
    inviteCode: string,
  ): Promise<HouseholdRecord | null> {
    const invite = await this.db
      .collection(collections.householdInvites)
      .doc(hashInviteCode(inviteCode))
      .get();
    if (!invite.exists) {
      return null;
    }
    const householdId = readString(invite.data(), "household_id");
    return this.getHousehold(householdId);
  }

  async getHousehold(
    householdId: string,
  ): Promise<HouseholdRecord | null> {
    return fromHouseholdSnapshot(
      await this.db.collection(collections.households).doc(householdId).get(),
    );
  }

  async saveHousehold(household: HouseholdRecord): Promise<void> {
    await this.db
      .collection(collections.households)
      .doc(household.id)
      .set(toFirestoreHouseholdData(household), {merge: true});
  }

  async getDish(
    householdId: string,
    dishId: string,
  ): Promise<DishRecord | null> {
    const dish = await this.db.collection(collections.dishes).doc(dishId).get();
    if (!dish.exists) {
      return null;
    }
    const record = fromFirestoreDishData(dish.id, requireData(dish));
    return record.householdId === householdId ? record : null;
  }

  async saveDish(dish: DishRecord): Promise<void> {
    await this.db
      .collection(collections.dishes)
      .doc(dish.id)
      .set(toFirestoreDishData(dish), {merge: true});
  }

  async findOrderByClientRequest(
    householdId: string,
    clientRequestId: string,
  ): Promise<OrderRecord | null> {
    const request = await this.db
      .collection(collections.orderRequests)
      .doc(orderRequestKey(householdId, clientRequestId))
      .get();
    if (!request.exists) {
      return null;
    }
    return this.getOrder(readString(request.data(), "order_id"));
  }

  async createOrder(
    order: OrderRecord,
    event: OrderEventRecord,
  ): Promise<OrderRecord> {
    return this.db.runTransaction(async (transaction) => {
      const requestRef = this.db
        .collection(collections.orderRequests)
        .doc(orderRequestKey(order.householdId, order.clientRequestId));
      const orderRef = this.db.collection(collections.orders).doc(order.id);
      const eventRef = this.db
        .collection(collections.orderEvents)
        .doc(event.id);

      const existingRequest = await transaction.get(requestRef);
      if (existingRequest.exists) {
        const existingOrderRef = this.db
          .collection(collections.orders)
          .doc(readString(existingRequest.data(), "order_id"));
        const existingOrder = await transaction.get(existingOrderRef);
        if (!existingOrder.exists) {
          throw new Error(
            `Order request ${requestRef.id} points to a missing order.`,
          );
        }
        return fromFirestoreOrderData(
          existingOrder.id,
          requireData(existingOrder),
        );
      }

      transaction.set(orderRef, toFirestoreOrderData(order));
      transaction.set(requestRef, {
        household_id: order.householdId,
        order_id: order.id,
        created_at: toTimestamp(order.createdAt),
      });
      transaction.set(eventRef, toFirestoreOrderEventData(event));
      return order;
    });
  }

  async getOrder(orderId: string): Promise<OrderRecord | null> {
    return fromOrderSnapshot(
      await this.db.collection(collections.orders).doc(orderId).get(),
    );
  }

  async saveOrder(order: OrderRecord): Promise<void> {
    await this.db
      .collection(collections.orders)
      .doc(order.id)
      .set(toFirestoreOrderData(order), {merge: true});
  }

  async appendOrderEvent(event: OrderEventRecord): Promise<void> {
    await this.db
      .collection(collections.orderEvents)
      .doc(event.id)
      .set(toFirestoreOrderEventData(event));
  }
}

export function hashInviteCode(inviteCode: string): string {
  return createHash("sha256").update(inviteCode, "utf8").digest("hex");
}

export function orderRequestKey(
  householdId: string,
  clientRequestId: string,
): string {
  return createHash("sha256")
    .update(`${householdId}\u0000${clientRequestId}`, "utf8")
    .digest("hex");
}

export function toFirestoreUserData(user: UserRecord): DocumentData {
  return {
    display_name: user.displayName,
    household_id: user.householdId,
    created_at: toTimestamp(user.createdAt),
    updated_at: toTimestamp(user.updatedAt),
  };
}

export function fromFirestoreUserData(
  id: string,
  data: DocumentData,
): UserRecord {
  return {
    id,
    displayName: readString(data, "display_name"),
    householdId: readNullableString(data, "household_id"),
    createdAt: readTimestamp(data, "created_at"),
    updatedAt: readTimestamp(data, "updated_at"),
  };
}

export function toFirestoreHouseholdData(
  household: HouseholdRecord,
): DocumentData {
  return {
    name: household.name,
    member_ids: household.memberIds,
    created_at: toTimestamp(household.createdAt),
    updated_at: toTimestamp(household.updatedAt),
  };
}

export function fromFirestoreHouseholdData(
  id: string,
  data: DocumentData,
): HouseholdRecord {
  return {
    id,
    name: readString(data, "name"),
    memberIds: readStringArray(data, "member_ids"),
    createdAt: readTimestamp(data, "created_at"),
    updatedAt: readTimestamp(data, "updated_at"),
  };
}

export function toFirestoreDishData(dish: DishRecord): DocumentData {
  return {
    household_id: dish.householdId,
    name: dish.name,
    category: dish.category,
    estimated_minutes: dish.estimatedMinutes,
    tags: dish.tags,
    created_at: toTimestamp(dish.createdAt),
    updated_at: toTimestamp(dish.updatedAt),
  };
}

export function fromFirestoreDishData(
  id: string,
  data: DocumentData,
): DishRecord {
  return {
    id,
    householdId: readString(data, "household_id"),
    name: readString(data, "name"),
    category: readString(data, "category"),
    estimatedMinutes: readNumber(data, "estimated_minutes"),
    tags: readStringArray(data, "tags"),
    createdAt: readTimestamp(data, "created_at"),
    updatedAt: readTimestamp(data, "updated_at"),
  };
}

export function toFirestoreOrderData(order: OrderRecord): DocumentData {
  return {
    household_id: order.householdId,
    requester_user_id: order.requesterId,
    dish_id: order.dishId,
    dish_name: order.dishName,
    status: order.status,
    raw_text: order.rawText,
    note: order.note,
    scheduled_time: order.scheduledTime,
    scheduled_label: order.scheduledLabel,
    client_request_id: order.clientRequestId,
    created_at: toTimestamp(order.createdAt),
    updated_at: toTimestamp(order.updatedAt),
    completed_at:
      order.completedAt === null ? null : toTimestamp(order.completedAt),
  };
}

export function fromFirestoreOrderData(
  id: string,
  data: DocumentData,
): OrderRecord {
  return {
    id,
    householdId: readString(data, "household_id"),
    requesterId: readString(data, "requester_user_id"),
    dishId: readNullableString(data, "dish_id"),
    dishName: readString(data, "dish_name"),
    status: readOrderStatus(data, "status"),
    rawText: readNullableString(data, "raw_text"),
    note: readNullableString(data, "note"),
    scheduledTime: readNullableString(data, "scheduled_time"),
    scheduledLabel: readNullableString(data, "scheduled_label"),
    clientRequestId: readString(data, "client_request_id"),
    createdAt: readTimestamp(data, "created_at"),
    updatedAt: readTimestamp(data, "updated_at"),
    completedAt: readNullableTimestamp(data, "completed_at"),
  };
}

export function toFirestoreOrderEventData(
  event: OrderEventRecord,
): DocumentData {
  return {
    household_id: event.householdId,
    order_id: event.orderId,
    actor_user_id: event.actorId,
    event_type: event.type,
    status: event.status,
    reason: event.reason,
    created_at: toTimestamp(event.createdAt),
  };
}

export function fromFirestoreOrderEventData(
  id: string,
  data: DocumentData,
): OrderEventRecord {
  return {
    id,
    householdId: readString(data, "household_id"),
    orderId: readString(data, "order_id"),
    actorId: readString(data, "actor_user_id"),
    type: readOrderEventType(data, "event_type"),
    status: readNullableOrderStatus(data, "status"),
    reason: readNullableString(data, "reason"),
    createdAt: readTimestamp(data, "created_at"),
  };
}

function fromUserSnapshot(
  snapshot: DocumentSnapshot,
): UserRecord | null {
  return snapshot.exists
    ? fromFirestoreUserData(snapshot.id, requireData(snapshot))
    : null;
}

function fromHouseholdSnapshot(
  snapshot: DocumentSnapshot,
): HouseholdRecord | null {
  return snapshot.exists
    ? fromFirestoreHouseholdData(snapshot.id, requireData(snapshot))
    : null;
}

function fromOrderSnapshot(
  snapshot: DocumentSnapshot,
): OrderRecord | null {
  return snapshot.exists
    ? fromFirestoreOrderData(snapshot.id, requireData(snapshot))
    : null;
}

function requireData(snapshot: DocumentSnapshot): DocumentData {
  const data = snapshot.data();
  if (data === undefined) {
    throw new Error(`Firestore document ${snapshot.ref.path} has no data.`);
  }
  return data;
}

function toTimestamp(value: string): Timestamp {
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) {
    throw new Error(`Invalid ISO timestamp: ${value}`);
  }
  return Timestamp.fromDate(date);
}

function readString(data: DocumentData | undefined, field: string): string {
  const value = readRequired(data, field);
  if (typeof value !== "string") {
    throw new Error(`Expected ${field} to be a string.`);
  }
  return value;
}

function readNullableString(
  data: DocumentData | undefined,
  field: string,
): string | null {
  const value = readRequired(data, field);
  if (value === null) {
    return null;
  }
  if (typeof value !== "string") {
    throw new Error(`Expected ${field} to be a string or null.`);
  }
  return value;
}

function readStringArray(
  data: DocumentData | undefined,
  field: string,
): string[] {
  const value = readRequired(data, field);
  if (
    !Array.isArray(value) ||
    value.some((item) => typeof item !== "string")
  ) {
    throw new Error(`Expected ${field} to be a string array.`);
  }
  return value;
}

function readNumber(data: DocumentData | undefined, field: string): number {
  const value = readRequired(data, field);
  if (typeof value !== "number") {
    throw new Error(`Expected ${field} to be a number.`);
  }
  return value;
}

function readTimestamp(data: DocumentData | undefined, field: string): string {
  const value = readRequired(data, field);
  if (value instanceof Timestamp) {
    return value.toDate().toISOString();
  }
  if (typeof value === "string") {
    return value;
  }
  throw new Error(`Expected ${field} to be a Firestore timestamp.`);
}

function readNullableTimestamp(
  data: DocumentData | undefined,
  field: string,
): string | null {
  const value = readRequired(data, field);
  if (value === null) {
    return null;
  }
  if (value instanceof Timestamp) {
    return value.toDate().toISOString();
  }
  if (typeof value === "string") {
    return value;
  }
  throw new Error(`Expected ${field} to be a Firestore timestamp or null.`);
}

function readOrderStatus(
  data: DocumentData | undefined,
  field: string,
): OrderStatus {
  const value = readString(data, field);
  if (!orderStatuses.includes(value as OrderStatus)) {
    throw new Error(`Unknown order status: ${value}`);
  }
  return value as OrderStatus;
}

function readNullableOrderStatus(
  data: DocumentData | undefined,
  field: string,
): OrderStatus | null {
  const value = readNullableString(data, field);
  if (value === null) {
    return null;
  }
  if (!orderStatuses.includes(value as OrderStatus)) {
    throw new Error(`Unknown order status: ${value}`);
  }
  return value as OrderStatus;
}

function readOrderEventType(
  data: DocumentData | undefined,
  field: string,
): OrderEventType {
  const value = readString(data, field);
  if (value !== "order_submitted" && value !== "status_changed") {
    throw new Error(`Unknown order event type: ${value}`);
  }
  return value;
}

function readRequired(
  data: DocumentData | undefined,
  field: string,
): unknown {
  if (data === undefined || !(field in data)) {
    throw new Error(`Missing required Firestore field: ${field}`);
  }
  return data[field];
}
