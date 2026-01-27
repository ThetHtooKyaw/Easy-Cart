import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:easy_cart/core/status/failure.dart';
import 'package:easy_cart/core/status/success.dart';
import 'package:easy_cart/src/cart/view_models/cart_view_model.dart';
import 'package:easy_cart/src/order/view_models/order_history_view_model.dart';
import 'package:easy_cart/core/widgets/loading_column.dart';
import 'package:easy_cart/core/widgets/quantity_selector.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  Future<void> _handleCheckout(
    CartViewModel cartVM,
    OrderHistoryViewModel orderVM,
  ) async {
    showLoadingDialog(context, 'Processing your checkout');

    final result = await orderVM.checkOut(cartItems: cartVM.cartItems);

    if (!mounted) return;
    hideLoadingDialog(context);

    if (result is Success) {
      cartVM.clearCart();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Checkout Successful'),
          content: const Text('Order placed successfully!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else if (result is Failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.response.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartVM = context.watch<CartViewModel>();
    final orderVM = context.read<OrderHistoryViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Shopping Cart")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartVM.cartItems.length,
              itemBuilder: (context, index) {
                return _buildCartItemCard(context, index, cartVM);
              },
            ),
          ),

          // Checkout Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: RM ${orderVM.calculateTotal(cartVM.cartItems)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: cartVM.cartItems.isEmpty
                      ? null
                      : () => _handleCheckout(cartVM, orderVM),
                  child: const Text("Checkout"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(BuildContext context, int index, CartViewModel vm) {
    final cartItem = vm.cartItems[index];
    final quantity = cartItem.quantity;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Slidable(
        // Slidable Action Button
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.35,
          children: [
            SlidableAction(
              onPressed: (context) => vm.removeFromCart(productIndex: index),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              flex: 2,
            ),
          ],
        ),

        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  cartItem.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),

              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.productName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "RM ${cartItem.price.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        QuantitySelector(
                          quantity: quantity,
                          onIncrement: () => vm.updateQuantity(
                            productIndex: index,
                            newQuantity: quantity + 1,
                          ),
                          onDecrement: () => vm.updateQuantity(
                            productIndex: index,
                            newQuantity: quantity - 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
