import {describe, expect, it} from "vitest";
import {canTransitionOrder, nextOrderStatuses} from "../src/index.js";

describe("order state machine", () => {
  it("allows the V0.1 happy path", () => {
    expect(canTransitionOrder("requested", "accepted")).toBe(true);
    expect(canTransitionOrder("accepted", "cooking")).toBe(true);
    expect(canTransitionOrder("cooking", "served")).toBe(true);
  });

  it("blocks terminal transitions", () => {
    expect(canTransitionOrder("served", "cancelled")).toBe(false);
    expect(nextOrderStatuses("cancelled")).toEqual([]);
  });
});
