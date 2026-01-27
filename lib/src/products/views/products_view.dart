import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_cart/src/products/models/product.dart';
import 'package:easy_cart/src/products/view_models/products_view_model.dart';
import 'package:easy_cart/src/products/views/product_details_view.dart';
import 'package:easy_cart/core/widgets/loading_column.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final TextEditingController searchBarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsViewModel>().loadProducts();
    });
  }

  @override
  void dispose() {
    searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductsViewModel>();

    return Scaffold(
      // Search Bar
      appBar: AppBar(
        title: TextField(
          controller: searchBarController,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: "Search products...",
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
          ),

          onSubmitted: (value) => vm.filterProducts(value),
        ),
      ),
      body: Consumer<ProductsViewModel>(
        builder: (context, vm, child) {
          if (vm.loading) {
            return LoadingColumn(message: 'Loading products');
          }

          if (vm.productError != null) {
            return Center(child: Text(vm.productError!.message));
          }

          if (vm.filteredProducts.isEmpty) {
            return const Center(child: Text('No products found!'));
          }
          return GridView.builder(
            padding: EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.63,
            ),
            itemCount: vm.filteredProducts.length,
            itemBuilder: (context, index) {
              final product = vm.filteredProducts[index];

              return _buildProductCard(context, product);
            },
          );
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsView(product: product),
          ),
        );
      },

      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Image.asset(product.images.first),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 2),

                  Text(
                    'RM${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  SizedBox(height: 2),

                  Text(
                    'Sales: ${product.sales.toString()}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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
