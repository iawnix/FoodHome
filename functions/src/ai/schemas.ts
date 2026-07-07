import {z} from "zod";

export const AiPurposeSchema = z.enum(["parse_order", "recommend_dishes"]);
export type AiPurpose = z.infer<typeof AiPurposeSchema>;

export const ParseOrderInputSchema = z.object({
  raw_text: z.string().min(1).max(500),
  timezone: z.string().default("Asia/Shanghai"),
});

export const ParseOrderOutputSchema = z.object({
  dish_candidates: z
    .array(
      z.object({
        name: z.string().min(1),
        confidence: z.number().min(0).max(1),
      }),
    )
    .max(5),
  taste_notes: z.array(z.string()).max(8),
  excluded_ingredients: z.array(z.string()).max(8),
  expected_time_local: z.string().nullable(),
  needs_confirmation: z.array(z.string()).max(8),
});

export const RecommendDishesInputSchema = z.object({
  mood: z.string().min(1).max(300),
  minutes_budget: z.number().int().min(5).max(180),
  dish_pool: z
    .array(
      z.object({
        name: z.string().min(1),
        tags: z.array(z.string()).max(8),
      }),
    )
    .max(30),
});

export const RecommendDishesOutputSchema = z.object({
  candidates: z
    .array(
      z.object({
        dish_name: z.string().min(1),
        reason: z.string().min(1).max(120),
        estimated_minutes: z.number().int().min(5).max(180),
        difficulty: z.enum(["easy", "medium", "hard"]),
      }),
    )
    .min(1)
    .max(5),
});
