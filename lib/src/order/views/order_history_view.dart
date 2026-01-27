import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_cart/src/cart/models/cart_item.dart';
import 'package:easy_cart/src/order/models/order.dart';
import 'package:easy_cart/src/order/view_models/order_history_view_model.dart';
import 'package:easy_cart/core/widgets/loading_column.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderHistoryViewModel>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: Consumer<OrderHistoryViewModel>(
        builder: (context, vm, child) {
          if (vm.loading) {
            return LoadingColumn(message: 'Loading your orders');
          }

          if (vm.orderError != null) {
            return Center(child: Text(vm.orderError!.message));
          }

          if (vm.orders.isEmpty) {
            return const Center(child: Text('No orders found!'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: vm.orders.length,
            itemBuilder: (context, index) {
              final order = vm.orders[index];
              final items = order.items;

              return _buildOrderCard(order, items);
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(AppOrder order, List<CartItem> items) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.id!.substring(0, 8)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: colorScheme.onSurface,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      order.createdAt.toLocal().toString().split('.')[0],
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withAlpha(153),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const Divider(height: 24),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, itemIndex) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        items[itemIndex].imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            items[itemIndex].productName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Qty: ${items[itemIndex].quantity}',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurface.withAlpha(153),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      "RM ${(items[itemIndex].price * items[itemIndex].quantity).toStringAsFixed(2)}",
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                );
              },
            ),

            const Divider(),

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: colorScheme.onSurface,
                      ),
                    ),

                    Text(
                      'RM ${order.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorScheme.onSurface.withAlpha(26)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 20,
                    color: colorScheme.onSurface.withAlpha(153),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      order.shippingAddress,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withAlpha(153),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
