enum OrderStatus {
  requested,
  accepted,
  cooking,
  blocked,
  served,
  cancelled,
}

extension OrderStatusText on OrderStatus {
  String get label {
    return switch (this) {
      OrderStatus.requested => '已点菜',
      OrderStatus.accepted => '主厨已接单',
      OrderStatus.cooking => '开始做了',
      OrderStatus.blocked => '缺食材',
      OrderStatus.served => '可以开饭',
      OrderStatus.cancelled => '已取消',
    };
  }

  bool get isTerminal {
    return this == OrderStatus.served || this == OrderStatus.cancelled;
  }
}
