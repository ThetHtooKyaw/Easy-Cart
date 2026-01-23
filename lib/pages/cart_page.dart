import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:workshop_shopping_app/data/cart_items.dart';
import 'package:workshop_shopping_app/models/item.dart';
import 'package:workshop_shopping_app/services/order_service.dart';
import 'package:workshop_shopping_app/widgets/quantity_selector.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void _incrementQuantity(int index) {
    setState(() {
      final item = cartItems[index];
      cartItems[index] = Item(
        productId: item.productId,
        productName: item.productName,
        imageUrl: item.imageUrl,
        price: item.price,
        quantity: item.quantity + 1,
      );
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      final item = cartItems[index];
      cartItems[index] = Item(
        productId: item.productId,
        productName: item.productName,
        imageUrl: item.imageUrl,
        price: item.price,
        quantity: item.quantity - 1,
      );
    });
  }

  void _deleteItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  Future<void> _checkout() async {
    final orderID = await OrderService().createOrderFromCart(cartItems);

    cartItems.clear();

    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Checkout Successful'),
          content: Text(
            'Order placed successfully! Order ID: ${orderID.substring(0, 8)}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shopping Cart")),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return _buildCartItemCard(context, index);
              },
            ),
          ),
          _buildCheckoutBar(context),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(BuildContext context, int index) {
    final cartItem = cartItems[index];
    final quantity = cartItem.quantity;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

      child: Slidable(
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.35,
          children: [
            SlidableAction(
              onPressed: (context) => _deleteItem(index),
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
                          onIncrement: () => _incrementQuantity(index),
                          onDecrement: () => _decrementQuantity(index),
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

  Widget _buildCheckoutBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total: RM ${OrderService().calculateTotal(cartItems).toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          ElevatedButton(
            onPressed: cartItems.isEmpty ? null : _checkout,
            child: const Text("Checkout"),
          ),
        ],
      ),
    );
  }
}
