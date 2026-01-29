import 'package:easy_cart/core/themes/app_color.dart';
import 'package:easy_cart/src/favourite/view_models/favourite_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_cart/src/cart/models/cart_item.dart';
import 'package:easy_cart/src/cart/view_models/cart_view_model.dart';
import 'package:easy_cart/src/products/models/product.dart';
import 'package:easy_cart/core/widgets/quantity_selector.dart';

class ProductDetailsView extends StatefulWidget {
  final Product product;
  const ProductDetailsView({super.key, required this.product});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FavouriteViewModel>();
    final isFav = vm.isFavourite(productId: widget.product.id!);

    return Scaffold(
      // Action Buttons
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: IconButton(
              onPressed: () => vm.toggleFavourite(product: widget.product),
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : AppColor.primary,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),

      // Bottom Bar
      bottomNavigationBar: _buildAddToCartBar(context),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Images
              AspectRatio(
                aspectRatio: 1,
                child: PageView(
                  children: widget.product.images.map((image) {
                    return Image.asset(image, fit: BoxFit.contain);
                  }).toList(),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      widget.product.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),

                    // Product Price
                    Text(
                      "RM ${widget.product.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Sales & Rating Row
                    Row(
                      children: [
                        Text(
                          "${widget.product.sales} sold | ",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        Text(
                          "${widget.product.rating}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        const Icon(Icons.star, color: Colors.amber, size: 20),
                      ],
                    ),
                    const SizedBox(height: 24),

                    const Divider(),
                    const SizedBox(height: 16),

                    // Product Description
                    Text(
                      "Product Description",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      widget.product.description.isEmpty
                          ? "No description available."
                          : widget.product.description,
                      style: const TextStyle(height: 1.75),
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

  Widget _buildAddToCartBar(BuildContext context) {
    final vm = context.watch<CartViewModel>();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                vm.addToCart(
                  newItem: CartItem(
                    productId: widget.product.id!,
                    productName: widget.product.name,
                    imageUrl: widget.product.images.first,
                    price: widget.product.price,
                    quantity: quantity,
                  ),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product added to cart successfully!'),
                    duration: Duration(milliseconds: 500),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Add to Cart"),
            ),
          ),

          QuantitySelector(
            quantity: quantity,
            onIncrement: () => setState(() => quantity += 1),
            onDecrement: () => setState(() => quantity -= 1),
          ),
        ],
      ),
    );
  }
}
