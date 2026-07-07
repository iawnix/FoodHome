import type {AiPurpose} from "./schemas.js";

const blockedKeys = new Set([
  "uid",
  "user_id",
  "phone",
  "avatar_url",
  "household_name",
  "member_ids",
]);

export function sanitizeForAi(
  payload: Record<string, unknown>,
  purpose: AiPurpose,
): Record<string, unknown> {
  const sanitized: Record<string, unknown> = {purpose};

  for (const [key, value] of Object.entries(payload)) {
    if (blockedKeys.has(key)) {
      continue;
    }
    if (typeof value === "string") {
      sanitized[key] = value.slice(0, 500);
      continue;
    }
    if (Array.isArray(value)) {
      sanitized[key] = value.slice(0, 30);
      continue;
    }
    sanitized[key] = value;
  }

  return sanitized;
}
