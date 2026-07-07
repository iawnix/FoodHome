export const orderStatuses = [
  "requested",
  "accepted",
  "cooking",
  "blocked",
  "served",
  "cancelled",
] as const;

export type OrderStatus = (typeof orderStatuses)[number];

const nextStatusMap = {
  requested: ["accepted", "cancelled"],
  accepted: ["cooking", "blocked", "cancelled"],
  cooking: ["blocked", "served"],
  blocked: ["accepted", "cooking", "cancelled"],
  served: [],
  cancelled: [],
} satisfies Record<OrderStatus, readonly OrderStatus[]>;

export function nextOrderStatuses(status: OrderStatus): readonly OrderStatus[] {
  return nextStatusMap[status];
}

export function canTransitionOrder(
  from: OrderStatus,
  to: OrderStatus,
): boolean {
  const nextStatuses = nextStatusMap[from] as readonly OrderStatus[];
  return nextStatuses.includes(to);
}
