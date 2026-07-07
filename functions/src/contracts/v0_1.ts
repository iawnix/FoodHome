import {z} from "zod";
import {orderStatuses} from "../domain/order_state_machine.js";

const idSchema = z.string().min(1).max(80);
const trimmedShortText = z.string().trim().min(1).max(80);

export const InviteCodeSchema = z.string().regex(/^\d{6}$/);

export const CallableErrorCodeSchema = z.enum([
  "already_in_household",
  "household_full",
  "illegal_transition",
  "invite_not_found",
  "not_found",
  "unauthenticated",
  "validation_failed",
]);

export type CallableErrorCode = z.infer<typeof CallableErrorCodeSchema>;

export type CallableResult<T> =
  | {ok: true; data: T}
  | {ok: false; error: {code: CallableErrorCode; message: string}};

export function ok<T>(data: T): CallableResult<T> {
  return {ok: true, data};
}

export function fail<T = never>(
  code: CallableErrorCode,
  message: string,
): CallableResult<T> {
  return {ok: false, error: {code, message}};
}

export const CreateHouseholdInputSchema = z.object({
  name: trimmedShortText,
  display_name: trimmedShortText.optional(),
});

export const CreateHouseholdOutputSchema = z.object({
  household_id: idSchema,
  invite_code: InviteCodeSchema,
});

export const JoinHouseholdInputSchema = z.object({
  invite_code: InviteCodeSchema,
  display_name: trimmedShortText.optional(),
});

export const JoinHouseholdOutputSchema = z.object({
  household_id: idSchema,
});

export const UpsertDishInputSchema = z.object({
  dish_id: idSchema.optional(),
  name: trimmedShortText,
  category: z.string().trim().min(1).max(40).default("home"),
  estimated_minutes: z.number().int().min(5).max(180),
  tags: z.array(z.string().trim().min(1).max(30)).max(8).default([]),
});

export const UpsertDishOutputSchema = z.object({
  dish_id: idSchema,
});

export const SubmitOrderInputSchema = z
  .object({
    client_request_id: z.string().trim().min(8).max(100),
    dish_id: idSchema.optional(),
    raw_text: z.string().trim().max(500).optional(),
    scheduled_time: z.string().trim().min(1).max(80).optional(),
    scheduled_label: z.string().trim().min(1).max(40).optional(),
    taste_notes: z
      .array(z.string().trim().min(1).max(30))
      .max(8)
      .default([]),
  })
  .refine(
    (value) =>
      value.dish_id !== undefined ||
      (value.raw_text !== undefined && value.raw_text.length > 0),
    {
      message: "dish_id or raw_text is required",
      path: ["dish_id"],
    },
  );

export const SubmitOrderOutputSchema = z.object({
  order_id: idSchema,
});

export const TransitionOrderStatusInputSchema = z.object({
  order_id: idSchema,
  target_status: z.enum(orderStatuses),
  reason: z.string().trim().max(200).optional(),
});

export const TransitionOrderStatusOutputSchema = z.object({
  order_id: idSchema,
  status: z.enum(orderStatuses),
});

export type CreateHouseholdInput = z.infer<typeof CreateHouseholdInputSchema>;
export type CreateHouseholdOutput = z.infer<typeof CreateHouseholdOutputSchema>;
export type JoinHouseholdInput = z.infer<typeof JoinHouseholdInputSchema>;
export type JoinHouseholdOutput = z.infer<typeof JoinHouseholdOutputSchema>;
export type UpsertDishInput = z.infer<typeof UpsertDishInputSchema>;
export type UpsertDishOutput = z.infer<typeof UpsertDishOutputSchema>;
export type SubmitOrderInput = z.infer<typeof SubmitOrderInputSchema>;
export type SubmitOrderOutput = z.infer<typeof SubmitOrderOutputSchema>;
export type TransitionOrderStatusInput = z.infer<
  typeof TransitionOrderStatusInputSchema
>;
export type TransitionOrderStatusOutput = z.infer<
  typeof TransitionOrderStatusOutputSchema
>;
