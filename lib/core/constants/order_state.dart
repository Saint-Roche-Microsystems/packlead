enum OrderState {
  pending,
  shipped,
  delivered,
}

extension OrderStateExtension on OrderState {
  String toJson() => name;

  static OrderState fromJson(String value) {
    return OrderState.values.firstWhere(
      (e) => e.name == value,
      orElse: () => OrderState.pending,
    );
  }
}