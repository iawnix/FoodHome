import {Timestamp} from "firebase-admin/firestore";
import {describe, expect, it} from "vitest";
import {
  fromFirestoreOrderData,
  hashInviteCode,
  OrderRecord,
  orderRequestKey,
  toFirestoreOrderData,
} from "../src/index.js";

describe("FirestoreFoodHomeStore mapping", () => {
  it("maps order records to Firestore snake_case and back", () => {
    const order: OrderRecord = {
      id: "order_1",
      householdId: "household_1",
      requesterId: "u_owner",
      dishId: "dish_1",
      dishName: "番茄牛腩",
      status: "requested",
      rawText: "少油",
      note: "少油 · 19:00 前",
      scheduledTime: null,
      scheduledLabel: "今晚 19:00 前",
      clientRequestId: "request-001",
      createdAt: "2026-07-07T12:00:00.000Z",
      updatedAt: "2026-07-07T12:00:00.000Z",
      completedAt: null,
    };

    const data = toFirestoreOrderData(order);

    expect(data).toMatchObject({
      household_id: "household_1",
      requester_user_id: "u_owner",
      dish_id: "dish_1",
      dish_name: "番茄牛腩",
      status: "requested",
      raw_text: "少油",
      note: "少油 · 19:00 前",
      scheduled_time: null,
      scheduled_label: "今晚 19:00 前",
      client_request_id: "request-001",
      completed_at: null,
    });
    expect(data.created_at).toBeInstanceOf(Timestamp);
    expect(data.updated_at).toBeInstanceOf(Timestamp);
    expect(fromFirestoreOrderData(order.id, data)).toEqual(order);
  });

  it("hashes invite codes without retaining plaintext", () => {
    expect(hashInviteCode("425816")).toMatch(/^[a-f0-9]{64}$/);
    expect(hashInviteCode("425816")).not.toBe("425816");
    expect(hashInviteCode("425816")).toBe(hashInviteCode("425816"));
  });

  it("hashes order idempotency keys without retaining client ids", () => {
    const key = orderRequestKey("household_1", "request-001");
    expect(key).toMatch(/^[a-f0-9]{64}$/);
    expect(key).not.toContain("household_1");
    expect(key).not.toContain("request-001");
  });
});
