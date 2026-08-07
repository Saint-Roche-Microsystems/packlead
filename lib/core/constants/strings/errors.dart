class OrdersApiErrors {
  OrdersApiErrors._();

  static const getOrders = 'Error al obtener pedidos';
  static const getOrder = 'Error al obtener pedido';
  static const createOrder = 'Error al crear pedido';
  static const updateOrder = 'Error al actualizar pedido';
  static const deleteOrder = 'Error al eliminar pedido';

  static const orderIdRequired = 'ID de pedido es requerido';
  static const payloadRequired = 'Payload no puede estar vacío';

  static const invalidOrderListResponse = 'Formato de respuesta inválido para lista de pedidos';
  static const invalidOrderResponse = 'Formato de respuesta inválido para pedido';
}

class DispatchersApiErrors {
  DispatchersApiErrors._();

  static const getDispatchers = 'Error al obtener repartidores';
  static const getDispatcher = 'Error al obtener repartidor';
  static const createDispatcher = 'Error al crear repartidor';
  static const updateDispatcher = 'Error al actualizar repartidor';
  static const deleteDispatcher = 'Error al eliminar repartidor';

  static const dispatcherIdRequired = 'ID de repartidor es requerido';

  static const invalidDispatcherListResponse = 'Formato de respuesta inválido para lista de repartidores';
  static const invalidDispatcherResponse = 'Formato de respuesta inválido para repartidor';
  static const invalidCreateDispatcherResponse = 'Formato de respuesta inválido al crear repartidor';
}
