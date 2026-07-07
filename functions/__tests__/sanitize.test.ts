import {describe, expect, it} from "vitest";
import {sanitizeForAi} from "../src/index.js";

describe("sanitizeForAi", () => {
  it("drops identity and household-only fields", () => {
    const sanitized = sanitizeForAi(
      {
        raw_text: "想吃番茄牛腩",
        uid: "u_123",
        phone: "18800000000",
        household_name: "我们家",
        dish_pool: ["番茄鸡蛋"],
      },
      "parse_order",
    );

    expect(sanitized).toEqual({
      purpose: "parse_order",
      raw_text: "想吃番茄牛腩",
      dish_pool: ["番茄鸡蛋"],
    });
  });
});
