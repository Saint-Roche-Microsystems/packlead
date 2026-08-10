class OrdersByDispatcherParams {
  final String dispatcherId;
  final DateTime forDate;

  const OrdersByDispatcherParams({
    required this.dispatcherId,
    required this.forDate,
  });

  // Implement equality and hashCode for proper comparison in providers
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrdersByDispatcherParams &&
          runtimeType == other.runtimeType &&
          dispatcherId == other.dispatcherId &&
          forDate == other.forDate;

  @override
  int get hashCode => dispatcherId.hashCode ^ forDate.hashCode;
}
