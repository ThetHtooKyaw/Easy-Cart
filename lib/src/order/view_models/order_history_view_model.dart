import 'package:flutter/foundation.dart';
import 'package:easy_cart/core/status/failure.dart';
import 'package:easy_cart/core/status/success.dart';
import 'package:easy_cart/src/auth/models/app_user.dart';
import 'package:easy_cart/src/auth/repo/auth_service.dart';
import 'package:easy_cart/src/order/repo/order_service.dart';
import 'package:easy_cart/src/cart/models/cart_item.dart';
import 'package:easy_cart/src/order/models/order.dart';
import 'package:easy_cart/src/order/models/order_error.dart';

class OrderHistoryViewModel extends ChangeNotifier {
  // Dependencies
  final OrderService _orderService;
  final AuthService _authService;
  OrderHistoryViewModel(this._orderService, this._authService);

  // Variables
  List<AppOrder> _orders = [];
  bool _loading = false;
  OrderError? _orderError;

  // Getters
  List<AppOrder> get orders => _orders;
  bool get loading => _loading;
  OrderError? get orderError => _orderError;

  // Setters
  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  setOrderError(OrderError orderError) {
    _orderError = orderError;
    notifyListeners();
  }

  void clearOrderError() {
    _orderError = null;
    notifyListeners();
  }

  // Use Cases
  Future<void> loadOrders() async {
    setLoading(true);
    clearOrderError();

    final response = await _orderService.loadOrders();

    if (response is Success) {
      _orders = response.response as List<AppOrder>;
    } else if (response is Failure) {
      setOrderError(OrderError(message: response.response.toString()));
    }

    setLoading(false);
  }

  double calculateTotal(List<CartItem> cartItems) {
    double subtotal = 0.0;
    for (var item in cartItems) {
      subtotal += item.price * item.quantity;
    }
    return double.parse(subtotal.toStringAsFixed(2));
  }

  Future<Object> checkOut({required List<CartItem> cartItems}) async {
    setLoading(true);
    clearOrderError();

    final authResponse = await _authService.getUser();

    if (authResponse is! Success) {
      setLoading(false);
      return Failure(response: 'Failed to fetch user');
    }

    final user = authResponse.response as AppUser;
    final totalAmount = calculateTotal(cartItems);
    final orderResponse = await _orderService.checkOut(
      cartItems: cartItems,
      totalAmount: totalAmount,
      user: user,
    );

    if (orderResponse is Success) {
      await loadOrders();
    } else if (orderResponse is Failure) {
      setOrderError(OrderError(message: orderResponse.response.toString()));
    }

    setLoading(false);
    return orderResponse;
  }
}
